-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BatConfig = require(ReplicatedStorage.Shared.BatConfig)
local v1 = {}

function v1.IsBatWeapon(v2) -- line 36 | captures: CollectionService, BatConfig
    local Tool
    if v2 == nil then
        Tool = false
    else
        Tool = v2:IsA("Tool")
        if Tool then
            if v2.Name == BatConfig.ToolName then
                Tool = not CollectionService:HasTag(v2, "AnimalTool")
            else
                Tool = false
            end
        end
    end
    return Tool
end

function v1.FindIn(v3) -- line 46 | captures: v1
    if v3 then
        for v4, v5 in v3:GetChildren() do
            if v1.IsBatWeapon(v5) then
                return v5
            end
        end
    end
    return nil
end

return v1
