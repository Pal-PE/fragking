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
Config.DefaultItems = {"calling_fng","calling_day1","col_white"}

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
            percentage = (levelAmounts[lvl+1].amount - exp)/(levelAmounts[lvl+1].amount - levelAmounts[lvl].amount)*100
        }
    end
}