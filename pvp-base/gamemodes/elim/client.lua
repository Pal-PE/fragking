-- Variables
local inGame = false
local inRound = false
local sphereEndPoint = nil
local sphereSize = nil
local previewCam = nil

-- Handle round starting/ending
RegisterNetEvent("pb-elim:InRound", function(value, team)

    inRound = value
    if value then
        -- Disable respawning
        allowedRespawn = false

        -- Team setup
        SetPedCanBeTargettedByTeam(PlayerPedId(), 1, true)
        SetPedCanBeTargettedByTeam(PlayerPedId(), 2, true)
        SetPlayerTeam(PlayerId(), team)
        print("get team", GetPlayerTeam(PlayerId()))
        SetPedCanBeTargettedByTeam(PlayerPedId(), team, false)

        -- HUD and loadout updates
        TriggerEvent("pb-loadout:AllowEquip", true)
        TriggerEvent("pb-loadout:DisplayWeaponSelect", false)
        TriggerEvent("pb-loadout:ForceUse", 1)
        TriggerEvent("pb-hud:SetTooltip", false)

        -- Begin spawning
        CreateThread(function()
            SetEntityMaxHealth(PlayerPedId(), 200)
            SetEntityHealth(PlayerPedId(), 200)
            SetPedArmour(PlayerPedId(), 100)
            SetEntityInvincible(PlayerPedId(), true)
            SetEntityAlpha(PlayerPedId(), 200)
            Wait(1000)
            SetEntityInvincible(PlayerPedId(), false)
            SetEntityAlpha(PlayerPedId(), 255)

            -- Start round cycle
            while inRound do
                Wait(1)
                if sphereEndPoint and sphereSize then
                    DrawSphere(sphereEndPoint.x, sphereEndPoint.y, sphereEndPoint.z, sphereSize, 255, 0, 0, 0.2)
                end
            end
        end)
        
        -- Check for sphere damage
        CreateThread(function()
            while inRound do
                Wait(1000)
                if sphereEndPoint and sphereSize then
                    local pos = GetEntityCoords(PlayerPedId())
                    if #(sphereEndPoint-pos) > sphereSize then 
                        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId())-45)
                        SetPedArmour(PlayerPedId(), GetPedArmour(PlayerPedId())-25)
                    end
                end
            end
        end)

    else
        -- Allow player to respawn if they're dead
        allowedRespawn = true

        -- HUD and loadout updates
        TriggerEvent("pb-loadout:AllowEquip", false)
        TriggerEvent("pb-loadout:DisplayWeaponSelect", true)
        RemoveAllPedWeapons()
        TriggerEvent("pb-hud:SetTooltip", "Press [F1] to change weapons.")
        
        -- Check for F1 keypress, opens weapon select
        CreateThread(function()
            while inGame and not inRound do
                Wait(1)
                if IsControlJustReleased(0, 288) then -- F1
                    TriggerEvent("pb-loadout:DisplayWeaponSelect", true)
                end
            end
        end)
    end

end)

-- Sets the inGame variable, intended to break loops
RegisterNetEvent("pb-elim:InGame", function(value)
    inGame = value
end)

-- Draw death sphere, and calculate if damage should be taken
RegisterNetEvent("pb-elim:UpdateSphere", function(endPoint, size, active)
    if active then
        sphereEndPoint = endPoint
        sphereSize = size
    else
        sphereEndPoint = nil
        sphereSize = nil
    end
end)

-- Set camera
RegisterNetEvent("pb-elim:SetCamera", function(camPos)
    if not camPos then return false end
    previewCam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", camPos[1], camPos[2], 90.0, false, 2)
    SetCamActive(previewCam, true)
    RenderScriptCams(true, false, 1, true, false)
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityAlpha(PlayerPedId(), 0)
end)

-- Remove camera
RegisterNetEvent("pb-elim:RemoveCamera", function()
    RenderScriptCams(false, false, 1, true, true)
    DestroyAllCams(true)
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityAlpha(PlayerPedId(), 255)
end)