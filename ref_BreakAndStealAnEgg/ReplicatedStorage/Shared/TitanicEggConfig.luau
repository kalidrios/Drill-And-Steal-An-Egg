-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    IntervalSeconds = 1800,
    LifetimeSeconds = 600,
    FirstZone = 2,
    Bracket = "TITANIC",
    BracketOneIn = 50,
    HealthMult = 10,
    LuckMult = 30,
    MaxLuckBias = 40,
    ClearPadding = 8,
    SoundRangeMult = 5,
    AdminSpawnFeedback = true,
    Tag = "TitanicEgg",
    GuardAvoidMargin = 6,
    MaxLive = 10,
    ShellHeight = { 30, 56 },
    SpawnMult = { 7, 8 },
    HatchMult = { 1.4, 1.6 },
    ZoneSizes = {
        [2] = {
            ShellHeight = { 18, 24 },
            SpawnMult = { 3.2, 3.8 },
            HatchMult = { 1.2, 1.3 }
        },
        [3] = {
            ShellHeight = { 22, 30 },
            SpawnMult = { 4, 4.8 },
            HatchMult = { 1.25, 1.35 }
        },
        [4] = {
            ShellHeight = { 26, 38 },
            SpawnMult = { 5, 6 },
            HatchMult = { 1.3, 1.45 }
        },
        [5] = {
            ShellHeight = { 30, 46 },
            SpawnMult = { 6, 7 },
            HatchMult = { 1.35, 1.5 }
        }
    },
    ExcludedEggs = { ["Frozen Egg"] = true },
    Variants = {},
    SpawnSfx = {},
    Board = {
        ModelName = "Special Egg Spawn",
        GuiName = "EggSpawnGui"
    },
    Attributes = {
        NextAt = "TitanicNextAt",
        EggName = "TitanicEggName",
        ZoneIndex = "TitanicZoneIndex",
        EndsAt = "TitanicEndsAt",
        SpawnId = "TitanicSpawnId",
        SpawnByAdmin = "TitanicSpawnByAdmin"
    },
    Placement = {
        RingStep = 12,
        RingSlots = 10,
        MaxRings = 12,
        FootprintSlack = 1.42
    },
    AdminSpawn = {
        Topic = "TitanicEggAdminSpawn",
        Announcement = "spawned a <font color=\"#FFD23C\">TITANIC EGG</font> in the %s!",
        MaxMessageAge = 60
    }
}
