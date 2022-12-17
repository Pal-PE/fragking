-- Variables
local Speed = Activities:CreateActivity("speed", false)
local StartActivity

-- Start activity
function StartActivity(difficulty)

    local changeSpeed
    if difficulty == "easy" then
        changeSpeed = 2800
    elseif difficulty == "normal" then
        changeSpeed = 2200
    elseif difficulty == "hard" then
        changeSpeed = 1600
    elseif difficulty == "pro" then
        changeSpeed = 1200
    else
        return false
    end

    local targetPoints = Config.Drills["gridshot"].targetPoints
    local targetObj = CreatePracObject("prop_range_target_01", targetPoints[math.random(#targetPoints)])
    
    CreateThread(function()
        while activityLive do
            Wait(changeSpeed)
            local newPoints = 100000000 - GetEntityHealth(targetObj)
            points = points + newPoints
            DeleteObject(targetObj)
            targetObj = CreatePracObject("prop_range_target_01", targetPoints[math.random(#targetPoints)])
        end
    end)

end

-- Attach activity handles
Speed.Handles.StartActivity = StartActivity