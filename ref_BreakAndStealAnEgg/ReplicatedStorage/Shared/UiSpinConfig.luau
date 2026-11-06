-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    UpdatesPerSecond = 60,
    Targets = {
        {
            DegreesPerSecond = 60,
            Path = { "LeftHUD", "SpeedDevproduct", "Spin" }
        },
        {
            DegreesPerSecond = 70,
            Path = { "SpeedPurchase", "Sunray" }
        },
        {
            DegreesPerSecond = 40,
            Path = {
                "Frames",
                "Shop",
                "ScrollingFrame",
                "EggsPack",
                "Inner",
                "AnimalsDisplay",
                "Animal8",
                "Outer",
                "UiGradient"
            }
        },
        {
            DegreesPerSecond = 40,
            Path = {
                "Frames",
                "Shop",
                "ScrollingFrame",
                "EggsPack",
                "Inner",
                "AnimalsDisplay",
                "Animal8",
                "InnerShine",
                "Inner",
                "UiGradient"
            }
        }
    }
}
for v2 = 2, 8 do
    local Targets = v1.Targets
    local v3 = {
        DegreesPerSecond = 36,
        Path = {
            "Frames",
            "Shop",
            "ScrollingFrame",
            "EggsPack",
            "Inner",
            "AnimalsDisplay",
            ("Animal%*"):format(v2),
            "Sunray"
        }
    }
    table.insert(Targets, v3)
end
return v1
