-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RobuxShopConfig = require(script.Parent.RobuxShopConfig)
local UiFramesConfig = require(script.Parent.UiFramesConfig)
local v1 = {}
for v2, v3 in RobuxShopConfig.SpeedPacks do
    local CardName = v3.CardName
    table.insert(v1, CardName)
end

return {
    ScrollingFrame = "ScrollingFrame",
    SectionHeader = "Splitter_SpeedPacks",
    ShopFrame = RobuxShopConfig.FrameName,
    SectionCards = v1,
    ToggleButtons = {
        { "Currencies", "Speed", "Icon", "More" },
        { "LeftHUD", "SpeedShop" }
    },
    ScrollTweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    FallenTokensScrollTweenInfo = TweenInfo.new(1.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    SettleDelay = UiFramesConfig.TweenDuration + 0.02
}
