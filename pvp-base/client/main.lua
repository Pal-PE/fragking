-- Variables
PB = {}
PB.Locale = Locale
local Sessions, Gamemodes, Stash, Shop
local GetCoreObject, GetSessions, GetStash
handlingRespawn = false

-- Return core object
function GetCoreObject()
    return PB
end

-- Return client side config
function GetCoreConfig()
    return Config
end

-- Get sessions, with a callback
function PB:GetSessions(cb)
    Sessions = nil
    TriggerServerEvent("pb:RequestSessions")
    while not Sessions do
        Wait(50)
    end
    cb(Sessions)
end

RegisterNetEvent("pb:ReceiveSessions", function(sessions)
    Sessions = sessions
end)

-- Get gamemodes, with a callback
function PB:GetGamemodes(cb)
    Gamemodes = nil
    TriggerServerEvent("pb:RequestGamemodes")
    while not Gamemodes do
        Wait(50)
    end
    cb(Gamemodes)
end

RegisterNetEvent("pb:ReceiveGamemodes", function(gamemodes)
    Gamemodes = gamemodes
end)

-- Get stash, with a callback
function PB:GetStash(cb)
    Stash = nil
    TriggerServerEvent("pb:RequestStash")
    while not Stash do
        Wait(50)
    end
    cb(Stash)
end

RegisterNetEvent("pb:ReceiveStash", function(stash)
    Stash = stash
end)

-- Get shop, with a callback
function PB:GetShop(cb)
    Shop = nil
    TriggerServerEvent("pb:RequestShop")
    while not Shop do
        Wait(50)
    end
    cb(Shop)
end

RegisterNetEvent("pb:ReceiveShop", function(shop)
    if not shop then return false end
    Shop = shop
end)

-- Net events
RegisterNetEvent("pb:JoinedSession", function(session)
    PB.Utility:SetWeather(session.settings.weather, session.settings.time)
    TriggerEvent("pb-menu:DisplayMenu", false)
    TriggerEvent("pb-hud:DisplayHUD", true)
    Notify("SUCCESS", "Joined " .. session.name, true)
    NetworkSetVoiceChannel(session.bucket)
end)

RegisterNetEvent("pb:LeftSession", function()
    PB.Utility:LeaveMap()
    allowedRespawn = true
    TriggerEvent("pb-menu:DisplayMenu", true)
    TriggerEvent("pb-loadout:ClearLoadout")
    TriggerEvent("pb-hud:SetStats", {})
    TriggerEvent("pb-hud:SetTooltip", false)
    TriggerEvent("pb-hud:DisplayHUD", false)
    Notify("ERROR", "Left session", true)
    SetPlayerTeam(PlayerId(), 0)
    SetCanAttackFriendly(PlayerPedId(), true, true)
	NetworkSetFriendlyFireOption(true)
end)

-- Turn on friendly fire, required
AddEventHandler("playerSpawned", function()
	SetCanAttackFriendly(PlayerPedId(), true, true)
	NetworkSetFriendlyFireOption(true)
end)

-- Exports
exports("GetCoreObject", GetCoreObject)
exports("GetCoreConfig", GetCoreConfig)

-- Let the server know that we've connected and are ready!
TriggerServerEvent("pb:PlayerConnected")