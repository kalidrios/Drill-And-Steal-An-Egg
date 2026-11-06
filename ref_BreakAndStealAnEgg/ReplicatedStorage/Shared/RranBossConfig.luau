-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    Bosses = {
        rran = "realrranBoss",
        monk = "monkisrokBoss"
    },
    BossUsers = {
        rran = {
            UserId = 9679848455,
            Name = "realrran",
            DisplayName = "rran"
        },
        monk = {
            UserId = 1247492319,
            Name = "monkisrok",
            DisplayName = "Monk"
        }
    },
    StartAnnouncement = "started a <font color=\"#72FF72\">Boss Event</font>! Lucky eggs are raining from their bazookas!",
    Scopes = {
        Server = true,
        Global = true
    },
    DefaultScope = "Global",
    Topic = "BossEvent",
    StateMap = "BossEvent",
    CatchUpMinSeconds = 60,
    LeaveAnnouncements = {
        LeavingSoon = "is flying off soon!",
        Left = "flew off... for now \240\159\145\128"
    },
    Tag = "EggBoss",
    LauncherName = "Studlauncher",
    MuzzlePartName = "LaunchFromHere",
    Cutscene = {
        Enabled = true,
        Hold = 1,
        Return = 0.9,
        ApproachShare = 0.6,
        Cooldown = 30,
        LateJoinGrace = 2.2,
        SafetyGrace = 1,
        SkipWhileCarrying = true,
        WallPadding = 2,
        Smoothing = 8,
        BarsGui = "Cinematic UI",
        BarsTime = 0.45,
        Zoom = 1.35,
        HideInCutscene = { { "Build", "ZoneBuilds", "Zone1", "Decor", "Trees", "ThisTree" } },
        Shots = {
            ApproachFrom = {
                Right = 2.4,
                Back = 0.6,
                Up = 0.2
            },
            ApproachTo = {
                Right = 1.9,
                Back = 0.3,
                Up = 0.3
            }
        }
    },
    Outline = {
        Transparency = 0.15,
        Color = Color3.fromRGB(255, 40, 40)
    }
}
local v2 = {
    SizeWords = {
        {
            Min = 4,
            Word = "MASSIVE"
        },
        {
            Min = 3,
            Word = "HUGE"
        }
    },
    ZoneNames = {
        Zone1 = "Forest Zone",
        Zone2 = "Desert Zone",
        Zone3 = "Snowy Zone",
        Zone4 = "Candy Zone",
        Zone5 = "Swamp Zone",
        Zone6 = "Ocean Zone",
        Zone7 = "Hell Zone",
        Zone8 = "Blossom Zone",
        Zone9 = "Galaxy Zone",
        Zone10 = "Planet X Zone"
    },
    ZoneColors = {
        Zone1 = Color3.fromRGB(110, 225, 95),
        Zone2 = Color3.fromRGB(245, 190, 80),
        Zone3 = Color3.fromRGB(150, 210, 255),
        Zone4 = Color3.fromRGB(255, 120, 200),
        Zone5 = Color3.fromRGB(160, 200, 70),
        Zone6 = Color3.fromRGB(80, 170, 255),
        Zone7 = Color3.fromRGB(255, 90, 40),
        Zone8 = Color3.fromRGB(255, 140, 190),
        Zone9 = Color3.fromRGB(175, 125, 255),
        Zone10 = Color3.fromRGB(150, 200, 255)
    }
}

v1.WalkAnimation = "rbxassetid://102347517866278"
v1.WalkAnimationSpeed = 3.15
v1.IdleAnimation = "rbxassetid://76900428083793"
v1.ShootAnimation = "rbxassetid://136283282799828"
v1.ShootAnimationLength = 1.35
v1.ShootFireTime = 0.7
v1.UpperBody = {
    Waist = true,
    Neck = true,
    RightShoulder = true,
    RightElbow = true,
    RightWrist = true,
    LeftShoulder = true,
    LeftElbow = true,
    LeftWrist = true
}
v1.ShotStance = {
    Root = { 2.003, -12.576, 6.454 },
    Waist = { 4.023, -1.509, -3.065 },
    Neck = { 17.793, -3.668, -18.044 },
    LeftHip = { 30.928, 9.658, -18.722 },
    LeftKnee = { -67.452, -0.037, -9.479 },
    LeftAnkle = { 37.659, 0.684, 12.407 },
    RightHip = { -5.602, -8.04, 13.624 },
    RightKnee = { -51.049, -6.828, -11.217 },
    RightAnkle = { 38.43, -22.955, -20.389 }
}
v1.ShotStillJoints = {}
for v3 in v1.ShotStance do
    v1.ShotStillJoints[v3] = true
end
v1.ShotBlendIn = 0.2
v1.ShotStillRelease = 0.3
v1.AnimalEggs = {
    FlightTag = "LaunchedEgg",
    RegularEggsPerLanding = 1,
    RegularStockFloor = 0.4,
    HeightMult = 0.7,
    MinHeight = 3.8,
    Clearance = 2,
    EdgeMargin = 0.15,
    Despawn = {
        Enabled = true,
        KeepRank = 5,
        MinAge = 150,
        LonelyTime = 75,
        NearRadius = 90,
        KeepPerZone = 3,
        ZoneGap = 30,
        CheckEvery = 2
    }
}
v1.Sfx = {
    Folder = "BossSfx",
    StompGap = 0.25,
    StompMergeRadius = 250,
    Shot = {
        Name = "Shot",
        Range = 4000,
        MinRange = 400,
        RollOff = "Linear",
        Volume = 0.45
    },
    Slam = {
        Name = "Slam",
        Range = 4000,
        MinRange = 600,
        RollOff = "Linear",
        Volume = 0.4
    },
    Stomp = {
        Name = "Stomp",
        Range = 900,
        MinRange = 150,
        RollOff = "Linear",
        PlaybackSpeed = 0.55,
        Volume = 0.55
    },
    EggWhoosh = {
        Name = "EggWhoosh",
        Range = 350,
        Volume = 0.55
    },
    FlyBy = {
        Name = "FlyBy",
        Range = 4000,
        MinRange = 500,
        RollOff = "Linear",
        Volume = 0.6
    },
    FlyLoop = {
        Name = "FlyLoop",
        Range = 4000,
        MinRange = 500,
        Volume = 0.55
    },
    EggLand = {
        Name = "EggLand",
        Range = 450,
        Volume = 0.6
    }
}

local v4 = {
    RightShoulder = { 70, 0, -10 },
    RightElbow = { 70, 0, 0 },
    RightWrist = { -120, 0, 0 },
    LeftShoulder = { 90, 0, 25 },
    LeftElbow = { 30, 0, 0 },
    Waist = { 2, -15, 0 },
    Neck = { 6, 15, 0 },
    RightHip = { 10, 0, 5 },
    RightKnee = { -18, 0, 0 },
    RightAnkle = { 8, 0, 0 },
    LeftHip = { 6, 0, -5 },
    LeftKnee = { -10, 0, 0 },
    LeftAnkle = { 4, 0, 0 }
}
local v5 = { 0, 0, 0 }

v5.Pos = Vector3.new(0, -0.07999999821186066, 0)
v4.Root = v5

local v6 = {
    RightShoulder = { 95, 0, -10 },
    RightElbow = { 60, 0, 0 },
    RightWrist = { -120, 0, 0 },
    LeftShoulder = { 110, 0, 25 },
    LeftElbow = { 25, 0, 0 },
    Waist = { 14, -15, 0 },
    Neck = { 14, 15, 0 },
    RightHip = { 4, 0, 5 },
    RightKnee = { -24, 0, 0 },
    RightAnkle = { 14, 0, 0 },
    LeftHip = { 0, 0, -5 },
    LeftKnee = { -16, 0, 0 },
    LeftAnkle = { 10, 0, 0 }
}
local v7 = { 0, 0, 0 }

v7.Pos = Vector3.new(0, -0.10000000149011612, 0.15000000596046448)
v6.Root = v7

local v8 = {
    RightShoulder = { 80, 0, -10 },
    RightElbow = { 65, 0, 0 },
    RightWrist = { -100, 0, 0 },
    LeftShoulder = { 115, 0, 25 },
    LeftElbow = { 20, 0, 0 },
    Waist = { 10, -15, 0 },
    Neck = { 18, 15, 0 },
    RightHip = { 14, 0, 5 },
    RightKnee = { -24, 0, 0 },
    RightAnkle = { 10, 0, 0 },
    LeftHip = { 6, 0, -5 },
    LeftKnee = { -10, 0, 0 },
    LeftAnkle = { 4, 0, 0 }
}
local v9 = { 0, 0, 0 }

v9.Pos = Vector3.new(0, -0.10000000149011612, 0)
v8.Root = v9

local v10 = {
    RightShoulder = { 105, 0, -10 },
    RightElbow = { 55, 0, 0 },
    RightWrist = { -100, 0, 0 },
    LeftShoulder = { 135, 0, 25 },
    LeftElbow = { 15, 0, 0 },
    Waist = { 22, -15, 0 },
    Neck = { 25, 15, 0 },
    RightHip = { 6, 0, 5 },
    RightKnee = { -30, 0, 0 },
    RightAnkle = { 16, 0, 0 },
    LeftHip = { 0, 0, -5 },
    LeftKnee = { -18, 0, 0 },
    LeftAnkle = { 12, 0, 0 }
}
local v11 = { 0, 0, 0 }

v11.Pos = Vector3.new(0, -0.14000000059604645, 0.2199999988079071)
v10.Root = v11

local v12 = {
    RightHip = { 28, 0, 0 },
    RightKnee = { -6, 0, 0 },
    RightAnkle = { -6, 0, 0 },
    LeftHip = { -22, 0, 0 },
    LeftKnee = { -28, 0, 0 },
    LeftAnkle = { 14, 0, 0 },
    LeftShoulder = { 24, 0, 0 },
    LeftElbow = { 18, 0, 0 },
    RightShoulder = { -6, 0, 0 },
    Waist = { -3, 6, 0 },
    Neck = { 0, -6, 0 }
}
local v13 = { 0, 0, 0 }

v13.Pos = Vector3.new(0, -0.07000000029802322, 0)
v12.Root = v13

local v14 = {
    RightHip = { 0, 0, 0 },
    RightKnee = { -4, 0, 0 },
    LeftHip = { 10, 0, 0 },
    LeftKnee = { -48, 0, 0 },
    LeftAnkle = { 12, 0, 0 },
    LeftShoulder = { 2, 0, 0 },
    LeftElbow = { 12, 0, 0 },
    RightShoulder = { 0, 0, 0 },
    Waist = { -3, 0, 0 }
}
local v15 = { 0, 0, 0 }

v15.Pos = Vector3.new(0, 0.05000000074505806, 0)
v14.Root = v15

local v16 = {
    LeftHip = { 28, 0, 0 },
    LeftKnee = { -6, 0, 0 },
    LeftAnkle = { -6, 0, 0 },
    RightHip = { -22, 0, 0 },
    RightKnee = { -28, 0, 0 },
    RightAnkle = { 14, 0, 0 },
    LeftShoulder = { -18, 0, 0 },
    LeftElbow = { 10, 0, 0 },
    RightShoulder = { 6, 0, 0 },
    Waist = { -3, -6, 0 },
    Neck = { 0, 6, 0 }
}
local v17 = { 0, 0, 0 }

v17.Pos = Vector3.new(0, -0.07000000029802322, 0)
v16.Root = v17

local v18 = {
    LeftHip = { 0, 0, 0 },
    LeftKnee = { -4, 0, 0 },
    RightHip = { 10, 0, 0 },
    RightKnee = { -48, 0, 0 },
    RightAnkle = { 12, 0, 0 },
    LeftShoulder = { 2, 0, 0 },
    LeftElbow = { 12, 0, 0 },
    RightShoulder = { 0, 0, 0 },
    Waist = { -3, 0, 0 }
}
local v19 = { 0, 0, 0 }

v19.Pos = Vector3.new(0, 0.05000000074505806, 0)
v18.Root = v19

local v20 = {
    Waist = { 3, 0, 0 },
    Neck = { -2, 0, 0 },
    LeftShoulder = { 3, 0, -3 },
    RightShoulder = { 2, 0, 3 }
}
local v21 = { 0, 0, 0 }

v21.Pos = Vector3.new(0, -0.029999999329447746, 0)
v20.Root = v21

local v22 = {
    RightShoulder = { -12, 0, 14 },
    LeftShoulder = { -12, 0, -14 },
    RightElbow = { 5, 0, 0 },
    LeftElbow = { 5, 0, 0 },
    RightHip = { -6, 0, 3 },
    LeftHip = { -6, 0, -3 },
    RightKnee = { -6, 0, 0 },
    LeftKnee = { -10, 0, 0 },
    RightAnkle = { -35, 0, 0 },
    LeftAnkle = { -35, 0, 0 },
    Waist = { 6, 0, 0 },
    Neck = { 38, 0, 0 }
}
local v23 = {
    RightShoulder = { 12, 0, 32 },
    LeftShoulder = { 12, 0, -32 },
    RightElbow = { 18, 0, 0 },
    LeftElbow = { 18, 0, 0 },
    RightHip = { 12, 0, 4 },
    LeftHip = { 20, 0, -4 },
    RightKnee = { -22, 0, 0 },
    LeftKnee = { -35, 0, 0 },
    RightAnkle = { -15, 0, 0 },
    LeftAnkle = { -15, 0, 0 },
    Waist = { -6, 0, 0 },
    Neck = { 4, 0, 0 }
}
local v24 = {
    RightShoulder = { 150, 0, 20 },
    LeftShoulder = { 150, 0, -20 },
    LeftElbow = { 20, 0, 0 },
    RightHip = { 35, 0, 6 },
    RightKnee = { -60, 0, 0 },
    LeftHip = { 12, 0, -6 },
    LeftKnee = { -30, 0, 0 },
    Waist = { -8, 0, 0 },
    Neck = { -10, 0, 0 }
}
local v25 = {
    RightHip = { 45, 0, 8 },
    RightKnee = { -90, 0, 0 },
    RightAnkle = { 45, 0, 0 },
    LeftHip = { 45, 0, -8 },
    LeftKnee = { -90, 0, 0 },
    LeftAnkle = { 45, 0, 0 },
    Waist = { -18, 0, 0 },
    Neck = { 18, 0, 0 },
    LeftShoulder = { 55, 0, -15 },
    LeftElbow = { 10, 0, 0 },
    RightShoulder = { 25, 0, 20 }
}
local v26 = { 0, 0, 0 }

v26.Pos = Vector3.new(0, -0.5, 0)
v25.Root = v26

local v27 = {
    RightShoulder = { 160, 0, 10 },
    LeftShoulder = { 160, 0, -10 },
    RightHip = { -6, 0, 0 },
    LeftHip = { -6, 0, 0 },
    RightAnkle = { -30, 0, 0 },
    LeftAnkle = { -30, 0, 0 },
    Waist = { 6, 0, 0 },
    Neck = { 10, 0, 0 }
}
for v28 in v1.ShotStillJoints do
    v6[v28] = v4[v28]
    v10[v28] = v8[v28]
end
v1.Poses = {
    Rest = {},
    Aim = v4,
    Fire = v6,
    SkyAim = v8,
    SkyFire = v10,
    WalkR = v12,
    WalkPassR = v14,
    WalkL = v16,
    WalkPassL = v18,
    Breathe = v20,
    Fall = v24,
    Land = v25,
    Launch = v27,
    Fly = v22,
    Hover = v23
}

local ShootAnimationLength = v1.ShootAnimationLength
local ShootFireTime = v1.ShootFireTime
local v29 = ShootAnimationLength - ShootFireTime
local v30 = ShootFireTime + v29
local v31 = ShootFireTime + v29 * 2

v1.Clips = {
    BazookaFire = {
        Looped = false,
        Length = ShootAnimationLength,
        Shots = { ShootFireTime },
        Animation = v1.ShootAnimation,
        Keyframes = {
            {
                Time = 0,
                Pose = "Rest"
            },
            {
                Pose = "Aim",
                Style = "Quad",
                Direction = "Out",
                Time = ShootFireTime * 0.6
            },
            {
                Pose = "Aim",
                Style = "Linear",
                Time = ShootFireTime
            },
            {
                Pose = "Fire",
                Style = "Quad",
                Direction = "Out",
                Time = ShootFireTime + 0.06
            },
            {
                Pose = "Aim",
                Style = "Back",
                Direction = "Out",
                Time = ShootFireTime + 0.35
            },
            {
                Pose = "Rest",
                Style = "Quad",
                Direction = "InOut",
                Time = ShootAnimationLength
            }
        }
    },
    SkyShot = {
        Looped = false,
        Length = ShootAnimationLength,
        Shots = { ShootFireTime },
        Animation = v1.ShootAnimation,
        Keyframes = {
            {
                Time = 0,
                Pose = "Rest"
            },
            {
                Pose = "SkyAim",
                Style = "Quad",
                Direction = "Out",
                Time = ShootFireTime * 0.6
            },
            {
                Pose = "SkyAim",
                Style = "Linear",
                Time = ShootFireTime
            },
            {
                Pose = "SkyFire",
                Style = "Quad",
                Direction = "Out",
                Time = ShootFireTime + 0.06
            },
            {
                Pose = "SkyAim",
                Style = "Back",
                Direction = "Out",
                Time = ShootFireTime + 0.35
            },
            {
                Pose = "Rest",
                Style = "Quad",
                Direction = "InOut",
                Time = ShootAnimationLength
            }
        }
    },
    TripleShot = {
        Looped = false,
        Length = ShootFireTime + v29 * 3,
        Shots = { ShootFireTime, v30, v31 },
        Animation = v1.ShootAnimation,
        RewindTo = ShootFireTime,
        Keyframes = {
            {
                Time = 0,
                Pose = "Rest"
            },
            {
                Pose = "Aim",
                Style = "Quad",
                Direction = "Out",
                Time = ShootFireTime * 0.6
            },
            {
                Pose = "Aim",
                Style = "Linear",
                Time = ShootFireTime
            },
            {
                Pose = "Fire",
                Style = "Quad",
                Direction = "Out",
                Time = ShootFireTime + 0.06
            },
            {
                Pose = "Aim",
                Style = "Quad",
                Direction = "Out",
                Time = v30
            },
            {
                Pose = "Fire",
                Style = "Quad",
                Direction = "Out",
                Time = v30 + 0.06
            },
            {
                Pose = "Aim",
                Style = "Quad",
                Direction = "Out",
                Time = v31
            },
            {
                Pose = "Fire",
                Style = "Quad",
                Direction = "Out",
                Time = v31 + 0.06
            },
            {
                Pose = "Aim",
                Style = "Back",
                Direction = "Out",
                Time = v31 + 0.35
            },
            {
                Pose = "Rest",
                Style = "Quad",
                Direction = "InOut",
                Time = ShootFireTime + v29 * 3
            }
        }
    },
    Walk = {
        Length = 0.85,
        Looped = true,
        Keyframes = {
            {
                Time = 0,
                Pose = "WalkR"
            },
            {
                Time = 0.2125,
                Pose = "WalkPassR",
                Style = "Sine",
                Direction = "InOut"
            },
            {
                Time = 0.425,
                Pose = "WalkL",
                Style = "Sine",
                Direction = "InOut"
            },
            {
                Time = 0.6375,
                Pose = "WalkPassL",
                Style = "Sine",
                Direction = "InOut"
            },
            {
                Time = 0.85,
                Pose = "WalkR",
                Style = "Sine",
                Direction = "InOut"
            }
        }
    },
    Idle = {
        Length = 2.6,
        Looped = true,
        Keyframes = {
            {
                Time = 0,
                Pose = "Rest"
            },
            {
                Time = 1.3,
                Pose = "Breathe",
                Style = "Sine",
                Direction = "InOut"
            },
            {
                Time = 2.6,
                Pose = "Rest",
                Style = "Sine",
                Direction = "InOut"
            }
        }
    },
    Drop = {
        Length = 3.9,
        Looped = false,
        Keyframes = {
            {
                Time = 0,
                Pose = "Fly"
            },
            {
                Time = 1.68,
                Pose = "Fly",
                Style = "Linear"
            },
            {
                Time = 2.38,
                Pose = "Hover",
                Style = "Quad",
                Direction = "InOut"
            },
            {
                Time = 2.8,
                Pose = "Land",
                Style = "Quad",
                Direction = "In"
            },
            {
                Time = 3.25,
                Pose = "Land",
                Style = "Linear"
            },
            {
                Time = 3.9,
                Pose = "Rest",
                Style = "Back",
                Direction = "Out"
            }
        }
    },
    Leave = {
        Length = 4.65,
        Looped = false,
        Keyframes = {
            {
                Time = 0,
                Pose = "Rest"
            },
            {
                Time = 0.45,
                Pose = "Land",
                Style = "Quad",
                Direction = "Out"
            },
            {
                Time = 0.6,
                Pose = "Launch",
                Style = "Quad",
                Direction = "Out"
            },
            {
                Time = 1.25,
                Pose = "Fly",
                Style = "Quad",
                Direction = "InOut"
            },
            {
                Time = 4.65,
                Pose = "Fly",
                Style = "Linear"
            }
        }
    }
}
v1.Event = {
    SpawnZone = 1,
    SpawnStagger = 0.7,
    BannerAfterCutscene = 7,
    DropTime = 2.8,
    EntranceDistance = 650,
    EntranceHeight = 320,
    EntranceSide = 220,
    LeaveCrouch = 0.45,
    LeaveTime = 4.65,
    LeaveDistance = 4500,
    LeaveHeight = 2200,
    Thrusters = {
        FlameSource = "Explosion",
        FlameMatch = "flame",
        FlameScale = 1.3,
        TrailWidth = 0.6,
        TrailLifetime = 0.45,
        Parts = { "LeftFoot", "RightFoot", "LeftHand", "RightHand" },
        TrailColors = {
            Color3.fromRGB(255, 250, 225),
            Color3.fromRGB(255, 140, 40)
        }
    },
    Territories = {
        rran = {
            Min = 1,
            Max = 4
        },
        monk = {
            Min = 5,
            Max = 10
        }
    },
    SafeZoneClearance = 60,
    PortalClearance = 90,
    WalkSpeed = 16,
    TurnSpeed = 200,
    MinTurnTime = 0.25,
    MinWalk = 35,
    MaxWalk = 220,
    Separation = 250,
    RoamStyles = {
        rran = "Stay",
        monk = "Travel"
    },
    DefaultRoamStyle = "Travel",
    TravelMinZones = 2,
    WalksBetweenShots = {
        Min = 1,
        Max = 2
    },
    IdlePause = {
        Min = 0.35,
        Max = 1.1
    },
    EdgeMargin = 0.18,
    StepUp = 14,
    DefaultMinutes = 5,
    MaxMinutes = 30,
    LeaveWarning = 30,
    ShotEggs = "Lucky",
    EggSizeMult = 1.25,
    ShootWhileWalking = false,
    WalkShotDelay = 0.3,
    TargetAnyZone = true,
    DistanceFalloff = 0.6,
    MaxEggsPerZone = 4,
    FullWait = 20,
    ReshootMinAge = 90,
    FarShotChance = 0.25,
    OpeningTime = 60,
    OpeningZones = 1,
    NearZones = 1,
    SkyShotMinZones = 2,
    NearShots = {
        BazookaFire = 60,
        TripleShot = 40
    },
    FarShots = {
        SkyShot = 70,
        TripleShot = 30
    },
    BigShot = v2,
    BigEggs = {
        Chance = 0.12,
        OpeningWindow = 20,
        SizeRatio = {
            Min = 3.1,
            Max = 4.5
        },
        OpeningCount = {
            Min = 3,
            Max = 5
        }
    },
    Flight = {
        MinTime = 1.5,
        TimePerStud = 0.0035714285714285713,
        MaxTime = 6.5,
        ApexMin = 30,
        ApexPerStud = 0.3,
        ApexMax = 380,
        SkyApexMult = 1.35,
        TripleApexMult = 0.8
    },
    MuzzleGuess = Vector3.new(1.2999999523162842, 2.200000047683716, -1.600000023841858),
    ShakeRadius = 260,
    LandShake = 6,
    FireShake = 2.2,
    MuzzleBlastScale = 1.4,
    LandBlastScale = 2.6,
    SmokeScale = 1.5,
    SmokeName = "SmokeVFX",
    BlastName = "Explosion"
}
return v1
