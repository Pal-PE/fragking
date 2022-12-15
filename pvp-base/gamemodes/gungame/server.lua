-- Variables
local GunGame = PB.Gamemodes:CreateGamemode("gungame", "Gun Game")
GunGame.Functions.SetMapPool({"shacktown","chopshop","nudist","lumber","villa","kortz","ramps"})
local StartCycle, StartLobby, StartGame, Winner, HandleJoin, HandleDeath, HandleLeave, TPGame, TPLobby

-- Start core game cycle
function StartCycle(session)
    -- Set the session to an initial states
    session.GameData.Live = true
    session.GameData.State = "LOBBY"
    session.GameData.Logic = {
        Timer = 0,
        Players = {}
    }
    StartLobby(session)
end

-- Start the lobby up
function StartLobby(session)
    CreateThread(function()
        while session.GameData.State == "LOBBY" do
            Wait(1000)
            local rdyCount = 0
            for k, v in pairs(session.GameData.Logic.Players) do
                if v then
                    rdyCount = rdyCount + 1
                end
            end
            if rdyCount >= 2 then
                session.GameData.State = "STARTING"
                local readyCountdown = Config.GunGame.LobbyStart
                while readyCountdown > 0 do
                    Wait(1000)
                    readyCountdown = readyCountdown - 1
                    for k, v in pairs(session.GameData.Logic.Players) do
                        TriggerClientEvent("pb-hud:SetStats", k, {[1] = {string = "Game starting", value = readyCountdown}})
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
    session.GameData.State = "LIVE"
    session.GameData.Logic.Timer = Config.GunGame.Timer

    -- Push all players in lobby to live game
    for k, v in pairs(session.Players) do
        if v then
            session.GameData.Logic.Players[k] = {
                kills = 0,
                deaths = 0,
                currentGun = 1,
                nextGun = 3,
            }
            TPGame(session, k)
            TriggerClientEvent("pb-gungame:InGame", k,  true)
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
                        [3] = {string = "Guns Left", value = math.floor(Config.GunGame.Goal/2 - v.currentGun)},
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
            currentGun = 1,
            nextGun = 3,
        }
        TPGame(session, src)
        TriggerClientEvent("pb-gungame:InGame", src, true)
    elseif session.GameData.State == "LOBBY" or session.GameData.State == "STARTING" then
        session.GameData.Logic.Players[src] = true
        TPLobby(session, src)
    end
end

-- Handle a player dying within the gamemode
function HandleDeath(session, victim, attacker)
    TPGame(session, victim)
    if not attacker then return false end
    if attacker == victim then return false end

    if session.GameData.Logic.Players[victim] and session.GameData.Logic.Players[attacker] then
        -- Update stats
        session.GameData.Logic.Players[victim].deaths = session.GameData.Logic.Players[victim].deaths + 1
        session.GameData.Logic.Players[attacker].kills = session.GameData.Logic.Players[attacker].kills + 1
        -- Check if we've got a winner
        if session.GameData.Logic.Players[attacker].kills >= Config.GunGame.Goal then
            Winner(session, attacker)
            return
        end
        -- Update gungame gun
        local newGun = math.floor(session.GameData.Logic.Players[attacker].kills / 2) + 1
        local killsLeft = session.GameData.Logic.Players[attacker].kills % 2
        if newGun ~= session.GameData.Logic.Players[attacker].currentGun then
            session.GameData.Logic.Players[attacker].currentGun = newGun
            TriggerClientEvent("pb-loadout:ForceLoadout", attacker, {
                [1] = {item = Config.GunGame.Guns[newGun]},
                [2] = {item = "gadget_medkit"},
                [3] = {item = "gadget_armour"}
            })
            TriggerClientEvent("pb-loadout:ForceUse", attacker, 1)
        end
        session.GameData.Logic.Players[attacker].nextGun = killsLeft
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
            TriggerClientEvent("pb-gungame:InGame", k, false)
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

    StartLobby(session)
end

-- TP player into the current game map
function TPGame(session, src)
    local plyPed = GetPlayerPed(src)
    local selectedSpawn = Config.Maps[session.Map].spawns[99][math.random(#Config.Maps[session.Map].spawns[99])]
    SetEntityCoords(plyPed, selectedSpawn)
    SetEntityHeading(plyPed, selectedSpawn.w)
    SetPlayerInvincible(src, false)
    -- Handle gungame weapons
    TriggerClientEvent("pb-loadout:ForceLoadout", src, {
        [1] = {item = Config.GunGame.Guns[session.GameData.Logic.Players[src].currentGun]},
        [2] = {item = "gadget_medkit"},
        [3] = {item = "gadget_armour"}
    })
    TriggerClientEvent("pb-loadout:ForceUse", src, 1)
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
    if session.GameData.Logic.Players[src] then
        session.GameData.Logic.Players[src] = false
        TriggerClientEvent("pb-gungame:InGame", src, false)
    end
end

-- Attach gamemode funcs
GunGame.Functions.SetCycle(StartCycle)
GunGame.Functions.SetHandleJoin(HandleJoin)
GunGame.Functions.SetHandleDeath(HandleDeath)
GunGame.Functions.SetHandleLeave(HandleLeave)

-- Create default sessions
local EXMP = PB.Sessions:CreateSession(21, false, "strict", "Gun Game: Office 24/7")
EXMP.Functions.SetGame("gungame")
EXMP.Functions.SetMap("office")
EXMP.Functions.SetMapPool({"office"})
EXMP.Functions.SetMaxPlayers(10)
EXMP.Functions.SetFlag("official", true)
EXMP.Functions.StartGame()

local EXMP = PB.Sessions:CreateSession(22, false, "strict", "Gun Game: Ramps 24/7")
EXMP.Functions.SetGame("gungame")
EXMP.Functions.SetMap("ramps")
EXMP.Functions.SetMapPool({"ramps"})
EXMP.Functions.SetMaxPlayers(10)
EXMP.Functions.SetFlag("official", true)
EXMP.Functions.StartGame()

local EXMP =  PB.Sessions:CreateSession(23, false, "strict", "Gun Game: Small & Medium Maps")
EXMP.Functions.SetGame("gungame")
EXMP.Functions.SetMap("nudist")
EXMP.Functions.SetMapPool({"office","chopshop","stabcity","shacktown","villa","ramps"})
EXMP.Functions.SetMaxPlayers(10)
EXMP.Functions.SetFlag("official", true)
EXMP.Functions.StartGame()

local EXMP = PB.Sessions:CreateSession(24, false, "strict", "Gun Game: Large Maps")
EXMP.Functions.SetGame("gungame")
EXMP.Functions.SetMap("kortz")
EXMP.Functions.SetMapPool({"kortz","chopshop"})
EXMP.Functions.SetMaxPlayers(20)
EXMP.Functions.SetFlag("official", true)
EXMP.Functions.StartGame()