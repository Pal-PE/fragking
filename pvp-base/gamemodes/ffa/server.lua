-- Variables
local FFA = PB.Gamemodes:CreateGamemode("ffa", "Free-for-all")
FFA.Functions.SetMapPool({"shacktown","chopshop","nudist","lumber","villa","kortz","ramps"})
local StartCycle, StartLobby, StartGame, Winner, HandleJoin, HandleDeath, HandleRespawn, HandleLeave, TPGame, TPLobby

-- Start core game cycle
function StartCycle(session)
    -- Set the session to an initial state
    session.gameData.live = true
    session.gameData.state = "LOBBY"
    session.gameData.logic = {
        timer = 0,
        players = {}
    }
    StartLobby(session)
end

-- Start the lobby up
function StartLobby(session)
    CreateThread(function()
        while session.gameData.state == "LOBBY" do
            Wait(1000)
            local rdyCount = 0
            for k, v in pairs(session.gameData.logic.players) do
                if v then
                    rdyCount = rdyCount + 1
                end
            end
            if rdyCount >= 1 then
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
                                print("setting map to " .. session.mapPool[v])
                                session.Functions.SetMap(session.mapPool[v])
                            end
                        }
                    end
                else
                    for v in pairs(FFA.mapPool) do
                        voteMaps[v] = {
                            name = Locale["map_" .. FFA.mapPool[v] .. "_name"],
                            img = FFA.mapPool[v] .. ".png",
                            Function = function()
                                session.Functions.SetMap(FFA.mapPool[v])
                            end
                        }
                    end
                end
                exports["pvp-voting"]:CreateVote(session.bucket, "VOTE FOR MAP", 20, voteMaps)
                local readyCountdown = Config.FFA.LobbyStart
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
    -- Setup the session
    session.gameData.state = "LIVE"
    session.gameData.logic.timer = Config.FFA.Timer

    -- Push all players in lobby to live game
    for k, v in pairs(session.players) do
        if v then
            session.gameData.logic.players[k] = {
                kills = 0,
                deaths = 0
            }
            TPGame(session, k)
            TriggerClientEvent("pb-ffa:InGame", k,  true)
            TriggerClientEvent("pb-loadout:ForceLoadout", k, {
                [1] = {item = "wep_assaultrifle"},
                [2] = {item = "wep_appistol"},
                [3] = {item = "gadget_medkit"},
                [4] = {item = "gadget_armour"}
            })
        end
    end

    -- Add timer
    CreateThread(function()
        while session.gameData.state == "LIVE" do
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
                    TriggerClientEvent("pb-hud:SetStats", k, {
                        [4] = {string = "Time left", value = time},
                        [3] = {string = "Target kills", value = Config.FFA.Goal},
                        [2] = {string = "Kills", value = v.kills},
                        [1] = {string = "Deaths", value = v.deaths}
                    })
                end
            end
            -- Check for timed winner
            if session.gameData.logic.timer <= 0 then
                local topKills = 0
                local topKiller = nil
                for k, v in pairs(session.gameData.logic.players) do
                    if v and v.kills then
                        if v.kills > topKills or topKiller == nil then
                            topKills = v.kills
                            topKiller = k
                        end
                    end
                end
                Winner(session, topKiller)
            end
        end
    end)
end

-- Handle a new player joining the game
function HandleJoin(session, src)
    -- Add them to the gamelogic
    if session.gameData.state == "LIVE" then
        session.gameData.logic.players[src] = {
            kills = 0,
            deaths = 0,
        }
        TPGame(session, src)
        TriggerClientEvent("pb-ffa:InGame", src, true)
        TriggerClientEvent("pb-loadout:ForceLoadout", src, {
            [1] = {item = "wep_assaultrifle"},
            [2] = {item = "wep_appistol"},
            [3] = {item = "gadget_medkit"},
            [4] = {item = "gadget_armour"}
        })
    elseif session.gameData.state == "LOBBY" or session.gameData.state == "STARTING" then
        session.gameData.logic.players[src] = true
        TPLobby(session, src)
    end
end

-- Handle a player dying within the gamemode
function HandleDeath(session, victim, attacker)
    if not session.gameData.state == "LIVE" then return false end
    if not attacker then return false end
    if attacker == victim then return false end
    if session.gameData.logic.players[victim] and session.gameData.logic.players[attacker] then
        -- Update stats
        session.gameData.logic.players[victim].deaths = session.gameData.logic.players[victim].deaths + 1
        session.gameData.logic.players[attacker].kills = session.gameData.logic.players[attacker].kills + 1
        -- Check if we've got a winner
        if session.gameData.logic.players[attacker].kills >= Config.FFA.Goal then
            Winner(session, attacker)
        end
    end
end

-- Handle player respawning
function HandleRespawn(session, src)
    TPGame(session, src)
    TriggerClientEvent("pb-loadout:ForceUse", sc, 1)
end

-- Decide on a winner of the game
function Winner(session, src)
    -- End the game
    session.gameData.state = "LOBBY"
    for k, v in pairs(session.gameData.logic.players) do
        if v then
            local ply = PB.Accounts:Get(k)
            if not ply then return false end
            ply.Functions.AddCurrency("cash", 1000 + v.kills*200)
            ply.Functions.AddExp("global", 250 + v.kills*50)
            v = true
            TPLobby(session, k)
            TriggerClientEvent("pb-ffa:InGame", k, false)
            TriggerClientEvent("pb:Notification", k, "INFO", "Game over! " .. GetPlayerName(src) .. " has won.", true)
        end
    end

    -- Reward winner
    if session.players[src] then
        PB.Utility:Notify(src, "INFO", "You placed first and therefore recieved a bonus!")
        local ply = PB.Accounts:Get(src)
        if not ply then return false end
        ply.Functions.AddCurrency("cash", 5000)
        ply.Functions.AddExp("global", 500)
    end

    StartLobby(session)
end

-- TP player into the current game map
function TPGame(session, src)
    local plyPed = GetPlayerPed(src)
    print("spawning for " .. session.map)
    local selectedSpawn = Config.Maps[session.map].spawns[99][math.random(#Config.Maps[session.map].spawns[99])]
    SetEntityCoords(plyPed, selectedSpawn)
    SetEntityHeading(plyPed, selectedSpawn.w)
    SetPlayerInvincible(src, false)
end

-- TP player into the lobby
function TPLobby(session, src)
    local plyPed = GetPlayerPed(src)
    SetEntityCoords(plyPed, 686.3, 577.96, 130.46)
    SetEntityHeading(plyPed, 157.6)
    SetPlayerInvincible(src, true)
    TriggerClientEvent("pb-hud:SetStats", src, {[1] = {string = "In lobby, 2 players required", value = ""}})
end

-- Handle a player leaving the game
function HandleLeave(session, src)
    if session.gameData.logic.players[src] then
        session.gameData.logic.players[src] = false
        TriggerClientEvent("pb-ffa:InGame", src, false)
    end
end

-- Attach gamemode funcs
FFA.Functions.SetCycle(StartCycle)
FFA.Functions.SetHandleJoin(HandleJoin)
FFA.Functions.SetHandleDeath(HandleDeath)
FFA.Functions.SetHandleRespawn(HandleRespawn)
FFA.Functions.SetHandleLeave(HandleLeave)