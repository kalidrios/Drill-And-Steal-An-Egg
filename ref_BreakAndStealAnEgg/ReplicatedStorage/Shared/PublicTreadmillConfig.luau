-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    SlotAttribute = "PublicTreadmillSlot",
    MultiplierAttribute = "OwnMultiplier",
    AdminSpawn = {
        Model = "Admin Treadmill",
        LandAtAttribute = "LandAt",
        DropTime = 1.6,
        DropHeight = 260,
        LandBlastName = "Explosion",
        LandBlastScale = 5,
        FlameRingCount = 10,
        FlameRingScale = 2.2,
        SmokeName = "SmokeVFX",
        SmokeScale = 4,
        ShakeRadius = 400,
        ShakeMagnitude = 7,
        SlamSound = "Slam",
        SlamRange = 4000,
        FallSound = "TreadmillFall",
        FallSoundFadeOut = 0.15,
        MinMultiplier = 1,
        MaxMultiplier = 100,
        MinSeconds = 10,
        MaxSeconds = 3600,
        Scopes = {
            Server = true,
            Global = true
        },
        DefaultScope = "Server",
        Topic = "AdminTreadmillSpawn",
        StateMap = "AdminTreadmill",
        StateKey = "Live",
        CatchUpJitter = 10,
        CatchUpTries = 3,
        SignName = "TreadmillOverhead",
        SignLabelName = "SpeedMultiplier",
        SignFormat = "x%g SPEED",
        Announcement = "spawned the <font color=\"#72FF72\">Admin Treadmill</font>! x%g speed!",
        WarnAt = { 600, 30, 10 },
        WarnText = "Admin Treadmill disappears in {%s}!",
        WarnShowTime = 6,
        Cutscene = {
            Enabled = true,
            Hold = 1.6,
            Return = 0.9,
            LateJoinGrace = 0.8,
            SafetyGrace = 1,
            SkipWhileCarrying = true,
            WallPadding = 2,
            Smoothing = 7,
            ShakeScale = 1,
            BarsGui = "Cinematic UI",
            BarsTime = 0.45,
            Zoom = 1,
            LookHeight = 0.4,
            HideInCutscene = {},
            Shots = {
                ApproachFrom = {
                    Right = 1.45,
                    Front = 0.55,
                    Up = 0.08
                },
                ApproachTo = {
                    Right = 1.1,
                    Front = 0.4,
                    Up = 0.28
                }
            }
        },
        BannerAfterCutscene = 5
    },
    PaceMult = 1.5,
    PopupsPerStep = 1,
    Treadmills = {
        {
            Model = "Admin Treadmill",
            Belt = "Treadmill part",
            Hitbox = "Hitbox",
            OwnMultiplier = 4,
            Facing = Vector3.new(0, 0, 1),
            Slots = {
                Vector3.new(-3, 0, 10),
                Vector3.new(3, 0, 6.699999809265137),
                Vector3.new(-3, 0, 3.299999952316284),
                Vector3.new(3, 0, 0),
                Vector3.new(-3, 0, -3.299999952316284),
                Vector3.new(3, 0, -6.699999809265137),
                (Vector3.new(-3, 0, -10))
            }
        }
    }
}
