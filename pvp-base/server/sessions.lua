-- Variables
Sessions = {}
PB.Sessions = {}

-- Create the session object, and setup default settings
function PB.Sessions:CreateSession(bucket, population, lockdown, name)
    -- Return false if the bucket is already in use
    if Sessions[bucket] then return false end

    Sessions[bucket] = {
        Name = name,
        Active = true,
        Private = false,
        Gamemode = nil,
        Map = nil,
        Flags = {},
        Players = {},
        Settings = {
            MaxPlayers = 20,
            Password = nil,
            Official = false
        },
        GameData = {
            Live = false,
            State = nil,
            Logic = {
                Timer = 10
            }
        },
        Functions = {}
    }

    -- SESSION OBJECT FUNCTIONS
    -- Official?
    Sessions[bucket].Functions.SetOfficial = function(value)
        Sessions[bucket].Settings.Official = value
    end

    -- Flag functions
    Sessions[bucket].Functions.GetFlag = function(flag)
        return Sessions[bucket].Flags[flag]
    end

    Sessions[bucket].Functions.SetFlag = function(flag, value)
        Sessions[bucket].Flags[flag] = value
        -- Actively apply any new flags to all players
        if flag == "god" then
            for k, v in pairs(Sessions[bucket].Players) do
                SetPlayerInvincible(v, true)
            end
        end
        PB.Logging:NewLog("SESSION", false, "Set a sessions flag", {session = bucket, flag = flag, value = value}, true)
    end

    Sessions[bucket].Functions.SetMaxPlayers = function(value)
        Sessions[bucket].Settings.MaxPlayers = value
        PB.Logging:NewLog("SESSION", false, "Set a sessions max players", {session = bucket, value = value}, true)
    end

    Sessions[bucket].Functions.SetPassword = function(value)
        Sessions[bucket].Settings.Password = value
        Sessions[bucket].Private = true
        PB.Logging:NewLog("SESSION", false, "Set a session to private", {session = bucket, password = value}, true)
    end

    Sessions[bucket].Functions.CloseSession = function(value)
        Sessions[bucket].active = false
        for k, v in pairs(Sessions[bucket].Players) do
            if v then
                PB.Utility:Notify(src, "INFO", "The session you were in has closed.")
                --PB.Lobby:JoinLobby(v)
            end
        end
    end

    -- Gamemode
    Sessions[bucket].Functions.SetGame = function(gamemode)
        Sessions[bucket].Gamemode = gamemode
        PB.Logging:NewLog("SESSION", false, "Set a sessions gamemode", {session = bucket, gamemode = gamemode}, true)
    end

    Sessions[bucket].Functions.StartGame = function()
        Gamemodes[Sessions[bucket].Gamemode].Handles.GameCycle(Sessions[bucket])
        Sessions[bucket].gameLive = true
        PB.Logging:NewLog("SESSION", false, "Started a sessions gamemode", {session = bucket, gamemode = Sessions[bucket].Gamemode}, true)
    end

    -- Map
    Sessions[bucket].Functions.SetMap = function(map)
        Sessions[bucket].Map = map
        PB.Logging:NewLog("SESSION", false, "Set a sessions map", {session = bucket, map = map}, true)
    end

    -- Set the native options
    SetRoutingBucketEntityLockdownMode(bucket, lockdown)
    SetRoutingBucketPopulationEnabled(bucket, population)

    PB.Logging:NewLog("SERVER", false, "Created a new session", {session = bucket, data = Sessions[bucket].data}, true)

    return Sessions[bucket]
end

-- Add a player to session
function PB.Sessions:JoinSession(src, bucket)
    bucket = tonumber(bucket)

    if not Sessions[bucket] then
        --PB.Lobby:JoinLobby(src)
        PB.Utility:Notify(src, "ERROR", "An error occured while joining a new session.")
        PB.Logging:NewError(src, true, "Attempted to set a players session to a session that does not exist", {session = session}, true)
        return false
    end

    if not Sessions[bucket].Active then 
        PB.Logging:NewError(src, true, "Attempted to join an inactive session", {session = session}, true)
        return false 
    end

    local ply = PB.Accounts:Get(src)
    if not ply then return false end

    -- Make sure they're not attempting to join a full session
    if Sessions[bucket].Settings.MaxPlayers then
        local plyCount = 0
        for k, v in pairs(Sessions[bucket].Players) do
            if v then
                plyCount = plyCount + 1
            end
        end
        if plyCount >= Sessions[bucket].Settings.MaxPlayers then
            PB.Logging:NewError(src, true, "Attempted to join a full session", {session = session}, true)
            return false
        end
    end

    -- Remove the player from any existing session they may be in
    PB.Sessions:LeaveSession(src)

    if Sessions[bucket].Players[src] then
        --PB.Lobby:JoinLobby(src)
        PB.Utility:Notify(src, "ERROR", "An error occured while joining a new session.")
        PB.Logging:NewError(src, true, "Attempted to set a players session to the session they're already in", {session = session, plySession = ply.Session, plyInstance = GetPlayerRoutingBucket(src)}, true)
    else
        CreateThread(function()
            Sessions[bucket].Players[src] = true
            SetPlayerRoutingBucket(src, bucket)
            ply.Session = bucket
            PB.Logging:NewLog(src, true, "Player joined new session", {session = bucket}, true)

            -- Check if it failed
            Wait(200)
            if not GetPlayerRoutingBucket(src) == bucket then
                PB.Logging:NewError(src, true, "Player not in their matched routing bucket", {intendedBucket = bucket, actualBucket = GetPlayerRoutingBucket(src)})
                DropPlayer(src, "You were dropped to avoid a native session error, please contact a server developer with this message.")
            end

            -- Apply any flags that may be applied
            if Sessions[bucket].Flags["god"] then
                SetPlayerInvincible(src, true)
            else
                SetPlayerInvincible(src, false)
            end

            -- Remove any prexisting loadout settings
            TriggerClientEvent("pb-loadout:LockLoadout", src, true)
            TriggerClientEvent("pb-loadout:ClearLoadout", src)

            -- Let the gamemode know
            if Sessions[bucket].GameData.Live then
                Gamemodes[Sessions[bucket].Gamemode].Handles.JoinTrigger(Sessions[bucket], src)
            end

        end)
    end

    -- Let the client know that they've joined a new session
    TriggerClientEvent("pb:JoinedSession", src, Sessions[bucket])
end

-- Remove player from session
function PB.Sessions:LeaveSession(src)
    local ply = PB.Accounts:Get(src)
    if not ply then return false end

    -- Let's go through and remove them from any sessions that exist
    for k, v in pairs(Sessions) do
        if v.Players[src] then
            v.Players[src] = false
            -- Let the gamemode know
            if v.GameData.Live then
                Gamemodes[v.Gamemode].Handles.LeaveTrigger(v, src)
            end
        end
    end
        
    SetPlayerRoutingBucket(src, 0)
    TriggerClientEvent("pb:LeftSession", src)
    PB.Logging:NewLog(src, true, "Player left session", {session = ply.Session}, true)
    ply.Session = 0
end

-- Get session object
function PB.Sessions:Get(session)
    if Sessions[session] then
        return Sessions[session]
    else
        PB.Logging:NewError("SERVER", false, "Couldn't find session object", {session = session}, true)
    end
end

-- Get parent session object
function PB.Sessions:GetAll()
    return Sessions
end

-- Net events
RegisterNetEvent("pb:JoinSession", function(session)
    local src = source
    PB.Sessions:JoinSession(src, session)
end)

RegisterNetEvent("pb:RequestSessions", function()
    local src = source
    TriggerClientEvent("pb:ReceiveSessions", src, Sessions)
end)

-- Commands
RegisterCommand("leave", function(src)
    PB.Sessions:LeaveSession(src)
    TriggerClientEvent("pb-menu:DisplayMenu", src, true)
end, false)