-- Variables
local Training = PB.Gamemodes:CreateGamemode("training", "Training")

local StartCycle, HandleJoin, HandleLeave, HandleDeath, TPFacility

-- Start core game cycle
function StartCycle(session)
    session.gameData.live = true
    session.gameData.state = "LIVE"
end

-- Handle a new player joining the game
function HandleJoin(session, src)
    TPFacility(src)
    TriggerClientEvent("pb-training:Join", src)
end

-- Handle a player leaving the game
function HandleLeave(session, src)
    SetPlayerInvincible(src, false)
    TriggerClientEvent("pb-training:Leave", src)
end

-- Handle player dying
function HandleDeath(session, src)
    TPFacility(src)
end

-- TP player into the facility
function TPFacility(src)
    local plyPed = GetPlayerPed(src)
    SetEntityCoords(plyPed, vector3(479.5876, 4822.33, -58.38282))
    SetEntityHeading(plyPed, 196.467)
    SetPlayerInvincible(src, true)
end

-- Attach gamemode funcs
Training.Functions.SetCycle(StartCycle)
Training.Functions.SetHandleJoin(HandleJoin)
Training.Functions.SetHandleDeath(HandleDeath)
Training.Functions.SetHandleLeave(HandleLeave)
