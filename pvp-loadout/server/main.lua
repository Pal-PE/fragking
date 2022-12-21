-- Variables
local PB = exports["pvp-base"]:GetCoreObject()

-- Remove the players previous weapons, then give them a new one and auto equip it
RegisterNetEvent("pb-loadout:GetWeapon", function(weapon)
    local src = source
    CreateThread(function()
        RemoveAllPedWeapons(GetPlayerPed(src))
        Wait(50)
        GiveWeaponToPed(GetPlayerPed(src), Config.Items[weapon].weapon, 10000, true, true)
        local ply = PB.Accounts:Get(src)
        if not ply then return false end
        if not ply.equippedItems.tints then return false end
        if not ply.equippedItems.tints[Config.Items[weapon].weapon] then return false end
        TriggerClientEvent("pb-loadout:ApplyTint", src, Config.Items[weapon].weapon, ply.equippedItems.tints[Config.Items[weapon].weapon])
    end)
    TriggerEvent("pb:NewLog", src, true, "Given a weapon via loadout", {weapon = weapon}, false)
end)

-- Remove a specified dweapon from the player, if non specified then remove all
RegisterNetEvent("pb-loadout:RemoveWeapon", function(weapon)
    local src = source
    if weapon then
        RemoveWeaponFromPed(GetPlayerPed(src), Config.Items[weapon].weapon)
    else
        RemoveAllPedWeapons(GetPlayerPed(src))
    end
    TriggerEvent("pb:NewLog", src, true, "Removed item via loadout", {weapon = weapon}, false)
end)