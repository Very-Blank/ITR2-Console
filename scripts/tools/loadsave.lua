local loadsave = {}

---@param args table
function loadsave:Call(args, freeCam)
    local subsystem = FindFirstOf("RadiusCheatManager")
    subsystem:LoadGame(1, 1, false)

	return { success = true, message = nil }
end

return loadsave