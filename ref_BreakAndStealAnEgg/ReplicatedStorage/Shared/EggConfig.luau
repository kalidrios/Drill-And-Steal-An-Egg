-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    SpawningEnabled = true,
    MaxHealth = 5,
    Damage = 1,
    SizeHealthExponent = 1,
    HitRange = 8,
    HitRangeLagSlack = 0.3,
    HitCooldownFactor = 0.92,
    HitBurst = 2,
    HitLagBurstFactor = 2.5,
    HitBurstMax = 16,
    UnequipHitGrace = 0.75,
    Eggs = {
        ["Basic Egg"] = { Luck = 1 },
        ["Forest Egg"] = {
            Luck = 1,
            Health = 5
        },
        ["Rock Egg"] = {
            Luck = 1.1,
            Health = 10
        },
        ["Swamp Egg"] = {
            Luck = 1.25,
            Health = 15
        },
        ["Cactus Egg"] = {
            Luck = 1,
            Health = 75
        },
        ["Bones Egg"] = {
            Luck = 1.1,
            Health = 100
        },
        ["Scorpion Egg"] = {
            Luck = 1.25,
            Health = 150
        },
        ["Frozen Egg"] = {
            Luck = 1,
            Health = 1000
        },
        ["Frosty Egg"] = {
            Luck = 1.1,
            Health = 2000
        },
        ["Yeti Egg"] = {
            Luck = 1.25,
            Health = 3000
        },
        ["Rainbow Egg"] = {
            Luck = 1,
            Health = 20000
        },
        ["Easter Bunny Egg"] = {
            Luck = 1.1,
            Health = 50000
        },
        ["Candy Egg"] = {
            Luck = 1.25,
            Health = 100000
        },
        ["Gooey Egg"] = {
            Luck = 1,
            Health = 400000
        },
        ["Tree Egg"] = {
            Luck = 1.1,
            Health = 1000000
        },
        ["Lake Egg"] = {
            Luck = 1.25,
            Health = 2000000
        },
        ["Sea Stones Egg"] = {
            Luck = 1,
            Health = 10000000
        },
        ["Sea Egg"] = {
            Luck = 1.1,
            Health = 25000000
        },
        ["Water Egg"] = {
            Luck = 1.25,
            Health = 50000000
        },
        ["Angel Egg"] = {
            Luck = 1,
            Health = 300000000
        },
        ["Fallen Angel Egg"] = {
            Luck = 1.1,
            Health = 750000000
        },
        ["Volcanic Egg"] = {
            Luck = 1.25,
            Health = 1500000000
        },
        ["Bamboo Egg"] = {
            Luck = 1,
            Health = 3000000000
        },
        ["Blossom Egg"] = {
            Luck = 1.1,
            Health = 7500000000
        },
        ["Fortune Egg"] = {
            Luck = 1.25,
            Health = 15000000000
        },
        ["Starry Egg"] = {
            Luck = 1,
            Health = 30000000000
        },
        ["Sun Egg"] = {
            Luck = 1.1,
            Health = 75000000000
        },
        ["BlackHole Egg"] = {
            Luck = 1.25,
            Health = 150000000000
        },
        ["Plasma Egg"] = {
            Luck = 1,
            Health = 150000000000
        },
        ["Nebula Egg"] = {
            Luck = 1.1,
            Health = 375000000000
        },
        ["Supernova Egg"] = {
            Luck = 1.25,
            Health = 750000000000
        }
    },
    ZoneHealthMult = {
        1,
        15,
        200,
        4000,
        80000,
        2000000,
        60000000,
        600000000,
        6000000000,
        30000000000
    },
    Spawn = {
        TemplatesFolderName = "Eggs",
        Template = "Basic Egg",
        BasicOnly = false,
        ReplicatedEggsFolder = "Eggs",
        NormalRootName = "NormalEggs",
        NormalFolderName = "Normal",
        TierWeights = { 3, 2, 1 },
        TierSizeMult = { 1, 1.1, 1.25 },
        EggBaseHeight = 3,
        EggHeightPerZone = 0.3,
        ZoneEggsFolderName = "Eggs",
        ZoneFloorFolderName = "Parts",
        MaxPerZone = 14,
        MaxPerZoneStep = 2,
        RespawnDelay = 15,
        BrokenCleanupDelay = 6,
        BrokenRespawnDelay = { 10, 15 },
        PityCheckInterval = 5,
        PityInterval = { 10, 15 },
        PityMax = 8,
        WidthSpreadFraction = 0.92,
        LengthBands = 3,
        BandBalanceAttempts = 10,
        EdgeMargin = 6,
        Gap = 5,
        PlacementAttempts = 20,
        HealthDepth = {
            Chance = 0.8,
            Band = 0.15,
            BandAttempts = 14,
            Zones = { Zone1 = true }
        },
        NestsFolderName = "EggNests",
        NestTemplate = "Zone_%d_Nest",
        NestWidthScale = 1.6,
        NestSinkFraction = 0.45,
        NestBuryFraction = 0.35,
        Variants = {}
    }
}
local v2 = {
    Spawn = {
        MaxMult = 4,
        MinMult = 0.7,
        BigChance = 0.65,
        MaxOneIn = 10000,
        MinOneIn = 60,
        TailExponent = 1.3,
        LuckBend = 0.35,
        Decimals = 2
    },
    AnimalWeightLuck = {
        Exponent = 0.75,
        MaxLuck = 2
    }
}
local v3 = {}

v3[1] = {
    SpawnMax = 2.3,
    HatchMax = 4
}
v3[2] = {
    SpawnMax = 2.6,
    HatchMax = 4.6
}
v3[3] = {
    SpawnMax = 3,
    HatchMax = 5.4
}
v3[4] = {
    SpawnMax = 3.4,
    HatchMax = 6.2
}
v3[5] = {
    SpawnMax = 3.6,
    HatchMax = 6.6
}
v3[6] = {
    SpawnMax = 3.7,
    HatchMax = 6.9
}
v3[7] = {
    SpawnMax = 3.9,
    HatchMax = 7.3
}
v2.ZoneCaps = v3
v2.Hatch = {
    MaxMult = 7.5,
    MinMult = 1,
    BigChance = 0.9,
    MaxOneIn = 300000,
    MinOneIn = 100,
    TailExponent = 1,
    Decimals = 2,
    LuckBend = 0.35
}
v2.Brackets = {
    {
        Label = "TITANIC",
        Chance = 0.02,
        MinHatchMult = 3
    },
    {
        Label = "HUGE",
        Chance = 0.1
    },
    {
        Label = "BIG",
        Chance = 0.33
    }
}

local v4 = {}

v4[1] = { TITANIC = 0.2 }
v2.ZoneBracketMults = v4
v1.Size = v2
v1.Idle = {
    MinDelay = 2.5,
    MaxDelay = 6,
    HopChance = 0.35,
    WiggleTime = 0.7,
    WiggleAngle = 6,
    WiggleRate = 5,
    HopHeightFrac = 0.12,
    HopTime = 0.35
}
v1.Hit = {
    SoundName = "Impact",
    SoundFolder = "rransCustomSFX",
    SoundLocalOnly = false,
    SoundRange = 100,
    VFXName = "EggHit",
    FlashTime = 0.18,
    ShrinkScale = 0.85,
    ShrinkTime = 0.07,
    RecoverTime = 0.45,
    ShakeAngle = 18
}
v1.Debris = {
    MinCount = 5,
    MaxCount = 8,
    Size = 1,
    SpawnScale = 0.2,
    GrowTime = 0.3,
    MaterialVariant = "Studs",
    MinLifetime = 0.4,
    SettleTimeout = 2.5,
    PopScale = 1.35,
    PopTime = 0.12,
    ShrinkTime = 0.14,
    UpSpeed = { 26, 36 },
    SideSpeed = { 8, 12 },
    RestTime = { 0.35, 0.65 }
}
v1.NestPop = {
    PopScale = 1.35,
    PopTime = 0.14,
    ShrinkTime = 0.18
}
v1.SpawnRise = {
    Duration = 0.7,
    MaxAge = 3
}
v1.DespawnSink = {
    Duration = 0.4,
    CleanupDelay = 1
}
v1.AmbientCull = {
    Distance = 200,
    Hysteresis = 20,
    CheckInterval = 0.25
}
v1.HideCull = {
    Distance = 600,
    Hysteresis = 25,
    CheckInterval = 0.25
}
v1.ViewCull = {
    HideEggShells = false,
    PauseEggVFX = false,
    HidePlacedAnimals = false,
    MarginDegrees = 15,
    CloseRadius = 60,
    HideDelay = 0.75,
    RadiusScale = 1.5,
    DebugPreview = false,
    DebugShrinkDegrees = 12
}
v1.AdaptiveCull = {
    Enabled = true,
    SmoothTime = 1.5,
    MaxFrameTime = 0.25,
    WarmupSeconds = 10,
    LowFps = 40,
    DowngradeHold = 3,
    HighFps = 54,
    RecoverHold = 20,
    RecoverHoldMax = 120,
    RelapseWindow = 20,
    Debug = false,
    Tiers = {
        {
            DistanceScale = 1,
            HideDelayScale = 1
        },
        {
            DistanceScale = 0.8,
            HideDelayScale = 0.8
        },
        {
            DistanceScale = 0.62,
            HideDelayScale = 0.6
        },
        {
            DistanceScale = 0.45,
            HideDelayScale = 0.4
        }
    }
}
v1.VFXRefShellWidth = 6.1
v1.VFXScaleClamp = { 0.35, 3 }

function v1.VFXScaleForWidth(v5) -- line 695 | captures: v1
    local VFXScaleClamp = v1.VFXScaleClamp
    local v6 = v5 / v1.VFXRefShellWidth
    local v7 = VFXScaleClamp[1]
    local v8 = VFXScaleClamp[2]
    return (math.clamp(v6, v7, v8))
end

v1.HatchAudio = { MaxConcurrent = 3 }
return v1
