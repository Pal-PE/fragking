-- Net events
RegisterNetEvent("pb-gungame:InGame", function(value)
    gameLive = value
    if value then
        exports["pvp-hud"]:DisplayHUD(true)
        exports["pvp-hud"]:SetTooltip(false)
        exports["pvp-loadout"]:LockLoadout(true)
    else
        exports["pvp-loadout"]:ClearLoadout()
        exports["pvp-hud"]:SetTooltip(false)
        exports["pvp-hud"]:DisplayHUD(false)
    end
end)