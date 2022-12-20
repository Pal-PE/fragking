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


    -- Clothing
    ["clothing_mask_monkey"] = { label = "Monkey Mask", category = "clothing", type = "drawable", drawable = "masks", value = 3, img = "img/", max = 1 },
    ["clothing_mask_monkey2"] = { label = "Monkey Mask", category = "clothing", type = "drawable", drawable = "masks", value = 5, img = "img/", max = 1 },
    ["clothing_mask_santa"] = { label = "Santa Mask", category = "clothing", type = "drawable", drawable = "masks", value = 5, img = "https://i.imgur.com/wf7QHEn.png", max = 1 },

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