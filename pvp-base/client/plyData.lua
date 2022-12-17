-- Variables
PlayerData = {}
local GetData

-- Return stored player data
function GetData()
    return PlayerData
end

-- Net events
RegisterNetEvent("pb:ReceivePlayerData", function(_PlayerData)
    PlayerData = _PlayerData
end)

-- Exports
exports("GetData", GetData)