-- Net events
RegisterNetEvent("pb-voting:ReceiveNewVote", function(title, options)
    SetNuiFocus(true, true)
    SendNUIMessage({type = "SetVotes", votes = options, title = title})
end)

RegisterNetEvent("pb-voting:VoteEnded", function()
    SetNuiFocus(false, false)
    SendNUIMessage({type = "CloseVotes"})
end)

RegisterNetEvent("pb:LeftSession", function()
    SetNuiFocus(false, false)
    SendNUIMessage({type = "CloseVotes"})
end)

-- NUI callbacks
RegisterNUICallback("CastVote", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({type = "CloseVotes"})
    TriggerServerEvent("pb-voting:CastVote", data.id)
end)
