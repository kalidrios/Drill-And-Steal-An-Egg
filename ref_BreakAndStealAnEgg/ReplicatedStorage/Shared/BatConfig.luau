-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    ToolName = "Bat",
    TemplatesFolderName = "Tools",
    SwingAnimationName = "Bat Swing",
    TutorialEndDelay = 20,
    ClientCooldown = 0.6,
    ServerCooldown = 0.7,
    HellClientCooldown = 0.5,
    HellServerCooldown = 0.45,
    HellCooldownJitter = 0.25,
    SwingSpeed = 1.75,
    SwingTrimEnd = 2,
    PostRagdollImmunity = 1,
    HitRemoteName = "BatHitRequest",
    DefaultTier = 1,
    TierAttribute = "BatTier",
    NameAttribute = "BatName",
    Targeting = {
        HitTolerance = 2,
        MaximumTargetViewAge = 0.35,
        TargetViewSamplePadding = 0.05,
        RangeMultiplierAttribute = "BatHitboxMultiplier",
        MinRangeMultiplier = 0.1,
        MaxRangeMultiplier = 20
    },
    Highlight = {
        FillTransparency = 0.5,
        OutlineTransparency = 0.15,
        FadeTime = 0.18,
        FillColor = Color3.fromRGB(255, 0, 0),
        OutlineColor = Color3.fromRGB(107, 0, 0)
    },
    Knockback = {
        Variance = 0.15,
        MinDistance = 5,
        LaunchAngle = 28,
        TimeScale = 1.35,
        MinGravityScale = 1,
        TumbleSpin = 9,
        SettleTime = 0.5,
        MinDuration = 1
    },
    Tiers = {
        {
            Name = "Bat",
            Template = "Bat",
            Range = 15,
            Knockback = 17.5,
            Zone = 1
        },
        {
            Name = "Cactus Bat",
            Template = "CactusBat",
            Range = 18,
            Knockback = 24,
            Zone = 2
        },
        {
            Name = "Frost Bat",
            Template = "FrostBat",
            Range = 19.5,
            Knockback = 27,
            Zone = 3
        },
        {
            Name = "Candy Bat",
            Template = "CandyBat",
            Range = 21,
            Knockback = 30,
            Zone = 4
        },
        {
            Name = "Tree Bat",
            Template = "TreeBat",
            Range = 22.5,
            Knockback = 33,
            Zone = 5
        },
        {
            Name = "Lake Bat",
            Template = "LakeBat",
            Range = 24,
            Knockback = 36,
            Zone = 6
        },
        {
            Name = "Lava Bat",
            Template = "LavaBat",
            Range = 25.5,
            Knockback = 39,
            Zone = 7
        },
        {
            Name = "Blossom Bat",
            Template = "BlossomBat",
            Range = 27,
            Knockback = 42,
            Zone = 8
        },
        {
            Name = "Galaxy Bat",
            Template = "GalaxyBat",
            Range = 28.5,
            Knockback = 45,
            Zone = 9
        },
        {
            Name = "Electric Hammer",
            Template = "Electric Hammer",
            Range = 30,
            Knockback = 48,
            Zone = 10,
            KeepOutOfChatBubble = true,
            ImageRotation = 40
        }
    }
}

v1.Unlock = {
    RemoteName = "BatUnlockRemote",
    ClaimText = "Claim",
    EquippedText = "Equipped",
    EquipText = "Equip",
    EquippedColor = Color3.fromRGB(60, 255, 60)
}

function v1.ClampTier(v2) -- line 187 | captures: v1
    if not (typeof(v2) == "number" and v2 == v2) then
        return v1.DefaultTier
    end
    local v3 = math.floor(v2)
    local v4 = #v1.Tiers
    return (math.clamp(v3, 1, v4))
end

function v1.GetTier(v5) -- line 194 | captures: v1
    return v1.Tiers[v1.ClampTier(v5)]
end

function v1.GetToolTier(v6) -- line 199 | captures: v1
    return v1.GetTier(v6 and v6:GetAttribute(v1.TierAttribute))
end

function v1.ImageRotationFor(v7) -- line 205 | captures: v1
    local ImageRotation = v1.GetTier(v7).ImageRotation
    if typeof(ImageRotation) == "number" then
        return ImageRotation
    end
    return 0
end

return v1
