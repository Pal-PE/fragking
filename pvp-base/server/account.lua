-- Variables
PB.Accounts = {}
Players = {}

-- Authenticate connecting players
function PB.Accounts:Connect(src)
    if GetPlayerIdentifier(src, 0) then
        CreateThread(function()
            exports.oxmysql:query("SELECT * FROM pb_players WHERE steam = ?",
            {GetPlayerIdentifier(src, 0)}, function(result)
                if result[1] then
                    PB.Accounts:Load(src, result[1])
                else
                    PB.Accounts:Create(src)
                end
            end)
        end)
    else
        DropPlayer(src, "You must be logged into a steam account to connect to our servers.")
    end
end

-- Create new user account
function PB.Accounts:Create(src)
    CreateThread(function()
        -- Generate account identifier
        math.randomseed(os.time())
        local newIdentifier = Config.IdentifierPrefix
        for i = 0, 10, 1 do
            newIdentifier = newIdentifier .. math.random(0, 9)
        end
        -- Setup new user account in the database
        exports.oxmysql:query("INSERT INTO pb_players (identifier, steam, flags, currency, levels, stash) VALUES (?, ?, ?, ?, ?, ?)",
        {newIdentifier,
        GetPlayerIdentifier(src, 0),
        json.encode({Config.DefaultFlags}),
        json.encode({}),
        json.encode({}),
        json.encode({equipped = {}, stash = {}})}, 
        function(result)
            if result then
                PB.Logging:NewLog("SERVER", false, "New player account created", {identifier = newIdentifier, steam = GetPlayerIdentifier(src, 0)}, true)
                PB.Accounts:Connect(src)
            else
                DropPlayer(src, "Failed to create user account")
                PB.Logging:NewError("SERVER", false, "Failed to create player account", {steam = GetPlayerIdentifier(src, 0)}, true)
            end
        end)
    end)
end

-- Save users account
function PB.Accounts:Save(src)
    if not src then return falce end
    local this = Players[src]
    if not this then return false end
    CreateThread(function()
        exports.oxmysql:query("UPDATE pb_players SET flags = ?, currency = ?, levels = ?, stash = ? WHERE identifier = ?",
        {json.encode(this.flags), json.encode(this.currency), json.encode(this.levels), json.encode({equipped = this.equippedItems, stash = this.stash}), this.identifier},
        function(result)
            if result then
                PB.Logging:NewLog(src, true, "Saved user's player data", false, true)
            else
                PB.Logging:NewError(src, true, "Failed to save user's player data", false, true)
            end
        end)
    end)
end

-- Load users account
function PB.Accounts:Load(src, account)
    if not account then
        PB.Logging:NewError(src, true, "Failed to load a players account, even though they're supposed to exist?", false, true)
        return false
    end

    local stash = json.decode(account.stash)

    -- Adding new player object to parent players object
    Players[src] = {
        identifier = account.identifier,
        steam = account.steam,
        flags = json.decode(account.flags),
        currency = json.decode(account.currency),
        levels = json.decode(account.levels),
        stash = stash.stash,
        equippedItems = stash.equipped,
        Functions = {},
        session = nil
    }

    local this = Players[src]

    -- Functions
    this.Functions.SendData = function()
        TriggerClientEvent("pb:ReceivePlayerData", src, {
            flags = this.flags,
            currency = this.currency,
            levels = this.levels,
            stash = this.stash
        })
    end

    this.Functions.GetFlag = function(flag)
        return this.flags[flag]
    end

    this.Functions.SetFlag = function(flag, value)
        this.flags[flag] = value
        PB.Logging:NewLog(src, true, "Set a players flag", {flag = flag, value = value}, true)
    end

    -- Currency
    this.Functions.GetCurrency = function(currency)
        if Config.Currency[currency] then
            if this.currency[currency] then
                return this.currency[currency]
            else
                return 0
            end
        else
            PB.Logging:NewError(src, true, "Attempted to get a currency that doesn't exist", {level = level}, true)
            return false
        end
    end

    this.Functions.SetCurrency = function(currency, amount)
        if Config.Currency[currency] then
            if this.currency[currency] then
                this.currency[currency] = amount
                PB.Logging:NewLog(src, true, "Set player's currency", {currency = currency, amount = amount}, true)
                return true
            else
                return false
            end
        else
            PB.Logging:NewError(src, true, "Attempted to set a currency that doesn't exist", {currency = currency}, true)
            return false
        end
    end

    this.Functions.AddCurrency = function(currency, amount)
        if Config.Currency[currency] then
            if this.currency[currency] then
                if this.flags["premium"] then
                    amount = amount*0.5
                end
                this.currency[currency] = this.currency[currency] + amount
                PB.Logging:NewLog(src, true, "Added player currency", {currency = currency, amount = amount}, true)
                return true
            else
                return false
            end
        else
            PB.Logging:NewError(src, true, "Attempted to add to a currency that doesn't exist", {currency = currency}, true)
            return false
        end
    end

    this.Functions.TakeCurrency = function(currency, amount)
        if Config.Currency[currency] then
            if this.currency[currency] then
                local newAmount = this.currency[currency] - amount
                if newAmount > 0 then
                    this.currency[currency] = newAmount
                    PB.Logging:NewLog(src, true, "Removed player currency", {currency = currency, amount = amount}, true)
                    return true
                else
                    return false
                end
            else
                return false
            end
        else
            PB.Logging:NewError(src, true, "Attempted to take from a currency that doesn't exist", {currency = currency}, true)
            return false
        end
    end

    -- Experience
    this.Functions.GetExp = function(level)
        if Config.Levels[level] then
            if this.levels[level] then
                return this.levels[level]
            else
                return false
            end
        else
            PB.Logging:NewError(src, true, "Attempted to get experience of a level that doesn't exist", {level = level}, true)
            return false
        end
    end

    this.Functions.SetExp = function(level, amount)
        if Config.Levels[level] then
            if this.levels[level] then
                this.levels[level] = amount
                PB.Logging:NewLog(src, true, "Set player's experience", {level = level, amount = amount}, true)
                return true
            else
                return false
            end
        else
            PB.Logging:NewError(src, true, "Attempted to set experience for a level that doesn't exist", {level = level}, true)
            return false
        end
    end

    this.Functions.AddExp = function(level, amount)
        if Config.Levels[level] then
            if this.levels[level] then
                if this.flags["premium"] then
                    amount = amount*0.5
                end
                this.levels[level] = this.levels[level] + amount
                PB.Logging:NewLog(src, true, "Added player experience", {level = level, amount = amount}, true)
                return true
            else
                return false
            end
        else
            PB.Logging:NewError(src, true, "Attempted to add experience to a level that doesn't exist", {level = level}, true)
            return false
        end
    end

    -- Levels
    this.Functions.GetLevel = function(level)
        if Config.Levels[level] then
            local lvl = Config.LevelFormulas[Config.Levels[level].formula](this.Functions.GetExp(level))
            if lvl > Config.Levels[level].maxLevel then
                lvl = Config.Levels[level].maxLevel
            end
            return lvl
        else
            PB.Logging:NewError(src, true, "Attempted to calculate level for a level that doesn't exist", {level = level}, true)
            return 0
        end
    end

    -- Stash
    this.Functions.AddItem = function(item, amount, alert)
        if Config.Items[item] then
            if amount <= 0 then
                PB.Logging:NewError(src, true, "Attempted to add a negative amount of items", {item = item, amount = amount}, true)
                return false
            end
            if this.stash[item] then
                local newAmount = this.stash[item] + amount
                if newAmount > Config.Items[item].max then
                    PB.Logging:NewError(src, true, "Attempted to add more than the maximum amount for an item", {item = item, amount = amount, newAmount = amount}, true)
                    return false
                end
                this.stash[item] = newAmount
                PB.Logging:NewLog(src, true, "Item added to player stash", {item = item, amount = amount}, true)
                return true
            else
                if amount > Config.Items[item].max then 
                    PB.Logging:NewError(src, true, "Attempted to add more than the maximum amount for an item", {item = item, amount = amount}, true)
                    return false 
                end
                this.stash[item] = amount
                PB.Logging:NewLog(src, true, "Item added to player stash", {item = item, amount = amount}, true)
                if alert then
                    TriggerClientEvent("pb:StashUpdated", src)
                    PB.Utility:Notify(src, "NIL", "Added " .. amount .. "x " .. Config.Items[item].label .. " to stash", true)
                end
                return true
            end
        else
            PB.Logging:NewError(src, true, "Attempted to add an item that doesn't exist", {item = item}, true)
            return false
        end
    end

    this.Functions.TakeItem = function(item, amount, alert)
        if Config.Items[item] then
            if amount <= 0 then
                PB.Logging:NewError(src, true, "Attempted to take a negative amount of items", {item = item, amount = amount}, true)
                return false
            end
            if this.stash[item] then
                local newAmount = this.stash[item] - amount
                if newAmount < 0 then
                    PB.Logging:NewError(src, true, "Attempted to take a an amount of items which woudl leave it negatice", {item = item, amount = amount, currentAmount = this.stash[item]}, false)
                    return false
                end
                this.stash[item] = currentAmount
                PB.Logging:NewLog(src, true, "Item taken from player stash", {item = item, amount = amount}, true)
                return true
            else
                PB.Logging:NewError(src, true, "Attempted to take an item the player doesnt't have", {item = item, amount = amount}, false)
                return false
            end
        else
            PB.Logging:NewError(src, true, "Attempted to take an item that doesn't exist", {item = item}, true)
            return false
        end
    end

    this.Functions.UseItem = function(item)
        if not Config.Items[item] then return false end
        if this.stash[item] then
            if not Config.ItemCategories[Config.Items[item].category].useFunc(src, item) then
                PB.Utility:Notify(src, "ERROR", "This item can not be used", true)
            end
        end
    end

    this.Functions.EquipItem = function(type, data, item)
        if not Config.Items[item] then return false end
        if this.stash[item] then
            this.equippedItems[type] = data
        end
    end

    -- Setup defaults
    for k, v in pairs(Config.Currency) do
        if not this.currency[k] then
            this.currency[k] = v.default
        end
    end

    for k, v in pairs(Config.Levels) do
        if not this.levels[k] then
            this.levels[k] = v.default
        end
    end

    for k in pairs(Config.DefaultItems) do
        if not this.stash[Config.DefaultItems[k]] then
            this.Functions.AddItem(Config.DefaultItems[k], 1)
        end
    end

    -- Now this is all done, send the player their data
    PB.Logging:NewLog(src, true, "Player account loaded", false, true)
    this.Functions.SendData()
    TriggerClientEvent("pb:PlayerLoaded", src)
    CheckForPurchases(src)
    return this
end

-- Get players object
function PB.Accounts:Get(src)
    src = tonumber(src)
    if Players[src] then
        return Players[src]
    else
        PB.Logging:NewError("SERVER", false, "Couldn't find player object", {src = src}, true)
        DropPlayer(src, "Could not find your player object when requested, please contact server developers with this message")
    end
end

-- Net Events
RegisterNetEvent("pb:PlayerConnected", function()
    local src = source
    PB.Accounts:Connect(src)
end)

RegisterNetEvent("pb:UseItem", function(item)
    local src = source
    local ply = PB.Accounts:Get(src)
    if not ply then return false end
    ply.Functions.UseItem(item)
end)

-- Save accounts on interval
CreateThread(function()
    Wait(15*60*1000)
    for k, v in pairs(GetPlayers()) do
        PB.Accounts:Save(tonumber(v))
    end
end)