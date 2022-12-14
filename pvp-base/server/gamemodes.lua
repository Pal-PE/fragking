-- Variables
Gamemodes = {}
Games = {}
PB.Gamemodes = {}

-- Create gamemode
function PB.Gamemodes:CreateGamemode(gameid, name, official)
    Gamemodes[gameid] = {
        Name = name,
        Official = official,
        MapPool = {},
        Handles = {
            GameCycle = nil,
            JoinTrigger = nil,
            DeathTrigger = nil,
            LeaveTrigger = nil,
            CommandTrigger = nil
        },
        Functions = {}
    }

    -- Functions
    Gamemodes[gameid].Functions.SetMapPool = function(maps)
        Gamemodes[gameid].MapPool = maps
    end

    Gamemodes[gameid].Functions.SetCycle = function(func)
        Gamemodes[gameid].Handles.GameCycle = func
    end
    Gamemodes[gameid].Functions.SetHandleJoin = function(func)
        Gamemodes[gameid].Handles.JoinTrigger = func
    end
    Gamemodes[gameid].Functions.SetHandleDeath = function(func)
        Gamemodes[gameid].Handles.DeathTrigger = func
    end
    Gamemodes[gameid].Functions.SetHandleLeave = function(func)
        Gamemodes[gameid].Handles.LeaveTrigger = func
    end
    Gamemodes[gameid].Functions.SetHandleCommand = function(func)
        Gamemodes[gameid].Handles.CommandTrigger = func
    end
    
    -- Return
    return Gamemodes[gameid]
end

-- Return gamemode object
function PB.Gamemodes:Get(game)
    return Gamemodes[game]
end

-- Net events
RegisterNetEvent("pb:RequestGamemodes", function()
    local src = source
    TriggerClientEvent("pb:ReceiveGamemodes", src, Gamemodes)
end)