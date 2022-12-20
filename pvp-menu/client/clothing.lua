-- Variables
inWardobe = false

-- Get the player in a proper state for the clothing menu, then open it
function OpenWardrobe()
    inWardrobe = true
    DisplayMenu(false)
    SetEntityCoords(PlayerPedId(), vector3(-808.6607, 176.0795, 75.74081))
    FreezeEntityPosition(PlayerPedId(), true)
    TriggerEvent("raid_clothes:OpenMenu", "clothesmenu")
    lobbyCam = CreateCameraWithParams(`DEFAULT_SCRIPTED_CAMERA`, -806.0, 177.0, 76.7, 0.0, 0.0, 100.0, 90.0, false, 2)
    SetCamActive(lobbyCam, true)
    RenderScriptCams(true, false, 1, true, false)
end

-- Leave the clothing menu
function CloseWardrobe()
    inWardrobe = false
    DisplayMenu(true)
    TriggerEvent("pb:Notification", "SUCCESS", "Saved wardrobe", true)
end

-- NUI callbacks
RegisterNUICallback("OpenClothing", function()
    OpenWardrobe()
end)

-- Net events
RegisterNetEvent("pb-menu:CloseWardrobe", function()
    CloseWardrobe()
end)