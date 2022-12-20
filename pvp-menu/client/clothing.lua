-- Variables
inWardobe = false

-- Get the player in a proper state for the clothing menu, then open it
function OpenWardrobe()
    inWardrobe = true
    DisplayMenu(false)
    SetEntityCoords(PlayerPedId(), vector3(329.188, 4840.853, -58.99949))
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

RegisterNetEvent("pb-menu:CreateNewChar", function()
    TriggerEvent("pb:Notification", "SUCCESS", "Welcome to FragKing!", true)
    TriggerEvent("raid_clothes:DefaultPed")
    RequestModel("mp_m_freemode_01")
    while (not HasModelLoaded("mp_m_freemode_01")) do
        Wait(0)
    end
    SetPlayerModel(PlayerId(), "mp_m_freemode_01")
    player = PlayerPedId()
    SetPedHeadBlendData(player, 0, 0, 0, 15, 0, 0, 0, 1.0, 0, false)
    SetPedComponentVariation(player, 11, 0, 11, 0)
    SetPedComponentVariation(player, 8, 0, 1, 0)
    SetPedComponentVariation(player, 6, 1, 2, 0)
    SetPedHeadOverlayColor(player, 1, 1, 0, 0)
    SetPedHeadOverlayColor(player, 2, 1, 0, 0)
    SetPedHeadOverlayColor(player, 4, 2, 0, 0)
    SetPedHeadOverlayColor(player, 5, 2, 0, 0)
    SetPedHeadOverlayColor(player, 8, 2, 0, 0)
    SetPedHeadOverlayColor(player, 10, 1, 0, 0)
    SetPedHeadOverlay(player, 1, 0, 0.0)
    SetPedHairColor(player, 1, 1)
    OpenWardrobe()
end)