-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RranBossConfig = require(script.Parent.RranBossConfig)
local v1 = {
    ModelName = "DemonBoss",
    Tag = "HellBoss",
    HitRemoteName = "HellBossHitRemote",
    DisplayName = "Demon King",
    Subtitle = "RULER OF HELL",
    MaxHealth = 12500,
    AttackDamageMult = 0.62,
    BatDamage = {
        Min = 10,
        Max = 25
    }
}
local v2 = {
    Reference = 4,
    Exponent = 0.45,
    MinMult = 0.6,
    MaxMult = 2.5,
    IdleAfter = 10,
    MoveStuds = 3
}
local v3 = {}

v3[1] = 1.1
v3[2] = 1.06
v2.SmallGroupBonus = v3
v1.DamageScaling = v2
v1.LowHealthDamage = {
    Below = 0.5,
    Mult = 0.85
}

function v1.DamageMult(v4) -- line 101 | captures: v1
    local DamageScaling = v1.DamageScaling
    local v5 = math.max(v4, 1)
    local v6 = (DamageScaling.Reference / v5) ^ DamageScaling.Exponent
    local MinMult = DamageScaling.MinMult
    local MaxMult = DamageScaling.MaxMult
    return math.clamp(v6, MinMult, MaxMult) * (DamageScaling.SmallGroupBonus and DamageScaling.SmallGroupBonus[v5] or 1)
end

function v1.HitDamage(v7, v8, v9) -- line 112 | captures: v1
    local v10 = (v8 or Random.new()):NextInteger(v1.BatDamage.Min, v1.BatDamage.Max)
    local v11 = v1.DamageMult(v7)
    local LowHealthDamage = v1.LowHealthDamage
    if LowHealthDamage and v9 and v9 <= LowHealthDamage.Below then
        v11 *= LowHealthDamage.Mult
    end
    local v12 = v10 * v11 + 0.5
    local v13 = math.floor(v12)
    return (math.max(v13, 1))
end

v1.BatHitRadius = 32
v1.BatHitReach = 10
v1.StrengthAttribute = "BossStrength"
v1.MaxStrength = 1000
v1.BatHitSlack = 8
v1.BatHitRewind = 0.4
v1.Shields = {
    Folder = "BossShields",
    Breakable = false,
    HitboxName = "Hitbox",
    Health = 225,
    BreakDamage = 1000,
    Reach = 10,
    BreakScale = 1.6,
    Off = {
        ColorScale = 0.3,
        FadeDim = 0.35,
        FadeTail = 0.4,
        Material = Enum.Material.SmoothPlastic
    },
    PipOrder = { "Stage1", "Stage2", "Stage3", "Stage4" },
    HitFlash = {
        Transparency = 0.15,
        Time = 0.25,
        Color = Color3.new(1, 1, 1)
    },
    BreakColor = Color3.fromRGB(255, 60, 60),
    BreakSound = {
        Name = "Slam",
        Range = 1400,
        MinRange = 300,
        PlaybackSpeed = 1.35,
        Volume = 0.8
    },
    Overhead = {
        Template = "SheildOverhead",
        Attachment = "HealthoverheadAttachment",
        Text = "%s/%s HP",
        BarTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    }
}
v1.TimeLimit = {
    ShowAfter = 0,
    Total = 720,
    EndAfter = 5,
    Attribute = "HellBossEndsAt",
    Text = "Ends in %s",
    LeftAnnouncement = "has <font color=\"#FF4A3D\">left Hell</font>... nobody beat him in time!",
    Announcer = {
        UserId = 0,
        Name = "DemonKing",
        DisplayName = "Demon King"
    }
}
v1.Fight = {
    IntroTime = 26.5,
    EndHellAfterDefeat = 12,
    ResetDelay = 2,
    FirstAttackDelay = 1.2,
    AttackGap = {
        Min = 5,
        Max = 7.5
    },
    Weights = {
        Stomp = 20,
        TripleStomp = 15,
        Slam = 45,
        Meteor = 35,
        Minions = 45,
        Spikes = 30
    },
    ShieldedWeights = {
        Stomp = 20,
        Slam = 45,
        Meteor = 35,
        Spikes = 30
    },
    Cooldowns = {
        Stomp = 20,
        TripleStomp = 28,
        Minions = 14,
        Spikes = 16
    },
    Enrage = {
        {
            Below = 0.5,
            DamageMult = 1.35,
            GapMult = 0.9,
            WalkMult = 1.15,
            CooldownMult = 0.95,
            CountMult = 1.15,
            SideChance = 0.1,
            SideDelay = 0.8,
            SideKinds = { "Meteor", "Spikes", "Minions" },
            Weights = {
                Stomp = 15,
                TripleStomp = 25,
                Slam = 40,
                Meteor = 35,
                Minions = 45,
                Spikes = 40
            }
        },
        {
            DamageMult = 1.5,
            GapMult = 0.8,
            WalkMult = 1.3,
            CooldownMult = 0.8,
            CountMult = 1.35,
            SideChance = 0.25,
            SideDelay = 0.6,
            Below = 1825 / v1.MaxHealth,
            SideKinds = { "Meteor", "Spikes", "Minions" },
            Weights = {
                Stomp = 10,
                TripleStomp = 35,
                Slam = 40,
                Meteor = 35,
                Minions = 50,
                Spikes = 45
            }
        }
    }
}
v1.Walk = {
    Speed = 31,
    StopDistance = 45,
    MinStep = 8,
    LegTime = 1.2,
    CircleStep = 35,
    CircleFlipChance = 0,
    PublishLead = 0.3,
    AnimationSpeed = 1.39,
    FootstepShake = 1.4,
    FootstepShakeRadius = 140
}
v1.Arena = {
    Radius = 260,
    ShockwaveRadius = 470,
    PlayerRadius = 650
}
v1.Knockback = {
    Light = {
        Distance = 32,
        Variance = 0.15,
        MinDistance = 10,
        LaunchAngle = 38,
        TimeScale = 1.25,
        MinGravityScale = 1,
        TumbleSpin = 9,
        SettleTime = 0.5,
        MinDuration = 1
    },
    Heavy = {
        Distance = 55,
        Variance = 0.15,
        MinDistance = 15,
        LaunchAngle = 34,
        TimeScale = 1.3,
        MinGravityScale = 1,
        TumbleSpin = 10,
        SettleTime = 0.6,
        MinDuration = 1.2
    },
    Huge = {
        Distance = 80,
        Variance = 0.15,
        MinDistance = 20,
        LaunchAngle = 48,
        TimeScale = 1.2,
        MinGravityScale = 1,
        TumbleSpin = 11,
        SettleTime = 0.7,
        MinDuration = 1.4
    }
}
v1.PostHitImmunity = 0.75
v1.RespawnImmunity = {
    Seconds = 5,
    Attribute = "HellBossImmune",
    ForceField = true
}
v1.Attacks = {
    Stomp = {
        Windup = 0.95,
        Recover = 1.1,
        Speed = 140,
        StartRadius = 14,
        Thickness = 6,
        Height = 4,
        Damage = 20,
        Knockback = "Heavy",
        Foot = "LeftFoot",
        FootReach = 40
    },
    TripleStomp = {
        Count = 3,
        Gap = 2.2,
        Recover = 1.1
    },
    Slam = {
        Crouch = 0.5,
        Rise = 0.8,
        Height = 200,
        Aim = 1.5,
        Fall = 0.35,
        Recover = 1.2,
        Radius = 55,
        HitHeight = 14,
        Damage = 35,
        Knockback = "Huge",
        MinTravel = 40,
        Shockwave = {
            StartRadius = 55,
            Speed = 140,
            Thickness = 6,
            Height = 4,
            Damage = 20,
            Knockback = "Heavy"
        }
    },
    Meteor = {
        Cast = 0.9,
        Warn = 1.5,
        Stagger = 0.06,
        PerPlayer = 3,
        Extra = 18,
        Max = 42,
        Spread = 28,
        MinGap = 20,
        Radius = 22,
        HitHeight = 12,
        FallTime = 0.55,
        FallHeight = 260,
        Recover = 0.8,
        Damage = 15,
        Knockback = "Light"
    },
    Spikes = {
        Cast = 0.7,
        Warn = 1.8,
        SpawnTime = 0.35,
        PerPlayer = 2,
        Extra = 50,
        Max = 60,
        Spread = 30,
        MinGap = 28,
        Radius = 16,
        HitHeight = 26,
        SpikeHeight = 30,
        RiseTime = 0.4,
        Hold = 0.9,
        SinkTime = 0.35,
        Recover = 1,
        Damage = 20,
        Knockback = "Light",
        Model = { "spikees" }
    },
    Minions = {
        SpawnPart = "AnimalSpawn",
        Cast = 0.9,
        Recover = 0.8,
        PerPlayer = 2,
        Max = 8,
        Speed = 28,
        SpeedPull = 0.35,
        MinSpeed = 18,
        MaxShare = 0.85,
        CatchUpFrom = 50,
        CatchUpFull = 220,
        CatchUpMult = 1.6,
        StopDistance = 3,
        TouchRadius = 5,
        Spacing = 14,
        SpacingWeight = 2.2,
        RepathEvery = 0.35,
        Height = 7,
        Radius = 16,
        HitHeight = 10,
        Knockback = "Heavy",
        Fuse = {
            Min = 5,
            Max = 20
        },
        HeightScale = {
            HellDragon = 1.5,
            HellHydra = 1.5
        },
        Damage = {
            Min = 10,
            Max = 20
        },
        Animals = { "HellCroc", "HellAnky", "HellTrike", "HellDinoRex", "HellMegalodon", "HellTRex", "HellDragon", "HellHydra" }
    }
}

function v1.AttackLength(v14, v15) -- line 536 | captures: v1
    local Attacks = v1.Attacks
    if v14 == "Stomp" then
        return Attacks.Stomp.Windup + Attacks.Stomp.Recover
    end
    if v14 == "TripleStomp" then
        return v1.TripleStompImpactTime(Attacks.TripleStomp.Count) + Attacks.TripleStomp.Recover
    end
    if v14 == "Slam" then
        local Slam = Attacks.Slam
        return Slam.Crouch + Slam.Rise + Slam.Aim + Slam.Fall + Slam.Recover
    end
    if v14 == "Minions" then
        return Attacks.Minions.Cast + Attacks.Minions.Recover
    end
    if v14 == "Spikes" then
        local Spikes = Attacks.Spikes
        local v16 = v15 or Spikes.Max
        local v17 = Spikes.Cast + Spikes.Warn
        local v18 = if v16 > 1 then Spikes.SpawnTime else 0
        return v17 + v18 + Spikes.RiseTime + Spikes.Recover
    end
    if v14 == "Meteor" then
        local Meteor = Attacks.Meteor
        local v19 = v15 or Meteor.Max
        local v20 = Meteor.Cast + Meteor.Warn
        local v21 = v19 - 1
        return v20 + math.max(v21, 0) * Meteor.Stagger + Meteor.Recover
    end
    return 0
end

function v1.TripleStompInterval() -- line 561 | captures: v1
    return v1.Attacks.TripleStomp.Gap + v1.Attacks.Stomp.Windup
end

function v1.TripleStompImpactTime(v22) -- line 566 | captures: v1
    return v1.Attacks.Stomp.Windup + (v22 - 1) * v1.TripleStompInterval()
end

function v1.SpikeImpactTime(v23, v24) -- line 572 | captures: v1
    local Spikes = v1.Attacks.Spikes
    local v25 = v24 or Spikes.Max
    local v26 = if v25 > 1 then Spikes.SpawnTime / (v25 - 1) else 0
    return Spikes.Cast + Spikes.Warn + (v23 - 1) * v26
end

function v1.SlamImpactTime() -- line 580 | captures: v1
    local Slam = v1.Attacks.Slam
    return Slam.Crouch + Slam.Rise + Slam.Aim + Slam.Fall
end

function v1.MeteorImpactTime(v27) -- line 586 | captures: v1
    local Meteor = v1.Attacks.Meteor
    return Meteor.Cast + Meteor.Warn + (v27 - 1) * Meteor.Stagger
end

v1.Visuals = {
    OutlineTransparency = 0.15,
    BlastName = "Explosion",
    SmokeName = "SmokeVFX",
    StompBlastScale = 1.8,
    SlamBlastScale = 3.2,
    LeapSmokeScale = 3,
    RoarBlastScale = 2.2,
    ShakeRadius = 700,
    ShakeFadeOut = 0.35,
    ShakeMaxStack = 3,
    StompShake = 5,
    SlamShake = 8,
    MeteorShake = 2.5,
    RoarShake = 6,
    LeapShake = 3,
    Outline = Color3.fromRGB(255, 40, 40),
    Indicator = {
        EdgeSegments = 40,
        EdgeWidth = 1.6,
        GrowTransparency = 0.25,
        BeamHeight = 90,
        SlamBeam = false,
        Color = Color3.fromRGB(255, 25, 25),
        EdgeColor = Color3.fromRGB(255, 70, 50),
        FillTransparency = {
            Min = 0.35,
            Max = 0.85
        },
        FlashRate = {
            Min = 2.5,
            Max = 11
        }
    },
    Shockwave = {
        Segments = 72,
        GlowTransparency = 0.6,
        FadeFrom = 0.7,
        Color = Color3.fromRGB(255, 90, 25),
        GlowColor = Color3.fromRGB(255, 30, 10)
    },
    Meteor = {
        Size = 14,
        Spin = 4,
        BlastScale = 1.1,
        Model = { "Assets", "Meteor" },
        Color = Color3.fromRGB(255, 110, 30),
        CoreColor = Color3.fromRGB(255, 220, 120),
        TrailColor = Color3.fromRGB(255, 80, 20)
    },
    Minion = {
        OutlineTransparency = 0,
        SpawnSmokeScale = 1.2,
        BlastScale = 1.5,
        BombTimerLabel = "Timer",
        BombHeightAboveHead = 0.25,
        BlastShake = 9,
        BlastShakeRadius = 90,
        FlashColor = Color3.fromRGB(255, 30, 30),
        OutlineColor = Color3.fromRGB(255, 30, 30),
        FlashRate = {
            Min = 1.5,
            Max = 9
        },
        FlashTransparency = {
            Min = 0.85,
            Max = 0.25
        },
        FlashNear = {
            From = 45,
            Full = 6
        },
        BombOverhead = { "Assets", "AnimalBombOverhead", "BombOverhead" }
    },
    Stun = {
        Stars = 6,
        StarSize = 3.2,
        StarOrbit = 14,
        StarSpeed = 2.4,
        Text = "STUNNED!",
        SubText = "HIT HIM NOW!",
        BannerTitle = "THE DEMON KING IS STUNNED!",
        BannerSub = "Run to him and hit him with your bat!",
        BannerInRange = "HIT HIM NOW!",
        BannerShielded = "Break his SHIELDS! (%d left)",
        ArrowSize = 64,
        ArrowMargin = 90,
        Color = Color3.fromRGB(255, 225, 60),
        BannerColors = {
            Color3.fromRGB(255, 170, 30),
            Color3.fromRGB(255, 240, 110)
        }
    },
    HitFlash = {
        Transparency = 0.5,
        FadeIn = 0.05,
        Time = 0.4,
        Color = Color3.fromRGB(255, 35, 35)
    },
    WeaponSlam = {
        Bone = "Weapon",
        SmokeScale = 1.4,
        BlastScale = 0.9,
        ChunkScale = 0.3,
        Ring = false,
        RingSpeed = 90,
        RingMax = 34,
        RingHeight = 1.5,
        RingThickness = 3,
        Shake = 2.5,
        Marks = { 1.52, 3.45 }
    },
    Crater = {
        Radius = 30,
        MeteorScale = 0.45,
        Blocks = 22,
        Tilt = 35,
        RiseTime = 0.3,
        Stagger = 0.18,
        Linger = 2,
        ShrinkTime = 0.4,
        BlockSize = {
            Min = 3,
            Max = 9
        },
        StickOut = {
            Min = 0.35,
            Max = 0.8
        },
        FallbackColor = Color3.fromRGB(120, 30, 20)
    }
}
v1.SfxVolume = 0.4
v1.Sfx = {
    MinionBeepSlow = 1,
    MinionBeepFrom = 3,
    Folder = RranBossConfig.Sfx.Folder,
    Stomp = {
        Name = "Stomp",
        Range = 1400,
        MinRange = 400,
        PlaybackSpeed = 0.45,
        Volume = 0.9
    },
    StompBoom = {
        Name = "Slam",
        Range = 1400,
        MinRange = 400,
        PlaybackSpeed = 1.15,
        Volume = 0.45
    },
    TakeOff = {
        Name = "Slam",
        Range = 1400,
        MinRange = 400,
        PlaybackSpeed = 1.3,
        Volume = 0.4
    },
    MinionSpawn = {
        Name = "Stomp",
        Range = 900,
        MinRange = 200,
        PlaybackSpeed = 1.4,
        Volume = 0.5
    },
    MinionBoom = {
        Name = "Slam",
        Range = 1000,
        MinRange = 250,
        PlaybackSpeed = 1.2,
        Volume = 0.8
    },
    SpikeRise = {
        Folder = "rransCustomSFX",
        Name = "SpikesEmerge",
        Range = 900,
        MinRange = 200,
        Volume = 0.8
    },
    SpikeRumble = {
        Name = "SpikeRumble",
        Range = 1400,
        MinRange = 500,
        Volume = 0.7
    },
    SpikeCrack = {
        Name = "SpikeCrack",
        Range = 800,
        MinRange = 150,
        Volume = 0.75
    },
    SpikeSink = {
        Name = "SpikeSink",
        Range = 700,
        MinRange = 150,
        Volume = 0.45
    },
    MeteorCast = {
        Name = "MeteorCast",
        Range = 1400,
        MinRange = 400,
        Volume = 0.7
    },
    MinionSummon = {
        Name = "MinionSummon",
        Range = 1400,
        MinRange = 400,
        Volume = 0.7
    },
    MinionBeep = {
        Folder = "rransCustomSFX",
        Name = "Beep",
        Range = 220,
        MinRange = 40
    },
    MinionBeepEvery = {
        Max = 1,
        Min = 0.1
    },
    MinionRoar = {
        Volume = 1.6,
        Approach = 2.2,
        Far = {
            Volume = 0.12,
            HighGain = -40,
            MidGain = -14,
            ReverbWet = -4
        },
        Near = {
            HighGain = 0,
            MidGain = 0,
            ReverbWet = -40
        },
        Animals = {
            HellHydra = {
                SoundId = "rbxassetid://125517277831362",
                PlaybackSpeed = 0.95,
                Priority = 8
            },
            HellDragon = {
                SoundId = "rbxassetid://135692329023659",
                PlaybackSpeed = 0.85,
                Priority = 7
            },
            HellTRex = {
                SoundId = "rbxassetid://6470855561",
                PlaybackSpeed = 0.9,
                Priority = 6
            },
            HellDinoRex = {
                SoundId = "rbxassetid://122528865379108",
                PlaybackSpeed = 0.9,
                Priority = 5
            },
            HellMegalodon = {
                SoundId = "rbxassetid://78025107672489",
                PlaybackSpeed = 0.8,
                Priority = 4
            },
            HellTrike = {
                SoundId = "rbxassetid://6528126715",
                PlaybackSpeed = 0.85,
                Priority = 3
            },
            HellAnky = {
                SoundId = "rbxassetid://78764625363408",
                PlaybackSpeed = 0.85,
                Priority = 2
            },
            HellCroc = {
                SoundId = "rbxassetid://133224963230056",
                PlaybackSpeed = 0.75,
                Priority = 1
            }
        }
    },
    PlayerHit = {
        Name = "PlayerHit",
        Range = 100,
        Volume = 0.8
    },
    BossHurt = {
        Folder = "BossSfx",
        Name = "DemonGrowl3",
        Range = 1400,
        MinRange = 400,
        Volume = 0.6,
        Chance = 0.2,
        Gap = 1.2
    },
    ShieldsDown = {
        Name = "ShieldsDown",
        Range = 2000,
        MinRange = 600,
        Volume = 0.9
    },
    Slam = {
        Name = "Slam",
        Range = 1400,
        MinRange = 400,
        Volume = 0.8
    },
    LargeImpact = {
        Folder = "rransCustomSFX",
        Name = "LargeImpact",
        Range = 1400,
        MinRange = 400,
        Volume = 0.6,
        Lead = 2
    },
    Footstep = {
        Name = "Stomp",
        Range = 700,
        MinRange = 150,
        PlaybackSpeed = 0.55,
        Volume = 0.5
    },
    WeaponSlam = {
        Name = "Stomp",
        Range = 900,
        MinRange = 200,
        PlaybackSpeed = 0.7,
        Volume = 0.6
    },
    MeteorFall = {
        Name = "EggWhoosh",
        Range = 500,
        MinRange = 60,
        PlaybackSpeed = 0.7,
        Volume = 0.6
    },
    MeteorHit = {
        Name = "EggLand",
        Range = 700,
        MinRange = 120,
        PlaybackSpeed = 0.8,
        Volume = 0.8
    },
    Roar = {
        Name = "Slam",
        Range = 1400,
        MinRange = 400,
        PlaybackSpeed = 0.6,
        Volume = 0.8
    }
}
v1.Dialogue = {
    Gui = "MainGUI",
    Frame = "BossDialogue",
    TextName = "Text",
    SpeakerName = "DemonKing",
    DisplayOrder = 45,
    DropBelow = {
        Path = { "BossHP" },
        Parts = { "BossHpBar", "Hp", "Shields", "Icon" }
    },
    BelowGap = 4,
    Speaker = "Demon King",
    Format = "%s: %s",
    CharsPerSecond = 30,
    TypeSound = {
        Folder = "UiSounds",
        Name = "Tick Sound",
        Every = 2,
        Volume = 0.25
    },
    Hold = 2.6,
    HoldPerChar = 0.04,
    LineName = "BossDialogue",
    TaskName = "Task",
    TaskTextName = "Text",
    MaxLines = 1,
    QuietGap = 3,
    QueueMax = 2,
    QueueGap = 0.5,
    Important = {
        Summon = true,
        IntroA = true,
        IntroB = true,
        FightStart = true,
        ShieldsDown = true,
        Enrage1 = true,
        Enrage2 = true,
        ThreeQuarterHealth = true,
        HalfHealth = true,
        LowHealth = true
    },
    Interrupt = {
        Defeat = true,
        Scream = true,
        Fallen = true,
        Failed = true
    },
    Voice = {
        Folder = "BossSfx",
        Volume = 0.8,
        Sounds = { "DemonGrowl1", "DemonGrowl2", "DemonGrowl3" },
        PlaybackSpeed = {
            Min = 0.72,
            Max = 0.88
        },
        Silent = {
            Defeat = true,
            Scream = true,
            Fallen = true
        }
    },
    PopTime = 0.25,
    AttackChance = 0.75,
    LowHealthAt = 0.25,
    HalfHealthAt = 0.5,
    ThreeQuarterAt = 0.75,
    PlayerDownChance = 0.7,
    MinGap = 4,
    ShieldHitChance = 0.2,
    HurtChance = 0.25,
    TauntEvery = {
        Min = 20,
        Max = 32
    },
    Lines = {
        Summon = "WHO DARES OPEN MY GATE?!",
        IntroA = "So... more mortals crawl into MY domain.",
        IntroB = "I am the DEMON KING! Kneel before me!",
        Defeat = "No... NO! This can't be happening...!",
        Scream = "NOOOOOOO!!",
        Fallen = "I'll... be... back...",
        FightStart = { "Come then! Let's see what you're made of!", "You picked the wrong boss to mess with!", "Welcome to MY house!", "None of you will leave this place!", "Visitors! How DELIGHTFUL!", "Let the showdown BEGIN!", "You came all this way just to LOSE!" },
        Stomp = { "FEEL THE GROUND SHAKE!", "Jump, little insects!", "The earth obeys ME!", "Hop, hop, little mortals!", "Can you feel THAT?!", "Keep your feet off MY ground!", "Shake, rattle and ROLL!", "Too slow to jump? Try again!" },
        TripleStomp = { "AGAIN! AND AGAIN! AND AGAIN!", "Keep jumping, insects!", "Dance for me!", "How long can you keep this up?!", "One! Two! THREE!", "Jump! Jump! JUMP!", "Your legs will give out first!", "I could do this ALL DAY!" },
        Slam = { "NOWHERE TO RUN!", "FROM ABOVE!", "Squish time!", "Look UP, fool!", "Incoming DOOM!", "Catch me if you can!", "Here I COME!", "Down you go!" },
        Spikes = { "The ground itself hates you!", "Watch your step!", "Pointy surprise!", "Nowhere is safe!", "The floor is extra pointy today!", "Mind the floor, mortal!", "Let's see you dodge THESE!", "Ouch! Spiky, isn't it?" },
        Minions = { "Rise, my pets! HUNT THEM!", "Go, my little bombs!", "Fetch... and EXPLODE!", "My pets are hungry!", "Tick tock, mortals!", "Hug them! They love hugs... BOOM!", "Run all you like \226\128\148 they're faster!", "Sic 'em, my darlings!" },
        Meteor = { "LOOK OUT BELOW!", "RAIN FIRE UPON THEM!", "Dodge THIS!", "Special delivery from the sky!", "It's raining rocks!", "Look up and despair!", "A gift from the sky!", "Heads up, down there!" },
        ShieldHit = { "My shields will never fall!", "You're wasting your time!", "Hit it all you like, fool!", "Pathetic little taps!", "Knock knock. Nobody's home!", "Scratch it harder, it might break!", "Is that a bat or a toothpick?", "My shields laugh at you!" },
        ShieldBroken = { "You broke one?! It means NOTHING!", "A lucky swing... it won't happen again!", "Grr... I have more where that came from!", "That shield was my favourite!", "Cracking my shields won't save you!", "Hmph. One down... you'll never get them all!", "You'll pay for every shield you break!", "Enjoy it while it lasts, mortal!" },
        ShieldsDown = { "My shields... NO! Stay back!", "Impossible! My defences...!", "Fine! I'll crush you with my own hands!", "You think that makes you safe?!", "No more hiding. Face me, then!" },
        Hurt = {
            "Is that all you've got?!",
            "That tickled!",
            "Ow! You'll pay for that!",
            "Grrraaah!",
            "You DARE strike me?!",
            "Hah! Hit me again, I dare you!",
            "A bee sting, nothing more!",
            "You're only making me ANGRY!",
            "Ugh! Lucky shot!",
            "Stop that THIS INSTANT!"
        },
        PlayerDown = { "One down! Who's next?", "Another one BITES the dust!", "Better luck next time!", "Who's next?!", "Too easy!", "Ha! Up you get, try again!", "Stay down, mortal!", "HA! Pathetic!" },
        Enrage1 = { "ENOUGH! No more holding back!", "Now you've made me ANGRY!", "Time to turn up the heat!" },
        Enrage2 = { "RAAAAGH! I'll use EVERYTHING I've got!", "You want a real fight?! HERE IT IS!", "No more games! FULL POWER!" },
        ThreeQuarterHealth = { "A scratch! Just a scratch!", "Hey! That actually stung a bit!", "Hmm. You're not completely useless." },
        HalfHealth = { "You're stronger than you look... but not strong enough!", "Enough games! Now I get SERIOUS!", "Half of me is still more than all of you!", "You've awakened my true FURY!" },
        Taunt = {
            "Run, run, RUN!",
            "You call that running?",
            "It was getting boring down here anyway!",
            "I've waited a thousand years for this!",
            "Is this the best the mortal world can send?",
            "I can see you trembling from here!",
            "Bow before your king!",
            "This realm is MINE!",
            "Is it getting HOT in here, or is it just me?",
            "Nobody escapes the Demon King!",
            "I've beaten heroes way tougher than you!",
            "Your eggs won't save you down here!",
            "Tired already? We've only just begun!",
            "Cheer louder! I can barely hear you!",
            "Every step you take, I'm right behind you!",
            "Hell never closes, mortal!"
        },
        Stunned = { "Ugh... my head...", "N-no... I can't move...!", "What... is happening to me...?" },
        Recover = { "ENOUGH! You'll pay for that!", "I'm BACK! Did you miss me?", "That won't happen again!" },
        LowHealth = { "Impossible... how are you this strong?!", "No... I will NOT fall to mortals!", "This isn't over! Not yet!", "I refuse... to lose... to YOU!", "Guards! GUARDS?! ...Anyone?!" },
        Failed = { "TIME'S UP! You've FAILED, mortals!", "You've FAILED! Crawl back to your little eggs!", "Too slow! Hell belongs to ME!", "FAILED! Nobody beats the Demon King!" }
    }
}
v1.Cutscene = {
    Enabled = true,
    BarsTime = 0.45,
    Smoothing = 7,
    MinTimeLeft = 18,
    Return = 1.1,
    SafetyGrace = 1.5,
    BarsGui = RranBossConfig.Cutscene.BarsGui,
    Hero = {
        Time = 3.2,
        PushIn = 0.12,
        Look = 0.72,
        RoarAt = 0.3,
        TitleAt = 1.05,
        FovPunch = 12,
        At = {
            Angle = -8,
            Distance = 1,
            Up = 0.16
        }
    },
    Sound = {
        Folder = "rransCustomSFX",
        Name = "CinematicIntro",
        FadeOut = 1
    },
    Title = {
        StrokeThickness = 4,
        Hold = 2.1,
        FadeTime = 0.35,
        Font = Font.new("rbxassetid://12187365977", Enum.FontWeight.Heavy),
        Colors = {
            Color3.fromRGB(255, 70, 40),
            Color3.fromRGB(255, 200, 60)
        },
        StrokeColor = Color3.fromRGB(0, 0, 0),
        SubColor = Color3.fromRGB(255, 235, 220)
    }
}
v1.IdleAnimation = RranBossConfig.IdleAnimation

local Poses = RranBossConfig.Poses
local v28 = {
    RightHip = { 78, 0, 8 },
    RightKnee = { -88, 0, 0 },
    RightAnkle = { 18, 0, 0 },
    LeftHip = { -4, 0, -6 },
    LeftKnee = { -12, 0, 0 },
    LeftAnkle = { 8, 0, 0 },
    Waist = { 10, 6, -4 },
    Neck = { -8, -6, 0 },
    RightShoulder = { 25, 0, 55 },
    LeftShoulder = { 25, 0, -60 },
    RightElbow = { 30, 0, 0 },
    LeftElbow = { 30, 0, 0 }
}
local v29 = { 0, 0, 0 }

v29.Pos = Vector3.new(0, -0.03999999910593033, 0)
v28.Root = v29

local v30 = {
    RightHip = { 28, 0, 10 },
    RightKnee = { -40, 0, 0 },
    RightAnkle = { 12, 0, 0 },
    LeftHip = { 22, 0, -8 },
    LeftKnee = { -45, 0, 0 },
    LeftAnkle = { 22, 0, 0 },
    Waist = { -16, 0, 0 },
    Neck = { 12, 0, 0 },
    RightShoulder = { -15, 0, 38 },
    LeftShoulder = { -15, 0, -38 },
    RightElbow = { 35, 0, 0 },
    LeftElbow = { 35, 0, 0 }
}
local v31 = { 0, 0, 0 }

v31.Pos = Vector3.new(0, -0.20000000298023224, 0)
v30.Root = v31

local v32 = {
    Waist = { -18, 0, 0 },
    Neck = { -15, 0, 0 },
    RightShoulder = { -10, 0, 20 },
    LeftShoulder = { -10, 0, -20 },
    RightElbow = { 75, 0, 0 },
    LeftElbow = { 75, 0, 0 },
    RightHip = { 20, 0, 8 },
    LeftHip = { 20, 0, -8 },
    RightKnee = { -35, 0, 0 },
    LeftKnee = { -35, 0, 0 },
    RightAnkle = { 15, 0, 0 },
    LeftAnkle = { 15, 0, 0 }
}
local v33 = { 0, 0, 0 }

v33.Pos = Vector3.new(0, -0.1599999964237213, 0)
v32.Root = v33

local v34 = {
    Waist = { 16, 0, 0 },
    Neck = { 24, 0, 0 },
    RightShoulder = { 38, 0, 75 },
    LeftShoulder = { 38, 0, -75 },
    RightElbow = { 30, 0, 0 },
    LeftElbow = { 30, 0, 0 },
    RightHip = { 6, 0, 12 },
    LeftHip = { 6, 0, -12 },
    RightKnee = { -18, 0, 0 },
    LeftKnee = { -18, 0, 0 },
    RightAnkle = { 8, 0, 0 },
    LeftAnkle = { 8, 0, 0 }
}
local v35 = { 0, 0, 0 }

v35.Pos = Vector3.new(0, -0.07999999821186066, 0)
v34.Root = v35

local v36 = table.clone(v34)

v36.Waist = { 19, 3, 0 }
v36.Neck = { 29, -3, 0 }
v36.RightShoulder = { 46, 0, 80 }
v36.LeftShoulder = { 46, 0, -80 }

local v37 = {
    Waist = { -12, 0, 0 },
    Neck = { -10, 0, 0 },
    RightShoulder = { -20, 0, 15 },
    LeftShoulder = { -20, 0, -15 },
    RightElbow = { 50, 0, 0 },
    LeftElbow = { 50, 0, 0 },
    RightHip = { 18, 0, 8 },
    LeftHip = { 18, 0, -8 },
    RightKnee = { -32, 0, 0 },
    LeftKnee = { -32, 0, 0 },
    RightAnkle = { 14, 0, 0 },
    LeftAnkle = { 14, 0, 0 }
}
local v38 = { 0, 0, 0 }

v38.Pos = Vector3.new(0, -0.14000000059604645, 0)
v37.Root = v38

local v39 = {
    Waist = { 12, 0, 0 },
    Neck = { 26, 0, 0 },
    RightShoulder = { 165, 0, 18 },
    LeftShoulder = { 165, 0, -18 },
    RightElbow = { 10, 0, 0 },
    LeftElbow = { 10, 0, 0 },
    RightHip = { 4, 0, 8 },
    LeftHip = { 4, 0, -8 },
    RightKnee = { -10, 0, 0 },
    LeftKnee = { -10, 0, 0 },
    RightAnkle = { 5, 0, 0 },
    LeftAnkle = { 5, 0, 0 }
}
local v40 = { 0, 0, 0 }

v40.Pos = Vector3.new(0, -0.019999999552965164, 0)
v39.Root = v40

local v41 = {
    RightHip = { 40, 0, 10 },
    LeftHip = { 40, 0, -10 },
    RightKnee = { -75, 0, 0 },
    LeftKnee = { -75, 0, 0 },
    RightAnkle = { 35, 0, 0 },
    LeftAnkle = { 35, 0, 0 },
    Waist = { -30, 8, 0 },
    Neck = { -28, -6, 10 },
    RightShoulder = { -8, 0, 8 },
    LeftShoulder = { -8, 0, -8 },
    RightElbow = { 12, 0, 0 },
    LeftElbow = { 12, 0, 0 }
}
local v42 = { 0, 0, 0 }

v42.Pos = Vector3.new(0, -0.41999998688697815, 0)
v41.Root = v42

local v43 = table.clone(v41)

v43.Waist = { -26, -8, 0 }
v43.Neck = { -22, 6, -10 }
v43.RightShoulder = { -4, 0, 12 }
v43.LeftShoulder = { -4, 0, -12 }

local v44 = {
    RightHip = { 70, 0, 12 },
    LeftHip = { 70, 0, -12 },
    RightKnee = { -110, 0, 0 },
    LeftKnee = { -110, 0, 0 },
    RightAnkle = { 45, 0, 0 },
    LeftAnkle = { 45, 0, 0 },
    Waist = { -45, 0, 0 },
    Neck = { -35, 0, 0 },
    RightShoulder = { -20, 0, 4 },
    LeftShoulder = { -20, 0, -4 },
    RightElbow = { 5, 0, 0 },
    LeftElbow = { 5, 0, 0 }
}
local v45 = { 0, 0, 0 }

v45.Pos = Vector3.new(0, -0.8999999761581421, 0)
v44.Root = v45

local v46 = {
    Waist = { 18, 0, 0 },
    Neck = { 22, 0, 0 },
    RightShoulder = { 70, 0, 55 },
    LeftShoulder = { 70, 0, -55 },
    RightElbow = { 30, 0, 0 },
    LeftElbow = { 30, 0, 0 },
    RightHip = { -6, 0, 6 },
    LeftHip = { -6, 0, -6 },
    RightKnee = { -12, 0, 0 },
    LeftKnee = { -12, 0, 0 }
}
local v47 = {
    Neck = { 12, 0, 0 },
    RightShoulder = { 10, 0, 80 },
    LeftShoulder = { 10, 0, -80 },
    RightElbow = { 12, 0, 0 },
    LeftElbow = { 12, 0, 0 },
    RightHip = { 0, 0, 10 },
    LeftHip = { 0, 0, -10 },
    RightKnee = { -6, 0, 0 },
    LeftKnee = { -6, 0, 0 }
}
local v48 = {
    Waist = { -10, 0, 0 },
    Neck = { -25, 0, 0 },
    RightShoulder = { 100, 0, 20 },
    LeftShoulder = { 100, 0, -20 },
    RightElbow = { 20, 0, 0 },
    LeftElbow = { 20, 0, 0 },
    RightHip = { 25, 0, 10 },
    LeftHip = { 25, 0, -10 },
    RightKnee = { -35, 0, 0 },
    LeftKnee = { -35, 0, 0 }
}

v1.Poses = {
    Rest = Poses.Rest,
    Breathe = Poses.Breathe,
    Land = Poses.Land,
    Launch = Poses.Launch,
    Hover = Poses.Hover,
    Fall = Poses.Fall,
    StompLift = v28,
    StompDown = v30,
    RoarBrace = v32,
    Roar = v34,
    RoarShake = v36,
    CastGather = v37,
    CastUp = v39,
    StunnedA = v41,
    StunnedB = v43,
    Defeated = v44,
    Stagger = v46,
    Fallen = v47,
    Reach = v48
}

local Stomp = v1.Attacks.Stomp
local Slam = v1.Attacks.Slam
local Meteor = v1.Attacks.Meteor
local v49 = Slam.Crouch + Slam.Rise
local v50 = v1.SlamImpactTime()
local Stomp_2 = v1.AttackLength("Stomp")
local Slam_2 = v1.AttackLength("Slam")
local v51 = Meteor.Cast + Meteor.Warn
local TripleStomp = v1.AttackLength("TripleStomp")
local v52 = {
    {
        Time = 0,
        Pose = "Rest"
    }
}
local Count = v1.Attacks.TripleStomp.Count
for v53 = 1, Count do
    local v54 = v1.TripleStompImpactTime(v53)
    local v55 = v54 - Stomp.Windup
    if v53 > 1 then
        local v56 = {
            Pose = "Rest",
            Style = "Quad",
            Direction = "InOut",
            Time = v55
        }
        table.insert(v52, v56)
    end
    local v57 = {
        Pose = "StompLift",
        Style = "Quad",
        Direction = "Out",
        Time = v55 + Stomp.Windup * 0.75
    }
    table.insert(v52, v57)
    local v58 = {
        Pose = "StompLift",
        Style = "Linear",
        Time = v55 + Stomp.Windup * 0.88
    }
    table.insert(v52, v58)
    local v59 = {
        Pose = "StompDown",
        Style = "Quad",
        Direction = "In",
        Time = v54
    }
    table.insert(v52, v59)
    local v60 = v1.Attacks.TripleStomp.Gap * 0.45
    local v61 = {
        Pose = "StompDown",
        Style = "Linear",
        Time = v54 + math.min(0.45, v60)
    }
    table.insert(v52, v61)
end
local v62 = {
    Pose = "Rest",
    Style = "Quad",
    Direction = "InOut",
    Time = TripleStomp
}
table.insert(v52, v62)
v1.Clips = {
    Idle = RranBossConfig.Clips.Idle,
    Stomp = {
        Looped = false,
        Length = Stomp_2,
        Keyframes = {
            {
                Time = 0,
                Pose = "Rest"
            },
            {
                Pose = "StompLift",
                Style = "Quad",
                Direction = "Out",
                Time = Stomp.Windup * 0.75
            },
            {
                Pose = "StompLift",
                Style = "Linear",
                Time = Stomp.Windup * 0.88
            },
            {
                Pose = "StompDown",
                Style = "Quad",
                Direction = "In",
                Time = Stomp.Windup
            },
            {
                Pose = "StompDown",
                Style = "Linear",
                Time = Stomp.Windup + 0.45
            },
            {
                Pose = "Rest",
                Style = "Quad",
                Direction = "InOut",
                Time = Stomp_2
            }
        }
    },
    TripleStomp = {
        Looped = false,
        Length = TripleStomp,
        Keyframes = v52
    },
    Slam = {
        Looped = false,
        Length = Slam_2,
        Keyframes = {
            {
                Time = 0,
                Pose = "Rest"
            },
            {
                Pose = "Land",
                Style = "Quad",
                Direction = "Out",
                Time = Slam.Crouch
            },
            {
                Pose = "Launch",
                Style = "Quad",
                Direction = "Out",
                Time = Slam.Crouch + 0.18
            },
            {
                Pose = "Hover",
                Style = "Sine",
                Direction = "InOut",
                Time = v49
            },
            {
                Pose = "Hover",
                Style = "Linear",
                Time = v49 + Slam.Aim * 0.8
            },
            {
                Pose = "Fall",
                Style = "Quad",
                Direction = "Out",
                Time = v50 - Slam.Fall * 0.5
            },
            {
                Pose = "Fall",
                Style = "Linear",
                Time = v50
            },
            {
                Pose = "Land",
                Style = "Quad",
                Direction = "Out",
                Time = v50 + 0.06
            },
            {
                Pose = "Land",
                Style = "Linear",
                Time = v50 + 0.6
            },
            {
                Pose = "Rest",
                Style = "Back",
                Direction = "Out",
                Time = Slam_2
            }
        }
    },
    Meteor = {
        Looped = false,
        Length = v51 + Meteor.Recover + 0.6,
        Keyframes = {
            {
                Time = 0,
                Pose = "Rest"
            },
            {
                Pose = "CastGather",
                Style = "Quad",
                Direction = "Out",
                Time = Meteor.Cast * 0.5
            },
            {
                Pose = "CastUp",
                Style = "Back",
                Direction = "Out",
                Time = Meteor.Cast
            },
            {
                Pose = "CastUp",
                Style = "Linear",
                Time = v51
            },
            {
                Pose = "Rest",
                Style = "Quad",
                Direction = "InOut",
                Time = v51 + Meteor.Recover + 0.6
            }
        }
    },
    Spikes = {
        Looped = false,
        Length = v1.Attacks.Spikes.Cast + v1.Attacks.Spikes.Warn + v1.Attacks.Spikes.Recover,
        Keyframes = {
            {
                Time = 0,
                Pose = "Rest"
            },
            {
                Pose = "StompLift",
                Style = "Quad",
                Direction = "Out",
                Time = v1.Attacks.Spikes.Cast * 0.7
            },
            {
                Pose = "StompDown",
                Style = "Quad",
                Direction = "In",
                Time = v1.Attacks.Spikes.Cast
            },
            {
                Pose = "StompDown",
                Style = "Linear",
                Time = v1.Attacks.Spikes.Cast + 0.6
            },
            {
                Pose = "Rest",
                Style = "Quad",
                Direction = "InOut",
                Time = v1.Attacks.Spikes.Cast + v1.Attacks.Spikes.Warn + v1.Attacks.Spikes.Recover
            }
        }
    },
    Minions = {
        Looped = false,
        Length = v1.AttackLength("Minions") + 0.4,
        Keyframes = {
            {
                Time = 0,
                Pose = "Rest"
            },
            {
                Pose = "CastGather",
                Style = "Quad",
                Direction = "Out",
                Time = v1.Attacks.Minions.Cast * 0.5
            },
            {
                Pose = "CastUp",
                Style = "Back",
                Direction = "Out",
                Time = v1.Attacks.Minions.Cast
            },
            {
                Pose = "Rest",
                Style = "Quad",
                Direction = "InOut",
                Time = v1.AttackLength("Minions") + 0.4
            }
        }
    },
    Roar = {
        Length = 3,
        Looped = false,
        Keyframes = {
            {
                Time = 0,
                Pose = "Rest"
            },
            {
                Time = 0.55,
                Pose = "RoarBrace",
                Style = "Quad",
                Direction = "Out"
            },
            {
                Time = 0.65,
                Pose = "Roar",
                Style = "Back",
                Direction = "Out"
            },
            {
                Time = 0.95,
                Pose = "RoarShake",
                Style = "Sine",
                Direction = "InOut"
            },
            {
                Time = 1.25,
                Pose = "Roar",
                Style = "Sine",
                Direction = "InOut"
            },
            {
                Time = 1.55,
                Pose = "RoarShake",
                Style = "Sine",
                Direction = "InOut"
            },
            {
                Time = 2.2,
                Pose = "Roar",
                Style = "Sine",
                Direction = "InOut"
            },
            {
                Time = 3,
                Pose = "Rest",
                Style = "Quad",
                Direction = "InOut"
            }
        }
    },
    Stunned = {
        Length = 1.8,
        Looped = true,
        Keyframes = {
            {
                Time = 0,
                Pose = "StunnedA"
            },
            {
                Time = 0.9,
                Pose = "StunnedB",
                Style = "Sine",
                Direction = "InOut"
            },
            {
                Time = 1.8,
                Pose = "StunnedA",
                Style = "Sine",
                Direction = "InOut"
            }
        }
    }
}
v1.Defeat = {
    BreakTime = 2.4,
    StaggerTime = 0.7,
    FallTime = 1.1,
    LieLift = 6.5,
    CrackAt = 2.2,
    CrackTime = 2.6,
    OpenAt = 4.8,
    OpenTime = 1.1,
    ScreamAt = 6,
    DropAt = 6.2,
    DropTime = 1.8,
    DropDepth = 2.2,
    DropTilt = 35,
    DropRoll = 14,
    DropRollSpeed = 1.6,
    FadeStart = 0.2,
    FadeEnd = 0.85,
    Topple = {
        BlendIn = 0.25,
        Moves = {
            {
                Bone = "Torso",
                Axis = "Swing",
                Amp = 3,
                Speed = 0.5,
                AmpFrom = 2.4,
                Keys = {
                    { 0, 0 },
                    { 0.5, 22 },
                    { 0.8, 18 },
                    { 1.5, -12 },
                    { 1.8, -16 },
                    { 2, -4 },
                    { 2.4, -8 }
                }
            },
            {
                Bone = "Head",
                Axis = "Swing",
                Amp = 6,
                Speed = 1.1,
                AmpTo = 0.9,
                Keys = {
                    { 0, 0 },
                    { 0.5, 25 },
                    { 1.2, -35 },
                    { 1.8, -45 },
                    { 1.95, -10 },
                    { 2.3, -25 }
                }
            },
            {
                Bone = "LeftUpperArm",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { 0.6, -20 },
                    { 1.3, 20 },
                    { 1.8, -10 },
                    { 2.3, -15 }
                }
            },
            {
                Bone = "RightUpperArm",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { 0.65, -25 },
                    { 1.35, 80 },
                    { 1.8, 45 },
                    { 2.3, 25 }
                }
            },
            {
                Bone = "LeftUpperArm",
                Axis = "Flap",
                Side = 1,
                Amp = 18,
                Speed = 3.2,
                AmpFrom = 0.7,
                AmpTo = 1.8,
                Keys = {
                    { 0, 0 },
                    { 0.7, 25 },
                    { 1.4, 70 },
                    { 1.8, 95 },
                    { 2.3, 95 }
                }
            },
            {
                Bone = "RightUpperArm",
                Axis = "Flap",
                Side = -1,
                Amp = 18,
                Speed = 3.2,
                Phase = 0.5,
                AmpFrom = 0.7,
                AmpTo = 1.8,
                Keys = {
                    { 0, 0 },
                    { 0.7, 15 },
                    { 1.4, 55 },
                    { 1.8, 75 },
                    { 2.3, 70 }
                }
            },
            {
                Bone = "LeftLowerArm",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { 0.6, 30 },
                    { 1.4, 10 },
                    { 1.8, 5 },
                    { 2.3, 5 }
                }
            },
            {
                Bone = "LeftHand",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { 1.3, -30 },
                    { 1.8, -90 },
                    { 2.3, -90 }
                }
            },
            {
                Bone = "RightLowerArm",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { 0.6, 40 },
                    { 1.4, 15 },
                    { 1.8, 35 },
                    { 2.3, 45 }
                }
            },
            {
                Bone = "LeftUpperLeg",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { 0.6, 15 },
                    { 1.3, 40 },
                    { 1.8, 65 },
                    { 2.05, 35 },
                    { 2.4, 40 }
                }
            },
            {
                Bone = "RightUpperLeg",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { 0.65, 12 },
                    { 1.4, 50 },
                    { 1.8, 50 },
                    { 2.1, 25 },
                    { 2.4, 30 }
                }
            },
            {
                Bone = "LeftLowerLeg",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { 0.6, -30 },
                    { 1.3, -35 },
                    { 1.8, -15 },
                    { 2.1, -45 },
                    { 2.4, -35 }
                }
            },
            {
                Bone = "RightLowerLeg",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { 0.65, -25 },
                    { 1.4, -30 },
                    { 1.8, -20 },
                    { 2.1, -40 },
                    { 2.4, -30 }
                }
            },
            {
                Bone = "LeftWing",
                Axis = "Flap",
                Side = 1,
                Amp = 20,
                Speed = 3,
                AmpFrom = 0.8,
                AmpTo = 1.8,
                Keys = {
                    { 0, 0 },
                    { 0.7, -15 },
                    { 1.5, 40 },
                    { 1.8, 55 },
                    { 2.4, 50 }
                }
            },
            {
                Bone = "RightWing",
                Axis = "Flap",
                Side = -1,
                Amp = 20,
                Speed = 3,
                AmpFrom = 0.8,
                AmpTo = 1.8,
                Keys = {
                    { 0, 0 },
                    { 0.7, -15 },
                    { 1.5, 40 },
                    { 1.8, 55 },
                    { 2.4, 50 }
                }
            }
        }
    },
    Flail = {
        StartAt = 6,
        BlendIn = 0.35,
        Moves = {
            {
                Bone = "LeftUpperArm",
                Axis = "Swing",
                Base = 80,
                Amp = 30,
                Speed = 2.2,
                Phase = 0
            },
            {
                Bone = "LeftUpperArm",
                Axis = "Flap",
                Side = 1,
                Base = 55
            },
            {
                Bone = "RightUpperArm",
                Axis = "Swing",
                Base = 110,
                Amp = 30,
                Speed = 2.2,
                Phase = 0.5
            },
            {
                Bone = "LeftLowerArm",
                Axis = "Swing",
                Base = 25,
                Amp = 25,
                Speed = 2.2,
                Phase = 0.25
            },
            {
                Bone = "RightLowerArm",
                Axis = "Swing",
                Base = 25,
                Amp = 25,
                Speed = 2.2,
                Phase = 0.75
            },
            {
                Bone = "LeftUpperLeg",
                Axis = "Swing",
                Base = 35,
                Amp = 30,
                Speed = 2.6,
                Phase = 0
            },
            {
                Bone = "RightUpperLeg",
                Axis = "Swing",
                Base = 35,
                Amp = 30,
                Speed = 2.6,
                Phase = 0.5
            },
            {
                Bone = "LeftLowerLeg",
                Axis = "Swing",
                Base = -30,
                Amp = 20,
                Speed = 2.6,
                Phase = 0.25
            },
            {
                Bone = "RightLowerLeg",
                Axis = "Swing",
                Base = -30,
                Amp = 20,
                Speed = 2.6,
                Phase = 0.75
            },
            {
                Bone = "LeftWing",
                Axis = "Flap",
                Base = 0,
                Amp = 35,
                Speed = 3,
                Side = 1
            },
            {
                Bone = "RightWing",
                Axis = "Flap",
                Base = 0,
                Amp = 35,
                Speed = 3,
                Side = -1
            },
            {
                Bone = "Head",
                Axis = "Twist",
                Base = 0,
                Amp = 25,
                Speed = 1.6
            }
        }
    },
    CloseAt = 8.4,
    CloseTime = 0.9,
    TitleAt = 7.8,
    TitleHold = 2.4,
    CameraEnd = 9.6,
    Return = 1.2,
    Stencil = {
        Name = "Crack",
        Size = 320,
        StartShare = 0.08,
        Yaw = 90
    },
    Shots = {
        Fall = {
            Angle = 80,
            Distance = 1.3,
            Up = 0.3
        },
        Crack = {
            Angle = 150,
            Distance = 1,
            Up = 1.05,
            PushIn = 0.15
        },
        Drop = {
            Angle = 70,
            Distance = 0.75,
            Up = 0.28
        }
    },
    ScreamText = "NOOOO!!",
    Title = "HAS BEEN DEFEATED!",
    Music = {
        Folder = "rransCustomSFX",
        Name = "DefeatMusic"
    },
    Scream = {
        Folder = "rransCustomSFX",
        Name = "BossRoar",
        Range = 2000,
        MinRange = 600
    },
    Thud = {
        Name = "Slam",
        Range = 1400,
        MinRange = 400,
        PlaybackSpeed = 0.8,
        Volume = 0.8
    },
    Rumble = {
        Name = "Stomp",
        Range = 1400,
        MinRange = 400,
        PlaybackSpeed = 0.35,
        Volume = 0.6
    },
    RumbleEvery = 0.45,
    Open = {
        Folder = "rransCustomSFX",
        Name = "GroundOpen",
        Range = 2000,
        MinRange = 600,
        Volume = 2.5
    }
}

local Defeat = v1.Defeat

v1.Fight.EndHellAfterDefeat = Defeat.BreakTime + Defeat.CameraEnd + Defeat.Return + 1.2
v1.Clips.Defeated = {
    Looped = false,
    Length = Defeat.DropAt + Defeat.DropTime + 1,
    Keyframes = {
        {
            Time = 0,
            Pose = "StunnedA"
        },
        {
            Pose = "Stagger",
            Style = "Quad",
            Direction = "Out",
            Time = Defeat.StaggerTime
        },
        {
            Pose = "Fallen",
            Style = "Quad",
            Direction = "In",
            Time = Defeat.StaggerTime + Defeat.FallTime
        },
        {
            Pose = "Fallen",
            Style = "Linear",
            Time = Defeat.DropAt
        },
        {
            Pose = "Reach",
            Style = "Back",
            Direction = "Out",
            Time = Defeat.DropAt + 0.3
        },
        {
            Pose = "Reach",
            Style = "Linear",
            Time = Defeat.DropAt + Defeat.DropTime + 1
        }
    }
}
v1.RoarHitTime = 0.65

local Cast = v1.Attacks.Minions.Cast
local v63 = v1.Attacks.Minions.Cast + v1.Attacks.Minions.Recover
local v64 = Cast * 0.5
local v65 = Cast + 0.35

v1.CodeMoves = {
    Summon = {
        Attack = "Minions",
        BlendIn = 0.15,
        BlendOut = 0.25,
        Length = v63,
        Moves = {
            {
                Bone = "Torso",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { v64, 15 },
                    { Cast, -15 },
                    { v65, -15 },
                    { v63, 0 }
                }
            },
            {
                Bone = "Head",
                Axis = "Swing",
                Amp = 4,
                Speed = 7,
                Keys = {
                    { 0, 0 },
                    { v64, 18 },
                    { Cast, -35 },
                    { v65, -30 },
                    { v63, 0 }
                },
                AmpFrom = Cast,
                AmpTo = v65
            },
            {
                Bone = "LeftUpperArm",
                Axis = "Swing",
                Amp = 6,
                Speed = 9,
                Keys = {
                    { 0, 0 },
                    { v64, -30 },
                    { Cast, 160 },
                    { v65, 155 },
                    { v63, 0 }
                },
                AmpFrom = Cast,
                AmpTo = v65
            },
            {
                Bone = "RightUpperArm",
                Axis = "Swing",
                Amp = 6,
                Speed = 9,
                Phase = 0.5,
                Keys = {
                    { 0, 0 },
                    { v64, -30 },
                    { Cast, 160 },
                    { v65, 155 },
                    { v63, 0 }
                },
                AmpFrom = Cast,
                AmpTo = v65
            },
            {
                Bone = "LeftUpperArm",
                Axis = "Flap",
                Side = 1,
                Keys = {
                    { 0, 0 },
                    { v64, 25 },
                    { Cast, 30 },
                    { v65, 30 },
                    { v63, 0 }
                }
            },
            {
                Bone = "RightUpperArm",
                Axis = "Flap",
                Side = -1,
                Keys = {
                    { 0, 0 },
                    { v64, 25 },
                    { Cast, 30 },
                    { v65, 30 },
                    { v63, 0 }
                }
            },
            {
                Bone = "LeftLowerArm",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { v64, 70 },
                    { Cast, 5 },
                    { v65, 10 },
                    { v63, 0 }
                }
            },
            {
                Bone = "RightLowerArm",
                Axis = "Swing",
                Keys = {
                    { 0, 0 },
                    { v64, 70 },
                    { Cast, 5 },
                    { v65, 10 },
                    { v63, 0 }
                }
            },
            {
                Bone = "LeftWing",
                Axis = "Flap",
                Side = 1,
                Amp = 12,
                Speed = 4,
                Keys = {
                    { 0, 0 },
                    { v64, -20 },
                    { Cast, 50 },
                    { v65, 45 },
                    { v63, 0 }
                },
                AmpFrom = Cast,
                AmpTo = v65
            },
            {
                Bone = "RightWing",
                Axis = "Flap",
                Side = -1,
                Amp = 12,
                Speed = 4,
                Keys = {
                    { 0, 0 },
                    { v64, -20 },
                    { Cast, 50 },
                    { v65, 45 },
                    { v63, 0 }
                },
                AmpFrom = Cast,
                AmpTo = v65
            }
        }
    }
}
v1.Rig = {
    Root = "RootPart",
    Folder = "Animations",
    FxScale = 12,
    ActionSpeed = 1.3,
    Fade = 0.2,
    Bones = {
        Head = "Head",
        LeftHand = "LeftHand",
        RightHand = "RighttHand",
        Weapon = "Weapon",
        LeftFoot = "LeftFoot",
        RightFoot = "RightFoot"
    },
    Tracks = {
        Idle = {
            Name = "Idle",
            Length = 2.5
        },
        Walk = {
            Name = "Walk",
            Length = 1.25
        },
        Stomp = {
            Name = "Stomp",
            Length = 2.5,
            Impact = 1.58
        },
        Attack = {
            Name = "Attack",
            Length = 4.166666666666667,
            Strike = 1.52
        },
        FlyUp = {
            Name = "Flying Up",
            Length = 1.25
        },
        FlyIdle = {
            Name = "Flying Idle",
            Length = 1.25
        },
        FlyDown = {
            Name = "Flying Down",
            Length = 1.25
        }
    }
}

local Tracks = v1.Rig.Tracks
local ActionSpeed = v1.Rig.ActionSpeed
local Attacks = v1.Attacks

local function synced(v66, v67, v68) -- line 1688 | captures: ActionSpeed
    return {
        Track = v66,
        Mark = v67,
        At = v68,
        Speed = ActionSpeed
    }
end

local v69 = {}
local Count_2 = Attacks.TripleStomp.Count
for v70 = 1, Count_2 do
    local v71 = {
        Track = "Stomp",
        Mark = Tracks.Stomp.Impact,
        At = v1.TripleStompImpactTime(v70),
        Speed = ActionSpeed
    }
    table.insert(v69, v71)
end
local Slam_3 = Attacks.Slam
local v72 = Slam_3.Crouch + Slam_3.Rise
local v73 = v72 + Slam_3.Aim
local v74 = Slam_3.Fall + 0.45

v1.Moves = {
    Stomp = {
        {
            Track = "Stomp",
            Mark = Tracks.Stomp.Impact,
            At = Attacks.Stomp.Windup,
            Speed = ActionSpeed
        }
    },
    TripleStomp = v69,
    Spikes = {
        {
            Track = "Attack",
            Mark = 0,
            At = 0,
            Speed = 1
        }
    },
    Meteor = {
        {
            Track = "Attack",
            Mark = Tracks.Attack.Strike,
            At = Attacks.Meteor.Cast + 0.1,
            Speed = ActionSpeed
        }
    },
    Slam = {
        {
            Track = "FlyUp",
            Mark = 0,
            At = 0,
            Speed = Tracks.FlyUp.Length / v72
        },
        {
            Track = "FlyIdle",
            Mark = 0,
            Speed = 1,
            Looped = true,
            At = v72,
            Until = v73,
            From = v72 - v1.Rig.Fade
        },
        {
            Track = "FlyDown",
            Mark = 0,
            At = v73,
            Speed = Tracks.FlyDown.Length / v74
        }
    },
    Roar = {
        {
            Track = "Stomp",
            Mark = Tracks.Stomp.Impact,
            At = v1.RoarHitTime,
            Speed = ActionSpeed
        }
    }
}
v1.ShieldArrow = {
    StartPart = "ArrowDirect_1",
    EndPart = "ArrowDirect_2",
    Essence = true,
    Asset = { "Assets", "RedArrow" }
}

local v75 = { BumpScale = 1.15 }

if v1.Shields.Breakable then
    v75.List = {
        {
            Id = "Shields",
            Text = "Destroy the shields: %d/%d"
        },
        {
            Id = "Boss",
            Text = "Now destroy the Demon King!",
            ShowFor = 5
        }
    }
else
    v75.List = {
        {
            Id = "Essence",
            Text = "Collect Essence",
            NoPop = true
        },
        {
            Id = "Boss",
            Text = "Defeat the Demon King!",
            ShowFor = 5
        }
    }
end
v1.Tasks = v75
return v1
