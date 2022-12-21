-- Variables
local gameLive = false
local inSafezone = false

-- Run client-side game cycle when game starts
local function InGame(safezone, radius)
    CreateThread(function()
        while gameLive do
            Wait(500)
            local plyPos = GetEntityCoords(PlayerPedId())
            local distance = #(vector2(plyPos.x, plyPos.y)-safezone)
            if distance > radius and inSafezone then
                inSafezone = false
                SetEntityInvincible(PlayerPedId(), false)
                SetEntityAlpha(PlayerPedId(), 255)
                TriggerEvent("pb-loadout:ForceLoadout", {
                    [1] = {item = "wep_appistol"},
                    [2] = {item = "gadget_medkit"},
                    [3] = {item = "gadget_armour"}
                })
                TriggerEvent("pb-loadout:ForceUse", 1)
            elseif not inSafezone and distance < radius then
                inSafezone = true
                SetEntityInvincible(PlayerPedId(), true)
                SetEntityAlpha(PlayerPedId(), 200)
                TriggerEvent("pb-loadout:ClearLoadout")
            end
        end
    end)
end

-- Net events
RegisterNetEvent("pb-rz:InGame", function(value, map)
    gameLive = value
    if value then
        TriggerEvent("pb-hud:DisplayHUD", true)
        TriggerEvent("pb-loadout:LockLoadout", true)
        InGame(map.rzPos, map.rzRadius)
    end
end)