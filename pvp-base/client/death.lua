-- Variables
allowedRespawn = true

-- Disable auto spawn on account load
RegisterNetEvent("pb:PlayerLoaded", function()
    exports["spawnmanager"]:setAutoSpawn(false)
    exports["spawnmanager"]:spawnPlayer(false)
end)

-- Handle death, and provide a killing player if possible
CreateThread(function()
    local attacker = false
    while true do
        Wait(100)
        -- Handle player dying
        if IsEntityDead(PlayerPedId()) then
            local pedKiller = GetPedSourceOfDeath(PlayerPedId())
            if IsEntityAPed(pedKiller) and IsPedAPlayer(pedKiller) then
                attacker = GetPlayerServerId(NetworkGetPlayerIndexFromPed(pedKiller))
            end
            TriggerServerEvent("pb:PlayerDied", attacker)
            -- Make sure the player is allowed to respawn
            while not allowedRespawn do
                Wait(500)
            end
            -- Respawn them
            handlingRespawn = true
            DoScreenFadeOut(500)
            exports["spawnmanager"]:spawnPlayer(false, Respawned)
            while handlingRespawn do
                Wait(0)
            end
        end
    end
end)

-- Handle respawn
function Respawned()
    handlingRespawn = false
    TriggerServerEvent("pb:PlayerRespawned", attacker)
    DoScreenFadeIn(500)
    CreateThread(function()
        SetEntityMaxHealth(PlayerPedId(), 200)
        SetEntityHealth(PlayerPedId(), 200)
        SetPedArmour(PlayerPedId(), 100)
        SetEntityInvincible(PlayerPedId(), true)
        SetEntityAlpha(PlayerPedId(), 200)
        Wait(400)
        SetEntityInvincible(PlayerPedId(), false)
        SetEntityAlpha(PlayerPedId(), 255)
    end)
end