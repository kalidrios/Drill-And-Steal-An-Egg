-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    TimeScale = 1,
    FadeSpeed = 8,
    ImpactAfter = 0.12,
    ImpactKick = -0.5,
    IdleRamp = 0.8,
    ShopPath = { "Frames", "Shop" },
    CardPath = { "Frames", "Shop", "ScrollingFrame", "EggsPack", "Inner" },
    CardSpring = { 2.6, 0.55 },
    Parts = {
        {
            Name = "Icon",
            At = 0.08,
            From = {
                Scale = 0.4,
                X = -0.03,
                Y = 0.05
            },
            Spring = { 3.2, 0.45 },
            Idle = {
                Bob = {
                    Period = 2.8,
                    AmpY = 0.012,
                    AmpR = 0
                }
            }
        },
        {
            Name = "Title",
            At = 0.14,
            Fade = true,
            Impact = true,
            From = {
                Scale = 1.9,
                Rot = -8,
                Y = -0.04
            },
            Spring = { 3.2, 0.45 }
        },
        {
            Name = "LimitedTime",
            At = 0.22,
            Fade = true,
            From = {
                Scale = 1.6,
                Rot = 8,
                Y = -0.03
            },
            Spring = { 3.2, 0.45 }
        },
        {
            Name = "Timer",
            At = 0.28,
            Fade = true,
            From = { Scale = 0.4 },
            Spring = { 3.5, 0.5 }
        },
        {
            Name = "Badge",
            At = 0.34,
            From = {
                Scale = 0,
                Rot = -120
            },
            Spring = { 3, 0.45 },
            Idle = {
                Bob = {
                    Period = 2.2,
                    AmpY = 0,
                    AmpR = 5
                }
            }
        },
        {
            Name = "ButtonList",
            At = 0.5,
            Fade = true,
            From = {
                Scale = 0.5,
                Y = 0.04
            },
            Spring = { 3.5, 0.5 }
        }
    },
    Tiles = {
        Container = "AnimalsDisplay",
        Pattern = "^Animal%d+$",
        At = 0.3,
        Step = 0.06,
        FromScale = 0,
        Spring = { 3.2, 0.58 }
    }
}
