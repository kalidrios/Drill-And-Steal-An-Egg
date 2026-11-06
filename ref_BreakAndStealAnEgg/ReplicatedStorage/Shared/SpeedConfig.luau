-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    DefaultSpeedPower = 10,
    SpeedPowerPerStep = 1,
    GainInterval = 1,
    BaseWalkSpeed = 18,
    SoftCapWalkSpeed = 100,
    MaxWalkSpeed = 200,
    MaxSpeedPower = 1000000000,
    OverdriveMaxSpeedPower = 10000000000000000,
    WalkSpeedCurveExponent = 1.59,
    GroundGripResponsiveness = 30,
    GroundGripMinWalkSpeed = 20,
    MultiplierAttribute = "SpeedMultiplier",
    InUseAttribute = "TreadmillInUse",
    DefaultTreadmillMultiplier = 2,
    PopupIcon = "rbxassetid://79732991925872",
    OverdriveSteps = {
        {
            Power = 1000000000000,
            WalkSpeed = 120
        },
        {
            Power = 100000000000000,
            WalkSpeed = 135
        },
        {
            Power = 10000000000000000,
            WalkSpeed = 200
        }
    },
    Tiers = {
        {
            Name = "Treadmill",
            Price = 0,
            SpeedMultiplier = 1,
            Rarity = "Common"
        },
        {
            Name = "Sci-Fi Treadmill",
            Price = 850000,
            SpeedMultiplier = 2,
            Rarity = "Uncommon"
        },
        {
            Name = "Flame Treadmill",
            Price = 10000000,
            SpeedMultiplier = 4,
            Rarity = "Rare"
        },
        {
            Name = "Celebrity Treadmill",
            Price = 500000000,
            SpeedMultiplier = 8,
            Rarity = "Epic"
        },
        {
            Name = "Golden Treadmill",
            Price = 9500000000,
            SpeedMultiplier = 16,
            Rarity = "Legendary"
        },
        {
            Name = "The Freeze Treadmill",
            Price = 120000000000,
            SpeedMultiplier = 32,
            Rarity = "Mythic"
        }
    }
}

function v1.SpeedPowerToProgression(v2) -- line 100 | captures: v1
    local v3 = v2 or v1.DefaultSpeedPower
    local DefaultSpeedPower = v1.DefaultSpeedPower
    local v4 = math.max(v3, DefaultSpeedPower) / v1.DefaultSpeedPower
    local v5 = math.log10(v4)
    local v6 = v1.MaxSpeedPower / v1.DefaultSpeedPower
    local v7 = v5 / math.log10(v6)
    return math.clamp(v7, 0, 1) * 290 + 10
end

function v1.SpeedPowerToWalkSpeed(v8) -- line 114 | captures: v1
    local v9 = v8 or v1.DefaultSpeedPower
    local DefaultSpeedPower = v1.DefaultSpeedPower
    local v10 = math.max(v9, DefaultSpeedPower)
    if v1.MaxSpeedPower < v10 then
        local v11, v12 = v1.MaxSpeedPower, v1.SoftCapWalkSpeed
        for v13, v14 in v1.OverdriveSteps do
            if v10 <= v14.Power then
                local v15 = v10 / v11
                local v16 = math.log10(v15)
                local v17 = v14.Power / v11
                local v18 = v16 / math.log10(v17)
                return v12 + math.clamp(v18, 0, 1) * (v14.WalkSpeed - v12)
            end
            v11, v12 = v14.Power, v14.WalkSpeed
        end
        return v1.MaxWalkSpeed
    end
    local v19 = (v1.SpeedPowerToProgression(v8) - 10) / 290
    local v20 = math.clamp(v19, 0, 1) ^ v1.WalkSpeedCurveExponent
    return v1.BaseWalkSpeed + v20 * (v1.SoftCapWalkSpeed - v1.BaseWalkSpeed)
end

local function AwardInterval(v21) -- line 137
    local v22 = (v21 - 10) / 90
    return 0.25 - math.clamp(v22, 0, 1) * 0.15
end

v1.AwardInterval = AwardInterval

function v1.SpeedPowerPerStepFor(v23) -- line 143 | captures: v1
    return v1.SpeedPowerPerStep * v23
end

function v1.SpeedPowerPerSecond(v24, v25) -- line 150 | captures: v1
    local v26 = v1.AwardInterval(v1.SpeedPowerToProgression(v24))
    return v1.SpeedPowerPerStepFor(v25) / v26
end

local function PopupColor(v27) -- line 156
    if v27 >= 100 then
        return Color3.fromRGB(255, 0, 0)
    end
    if v27 >= 25 then
        return Color3.fromRGB(255, 67, 199)
    end
    if v27 >= 9 then
        return Color3.fromRGB(0, 255, 255)
    end
    if v27 > 1 then
        return Color3.fromRGB(255, 238, 0)
    end
    return Color3.fromRGB(178, 233, 255)
end

v1.PopupColor = PopupColor
return v1
