-- Variables
PB.Utility = {}
local currentMap = nil
local outOfMapCountdown = 5
local CheckMap
local time = 0

-- Notifications
function Notify(_type, string, notify)
    local prefix = "INVALID"
    local prefixColour = {255, 255, 255}

    if _type == "ERROR" then
        prefix = "Error!"
        prefixColour = {255, 0, 0}
    elseif _type == "INFO" then
        prefix = "PvP"
        prefixColour = {40, 40, 255}
    elseif _type == "SUCCESS" then
        prefix = "PvP"
        prefixColour = {40, 255, 45}
    end

    if not notify then
        TriggerEvent("chat:addMessage", {
            color = prefixColour,
            multiline = true,
            args = {prefix, string}
        })
    end

    if notify then
        TriggerEvent("pb-hud:AddNotification", string, _type)
    end
end

RegisterNetEvent("pb:Notification", function(_type, string, notify)
    Notify(_type, string, notify)
 end)

-- Handle player leaving map bounds
function CheckMap(map)
    if not Config.Maps[map].Poly then return false end
    CreateThread(function()
        currentMap = nil
        Wait(2000)
        currentMap = map
        while currentMap do
            Wait(500)
            if not handlingRespawn then
                local coord = GetEntityCoords(PlayerPedId())
                insideMap = Config.Maps[map].Poly:isPointInside(coord)
                if not insideMap then
                    Notify("ERROR", "Out of bounds, return to the map!", true)
                    Wait(5000)
                    local coord = GetEntityCoords(PlayerPedId())
                    insideMap = Config.Maps[map].Poly:isPointInside(coord)
                    if not insideMap and currentMap then
                        SetEntityHealth(PlayerPedId(), 0)
                    end
                end
            end
        end
    end)
end

function PB.Utility:LeaveMap()
    currentMap = nil
end

RegisterNetEvent("pb:CheckMap", function(map)
    CheckMap(map)
end)

RegisterNetEvent("pb:LeaveMap", function()
    PB.Utility:LeaveMap()
end)

-- Handle weather
local frozenTime = 12
function PB.Utility:SetWeather(weather, time)
    ClearOverrideWeather()
	ClearWeatherTypePersist()
    SetWeatherTypePersist(weather)
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypeNow(weather)
    SetOverrideWeather(weather)
    if weather == "XMAS" then
        SetForceVehicleTrails(true)
		SetForcePedFootstepsTracks(true)
    else
        SetForceVehicleTrails(false)
        SetForcePedFootstepsTracks(false)
    end
    -- Set time
    NetworkOverrideClockTime(time, 0, 0)
    frozenTime = time
end

CreateThread(function()
    while true do
        Wait(5000)
        NetworkOverrideClockTime(frozenTime, 0, 0)
    end
end)


RegisterNetEvent("pb:UpdateWeather", function(weather, time)
    PB.Utility:SetWeather(weaather, time)
end)