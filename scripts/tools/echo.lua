local echo = {}

---@param args table
function echo:Call(args, freeCam)
	local msg = "";
	for _, arg in ipairs(args) do
		msg = msg .. " " .. arg
	end

	return { success = true, message = msg }
end

return echo
