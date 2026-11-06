-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    Enabled = true,
    GatherAttribute = "HellGathering",
    EssenceAttribute = "HellEssence",
    GoalAttribute = "HellEssenceGoal",
    EggTag = "HellEssenceEgg",
    ValueAttribute = "EssenceValue",
    GoalBase = 1000,
    GoalPerPlayer = 0
}

function v1.Goal(v2) -- line 36 | captures: v1
    return v1.GoalBase + v1.GoalPerPlayer * math.max(v2, 1)
end

v1.MaxSeconds = 0
v1.SummonDelay = 1
v1.HitDamage = 1
v1.ZoneIndex = 7
v1.SpawnPart = "EggsSpawn"
v1.FloorPath = { "Build", "Floor" }
v1.FolderName = "EssenceEggs"
v1.Alive = {
    Base = 10,
    PerPlayer = 3,
    Max = 30
}
v1.RespawnDelay = {
    Min = 1,
    Max = 3
}
v1.MinGap = 22
v1.PylonClearance = 30
v1.BossClearance = 45
v1.Sizes = {
    {
        Name = "Small",
        Label = "Essence Egg",
        Weight = 70,
        Height = 7,
        Hits = 1,
        Essence = 14
    },
    {
        Name = "Big",
        Label = "BIG Essence Egg",
        Weight = 30,
        Height = 13,
        Hits = 1,
        Essence = 42
    }
}
v1.ShowInfo = false
v1.Bar = {
    IconName = "Icon",
    TitleName = "Title",
    Icon = "rbxassetid://92952881904582",
    Title = "Essence",
    ShowTitle = false,
    Format = "%s/%s Essence",
    FillTime = 0.35,
    BossIcon = "rbxassetid://107238529015994"
}
v1.Drain = {
    Enabled = true,
    GrowMult = 2.5,
    ZapSoundEvery = 0.35,
    ZapVolume = 0.3,
    BreakSoundEvery = 0.12,
    PayoutStep = 1,
    SilentGrow = true,
    StrikeEvery = {
        Min = 0.08,
        Max = 0.22
    }
}
v1.Burst = {
    Scale = 1.2,
    Color = Color3.fromRGB(255, 170, 60)
}
v1.Zap = {
    Width = 0.8,
    GlowWidth = 3,
    OuterWidth = 8,
    Depth = 4,
    Jag = 0.14,
    Branches = 1,
    Leader = 0.06,
    Life = 0.45
}
v1.Sfx = {
    Zap = {
        Folder = "BossSfx",
        Name = "ElectricArc",
        Range = 500,
        MinRange = 60,
        Volume = 0.45
    }
}
return v1
