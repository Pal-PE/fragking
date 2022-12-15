-- Variables
local FFA = PB.Gamemodes:CreateGamemode("ffa", "Free-for-all")
FFA.Functions.SetMapPool({"shacktown","chopshop","nudist","lumber","villa","kortz","ramps"})
local StartCycle, StartLobby, StartGame, Winner, HandleJoin, HandleDeath, HandleLeave, TPGame, TPLobby

-- Start core game cycle
function StartCycle(session)
    -- Set the session to an initial state
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
            if rdyCount >= 1 then
                session.GameData.State = "STARTING"
                Wait(3000)
                -- Map voting
                local voteMaps = {}
                if session.MapPool then
                    for v in pairs(session.MapPool) do
                        voteMaps[v] = {
                            name = Locale["map_" .. session.MapPool[v] .. "_name"],
                            img = session.MapPool[v] .. ".png",
                            Function = function()
                                session.Functions.SetMap(session.MapPool[v])
                            end
                        }
                    end
                else
                    for v in pairs(FFA.MapPool) do
                        print(v)
                        voteMaps[v] = {
                            name = Locale["map_" .. FFA.MapPool[v] .. "_name"],
                            img = FFA.MapPool[v] .. ".png",
                            Function = function()
                                session.Functions.SetMap(FFA.MapPool[v])
                            end
                        }
                    end
                end
                exports["pvp-voting"]:CreateVote(session.Bucket, "SELECT MAP", 20, voteMaps)
                local readyCountdown = Config.FFA.LobbyStart
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
                [3] = {item = "gadget_medkit"},
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
        TPGame(session, src)
        TriggerClientEvent("pb-ffa:InGame", src, true)
        TriggerClientEvent("pb-loadout:ForceLoadout", src, {
            [1] = {item = "wep_assaultrifle"},
            [2] = {item = "wep_appistol"},
            [3] = {item = "gadget_medkit"},
            [4] = {item = "gadget_armour"}
        })
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

    StartLobby(session)
end

-- TP player into the current game map
function TPGame(session, src)
    local plyPed = GetPlayerPed(src)
    local selectedSpawn = Config.Maps[session.Map].spawns[99][math.random(#Config.Maps[session.Map].spawns[99])]
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
    if session.GameData.Logic.Players[src] then
        session.GameData.Logic.Players[src] = false
        TriggerClientEvent("pb-ffa:InGame", src, false)
    end
end

-- Attach gamemode funcs
FFA.Functions.SetCycle(StartCycle)
FFA.Functions.SetHandleJoin(HandleJoin)
FFA.Functions.SetHandleDeath(HandleDeath)
FFA.Functions.SetHandleLeave(HandleLeave)

-- Create default sessions
local EXMP = PB.Sessions:CreateSession(11, false, "strict", "FFA: Office 24/7")
EXMP.Functions.SetGame("ffa")
EXMP.Functions.SetMap("office")
EXMP.Functions.SetMapPool({"office"})
EXMP.Functions.SetMaxPlayers(10)
EXMP.Functions.SetFlag("official", true)
EXMP.Functions.StartGame()

local EXMP = PB.Sessions:CreateSession(12, false, "strict", "FFA: Ramps 24/7")
EXMP.Functions.SetGame("ffa")
EXMP.Functions.SetMap("ramps")
EXMP.Functions.SetMapPool({"ramps"})
EXMP.Functions.SetMaxPlayers(10)
EXMP.Functions.SetFlag("official", true)
EXMP.Functions.StartGame()

local EXMP =  PB.Sessions:CreateSession(13, false, "strict", "FFA: Small & Medium Maps")
EXMP.Functions.SetGame("ffa")
EXMP.Functions.SetMap("nudist")
EXMP.Functions.SetMapPool({"office","chopshop","stabcity","shacktown","villa","ramps"})
EXMP.Functions.SetMaxPlayers(10)
EXMP.Functions.SetFlag("official", true)
EXMP.Functions.StartGame()

local EXMP = PB.Sessions:CreateSession(14, false, "strict", "FFA: Large Maps")
EXMP.Functions.SetGame("ffa")
EXMP.Functions.SetMap("kortz")
EXMP.Functions.SetMapPool({"kortz","chopshop"})
EXMP.Functions.SetMaxPlayers(20)
EXMP.Functions.SetFlag("official", true)
EXMP.Functions.StartGame()