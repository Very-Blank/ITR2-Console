local shell = {
	tools = require("tools"),
	builtins = require("builtins"),
}

function IsWhitespace(char)
	return char:match("^%s$") ~= nil
end

---@param text string
function shell:Parse(text)
	local commands = { {} }
	local currentArgs = 1
	local arg = ""
	local qouteStarted = false

	for c in text:gmatch(".") do
		if IsWhitespace(c) and qouteStarted == false then
			if #arg > 0 then
				table.insert(commands[currentArgs], arg)
				arg = ""
			end
		elseif c == '"' then
			if qouteStarted then
				if #arg > 0 then
					table.insert(commands[currentArgs], arg)
					arg = ""
				end
			else
				qouteStarted = true
			end
		elseif c == ";" then
			table.insert(commands, {})
			currentArgs = currentArgs + 1
		else
			arg = arg .. c
		end
	end

	if #arg > 0 then
		table.insert(commands[currentArgs], arg)
	end

	return commands
end

---@param args table
function shell:ProcessAliases(sh, args)
	for _ = 1, 2, 1 do
		local newArgs = {}
		for _, arg in ipairs(args) do
			if #arg > 3 then
				local aliasMarker = string.sub(arg, 1, 2)
				if aliasMarker == "a:" then
					local newArg = sh.builtins.alias:ToArg(string.sub(arg, 3, nil))
					if newArg ~= nil then
						if type(newArg) == "table" then
							for _, value in ipairs(newArg) do
								table.insert(newArgs, value)
							end
						elseif type(newArg) == "string" then
							table.insert(newArgs, newArg)
						end
					else
						table.insert(newArgs, arg)
					end
				else
					table.insert(newArgs, arg)
				end
			else
				table.insert(newArgs, arg)
			end
		end

		args = newArgs
	end

	return args
end

---@param commands table
function shell:Execute(sh, commands, freeCam)
	for _, args in ipairs(commands) do
		if #args > 0 then
			local tool = args[1]
			table.remove(args, 1)
			if sh.builtins[tool] ~= nil then
				local value = sh.builtins[tool]:Call(sh, args, freeCam)
				if value ~= nil and value.success and value.message ~= nil then
					freeCam.PrintToOutput(value.message, false)
				elseif value ~= nil and not value.success and value.message ~= nil then
					freeCam.PrintToOutput(value.message, true)
				end
			elseif sh.tools[tool] ~= nil then
				local value = sh.tools[tool]:Call(args, freeCam)
				if value ~= nil and value.success and value.message ~= nil then
					freeCam.PrintToOutput(value.message, false)
				elseif value ~= nil and not value.success and value.message ~= nil then
					freeCam.PrintToOutput(value.message, true)
				end
			else
				freeCam.PrintToOutput("Tool not found", true)
			end
		end
	end
end

---@param text string
function shell:Run(sh, text, freeCam)
	local commands = sh:Parse(text)
	for i, args in ipairs(commands) do
		commands[i] = sh:ProcessAliases(sh, args)
	end

	sh:Execute(sh, commands, freeCam)
end

return shell
