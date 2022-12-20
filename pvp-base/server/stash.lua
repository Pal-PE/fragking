-- Variables
PB.Stash = {}

-- Purchase item
function PB.Stash:PurchaseItem(src, item)
    if not Config.Items[item] then return false end
    local ply = PB.Accounts:Get(src)
    if not ply then return false end

    if ply.stash[item] then
        PB.Utility:Notify(src, "ERROR", "You already own this item", true)
        return false
    end

    -- Check for the item in shop
    local itemCost = nil
    local currency = nil
    local levelReq = nil
    for k, v in pairs(Config.Shop) do
        for x, y in pairs(v.items) do
            if item == y.item then
                itemCost = y.price
                currency = y.currency
                levelReq = y.level
            end
        end
    end

    if not itemCost or not currency or not levelReq then
        PB.Utility:Notify(src, "ERROR", "Item not found in shop", true)
        return false
    end

    if ply.Functions.GetLevel("global") >= levelReq then
        if ply.Functions.TakeCurrency(currency, itemCost) then
            if ply.Functions.AddItem(item, 1) then
                PB.Utility:Notify(src, "SUCCESS", "Purchased " .. Config.Items[item].label, true)
                PB.Accounts:Save(src)
                PB.Logging:NewLog(src, true, "Item purchased", {item = item, itemCost = itemCost, currency = currency, levelReq = levelReq}, true)
                return true
            else
                ply.Functions.AddCurrency(currency, itemCost)
                PB.Utility:Notify(src, "ERROR", "Failed to purchase item", true)
            end
        else
            PB.Utility:Notify(src, "ERROR", "Not enough money", true)
        end
    else
        PB.Utility:Notify(src, "ERROR", "Level requirement not met", true)
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
end

-- Equip calling card
PB.Stash.EquipCallingCard = function(src, callingcard)
    local ply = PB.Accounts:Get(src)
    if not ply then return false end
    ply.Functions.EquipItem("callingcard", callingcard, callingcard)
    PB.Utility:Notify(src, "SUCCESS", "Equipped " .. Config.Items[callingcard].label, true)
end

-- Equip coloured name
PB.Stash.EquipColouredName = function(src, colour)
    local ply = PB.Accounts:Get(src)
    if not ply then return false end
    ply.Functions.EquipItem("colname", colour, colour)
    PB.Utility:Notify(src, "SUCCESS", "Applied " .. Config.Items[colour].label, true)
end

-- Apply funcs to items.lua server side
Config.ItemCategories["tints"].useFunc = PB.Stash.EquipTint
Config.ItemCategories["callingcards"].useFunc = PB.Stash.EquipCallingCard
Config.ItemCategories["namecol"].useFunc = PB.Stash.EquipColouredName

-- Net events
RegisterNetEvent("pb:RequestStash", function()
    local src = source
    local ply = PB.Accounts:Get(src)
    if not ply then return false end
    TriggerClientEvent("pb:ReceiveStash", src, ply.stash)
end)

RegisterNetEvent("pb:PurchaseItem", function(item)
    local src = source
    PB.Stash:PurchaseItem(src, item)
end)