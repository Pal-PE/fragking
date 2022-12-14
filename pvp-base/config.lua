Config = {}

-- User account config

Config.DefaultFlags = {
    ["rank"] = "member",
}

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

Config.Levels = {
    ["global"] = {
        label = "Global Experience",
        default = 500,
        maxLevel = 50,
        formula = 1
    }
}

-- Optimize this so that it sets up level amounts on start, then just loop through when needed
Config.LevelFormula = {

    [1] = function(exp)

        if not exp then return end

        local _amount = 0
        local levelAmounts = {}
        for i = 0, 500, 1 do
            _amount = (i*i)*50 + _amount
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