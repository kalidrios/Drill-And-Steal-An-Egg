-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local AdminConfig = require(script.Parent.AdminConfig)
local HellBossConfig = require(script.Parent.HellBossConfig)
local SpeedConfig = require(script.Parent.SpeedConfig)
local v1 = {
    MapName = "HellBossFight",
    SpawnsFolderName = "Spawns",
    SpawnHeight = 4,
    Map = {
        DespawnDelay = 12,
        RestageDelay = 5,
        Strip = { "AnimSaves", "InitialPoses" }
    },
    Leave = {
        ModelName = "LeaveHell",
        TouchPart = "TP",
        BlockDuringAdminAbuse = true,
        BlockedText = "You can't leave during Admin Abuse! Defeat the boss!",
        BlockedNoticeEvery = 3,
        RemoveWhenForced = true,
        ForcedText = "There's no way out of this Hell! Defeat the boss!",
        RemovedAttribute = "HellLeaveRemoved"
    },
    StreamTimeout = 1.5,
    Scopes = {
        Server = true,
        Global = true
    },
    Topic = "HellEvent",
    StateMap = "HellEvent",
    StateKey = "Active",
    MaxSeconds = 21600,
    CatchUpSeconds = 900,
    StartedAtAttribute = "HellStartedAt",
    StartDelay = {
        Attribute = "HellScheduledAt",
        Max = 86400,
        StateKey = "Scheduled",
        DisplayGrace = 30
    },
    Schedule = {
        Interval = 3600,
        Duration = 1560,
        EnableAt = 1791118800,
        JoinCooldown = 2,
        LateServerGrace = 5,
        LateServerMinLeft = nil,
        TestDelayAfterFight = nil,
        TestIgnoreAnchor = false,
        CloseJoinBelowHealth = 2920,
        CloseWhenEmptyAfter = 300
    },
    Cleared = {
        StateMap = "HellCleared",
        FirstPlayerWait = 20,
        ExpiryMargin = 120
    },
    DevSchedule = {
        Interval = 3600,
        EnableAt = 0
    }
}

if game.PlaceId == AdminConfig.DevPlaceId then
    for v2, v3 in v1.DevSchedule do
        v1.Schedule[v2] = v3
    end
end
v1.HourlySwitch = {
    Store = "HellSchedule",
    Topic = "HellSchedule",
    BootWait = 10,
    Attribute = "HellHourlyOn",
    Button = "Hourly",
    OnText = "Hourly: ON",
    OffText = "Hourly: OFF",
    LoadingText = "Hourly: ...",
    Key = ("Hourly_%*"):format(game.PlaceId)
}
v1.NextAtAttribute = "HellNextAt"
v1.JoinableAttribute = "HellJoinable"
v1.PortalChargeAttribute = "HellPortalChargeAt"
v1.JoinRemoteName = "HellJoinRemote"
v1.Portal = {
    TouchPart = "TP",
    Face = "Shadow",
    HideWhenShut = true,
    SolidWhenEnabled = true,
    OpenBurst = 12,
    StartShare = 0.08,
    OpenTime = 1.6,
    CloseTime = 0.8,
    TouchMargin = 1,
    JoinRequestSlack = 6,
    TouchCheckInterval = 0.25,
    Path = { "Build", "ZoneBuilds", "Zone7", "JoinHell" },
    OpenEmitters = { "Shadow", "TP" },
    PassThrough = { "TP", "Shadow" },
    Dormant = {
        Transparency = 0.6,
        Scale = 0.92,
        Color = Color3.fromRGB(70, 14, 8)
    },
    OpenStyle = Enum.EasingStyle.Elastic,
    CloseStyle = Enum.EasingStyle.Back,
    Label = {
        Billboard = "PortalOverhead",
        Text = "Name",
        ClosedText = "CLOSED",
        Every = 0.25
    }
}

function v1.FindPortal() -- line 323 | captures: v1
    local v4 = workspace
    for v5, v6 in v1.Portal.Path do
        if v4 then
            v4 = v4:FindFirstChild(v6)
        else
            v4 = nil
        end
    end
    if not (v4 and v4:IsA("Model")) then
        return nil
    end
    return v4
end

v1.RiftBanner = {
    Name = "HellRift",
    Order = 2,
    Hold = 7.5,
    Flame = "DemonFlame",
    Sfx = {
        {
            Folder = "rransCustomSFX",
            Name = "Titanic Spawn Whoosh",
            Volume = 0.45
        },
        {
            Folder = "BossSfx",
            Name = "PortalOpen",
            Volume = 0.7
        },
        {
            Folder = "rransCustomSFX",
            Name = "Dark Impact",
            Volume = 0.7,
            Speed = 0.8
        },
        {
            Folder = "BossSfx",
            Name = "DemonGrowl2",
            Volume = 0.35,
            Speed = 0.8
        }
    }
}
v1.PortalCharge = {
    Duration = 10,
    WindDown = 1.5,
    StrikeShrink = 0.3,
    Orb = "Icosphere",
    WallBolts = true,
    EndShare = 0.55,
    KickTime = 0.22,
    TargetSpread = 0.8,
    PowerUpTime = 0.6,
    PowerDownTime = 7,
    Pylons = {
        { "Build", "ZoneBuilds", "Zone7", "1" },
        { "Build", "ZoneBuilds", "Zone7", "2" }
    },
    StrikeEvery = {
        Start = 0.45,
        End = 0.09,
        WindDown = 0.5
    },
    ArcWidth = {
        Start = 0.5,
        End = 1.7
    },
    Color = Color3.fromRGB(255, 35, 25),
    Bolts = {
        Arc = {
            Width = 0.9,
            GlowWidth = 3.2,
            OuterWidth = 9,
            Depth = 5,
            Jag = 0.1,
            Branches = 2,
            BranchLength = 0.18,
            Interval = 0.05,
            Color = Color3.fromRGB(255, 225, 220),
            GlowColor = Color3.fromRGB(255, 45, 30),
            OuterColor = Color3.fromRGB(170, 0, 0)
        },
        Strike = {
            Width = 1.4,
            GlowWidth = 4.5,
            OuterWidth = 12,
            Depth = 5,
            Jag = 0.09,
            Branches = 3,
            BranchLength = 0.22,
            Leader = 0.05,
            Life = 0.45,
            FadeTime = 0.2,
            Color = Color3.fromRGB(255, 230, 225),
            GlowColor = Color3.fromRGB(255, 40, 25),
            OuterColor = Color3.fromRGB(160, 0, 0)
        },
        Final = {
            Width = 3,
            GlowWidth = 9,
            OuterWidth = 24,
            Depth = 6,
            Jag = 0.07,
            Branches = 5,
            BranchLength = 0.2,
            Leader = 0.06,
            Life = 0.8,
            FadeTime = 0.35,
            Color = Color3.fromRGB(255, 235, 230),
            GlowColor = Color3.fromRGB(255, 50, 30),
            OuterColor = Color3.fromRGB(180, 0, 0)
        }
    },
    Sfx = {
        Charge = {
            Folder = "BossSfx",
            Name = "ElectricCharge",
            Range = 400,
            MinRange = 80,
            Volume = 0.5,
            FadeOut = 0.6
        },
        Zap = {
            Folder = "BossSfx",
            Name = "ElectricArc",
            Range = 400,
            MinRange = 80,
            Volume = 0.4,
            Every = 0.12
        },
        Final = {
            Folder = "BossSfx",
            Name = "ThunderStrike",
            Range = 600,
            MinRange = 120,
            Volume = 0.6
        }
    }
}
v1.Timer = {
    LabelName = "Timer",
    Countdown = "In %s",
    JoinText = "JOIN NOW!",
    ChargingText = "OPENING...",
    LiveText = "LIVE!",
    FramePath = { "BottomRightHUD", "BossTimer" }
}
v1.MusicName = "BossMusic"
v1.MusicFadeTime = 2.5
v1.PlayerAttribute = "InHell"
v1.LightingFolderPath = { "HellLighting" }
v1.LightingClasses = { "Sky" }
v1.ClockTime = 12
v1.MinWalkSpeed = 35
v1.MaxWalkSpeed = 80

function v1.WalkSpeedFor(v7) -- line 496 | captures: SpeedConfig, v1
    local v8 = (v7 - SpeedConfig.BaseWalkSpeed) / (SpeedConfig.MaxWalkSpeed - SpeedConfig.BaseWalkSpeed)
    local v9 = math.clamp(v8, 0, 1)
    return v1.MinWalkSpeed + v9 * (v1.MaxWalkSpeed - v1.MinWalkSpeed)
end

v1.ShowFrames = { { "BossHP" } }
v1.PopIn = {
    StartDelay = 0.05,
    Stagger = 0.07,
    SizeTime = 1.1,
    MoveTime = 0.7,
    FromCenter = 0,
    RisePixels = 18,
    FadeTime = 0.35,
    Order = {
        "Shadow",
        "BossHpBar",
        "Hp",
        "Title",
        "Icon",
        "Shields",
        "DemonGate",
        "DemonWing",
        "DemonCloud",
        "DemonFlame"
    },
    SizeStyle = Enum.EasingStyle.Elastic,
    MoveStyle = Enum.EasingStyle.Back
}
v1.HpCountUp = {
    Format = "%s/%s HP",
    TrailDelay = 0.35,
    TrailTime = 0.45,
    StartDelay = 0.2,
    Time = 1.4,
    BarPath = { "BossHpBar", "Bar" },
    TrailPath = { "BossHpBar", "DamageBar" },
    TextPath = { "Hp" },
    MaxHp = HellBossConfig.MaxHealth,
    Style = Enum.EasingStyle.Quart
}
return v1
