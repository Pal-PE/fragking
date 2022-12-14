-- Core object
PB = {}

-- Retrieve core framework object
function GetCoreObject()
    return PB
end

-- Handle player disconnecting
RegisterNetEvent("playerDropped", function(reason)
    local src = source
    PB.Accounts:Save(src)
    PB.Sessions:LeaveSession(src)
end)

-- Handle player death
RegisterNetEvent("pb:PlayerDied", function(attacker)
    local src = source
    local ply = PB.Accounts:Get(src)
    if ply.Session then
        local session = PB.Sessions:Get(ply.Session)
        if not session then return false end
        -- Gamemode trigger
        if session.Active and session.Gamemode and session.GameData.Live then
            Gamemodes[session.Gamemode].Handles.DeathTrigger(session, src, attacker)
        end
        -- Let all players in session know, for the killfeed
        if attacker then
            local victimName = GetPlayerName(src)
            local attackerName = GetPlayerName(attacker)
            if session.Active then
                for k, v in pairs(session.Players) do
                    if v then
                        TriggerClientEvent("pb-hud:AddKillFeed", k, src, attacker, victimName, attackerName)
                    end
                end
            end
        end
    end
end)

-- Exports
exports("GetCoreObject", GetCoreObject)