-- Core object
PB = {}
local GetCoreObject

-- Retrieve core framework object
function GetCoreObject()
    return PB
end

function GetCoreConfig()
    return Config
end

-- Handle player disconnecting
RegisterNetEvent("playerDropped", function(reason)
    local src = source
    PB.Sessions:LeaveSession(src)
    PB.Accounts:Save(src)
    PB.Logging.NewLog(src, true, "Player disconnected", {reason = reason}, true)
end)

-- Handle player death, triggers once they're back alive
RegisterNetEvent("pb:PlayerDied", function(attacker)
    local src = source
    local victimName = GetPlayerName(src)
    local ply = PB.Accounts:Get(src)
    if not ply then return false end
    if ply.session then
        local session = PB.Sessions:Get(ply.session)
        if not session then return false end
        -- Gamemode trigger
        if session.active and session.gamemode and session.gameData.live then
            Gamemodes[session.gamemode].Handles.DeathTrigger(session, src, attacker)
        end
        -- Handle the event if theres an attacker
        if attacker then
            local attackerName = GetPlayerName(attacker)
            -- Let all players in session know, for the killfeed
            if session.active then
                for k, v in pairs(session.players) do
                    if v then
                        TriggerClientEvent("pb-hud:AddKillFeed", k, src, attacker, victimName, attackerName)
                    end
                end
            end
            -- Set calling cards for attacker and victim
            local attackerPly = PB.Accounts:Get(attacker)
            if not attackerPly then return false end
            local attackerCallingCard
            if attackerPly.equippedItems["callingcard"] then
                attackerCallingCard = Config.Items[attackerPly.equippedItems["callingcard"]]
            else
                attackerCallingCard = Config.Items["calling_fng"]
            end
            local victimCallingCard
            if ply.equippedItems["callingcard"] then
                victimCallingCard = Config.Items[ply.equippedItems["callingcard"]]
            else
                victimCallingCard = Config.Items["calling_fng"]
            end
            TriggerClientEvent("pb-hud:SetKillbox", src, "Killed by " .. attackerName, attackerCallingCard.card,  attackerCallingCard.title)
            TriggerClientEvent("pb-hud:SetKillbox", attacker, "Killed " .. victimName, victimCallingCard.card,  victimCallingCard.title)
        end
    end
end)

-- Exports
exports("GetCoreObject", GetCoreObject)
exports("GetCoreConfig", GetCoreConfig)