-- Variables
local showHUD = false

-- Display HUD
function DisplayHUD(value)
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
end

-- Set NUI values
function SetTooltip(string)
    SendNUIMessage({type = "HudTooltip", value = string})
end
function AddNotification(string, _type)
    SendNUIMessage({type = "AddNotification", string = string, cat = _type})
end
function AddKill(string, personal)
    SendNUIMessage({type = "AddKillfeed", string = string, personal = personal})
end
function SetStats(table)
    SendNUIMessage({type = "SetStats", table = table})
end

-- Net events
RegisterNetEvent("pb-hud:AddKillFeed", function(victim, attacker, victimName, attackerName)
    local personal = false
    if victim == GetPlayerServerId(PlayerId()) or attacker == GetPlayerServerId(PlayerId()) then
        personal = true
    end
    AddKill(attackerName .. " killed " .. victimName, personal)
end)

RegisterNetEvent("pb-hud:SetStats", function(table)
    SetStats(table)
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

-- Exports
exports("DisplayHUD", DisplayHUD)
exports("SetTooltip", SetTooltip)
exports("AddNotification", AddNotification)
exports("AddKill", AddKill)
exports("SetStats", SetStats)