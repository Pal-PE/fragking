-- Variables
PB = exports["pvp-base"]:GetCoreObject()
local activites = {"classic","speed","gridshot","tracking","precision","targetswap"}
local difficulties = {"easy","normal","hard","pro"}
highscores = {}
local NewScore, UpdateHighscores, GetStats

-- Handle new score, and replace former record if needed
function NewScore(src, activity, difficulty, score)
    if not src or not activity or not difficulty or not score then
        return false
    end

    local ply = PB.Accounts:Get(src)
    if not ply then return false end

    TriggerEvent("pb:NewLog", src, true, "Finished training drill", {activity = activity, difficulty = difficulty, score = score}, false)

    local date = os.time()

    -- Add attempt to the database
    exports.oxmysql:query("INSERT INTO pb_training_attempts (identifier, activity, difficulty, score, grade, date) VALUES (?, ?, ?, ?, ?, ?)",
    {ply.identifier, activity, difficulty, score, "?", date}, function() end)

    -- Check if it's a top score
    exports.oxmysql:query("SELECT * FROM pb_training_leaderboard WHERE identifier = ? AND activity = ? AND difficulty = ?",
    {ply.identifier, activity, difficulty}, function(result)
        if result[1] then
            if score > result[1].score then
                exports.oxmysql:query("UPDATE pb_training_leaderboard SET score = ?, name = ? WHERE identifier = ? AND activity = ? AND difficulty = ?",
                {score, GetPlayerName(src), ply.identifier, activity, difficulty}, function()
                    if result then
                        TriggerClientEvent("pb:Notification", src, "SUCCESS", "NEW PERSONAL BEST!", true)
                    end
                end)
            end
        else
            exports.oxmysql:query("INSERT INTO pb_training_leaderboard (identifier, activity, difficulty, score, name) VALUES (?, ?, ?, ?, ?)",
            {ply.identifier, activity, difficulty, score, GetPlayerName(src)}, function()
                if result then
                    TriggerClientEvent("pb:Notification", src, "SUCCESS", "NEW PERSONAL BEST", true)
                end
            end)
        end
    end)
end

-- Update high scores
function UpdateHighscores()
    highscores = {}
    for k in pairs(activites) do
        highscores[activites[k]] = {}
        for x in pairs(difficulties) do
            exports.oxmysql:query("SELECT * FROM pb_training_leaderboard WHERE activity = ? AND difficulty = ? ORDER BY score DESC LIMIT 100",
            {activites[k], difficulties[x]}, function(result)
                if result then
                    highscores[activites[k]][difficulties[x]] = result
                end
            end)
        end
    end
end

-- Get high scores
UpdateHighscores()
CreateThread(function()
    while true do
        Wait(600*1000)
        UpdateHighscores()
    end
end)

-- Get player stats
function GetStats(src)
    if not src then return false end

    local ply = PB.Accounts:Get(src)
    if not ply then return false end

    local stats = {}
    local activitesProcessed = 0

    for k in pairs(activites) do
        stats[activites[k]] = {}
        for x in pairs(difficulties) do
            -- Get top 50 scores
            exports.oxmysql:query("SELECT * FROM pb_training_attempts WHERE activity = ? AND difficulty = ? AND identifier = ? ORDER BY score DESC LIMIT 50",
            {activites[k], difficulties[x], ply.identifier}, function(result)
                if result then
                    stats[activites[k]][difficulties[x]] = {}
                    stats[activites[k]][difficulties[x]].personalBest = 0
                    if result[1] then
                        stats[activites[k]][difficulties[x]].personalBest = result[1].score
                    end
                    local top20 = 0
                    local top50 = 0
                    for i, o in pairs(result) do
                        if i <= 20 then
                            top20 = top20 + o.score
                        end
                        top50 = top50 + o.score
                    end
                    stats[activites[k]][difficulties[x]].top20 = top20
                    stats[activites[k]][difficulties[x]].top50 = top50
                    -- Get 20 most recent scores
                    exports.oxmysql:query("SELECT * FROM pb_training_attempts WHERE activity = ? AND difficulty = ? AND identifier = ? ORDER BY date DESC LIMIT 20",
                    {activites[k], difficulties[x], ply.identifier}, function(result2)
                        if result2 then
                            stats[activites[k]][difficulties[x]].history = result2
                            activitesProcessed = activitesProcessed + 1
                        end
                    end)
                end
            end)
        end
    end

    -- Send the player their stats once all activites have been processed
    while activitesProcessed < #activites*#difficulties do 
        Wait(100)
    end
    print("finished processing")
    TriggerClientEvent("pb-practice:ReceiveStats", src, stats)

end


-- Net events
RegisterNetEvent("pb-practice:FinishedDrill", function(activity, difficulty, score)
    local src = source
    NewScore(src, activity, difficulty, score)
end)

RegisterNetEvent("pb-practice:GetHighscores", function()
    local src = source
    TriggerClientEvent("pb-practice:ReceiveHighscores", src, highscores)
end)

RegisterNetEvent("pb-practice:GetStats", function()
    local src = source
    GetStats(src)
end)