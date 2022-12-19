-- Variables
local showHUD = false
local DisplayHUD, SetTooltip, AddNotification, AddKill, SetStats, SetKillbox

-- Display HUD
RegisterNetEvent("pb-hud:DisplayHUD", function(value)
    if value == showHUD then return false end
    showHUD = value
    if value then
        SendNUIMessage({type = "DisplayHUD", value = true})
        CreateThread(function()
            while showHUD do
                Wait(500)
                SendNUIMessage({type = "HudHP", value = GetEntityMaxHealth(PlayerPedId())})
                SendNUIMessage({type = "HudARM", value = GetPedArmour(PlayerPedId())})
            end
        end)
    else
        SendNUIMessage({type = "DisplayHUD", value = false})
    end
end)

-- Set tooltip
RegisterNetEvent("pb-hud:SetTooltip", function(string)
    SendNUIMessage({type = "HudTooltip", value = string})
end)

-- Add new notification to queue
RegisterNetEvent("pb-hud:AddNotification", function(string, _type)
    SendNUIMessage({type = "AddNotification", string = string, cat = _type})
end)

-- Set sidebar stats
RegisterNetEvent("pb-hud:SetStats", function(table)
    SendNUIMessage({type = "SetStats", table = table})
end)

-- Add kill to the killfeed
RegisterNetEvent("pb-hud:AddKillFeed", function(victim, attacker, victimName, attackerName)
    local personal = false
    if victim == GetPlayerServerId(PlayerId()) or attacker == GetPlayerServerId(PlayerId()) then
        personal = true
    end
    SendNUIMessage({type = "AddKillfeed", string = attackerName .. " fragged " .. victimName, personal = personal})
end)

-- Set killbox
RegisterNetEvent("pb-hud:SetKillbox", function(string, callingcard, title)
    SendNUIMessage({type = "SetKillbox", string = string, callingcard = callingcard, title = title})
end)

-- Base game stuff to disable
DisplayRadar(false)
CreateThread(function()
    while true do
        Wait(1)
        HideHudComponentThisFrame(3) -- Cash
        HideHudComponentThisFrame(4) -- MP Cash
        HideHudComponentThisFrame(6) -- Vehicle Name
        HideHudComponentThisFrame(7) -- Area Name
        HideHudComponentThisFrame(8) -- Vehicle Class      
        HideHudComponentThisFrame(9) -- Street Name
        HideHudComponentThisFrame(13) -- Cash Change
        HideHudComponentThisFrame(17) -- Save Game  
        HideHudComponentThisFrame(19) -- Weapon Wheel
        HideHudComponentThisFrame(20) -- Weapon Stats 
    end
end)