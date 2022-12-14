-- Variables
local gameLive = false

-- Run client-side game cycle when game starts
function InGame()
    exports["pvp-loadout"]:LockLoadout(false)
    CreateThread(function()
        while gameLive do
            Wait(1)
            if IsControlJustReleased(0, 288) then -- F1
                exports["pvp-loadout"]:OpenWeaponSelect()
            end
        end
    end)
end

-- Net events
RegisterNetEvent("pb-ffa:InGame", function(value)
    gameLive = value
    if value then
        exports["pvp-hud"]:SetTooltip("Press [F1] to change weapons.")
        exports["pvp-hud"]:DisplayHUD(true)
        InGame()
    else
        exports["pvp-loadout"]:ClearLoadout()
        exports["pvp-hud"]:SetTooltip(false)
        exports["pvp-hud"]:DisplayHUD(false)
    end
end)