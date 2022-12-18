-- Variables
PB.Stash = {}

-- Purchase item
function PB.Stash:PurchaseItem(src, item, amount)
    if not Config.Items[item] then
        PB.Logging:NewError(src, true, "Attempted to purchase an item that doesn't exist", {item = item}, true)
        return false
    end
    local ply = PB.Accounts:Get(src)
    if not ply then return false end
    if ply.Functions.TakeCurrency("cash", Config.Items[item].price) then
        ply.Functions.Additem(item, amount)
    end
end

-- Equip tint
PB.Stash.EquipTint = function(src, tint)

    local ply = PB.Accounts:Get(src)
    if not ply then return false end

    if ply.equippedItems["tints"] then
        local tints = ply.equippedItems["tints"]
        tints[Config.Items[tint].wep] = Config.Items[tint].tint
        ply.Functions.EquipItem("tints", tints, tint)
    else
        ply.Functions.EquipItem("tints", {[Config.Items[tint].wep] = Config.Items[tint].tint}, tint)
    end

    PB.Utility:Notify(src, "SUCCESS", "Applied " .. Config.Items[tint].label, true)

    PB.Accounts:Save(src)

end

-- Apply funcs to items.lua server side
Config.ItemCategories["tints"].useFunc = PB.Stash.EquipTint

-- Net events
RegisterNetEvent("pb:RequestStash", function()
    local src = source
    local ply = PB.Accounts:Get(src)
    if not ply then return false end
    TriggerClientEvent("pb:ReceiveStash", src, ply.stash)
end)
