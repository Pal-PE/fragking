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
            local attackerPly = PB.Accounts:Get(attacker)
            if not attackerPly then return false end
            local attackerName = GetPlayerName(attacker)
            local attackerColour
            if attackerPly.equippedItems["colname"] then
                attackerColour = Config.Items[attackerPly.equippedItems["colname"]].colour
            else
                attackerColour = Config.Items["col_white"].colour
            end
            local victimColour
            if ply.equippedItems["colname"] then
                victimColour = Config.Items[ply.equippedItems["colname"]].colour
            else
                victimColour = Config.Items["col_white"].colour
            end
            -- Let all players in session know, for the killfeed
            if session.active then
                for k, v in pairs(session.players) do
                    if v then
                        TriggerClientEvent("pb-hud:AddKillFeed", k, src, attacker, victimName, victimColour, attackerName, attackerColour)
                    end
                end
            end
            -- Set calling cards for attacker and victim
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
            TriggerClientEvent("pb-hud:SetKillbox", src, "Killed by ", attackerName, attackerColour, attackerCallingCard.card,  attackerCallingCard.title)
            TriggerClientEvent("pb-hud:SetKillbox", attacker, "Killed ", victimName, victimColour, victimCallingCard.card,  victimCallingCard.title)
        end
    end
end)

-- Exports
exports("GetCoreObject", GetCoreObject)
exports("GetCoreConfig", GetCoreConfig)