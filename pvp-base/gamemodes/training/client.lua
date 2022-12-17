-- Net events
RegisterNetEvent("pb-training:InGame", function(value)
    if value then
        exports["pvp-practice"]:JoinTraining()
    else
        exports["pvp-practice"]:LeaveTraining()
    end
end)