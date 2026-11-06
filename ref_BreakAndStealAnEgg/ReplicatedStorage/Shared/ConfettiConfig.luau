-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    GuiName = "MainGUI",
    LayerName = "ConfettiLayer",
    ZIndex = 45,
    PieceCount = 320,
    SpawnDuration = 0.45,
    MaxPieces = 700,
    Gravity = 1.7,
    SideSpeed = 0.12,
    SideDrag = 2,
    PieceWidth = NumberRange.new(0.012, 0.02),
    PieceLength = NumberRange.new(0.026, 0.046),
    Colors = {
        Color3.fromRGB(230, 57, 70),
        Color3.fromRGB(142, 68, 214),
        Color3.fromRGB(28, 184, 206),
        Color3.fromRGB(82, 200, 60),
        Color3.fromRGB(245, 208, 50),
        Color3.fromRGB(52, 112, 235),
        Color3.fromRGB(255, 120, 190)
    },
    PeakAboveTop = NumberRange.new(0.08, 0.5),
    FallSpeed = NumberRange.new(0.22, 0.38),
    SwayDistance = NumberRange.new(0.01, 0.03),
    SwaySpeed = NumberRange.new(2, 4),
    WobbleDegrees = NumberRange.new(8, 22),
    WobbleSpeed = NumberRange.new(2.5, 5)
}
