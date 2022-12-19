-- Categories
Config.ItemCategories = {
    ["tints"] = {
        label = "Tints",
        desc = "Apply tint to weapon"
    },
    ["taunts"] = {
        label = "Taunts",
        desc = "Apply tint to weapon"
    },
    ["namecol"] = {
        label = "Name Colour",
        desc = "Apply tint to weapon"
    },
    ["callingcard"] = {
        label = "Calling Cards",
        desc = "Apply tint to weapon"
    },
    ["clothing"] = {
        label = "Clothing",
        desc = "Apply tint to weapon"
    }
}

-- Items
Config.Items = {
    -- Name colours

    -- Taunts

    -- Calling cards
    ["calling_fng"] = { label = "FNG", category = "calling_basic", card = "fng.png", max = 1 }

    -- Clothing
}

-- Auto add tints
local weaponImg = {
    ["tint_pistol_green"] = "https://i.imgur.com/GbCj9px.png",
    ["tint_appistol_army"] = "https://i.imgur.com/KFkKvbZ.png",
    ["tint_carbinerifle_pink"] = "https://i.imgur.com/JCYEXm0.png",
    ["tint_mg_blue"] = "https://i.imgur.com/c6NJLSi.png",
    ["tint_compactrifle_platinum"] = "https://i.imgur.com/Thy7Ay6.png",
    ["tint_pistol_pink"] = "https://i.imgur.com/GLjRdf5.png",
    ["tint_appistol_pink"] = "https://i.imgur.com/Jx0jjjf.png",
    ["tint_heavypistol_pink"] = "https://i.imgur.com/NLZ5yEj.png",
    ["tint_minismg_pink"] = "https://i.imgur.com/xjCLTFX.png",
    ["tint_microsmg_pink"] = "https://i.imgur.com/l7K20v6.png",
    ["tint_musket_pink"] = "https://i.imgur.com/j2L0SkQ.png",
    ["tint_assaultrifle_pink"] = "https://i.imgur.com/EB3bkhJ.png",
    ["tint_compactrifle_pink"] = "https://i.imgur.com/0gVK1GH.png",
    ["tint_combatpistol_green"] = "https://i.imgur.com/DnLyqNi.png",
    ["tint_assaultrifle_green"] = "https://i.imgur.com/qtyyEPC.png",
    ["tint_minismg_green"] = "https://i.imgur.com/HnbA1YO.png",
    ["tint_mg_green"] = "https://i.imgur.com/3fNVFPS.png",
    ["tint_shotgun_green"] = "https://i.imgur.com/TSnqWqW.png",
    ["tint_sawnoffshotgun_orange"] = "https://i.imgur.com/fp0ZFWv.png",
    ["tint_revolver_orange"] = "https://i.imgur.com/XIMqwzo.png",
    ["tint_marksmanpistol_orange"] = "https://i.imgur.com/HST8otN.png",
    ["tint_bullpuprifle_orange"] = "https://i.imgur.com/tV8gspO.png",
    ["tint_machinepistol_orange"] = "https://i.imgur.com/gGS255z.png"
}
local baseWeapons = {["pistol"] = "Pistol", ["combatpistol"] = "Combat Pistol", ["appistol"] = "AP Pistol", ["pistol50"] = "Pistol 50", ["heavypistol"] = "Heaavy Pistol",
["marksmanpistol"] = "Marksman Pistol", ["revolver"] = "Revolver", ["microsmg"] = "Scorpion", ["smg"] = "SMG", ["combatpdw"] = "Combat PDW", ["machinepistol"] = "Machine Pistol",
["minismg"] = "UZI", ["pumpshotgun"] = "Pump Shotgun", ["sawnoffshotgun"] = "Sawnoff", ["assaultshotgun"] = "Assault Shotgun", ["bullpupshotgun"] = "Bullpup Shotgun",
["musket"] = "Musket", ["assaultrifle"] = "Assault Rifle", ["carbinerifle"] = "Carbine Rifle", ["advancedrifle"] = "Advanced Rifle", ["specialcarbine"] = "Special Carbine",
["bullpuprifle"] = "Bullpup Rifle", ["compactrifle"] = "Draco", ["mg"] = "MG", ["combatmg"] = "Combat MG", ["gusenberg"] = "Gusenberg", ["sniperrifle"] = "Sniper", 
["heavysniper"] = "Heavy Sniper", ["marksmanrifle"] = "Marksman Rifle"}
local baseTints = {[1] = "Green", [2] = "Gold", [3] = "Pink", [4] = "Army", [5] = "Blue", [6] = "Orange", [7] = "Platinum"}
for k, v in pairs(baseWeapons) do
    for x, y in pairs(baseTints) do
        local img = ""
        if weaponImg["tint_" .. k .. "_" .. string.lower(y)] then 
            img = weaponImg["tint_" .. k .. "_" .. string.lower(y)]
        end
        Config.Items["tint_" .. k .. "_" .. string.lower(y)] = { label = v .. ": " .. y .. " Tint", max = 1, category = "tints", wep = "weapon_" .. k, tint = x, img = img }
    end
end