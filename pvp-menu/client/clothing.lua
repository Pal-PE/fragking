-- Variables
inWardobe = false

-- Get the player in a proper state for the clothing menu, then open it
function OpenWardrobe(menu)
    inWardrobe = true
    DisplayMenu(false)
    SetEntityCoords(PlayerPedId(), vector3(1201.985, -3119.809, 4.540318))
    SetEntityHeading(PlayerPedId(), 357.5)
    FreezeEntityPosition(PlayerPedId(), true)
    TriggerEvent("raid_clothes:OpenMenu", menu)
    lobbyCam = CreateCameraWithParams(`DEFAULT_SCRIPTED_CAMERA`, 1202.087, -3117.189, 6.540325, 345.0, 0.0, 170.0, 70.0, false, 2)
    SetCamActive(lobbyCam, true)
    RenderScriptCams(true, false, 1, true, false)
    GiveWeaponToPed(PlayerPedId(), "weapon_compactrifle", 0, true, true)
end

-- Leave the clothing menu
function CloseWardrobe()
    inWardrobe = false
    DisplayMenu(true)
    RemoveAllPedWeapons(PlayerPedId())
    TriggerEvent("pb:Notification", "SUCCESS", "Saved wardrobe", true)
end

-- NUI callbacks
RegisterNUICallback("OpenClothing", function()
    OpenWardrobe("clothesmenu")
end)

RegisterNUICallback("OpenBarber", function()
    OpenWardrobe("barbermenu")
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
    SetPedComponentVariation(player, 11, 245, 5, 0) -- Torso
    SetPedComponentVariation(player, 4, 69, 0, 0) -- Bottoms
    SetPedComponentVariation(player, 8, 15, 1, 0) -- Undershirt
    SetPedComponentVariation(player, 6, 34, 0, 0) -- Shoes
    SetPedPropIndex(player, 0, 22, 0, true) -- Hat
    SetPedHeadOverlayColor(player, 1, 1, 0, 0)
    SetPedHeadOverlayColor(player, 2, 1, 0, 0)
    SetPedHeadOverlayColor(player, 4, 2, 0, 0)
    SetPedHeadOverlayColor(player, 5, 2, 0, 0)
    SetPedHeadOverlayColor(player, 8, 2, 0, 0)
    SetPedHeadOverlayColor(player, 10, 1, 0, 0)
    SetPedHeadOverlay(player, 1, 0, 0.0)
    SetPedHairColor(player, 1, 1)
    OpenWardrobe("clothesmenu")
end)