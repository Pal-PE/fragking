-- Core object
PB = {}
local GetCoreObject

-- Retrieve core framework object
function GetCoreObject()
    return PB
end

-- Handle player disconnecting
RegisterNetEvent("playerDropped", function(reason)
    local src = source
    PB.Sessions:LeaveSession(src)
    PB.Accounts:Save(src)
    PB.Notify.AddLog(src, true, "Player disconnected", {reason = reason}, true)
end)

-- Handle player death, triggers once they're back alive
RegisterNetEvent("pb:PlayerDied", function(attacker)
    local src = source
    local ply = PB.Accounts:Get(src)
    if ply.session then
        local session = PB.Sessions:Get(ply.session)
        if not session then return false end
        -- Gamemode trigger
        if session.active and session.gamemode and session.gameData.live then
            Gamemodes[session.gamemode].Handles.DeathTrigger(session, src, attacker)
        end
        -- Let all players in session know, for the killfeed
        if attacker then
            local victimName = GetPlayerName(src)
            local attackerName = GetPlayerName(attacker)
            if session.active then
                for k, v in pairs(session.players) do
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