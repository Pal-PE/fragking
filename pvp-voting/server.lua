-- Variables
PB = exports["pvp-base"]:GetCoreObject()
Votes = {}

-- Create new vote
function CreateVote(bucket, title, time, options)
    print(bucket)
    if Votes[bucket] then 
        PB.Logging:NewError("SERVER", false, "Attempted to create a vote in a bucket with an existing vote", {bucket = bucket,}, true)
        return false
    end

    -- Collect the session
    local session = PB.Sessions:Get(bucket)
    if not session then 
        PB.Logging:NewError("SERVER", false, "Failed to get session for new vote", {bucket = bucket,}, true)
        return false 
    end

    -- Add to the voting parent object
    Votes[bucket] = options

    -- Setup vote table, and fill empty gaps
    for k, v in pairs(Votes[bucket]) do
        if not v.name then
            v.name = "Invalid"
        end
        if not v.img then
            v.img = "nudist.png"
        end
        v.id = k
        v.votes = {}
    end

    -- Send vote to all players in lobby
    for k, v in pairs(session.players) do
        if v then
            TriggerClientEvent("pb-voting:ReceiveNewVote", k, title, Votes[bucket])
        end
    end

    -- Start timer to end the vote
    CreateThread(function()
        Wait(time*1000)
        -- Find the highest voted result
        local highestVote = nil
        local mostVotes = 0
        for k, v in pairs(Votes[bucket]) do
            if highestVote == nil or #v.votes > mostVotes then
                highestVote = k
                mostVotes = #v.votes
            end
        end
        -- Run the function of the most voted for option
        if highestVote then
            Votes[bucket][highestVote].Function()
        end
        -- Set object to false to avoid any buggy votes
        Votes[bucket] = false
        -- Close menu for any players who didn't vote
        local session = PB.Sessions:Get(bucket)
        if not session then return false end
        for k, v in pairs(session.players) do
            if v then
                TriggerClientEvent("pb-voting:VoteEnded", k)
            end
        end
    end)
end

-- Handle casting of a vote
function CastVote(src, bucket, key, ply)
    if not Votes[bucket] then return false end

    -- Make sure that the players not already voted
    local alrdyVoted = false
    for k, v in pairs(Votes[bucket]) do
        for x in pairs(v.votes) do
            if v.votes[x] == src then
                alrdyVoted = true
            end
        end
    end
    if alrdyVoted then return false end

    -- Cast vote
    Votes[bucket][key].votes[#Votes[bucket][key].votes+1] = src
    -- Extra vote for premium
    if ply.flags["premium"] then
        Votes[bucket][key].votes[#Votes[bucket][key].votes+1] = src
    end
    TriggerClientEvent("pb-voting:VoteEnded", src)
end

-- Net events
RegisterNetEvent("pb-voting:CastVote", function(key)
    local src = source
    local ply = PB.Accounts:Get(src)
    if not ply then return false end
    CastVote(src, ply.session, key, ply)
end)

-- Exports
exports("CreateVote", CreateVote)