local destroy = {}

---@param args table
function destroy:Call(args, freeCam)
	if #args == 0 then
		return { success = false, message = "No arguments given" }
	elseif #args > 1 then
		return { success = false, message = "Too many arguments given" }
	end

    if args[1] == "selected" then
        if freeCam.SelectedActor:IsValid() then
            freeCam.SelectedActor:K2_DestroyActor()
		    return { success = true, message = "Destroyed selected actor" }
        else
		    return { success = false, message = "Select actor was invalid" }
        end
    elseif args[1] == "hit" then
        if freeCam.HitActor:IsValid() then
            freeCam.HitActor:K2_DestroyActor()
		    return { success = true, message = "Destroyed selected actor" }
        else
		    return { success = false, message = "Select actor was invalid" }
        end
    elseif args[1] == "multi" then
        for i = 1, #freeCam.MultiSelectedActors, 1 do
            if freeCam.MultiSelectedActors[i]:IsValid() then
                freeCam.MultiSelectedActors[i]:K2_DestroyActor()
            end
        end

        freeCam.MultiSelectedActors:Empty()
    end

	return { success = false, message = nil }
end

return destroy