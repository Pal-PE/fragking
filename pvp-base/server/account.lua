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
        local newIdentifier = "22"
        for i = 0, 10, 1 do
            newIdentifier = newIdentifier .. math.random(0, 9)
        end
        -- Setup new user account in the database
        exports.oxmysql:query("INSERT INTO pb_players (identifier, steam, flags, currency, levels, stats) VALUES (?, ?, ?, ?, ?, ?)",
        {newIdentifier,
        GetPlayerIdentifier(src, 0),
        json.encode({Config.DefaultFlags}),
        json.encode({}),
        json.encode({}),
        json.encode({})}, 
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
    CreateThread(function()
        exports.oxmysql:query("UPDATE pb_players SET flags = ?, currency = ?, levels = ?, stats = ? WHERE identifier = ?",
        {json.encode(Players[src].flags), json.encode(Players[src].currency), json.encode(Players[src].levels), json.encode(Players[src].stats), Players[src].identifier},
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
    else
        CreateThread(function()
            -- Adding new player object to parent players object
            Players[src] = {
                identifier = account.identifier,
                steam = account.steam,
                flags = json.decode(account.flags),
                currency = json.decode(account.currency),
                levels = json.decode(account.levels),
                Functions = {},
                PlayerState = "SETUP",
                Session = nil
            }

            PB.Logging:NewLog(src, true, "Player account loaded", false, true)

            -- Functions
            Players[src].Functions.SendData = function()
                TriggerClientEvent(src, "pb:PlayerData", {
                    flags = Players[src].flags,
                    currency = Players[src].currency,
                    levels = Players[src].levels
                })
            end
            
            Players[src].Functions.GetPlyState = function()
                return Players[src].PlayerState
            end

            Players[src].Functions.SetPlyState = function(value)
                Players[src].PlayerState = value
                PB.Logging:NewLog(src, true, "Set a players state", { value = value}, true)
            end

            Players[src].Functions.GetFlag = function(flag)
                return Players[src].flags[flag]
            end

            Players[src].Functions.SetFlag = function(flag, value)
                Players[src].flags[flag] = value
                PB.Logging:NewLog(src, true, "Set a players flag", {flag = flag, value = value}, true)
            end

            -- Currency
            Players[src].Functions.GetCurrency = function(currency)
                if Config.Currency[currency] then
                    if Players[src].currency[currency] then
                        return Players[src].currency[currency]
                    else
                        return 0
                    end
                else
                    PB.Logging:NewError(src, true, "Attempted to get a currency that doesn't exist", {level = level}, true)
                    return false
                end
            end

            Players[src].Functions.SetCurrency = function(currency, amount)
                if Config.Currency[currency] then
                    if Players[src].currency[currency] then
                        Players[src].currency[currency] = amount
                        PB.Logging:NewLog(src, true, "Set player's currency", {currency = currency, amount = amount}, true)
                    else
                        return false
                    end
                else
                    PB.Logging:NewError(src, true, "Attempted to set a currency that doesn't exist", {currency = currency}, true)
                    return false
                end
            end

            Players[src].Functions.AddCurrency = function(currency, amount)
                if Config.Currency[currency] then
                    if Players[src].currency[currency] then
                        Players[src].currency[currency] = Players[src].currency[currency] + amount
                        PB.Logging:NewLog(src, true, "Added player currency", {currency = currency, amount = amount}, true)
                    else
                        return false
                    end
                else
                    PB.Logging:NewError(src, true, "Attempted to add to a currency that doesn't exist", {currency = currency}, true)
                    return false
                end
            end

            Players[src].Functions.TakeCurrency = function(currency, amount)
                if Config.Currency[currency] then
                    if Players[src].currency[currency] then
                        local newAmount = Players[src].currency[currency] - amount
                        if newAmount > 0 then
                            Players[src].currency[currency] = newAmount
                            PB.Logging:NewLog(src, true, "Removed player currency", {currency = currency, amount = amount}, true)
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
            Players[src].Functions.GetExp = function(level)
                if Config.Levels[level] then
                    if Players[src].levels[level] then
                        return Players[src].levels[level]
                    else
                        return false
                    end
                else
                    PB.Logging:NewError(src, true, "Attempted to get experience of a level that doesn't exist", {level = level}, true)
                    return false
                end
            end

            Players[src].Functions.SetExp = function(level, amount)
                if Config.Levels[level] then
                    if Players[src].levels[level] then
                        Players[src].levels[level] = amount
                        PB.Logging:NewLog(src, true, "Set player's experience", {level = level, amount = amount}, true)
                    else
                        return false
                    end
                else
                    PB.Logging:NewError(src, true, "Attempted to set experience for a level that doesn't exist", {level = level}, true)
                    return false
                end
            end

            Players[src].Functions.AddExp = function(level, amount)
                if Config.Levels[level] then
                    if Players[src].levels[level] then
                        Players[src].levels[level] = Players[src].levels[level] + amount
                        PB.Logging:NewLog(src, true, "Added player experience", {level = level, amount = amount}, true)
                    else
                        return false
                    end
                else
                    PB.Logging:NewError(src, true, "Attempted to add experience to a level that doesn't exist", {level = level}, true)
                    return false
                end
            end

            -- Levels
            Players[src].Functions.GetLevel = function(level)
                if Config.Levels[level] then
                    local level = Config.LevelFormulas[Config.Levels[level].formula](Players[src].Functions.GetExp(level))
                    if level > Config.Levels[level].maxLevel then
                        level = Config.Levels[level].maxLevel
                        PB.Logging:NewLog(src, true, "Removed player experience", {level = level, amount = amount}, true)
                    end
                    return level
                else
                    PB.Logging:NewError(src, true, "Attempted to calculate level for a level that doesn't exist", {level = level}, true)
                    return 0
                end
            end

            -- Setup defaults
            for k, v in pairs(Config.Currency) do
                if not Players[src].currency[k] then
                    Players[src].currency[k] = v.default
                end
            end

            for k, v in pairs(Config.Levels) do
                if not Players[src].levels[k] then
                    Players[src].levels[k] = v.default
                end
            end

            -- Now this is all done, send the player their data
            Players[src].Functions.SendData()
            TriggerClientEvent("pb:PlayerLoaded", src)
            CheckForPurchases(src)

        end)
    end
end

-- Get players object
function PB.Accounts:Get(src)
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

-- Save accounts on interval
CreateThread(function()
    Wait(30*60*1000)
    for k, v in pairs(GetPlayers()) do
        print(`tryna auto save..`)
        print(v)
        PB.Accounts:Save(v)
    end
end)