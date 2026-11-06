-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    Portal = {
        Surface = "Shadow",
        ColorTime = 1.8,
        LightTime = 1.2,
        BurstCount = 25,
        ExitDrop = 30,
        Path = { "Build", "Vfx", "Portal" },
        LitColors = {
            Color3.fromRGB(140, 15, 0),
            Color3.fromRGB(255, 110, 10),
            Color3.fromRGB(255, 185, 45)
        }
    },
    Strike = {
        Bolts = 3,
        Spacing = 0.07,
        Height = 520,
        SkySpread = 80,
        BlastScale = 3.2,
        GroundSmokeScale = 2.2,
        CrackleArcs = 3,
        CrackleRadius = 22
    },
    Pylons = {
        Orb = "Icosphere",
        ChainAttachment = "BossAttachment"
    },
    Timeline = {
        StrikesAt = 2,
        StrikeEvery = 1.34,
        StrikeDelay = 0.45,
        ChainAt = 7.35,
        RingEvery = 0.35,
        ConvergeAt = 10.6,
        FireAt = 12,
        IgniteAt = 12.3,
        EmergeAt = 14.6,
        TrackAt = 15.4,
        LandAt = 17.4,
        HeroAt = 18
    },
    Camera = {
        Smoothing = 6,
        Fov = 70,
        Dark = {
            Back = 300,
            Up = 150,
            PushIn = 60
        },
        Pylon = {
            Distance = 70,
            Up = -12,
            LookUp = 4,
            Orbit = 10
        },
        Chain = {
            Up = 460,
            Back = 280,
            Orbit = 20,
            Fov = 80
        },
        Converge = {
            Back = 170,
            Up = 25,
            Side = 45
        },
        Gate = {
            Distance = 300,
            Up = -10,
            PushIn = 70
        },
        Track = {
            Side = 150,
            Up = 30,
            Behind = 70
        }
    },
    Ball = {
        Up = 120,
        StartRadius = 3,
        Radius = 20,
        Arcs = 7,
        Color = Color3.fromRGB(255, 200, 70)
    },
    Flight = {
        ArcHeight = 70,
        FadeIn = 0.25,
        TurnShare = 0.75
    },
    Bolts = {
        Sky = {
            Width = 3.2,
            GlowWidth = 9,
            OuterWidth = 22,
            GlowTransparency = 0.4,
            OuterTransparency = 0.8,
            Depth = 5,
            Jag = 0.1,
            Branches = 6,
            BranchLength = 0.32,
            Leader = 0.08,
            Life = 0.85,
            FadeTime = 0.35
        },
        Crackle = {
            Width = 0.7,
            GlowWidth = 2.6,
            OuterWidth = 7,
            GlowTransparency = 0.35,
            Depth = 3,
            Jag = 0.25,
            Branches = 1,
            Interval = 0.05
        },
        Chain = {
            Width = 1,
            GlowWidth = 3.5,
            OuterWidth = 9,
            Depth = 5,
            Jag = 0.08,
            Branches = 2,
            BranchLength = 0.15
        },
        Feed = {
            Width = 1.2,
            GlowWidth = 4,
            OuterWidth = 10,
            Depth = 5,
            Jag = 0.09,
            Branches = 2
        },
        Knot = {
            Width = 0.6,
            GlowWidth = 2.2,
            OuterWidth = 6,
            Depth = 3,
            Jag = 0.3,
            Branches = 1,
            Interval = 0.04
        },
        Blast = {
            Width = 4,
            GlowWidth = 12,
            OuterWidth = 30,
            Depth = 6,
            Jag = 0.06,
            Branches = 5,
            BranchLength = 0.2,
            Leader = 0.1,
            Life = 0.9
        },
        Gate = {
            Width = 0.7,
            GlowWidth = 2.5,
            Depth = 4,
            Jag = 0.2,
            Branches = 1,
            Leader = 0.03,
            Life = 0.35
        },
        Lock = {
            Width = 0.9,
            GlowWidth = 3,
            Depth = 5,
            Jag = 0.1,
            Branches = 1,
            Leader = 0.05,
            Life = 0.5
        }
    },
    Grade = {
        Dark = {
            Brightness = -0.12,
            Contrast = 0.15,
            Saturation = -0.25
        },
        Strike = {
            Brightness = 0.45,
            Time = 0.3,
            Tint = Color3.fromRGB(255, 240, 210)
        },
        Ignite = {
            Brightness = 0.7,
            Time = 0.6,
            Tint = Color3.fromRGB(255, 190, 120)
        },
        Land = {
            Brightness = 0.3,
            Time = 0.35,
            Tint = Color3.fromRGB(255, 200, 160)
        }
    },
    Shake = {
        Strike = 4,
        Fire = 6,
        Ignite = 9,
        Land = 10
    },
    Sfx = {
        Rumble = {
            Folder = "BossSfx",
            Name = "ThunderRumble",
            Volume = 0.6
        },
        Strike = {
            Folder = "BossSfx",
            Name = "ThunderStrike",
            Volume = 0.8
        },
        Arc = {
            Folder = "BossSfx",
            Name = "ElectricArc",
            Volume = 0.3
        },
        Charge = {
            Folder = "BossSfx",
            Name = "ElectricCharge",
            Volume = 0.45
        },
        Riser = {
            Folder = "BossSfx",
            Name = "SummonRiser",
            Volume = 0.8,
            StartAt = "StrikesAt",
            PeakAt = "FireAt"
        },
        Vortex = {
            Folder = "BossSfx",
            Name = "SummonVortex",
            Volume = 0.55,
            StartAt = "ChainAt",
            StopAt = "IgniteAt",
            FadeOut = 0.8
        },
        Fire = {
            Folder = "BossSfx",
            Name = "ThunderStrike",
            Volume = 1,
            PlaybackSpeed = 0.75
        },
        Portal = {
            Folder = "BossSfx",
            Name = "PortalOpen",
            Volume = 0.9
        },
        Whoosh = {
            Folder = "rransCustomSFX",
            Name = "Titanic Spawn Whoosh",
            Volume = 0.7
        },
        Land = {
            Folder = "BossSfx",
            Name = "Slam",
            Volume = 0.9,
            PlaybackSpeed = 0.8
        }
    }
}
