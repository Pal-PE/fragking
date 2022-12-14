RegisterNetEvent("pb-loadout:GetWeapon", function(weapon)
    local src = source
    CreateThread(function()
        RemoveAllPedWeapons(GetPlayerPed(src))
        Wait(50)
        GiveWeaponToPed(GetPlayerPed(src), Config.Items[weapon].weapon, 10000, true, true)
    end)
end)

RegisterNetEvent("pb-loadout:RemoveWeapon", function(weapon)
    local src = source
    if weapon then
        RemoveWeaponFromPed(GetPlayerPed(src), Config.Items[weapon].weapon)
    else
        RemoveAllPedWeapons(GetPlayerPed(src))
    end
end)