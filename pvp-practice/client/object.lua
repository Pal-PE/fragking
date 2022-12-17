-- Variables
pracObjects = {}

-- Create practice object
function CreatePracObject(model, startPos)
    if not inTraining then return false end

    -- Load model
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(1)
        end
    end

    -- Create the object
    pracObjects[#pracObjects+1] = CreateObject(model, startPos, false, false)
    SetEntityHeading(pracObjects[#pracObjects], 195.5)
    SetEntityHealth(pracObjects[#pracObjects], 100000000)
    SetEntityCollision(pracObjects[#pracObjects], false, true)
    SetObjectPhysicsParams(pracObjects[#pracObjects], 10000.0)
    return pracObjects[#pracObjects]
end

-- Delete practice objects
function ClearPracObjects()
    for k in pairs(pracObjects) do
        DeleteObject(pracObjects[k])
    end
end