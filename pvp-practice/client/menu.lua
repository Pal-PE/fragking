-- Display training menu
function DisplayMenu(value)
    SendNUIMessage({type = "DisplayMenu", value = value})
    if value then
        TriggerScreenblurFadeIn(3000)
        SetNuiFocus(true, true)
    else
        TriggerScreenblurFadeOut(3000)
        SetNuiFocus(false, false)
    end
end

-- NUI callbacks
RegisterNUICallback("StartPractice", function(data)
    DisplayMenu(false)
    StartPractice(string.lower(data.activity), data.difficulty)
end)

RegisterNUICallback("StartDrill", function(data)
    DisplayMenu(false)
    StartDrill(string.lower(data.activity), data.difficulty)
end)

RegisterNUICallback("QuitTraining", function(data)
    LeaveTraining()
    DisplayMenu(false)
    TriggerServerEvent("pb:LeaveSession")
end)

RegisterNUICallback("RefreshScoreboard", function(data)
    TriggerEvent("pb:Notification", "INFO", "Refreshing leaderboard", true)
    TriggerServerEvent("pb-practice:GetHighscores")
end)

RegisterNUICallback("RefreshStats", function(data)
    TriggerEvent("pb:Notification", "INFO", "Refreshing stats, please wait", true)
    TriggerServerEvent("pb-practice:GetStats")
end)

-- Net events
RegisterNetEvent("pb-practice:ReceiveHighscores", function(highscores)
    SendNUIMessage({type = "SetHighscores", highscores = highscores})
end)

RegisterNetEvent("pb-practice:ReceiveStats", function(stats)
    SendNUIMessage({type = "SetStats", stats = stats})
end)