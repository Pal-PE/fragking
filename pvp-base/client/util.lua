-- Notifications
RegisterNetEvent("pb:Notification", function(_type, string, notify)
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
        exports["pvp-hud"]:AddNotification(string, _type)
    end
end)

-- LET IT SNOW!
SetWeatherTypePersist("XMAS")
SetWeatherTypeNowPersist("XMAS")
SetWeatherTypeNow("XMAS")
SetOverrideWeather("XMAS")