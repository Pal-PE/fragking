-- Variables
local StartActivity

-- Start activity
function StartActivity(difficulty)

    local objModel
    local dummyAmount
    local dummyModel
    if difficulty == "easy" then
        objModel = "prop_range_target_01"
        dummyModel = "prop_range_target_02"
        dummyAmount = 1
    elseif difficulty == "normal" then
        objModel = "prop_range_target_01"
        dummyModel = "prop_range_target_02"
        dummyAmount = 2
    elseif difficulty == "hard" then
        objModel = "prop_target_red_blue_01"
        dummyModel = "prop_target_blue"
        dummyAmount = 3
    elseif difficulty == "pro" then
        objModel = "prop_phys_wades_head"
        dummyModel = "prop_bowling_ball"
        dummyAmount = 4
    else
        return false
    end


    local targetPoints = Config.Drills["gridshot"].targetPoints
    local targetObj = CreatePracObject(objModel, targetPoints[math.random(#targetPoints)])
    local dummyObjs = {}
    for i = 1, dummyAmount do
        dummyObjs[i] = CreatePracObject(dummyModel, targetPoints[math.random(#targetPoints)])
    end

    CreateThread(function()
        while activityLive do
            Wait(0)
            for k in pairs(dummyObjs) do
                if GetEntityHealth(dummyObjs[k]) < 100000000 then
                    ClearPracObjects()
                    points = points - 75
                    for i = 1, dummyAmount do
                        dummyObjs[i] = CreatePracObject(dummyModel, targetPoints[math.random(#targetPoints)])
                    end
                    targetObj = CreatePracObject(objModel, targetPoints[math.random(#targetPoints)])
                end
            end
            if GetEntityHealth(targetObj) < 100000000 then
                ClearPracObjects()
                points = points + 100
                for i = 1, dummyAmount do
                    dummyObjs[i] = CreatePracObject(dummyModel, targetPoints[math.random(#targetPoints)])
                end
                targetObj = CreatePracObject(objModel, targetPoints[math.random(#targetPoints)])
            end
        end
    end)

end


-- Create activity
local Precision = Activities:CreateActivity("precision", StartActivity, true, 60, "wep_pistol")