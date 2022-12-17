-- Variables
local RZ = PB.Gamemodes:CreateGamemode("rz", "AP RZ")
RZ.Functions.SetMapPool({"ramps"})
local StartCycle, TPPlatform, HandleDeath, HandleJoin, HandleLeave

-- Start game cycle
function StartCycle(session)
    session.gameData.live = true
    session.gameData.state = "LIVE"
    session.gameData.logic = {
        players = {}
    }
    -- Update HUD
    CreateThread(function()
        while session.Active do
            Wait(500)
            for k, v in pairs(session.gameData.logic.players) do
                if v then
                    -- HUD
                    TriggerClientEvent("pb-hud:SetStats", k, {
                        [2] = {string = "Kills", value = v.kills},
                        [1] = {string = "Deaths", value = v.deaths}
                    })
                end
            end
        end
    end)
end

-- Handle player joining
function HandleJoin(session, src)
    session.gameData.logic.players[src] = {
        kills = 0,
        deaths = 0,
    }
    TriggerClientEvent("pb-rz:InGame", src, true, Config.Maps[session.map])
    TPPlatform(session, src)
end

-- Handle player leaving
function HandleLeave(session, src)
    if session.gameData.logic.players[src] then
        session.gameData.logic.players[src] = false
        TriggerClientEvent("pb-rz:InGame", src, false)
    end
end

-- Handle player dying
function HandleDeath(session, victim, attacker)
    TPPlatform(session, victim)
    if not attacker then return false end
    if attacker == victim then return false end
    -- Update stats
    if session.gameData.logic.players[victim] and session.gameData.logic.players[attacker] then
        session.gameData.logic.players[victim].deaths = session.gameData.logic.players[victim].deaths + 1
        session.gameData.logic.players[attacker].kills = session.gameData.logic.players[attacker].kills + 1
        local ply = PB.Accounts:Get(attacker)
        if not ply then return false end
        ply.Functions.AddCurrency("cash", 50)
        ply.Functions.AddExp("global", 75)
    end
end

-- Spawn the player back to the centre platform
function TPPlatform(session, src)
    local plyPed = GetPlayerPed(src)
    local selectedSpawn = Config.Maps[session.map].spawns[100][math.random(#Config.Maps[session.map].spawns[100])]
    SetEntityCoords(plyPed, selectedSpawn)
    SetEntityHeading(plyPed, selectedSpawn.w)
end

-- Attach gamemode funcs
RZ.Functions.SetCycle(StartCycle)
RZ.Functions.SetHandleJoin(HandleJoin)
RZ.Functions.SetHandleDeath(HandleDeath)
RZ.Functions.SetHandleLeave(HandleLeave)