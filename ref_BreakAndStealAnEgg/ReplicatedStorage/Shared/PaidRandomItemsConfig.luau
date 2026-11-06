-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RobuxShopConfig = require(script.Parent.RobuxShopConfig)
local v1 = {
    Attribute = "PaidRandomItemsRestricted",
    RestrictTokenEggs = true,
    Attempts = 3,
    RetryDelay = 2,
    RecheckSeconds = 60,
    ResolveTimeout = 10,
    StudioForceRestricted = false,
    Presets = {
        Restricted = "PaidRandomItemsRestricted",
        GiftRecipientRestricted = "PaidRandomGiftRestricted",
        GiftFellBackToBuyer = "PaidRandomGiftToBuyer"
    }
}
local v2 = {}
for v3, v4 in RobuxShopConfig.EggPack.Packs do
    local v5 = RobuxShopConfig.EggPackProductId(v4)
    if v5 then
        v2[v5] = true
    end
end

function v1.IsPaidRandomProduct(v6) -- line 74 | captures: v2
    return v2[v6] == true
end

function v1.IsRestricted(v7) -- line 80 | captures: v1
    return v7:GetAttribute(v1.Attribute) ~= false
end

return v1
