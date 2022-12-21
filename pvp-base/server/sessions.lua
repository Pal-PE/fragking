-- Variables
Sessions = {}
PB.Sessions = {}
local GetSessions

-- Create the session object, and setup default settings
function PB.Sessions:CreateSession(bucket, population, lockdown, name)
    -- Return false if the bucket is already in use
    if Sessions[bucket] then return false end

    Sessions[bucket] = {
        bucket = bucket,
        name = name,
        active = true,
        private = false,
        gamemode = nil,
        map = nil,
        mapPool = nil,
        flags = {},
        players = {},
        settings = {
            maxPlayers = 20,
            password = nil
        },
        gameData = {
            live = false,
            state = nil,
            logic = {
                Timer = 10
            }
        },
        Functions = {}
    }

    -- Flag functions
    Sessions[bucket].Functions.SetFlag = function(flag, value)
        Sessions[bucket].flags[flag] = value
        -- Actively apply any new flags to all players
        if flag == "god" then
            for k, v in pairs(Sessions[bucket].players) do
                SetPlayerInvincible(v, true)
            end
        end
        PB.Logging:NewLog("SESSION", false, "Set a sessions flag", {session = bucket, flag = flag, value = value}, true)
    end

    Sessions[bucket].Functions.SetMaxPlayers = function(value)
        Sessions[bucket].settings.maxPlayers = value
        PB.Logging:NewLog("SESSION", false, "Set a sessions max players", {session = bucket, value = value}, true)
    end

    Sessions[bucket].Functions.SetPassword = function(value)
        Sessions[bucket].settings.password = value
        Sessions[bucket].private = true
        PB.Logging:NewLog("SESSION", false, "Set a session to private", {session = bucket, password = value}, true)
    end

    Sessions[bucket].Functions.CloseSession = function(value)
        Sessions[bucket].active = false
        for k, v in pairs(Sessions[bucket].players) do
            if v then
                PB.Utility:Notify(k, "INFO", "The session you were in has closed.")
                PB.Sessions:LeaveSession(k)
                TriggerClientEvent("pb-menu:DisplayMenu", src, true)
            end
        end
    end

    -- Gamemode
    Sessions[bucket].Functions.SetGame = function(gamemode)
        Sessions[bucket].gamemode = gamemode
        PB.Logging:NewLog("SESSION", false, "Set a sessions gamemode", {session = bucket, gamemode = gamemode}, true)
    end

    Sessions[bucket].Functions.StartGame = function()
        Gamemodes[Sessions[bucket].gamemode].Handles.GameCycle(Sessions[bucket])
        Sessions[bucket].gameLive = true
        PB.Logging:NewLog("SESSION", false, "Started a sessions gamemode", {session = bucket, gamemode = Sessions[bucket].gamemode}, true)
    end

    -- Map
    Sessions[bucket].Functions.SetMap = function(map)
        Sessions[bucket].map = map
        PB.Logging:NewLog("SESSION", false, "Set a sessions map", {session = bucket, map = map}, true)
    end

    Sessions[bucket].Functions.SetMapPool = function(maps)
        Sessions[bucket].mapPool = maps
        PB.Logging:NewLog("SESSION", false, "Set a sessions mappool", {session = bucket, maps = maps}, true)
    end

    -- Set the native options
    SetRoutingBucketEntityLockdownMode(bucket, lockdown)
    SetRoutingBucketPopulationEnabled(bucket, population)

    PB.Logging:NewLog("SERVER", false, "Created a new session", {bucket = bucket}, true)

    return Sessions[bucket]

end

-- Add a player to session
function PB.Sessions:JoinSession(src, bucket, password)

    bucket = tonumber(bucket)

    if not Sessions[bucket] then
        TriggerClientEvent("pb-menu:DisplayMenu", src, true)
        PB.Utility:Notify(src, "ERROR", "An error occured while joining a new session", true)
        PB.Logging:NewError(src, true, "Attempted to set a players session to a session that does not exist", {session = session}, true)
        return false
    end

    if not Sessions[bucket].active then 
        PB.Utility:Notify(src, "ERROR", "Session has closed")
        PB.Logging:NewError(src, true, "Attempted to join an inactive session", {session = session}, true)
        return false 
    end

    -- Check if the games private, and if it is, then match password
    if Sessions[bucket].private then
        if not password then
            PB.Utility:Notify(src, "ERROR", "Session requires password", true)
            return
        end
        if not (password == Sessions[bucket].settings.password) then
            PB.Utility:Notify(src, "ERROR", "Incorrect password", true)
            return
        end
    end

    local ply = PB.Accounts:Get(src)
    if not ply then return false end

    -- Make sure they're not attempting to join a full session
    if Sessions[bucket].settings.maxPlayers then
        local plyCount = 0
        for k, v in pairs(Sessions[bucket].players) do
            if v then
                plyCount = plyCount + 1
            end
        end
        if plyCount >= Sessions[bucket].settings.maxPlayers then
            PB.Logging:NewError(src, true, "Attempted to join a full session", {session = session}, true)
            return false
        end
    end

    -- Remove the player from any existing session they may be in
    PB.Sessions:LeaveSession(src)

    if Sessions[bucket].players[src] then
        TriggerClientEvent("pb-menu:DisplayMenu", src, true)
        PB.Utility:Notify(src, "ERROR", "An error occured while joining a new session", true)
        PB.Logging:NewError(src, true, "Attempted to set a players session to the session they're already in", {session = session, plySession = ply.Session, plyInstance = GetPlayerRoutingBucket(src)}, true)
    else
        CreateThread(function()
            Sessions[bucket].players[src] = true
            SetPlayerRoutingBucket(src, bucket)
            ply.session = bucket
            PB.Logging:NewLog(src, true, "Player joined new session", {session = bucket}, true)

            -- Check if it failed
            Wait(200)
            if not GetPlayerRoutingBucket(src) == bucket then
                PB.Logging:NewError(src, true, "Player not in their matched routing bucket", {intendedBucket = bucket, actualBucket = GetPlayerRoutingBucket(src)})
                DropPlayer(src, "You were dropped to avoid a native session error, please contact a server developer with this message.")
            end

            -- Apply any flags that may be applied
            if Sessions[bucket].flags["god"] then
                SetPlayerInvincible(src, true)
            else
                SetPlayerInvincible(src, false)
            end

            -- Remove any prexisting loadout settings
            TriggerClientEvent("pb-loadout:LockLoadout", src, true)
            TriggerClientEvent("pb-loadout:ClearLoadout", src)

            -- Let the gamemode know
            if Sessions[bucket].gameData.live then
                Gamemodes[Sessions[bucket].gamemode].Handles.JoinTrigger(Sessions[bucket], src)
            end

            -- Let the client know that they've joined a new session
            TriggerClientEvent("pb:JoinedSession", src, Sessions[bucket])

        end)
    end
end

-- Remove player from session
function PB.Sessions:LeaveSession(src)
    local ply = PB.Accounts:Get(src)
    if not ply then return false end

    -- Let's go through and remove them from any sessions that exist
    for k, v in pairs(Sessions) do
        if v.players[src] then
            v.players[src] = false
            -- Let the gamemode know
            if v.gameData.live then
                Gamemodes[v.gamemode].Handles.LeaveTrigger(v, src)
            end
        end
    end
    
    ply.session = 0
    SetPlayerRoutingBucket(src, 0)
    PB.Logging:NewLog(src, true, "Player left session", {session = ply.session}, true)

    -- Let the client know that they've left the session
    TriggerClientEvent("pb:LeftSession", src)

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

function GetSessions()
    return Sessions
end

-- Auto-remove all inactive sessions
CreateThread(function()
    while true do
        Wait(600*1000)
        for k, v in pairs(Sessions) do
            if v.flags["official"] then return false end
            local plyCount = 0
            for x, y in pairs(v.players) do
                if y then
                    plyCount = plyCount + 1
                end
            end
            if plyCount == 0 then
                v.Functions.CloseSession()
            end
        end
    end
end)

-- Net events
RegisterNetEvent("pb:JoinSession", function(session, password)
    local src = source
    PB.Sessions:JoinSession(src, session, password)
end)

RegisterNetEvent("pb:RequestSessions", function()
    local src = source
    TriggerClientEvent("pb:ReceiveSessions", src, Sessions)
end)

RegisterNetEvent("pb:LeaveSession", function()
    local src = source
    PB.Sessions:LeaveSession(src)
end)

-- Exports
exports("GetSessions", GetSessions)