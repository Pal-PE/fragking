-- All shops
Config.Shop = {

    -- Tints
    [1] = {
        label = "Beta Exclusive Tints",
        type = "tints",
        premium = false,
        defaultPrice = false,
        defaultLevel = false,
        sortBy = "level",
        level = "global",
        currency = "cash",
        items = {
            ["tint_pistol_green"] = { level = 10, price = 25000 },
            ["tint_appistol_army"] = { level = 20, price = 30000 },
            ["tint_carbinerifle_pink"] = { level = 30, price = 40000 },
            ["tint_mg_blue"] = { level = 40, price = 30000 },
            ["tint_compactrifle_platinum"] = { level = 50, price = 150000 },
        }
    }

    [1] = {
        label = "Pink Tints",
        type = "tints",
        premium = false,
        defaultPrice = 50000,
        defaultLevel = false,
        sortBy = "level",
        level = "global",
        currency = "cash",
        items = {
            ["tint_pistol_pink"] = { level = 5 },
            ["tint_appistol_pink"] = { level = 28 },
            ["tint_minismg_pink"] = { level = 12 },
            ["tint_microsmg_pink"] = { level = 20 },
            ["tint_assaultrifle_pink"] = { level = 43 },
            ["tint_compactrifle_pink"] = { level = 45 },
            ["tint_musket_pink"] = { level = 49 },
        }
    }

    [3] = {
        label = "Green Tints",
        type = "tints",
        items = {
            [1] = { item = "tint_combatpistol_green", currency = "cash", price = 25000, level = 2 },
            [2] = { item = "tint_assaultrifle_green", currency = "cash", price = 25000, level = 6 },
            [3] = { item = "tint_minismg_green", currency = "cash", price = 25000, level = 9 },
            [4] = { item = "tint_mg_green", currency = "cash", price = 25000, level = 14 },
        }            
    },
    [4] = {
        label = "Orange Tints",
        type = "tints",
        items = {
            [1] = { item = "tint_sawnoffshotgun_orange", currency = "cash", price = 35000, level = 2 },
            [2] = { item = "tint_marksmanpistol_orange", currency = "cash", price = 35000, level = 23 },
            [3] = { item = "tint_revolver_orange", currency = "cash", price = 35000, level = 29 },
            [4] = { item = "tint_bullpuprifle_orange", currency = "cash", price = 35000, level = 30 },
            [5] = { item = "tint_machinepistol_orange", currency = "cash", price = 35000, level = 39 },
        }            
    },

    -- Calling Cards
    [5] = {
        label = "Beta Exclusive Calling Cards",
        type = "callingcards",
        items = {
            [1] = { item = "calling_unlucky", currency = "cash", price = 20000, level = 10 },
            [2] = { item = "calling_ballas", currency = "cash", price = 20000, level = 20 },
            [3] = { item = "calling_livinitup", currency = "cash", price = 20000, level = 30 },
            [4] = { item = "calling_nosweat", currency = "cash", price = 20000, level = 40 },
            [5] = { item = "calling_prodigy", currency = "cash", price = 20000, level = 50 },
        }
    },
    [6] = {
        label = "Premium Calling Cards",
        type = "callingcards",
        items = {
            [1] = { item = "calling_ezstuff", currency = "cash", price = 20000, level = 10 },
            [2] = { item = "calling_publicenemy", currency = "cash", price = 20000, level = 34 },
            [3] = { item = "calling_gangshit", currency = "cash", price = 20000, level = 22 },
            [4] = { item = "calling_backstabber", currency = "cash", price = 20000, level = 4 },
            [5] = { item = "calling_<3", currency = "cash", price = 20000, level = 50 },
            [6] = { item = "calling_ggwp", currency = "cash", price = 20000, level = 14 },
            [7] = { item = "calling_sweetandsour", currency = "cash", price = 20000, level = 29 },
            [8] = { item = "calling_lawandorder", currency = "cash", price = 20000, level = 8 },
            [9] = { item = "calling_justice", currency = "cash", price = 20000, level = 43 },
            [10] = { item = "calling_walkinthepark", currency = "cash", price = 20000, level = 43 },
            [11] = { item = "calling_calculated", currency = "cash", price = 20000, level = 43 },
            [12] = { item = "calling_simplereally", currency = "cash", price = 20000, level = 43 },
            [13] = { item = "calling_nbk", currency = "cash", price = 20000, level = 43 },
            [14] = { item = "calling_itspersonal", currency = "cash", price = 20000, level = 43 },
            [15] = { item = "calling_allin", currency = "cash", price = 20000, level = 43 },
            [16] = { item = "calling_doubledown", currency = "cash", price = 20000, level = 43 },
            [17] = { item = "calling_lonewolf", currency = "cash", price = 20000, level = 43 },
            [18] = { item = "calling_speeddemon", currency = "cash", price = 20000, level = 43 },
            [19] = { item = "calling_fullthrottle", currency = "cash", price = 20000, level = 43 },
            [20] = { item = "calling_hunted", currency = "cash", price = 20000, level = 43 },

        }
    },

    -- Name colours
    [7] = {
        label = "Premium Name Colours",
        type = "namecols",
        items = {
            [1] = { item = "col_blue", currency = "cash", price = 50000, level = 10 },
            [2] = { item = "col_pink", currency = "cash", price = 50000, level = 10 },
            [3] = { item = "col_green", currency = "cash", price = 50000, level = 10 },
            [4] = { item = "col_purple", currency = "cash", price = 50000, level = 10 },
            [5] = { item = "col_orange", currency = "cash", price = 50000, level = 10 },
            [6] = { item = "col_red", currency = "cash", price = 50000, level = 10 },
            [7] = { item = "col_cyan", currency = "cash", price = 50000, level = 10 },
            [8] = { item = "col_yellow", currency = "cash", price = 50000, level = 10 },
            [9] = { item = "col_mimosa", currency = "cash", price = 100000, level = 20 },
            [10] = { item = "col_lilly", currency = "cash", price = 100000, level = 40 },
            [11] = { item = "col_breeze", currency = "cash", price = 100000, level = 40 },
            [12] = { item = "col_disco", currency = "cash", price = 100000, level = 40 },
            [13] = { item = "col_seasalt", currency = "cash", price = 100000, level = 40 },
            [14] = { item = "col_sandstorm", currency = "cash", price = 100000, level = 40 },
            [15] = { item = "col_lemontwist", currency = "cash", price = 100000, level = 40 },
        }
    },

    -- Clothing
    [8] = {
        label = "Masks",
        type = "clothing",
        items = {
            [1] = { item = "clothing_mask_moose", currency = "cash", price = 18000, level = 18 },
            [2] = { item = "clothing_mask_orc", currency = "cash", price = 18000, level = 18 },
            [3] = { item = "clothing_mask_snowman", currency = "cash", price = 18000, level = 18 },
            [4] = { item = "clothing_mask_cat", currency = "cash", price = 18000, level = 18 },
            [5] = { item = "clothing_mask_fox", currency = "cash", price = 18000, level = 18 },
            --[6] = { item = "clothing_mask_racoon", currency = "cash", price = 18000, level = 18 },
            [7] = { item = "clothing_mask_bear", currency = "cash", price = 18000, level = 18 },
            [8] = { item = "clothing_mask_penguin", currency = "cash", price = 18000, level = 18 },
            [9] = { item = "clothing_mask_gingerbreadhappy", currency = "cash", price = 18000, level = 18 },
            --[10] = { item = "clothing_mask_zombie", currency = "cash", price = 18000, level = 18 },
            [11] = { item = "clothing_mask_weeb", currency = "cash", price = 18000, level = 18 },
            [12] = { item = "clothing_mask_detective", currency = "cash", price = 18000, level = 18 },
            --[13] = { item = "clothing_mask_pumpkin", currency = "cash", price = 18000, level = 18 },
            [14] = { item = "clothing_mask_skullzombie", currency = "cash", price = 18000, level = 18 },
            --[15] = { item = "clothing_mask_bug", currency = "cash", price = 18000, level = 18 },
            [16] = { item = "clothing_mask_satan", currency = "cash", price = 18000, level = 18 },
            [17] = { item = "clothing_mask_angrygingerbread", currency = "cash", price = 18000, level = 18 },
            [18] = { item = "clothing_mask_chicken", currency = "cash", price = 18000, level = 18 },
            --[19] = { item = "clothing_mask_granny", currency = "cash", price = 18000, level = 18 },
            --[20] = { item = "clothing_mask_grandpa", currency = "cash", price = 18000, level = 18 },
            [21] = { item = "clothing_mask_dino", currency = "cash", price = 18000, level = 18 },
            [22] = { item = "clothing_mask_clown", currency = "cash", price = 18000, level = 18 },
            [23] = { item = "clothing_mask_ape", currency = "cash", price = 18000, level = 18 },
            --[24] = { item = "clothing_mask_horse", currency = "cash", price = 18000, level = 18 },
            [25] = { item = "clothing_mask_unicorn", currency = "cash", price = 18000, level = 18 },
            [26] = { item = "clothing_mask_pug", currency = "cash", price = 18000, level = 18 },
            --[27] = { item = "clothing_mask_neon", currency = "cash", price = 18000, level = 18 },
            --[28] = { item = "clothing_mask_soldierzombie", currency = "cash", price = 18000, level = 18 },
            [29] = { item = "clothing_mask_skull", currency = "cash", price = 18000, level = 18 },
            [30] = { item = "clothing_mask_neon2", currency = "cash", price = 18000, level = 18 },
            [31] = { item = "clothing_mask_nvg", currency = "cash", price = 18000, level = 18 },
            [32] = { item = "clothing_mask_bird", currency = "cash", price = 18000, level = 18 },
            --[33] = { item = "clothing_mask_cyberbird", currency = "cash", price = 18000, level = 18 },
            [34] = { item = "clothing_mask_alien", currency = "cash", price = 18000, level = 18 },
            --[35] = { item = "clothing_mask_mike", currency = "cash", price = 18000, level = 18 },
            [36] = { item = "clothing_mask_druid", currency = "cash", price = 18000, level = 18 },
            [37] = { item = "clothing_mask_steampunk", currency = "cash", price = 18000, level = 18 },
            --[38] = { item = "clothing_mask_taco", currency = "cash", price = 18000, level = 18 },
            --[39] = { item = "clothing_mask_burgershot", currency = "cash", price = 18000, level = 18 },
            --[40] = { item = "clothing_mask_cluckin", currency = "cash", price = 18000, level = 18 },
            [41] = { item = "clothing_mask_gadget", currency = "cash", price = 18000, level = 18 },
            [42] = { item = "clothing_mask_coolape", currency = "cash", price = 18000, level = 18 },
        }
    },

}