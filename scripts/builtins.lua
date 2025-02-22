local alias = {
	["test"] = "really long thing that is boring",
	["superTest"] = { "long text:", "a:test" },
}

---@param arg string
function alias:ToArg(arg)
	return alias[arg]
end

---@param args table
function alias:Call(args)
	if args == nil then
		return { success = false, message = "No arguments given" }
	elseif #args > 2 and args[1] == "-r" then
	else
		return { success = false, message = "Too many arguments given" }
	end

	if #args == 2 then
		self[args[1]] = args[2]
		return { success = true, message = nil }
	end

	if #args == 1 and args[1] == "-h" then
		return {
			success = true,
			message = 'Usage: name "arguments that the alias should correspond to"\n' .. "Usage: -r name1 name2 ...",
		}
	end

	return { success = true, message = nil }
end

local builtins = {
	alias = alias,
}

return builtins
