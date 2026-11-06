-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local EggRewards = require(script.Parent.EggRewards)
local EggGrowthClock = require(script.Parent.EggGrowthClock)
local v1 = {
    SlotCount = 3,
    CooldownSeconds = 0,
    CooldownAttribute = "MergeCooldownEndsAt",
    RemoteName = "MergeMachineRemote",
    EggToolTag = "MergeEggTool",
    PlacedEggTag = "MergeEggPlaced",
    OwnerPromptTag = "MergeEggPrompt",
    EggTemplateFolderName = "Eggs",
    EggTemplateName = "MergeMachineEgg",
    LegacyEggTemplateName = "Egg Test",
    BaseGrowthSeconds = 10,
    GrowthKgPivot = 150,
    GrowthKgExponent = 0.88,
    MaxGrowthSeconds = 604800,
    EggGrowthRatio = 3,
    EggFootprintRatio = 0.4,
    EggPlaceSpacingFrac = 1,
    SfxFolder = "MergeSFX",
    RevealOwnVolumeScale = 0.75,
    SfxRollOffMin = 15,
    SfxRollOffMax = 150,
    VfxFolderName = "Egg Open",
    HatchGrantDelaySeconds = 6.2,
    GrowthRarityMultipliers = {
        Common = 1,
        Uncommon = 1.15,
        Rare = 1.3,
        Epic = 1.5,
        Legendary = 1.75,
        Mythic = 2,
        Divine = 2.3,
        Cosmic = 2.6,
        Secret = 3,
        Celestial = 3.5,
        Inferno = 4,
        Void = 4.5,
        Omega = 5
    },
    Sfx = {
        EggLand = {
            Folder = "rransCustomSFX",
            Name = "Egg Placing"
        },
        Merged = {
            Folder = "rransCustomSFX",
            Name = "Potion"
        },
        MergedPower = {
            Folder = "rransCustomSFX",
            Name = "Power Up"
        },
        Shake = {
            Folder = "SFX",
            Name = "Egg Crack_2"
        },
        EggCrack = {
            Folder = "SFX",
            Name = "Egg Crack"
        },
        EggOpen = {
            Folder = "SFX",
            Name = "Egg Open"
        },
        Confetti = {
            Folder = "rransCustomSFX",
            Name = "Confetti"
        },
        Reveal = {
            Folder = "rransCustomSFX",
            Name = "Reveal"
        }
    },
    SkipProducts = {
        {
            ProductId = 3714392668,
            Seconds = 900
        },
        {
            ProductId = 3714392730,
            Seconds = 3600
        },
        {
            ProductId = 3714392757,
            Seconds = 14400
        },
        {
            ProductId = 3714392785,
            Seconds = 86400
        },
        {
            ProductId = 3714670663,
            Seconds = 172800
        },
        {
            ProductId = 3714670696,
            Seconds = 259200
        },
        {
            ProductId = 3714670745,
            Seconds = 432000,
            Offered = false
        },
        {
            ProductId = 3714670776,
            Seconds = 604800
        }
    },
    GrowAllProducts = {
        {
            ProductId = 3714939509,
            MaxSeconds = 3600
        },
        {
            ProductId = 3714939764,
            MaxSeconds = 21600
        },
        {
            ProductId = 3714939804,
            MaxSeconds = 86400
        },
        {
            ProductId = 3714939855,
            MaxSeconds = 259200
        },
        { ProductId = 3714939888 }
    }
}

function v1.GrowAllProductFor(v2) -- line 236 | captures: v1
    local v3
    for v4, v5 in v1.GrowAllProducts do
        if v5.ProductId ~= nil then
            if v5.MaxSeconds == nil then
                return v5
            end
            if v2 <= v5.MaxSeconds then
                return v5
            end
            v3 = v5
        end
    end
    return v3
end

function v1.SkipProductFor(v6) -- line 251 | captures: v1
    local v7
    for v8, v9 in v1.SkipProducts do
        if v9.ProductId ~= nil and v9.Offered ~= false then
            if v6 <= v9.Seconds then
                return v9
            end
            v7 = v9
        end
    end
    return v7
end

v1.VariantTiers = { "Diamond", "Gold" }

function v1.VariantOdds(v10) -- line 286 | captures: v1
    local v11 = {}
    local v12 = 1
    local v13 = 0
    for v14, v15 in v1.VariantTiers do
        local SlotCount = v1.SlotCount
        for v16 = 1, SlotCount do
            if v10[v16] == v15 then
                v13 += 1
            end
        end
        local v17 = v13 / v1.SlotCount
        local v18 = v12 * math.min(v17, 1)
        if v18 > 0 then
            v11[v15] = v18
            v12 -= v18
        end
    end
    return v11, (math.max(v12, 0))
end

function v1.RollVariant(v19, v20) -- line 307 | captures: v1
    local v21 = v1.VariantOdds(v19)
    local v22 = (v20 or Random.new()):NextNumber()
    for v23, v24 in v1.VariantTiers do
        local v25 = v21[v24]
        if v25 then
            if v22 < v25 then
                return v24
            end
            v22 -= v25
        end
    end
    return nil
end

function v1.GrowthRarityMultiplier(v26) -- line 323 | captures: v1
    return v26 and v1.GrowthRarityMultipliers[v26] or 1
end

function v1.GrowthSeconds(v27, v28) -- line 329 | captures: v1
    local v29 = math.max(v27, 0)
    local v30 = if v1.GrowthKgPivot < v29 then (v29 / v1.GrowthKgPivot) ^ v1.GrowthKgExponent else 1
    local v31 = v30 * v1.GrowthRarityMultiplier(v28)
    local v32 = v1.BaseGrowthSeconds * v31
    local MaxGrowthSeconds = v1.MaxGrowthSeconds
    local v33 = math.min(v32, MaxGrowthSeconds) + 0.5
    return (math.floor(v33))
end

function v1.MergedSizeMult(v34, v35) -- line 346 | captures: EggRewards
    return EggRewards.SizeForKg(EggRewards.AnimalBaseKg(v34), v35)
end

function v1.MergedMaxScale() -- line 352 | captures: EggRewards
    return EggRewards.MaxMergedSizeMult
end

function v1.MergedScale(v36, v37) -- line 357 | captures: EggRewards, v1
    return EggRewards.ScaleForWeight(v36, v37, v1.MergedSizeMult(v36, v37), false, v1.MergedMaxScale())
end

function v1.EggFinalHeight(v38, v39) -- line 370 | captures: EggRewards, v1
    return EggRewards.TargetHeight * v1.MergedScale(v38, v39)
end

function v1.EggVfxFolder() -- line 375 | captures: v1
    local Assets = game:GetService("ReplicatedStorage"):FindFirstChild("Assets")
    return Assets and Assets:FindFirstChild(v1.VfxFolderName)
end

function v1.RemainingSeconds(v40) -- line 387 | captures: EggGrowthClock
    local v41 = v40:GetAttribute("GrowthDuration") or 1
    local v42 = EggGrowthClock.RemainingOf(v40)
    local v43 = math.max(v41, 0)
    return math.clamp(v42, 0, v43), v41
end

local function FormatDuration(v44) -- line 394
    local v45 = math.ceil(v44)
    local v46 = math.max(v45, 0)
    local v47 = v46 // 86400
    local v48 = v46 % 86400 // 3600
    local v49 = v46 % 3600 // 60
    local v50 = v46 % 60
    if v47 > 0 then
        return (("%*D %*H %*M"):format(v47, v48, v49))
    end
    if v48 > 0 then
        return (("%*H %*M"):format(v48, v49))
    end
    if v49 > 0 then
        return (("%*M %*S"):format(v49, (string.format("%02d", v50))))
    end
    return (("%*S"):format(v50))
end

v1.FormatDuration = FormatDuration
return v1
