-- Variables
Config = {}

Config.IdentifierPrefix = "22"

-- Default flags
Config.DefaultFlags = {
    ["rank"] = "member",
}

-- Default currencies
Config.Currency = {
    ["cash"] = {
        label = "Cash",
        default = 0,
    },
    ["gold"] = {
        label = "Gold Bars",
        default = 0
    }
}

-- Default levels
Config.Levels = {
    ["global"] = {
        label = "Global Experience",
        default = 0,
        maxLevel = 50,
        formula = 1
    }
}

-- Default items
Config.DefaultItems = {"calling_fng","calling_day1","col_white","clothing_hat_beanie","clothing_hat_bucket",
"clothing_hat_frontcap","clothing_hat_beanie2","clothing_hat_militarycap","clothing_hat_flatcap","clothing_hat_backcap",
"clothing_hat_frontcap2","clothing_hat_fedora","clothing_hat_cowboy","clothing_hat_bandana","clothing_hat_headphones",
"clothing_hat_bike","clothing_hat_bike2","clothing_hat_bike3","clothing_hat_headset","clothing_hat_reindeer",
"clothing_hat_pilot","clothing_hat_combat","clothing_hat_xmas","clothing_hat_xmas2","clothing_hat_yankee","clothing_hat_fedora7","clothing_hat_frontcap8",
"clothing_hat_backcap4","clothing_hat_bike7","clothing_hat_stunt","clothing_hat_bike8","clothing_hat_beret","clothing_hat_santa",
"clothing_mask_hockey","clothing_mask_hockey4","clothing_mask_oldpilot","clothing_mask_combat","clothing_mask_hockey5","clothing_mask_skimask",
"clothing_mask_bankrobber", "clothing_mask_tapemask","clothing_mask_paperbag","clothing_mask_hockey6","clothing_mask_bandana","clothing_mask_bandana2","clothing_mask_shirt","clothing_mask_shemagh","clothing_glasses_shades","clothing_glasses_shades2","clothing_glasses_glasses",
"clothing_glasses_glasses2","clothing_glasses_aviators","clothing_glasses_aviators2","clothing_glasses_shades3","clothing_glasses_squareframe",
"clothing_glasses_shades4","clothing_glasses_combat","clothing_glasses_glasses3","clothing_glasses_pilot","clothing_glasses_diving"}

-- Optimize this so that it sets up level amounts on start, then just loop through when needed
Config.LevelFormulas = {
    [1] = function(exp)
        if not exp then return end
        local _amount = 0
        local levelAmounts = {}
        for i = 0, 51, 1 do
            _amount = (i*i)*75 + _amount
            levelAmounts[i] = {amount = _amount}
        end
        local lvl = 0
        for k, v in pairs(levelAmounts) do
            if exp < v.amount then
                lvl = k
                break
            end
        end
        return lvl
    end
}

Config.NextLevel = {
    [1] = function(exp)
        if not exp then return end
        local _amount = 0
        local levelAmounts = {}
        for i = 0, 51, 1 do
            _amount = (i*i)*75 + _amount
            levelAmounts[i] = {amount = _amount}
        end
        local lvl = 0
        for k, v in pairs(levelAmounts) do
            if exp < v.amount then
                lvl = k
                break
            end
        end
        return {
            nextLvlExp = levelAmounts[lvl+1].amount,
            currentLvlExp = levelAmounts[lvl].amount,
            neededTotalExp = levelAmounts[lvl+1].amount - levelAmounts[lvl].amount,
            neededExp = levelAmounts[lvl+1].amount - exp,
            percentage = ((levelAmounts[lvl+1].amount - exp)/(levelAmounts[lvl+1].amount - levelAmounts[lvl].amount))*100
        }
    end
}