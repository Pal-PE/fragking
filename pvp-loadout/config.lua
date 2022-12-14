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
    -- Melee
    ["wep_bat"] = { label = "Bat", category = "weps_melee", type = "weapon", weapon = "weapon_bat", img = "WEAPON_BAT.png" },
    -- Pistols
    ["wep_pistol"] = { label = "Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_pistol", img = "WEAPON_PISTOL.png" },
    --["wep_pistol_mk2"] = { label = "Pistol Mk2", category = "weps_secondary", type = "weapon", weapon = "weapon_pistol_mk2", img = "WEAPON_PISTOL.png" },
    ["wep_combatpistol"] = { label = "Cmbt Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_combatpistol", img = "WEAPON_COMBATPISTOL.png" },
    ["wep_appistol"] = { label = "AP Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_appistol", img = "WEAPON_APPISTOL.png" },
    --["wep_stungun"] = { label = "Stungun", category = "weps_secondary", type = "weapon", weapon = "weapon_stungun", img = "WEAPON_STUNGUN.png" },
    ["wep_pistol50"] = { label = "Pistol 50", category = "weps_secondary", type = "weapon", weapon = "weapon_pistol50", img = "WEAPON_PISTOL50.png" },
    --["wep_snspistol"] = { label = "SNS Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_snspistol", img = "WEAPON_SNSPISTOL.png" },
    --["wep_snspistol_mk2"] = { label = "SNS Pistol Mk2", category = "weps_secondary", type = "weapon", weapon = "weapon_snspistol_mk2", img = "WEAPON_SNSPISTOL.png" },
    ["wep_heavypistol"] = { label = "Heavy Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_heavypistol", img = "WEAPON_PISTOL50.png" },
    --["wep_vintagepistol"] = { label = "Vintage Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_vintagepistol", img = "WEAPON_REVOLVER.png" },
    --["wep_flaregun"] = { label = "Flare Gun", category = "weps_secondary", type = "weapon", weapon = "weapon_flaregun", img = "WEAPON_FLARE.png" },
    ["wep_marksmanpistol"] = { label = "Marksman Pistol", category = "weps_secondary", type = "weapon", weapon = "weapon_marksmanpistol", img = "WEAPON_DBSHOTGUN.png" },
    ["wep_revolver"] = { label = "Revolver", category = "weps_secondary", type = "weapon", weapon = "weapon_revolver", img = "WEAPON_REVOLVER.png" },
    --["wep_revolver_mk2"] = { label = "Revolver Mk2", category = "weps_secondary", type = "weapon", weapon = "weapon_revolver_mk2", img = "WEAPON_REVOLVER.png" },
    --["wep_doubleaction"] = { label = "Double Action", category = "weps_secondary", type = "weapon", weapon = "weapon_doubleaction", img = "WEAPON_REVOLVER.png" },
    -- SMGS
    ["wep_microsmg"] = { label = "UZI", category = "weps_secondary", type = "weapon", weapon = "weapon_microsmg", img = "WEAPON_MICROSMG.png" },
    ["wep_smg"] = { label = "SMG", category = "weps_secondary", type = "weapon", weapon = "weapon_smg", img = "WEAPON_SMG.png" },
    --["wep_smg_mk2"] = { label = "SMG Mk2", category = "weps_secondary", type = "weapon", weapon = "weapon_smg_mk2", img = "WEAPON_SMG.png" },
    --["wep_assaultsmg"] = { label = "Assault SMG", category = "weps_secondary", type = "weapon", weapon = "weapon_assaultsmg", img = "WEAPON_ASSAULTSMG.png" },
    ["wep_combatpdw"] = { label = "PDW", category = "weps_secondary", type = "weapon", weapon = "weapon_combatpdw", img = "WEAPON_ASSAULTSMG.png" },
    ["wep_machinepistol"] = { label = "TEC9", category = "weps_secondary", type = "weapon", weapon = "weapon_machinepistol", img = "WEAPON_MACHINEPISTOL.png" },
    ["wep_minismg"] = { label = "Scorpion", category = "weps_secondary", type = "weapon", weapon = "weapon_minismg", img = "" },
    -- Shotguns
    ["wep_pumpshotgun"] = { label = "Pump Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_pumpshotgun", img = "WEAPON_PUMPSHOTGUN.png" },
    --["wep_pumpshotgun_mk2"] = { label = "Pump Shotgun Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_pumpshotgun_mk2", img = "WEAPON_PUMPSHOTGUN.png" },
    ["wep_sawnoffshotgun"] = { label = "Sawnoff", category = "weps_primary", type = "weapon", weapon = "weapon_sawnoffshotgun", img = "WEAPON_DBSHOTGUN.png" },
    ["wep_assaultshotgun"] = { label = "Assault Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_assaultshotgun", img = "WEAPON_ASSAULTSHOTGUN.png" },
    ["wep_bullpupshotgun"] = { label = "Bullpup Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_bullpupshotgun", img = "WEAPON_BULLPUPRIFLE.png" },
    ["wep_musket"] = { label = "Musket", category = "weps_primary", type = "weapon", weapon = "weapon_musket", img = "WEAPON_DBSHOTGUN.png" },
    --["wep_heavyshotgun"] = { label = "Heavy Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_heavyshotgun", img = "WEAPON_BULLPUPRIFLE.png" },
    --["wep_dbshotgun"] = { label = "Doublebarrel", category = "weps_primary", type = "weapon", weapon = "weapon_dbshotgun", img = "WEAPON_DBSHOTGUN.png" },
    --["wep_autoshotgun"] = { label = "Auto Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_autoshotgun", img = "WEAPON_ASSAULTSHOTGUN.png" },
    --["wep_combatshotgun"] = { label = "Combat Shotgun", category = "weps_primary", type = "weapon", weapon = "weapon_combatshotgun", img = "WEAPON_ASSAULTSHOTGUN.png" },
    -- Assault Riffles
    ["wep_assaultrifle"] = { label = "Assault Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_assaultrifle", img = "WEAPON_ASSAULTRIFLE.png" },
    --["wep_assaultrifle_mk2"] = { label = "Assault Rifle Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_assaultrifle_mk2", img = "WEAPON_ASSAULTRIFLE.png" },
    ["wep_carbinerifle"] = { label = "Carbine Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_carbinerifle", img = "WEAPON_CARBINERIFLE.png" },
    --["wep_assaultrifle_mk2"] = { label = "Assault Rifle Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_carbinerifle_mk2", img = "WEAPON_CARBINERIFLE.png" },
    ["wep_advancedrifle"] = { label = "Advanced Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_advancedrifle", img = "WEAPON_ADVANCEDRIFLE.png" },
    ["wep_specialcarbine"] = { label = "Special Carbine", category = "weps_primary", type = "weapon", weapon = "weapon_specialcarbine", img = "WEAPON_SPECIALCARBINE.png" },
    --["wep_specialcarbine_mk2"] = { label = "Special Carbine Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_specialcarbine_mk2", img = "WEAPON_SPECIALCARBINE.png" },
    ["wep_bullpuprifle"] = { label = "Bullpup Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_bullpuprifle", img = "WEAPON_BULLPUPRIFLE" },
    --["wep_bullpuprifle_mk2"] = { label = "Bullpup Rifle Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_bullpuprifle_mk2", img = "WEAPON_BULLPUPRIFLE" },
    ["wep_compactrifle"] = { label = "Draco", category = "weps_primary", type = "weapon", weapon = "weapon_compactrifle", img = "WEAPON_COMPACTRIFLE.png" },
    --["wep_militaryrifle"] = { label = "Military Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_militaryrifle", img = "WEAPON_CARBINERIFLE.png" },
    --["wep_heavyrifle"] = { label = "Heavy Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_heavyrifle", img = "WEAPON_CARBINERIFLE.png" },
    --["wep_tacticalrifle"] = { label = "Tactical Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_tacticalrifle", img = "WEAPON_CARBINERIFLE.png" },
    -- LMG
    ["wep_mg"] = { label = "MG", category = "weps_primary", type = "weapon", weapon = "weapon_mg", img = "WEAPON_COMBATMG.png" },
    ["wep_combatmg"] = { label = "Combat MG", category = "weps_primary", type = "weapon", weapon = "weapon_combatmg", img = "WEAPON_COMBATMG.png" },
    --["wep_combatmg_mk2"] = { label = "Combat MG Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_combatmg_mk2", img = "WEAPON_COMBATMG.png" },
    ["wep_gusenberg"] = { label = "Gusenberg", category = "weps_primary", type = "weapon", weapon = "weapon_gusenberg", img = "" },
    -- Snipers
    ["wep_sniperrifle"] = { label = "Sniper Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_sniperrifle", img = "" },
    ["wep_heavysniper"] = { label = "Heavy Sniper", category = "weps_primary", type = "weapon", weapon = "weapon_heavysniper", img = "" },
    --["wep_heavysniper_mk2"] = { label = "Heavy Sniper Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_heavysniper_mk2", img = "" },
    ["wep_marksmanrifle"] = { label = "Marksman Rifle", category = "weps_heavy", type = "weapon", weapon = "weapon_marksmanrifle", img = "" },
    --["wep_marksmanrifle_mk2"] = { label = "Marksman Rifle Mk2", category = "weps_primary", type = "weapon", weapon = "weapon_marksmanrifle_mk2", img = "" },
    --["wep_precisionrifle"] = { label = "Precision Rifle", category = "weps_primary", type = "weapon", weapon = "weapon_precisionrifle", img = "" },
    -- Gadgets
    ["gadget_bandage"] = { label = "Bandage", category = "consumables", type = "gadget", cooldown = 3, img = "BANDAGE.png" },
    ["gadget_medkit"] = { label = "Med Kit", category = "consumables", type = "gadget", cooldown = 10, img = "MEDKIT.png" },
    ["gadget_armour"] = { label = "Armour", category = "consumables", type = "gadget", cooldown = 15, img = "ARMOUR.png" }
}