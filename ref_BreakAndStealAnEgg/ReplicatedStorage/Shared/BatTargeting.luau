-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BatConfig = require(ReplicatedStorage.Shared.BatConfig)
local BatToolQuery = require(ReplicatedStorage.Shared.BatToolQuery)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local SafeZoneQuery = require(ReplicatedStorage.Shared.SafeZoneQuery)
local TutorialConfig = require(ReplicatedStorage.Shared.TutorialConfig)
local v1 = {}

function v1.BaseRange(v2) -- line 28 | captures: BatConfig, BatToolQuery
    local v3 = v2 and v2.Character
    local v4 = v3 and BatToolQuery.FindIn(v3)
    return BatConfig.GetToolTier(v4).Range
end

function v1.MaxRange(v5) -- line 37 | captures: BatConfig, v1
    local Targeting = BatConfig.Targeting
    local v6 = v5 and v5:GetAttribute(Targeting.RangeMultiplierAttribute)
    if typeof(v6) ~= "number" or v6 <= 0 then
        v6 = 1
    end
    return v1.BaseRange(v5) * v6 + Targeting.HitTolerance
end

function v1.IsEligible(v7, v8, v9) -- line 48 | captures: HellEventConfig, SafeZoneQuery, TutorialConfig
    local Character = v7.Character
    if Character then
        local v10 = Character:FindFirstChild("HumanoidRootPart")
        local v11 = Character:FindFirstChildOfClass("Humanoid")
        if v10 and v10:IsA("BasePart") and v11 and not (v11.Health <= 0) then
            if not (Character:GetAttribute("Ragdolled") or Character:GetAttribute("BatImmune")) then
                local v12 = v7:GetAttribute(TutorialConfig.StageAttribute)
                if v12 == nil or v12 == TutorialConfig.DoneStage then
                    if SafeZoneQuery.IsBankable(v7.UserId, v10.Position) then
                        return false, (1/0)
                    end
                    if v7:GetAttribute(HellEventConfig.PlayerAttribute) == true then
                        return false, (1/0)
                    end
                    local Magnitude = (v10.Position - v8).Magnitude
                    return Magnitude <= v9, Magnitude
                end
            end
            return false, (1/0)
        end
    end
    return false, (1/0)
end

function v1.SelectClosestTarget(v13, v14, v15) -- line 85 | captures: Players, v1
    local v16
    local v17 = (1/0)
    for v18, v19 in Players:GetPlayers() do
        if v19 ~= v13 then
            local v20, v21 = v1.IsEligible(v19, v14, v15)
            if v20 and v21 < v17 then
                v16 = v19
                v17 = v21
            end
        end
    end
    return v16
end

return v1
