-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    DefaultLevel = 1,
    AnimRateBase = 1,
    AnimRateStep = 0.5,
    AssetsFolderName = "Treadmills",
    Levels = {
        {
            Asset = "1: Basic Treadmill",
            Multiplier = 1,
            UpgradeCost = 850000
        },
        {
            Asset = "2: Wooden Treadmill",
            Multiplier = 2,
            UpgradeCost = 10000000
        },
        {
            Asset = "3: Golden Treadmill",
            Multiplier = 4,
            UpgradeCost = 500000000
        },
        {
            Asset = "4:Spikey Treadmill",
            Multiplier = 8,
            UpgradeCost = 9500000000
        },
        {
            Asset = "5: Diamond Treadmill",
            Multiplier = 16,
            UpgradeCost = 120000000000
        },
        {
            Asset = "6: Futuristic Treadmill",
            Multiplier = 32,
            UpgradeCost = 1000000000000
        },
        {
            Asset = "7: Speedy Treadmill",
            Multiplier = 64,
            UpgradeCost = 15000000000000
        },
        {
            Asset = "8: Volcanic Treadmill",
            Multiplier = 128,
            UpgradeCost = 250000000000000
        },
        {
            Asset = "9: Ghost Treadmill",
            Multiplier = 256
        }
    },
    SkipProductIds = {
        3714922595,
        3714922630,
        3714922664,
        3714922694,
        3714922716,
        3714922753,
        3714922777,
        3714922800,
        3714922904
    }
}

v1.MaxLevel = #v1.Levels

function v1.ClampLevel(v2) -- line 86 | captures: v1
    if not (typeof(v2) == "number" and v2 == v2) then
        return v1.DefaultLevel
    end
    local v3 = math.floor(v2)
    local MaxLevel = v1.MaxLevel
    return (math.clamp(v3, 1, MaxLevel))
end

function v1.AnimationRateFor(v4) -- line 94 | captures: v1
    return v1.AnimRateBase + (v1.ClampLevel(v4) - 1) * v1.AnimRateStep
end

function v1.MultiplierFor(v5) -- line 100 | captures: v1
    return v1.Levels[v1.ClampLevel(v5)].Multiplier
end

function v1.UpgradeCost(v6) -- line 105 | captures: v1
    return v1.Levels[v1.ClampLevel(v6)].UpgradeCost
end

function v1.SkipProductFor(v7) -- line 111 | captures: v1
    local v8 = v1.ClampLevel(v7)
    if v1.MaxLevel <= v8 then
        return nil
    end
    return v1.SkipProductIds[v8]
end

function v1.AssetNameFor(v9) -- line 120 | captures: v1
    return v1.Levels[v1.ClampLevel(v9)].Asset
end

function v1.DisplayNameFor(v10) -- line 126 | captures: v1
    local v11 = v1.AssetNameFor(v10)
    return (string.gsub(v11, "^%d+:%s*", ""))
end

return v1
