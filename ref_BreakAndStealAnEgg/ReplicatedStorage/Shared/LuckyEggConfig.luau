-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    Tag = "LuckyEgg",
    PetLuck = {
        Min = 1.1,
        Max = 1.2
    },
    BossPetLuck = 2,
    SizeLuck = {
        Min = 1.2,
        Max = 1.35
    },
    HealthBoost = {
        Min = 1.2,
        Max = 1.35
    },
    MutationLuck = {
        Min = 1.5,
        Max = 2
    },
    DefaultPerZone = 2,
    MaxPerZone = 8,
    DropSpread = 6,
    DropHeight = 110,
    DropTime = 7,
    EdgeMargin = 0.15,
    LandClearance = 2,
    Despawn = {
        Enabled = true,
        KeepRank = 5,
        MinAge = 150,
        LonelyTime = 75,
        NearRadius = 90,
        KeepPerZone = 3,
        ZoneGap = 30,
        CheckEvery = 2
    },
    Badge = "Lucky",
    AuraName = "EggSuperLuckyVFX",
    AuraReferenceHeight = 4,
    AuraViewDistance = 600,
    AuraFrontOffset = 0.25,
    ParachuteName = "LuckyEggParachute",
    Flight = {
        DefaultElevation = 50,
        DropIn = 0.2,
        MuzzleSnap = 80,
        SpinPerSecond = 0.6,
        TrailWidth = 0.8,
        CoreWidth = 0.3,
        TrailLifetime = 0.55,
        SmokeName = "SmokeVFX",
        SmokeRate = 1,
        LandShake = 2.5,
        TrailColors = {
            Color3.fromRGB(255, 235, 120),
            Color3.fromRGB(255, 150, 40)
        }
    },
    LandPuff = {
        Name = "SmokeVFX",
        Scale = 0.12
    },
    AnnounceColor = "#72FF72"
}
