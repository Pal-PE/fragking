-- Variables
PB = exports["pvp-base"]:GetCoreObject()
local showMenu = false
local lobbyCam = nil

-- Get gamemodes, then trim them down and send them to the NUI
function GetGamemodes()
    CreateThread(function()
        PB.Gamemodes:RequestAll()
        -- Wait until we've got the gamemodes to start looping
        local gamemodes
        while gamemodes == nil do
            Wait(100)
            gamemodes = PB.Gamemodes:GetGamemodes()
        end
        -- Trim the fat
        local collectedGamemodes = {}
        for k, v in pairs(gamemodes) do
            if k == "training" then return false end
            collectedGamemodes[k] = {
                key = k,
                maps = {}
            }
            for x, y in pairs(v.MapPool) do
                collectedGamemodes[k].maps[y] = { key = y }
            end
        end
        SendNUIMessage({type = "SendGamemodes", gamemodes = collectedGamemodes})
    end)
end

-- Get sessions, then trim them down and send them to the NUI
function UpdateSessions()
    CreateThread(function()
        PB.Sessions:RequestAll()
        -- Wait until we've got the sessions to start looping
        local sessions
        while sessions == nil do
            Wait(100)
            sessions = PB.Sessions:GetSessions()
        end
        -- Trim the fat
        local collectedSessions = {}
        for k, v in pairs(sessions) do
            if v.Flags["hidden"] then return false end
            -- Calculate players
            local plyCount = 0
            for x, y in pairs(v.Players) do
                if y then
                    plyCount = plyCount + 1
                end
            end
            collectedSessions[k] = {
                id = k,
                name = v.Name,
                gamemode = v.Gamemode,
                map = v.Map,
                players = plyCount,
                maxplayers = v.Settings.MaxPlayers,
                locked = v.Private,
                official = v.Flags["official"]
            }
        end
        SendNUIMessage({type = "UpdateSessions", sessions = collectedSessions})
    end)
end

-- Set the player cam, TP them, all that stuff, then open the NUI
function DisplayMenu(value)
    if value == showMenu then return false end
    showMenu = value
    UpdateSessions()
    if value then
        TriggerScreenblurFadeIn(3000)
        lobbyCam = CreateCameraWithParams(`DEFAULT_SCRIPTED_CAMERA`, 128.0, -856.0, 180.0, 0.0, 0.0, 150.0, 90.0, false, 2)
        SetCamActive(lobbyCam, true)
        RenderScriptCams(true, false, 1, true, false)
        SetEntityCoords(PlayerPedId(), -1582.29, -569.52, 116.33)
        SendNUIMessage({type = "DisplayMenu", value = true})
        SetNuiFocus(true, true)
    else
        TriggerScreenblurFadeOut(3000)
        RenderScriptCams(false, false, 1, true, true)
        DestroyAllCams(true)
        SendNUIMessage({type = "DisplayMenu", value = false})
        SetNuiFocus(false, false)
    end
end

-- Net events
RegisterNetEvent("pb-menu:DisplayMenu", function(value)
    DisplayMenu(value)
end)

RegisterNetEvent("pb:JoinedSession", function()
    DisplayMenu(false)
end)

-- NUI callbacks
RegisterNUICallback("RefreshSessions", function(data)
    UpdateSessions()
end)

RegisterNUICallback("JoinSession", function(data)
    TriggerServerEvent("pb:JoinSession", data.session, data.password)
end)

RegisterNUICallback("CreateSession", function(data)
    TriggerServerEvent("pb-menu:CreateSession", data)
end)

RegisterNUICallback("QuickplayGG", function()
    TriggerServerEvent("pb-menu:QuickplayGG")
end)

RegisterNUICallback("QuickplayRZ", function()
    TriggerServerEvent("pb-menu:QuickplayRZ")
end)

RegisterNUICallback("QuickplayPractice", function()
    TriggerServerEvent("pb-menu:QuickplayPractice")
end)

RegisterNUICallback("RedeemCode", function(data)
    TriggerServerEvent("pb:RedeemCode", data.code)
end)

-- Send over locale data to NUI
CreateThread(function()
    Wait(500)
    SendNUIMessage({ type = "SendTranslations", locale = PB.Locale })
end)

-- Display menu on join
CreateThread(function()
    Wait(200)
    DisplayMenu(true)
    GetGamemodes()
end)

-- Exports
exports("DisplayMenu", DisplayMenu)