local tools = {}

local p = io.popen('find tools -maxdepth 1 -type f -name "*.lua" -printf "%f\\n"')

--Windows
-- local p = io.popen("dir /b tools\\*.lua")

if p == nil then
	return {}
end

for filename in p:lines() do
	local name = string.sub(filename, 0, #filename - 4)
	tools[name] = require("tools." .. name)
end

p:close()

return tools
