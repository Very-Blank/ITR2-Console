local physics = {}

---@param args table
function physics:Call(args, freeCam)
	if #args == 0 then
		return { success = false, message = "No arguments given" }
	elseif #args > 1 then
		return { success = false, message = "Too many arguments given" }
	end

    if args[1] == "selected" then
        if freeCam.SelectedActor:IsValid() then
            freeCam.SelectedActor:K2_GetRootComponent():SetSimulatePhysics(true)
        else
		    return { success = false, message = "Selected actor was invalid" }
        end
    elseif args[1] == "hit" then
        if freeCam.HitActor:IsValid() then
            freeCam.HitActor:K2_GetRootComponent():SetSimulatePhysics(true)
        else
		    return { success = false, message = "Hit actor was invalid" }
        end
    end

	return { success = true, message = nil }
end

return physics