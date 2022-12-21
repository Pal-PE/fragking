Gadgets = {}

Gadgets["gadget_bandage"] = function()
    local newHP = GetEntityHealth(PlayerPedId())+70
    if newHP > 200 then
        newHP = 200
    end
    SetEntityHealth(PlayerPedId(), newHP)
end

Gadgets["gadget_medkit"] = function()
    SetEntityHealth(PlayerPedId(), 200)
end

Gadgets["gadget_armour"] = function()
    SetPedArmour(PlayerPedId(), 100)
end