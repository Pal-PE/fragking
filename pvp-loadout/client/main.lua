-- Variables
currentLoadout = {}
local selectedWeapon = false
loadoutLocked = true
local displayLoadout = true
local ClearLoadout, ForceLoadout, LockLoadout, UseItem

-- Clear loadout to default, and remove ped weapons
function ClearLoadout()
    currentLoadout = {}
    TriggerServerEvent("pb-loadout:RemoveWeapon")
    UpdateUI()
end

-- Force a loadout on the player
function ForceLoadout(data, use)
    print("forcing loadout")
    selectedWeapon = false
    RemoveAllPedWeapons(PlayerPedId())
    currentLoadout = data
    for k, v in pairs(currentLoadout) do
        if Config.Items[v.item].type == "gadget" then
            v.cooldown = false
        end
    end
    UpdateUI()
    if use then 
        ForceUse(use)
    end
end

-- Lock loadout, not allowing for it to be changed without force
function LockLoadout()
    loadoutLocked = value
end

-- Update the NUI
function UpdateUI()
    local loadoutData = {}
    for k, v in pairs(currentLoadout) do
        loadoutData[k] = {
            slot = k,
            label = Config.Items[v.item].label,
            img = Config.Items[v.item].img,
            cooldown = v.cooldown
        }
    end
    SendNUIMessage({type = "SetLoadout", loadout = loadoutData})
end

-- Logic for using an item
function UseItem(item)
    -- Make sure the item exists
    if not item or not item.item or not Config.Items[item.item] then
        TriggerEvent("pb:Notification", "ERROR", "Error occured while using item", true)
        return false 
    end
    -- Handle weapons
    if Config.Items[item.item].type == "weapon" then
    if not item.item == selectedWeapon then
        selectedWeapon = item.item
        TriggerServerEvent("pb-loadout:GetWeapon", item.item)
    else
        selectedWeapon = false
        TriggerServerEvent("pb-loadout:RemoveWeapon", item.item)
    end
    -- Handle gadgets
    elseif Config.Items[item.item].type == "gadget" then
        if not item.cooldown then
            item.cooldown = true
            Gadgets[item.item]()
            UpdateUI()
            CreateThread(function()
                Wait(Config.Items[item.item].cooldown*1000)
                item.cooldown = false
                UpdateUI()
            end)
            TriggerEvent("pb:Notification", "SUCCESS", "Used " .. Config.Items[item.item].label .. ".", true)
        else
            TriggerEvent("pb:Notification", "ERROR", Config.Items[item.item].label .. " is on cooldown.", true)
        end
    end
end

-- Force the user to use a item, good for auto equipping
function ForceUse(slot)
    selectedWeapon = false
    UseItem(currentLoadout[slot])
end

-- Check for keypresses and block default weapon wheel
CreateThread(function()
    while true do
        Wait(1)
        BlockWeaponWheelThisFrame()
        if IsControlJustReleased(0, 157) then -- 1
            if currentLoadout[1] then
                UseItem(currentLoadout[1])
            end
        elseif IsControlJustReleased(0, 158) then -- 2
            if currentLoadout[2] then
                UseItem(currentLoadout[2])
            end
        elseif IsControlJustReleased(0, 160) then -- 3
            if currentLoadout[3] then
                UseItem(currentLoadout[3])
            end
        elseif IsControlJustReleased(0, 164) then -- 4
            if currentLoadout[4] then
                UseItem(currentLoadout[4])
            end
        elseif IsControlJustReleased(0, 165) then -- 5
            if currentLoadout[5] then
                UseItem(currentLoadout[5])
            end
        end
    end
end)

-- Net events
RegisterNetEvent("pb-loadout:ClearLoadout", function()
    ClearLoadout()
end)

RegisterNetEvent("pb-loadout:ForceLoadout", function(data)
    ForceLoadout(data)
end)

RegisterNetEvent("pb-loadout:LockLoadout", function(value)
    LockLoadout(value)
end)

RegisterNetEvent("pb-loadout:ForceUse", function(slot)
    ForceUse(slot)
end)