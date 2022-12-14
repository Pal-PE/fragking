RegisterNetEvent("pb-loadout:GetWeapon", function(weapon)
    local src = source
    RemoveAllPedWeapons(GetPlayerPed(src))
    GiveWeaponToPed(GetPlayerPed(src), Config.Items[weapon].weapon, 10000, true, true)
end)

RegisterNetEvent("pb-loadout:RemoveWeapon", function(weapon)
    local src = source
    if weapon then
        RemoveWeaponFromPed(GetPlayerPed(src), Config.Items[weapon].weapon)
    else
        RemoveAllPedWeapons(GetPlayerPed(src))
    end
end)