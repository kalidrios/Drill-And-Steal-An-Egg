-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    DefaultStyle = {
        FloatHeight = 0.05,
        FloatPeriod = 3.2,
        SwayDegrees = 2.5,
        SwayPeriod = 4.6,
        BreathScale = 0,
        HoverFloatAmount = 0.3,
        HoverScale = 1.12,
        HoverLift = 0.04,
        HoverTilt = -7,
        PulseTime = 0.28,
        PressScale = 0.9,
        PressTilt = 0,
        ClickScaleKick = 3.5,
        ClickTiltKick = 320,
        HoverSound = "UiHover",
        ClickSound = "UiClick_2",
        LayerName = "Inner",
        HoverLayerDepth = 1.8,
        PressLayerDepth = 0.15,
        ScaleSpring = {
            Stiffness = 380,
            Damping = 18
        },
        TiltSpring = {
            Stiffness = 210,
            Damping = 13
        },
        LiftSpring = {
            Stiffness = 240,
            Damping = 25
        },
        FloatBlendSpring = {
            Stiffness = 40,
            Damping = 13
        },
        LayerSpring = {
            Stiffness = 420,
            Damping = 20
        }
    },
    Styles = {
        AnimalTile = {
            FloatHeight = 0,
            SwayDegrees = 0,
            HoverFloatAmount = 0,
            HoverScale = 1.08,
            HoverLift = 0.03,
            HoverTilt = -5,
            PressScale = 0.93,
            ClickScaleKick = 2.5,
            ClickTiltKick = 220,
            HoverLayerDepth = 1.5,
            HoverSound = false,
            ClickSound = false
        }
    },
    Targets = { { Path = { "Frames", "Shop", "ScrollingFrame", "CommunityReward", "Inner", "Icon" } } }
}
