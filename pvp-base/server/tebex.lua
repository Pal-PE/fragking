-- Variables
PB.Tebex = {}
PB.Tebex.Actions = {}

-- Redeem new code
local function RedeemCode(src, code)

    if not src or not code then return false end

    local ply = PB.Accounts:Get(src)
    if not ply then
        PB.Utility:Notify(src, "ERROR", "Failed to redeem code", true)
        return
    end

    PerformHttpRequest("http://localhost:9000/redeem", function (errorCode, resultData, resultHeaders)
        resultData = json.decode(resultData)
        if errorCode == 200 then
            if resultData.content then
                PB.Utility:Notify(src, "SUCCESS", "API: " .. resultData.content , true)
            end
        elseif errorCode == 401 then
            if resultData.error then
                PB.Utility:Notify(src, "ERROR", "API: " .. resultData.error , true)
            end
        else
            PB.Utility:Notify(src, "ERROR", "Failed to contact API (" .. errorCode .. ")", true)
        end
        CheckForPurchases(src)
    end, "POST", "", {["identifier"] = ply.identifier, ["code"] = code})

end

-- Handle player connecting
function CheckForPurchases(src)

    if not src then return false end

    local ply = PB.Accounts:Get(src)
    if not ply then
        PB.Utility:Notify(src, "ERROR", "Failed to redeem code", true)
        return
    end

    PerformHttpRequest("http://localhost:9000/check", function (errorCode, resultData, resultHeaders)
        resultData = json.decode(resultData)
        local currentTime = os.time()
        if errorCode == 200 then
            if resultData.content then
                for k, v in pairs(resultData.content) do
                    if not v.expire or not v.item then return false end
                    if tonumber(v.expire) < currentTime*1000 then return false end
                    PB.Tebex.Actions[v.item](src)
                end
                ply.Functions.SendData()
            end
        else
            PB.Utility:Notify(src, "ERROR", "Failed to contact API (" .. errorCode .. ")", true)
        end
    end, "GET", "", {["identifier"] = ply.identifier})

end

-- Net events
RegisterNetEvent("pb:RedeemCode", function(code)
    local src = source
    RedeemCode(code)
end)

-- Purchase actions
PB.Tebex.Actions["premium"] = function(src)
    local ply = PB.Accounts:Get(src)
    if not ply then return false end
    ply.Functions.SetFlag("premium", true)
    PB.Utility:Notify(src, "SUCCESS", "Applied premium subscription", true)
end

PB.Tebex.Actions["beta"] = function(ply)
    local ply = PB.Accounts:Get(src)
    if not ply then return false end
    ply.Functions.SetFlag("beta", true)
    PB.Utility:Notify(src, "SUCCESS", "Test", true)
end