-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    DefaultMultiplier = 1,
    AttributeName = "SpeedBoostMultiplier",
    HudTag = {
        Color = "#3BFF3B",
        ShowWhenUnboosted = false
    },
    ShopCard = {
        CardName = "DoubleSpeed",
        MaxText = "MAX",
        MaxedPriceText = "MAXED"
    },
    Tiers = {
        {
            Multiplier = 2,
            DevProductId = 3712779280
        },
        {
            Multiplier = 4,
            DevProductId = 3712779335
        },
        {
            Multiplier = 8,
            DevProductId = 3712779382
        },
        {
            Multiplier = 16,
            DevProductId = 3712779701
        },
        {
            Multiplier = 32,
            DevProductId = 3712779720
        },
        {
            Multiplier = 64,
            DevProductId = 3712779800
        },
        {
            Multiplier = 128,
            DevProductId = 3712779914
        },
        {
            Multiplier = 256,
            DevProductId = 3712779982
        },
        {
            Multiplier = 512,
            DevProductId = 3712780014
        },
        {
            Multiplier = 1024,
            DevProductId = 3712780048
        },
        {
            Multiplier = 2048,
            DevProductId = 3716644340
        },
        {
            Multiplier = 4096,
            DevProductId = 3716644368
        }
    }
}

function v1.ClampMultiplier(v2) -- line 70 | captures: v1
    local Multiplier = v1.Tiers[#v1.Tiers].Multiplier
    if not (typeof(v2) == "number" and v2 == v2) then
        return v1.DefaultMultiplier
    end
    local DefaultMultiplier = v1.DefaultMultiplier
    return (math.clamp(v2, DefaultMultiplier, Multiplier))
end

function v1.NextTier(v3) -- line 80 | captures: v1
    local v4 = v1.ClampMultiplier(v3)
    for v5, v6 in v1.Tiers do
        if v4 < v6.Multiplier then
            return v6
        end
    end
    return nil
end

local function Text(v7) -- line 91
    return (("x%*"):format(v7))
end

v1.Text = Text

local function MaxedGiftText(v8) -- line 96
    return (("%* has already maxed out the Speed Boost!"):format(v8))
end

v1.MaxedGiftText = MaxedGiftText

function v1.MultiplierOf(v9) -- line 102 | captures: v1
    return v1.ClampMultiplier(v9:GetAttribute(v1.AttributeName))
end

function v1.TierForProduct(v10) -- line 107 | captures: v1
    for v11, v12 in v1.Tiers do
        if v12.DevProductId == v10 then
            return v12
        end
    end
    return nil
end

return v1
