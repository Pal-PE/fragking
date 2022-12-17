-- Variables
local Tracking = Activities:CreateActivity("tracking", false)
local StartActivity

-- Start activity
function StartActivity(difficulty)

    local trackingSpeed
    if difficulty == "easy" then
        trackingSpeed = 0.015
    elseif difficulty == "normal" then
        trackingSpeed = 0.02
    elseif difficulty == "hard" then
        trackingSpeed = 0.028
    elseif difficulty == "pro" then
        trackingSpeed = 0.035
    else
        return false
    end

    local slidePoints = Config.Drills["gridshot"].targetPoints
    local slideObj = CreatePracObject("prop_range_target_01", slidePoints[math.random(#slidePoints)])
    local slidePoint = slidePoints[math.random(#slidePoints)]

    CreateThread(function()
        while activityLive do
            Wait(0)
            if SlideObject(slideObj, slidePoint, trackingSpeed, trackingSpeed, trackingSpeed, false) then
                slidePoint = slidePoints[math.random(#slidePoints)]
            end
            points = 100000000-GetEntityHealth(slideObj)
        end
    end)

end

-- Attach activity handles
Tracking.Handles.StartActivity = StartActivity