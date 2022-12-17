Gadgets = {}

Gadgets["gadget_bandage"] = function()
    local newHP = GetEntityHealth(PlayerPedId())+30
    if newHP > 100 then
        newHP = 100
    end
    SetEntityHealth(PlayerPedId(), newHP)
end

Gadgets["gadget_medkit"] = function()
    SetEntityHealth(PlayerPedId(), 100)
end

Gadgets["gadget_armour"] = function()
    SetPedArmour(PlayerPedId(), 100)
end