-- Variables
local Elim = PB.Gamemodes:CreateGamemode("elim", "Elimination")
Elim.Functions.SetMapPool({"villa"})
local StartCycle, StartLobby, StartGame, StartRound, SetNewTeam, Winner, EndRound, TPLobby, HandleRespawn, HandleDeath, HandleJoin, HandleLeave

-- Start core game cycle
function StartCycle(session)
    -- Set the session to an initial states
    session.gameData.live = true
    session.gameData.state = "LOBBY"
    session.gameData.logic = {
        timer = 0,
        round = 0,
        score = {[1] = 0, [2] = 0},
        players = {}
    }
    StartLobby(session)
end

-- Start the lobby up
function StartLobby(session)
    session.gameData.state = "LOBBY"
    CreateThread(function()
        while session.gameData.state == "LOBBY" do
            Wait(1000)
            local rdyCount = 0
            for k, v in pairs(session.gameData.logic.players) do
                if v then
                    rdyCount = rdyCount + 1
                end
            end
            if rdyCount >= 2 then
                session.gameData.state = "STARTING"
                Wait(3000)
                -- Map voting
                local voteMaps = {}
                if session.mapPool then
                    for v in pairs(session.mapPool) do
                        voteMaps[v] = {
                            name = Locale["map_" .. session.mapPool[v] .. "_name"],
                            img = session.mapPool[v] .. ".png",
                            Function = function()
                                session.Functions.SetMap(session.mapPool[v])
                            end
                        }
                    end
                else
                    for v in pairs(Elim.mapPool) do
                        voteMaps[v] = {
                            name = Locale["map_" .. Elim.mapPool[v] .. "_name"],
                            img = Elim.mapPool[v] .. ".png",
                            Function = function()
                                session.Functions.SetMap(Elim.mapPool[v])
                            end
                        }
                    end
                end
                exports["pvp-voting"]:CreateVote(session.bucket, "VOTE FOR MAP", 20, voteMaps)
                
                local readyCountdown = Config.Elim.LobbyStart
                while readyCountdown > 0 do
                    Wait(1000)
                    readyCountdown = readyCountdown - 1
                    for k, v in pairs(session.gameData.logic.players) do
                        if v then
                            TriggerClientEvent("pb-hud:SetStats", k, {[1] = {string = "Game starting", value = readyCountdown}})
                        end
                    end
                end
                StartGame(session)
            end
        end
    end)
end

--Run server-side game cycle when game starts
function StartGame(session)
    -- Set default gamedata logic
    session.gameData.logic.round = 0
    session.gameData.logic.score = {[1] = 0, [2] = 0}
    -- Push all players in lobby to live game
    for k, v in pairs(session.players) do
        if v then
            session.gameData.logic.players[k] = {
                kills = 0,
                deaths = 0,
                team = nil,
                alive = false,
            }
            SetNewTeam(session, k)
        end
    end
    StartRound(session)
end

-- Set players team, automatically
function SetNewTeam(session, src)
    if not session.gameData.logic.players[src] then return false end
    local team1Count = 0
    local team2Count = 0
    for k, v in pairs(session.gameData.logic.players) do
        if v then
            if v.team then
                if v.team == 1 then
                    team1Count = team1Count + 1
                elseif v.team == 2 then
                    team2Count = team2Count + 1
                end
            end
        end
    end
    if team1Count > team2Count then
        session.gameData.logic.players[src].team = 2
    else
        session.gameData.logic.players[src].team = 1
    end
end

-- Run server-side game cycle when new round starts
function StartRound(session)

    session.gameData.state = "INROUND"
    session.gameData.logic.round = session.gameData.logic.round + 1
    session.gameData.logic.timer = Config.Elim.RoundTime
    session.gameData.logic.zoneEndPoint = Config.Maps[session.map].objectives["elim_zones"][#Config.Maps[session.map].objectives["elim_zones"]]
    session.gameData.logic.zoneSize = Config.Elim.ZoneStartSize

    for k, v in pairs(session.gameData.logic.players) do
        if v then
            local plyPed = GetPlayerPed(k)
            local selectedSpawn = Config.Maps[session.map].spawns[v.team][math.random(#Config.Maps[session.map].spawns[v.team])]
            SetEntityCoords(plyPed, selectedSpawn)
            SetEntityHeading(plyPed, selectedSpawn.w)
            TriggerClientEvent("pb-elim:InRound", k, true, v.team)
            TriggerClientEvent("pb-loadout:ForceUse", k, 1)
            TriggerClientEvent("pb-elim:UpdateSphere", k, session.gameData.logic.zoneEndPoint, session.gameData.logic.zoneSize, false)
            v.alive = true
        end
    end

    -- Round timer
    CreateThread(function()
        while session.gameData.state == "INROUND" do
            Wait(1000)
            session.gameData.logic.timer = session.gameData.logic.timer - 1
            -- Update stats panel for player
            local time = os.date("!*t", session.gameData.logic.timer)
            if string.len(tostring(time["sec"])) == 1 then
                time["sec"] = "0" .. time["sec"]
            end
            time = time["min"] .. ":" .. time["sec"]
            for k, v in pairs(session.gameData.logic.players) do
                if v then
                    local opponentTeam = 2
                    if v.team == 2 then
                        opponentTeam = 1
                    end
                    TriggerClientEvent("pb-hud:SetStats", k, {
                        [5] = {string = "Time left", value = time},
                        [4] = {string = "Team Score", value = session.gameData.logic.score[v.team] .. "/" .. math.floor((Config.Elim.MaxRounds/2)+1)},
                        [3] = {string = "Opponent Score", value = session.gameData.logic.score[opponentTeam] .. "/" .. math.floor((Config.Elim.MaxRounds/2)+1)},
                        [2] = {string = "Kills", value = v.kills},
                        [1] = {string = "Deaths", value = v.deaths}
                    })
                    if session.gameData.logic.timer == 0 then
                        EndRound(session, false)
                    elseif session.gameData.logic.timer <= Config.Elim.ZoneStartTime then
                        if session.gameData.logic.zoneSize > Config.Elim.ZoneEndSize then
                            session.gameData.logic.zoneSize = session.gameData.logic.zoneSize - Config.Elim.ZoneSpeed
                            TriggerClientEvent("pb-elim:UpdateSphere", k, session.gameData.logic.zoneEndPoint, session.gameData.logic.zoneSize, true)
                        end
                    end
                end
            end
        end
    end)
end

-- Handle endting a round
function EndRound(session, winner)

    if session.gameData.state == "ENDROUND" then return false end
    session.gameData.state = "ENDROUND"

    CreateThread(function()
        -- Handle the game not knowing who won the round
        if not winner then
            local team1Alive = 0
            local team2Alive = 0
            for k, v in pairs(session.gameData.logic.players) do
                if v then
                    if v.alive then
                        if v.team == 1 then
                            team1Alive = team1Alive + 1
                        else
                            team2Alive = team2Alive + 1
                        end
                    end
                end
            end
            if team1Alive > team2Alive then
                winner = 1
            elseif team1Alive < team2Alive then
                winner = 2
            end
        end

        -- Respawn players, and notify them
        for k, v in pairs(session.gameData.logic.players) do
            if v then
                if v.team == winner then
                    PB.Utility:Notify(k, "SUCCESS", "Round win", true)
                elseif winner == 0 then
                    PB.Utility:Notify(k, "NIL", "Round draw", true)
                else
                    PB.Utility:Notify(k, "ERROR", "Round loss", true)
                end
            end
        end

        -- Let the winning player have a little breather
        Wait(3000)
        for k, v in pairs(session.gameData.logic.players) do
            if v then
                TriggerClientEvent("pb-elim:InRound", k, false)
                TriggerClientEvent("pb-elim:SetCamera", k, Config.Maps[session.map].camera)
            end
        end

        -- Add up their teams score
        if winner then
            session.gameData.logic.score[winner] = session.gameData.logic.score[winner] + 1
            if session.gameData.logic.score[winner] > Config.Elim.MaxRounds/2 then
                Winner(session, winner)
                return
            end
        end

        -- Handle game ending due to max rounds, with no winner
        if session.gameData.logic.round >= Config.Elim.MaxRounds then
            if session.gameData.logic.score[1] > session.gameData.logic.score[2] then
                Winner(session, 1)
                return
            elseif session.gameData.logic.score[1] < session.gameData.logic.score[2] then
                Winner(session, 2)
                return
            else
                Winner(session, false)
                return
            end
        end

        local readyCountdown = Config.Elim.RoundStart
        while readyCountdown > 0 do
            Wait(1000)
            readyCountdown = readyCountdown - 1
            for k, v in pairs(session.gameData.logic.players) do
                if v then
                    TriggerClientEvent("pb-hud:SetStats", k, {[1] = {string = "Round starting", value = readyCountdown}})
                    if readyCountdown == 0 then
                        TriggerClientEvent("pb-elim:RemoveCamera", k)
                    end
                end
            end
        end
        StartRound(session)
    end)

end

-- Handle a winner being crowned
function Winner(session, winner)
    -- Handle the players
    if not winner then
        for k, v in pairs(session.gameData.logic.players) do
            if v then
                PB.Utility:Notify(k, "NIL", "Game was a draw", true)
                local ply = PB.Accounts:Get(k)
                if not ply then return false end
                ply.Functions.AddCurrency("cash", 1000 + v.kills*200)
                ply.Functions.AddExp("global", 500 + v.kills*75)
            end
        end
    else
        for k, v in pairs(session.gameData.logic.players) do
            if v then
                TPLobby(session, k)
                TriggerClientEvent("pb-elim:RemoveCamera", k)
                if v.team == winner then
                    PB.Utility:Notify(k, "SUCCESS", "Your team won the match", true)
                else
                    PB.Utility:Notify(k, "ERROR", "Your team lost the match", true)
                end
            end
        end
    end
    StartLobby(session)
end

-- TP player into the lobby
function TPLobby(session, src)
    local plyPed = GetPlayerPed(src)
    SetEntityCoords(plyPed, 686.3, 577.96, 130.46)
    SetEntityHeading(plyPed, 157.6)
    SetPlayerInvincible(src, true)
    TriggerClientEvent("pb-loadout:AllowEquip", src, false)
    TriggerClientEvent("pb-loadout:DisplayWeaponSelect", src, true)
    TriggerClientEvent("pb-hud:SetStats", src, {[1] = {string = "In lobby, 2 players required", value = ""}})
    if session.gameData.state == "INROUND" then
        TriggerClientEvent("pb-hud:SetStats", src, {[1] = {string = "Game live, will spawn in next round!", value = ""}})
    elseif session.gameData.state == "LOBBY" then
        TriggerClientEvent("pb-hud:SetStats", src, {[1] = {string = "In lobby, 2 players required", value = ""}})
    end

end

-- Handle a player dying within the gamemode
function HandleDeath(session, victim, attacker)
    if not session.gameData.state == "INROUND" then return false end
    if session.gameData.logic.players[victim] then
        -- Update stats
        session.gameData.logic.players[victim].deaths = session.gameData.logic.players[victim].deaths + 1
        -- Check if we've got a winner
        session.gameData.logic.players[victim].alive = false
        local team1Alive = 0
        local team2Alive = 0
        for k, v in pairs(session.gameData.logic.players) do 
            if v.alive then
                if v.team == 1 then
                    team1Alive = team1Alive + 1
                else
                    team2Alive = team2Alive + 1
                end
            end
        end
        if team1Alive == 0 then
            EndRound(session, 2)
        elseif team2Alive == 0 then
            EndRound(session, 1)
        end
    end
    if attacker and session.gameData.logic.players[attacker]then
        session.gameData.logic.players[attacker].kills = session.gameData.logic.players[attacker].kills + 1
    end
end

-- Handle player respawning
function HandleRespawn(session, src)
    -- improve this, with accurate funcs/events once theyre made
    TPLobby(session, src)
end

-- Handle a new player joining the game
function HandleJoin(session, src)
    session.gameData.logic.players[src] = {
        kills = 0,
        deaths = 0,
        team = false,
    }
    TPLobby(session, src)
    TriggerClientEvent("pb-elim:InRound", src, false)
    TriggerClientEvent("pb-loadout:ForceLoadout", src, {
        [1] = {item = "wep_compactrifle"},
        [2] = {item = "wep_appistol"},
        [3] = {item = "gadget_medkit"},
        [4] = {item = "gadget_armour"}
    })
    if not session.gameData.logic.state == "LOBBY" then
        SetNewTeam(session, src)
    end
    TriggerClientEvent("pb-elim:InGame", src, true)
end

-- Handle a player leaving the game
function HandleLeave(session, src)
    TriggerClientEvent("pb-elim:InGame", src, false)
    if session.gameData.logic.players[src] then
        if session.gameData.state == "INROUND" then
            session.gameData.logic.players[src].alive = false
            local team1Alive = 0
            local team2Alive = 0
            for k, v in pairs(session.gameData.logic.players) do 
                if v.alive then
                    if v.team == 1 then
                        team1Alive = team1Alive + 1
                    else
                        team2Alive = team2Alive + 1
                    end
                end
            end
            if team1Alive == 0 then
                EndRound(session, 2)
            elseif team2Alive == 0 then
                EndRound(session, 1)
            end
        end
        session.gameData.logic.players[src] = false
        TriggerClientEvent("pb-elim:InRound", src, false)
        TriggerClientEvent("pb-elim:RemoveCamera", src)
    end
end

-- Attach gamemode funcs
Elim.Functions.SetCycle(StartCycle)
Elim.Functions.SetHandleJoin(HandleJoin)
Elim.Functions.SetHandleDeath(HandleDeath)
Elim.Functions.SetHandleRespawn(HandleRespawn)
Elim.Functions.SetHandleLeave(HandleLeave)