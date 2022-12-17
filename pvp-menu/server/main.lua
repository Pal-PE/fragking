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
    local sessions = exports["pvp-base"]:GetSessions()
    local bestLobby = false
    local bestPlayers = nil
    for k, v in pairs(sessions) do
        if not v.private and v.gamemode == gm then
            local plyCount = 0
            for x, y in pairs(v.players) do
                if y then
                    plyCount = plyCount + 1
                end
            end
            if plyCount >= v.settings.maxPlayers then return false end
            if bestLobby == false or plyCount > bestPlayers then
                bestLobby = k
                bestPlayers = plyCount
            end
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

RegisterNetEvent("pb-menu:FindBestMatch", function(gamemode)
    local src = source
    FindBestSession(src, gamemode)
end)

RegisterNetEvent("pb-menu:StartTraining", function()
    local src = source
    -- If the session exists, connect using the premade pass, if not then create it and connect them
    if PB.Sessions:Get(1000+src) then
        PB.Sessions:JoinSession(src, 1000+src, "HIDDENPASSWORD" .. src)
    else
        local newSession = PB.Sessions:CreateSession(1000+src, "strict", true, "Practice")
        newSession.Functions.SetPassword("HIDDENPASSWORD" .. src)
        if not newSession then
            PB.Utility:Notify(src, "ERROR", "Couldn't create practice session", true)
            return
        end
        newSession.Functions.SetGame("training")
        newSession.Functions.SetMap("facility")
        newSession.Functions.SetFlag("official", true)
        newSession.Functions.SetFlag("hidden", true)
        newSession.Functions.StartGame()
        PB.Sessions:JoinSession(src, 1000+src, "HIDDENPASSWORD" .. src)
    end
end)