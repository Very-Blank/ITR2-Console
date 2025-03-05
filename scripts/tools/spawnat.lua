local UEHelpers = require("UEHelpers")

local spawnat = {}

---@param args table
function spawnat:Call(args, freeCam)
    if #args <= 1 then
	    return { success = false, message = "Too few arguments given" }
    end

    local world = UEHelpers:GetWorld()
    if not world:IsValid() then
	    return { success = false, message = "World was invalid" }
    end

    local location = {
        X = 0.0,
        Y = 0.0,
        Z = 0.0,
    }

    local rotation = {
        Pitch = 0.0,
        Yaw = 0.0,
        Roll = 0.0,
    }

    if args[1] == "selected" then
        location.X = freeCam.SelectedPosition.X
        location.Y = freeCam.SelectedPosition.Y
        location.Z = freeCam.SelectedPosition.Z + 100
    elseif args[1] == "hit" then
        location.X = freeCam.HitPosition.X
        location.Y = freeCam.HitPosition.Y
        location.Z = freeCam.HitPosition.Z + 100
    elseif args[1] == "cam" then
        location.X = freeCam.WorldPosition.X
        location.Y = freeCam.WorldPosition.Y
        location.Z = freeCam.WorldPosition.Z
    elseif args[1] == "multi" then
        for i = 1, #freeCam.MultiSelectedPositions, 1 do
            location.X = freeCam.MultiSelectedPositions[i].X
            location.Y = freeCam.MultiSelectedPositions[i].Y
            location.Z = freeCam.MultiSelectedPositions[i].Z

            for j = 2, #args, 1 do
                local name = args[j]
                local actor = StaticFindObject(name)
                if actor == nil or not actor:IsValid() then
                    LoadAsset(name)
                    actor = StaticFindObject(name)
                    if actor == nil or not actor:IsValid() then
                        return { success = false, message = "Failed to load asset: " .. name}
                    end
                end

                local spawnedItem = world:SpawnActor(actor, location, rotation)

                if not spawnedItem:IsValid() then
                    spawnedItem = world:SpawnActor(actor, location, rotation)
                    if not spawnedItem:IsValid() then
                        return { success = false, message = "Failed to spawn: " .. name}
                    end
                else
                    freeCam.PrintToOutput("Spawned an actor: " .. name, false)
                end
            end
        end

	    return { success = true, message = nil }
    else
	    return { success = false, message = "Incorrect position given" }
    end

    for i = 2, #args, 1 do
        local name = args[i]
        local actor = StaticFindObject(name)
        if actor == nil or not actor:IsValid() then
            LoadAsset(name)
            actor = StaticFindObject(name)
            if actor == nil or not actor:IsValid() then
                return { success = false, message = "Failed to load asset: " .. name}
            end
        end

        local spawnedItem = world:SpawnActor(actor, location, rotation)

        if not spawnedItem:IsValid() then
            spawnedItem = world:SpawnActor(actor, location, rotation)
            if not spawnedItem:IsValid() then
                return { success = false, message = "Failed to spawn: " .. name}
            end
        else
            freeCam.PrintToOutput("Spawned an actor: " .. name, false)
        end
    end

	return { success = true, message = nil }
end

return spawnat