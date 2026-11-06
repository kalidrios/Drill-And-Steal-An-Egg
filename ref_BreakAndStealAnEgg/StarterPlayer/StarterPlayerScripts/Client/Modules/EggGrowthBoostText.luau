-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggGrowthClock = require(ReplicatedStorage.Shared.EggGrowthClock)
local PotionConfig = require(ReplicatedStorage.Shared.PotionConfig)
local v1 = {}

function v1.MultiplierFor(v2) -- line 27 | captures: EggGrowthClock
    return EggGrowthClock.RateOf(v2)
end

function v1.Suffix(v3) -- line 32 | captures: PotionConfig
    if v3 <= 1 then
        return ""
    end
    return ((" <font color=\"%*\">(%*x)</font>"):format(PotionConfig.HoverMultiplierColor, (string.format("%g", v3))))
end

function v1.Decorate(v4, v5, v6) -- line 40 | captures: v1
    local v7 = v1.Suffix(v1.MultiplierFor(v5))
    if v7 ~= "" and not v4.RichText then
        v4.RichText = true
    end
    return v6 .. v7
end

return v1
