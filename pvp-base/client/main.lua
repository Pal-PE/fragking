-- Variables
PB = {}
PB.Locale = Locale
PB.Sessions = {}
local Sessions
PB.Gamemodes = {}
local Gamemodes
local GetCoreObject, GetSessions

-- Return core object
function GetCoreObject()
    return PB
end

-- Get session data
function PB.Sessions:RequestAll()
    TriggerServerEvent("pb:RequestSessions")
end

-- Return session data
function PB.Sessions:GetSessions()
    return Sessions
end

function GetSessions()
    return Sessions
end

-- Get gamemode data
function PB.Gamemodes:RequestAll()
    TriggerServerEvent("pb:RequestGamemodes")
end

-- Return gamemode data
function PB.Gamemodes:GetGamemodes()
    return Gamemodes
end

-- Handle death, and provide a killing player if possible
exports["spawnmanager"]:setAutoSpawn(false)
CreateThread(function()
    local attacker = false
    while true do
        Wait(100)
        if IsEntityDead(PlayerPedId()) then
            local pedKiller = GetPedSourceOfDeath(PlayerPedId())
            if IsEntityAPed(pedKiller) and IsPedAPlayer(pedKiller) then
                attacker = GetPlayerServerId(NetworkGetPlayerIndexFromPed(pedKiller))
            end
            exports["spawnmanager"]:spawnPlayer()
            while IsEntityDead(PlayerPedId()) do
                Wait(50)
            end
            SetEntityMaxHealth(PlayerPedId(), 100)
            SetEntityHealth(PlayerPedId(), 100)
            SetPedArmour(PlayerPedId(), 100)
            TriggerServerEvent("pb:PlayerDied", attacker)
        end
    end
end)

-- Net events
RegisterNetEvent("pb:PlayerLoaded", function()
    TriggerEvent("pb-menu:DisplayMenu", true)
end)

RegisterNetEvent("pb:ReceiveSessions", function(sessions)
    Sessions = sessions
end)

RegisterNetEvent("pb:ReceiveGamemodes", function(gamemodes)
    Gamemodes = gamemodes
end)

RegisterNetEvent("pb:JoinedSession", function(session)
    TriggerEvent("pb-menu:DisplayMenu", false)
    Notify("SUCCESS", "Joined " .. session.name, true)
end)

RegisterNetEvent("pb:LeftSession", function()
    TriggerEvent("pb-menu:DisplayMenu", true)
    TriggerEvent("pb-loadout:ClearLoadout")
    TriggerEvent("pb-hud:SetStats", {})
    TriggerEvent("pb-hud:SetTooltip", false)
    TriggerEvent("pb-hud:DisplayHUD", false)
    Notify("ERROR", "Left session", true)
end)

-- Turn on friendly fire, required
AddEventHandler("playerSpawned", function()
	SetCanAttackFriendly(PlayerPedId(), true, true)
	NetworkSetFriendlyFireOption(true)
end)

-- Exports
exports("GetCoreObject", GetCoreObject)
exports("GetSessions", GetSessions)

-- Let the server know that we've connected and are ready!
TriggerServerEvent("pb:PlayerConnected")