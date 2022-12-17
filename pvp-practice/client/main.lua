-- Variables
PB = exports["pvp-base"]:GetCoreObject()
inTraining = false
pracObjects = {}
Activities = {}
points = 0
activityLive = false
drillLive = false
drillTime = 0

-- Create new activity
function Activities:CreateActivity(id, premium)
    Activities[id] = {
        premium = premium,
        Handles = {
            StartActivity = nil,
            EndActivity = nil
        }
    }
    return Activities[id]
end

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

-- Handle player joining training mode
function JoinTraining()
    inTraining = true
    TriggerServerEvent("pb-practice:GetHighscores")
    TriggerServerEvent("pb-practice:GetStats")
    exports["pvp-hud"]:DisplayHUD(true)
    exports["pvp-hud"]:SetTooltip("[F1] Open Training Menu")
    SetPedInfiniteAmmoClip(PlayerPedId(), true)
    DisplayMenu(true)
    CreateThread(function()
        while inTraining do
            Wait(1)
            if IsControlJustReleased(0, 288) then -- F1
                print("released!")
                if drillLive then
                    TriggerEvent("pb:Notification", "ERROR", "Can't open training menu while in a drill", true)
                    return false
                end
                DisplayMenu(true)
                activityLive = false
                ClearPracObjects()
            end
            if activityLive and drillLive then
                exports["pvp-hud"]:SetStats({
                    [1] = {string = "Points", value = points},
                    [2] = {string = "Drill Time", value = drillTime}
                })
            elseif activityLive then
                exports["pvp-hud"]:SetStats({
                    [1] = {string = "Points", value = points},
                })
            end
        end
    end)
end

-- Handle player leaving training mode
function LeaveTraining()
    inTraining = false
    points = 0
    activityLive = false
    drillLive = false
    drillTime = 0
    SetPedInfiniteAmmoClip(PlayerPedId(), false)
    ClearPracObjects()
    FreezeEntityPosition(PlayerPedId(), false)
end

-- Create practice object
function CreatePracObject(model, startPos)
    if not inTraining then return false end
    -- Load model
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(1)
        end
    end
    -- Create the object
    pracObjects[#pracObjects+1] = CreateObject(model, startPos, false, false)
    SetEntityHeading(pracObjects[#pracObjects], 195.5)
    SetEntityHealth(pracObjects[#pracObjects], 100000000)
    SetEntityCollision(pracObjects[#pracObjects], false, true)
    SetObjectPhysicsParams(pracObjects[#pracObjects], 10000.0)
    return pracObjects[#pracObjects]
end

-- Delete practice objects
function ClearPracObjects()
    for k in pairs(pracObjects) do
        DeleteObject(pracObjects[k])
    end
end

-- Start new practice activity
function StartPractice(activity, difficulty)
    if not inTraining then return false end
    if activityLive then return false end
    activityLive = true
    exports["pvp-hud"]:SetTooltip("[F1] Quit Practice Activity")
    if drillLive then
        TriggerEvent("pb:Notification", "ERROR", "Can't start practice while a drill is live", true)
        return false
    end
    ClearPracObjects()
    TriggerEvent("pb:Notification", "INFO", "Starting " .. activity .. " practice", true)
    CreateThread(function()
        Wait(500)
        points = 0
        math.randomseed(GetGameTimer())
        print(activity)
        print(difficulty)
        Activities[activity].Handles.StartActivity(difficulty)
    end)
end

-- Start new drill activity
function StartDrill(activity, difficulty)
    if not inTraining then return false end
    if activityLive then return false end
    activityLive = true
    exports["pvp-hud"]:SetTooltip(false)
    if drillLive then
        TriggerEvent("pb:Notification", "ERROR", "Can't start a new drill while one is already live", true)
        return false
    end
    drillLive = true
    ClearPracObjects()
    TriggerEvent("pb:Notification", "INFO", "Starting " .. activity .. " drill", true)
    CreateThread(function()
        Wait(500)
        points = 0
        math.randomseed(GetGameTimer())
        SetEntityCoords(PlayerPedId(), vector3(479.2772, 4824.704, -58.38286))
        SetEntityHeading(PlayerPedId(), 198.5981)
        FreezeEntityPosition(PlayerPedId(), true)
        Activities[activity].Handles.StartActivity(difficulty)
        CreateThread(function()
            drillTime = 60
            while drillTime > 0 do
                Wait(1000)
                drillTime = drillTime - 1
            end
            EndDrill(activity, difficulty)
        end)
    end)
end

-- Handle a drill ending
function EndDrill(activity, difficulty)
    if not inTraining then return false end
    activityLive = false
    drillLive = false
    FreezeEntityPosition(PlayerPedId(), false)
    exports["pvp-hud"]:SetStats({})
    TriggerEvent("pb:Notification", "INFO", "Drill ended, " .. points .. " points scored", true)
    TriggerServerEvent("pb-practice:FinishedDrill", activity, difficulty, points)
    exports["pvp-hud"]:SetTooltip("[Q] Replay Drill [F1] Open Training Menu")
    CreateThread(function()
        while not activityLive do
            Wait(1)
            if IsControlJustReleased(0, 44) then -- Q
                StartDrill(activity, difficulty)
            end
        end
    end)
end

-- NUI callbacks
RegisterNUICallback("StartPractice", function(data)
    DisplayMenu(false)
    StartPractice(string.lower(data.activity), data.difficulty)
end)

RegisterNUICallback("RefreshScoreboard", function(data)
    TriggerEvent("pb:Notification", "INFO", "Refreshing leaderboard", true)
    TriggerServerEvent("pb-practice:GetHighscores")
end)

RegisterNUICallback("RefreshStats", function(data)
    TriggerEvent("pb:Notification", "INFO", "Refreshing stats, please wait", true)
    TriggerServerEvent("pb-practice:GetStats")
end)

RegisterNUICallback("StartDrill", function(data)
    DisplayMenu(false)
    if data.difficulty == "pro" then
        TriggerEvent("pb:Notification", "ERROR", "Pro drills are restricted to premium", true)
    else
        StartDrill(string.lower(data.activity), data.difficulty)
    end
end)

RegisterNUICallback("QuitTraining", function(data)
    DisplayMenu(false)
    TriggerServerEvent("pb:LeaveSession")
    exports["pvp-menu"]:DisplayMenu(true)
end)

-- Net events
RegisterNetEvent("pb-practice:ReceiveHighscores", function(highscores)
    SendNUIMessage({type = "SetHighscores", highscores = highscores})
end)

RegisterNetEvent("pb-practice:ReceiveStats", function(stats)
    SendNUIMessage({type = "SetStats", stats = stats})
end)

-- Send over locale data to NUI
CreateThread(function()
    Wait(500)
    SendNUIMessage({ type = "SendTranslations", locale = PB.Locale })
end)

-- Exports
exports("JoinTraining", JoinTraining)
exports("LeaveTraining", LeaveTraining)