-- Variables
PB.Utility = {}
local currentMap = nil
local outOfMapCountdown = 5
local CheckMap

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

-- LET IT SNOW!
--SetWeatherTypePersist("XMAS")
--SetWeatherTypeNowPersist("XMAS")
--SetWeatherTypeNow("XMAS")
--SetOverrideWeather("XMAS")

-- Check if player is out of map
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

-- Net events
RegisterNetEvent("pb:Notification", function(_type, string, notify)
   Notify(_type, string, notify)
end)

RegisterNetEvent("pb:CheckMap", function(map)
    CheckMap(map)
end)

RegisterNetEvent("pb:LeaveMap", function()
    PB.Utility:LeaveMap()
end)