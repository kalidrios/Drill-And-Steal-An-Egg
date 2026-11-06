-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local AdminConfig = require(script.Parent.AdminConfig)
local v1 = {
    FreeProductsEnabled = true,
    RemoteName = "TestPlaceFreePurchase",
    RateInterval = 0.5,
    RateBurst = 4
}

function v1.IsTestPlace() -- line 39 | captures: AdminConfig, v1
    return v1.FreeProductsEnabled and game.PlaceId == AdminConfig.DevPlaceId
end

return v1
