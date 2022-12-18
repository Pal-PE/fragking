-- Client-side game cycle
function StartTrainingLoop()
    -- Continous checks
    CreateThread(function()
        while inTraining do
            Wait(1)
            -- Open training menu?
            if IsControlJustReleased(0, 288) then -- F1
                if not drillLive then
                    DisplayMenu(true)
                    activityLive = false
                else
                    TriggerEvent("pb:Notification", "ERROR", "Can't open training menu while in a drill", true)
                end

            end
        end
    end)
    -- Periodic checks
    CreateThread(function()
        while inTraining do
            Wait(500)
            -- HUD
            if activityLive and drillLive then
                TriggerEvent("pb-hud:SetStats", {
                    [1] = {string = "Points", value = points},
                    [2] = {string = "Drill Time", value = drillTime}
                })
            elseif activityLive then
                TriggerEvent("pb-hud:SetStats", {
                    [1] = {string = "Points", value = points},
                })
            end
            -- Distance check, in case the player "escapes"
            if 100 < #(GetEntityCoords(PlayerPedId())-vector3(482.1203, 4813.112, -58.38425)) then
                if inTraining then
                    SetEntityCoords(PlayerPedId(), vector3(482.1203, 4813.112, -58.38425))
                    TriggerEvent("pb:Notification", "INFO", "Returned to training", true)
                end
            end
        end
    end)
end