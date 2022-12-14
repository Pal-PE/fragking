-- Variables
PlayerData = {}

-- Return stored player data
function PB:GetData()
    return PlayerData
end

-- Net events
RegisterNetEvent("pb:PlayerData", function(_PlayerData)
    PlayerData = _PlayerData
end)