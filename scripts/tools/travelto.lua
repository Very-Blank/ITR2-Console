local travelto = {}

---@param args table
function travelto:Call(args, freeCam)
    local subsystem = FindFirstOf("RadiusPlayerController")
    local LevelTag = {
        TagName = nil
    }
    if args[1] == "peninsula" then
        LevelTag.TagName = "Level.Radius.Peninsula.Gate2"
    elseif args[1] == "forest" then
        LevelTag.TagName = "Level.Radius.Forest.Gate2"
    elseif args[1] == "hub" then
        LevelTag.TagName = "Level.Radius.Town"
    end

    subsystem:Server_TravelTo(LevelTag)

	return { success = true, message = nil }
end

return travelto
