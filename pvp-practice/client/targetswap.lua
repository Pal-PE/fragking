-- Variables
local Targetswap = Activities:CreateActivity("targetswap", false)
local StartActivity

-- Start activity
function StartActivity(difficulty)

    local trackingSpeed
    local dummyAmount
    if difficulty == "easy" then
        trackingSpeed = 0.015
        dummyAmount = 1
    elseif difficulty == "normal" then
        trackingSpeed = 0.02
        dummyAmount = 2
    elseif difficulty == "hard" then
        trackingSpeed = 0.028
        dummyAmount = 3
    elseif difficulty == "pro" then
        trackingSpeed = 0.035
        dummyAmount = 5
    else
        return false
    end

    local slidePoints = Config.Drills["tracking"].slidePoints
    local targetObj = CreatePracObject("prop_range_target_01", slidePoints[math.random(#slidePoints)])
    local slidePoint = slidePoints[math.random(#slidePoints)]
    local dummyObjs = {}
    for i = 1, dummyAmount do
        dummyObjs[i] = {slidePoint = slidePoints[math.random(#slidePoints)], obj = CreatePracObject("prop_range_target_02", slidePoints[math.random(#slidePoints)])}
    end

    CreateThread(function()
        while activityLive do
            Wait(0)
            if SlideObject(targetObj, slidePoint, trackingSpeed, trackingSpeed, trackingSpeed, false) then
                slidePoint = slidePoints[math.random(#slidePoints)]
            end
            for k in pairs(dummyObjs) do
                if SlideObject(dummyObjs[k].obj, dummyObjs[k].slidePoint, trackingSpeed, trackingSpeed, trackingSpeed, false) then
                    dummyObjs[k].slidePoint = slidePoints[math.random(#slidePoints)]
                end
            end
            points = 100000000-GetEntityHealth(targetObj)
        end
        targetObj = false
    end)

    local count = 0
    CreateThread(function()
        while activityLive do
            Wait(100)
            count = count + 1
            if count >= 40 then
                local dummyToSwap = math.random(1, dummyAmount)
                local targetPos = GetEntityCoords(targetObj)
                local targetSlide = slidePoint
                SetEntityCoords(targetObj, GetEntityCoords(dummyObjs[dummyToSwap].obj))
                slidePoint = dummyObjs[dummyToSwap].slidePoint
                SetEntityCoords(dummyObjs[dummyToSwap].obj, targetPos)
                dummyObjs[dummyToSwap].slidePoint = targetSlide
                count = 0
            end
        end
    end)

end

-- Attach activity handles
Targetswap.Handles.StartActivity = StartActivity