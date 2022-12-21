-- Variables
Gamemodes = {}
Games = {}
PB.Gamemodes = {}

-- Create gamemode
function PB.Gamemodes:CreateGamemode(gameid, name)
    Gamemodes[gameid] = {
        name = name,
        mapPool = {},
        Handles = {
            GameCycle = nil,
            JoinTrigger = nil,
            DeathTrigger = nil,
            RespawnTrigger = nil,
            LeaveTrigger = nil,
            CommandTrigger = nil
        },
        Functions = {}
    }

    local this = Gamemodes[gameid]

    -- Functions
    this.Functions.SetMapPool = function(maps)
        this.mapPool = maps
    end

    this.Functions.SetCycle = function(func)
        this.Handles.GameCycle = func
    end
    this.Functions.SetHandleJoin = function(func)
        this.Handles.JoinTrigger = func
    end
    this.Functions.SetHandleDeath = function(func)
        this.Handles.DeathTrigger = func
    end
    this.Functions.SetHandleRespawn = function(func)
        this.Handles.RespawnTrigger = func
    end
    this.Functions.SetHandleLeave = function(func)
        this.Handles.LeaveTrigger = func
    end
    this.Functions.SetHandleCommand = function(func)
        this.Handles.CommandTrigger = func
    end

    -- All done, now return
    return this
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