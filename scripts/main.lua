local UEHelpers = require("UEHelpers")
local ITR2 = require("ITR2")
local shell = require("shell")

function Print(val)
    print("|ITR2-Console| " .. val .. "\n")
end

-- MOD CONFIG --
local MOD_NAME = "FreeCam"
local ASSET_PATH = "/Game/Mods/FreeCam/FreeCam"
local ASSET_NAME = "FreeCam_C"
-- END CONFIG --

local hooksRegistered = false
function RegisterAllHooks()
    if hooksRegistered == false then
        RegisterHook("/Game/Mods/FreeCam/FreeCam.FreeCam_C:KonsoleFinished", KonsoleFinished)
        hooksRegistered = true
    end
end

local freeCam = nil
local function SpawnFreeCam(World)
    Print("Loading new cam")
    -- Get UE version-sensitive asset data
    local AssetData = {}
    AssetData.PackageName = UEHelpers.FindOrAddFName(ASSET_PATH)
    AssetData.AssetName = UEHelpers.FindOrAddFName(ASSET_NAME)

    -- Original loader's asset registry pattern
    local AssetRegistryHelpers = StaticFindObject("/Script/AssetRegistry.Default__AssetRegistryHelpers")
    if not AssetRegistryHelpers:IsValid() then
        Print("ERROR: Missing AssetRegistryHelpers")
        return
    end

    local AssetRegistry = AssetRegistryHelpers:GetAssetRegistry()
    if not AssetRegistry:IsValid() then
        Print("ERROR: Failed to get AssetRegistry")
        return
    end

    ExecuteInGameThread(function()
        local ModClass = AssetRegistryHelpers:GetAsset(AssetData)
        if not ModClass:IsValid() then
            print("")
            return
        end

        freeCam = World:SpawnActor(ModClass, {}, {})
        if freeCam:IsValid() then
            Print(string.format("SUCCESS! Spawned %s at %s", MOD_NAME, freeCam:GetFullName()))
            if freeCam.PreBeginPlay:IsValid() then
                freeCam.PreBeginPlay()
            end

            RegisterAllHooks()
        end
    end)
end

function KonsoleFinished()
    if freeCam == nil or not freeCam:IsValid() then
        local FreeCamInstance = FindFirstOf(ASSET_NAME)
        if not FreeCamInstance:IsValid() then
            return
        else
            freeCam = FreeCamInstance
        end
    end

    local args = freeCam.Args:ToString()
    if freeCam:IsValid() then
        shell:Run(shell, args, freeCam)
    end
end

-- ITR2.Events.RadiusGameMode.OnLevelLoaded(function()
--     SpawnFreeCam(UEHelpers.GetWorld())
-- end)


RegisterKeyBind(Key.P, function()
    if freeCam == nil or not freeCam:IsValid() then
        local FreeCamInstance = FindFirstOf(ASSET_NAME)
        if not FreeCamInstance:IsValid() then
            SpawnFreeCam(UEHelpers.GetWorld())
        else
            freeCam = FreeCamInstance
        end
    end
end)


local FreeCamInstance = FindFirstOf(ASSET_NAME)
if not FreeCamInstance:IsValid() then
else
    freeCam = FreeCamInstance
    RegisterAllHooks()
end


-- local ExistingActor = FindFirstOf("Actor")
-- if ExistingActor:IsValid() then
--     SpawnFreeCam(ExistingActor:GetWorld())
-- end
