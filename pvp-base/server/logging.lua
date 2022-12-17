-- Variables
PB.Logging = {}

-- Create new log
function PB.Logging:NewLog(target, isPly, report, data, shouldPrint)
    if target == nil or isPly == nil or report == nil or data == nil or shouldPrint == nil then
        print("Log was not created as not all required fields were given.")
        return false
    end

    if isPly then
        local ply = PB.Accounts:Get(tonumber(target))
        if not ply then return false end
        target = ply.identifier
    end

    if not data then data = {} end

    local date = os.time()

    if shouldPrint then
        local printFriendly = os.date("%x - %X")
        print("[LOG] " .. printFriendly .. ", " .. target .. ": " .. report)
    end

    exports.oxmysql:query("INSERT INTO pb_logs (date, target, isPly, report, data) VALUES (?, ?, ?, ?, ?)",
    {date, target, isPly, report, json.encode(data)},
    function(result)
        if not result then
            print("An error occured while creating a new log within the database")
        end
    end)
end

-- Create new error log
function PB.Logging:NewError(target, isPly, report, data, shouldPrint)
    if target == nil or isPly == nil or report == nil or data == nil or shouldPrint == nil then
        print("Error log was not created as not all required fields were given.")
        return false
    end

    if isPly then
        local ply = PB.Accounts:Get(target)
        if not ply then return false end
        target = ply.identifier
    end

    if not data then data = {} end

    local date = os.time()

    if shouldPrint then
        local printFriendly = os.date("%x - %X")
        print("[ERROR!] " .. printFriendly .. ", " .. target .. ": " .. report)
    end

    exports.oxmysql:query("INSERT INTO pb_errors (date, target, isPly, report, data) VALUES (?, ?, ?, ?, ?)",
    {date, target, isPly, report, json.encode(data)},
    function(result)
        if not result then
            print("An error occured while creating a new error log within the database")
        end
    end)
end

-- Net events
RegisterNetEvent("pb:NewLog", function(target, isPly, report, data, shouldPrint)
    PB.Logging:NewLog(target, isPly, report, data, shouldPrint)
end)

RegisterNetEvent("pb:NewError", function(target, isPly, report, data, shouldPrint)
    PB.Logging:NewError(target, isPly, report, data, shouldPrint)
end)