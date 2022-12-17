-- Variables
PB = exports["pvp-base"]:GetCoreObject()
Activities = {}
inTraining = false
points = 0
activityLive = false
drillLive = false
drillTime = 0
local JoinTraining, PrepTraining

-- Create new activity
function Activities:CreateActivity(id, startFunc, premium, drillTime, weapon)
    Activities[id] = {
        premium = premium,
        drillTime = drillTime,
        weapon = weapon,
        startFunc = startFunc
    }
    return Activities[id]
end

-- Handle player joining training mode
function JoinTraining()
    inTraining = true
    TriggerServerEvent("pb-practice:GetHighscores")
    TriggerServerEvent("pb-practice:GetStats")
    TriggerEvent("pb-hud:DisplayHUD", true)
    TriggerEvent("pb-hud:SetTooltip", "[F1] Open Training Menu")
    SetPedInfiniteAmmoClip(PlayerPedId(), true)
    DisplayMenu(true)
    StartTrainingLoop()
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

-- Prep activity (avoids duplication with drill and practice functios)
function PrepActivity(activity, _type)
    -- Checks to make sure the activity should go ahead
    if not inTraining then return false end
    if Activities[activity].premium then
        local ply = exports["pvp-base"]:GetData()
        if not ply.flags["premium"] then 
            TriggerEvent("pb:Notification", "ERROR", "This activity is for premium only", true)
            return false 
        end
    end
    if drillLive then
        TriggerEvent("pb:Notification", "ERROR", "Can't start activity while a drill is live", true)
        return false
    end
    -- Now prep it!
    activityLive = false
    local activityPrepped = false
    CreateThread(function()
        Wait(200)
        activityLive = true
        points = 0
        TriggerEvent("pb-loadout:ForceLoadout", {[1] = {item = Activities[activity].weapon}})
        TriggerEvent("pb-loadout:ForceUse", 1)
        ClearPracObjects()
        TriggerEvent("pb-hud:SetTooltip", false)
        TriggerEvent("pb:Notification", "INFO", "Starting " .. activity .. " " .. _type, true)
        math.randomseed(GetGameTimer())
        activityPrepped = true
    end)

    while not activityPrepped do
        Wait(100)
    end

    return true

end

-- Start new practice activity
function StartPractice(activity, difficulty)
    if not PrepActivity(activity, "practice") then return false end
    TriggerEvent("pb-hud:SetTooltip", "[F1] Quit Practice Activity")
    CreateThread(function()
        Wait(500)
        Activities[activity].startFunc(difficulty)
    end)
end

-- Start new drill activity
function StartDrill(activity, difficulty)
    if inActivity then return false end
    if difficulty == "pro" then
        local ply = exports["pvp-base"]:GetData()
        if not ply.flags["premium"] then 
            TriggerEvent("pb:Notification", "ERROR", "Pro drills are restricted to premium", true)
            return false
        end
    end
    if not PrepActivity(activity, "drill") then return false end
    drillLive = true
    CreateThread(function()
        Wait(500)
        SetEntityCoords(PlayerPedId(), vector3(479.2772, 4824.704, -58.38286))
        SetEntityHeading(PlayerPedId(), 198.5981)
        FreezeEntityPosition(PlayerPedId(), true)
        Activities[activity].startFunc(difficulty)
        -- Drill timer
        CreateThread(function()
            drillTime = Activities[activity].drillTime
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
    TriggerEvent("pb:Notification", "INFO", "Drill ended, " .. points .. " points scored", true)
    TriggerServerEvent("pb-practice:FinishedDrill", activity, difficulty, points)
    TriggerEvent("pb-hud:SetTooltip", "[Q] Replay Drill [F1] Open Training Menu")
    -- Give the player the ability to replay the drill while no other activity goes live
    CreateThread(function()
        while not activityLive do
            Wait(1)
            if IsControlJustReleased(0, 44) then -- Q
                StartDrill(activity, difficulty)
            end
        end
    end)
end

-- Net events
RegisterNetEvent("pb-training:Join", JoinTraining)
RegisterNetEvent("pb-training:Leave", LeaveTraining)

-- Send over locale data to NUI
CreateThread(function()
    Wait(500)
    SendNUIMessage({ type = "SendTranslations", locale = PB.Locale })
end)