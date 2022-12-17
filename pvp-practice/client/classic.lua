-- Variables
local Classic = Activities:CreateActivity("classic", false)
local StartActivity

-- Start activity
function StartActivity(difficulty)

    local objModel
    if difficulty == "easy" then
        objModel = "prop_range_target_01"
    elseif difficulty == "normal" then
        objModel = "prop_barrel_02b"
    elseif difficulty == "hard" then
        objModel = "prop_target_red_blue_01"
    elseif difficulty == "pro" then
        objModel = "prop_phys_wades_head"
    else
        return false
    end


    local targetPoints = Config.Drills["gridshot"].targetPoints
    local classicObj = CreatePracObject(objModel, targetPoints[math.random(#targetPoints)])

    CreateThread(function()
        while activityLive do
            Wait(0)
            if GetEntityHealth(classicObj) < 100000000 then
                DeleteObject(classicObj)
                points = points + 100
                classicObj = CreatePracObject(objModel, targetPoints[math.random(#targetPoints)])
            end
        end
    end)

end


-- Attach activity handles
Classic.Handles.StartActivity = StartActivity