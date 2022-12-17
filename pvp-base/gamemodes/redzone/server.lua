-- Variables
local RZ = PB.Gamemodes:CreateGamemode("rz", "AP RZ")
RZ.Functions.SetMapPool({"ramps"})
local StartCycle, TPPlatform, HandleDeath, HandleJoin, HandleLeave

-- Start game cycle
function StartCycle(session)
    session.GameData.Live = true
    session.GameData.State = "LIVE"
    session.GameData.Logic = {
        Players = {}
    }
    -- Update HUD
    CreateThread(function()
        while session.Active do
            Wait(500)
            for k, v in pairs(session.GameData.Logic.Players) do
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
    session.GameData.Logic.Players[src] = {
        kills = 0,
        deaths = 0,
    }
    TriggerClientEvent("pb-rz:InGame", src, true, Config.Maps[session.Map])
    TPPlatform(session, src)
end

-- Handle player leaving
function HandleLeave(session, src)
    if session.GameData.Logic.Players[src] then
        session.GameData.Logic.Players[src] = false
        TriggerClientEvent("pb-rz:InGame", src, false)
    end
end

-- Handle player dying
function HandleDeath(session, victim, attacker)
    TPPlatform(session, victim)
    if not attacker then return false end
    if attacker == victim then return false end
    -- Update stats
    if session.GameData.Logic.Players[victim] and session.GameData.Logic.Players[attacker] then
        session.GameData.Logic.Players[victim].deaths = session.GameData.Logic.Players[victim].deaths + 1
        session.GameData.Logic.Players[attacker].kills = session.GameData.Logic.Players[attacker].kills + 1
        local ply = PB.Accounts:Get(attacker)
        if not ply then return false end
        ply.Functions.AddCurrency("cash", 50)
        ply.Functions.AddExp("global", 75)
    end
end

-- Spawn the player back to the centre platform
function TPPlatform(session, src)
    local plyPed = GetPlayerPed(src)
    local selectedSpawn = Config.Maps[session.Map].spawns[100][math.random(#Config.Maps[session.Map].spawns[100])]
    SetEntityCoords(plyPed, selectedSpawn)
    SetEntityHeading(plyPed, selectedSpawn.w)
end

-- Attach gamemode funcs
RZ.Functions.SetCycle(StartCycle)
RZ.Functions.SetHandleJoin(HandleJoin)
RZ.Functions.SetHandleDeath(HandleDeath)
RZ.Functions.SetHandleLeave(HandleLeave)