PB.Shop = {}
CurrentShop = {}

-- Compare level
function SortLevel(a, b)
    return a.level > b.level
end

-- Generate a new shop
function PB.Shop:GenerateShop()
    math.randomseed(os.time())
    for k, v in pairs(Config.Shop) do
        local generatedItems = {}
        if v.rotates then
            local keys = {}
            local usedKeys = {}
            for x, y in pairs(v.items) do
                keys[#keys+1] = x
            end
            while v.rotateAmount > #generatedItems do
                local generatedKey = math.random(#keys)
                if not usedKeys[generatedKey] then
                    usedKeys[generatedKey] = true
                    local item = v.items[keys[generatedKey]]
                    generatedItems[#generatedItems+1] = {
                        item = keys[generatedKey],
                        currency = v.currency,
                        price = item.price or v.defaultPrice,
                        level = item.level or v.defaultLevel
                    }
                end
            end
        else
            for x, y in pairs(v.items) do
                generatedItems[#generatedItems+1] = {
                    item = x,
                    currency = v.currency,
                    price = y.price or v.defaultPrice,
                    level = y.level or v.defaultLevel
                }
            end
        end
        --table.sort(generatedItems, Sortlevel)
        CurrentShop[k] = { 
            label = v.label,
            type = v.type,
            premium = v.premium,
            items = generatedItems
        }
    end
end

-- Net events
RegisterNetEvent("pb:RequestShop", function()
    local src = source
    TriggerClientEvent("pb:ReceiveShop", src, CurrentShop)
end)

-- List of shops
Config.Shop = {

    -- Tints
    [1] = {
        label = "Beta Exclusive Tints",
        type = "tints",
        premium = false,
        defaultPrice = false,
        defaultLevel = false,
        rotates = false,
        sortBy = "level",
        level = "global",
        currency = "cash",
        items = {
            ["tint_pistol_green"] = { level = 10, price = 40000 },
            ["tint_appistol_army"] = { level = 20, price = 40000 },
            ["tint_carbinerifle_pink"] = { level = 30, price = 65000 },
            ["tint_mg_blue"] = { level = 40, price = 40000 },
            ["tint_compactrifle_platinum"] = { level = 50, price = 150000 },
        }
    },

    [2] = {
        label = "Pink Tints",
        type = "tints",
        premium = false,
        defaultPrice = 65000,
        defaultLevel = false,
        rotates = false,
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
    },

    [3] = {
        label = "Green Tints",
        type = "tints",
        premium = false,
        defaultPrice = 40000,
        defaultLevel = false,
        rotates = false,
        sortBy = "level",
        level = "global",
        currency = "cash",
        items = {
            ["tint_combatpistol_green"] = { level = 2 },
            ["tint_assaultrifle_green"] = { level = 6 },
            ["tint_minismg_green"] = { level = 9 },
            ["tint_mg_green"] = { level = 14 },

        }
    },

    [4] = {
        label = "Orange Tints",
        type = "tints",
        premium = false,
        defaultPrice = 40000,
        defaultLevel = false,
        rotates = false,
        sortBy = "level",
        level = "global",
        currency = "cash",
        items = {
            ["tint_sawnoffshotgun_orange"] = { level = 2 },
            ["tint_marksmanpistol_orange"] = { level = 23 },
            ["tint_revolver_orange"] = { level = 29 },
            ["tint_bullpuprifle_orange"] = { level = 30 },
            ["tint_machinepistol_orange"] = { level = 39 },
        }      
    },

    -- Calling cards
    [5] = {
        label = "Beta Exclusive Calling Cards",
        type = "callingcards",
        premium = false,
        defaultPrice = 30000,
        defaultLevel = false,
        rotates = false,
        sortBy = "level",
        level = "global",
        currency = "cash",
        items = {
            ["calling_unlucky"] = { level = 10 },
            ["calling_ballas"] = { level = 20 },
            ["calling_livinitup"] = { level = 30 },
            ["calling_nosweat"] = { level = 40 },
            ["calling_prodigy"] = { level = 50 },
        }      
    },

    [6] = {
        label = "Premium Calling Cards",
        type = "callingcards",
        premium = true,
        defaultPrice = 30000,
        defaultLevel = false,
        rotates = false,
        sortBy = "level",
        level = "global",
        currency = "cash",
        items = {
            ["calling_ezstuff"] = { level = 10 },
            ["calling_publicenemy"] = { level = 42 },
            ["calling_gangshit"] = { level = 4 },
            ["calling_backstabber"] = { level = 1 },
            ["calling_<3"] = { level = 50 },
            ["calling_ggwp"] = { level = 23 },
            ["calling_sweetandsour"] = { level = 8 },
            ["calling_lawandorder"] = { level = 3 },
            ["calling_justice"] = { level = 14 },
            ["calling_walkinthepark"] = { level = 47 },
            ["calling_calculated"] = { level = 26 },
            ["calling_simplereally"] = { level = 11 },
            ["calling_nbk"] = { level = 5 },
            ["calling_itspersonal"] = { level = 41 },
            ["calling_allin"] = { level = 30 },
            ["calling_doubledown"] = { level = 28 },
            ["calling_lonewolf"] = { level = 19 },
            ["calling_speeddemon"] = { level = 35 },
            ["calling_fullthrottle"] = { level = 40 },
            ["calling_hunted"] = { level = 18 },
            ["calling_survivor"] = { level = 32 },
            ["calling_chill"] = { level = 17 },
            ["calling_againstodds"] = { level = 49 },
            ["calling_lightwork"] = { level = 38 },
            ["calling_dogeatdog"] = { level = 34 },
        }      
    },

    -- Name colours
    [7] = {
        label = "Premium Name Colours",
        type = "namecols",
        premium = true,
        defaultPrice = false,
        defaultLevel = false,
        rotates = false,
        sortBy = "level",
        level = "global",
        currency = "cash",
        items = {
            ["col_blue"] = { level = 10, price = 50000 },
            ["col_pink"] = { level = 10, price = 50000 },
            ["col_green"] = { level = 10, price = 50000 },
            ["col_purple"] = { level = 10, price = 50000 },
            ["col_orange"] = { level = 10, price = 50000 },
            ["col_red"] = { level = 10, price = 50000 },
            ["col_cyan"] = { level = 10, price = 50000 },
            ["col_yellow"] = { level = 10, price = 50000 },
            ["col_mimosa"] = { level = 30, price = 125000 },
            ["col_lilly"] = { level = 30, price = 125000 },
            ["col_breeze"] = { level = 30, price = 125000 },
            ["col_disco"] = { level = 30, price = 125000 },
            ["col_seasalt"] = { level = 30, price = 125000 },
            ["col_sandstorm"] = { level = 30, price = 125000 },
            ["col_lemontwist"] = { level = 30, price = 125000 },
            ["col_apple"] = { level = 30, price = 125000 },
            ["col_retro"] = { level = 30, price = 125000 },
        }      
    },

    -- Clothing
    [8] = {
        label = "Masks *Rotates",
        type = "clothing",
        premium = false,
        defaultPrice = 12500,
        defaultLevel = 1,
        rotates = true,
        rotateAmount = 10,
        sortBy = "level",
        level = "global",
        currency = "cash",
        items = {
            ["clothing_mask_moose"] = {},
            ["clothing_mask_orc"] = {},
            ["clothing_mask_snowman"] = {},
            ["clothing_mask_cat"] = {},
            ["clothing_mask_fox"] = {},
            ["clothing_mask_racoon"] = {},
            ["clothing_mask_bear"] = {},
            ["clothing_mask_penguin"] = {},
            ["clothing_mask_gingerbreadhappy"] = {},
            ["clothing_mask_zombie"] = {},
            ["clothing_mask_weeb"] = {},
            ["clothing_mask_detective"] = {},
            ["clothing_mask_pumpkin"] = {},
            ["clothing_mask_skullzombie"] = {},
            ["clothing_mask_bug"] = {},
            ["clothing_mask_satan"] = {},
            ["clothing_mask_angrygingerbread"] = {},
            ["clothing_mask_chicken"] = {},
            ["clothing_mask_granny"] = {},
            ["clothing_mask_grandpa"] = {},
            ["clothing_mask_dino"] = {},
            ["clothing_mask_clown"] = {},
            ["clothing_mask_ape"] = {},
            ["clothing_mask_horse"] = {},
            ["clothing_mask_unicorn"] = {},
            ["clothing_mask_pug"] = {},
            ["clothing_mask_neon"] = {},
            ["clothing_mask_soldierzombie"] = {},
            ["clothing_mask_skull"] = {},
            ["clothing_mask_neon2"] = {},
            ["clothing_mask_nvg"] = {},
            ["clothing_mask_bird"] = {},
            ["clothing_mask_cyberbird"] = {},
            ["clothing_mask_alien"] = {},
            ["clothing_mask_mike"] = {},
            ["clothing_mask_druid"] = {},
            ["clothing_mask_steampunk"] = {},
            ["clothing_mask_taco"] = {},
            ["clothing_mask_burgershot"] = {},
            ["clothing_mask_cluckin"] = {},
            ["clothing_mask_gadget"] = {},
            ["clothing_mask_coolape"] = {},
            ["clothing_mask_hockey2"] = {},
            ["clothing_mask_hockey3"] = {},
            ["clothing_mask_gasmask"] = {},
        }      
    },

    [9] = {
        label = "Hats *Rotates",
        type = "clothing",
        premium = false,
        defaultPrice = 12500,
        defaultLevel = 1,
        sortBy = "level",
        level = "global",
        rotates = true,
        rotateAmount = 10,
        currency = "cash",
        items = {
            ["clothing_hat_bucket2"] = {},
            ["clothing_hat_fedora2"] = {},
            ["clothing_hat_elf"] = {},
            ["clothing_hat_fedora3"] = {},
            ["clothing_hat_tophat"] = {},
            ["clothing_hat_tophat2"] = {},
            ["clothing_hat_beanie3"] = {},
            ["clothing_hat_fedora4"] = {},
            ["clothing_hat_fedora5"] = {},
            ["clothing_hat_patriot"] = {},
            ["clothing_hat_patriot2"] = {},
            ["clothing_hat_patriot3"] = {},
            ["clothing_hat_patriot4"] = {},
            ["clothing_hat_patriot5"] = {},
            ["clothing_hat_beer"] = {},
            ["clothing_hat_xmas3"] = {},
            ["clothing_hat_xmas4"] = {},
            ["clothing_hat_frontcap3"] = {},
            ["clothing_hat_backcap3"] = {},
            ["clothing_hat_police"] = {},
            ["clothing_hat_pilot2"] = {},
            ["clothing_hat_bike4"] = {},
            ["clothing_hat_bike5"] = {},
            ["clothing_hat_frontcap4"] = {},
            ["clothing_hat_frontcap5"] = {},
            ["clothing_hat_frontcap6"] = {},
            ["clothing_hat_spacemarine"] = {},
            ["clothing_hat_frontcap7"] = {},
            ["clothing_hat_combat2"] = {},
            ["clothing_hat_militarycap2"] = {},
            ["clothing_hat_fedora6"] = {},
            ["clothing_hat_bike6"] = {},
            ["clothing_hat_frontcap9"] = {},
            ["clothing_hat_backcap5"] = {},
            ["clothing_hat_stunt2"] = {},
            ["clothing_hat_stunt3"] = {},
            ["clothing_hat_beanie4"] = {},
            ["clothing_hat_bike9"] = {},
            ["clothing_hat_bike10"] = {},
            ["clothing_hat_bike11"] = {},
            ["clothing_hat_neon"] = {},
            ["clothing_hat_stunt4"] = {},
            ["clothing_hat_bucket3"] = {},
            ["clothing_hat_fedora8"] = {},
            ["clothing_hat_yankee3"] = {},
            ["clothing_hat_xmas5"] = {},
            ["clothing_hat_xmas6"] = {},
            ["clothing_hat_xmas7"] = {},
            ["clothing_hat_xmas8"] = {},
            ["clothing_hat_reindeer2"] = {},
            ["clothing_hat_yankee4"] = {},
            ["clothing_hat_frontcap10"] = {},
            ["clothing_hat_boonie"] = {},
            ["clothing_hat_boonie2"] = {},
            ["clothing_hat_militarycap3"] = {},
            ["clothing_hat_frontcap11"] = {},
            ["clothing_hat_frontcap12"] = {},
            ["clothing_hat_backcap2"] = {},
            ["clothing_hat_pilot3"] = {},
            ["clothing_hat_combat3"] = {},
            ["clothing_hat_nvg"] = {},
            ["clothing_hat_nvg2"] = {},
            ["clothing_hat_beanie5"] = {},
            ["clothing_hat_frontcap13"] = {},
            ["clothing_hat_tachanka"] = {},
            ["clothing_hat_riot"] = {},
            ["clothing_hat_frontcap14"] = {},
            ["clothing_hat_backcap6"] = {},
            ["clothing_hat_bucket4"] = {},
            ["clothing_hat_space"] = {},
        }      
    },

    [10] = {
        label = "Glasses",
        type = "clothing",
        premium = false,
        defaultPrice = 12500,
        defaultLevel = 1,
        rotates = false,
        sortBy = "level",
        level = "global",
        currency = "cash",
        items = {
            ["clothing_glasses_ski"] = {},
            ["clothing_glasses_combat2"] = {},
            ["clothing_glasses_patriot"] = {},
            ["clothing_glasses_patriot2"] = {},
        }
    }

}

PB.Shop:GenerateShop()