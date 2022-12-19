-- Variables
local menuPool = NativeUI.CreatePool()
local weaponSelectMenu = NativeUI.CreateMenu("WEAPON SELECT", "")
menuPool:Add(weaponSelectMenu)
local primaryMenu = menuPool:AddSubMenu(weaponSelectMenu, "Select Primary")
local secondaryMenu = menuPool:AddSubMenu(weaponSelectMenu, "Select Secondary")
local DisplayWeaponSelect

-- Loop through all items and add them to their related sub menu
for k, v in pairs(Config.Items) do
    if v.category == "weps_primary" then
        local newWeapon = NativeUI.CreateItem(v.label)
        newWeapon.itemId = k
        primaryMenu:AddItem(newWeapon)
    elseif v.category == "weps_secondary" then
        local newWeapon = NativeUI.CreateItem(v.label)
        newWeapon.itemId = k
        secondaryMenu:AddItem(newWeapon)
    end
end

-- Handle primary weapon being selected
primaryMenu.OnItemSelect = function(sender, item, index)
    if not loadoutLocked then
        TriggerServerEvent("pb-loadout:RemoveWeapon")
        currentLoadout[1] = {
            item = item.itemId
        }
        ForceUse(1)
        UpdateUI()
    end
end

-- Handle secondary weapon being selected
secondaryMenu.OnItemSelect = function(sender, item, index)
    if not loadoutLocked then
        TriggerServerEvent("pb-loadout:RemoveWeapon")
        currentLoadout[2] = {
            item = item.itemId
        }
        ForceUse(2)
        UpdateUI()
    end
end

-- Process menus
CreateThread(function()
    while true do
        Wait(0)
        menuPool:ProcessMenus()
        menuPool:MouseControlsEnabled(false)
        menuPool:MouseEdgeEnabled(false)
        menuPool:ControlDisablingEnabled(false)
    end
end)

-- Open the weapon select menu
function DisplayWeaponSelect(value)
    weaponSelectMenu:Visible(value)
end

-- Net events
AddEventHandler("pb-loadout:DisplayWeaponSelect", function(value)
    OpenWeaponSelect(value)
end)