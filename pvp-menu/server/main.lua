-- Variables
PB = exports["pvp-base"]:GetCoreObject()

-- Create session
function CreateSession(src, data)
    -- Make sure we've got everything we need
    if data.name == nil then
        PB.Utility:Notify(src, "ERROR", "No session name", true)
        return
    elseif data.gamemode == nil then
        PB.Utility:Notify(src, "ERROR", "No gamemode select", true)
        return
    elseif data.map == nil then
        PB.Utility:Notify(src, "ERROR", "No map selected", true)
        return
    end
    -- Create the new session
    local newSession = PB.Sessions:CreateSession(100+src, "strict", true, data.name)
    if not newSession then
        PB.Utility:Notify(src, "ERROR", "Couldn't create session", true)
        return
    end
    newSession.Functions.SetGame(data.gamemode)
    newSession.Functions.SetMap(data.map)
    -- Add a password, if needed
    if data.password and string.len(data.password) > 0 then
        newSession.Functions.SetPassword(data.password)
    end
    -- Start the game and connect the host
    newSession.Functions.StartGame()
    PB.Sessions:JoinSession(src, 100+src, data.password)
end

-- Find best session
function FindBestSession(src, gm)
    local src = source
    local sessions = PB.Sessions:GetAll()
    local bestLobby = false
    local bestPlayers = nil
    for k, v in pairs(sessions) do
        if not v.Gamemode == gm then return false end
        local plyCount = 0
        for k, v in pairs(v.Players) do
            if v then
                plyCount = plyCount + 1
            end
        end
        if plyCount >= v.Settings.MaxPlayers then return false end
        if bestLobby == false or plyCount > bestPlayers then
            bestLobby = k
            bestPlayers = plyCount
        end
    end
    if bestLobby then
        PB.Sessions:JoinSession(src, bestLobby)
    else
        PB.Utility:Notify(src, "ERROR", "No available lobbies were found matching this gamemode.")
    end
end

-- Net events
RegisterNetEvent("pb-menu:CreateSession", function(data)
    local src = source
    CreateSession(src, data)
end)

RegisterNetEvent("pb-menu:QuickplayFFA", function()
    local src = source
    FindBestSession(src, "ffa")
end)

RegisterNetEvent("pb-menu:Quickplay1v1", function()
    local src = source
    FindBestSession(src, "1v1")
end)

RegisterNetEvent("pb-menu:QuickplayPractice", function()
    print("start practice tool!")
end)