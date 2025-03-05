local UEHelpers = require("UEHelpers")
local clear = {}

---@param args table
function clear:Call(args, freeCam)
    freeCam.ClearOutput()
	return { success = true, message = nil }
end

return clear