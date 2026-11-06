-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TrailsConfig = require(ReplicatedStorage.Shared.TrailsConfig)
local TutorialConfig = require(ReplicatedStorage.Shared.TutorialConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer

function v1.IsActive() -- line 31 | captures: TutorialConfig, LocalPlayer
    return LocalPlayer:GetAttribute(TutorialConfig.ActiveAttribute) == true
end

local function stage() -- line 35 | captures: TutorialConfig, LocalPlayer
    return LocalPlayer:GetAttribute(TutorialConfig.StageAttribute)
end

function v1.PickaxeTier() -- line 39 | captures: TutorialConfig, v1, LocalPlayer
    if v1.IsActive() then
        if LocalPlayer:GetAttribute(TutorialConfig.StageAttribute) == "BuyPickaxe" then
            return true, TutorialConfig.ShopPickaxeTier
        end
        return true, nil
    end
    return false, nil
end

function v1.TrailId() -- line 49 | captures: TrailsConfig, TutorialConfig, v1, LocalPlayer
    if v1.IsActive() then
        if LocalPlayer:GetAttribute(TutorialConfig.StageAttribute) == "BuyTrail" then
            local Cash = LocalPlayer:GetAttribute("Cash")
            local BestAffordable = TrailsConfig.BestAffordable
            if typeof(Cash) ~= "number" then
                Cash = 0
            end
            local v2 = BestAffordable(Cash)
            return true, v2 and v2.Id
        end
        return true, nil
    end
    return false, nil
end

return v1
