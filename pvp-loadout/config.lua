Config = {}

Config.Categories = {
    ["weapons"] = {
        label = "Weapons"
    },
    ["consumables"] = {
        label = "Consumables"
    }
}

Config.Items = {
    -- Pistols
    ["wep_pistol"] = { label = "Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_pistol", img = "" },
    --["wep_pistol_mk2"] = { label = "Pistol Mk2", category = "weps_secondary", type = "weapon", weapon = "weapon_pistol_mk2", img = "" },
    ["wep_combatpistol"] = { label = "Cmbt Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_combatpistol", img = "" },
    ["wep_appistol"] = { label = "AP Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_appistol", img = "" },
    --["wep_stungun"] = { label = "Stungun", category = "weps_secondary", type = "weapon", weapon = "weapon_stungun", img = "" },
    ["wep_pistol50"] = { label = "Pistol 50", category = "weps_secondary", type = "weapon", weapon = "weapon_pistol50", img = "" },
    --["wep_snspistol"] = { label = "SNS Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_snspistol", img = "" },
    --["wep_snspistol_mk2"] = { label = "SNS Pistol Mk2", category = "weps_secondary", type = "weapon", weapon = "weapon_snspistol_mk2", img = "" },
    ["wep_heavypistol"] = { label = "Heavy Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_heavypistol", img = "" },
    --["wep_vintagepistol"] = { label = "Vintage Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_vintagepistol", img = "" },
    --["wep_flaregun"] = { label = "Flare Gun", category = "weps_secondary", type = "weapon", weapon = "weapon_flaregun", img = "" },
    ["wep_marksmanpistol"] = { label = "Marksman Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_marksmanpistol", img = "" },
    ["wep_revolver"] = { label = "Revolver", category = "weps_secondary", type = "weapon", weapon = "weapon_revolver", img = "" },
    --["wep_revolver_mk2"] = { label = "Revolver Mk2", category = "weps_secondary", type = "weapon", weapon = "weapon_revolver_mk2", img = "" },
    --["wep_doubleaction"] = { label = "Double Action", category = "weps_secondary", type = "weapon", weapon = "weapon_doubleaction", img = "" },
    -- SMGS
    ["wep_microsmg"] = { label = "UZI", category = "weps_secondary", type = "weapon", weapon = "weapon_microsmg", img = "" },
    ["wep_smg"] = { label = "SMG", category = "weps_secondary", type = "weapon", weapon = "weapon_smg", img = "" },
    --["wep_smg_mk2"] = { label = "SMG Mk2", category = "weps_secondary", type = "weapon", weapon = "weapon_smg_mk2", img = "" },
    --["wep_assaultsmg"] = { label = "Assault SMG", category = "weps_secondary", type = "weapon", weapon = "weapon_assaultsmg", img = "" },
    ["wep_combatpdw"] = { label = "PDW", category = "weps_secondary", type = "weapon", weapon = "weapon_combatpdw", img = "" },
    ["wep_machinepistol"] = { label = "TEC9", category = "weps_secondary", type = "weapon", weapon = "weapon_machinepistol", img = "" },
    --["wep_minismg"] = { label = "Scorpion", category = "weps_secondary", type = "weapon", weapon = "weapon_minismg", img = "" },
    -- Shotguns
    ["wep_pumpshotgun"] = { label = "Pump Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_pumpshotgun", img = "" },
    --["wep_pumpshotgun_mk2"] = { label = "Pump Shotgun Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_pumpshotgun_mk2", img = "" },
    ["wep_sawnoffshotgun"] = { label = "Sawnoff", category = "weps_primary", type = "weapon", weapon = "weapon_sawnoffshotgun", img = "" },
    ["wep_assaultshotgun"] = { label = "Assault Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_assaultshotgun", img = "" },
    ["wep_bullpupshotgun"] = { label = "Bullpup Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_bullpupshotgun", img = "" },
    ["wep_musket"] = { label = "Musket", category = "weps_primary", type = "weapon", weapon = "weapon_musket", img = "" },
    --["wep_heavyshotgun"] = { label = "Heavy Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_heavyshotgun", img = "" },
    --["wep_dbshotgun"] = { label = "Doublebarrel", category = "weps_primary", type = "weapon", weapon = "weapon_dbshotgun", img = "" },
    --["wep_autoshotgun"] = { label = "Auto Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_autoshotgun", img = "" },
    --["wep_combatshotgun"] = { label = "Combat Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_combatshotgun", img = "" },
    -- Assault Riffles
    ["wep_assaultrifle"] = { label = "Assault Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_assaultrifle", img = "WEAPON_ASSAULTRIFLE.png" },
    --["wep_assaultrifle_mk2"] = { label = "Assault Rifle Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_assaultrifle_mk2", img = "" },
    ["wep_carbinerifle"] = { label = "Carbine Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_carbinerifle", img = "" },
    --["wep_assaultrifle_mk2"] = { label = "Assault Rifle Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_carbinerifle_mk2", img = "" },
    ["wep_advancedrifle"] = { label = "Advanced Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_advancedrifle", img = "" },
    ["wep_specialcarbine"] = { label = "Special Carbine", category = "weps_primary", type = "weapon", weapon = "weapon_specialcarbine", img = "" },
    --["wep_specialcarbine_mk2"] = { label = "Special Carbine Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_specialcarbine_mk2", img = "" },
    ["wep_bullpuprifle"] = { label = "Bullpup Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_bullpuprifle", img = "" },
    --["wep_bullpuprifle_mk2"] = { label = "Bullpup Rifle Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_bullpuprifle_mk2", img = "" },
    ["wep_compactrifle"] = { label = "Draco", category = "weps_primary", type = "weapon", weapon = "weapon_compactrifle", img = "" },
    --["wep_militaryrifle"] = { label = "Military Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_militaryrifle", img = "" },
    --["wep_heavyrifle"] = { label = "Heavy Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_heavyrifle", img = "" },
    --["wep_tacticalrifle"] = { label = "Tactical Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_tacticalrifle", img = "" },
    -- LMG
    ["wep_mg"] = { label = "MG", category = "weps_primary", type = "weapon", weapon = "weapon_mg", img = "" },
    ["wep_combatmg"] = { label = "Combat MG", category = "weps_primary", type = "weapon", weapon = "weapon_combatmg", img = "" },
    --["wep_combatmg_mk2"] = { label = "Combat MG Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_combatmg_mk2", img = "" },
    ["wep_gusenberg"] = { label = "Gusenberg", category = "weps_primary", type = "weapon", weapon = "weapon_gusenberg", img = "" },
    -- Snipers
    ["wep_sniperrifle"] = { label = "Sniper Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_sniperrifle", img = "" },
    ["wep_heavysniper"] = { label = "Heavy Sniper", category = "weps_primary", type = "weapon", weapon = "weapon_heavysniper", img = "" },
    --["wep_heavysniper_mk2"] = { label = "Heavy Sniper Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_heavysniper_mk2", img = "" },
    ["wep_marksmanrifle"] = { label = "Marksman Rifle", category = "weps_heavy", type = "weapon", weapon = "weapon_marksmanrifle", img = "" },
    --["wep_marksmanrifle_mk2"] = { label = "Marksman Rifle Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_marksmanrifle_mk2", img = "" },
    --["wep_precisionrifle"] = { label = "Precision Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_precisionrifle", img = "" },
    -- Gadgets
    ["gadget_bandage"] = { label = "Bandage", category = "consumables", type = "gadget", cooldown = 3 },
    ["gadget_medkit"] = { label = "Med Kit", category = "consumables", type = "gadget", cooldown = 10 },
    ["gadget_joint"] = { label = "Joint", category = "consumables", type = "gadget", cooldown = 3 },
    ["gadget_armour"] = { label = "Armour Plate", category = "consumables", type = "gadget", cooldown = 15 }
}