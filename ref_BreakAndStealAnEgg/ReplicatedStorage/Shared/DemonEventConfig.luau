-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    CurrencyName = "Fallen Tokens",
    BalanceAttribute = "DemonTokens",
    RemoteName = "DemonEventRequest",
    TokenIcon = "rbxassetid://72991528594731",
    EggTabOffer = "Demon",
    PotionOfferSeconds = 600,
    RequiredSpeedPower = 750000000,
    SpeedPowerAttribute = "SpeedPower",
    FurnaceUnlockedAttribute = "FurnaceUnlocked",
    FurnacePromptObjectText = "Mysterious Egg Incubator",
    FurnaceLockedActionText = "Locked",
    FurnaceUnlockedActionText = "Interact",
    BossReward = {
        Min = 150,
        Max = 750
    },
    Eggs = {
        Demon = {
            EggType = "Demon",
            Price = 500
        }
    },
    PotionOffers = {
        {
            PotionId = "Swing",
            Price = 400,
            Quantity = 1
        },
        {
            PotionId = "EggGrowth",
            Price = 325,
            Quantity = 1
        },
        {
            PotionId = "Cash",
            Price = 275,
            Quantity = 1
        },
        {
            PotionId = "Treadmill",
            Price = 250,
            Quantity = 1
        },
        {
            PotionId = "WalkSpeed",
            Price = 150,
            Quantity = 1
        }
    }
}

function v1.PotionOffer(v2) -- line 110 | captures: v1
    if typeof(v2) == "string" then
        for v3, v4 in v1.PotionOffers do
            if v4.PotionId == v2 then
                return v4
            end
        end
    end
    return nil
end

function v1.BossRewardFor(v5) -- line 123 | captures: v1
    local BossReward = v1.BossReward
    local v6 = if v5 == v5 then v5 else 0
    local v7 = math.clamp(v6, 0, 1)
    local v8 = BossReward.Min + (BossReward.Max - BossReward.Min) * v7 + 0.5
    return (math.floor(v8))
end

return v1
