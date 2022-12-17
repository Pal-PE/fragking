-- Variables
local StartActivity

-- Start activity
function StartActivity(difficulty)

    local changeSpeed
    if difficulty == "easy" then
        changeSpeed = 28
    elseif difficulty == "normal" then
        changeSpeed = 22
    elseif difficulty == "hard" then
        changeSpeed = 16
    elseif difficulty == "pro" then
        changeSpeed = 12
    else
        return false
    end

    local targetPoints = Config.Drills["gridshot"].targetPoints
    local targetObj = CreatePracObject("prop_range_target_01", targetPoints[math.random(#targetPoints)])
    
    local count = 0
    CreateThread(function()
        while activityLive do
            Wait(100)
            count = count + 1
            if count >= changeSpeed then
                local newPoints = 100000000 - GetEntityHealth(targetObj)
                points = points + newPoints
                DeleteObject(targetObj)
                targetObj = CreatePracObject("prop_range_target_01", targetPoints[math.random(#targetPoints)])
                count = 0
            end
        end
    end)

end

-- Create activity
local Speed = Activities:CreateActivity("speed", StartActivity, false, 60, "wep_appistol")