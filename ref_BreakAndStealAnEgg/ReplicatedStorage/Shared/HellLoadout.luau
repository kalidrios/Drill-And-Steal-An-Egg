-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local BatToolQuery = require(ReplicatedStorage.Shared.BatToolQuery)
local HellEssenceConfig = require(ReplicatedStorage.Shared.HellEssenceConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local v1 = {}

function v1.Gathering() -- line 31 | captures: Workspace, HellEssenceConfig
    return Workspace:GetAttribute(HellEssenceConfig.GatherAttribute) == true
end

function v1.InHell(v2) -- line 35 | captures: HellEventConfig
    return v2:GetAttribute(HellEventConfig.PlayerAttribute) == true
end

function v1.CanEquip(v3, v4) -- line 39 | captures: BatToolQuery, PickaxeConfig, v1
    if v1.InHell(v3) then
        if v1.Gathering() and v4 and v4.Name == PickaxeConfig.ToolName then
            return true
        end
        return BatToolQuery.IsBatWeapon(v4)
    end
    return true
end

return v1
