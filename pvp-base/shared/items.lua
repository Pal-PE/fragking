-- Categories
Config.ItemCategories = {
    ["tints"] = {
        label = "Tints",
        desc = "Apply tint to your weapon, auto applied in all gamemodes."
    },
    ["namecol"] = {
        label = "Name Colour",
        desc = "Change your name colour in chat, death info boxes, and the killfeed."
    },
    ["callingcards"] = {
        label = "Calling Cards",
        desc = "Show off with a title upon killing, or being killed by an enemy."
    },
    ["clothing"] = {
        label = "Clothing",
        desc = "Allows for the use of this item within the wardrobe."
    }
}

-- Items
Config.Items = {
    -- Name colours
    ["col_white"] = { label = "White Name Colour", category = "namecol", colour = "linear-gradient(90deg, #ffffff 0%, #ffffff 100%)", max = 1 },
    ["col_pink"] = { label = "Pink Name Colour", category = "namecol", colour = "linear-gradient(90deg, #872ab5 0%, #872ab5 100%)", max = 1 },
    ["col_blue"] = { label = "Blue Name Colour", category = "namecol", colour = "linear-gradient(90deg, #2a6ab8 0%, #2a6ab8 100%)", max = 1 },
    ["col_green"] = { label = "Green Name Colour", category = "namecol", colour = "linear-gradient(90deg, #329c1a 0%, #329c1a 100%)", max = 1 },
    ["col_purple"] = { label = "Purple Name Colour", category = "namecol", colour = "linear-gradient(90deg, #551a9c 0%, #551a9c 100%)", max = 1 },
    ["col_orange"] = { label = "Orange Name Colour", category = "namecol", colour = "linear-gradient(90deg, #bf5915 0%, #bf5915 100%)", max = 1 },
    ["col_red"] = { label = "Red Name Colour", category = "namecol", colour = "linear-gradient(90deg, #cc0c0c 0%, #cc0c0c 100%)", max = 1 },
    ["col_yellow"] = { label = "Yellow Name Colour", category = "namecol", colour = "linear-gradient(90deg, #bab514 0%, #bab514 100%)", max = 1 },
    ["col_cyan"] = { label = "Cyan Name Colour", category = "namecol", colour = "linear-gradient(90deg, #1a8aa1 0%, #1a8aa1 100%)", max = 1 },

    ["col_mimosa"] = { label = "Mimosa Name Colour", category = "namecol", colour = "linear-gradient(90deg, #d53369 0%, #daae51 100%)", max = 1 },
    ["col_lilly"] = { label = "Lilly Name Colour", category = "namecol", colour = "linear-gradient(90deg, #efd5ff 0%, #515ada 100%)", max = 1 },
    ["col_breeze"] = { label = "Breeze Name Colour", category = "namecol", colour = "linear-gradient(90deg, #1CB5E0 0%, #000851 100%)", max = 1 },
    ["col_disco"] = { label = "Disco Name Colour", category = "namecol", colour = "linear-gradient(90deg, #FC466B 0%, #3F5EFB 100%)", max = 1 },
    ["col_seasalt"] = { label = "Sea Salt Name Colour", category = "namecol", colour = "linear-gradient(90deg, #4b6cb7 0%, #182848 100%)", max = 1 },
    ["col_sandstorm"] = { label = "Sandstorm Name Colour", category = "namecol", colour = "linear-gradient(90deg, #fcff9e 0%, #c67700 100%)", max = 1 },
    ["col_lemontwist"] = { label = "Lemon Twist Name Colour", category = "namecol", colour = "linear-gradient(90deg, #3CA55C 0%, #B5AC49 100%)", max = 1 },

    -- Calling cards
    ["calling_fng"] = { label = "FNG Calling Card", category = "callingcards", title = "F.N.G.", card = "https://i.imgur.com/oMdDihE.png", img = "https://i.imgur.com/oMdDihE.png", max = 1 },
    ["calling_veteran"] = { label = "Veteran Calling Card", category = "callingcards", title = "Veteran", card = "https://i.imgur.com/oMdDihE.png", img = "https://i.imgur.com/oMdDihE.png", max = 1 },
    ["calling_prodigy"] = { label = "Prodigy Calling Card", category = "callingcards", title = "Prodigy", card = "https://i.imgur.com/oMdDihE.png", img = "https://i.imgur.com/oMdDihE.png", max = 1 },

    ["calling_day1"] = { label = "Day 1 Calling Card", category = "callingcards", title = "Day 1", card = "https://i.imgur.com/jLIqB80.png", img = "https://i.imgur.com/jLIqB80.png", max = 1 },
    ["calling_livinitup"] = { label = "Livin' It Up Calling Card", category = "callingcards", title = "Livin' It Up", card = "https://i.imgur.com/jLIqB80.png", img = "https://i.imgur.com/jLIqB80.png", max = 1 },
    
    ["calling_ballas"] = { label = "Ballas Calling Card", category = "callingcards", title = "Ballas", card = "https://i.imgur.com/gVDtDNF.png", img = "https://i.imgur.com/gVDtDNF.png", max = 1 },
    ["calling_publicenemy"] = { label = "Public Enemy #1 Calling Card", category = "callingcards", title = "Public Enemy #1", card = "https://i.imgur.com/gVDtDNF.png", img = "https://i.imgur.com/gVDtDNF.png", max = 1 },
    ["calling_gangshit"] = { label = "GANG SHIT Calling Card", category = "callingcards", title = "GANG SHIT", card = "https://i.imgur.com/gVDtDNF.png", img = "https://i.imgur.com/gVDtDNF.png", max = 1 },
    ["calling_backstabber"] = { label = "Backstabber Calling Card", category = "callingcards", title = "Backstabber", card = "https://i.imgur.com/gVDtDNF.png", img = "https://i.imgur.com/gVDtDNF.png", max = 1 },

    ["calling_<3"] = { label = "<3 Calling Card", category = "callingcards", title = "<3", card = "https://i.imgur.com/6H4y9MG.png", img = "https://i.imgur.com/6H4y9MG.png", max = 1 },
    ["calling_ggwp"] = { label = "GGWP Calling Card", category = "callingcards", title = "GGWP", card = "https://i.imgur.com/6H4y9MG.png", img = "https://i.imgur.com/6H4y9MG.png", max = 1 },
    ["calling_sweetandsour"] = { label = "Sweet & Sour Calling Card", category = "callingcards", title = "Sweet & Sour", card = "https://i.imgur.com/6H4y9MG.png", img = "https://i.imgur.com/6H4y9MG.png", max = 1 },
    ["calling_unlucky"] = { label = "Unlucky! Calling Card", category = "callingcards", title = "Unlucky!", card = "https://i.imgur.com/6H4y9MG.png", img = "https://i.imgur.com/6H4y9MG.png", max = 1 },

    ["calling_ezstuff"] = { label = "EZ Stuff Calling Card", category = "callingcards", title = "EZ Stuff", card = "https://i.imgur.com/EXv4lPG.png", img = "https://i.imgur.com/EXv4lPG.png", max = 1 },
    ["calling_nosweat"] = { label = "No Sweat Calling Card", category = "callingcards", title = "No Sweat", card = "https://i.imgur.com/EXv4lPG.png", img = "https://i.imgur.com/EXv4lPG.png", max = 1 },
    ["calling_walkinthepark"] = { label = "Walk In The Park Calling Card", category = "callingcards", title = "Walk In The Park", card = "https://i.imgur.com/EXv4lPG.png", img = "https://i.imgur.com/EXv4lPG.png", max = 1 },


    ["calling_thelaw"] = { label = "The Law Calling Card", category = "callingcards", title = "The Law", card = "https://i.imgur.com/HjSGBxf.png", img = "https://i.imgur.com/HjSGBxf.png", max = 1 },
    ["calling_justice"] = { label = "Justice Calling Card", category = "callingcards", title = "Justice", card = "https://i.imgur.com/HjSGBxf.png", img = "https://i.imgur.com/HjSGBxf.png", max = 1 },
    ["calling_lawandorder"] = { label = "Law & Order Calling Card", category = "callingcards", title = "Law & Order", card = "https://i.imgur.com/HjSGBxf.png", img = "https://i.imgur.com/HjSGBxf.png", max = 1 },

    ["calling_simplereally"] = { label = "Simple Really Calling Card", category = "callingcards", title = "Simple Really", card = "https://i.imgur.com/VQ1Kmye.png", img = "https://i.imgur.com/VQ1Kmye.png", max = 1 },
    ["calling_calculated"] = { label = "Calculated Calling Card", category = "callingcards", title = "Calculated", card = "https://i.imgur.com/VQ1Kmye.png", img = "https://i.imgur.com/VQ1Kmye.png", max = 1 },

    ["calling_nbk"] = { label = "NBK Calling Card", category = "callingcards", title = "NBK", card = "https://i.imgur.com/IJz3mX8.png", img = "https://i.imgur.com/IJz3mX8.png", max = 1 },
    ["calling_itspersonal"] = { label = "It's Personal Calling Card", category = "callingcards", title = "It's Personal", card = "https://i.imgur.com/IJz3mX8.png", img = "https://i.imgur.com/IJz3mX8.png", max = 1 },

    ["calling_allin"] = { label = "All In Calling Card", category = "callingcards", title = "All In", card = "https://i.imgur.com/wf7QHEn.png", img = "https://i.imgur.com/wf7QHEn.png", max = 1 },
    ["calling_doubledown"] = { label = "Double Down Calling Card", category = "callingcards", title = "Double Down", card = "https://i.imgur.com/wf7QHEn.png", img = "https://i.imgur.com/wf7QHEn.png", max = 1 },

    ["calling_lonewolf"] = { label = "Lone Wolf Calling Card", category = "callingcards", title = "Lone Wolf", card = "https://i.imgur.com/VRR3chg.png", img = "https://i.imgur.com/VRR3chg.png", max = 1 },
    ["calling_hunted"] = { label = "Hunted Calling Card", category = "callingcards", title = "Hunted", card = "https://i.imgur.com/VRR3chg.png", img = "https://i.imgur.com/VRR3chg.png", max = 1 },


    ["calling_speeddemon"] = { label = "Speed Demon Calling Card", category = "callingcards", title = "Speed Demon", card = "https://i.imgur.com/cNXp7s1.png", img = "https://i.imgur.com/cNXp7s1.png", max = 1 },
    ["calling_fullthrottle"] = { label = "Full Throttle Calling Card", category = "callingcards", title = "Full Throtle", card = "https://i.imgur.com/cNXp7s1.png", img = "https://i.imgur.com/cNXp7s1.png", max = 1 },


    -- Clothing
    -- Buyable vanilla masks
    ["clothing_mask_moose"] = { label = "Moose Mask", category = "clothing", type = "drawable", drawable = "masks", value = 9, img = "img/masks/9.png", max = 1 },
    ["clothing_mask_orc"] = { label = "Orc Mask", category = "clothing", type = "drawable", drawable = "masks", value = 7, img = "img/masks/7.png", max = 1 },
    ["clothing_mask_snowman"] = { label = "Snowman Mask", category = "clothing", type = "drawable", drawable = "masks", value = 10, img = "img/masks/7.png", max = 1 },
    ["clothing_mask_cat"] = { label = "Cat Mask", category = "clothing", type = "drawable", drawable = "masks", value = 17, img = "img/masks/17.png", max = 1 },
    ["clothing_mask_fox"] = { label = "Fox Mask", category = "clothing", type = "drawable", drawable = "masks", value = 18, img = "img/masks/18.png", max = 1 },
    ["clothing_mask_racoon"] = { label = "Racoon Mask", category = "clothing", type = "drawable", drawable = "masks", value = 20, img = "img/masks/20.png", max = 1 },
    ["clothing_mask_bear"] = { label = "Bear Mask", category = "clothing", type = "drawable", drawable = "masks", value = 21, img = "img/masks/21.png", max = 1 },
    ["clothing_mask_penguin"] = { label = "Penguin Mask", category = "clothing", type = "drawable", drawable = "masks", value = 31, img = "img/masks/31.png", max = 1 },
    ["clothing_mask_gingerbreadhappy"] = { label = "Happy Gingerbread Mask", category = "clothing", type = "drawable", drawable = "masks", value = 33, img = "img/masks/33.png", max = 1 },
    ["clothing_mask_zombie"] = { label = "Zombie Mask", category = "clothing", type = "drawable", drawable = "masks", value = 39, img = "img/masks/39.png", max = 1 },
    ["clothing_mask_weeb"] = { label = "Weeb Mask", category = "clothing", type = "drawable", drawable = "masks", value = 44, img = "img/masks/44.png", max = 1 },
    ["clothing_mask_detective"] = { label = "Detective Mask", category = "clothing", type = "drawable", drawable = "masks", value = 45, img = "img/masks/45.png", max = 1 },
    ["clothing_mask_pumpkin"] = { label = "Pumpkin Mask", category = "clothing", type = "drawable", drawable = "masks", value = 60, img = "img/masks/60.png", max = 1 },
    ["clothing_mask_skullzombie"] = { label = "Skull Zombie Mask", category = "clothing", type = "drawable", drawable = "masks", value = 64, img = "img/masks/64.png", max = 1 },
    ["clothing_mask_bug"] = { label = "Bug Mask", category = "clothing", type = "drawable", drawable = "masks", value = 66, img = "img/masks/66.png", max = 1 },
    ["clothing_mask_satan"] = { label = "Satan Mask", category = "clothing", type = "drawable", drawable = "masks", value = 68, img = "img/masks/68.png", max = 1 },
    ["clothing_mask_angrygingerbread"] = { label = "Angry Gingerbread Mask", category = "clothing", type = "drawable", drawable = "masks", value = 74, img = "img/masks/74.png", max = 1 },
    ["clothing_mask_chicken"] = { label = "Chicken Mask", category = "clothing", type = "drawable", drawable = "masks", value = 85, img = "img/masks/85.png", max = 1 },
    ["clothing_mask_granny"] = { label = "Granny Mask", category = "clothing", type = "drawable", drawable = "masks", value = 86, img = "img/masks/86.png", max = 1 },
    ["clothing_mask_grandpa"] = { label = "Grandpa Mask", category = "clothing", type = "drawable", drawable = "masks", value = 87, img = "img/masks/87.png", max = 1 },
    ["clothing_mask_dino"] = { label = "Dino Mask", category = "clothing", type = "drawable", drawable = "masks", value = 93, img = "img/masks/93.png", max = 1 },
    ["clothing_mask_clown"] = { label = "Clown Mask", category = "clothing", type = "drawable", drawable = "masks", value = 95, img = "img/masks/95.png", max = 1 },
    ["clothing_mask_ape"] = { label = "Ape Mask", category = "clothing", type = "drawable", drawable = "masks", value = 96, img = "img/masks/96.png", max = 1 },
    ["clothing_mask_horse"] = { label = "Horse Mask", category = "clothing", type = "drawable", drawable = "masks", value = 97, img = "img/masks/97.png", max = 1 },
    ["clothing_mask_unicorn"] = { label = "Unicorn Mask", category = "clothing", type = "drawable", drawable = "masks", value = 98, img = "img/masks/98.png", max = 1 },
    ["clothing_mask_pug"] = { label = "Pug Mask", category = "clothing", type = "drawable", drawable = "masks", value = 100, img = "img/masks/100.png", max = 1 },
    ["clothing_mask_neon"] = { label = "Neon Mask", category = "clothing", type = "drawable", drawable = "masks", value = 102, img = "img/masks/102.png", max = 1 },
    ["clothing_mask_soldierzombie"] = { label = "Zombie Soldier Mask", category = "clothing", type = "drawable", drawable = "masks", value = 103, img = "img/masks/103.png", max = 1 },
    ["clothing_mask_skull"] = { label = "Skull Mask", category = "clothing", type = "drawable", drawable = "masks", value = 110, img = "img/masks/110.png", max = 1 },
    ["clothing_mask_neon2"] = { label = "Neon Mask", category = "clothing", type = "drawable", drawable = "masks", value = 124, img = "img/masks/124.png", max = 1 },
    ["clothing_mask_nvg"] = { label = "NVG Mask", category = "clothing", type = "drawable", drawable = "masks", value = 132, img = "img/masks/132.png", max = 1 },
    ["clothing_mask_bird"] = { label = "Bird Mask", category = "clothing", type = "drawable", drawable = "masks", value = 136, img = "img/masks/136.png", max = 1 },
    ["clothing_mask_cyberird"] = { label = "Cyber Bird Mask", category = "clothing", type = "drawable", drawable = "masks", value = 138, img = "img/masks/138.png", max = 1 },
    ["clothing_mask_alien"] = { label = "Alien Mask", category = "clothing", type = "drawable", drawable = "masks", value = 139, img = "img/masks/139.png", max = 1 },
    ["clothing_mask_mike"] = { label = "Mike Mask", category = "clothing", type = "drawable", drawable = "masks", value = 140, img = "img/masks/140.png", max = 1 },
    ["clothing_mask_druid"] = { label = "Druid Mask", category = "clothing", type = "drawable", drawable = "masks", value = 141, img = "img/masks/141.png", max = 1 },
    ["clothing_mask_steampunk"] = { label = "Steampunk Mask", category = "clothing", type = "drawable", drawable = "masks", value = 142, img = "img/masks/142.png", max = 1 },
    ["clothing_mask_taco"] = { label = "Taco Mask", category = "clothing", type = "drawable", drawable = "masks", value = 143, img = "img/masks/143.png", max = 1 },
    ["clothing_mask_burgershot"] = { label = "Burgershot Mask", category = "clothing", type = "drawable", drawable = "masks", value = 144, img = "img/masks/144.png", max = 1 },
    ["clothing_mask_cluckin"] = { label = "Cluckin Mask", category = "clothing", type = "drawable", drawable = "masks", value = 145, img = "img/masks/145.png", max = 1 },
    ["clothing_mask_gadget"] = { label = "Gadget Mask", category = "clothing", type = "drawable", drawable = "masks", value = 146, img = "img/masks/146.png", max = 1 },
    ["clothing_mask_coolape"] = { label = "Cool Ape Mask", category = "clothing", type = "drawable", drawable = "masks", value = 147, img = "img/masks/147.png", max = 1 },
    -- Stock vanilla masks

    -- Buyable vanilla hats

    -- Stock vanilla hats

    -- Buyable vanilla glases
    ["clothing_glasses_ski"] = { label = "Ski Goggles", category = "clothing", type = "prop", prop = "glasses", value = 25, img = "img/glasses/25", max = 1 },
    ["clothing_glasses_combat2"] = { label = "Combat Glasses 2", category = "clothing", type = "prop", prop = "glasses", value = 23, img = "img/glasses/23", max = 1 },
    ["clothing_glasses_patriot"] = { label = "Patriot Shades", category = "clothing", type = "prop", prop = "glasses", value = 21, img = "img/glasses/21", max = 1 },
    ["clothing_glasses_patriot2"] = { label = "Patriot Shades 2", category = "clothing", type = "prop", prop = "glasses", value = 22, img = "img/glasses/22", max = 1 },
    -- Stock vanilla glasses
    ["clothing_glasses_shades"] = { label = "Shades", category = "clothing", type = "prop", prop = "glasses", value = 1, img = "img/glasses/1", max = 1 },
    ["clothing_glasses_shades2"] = { label = "Shades 2", category = "clothing", type = "prop", prop = "glasses", value = 2, img = "img/glasses/2", max = 1 },
    ["clothing_glasses_glasses"] = { label = "Glasses", category = "clothing", type = "prop", prop = "glasses", value = 2, img = "img/glasses/2", max = 1 },
    ["clothing_glasses_glasses2"] = { label = "Glasses 2", category = "clothing", type = "prop", prop = "glasses", value = 2, img = "img/glasses/7", max = 1 },
    ["clothing_glasses_aviators"] = { label = "Aviators", category = "clothing", type = "prop", prop = "glasses", value = 5, img = "img/glasses/5", max = 1 },
    ["clothing_glasses_aviators2"] = { label = "Aviators 2", category = "clothing", type = "prop", prop = "glasses", value = 8, img = "img/glasses/8", max = 1 },
    ["clothing_glasses_shades3"] = { label = "Shades 3", category = "clothing", type = "prop", prop = "glasses", value = 9, img = "img/glasses/9", max = 1 },
    ["clothing_glasses_squareframe"] = { label = "Square Fames", category = "clothing", type = "prop", prop = "glasses", value = 10, img = "img/glasses/10", max = 1 },
    ["clothing_glasses_shades4"] = { label = "Shades 4", category = "clothing", type = "prop", prop = "glasses", value = 13, img = "img/glasses/13", max = 1 },
    ["clothing_glasses_combat"] = { label = "Combat Glasses", category = "clothing", type = "prop", prop = "glasses", value = 15, img = "img/glasses/15", max = 1 },
    ["clothing_glasses_glasses3"] = { label = "Glasses 3", category = "clothing", type = "prop", prop = "glasses", value = 17, img = "img/glasses/17", max = 1 },
    ["clothing_glasses_pilot"] = { label = "Pilot Goggles", category = "clothing", type = "prop", prop = "glasses", value = 24, img = "img/glasses/24", max = 1 },
    ["clothing_glasses_diving"] = { label = "Rebreather", category = "clothing", type = "prop", prop = "glasses", value = 26, img = "img/glasses/26", max = 1 },


}

-- Automatically setup tints
local baseWeapons = {["pistol"] = "Pistol", ["combatpistol"] = "Combat Pistol", ["appistol"] = "AP Pistol", ["pistol50"] = "Pistol 50", ["heavypistol"] = "Heaavy Pistol",
["marksmanpistol"] = "Marksman Pistol", ["revolver"] = "Revolver", ["microsmg"] = "Scorpion", ["smg"] = "SMG", ["combatpdw"] = "Combat PDW", ["machinepistol"] = "Machine Pistol",
["minismg"] = "UZI", ["pumpshotgun"] = "Pump Shotgun", ["sawnoffshotgun"] = "Sawnoff", ["assaultshotgun"] = "Assault Shotgun", ["bullpupshotgun"] = "Bullpup Shotgun",
["musket"] = "Musket", ["assaultrifle"] = "Assault Rifle", ["carbinerifle"] = "Carbine Rifle", ["advancedrifle"] = "Advanced Rifle", ["specialcarbine"] = "Special Carbine",
["bullpuprifle"] = "Bullpup Rifle", ["compactrifle"] = "Draco", ["mg"] = "MG", ["combatmg"] = "Combat MG", ["gusenberg"] = "Gusenberg", ["sniperrifle"] = "Sniper", 
["heavysniper"] = "Heavy Sniper", ["marksmanrifle"] = "Marksman Rifle"}
local baseTints = {[1] = "Green", [2] = "Gold", [3] = "Pink", [4] = "Army", [5] = "Blue", [6] = "Orange", [7] = "Platinum"}
for k, v in pairs(baseWeapons) do
    for x, y in pairs(baseTints) do
        Config.Items["tint_" .. k .. "_" .. string.lower(y)] = { label = v .. ": " .. y .. " Tint", max = 1, category = "tints", wep = "weapon_" .. k, tint = x, img = "img/tint_" .. k .. "_" .. string.lower(y) .. ".png" }
    end
end