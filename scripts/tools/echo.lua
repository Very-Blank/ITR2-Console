local echo = {}

function echo:Call(args)
	for _, arg in ipairs(args) do
		print(arg)
	end
end

return echo
