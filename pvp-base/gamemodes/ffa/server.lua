-- Create gamemode
local FFA = PB.Gamemodes:CreateGamemode("ffa", "Free-for-all", false)
FFA.Functions.SetMapPool({"shacktown","chopshop","nudist","lumber","villa","kortz"})

-- Start core game cycle
function StartCycle(session)
    -- Set the session to an initial state
    session.GameData.Live = true
    session.GameData.State = "LOBBY"
    session.GameData.Logic = {
        Timer = 0,
        Players = {}
    }
    -- Check for players, and start game once lobby is full
    CreateThread(function()
        while session.GameData.State == "LOBBY" do
            Wait(Config.FFA.LobbyCheck*1000)
            local rdyCount = 0
            for k, v in pairs(session.GameData.Logic.Players) do
                if v then
                    rdyCount = rdyCount + 1
                end
            end
            if rdyCount >= 2 then
                StartGame(session)
            end
        end
    end)
end

--Run server-side game cycle when game starts
function StartGame(session)
    -- Setup the session
    session.GameData.State = "LIVE"
    session.GameData.Logic.Timer = Config.FFA.Timer

    -- Push all players in lobby to live game
    for k, v in pairs(session.Players) do
        if v then
            session.GameData.Logic.Players[k] = {
                kills = 0,
                deaths = 0
            }
            TPGame(session, k)
            TriggerClientEvent("pb-ffa:InGame", k,  true)
            TriggerClientEvent("pb-loadout:ForceLoadout", k, {
                [1] = {item = "wep_assaultrifle"},
                [2] = {item = "wep_appistol"},
                [3] = {item = "gadget_bandage"},
                [4] = {item = "gadget_armour"}
            })
        end
    end

    -- Add timer
    CreateThread(function()
        while session.GameData.State == "LIVE" do
            Wait(1000)
            session.GameData.Logic.Timer = session.GameData.Logic.Timer - 1
            -- Update stats panel for player
            local time = os.date("!*t", session.GameData.Logic.Timer)
            if string.len(tostring(time["sec"])) == 1 then
                time["sec"] = "0" .. time["sec"]
            end
            time = time["min"] .. ":" .. time["sec"]
            for k, v in pairs(session.GameData.Logic.Players) do
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
            if session.GameData.Logic.Timer <= 0 then
                local topKills = 0
                local topKiller = nil
                for k, v in pairs(session.GameData.Logic.Players) do
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
    if session.GameData.State == "LIVE" then
        session.GameData.Logic.Players[src] = {
            kills = 0,
            deaths = 0,
        }
        TPGame(session, k)
        TriggerClientEvent("pb-ffa:InGame", src, true)
        TriggerClientEvent("pb-loadout:ForceLoadout", src, {
            [1] = {item = "wep_assaultrifle"},
            [2] = {item = "wep_appistol"},
            [3] = {item = "gadget_bandage"},
            [4] = {item = "gadget_armour"}
        })
    elseif session.GameData.State == "LOBBY" then
        session.GameData.Logic.Players[src] = true
        TPLobby(session, src)
    end
end

-- Handle a player dying within the gamemode
function HandleDeath(session, victim, attacker)
    TPGame(session, victim)
    if not attacker then return false end

    if session.GameData.Logic.Players[victim] and session.GameData.Logic.Players[attacker] then
        -- Update stats
        session.GameData.Logic.Players[victim].deaths = session.GameData.Logic.Players[victim].deaths + 1
        session.GameData.Logic.Players[attacker].kills = session.GameData.Logic.Players[attacker].kills + 1
        -- Check if we've got a winner
        if session.GameData.Logic.Players[attacker].kills >= Config.FFA.Goal then
            Winner(session, attacker)
        end
    end
end

-- Decide on a winner of the game
function Winner(session, src)
    -- End the game
    session.GameData.State = "LOBBY"
    for k, v in pairs(session.GameData.Logic.Players) do
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
    if session.Players[src] then
        PB.Utility:Notify(src, "INFO", "You placed first and therefore recieved a bonus!")
        local ply = PB.Accounts:Get(src)
        if not ply then return false end
        ply.Functions.AddCurrency("cash", 5000)
        ply.Functions.AddExp("global", 500)
    end

    -- Check on starting the game back up
    CreateThread(function()
        while session.GameData.State == "LOBBY" do
            Wait(Config.FFA.LobbyCheck*1000)
            local rdyCount = 0
            for k, v in pairs(session.GameData.Logic.Players) do
                if v then
                    rdyCount = rdyCount + 1
                end
            end
            if rdyCount >= 1 then
                StartGame(session)
            end
        end
    end)
end

-- TP player into the current game map
function TPGame(session, src)
    local plyPed = GetPlayerPed(src)
    local selectedSpawn = Config.Maps[session.Map].spawns[99][math.random(#Config.Maps[session.Map].spawns[99])]
    SetEntityCoords(plyPed, selectedSpawn)
    SetEntityHeading(plyPed, selectedSpawn.w)
end

-- TP player into the lobby
function TPLobby(session, src)
    local plyPed = GetPlayerPed(src)
    SetEntityCoords(plyPed, 686.3, 577.96, 130.46)
    SetEntityHeading(plyPed, 157.6)
end

-- Handle a player leaving the game
function HandleLeave(session, src)
    if session.GameData.Logic.Players[src] then
        session.GameData.Logic.Players[src] = false
        TriggerClientEvent("pb-ffa:InGame", src, false)
    end
end

-- Attach gamecycle
FFA.Functions.SetCycle(StartCycle)
FFA.Functions.SetHandleJoin(HandleJoin)
FFA.Functions.SetHandleDeath(HandleDeath)
FFA.Functions.SetHandleLeave(HandleLeave)

-- Create default sessions
PB.Sessions:CreateSession(11, false, "strict", "Official FFA #1")
local EXMP = PB.Sessions:Get(11)
EXMP.Functions.SetGame("ffa")
EXMP.Functions.SetMap("villa")
EXMP.Functions.SetMaxPlayers(10)
EXMP.Functions.SetOfficial(true)
EXMP.Functions.StartGame()

PB.Sessions:CreateSession(12, false, "strict", "Official FFA #2")
local EXMP = PB.Sessions:Get(12)
EXMP.Functions.SetGame("ffa")
EXMP.Functions.SetMap("nudist")
EXMP.Functions.SetMaxPlayers(10)
EXMP.Functions.SetOfficial(true)
EXMP.Functions.StartGame()

PB.Sessions:CreateSession(12, false, "strict", "Official FFA #3")
local EXMP = PB.Sessions:Get(12)
EXMP.Functions.SetGame("ffa")
EXMP.Functions.SetMap("kortz")
EXMP.Functions.SetMaxPlayers(32)
EXMP.Functions.SetOfficial(true)
EXMP.Functions.StartGame()