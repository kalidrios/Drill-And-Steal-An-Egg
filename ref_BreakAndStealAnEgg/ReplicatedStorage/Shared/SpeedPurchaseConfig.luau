-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    CaughtRequiredPowerAttribute = "CaughtRequiredPower",
    ShowSeconds = 10,
    HiddenYScale = -0.35,
    PulsePeriod = 0.55,
    PulseScale = 1.2,
    SlideIn = {
        Time = 0.5,
        Style = Enum.EasingStyle.Back,
        Direction = Enum.EasingDirection.Out
    },
    SlideOut = {
        Time = 0.35,
        Style = Enum.EasingStyle.Back,
        Direction = Enum.EasingDirection.In
    },
    PulseColor = Color3.fromRGB(85, 255, 100)
}
local RobuxShopConfig = require(script.Parent.RobuxShopConfig)

function v1.PackFor(v2, v3) -- line 63 | captures: RobuxShopConfig
    local v4 = v3 - v2
    local SpeedPacks = RobuxShopConfig.SpeedPacks
    for v5, v6 in SpeedPacks do
        if v4 <= v6.Amount then
            return v6
        end
    end
    return SpeedPacks[#SpeedPacks]
end

return v1
