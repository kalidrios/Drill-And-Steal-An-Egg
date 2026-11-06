-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local v1 = {
    RemoteName = "BackpackSellRemote",
    PetIncomeSeconds = 60,
    EggIncomeSeconds = 60,
    MaxPerRequest = 200,
    SellText = "Sell",
    ConfirmText = "Confirm",
    SelectedScale = 0.85,
    AnimalToolTag = "AnimalTool",
    SelectedTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    EggToolTag = MergeConfig.EggToolTag
}

local function floorCash(v2) -- line 45
    if v2 == v2 and v2 ~= (1/0) and not (v2 < 0) then
        return (math.floor(v2))
    end
    return 0
end

function v1.PetValue(v3, v4, v5, v6, v7) -- line 52 | captures: EggRewards, v1
    local v8 = EggRewards.PlacedCashPerSecond(v3, v4, v5, v6, v7) * v1.PetIncomeSeconds
    if v8 == v8 and v8 ~= (1/0) and not (v8 < 0) then
        return (math.floor(v8))
    end
    return 0
end

function v1.EggValue(v9, v10) -- line 56 | captures: EggRewards, v1
    local v11 = EggRewards.PlacedCashPerSecond(v9, nil, nil, v10, nil) * v1.EggIncomeSeconds
    if v11 == v11 and v11 ~= (1/0) and not (v11 < 0) then
        return (math.floor(v11))
    end
    return 0
end

function v1.IsSellable(v12) -- line 62 | captures: CollectionService, v1
    return CollectionService:HasTag(v12, v1.AnimalToolTag) or CollectionService:HasTag(v12, v1.EggToolTag)
end

function v1.ToolValue(v13) -- line 69 | captures: CollectionService, v1
    local AnimalName = v13:GetAttribute("AnimalName")
    if typeof(AnimalName) == "string" then
        local WeightKg = v13:GetAttribute("WeightKg")
        if CollectionService:HasTag(v13, v1.EggToolTag) then
            return v1.EggValue(AnimalName, WeightKg)
        end
        if CollectionService:HasTag(v13, v1.AnimalToolTag) then
            return v1.PetValue(AnimalName, v13:GetAttribute("SizeMult"), v13:GetAttribute("Mutation"), WeightKg, (v13:GetAttribute("Variant")))
        end
    end
    return 0
end

return v1
