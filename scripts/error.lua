local error = {}

---@param args table
function error:Call(args, freeCam)
	local msg = "";
	for _, arg in ipairs(args) do
		msg = msg .. " " .. arg
	end

	return { success = false, message = msg }
end

return error
