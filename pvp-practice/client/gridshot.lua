-- Variables
local Gridshot = Activities:CreateActivity("gridshot", "GridShot")
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
    local gridshotObjs = {}
    for i = 1, 5 do
        gridshotObjs[i] = CreatePracObject(objModel, targetPoints[math.random(#targetPoints)])
    end

    CreateThread(function()
        while activityLive do
            Wait(0)
            for k in pairs(gridshotObjs) do
                if GetEntityHealth(gridshotObjs[k]) < 100000000 then
                    DeleteObject(gridshotObjs[k])
                    points = points + 100
                    gridshotObjs[k] = CreatePracObject(objModel, targetPoints[math.random(#targetPoints)])
                end
            end
        end
    end)

end


-- Attach activity handles
Gridshot.Handles.StartActivity = StartActivity