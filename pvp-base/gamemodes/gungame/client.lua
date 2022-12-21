-- Net events
RegisterNetEvent("pb-gungame:InGame", function(value)
    gameLive = value
    if value then
        TriggerEvent("pb-hud:DisplayHUD", true)
        TriggerEvent("pb-loadout:LockLoadout", true)
    else
        TriggerEvent("pb-loadout:ClearLoadout")
        TriggerEvent("pb-hud:DisplayHUD", true)
    end
end)