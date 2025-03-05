local alias = {
   	["policeman"] ="/Game/ITR2/BPs/AI/Enemies/Mimic/BP_RadiusNPCCharacterMimicPoliceman.BP_RadiusNPCCharacterMimicPoliceman_C",
   	["jaeger"] ="/Game/ITR2/BPs/AI/Enemies/Mimic/BP_RadiusNPCCharacterMimicJaeger.BP_RadiusNPCCharacterMimicJaeger_C",
   	["scout"] ="/Game/ITR2/BPs/AI/Enemies/Mimic/BP_RadiusNPCCharacterMimicScout.BP_RadiusNPCCharacterMimicScout_C",
   	["heavy"] ="/Game/ITR2/BPs/AI/Enemies/Mimic/BP_RadiusNPCCharacterMimicHeavy.BP_RadiusNPCCharacterMimicHeavy_C",
   	["assault"] ="/Game/ITR2/BPs/AI/Enemies/Mimic/BP_RadiusNPCCharacterMimicAssault.BP_RadiusNPCCharacterMimicAssault_C",
   	["marksman"] ="/Game/ITR2/BPs/AI/Enemies/Mimic/BP_RadiusNPCCharacterMimicMarksman.BP_RadiusNPCCharacterMimicMarksman_C",
   	["creeps"] ="/Game/ITR2/BPs/AI/Enemies/Spawn/BP_RadiusNPCCharacterCreep.BP_RadiusNPCCharacterCreep_C",
   	["creepb"] ="/Game/ITR2/BPs/AI/Enemies/Spawn/BP_RadiusNPCCharacterCreepBig.BP_RadiusNPCCharacterCreepBig_C",
   	["fragr"] ="/Game/ITR2/BPs/AI/Enemies/Fragment/BP_RadiusNPCCharacterFragmentRessurective.BP_RadiusNPCCharacterFragmentRessurective_C",
   	["fragb"] ="/Game/ITR2/BPs/AI/Enemies/Fragment/BP_RadiusNPCCharacterFragmentBase.BP_RadiusNPCCharacterFragmentBase_C",
}

---@param arg string
function alias:ToArg(arg)
	return alias[arg]
end

---@param sh table
---@param args table
function alias:Call(sh, args, freeCam)
	if args == nil then
		return { success = false, message = "No arguments given" }
	elseif #args > 2 and args[1] == "-r" then
	else
		return { success = false, message = "Too many arguments given" }
	end

	if #args == 2 then
		sh.builtins.alias[args[1]] = args[2]
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

local reload = {}

---@param sh table
---@param args table
function reload:Call(sh, args, freeCam)
    -- Clear ALL relevant caches
    package.loaded.toolLoader = nil
    for k in pairs(package.loaded) do
        if k:match("^tools") then
            package.loaded[k] = nil
        end
    end

	sh.tools = require("tools")

	return { success = true, message = "Tools reloaded" }
end

local builtins = {
	alias = alias,
	reload = reload,
}

return builtins
