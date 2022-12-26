-- Variables
local gameLive = false

-- Run client-side game cycle when game starts
local function InGame()
    TriggerEvent("pb-loadout:LockLoadout", true)
    CreateThread(function()
        while gameLive do
            Wait(1)
            if IsControlJustReleased(0, 288) then -- F1
                TriggerEvent("pb-loadout:DisplayWeaponSelect", true)
            end
        end
    end)
end

-- Net events
RegisterNetEvent("pb-ffa:InGame", function(value)
    gameLive = value
    if value then
        TriggerEvent("pb-hud:SetTooltip", "Press [F1] to change weapons.")
        InGame()
    else
        TriggerEvent("pb-loadout:DisplayWeaponSelect", false)
        TriggerEvent("pb-loadout:ClearLoadout")
        TriggerEvent("pb-hud:SetTooltip", false)
    end
end)