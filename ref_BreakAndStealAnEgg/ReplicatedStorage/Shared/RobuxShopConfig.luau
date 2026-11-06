-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    FrameName = "Shop",
    FastSwingAttribute = "FastSwingOwned",
    DoubleCashAttribute = "DoubleCashOwned",
    DoubleGrowthAttribute = "DoubleGrowthOwned",
    FallenTokenSection = "FallenTokens",
    FallenTokenHeader = "Splitter_Fallen_Tokens",
    PendingText = "...",
    BoughtText = "BOUGHT!",
    GiftIntentRemoteName = "RobuxShopGiftIntent",
    GiftRequestRemoteName = "RobuxShopGiftRequest",
    GiftIntentTimeoutSeconds = 300,
    FastSwing = {
        ProductId = 3714065679,
        CardName = "x2 Swing Speed",
        SwingMultiplier = 2
    },
    DoubleCash = {
        ProductId = 3714065639,
        CardName = "x2 Cash",
        CashMultiplier = 2
    },
    DoubleGrowth = {
        ProductId = 3717726136,
        CardName = "x2 Growth",
        GrowthMultiplier = 2
    },
    SpeedPacks = {
        {
            ProductId = 3714065712,
            Amount = 150000,
            CardName = "Speed_Pack_1",
            TitleColor = "#00FF00"
        },
        {
            ProductId = 3714065732,
            Amount = 1000000,
            CardName = "Speed_Pack_2",
            TitleColor = "#00FF00"
        },
        {
            ProductId = 3714065754,
            Amount = 10000000,
            CardName = "Speed_Pack_3",
            TitleColor = "#00FF00"
        },
        {
            ProductId = 3714136238,
            Amount = 50000000,
            CardName = "Speed_Pack_4",
            TitleColor = "#ffc800"
        },
        {
            ProductId = 3714065818,
            Amount = 250000000,
            CardName = "Speed_Pack_5",
            TitleColor = "#ffc800"
        },
        {
            ProductId = 3714065829,
            Amount = 1000000000,
            CardName = "Speed_Pack_6",
            TitleColor = "#ffc800"
        }
    },
    CashPacks = {
        {
            ProductId = 3714065877,
            Amount = 100000,
            CardName = "Money_Pack_1"
        },
        {
            ProductId = 3714065889,
            Amount = 500000,
            CardName = "Money_Pack_2"
        },
        {
            ProductId = 3714065913,
            Amount = 2000000,
            CardName = "Money_Pack_3"
        },
        {
            ProductId = 3714065940,
            Amount = 20000000,
            CardName = "Money_Pack_4"
        },
        {
            ProductId = 3714065974,
            Amount = 100000000,
            CardName = "Money_Pack_5"
        }
    },
    FallenTokenPacks = {
        {
            ProductId = 3715696847,
            Amount = 500,
            CardName = "Pack_1"
        },
        {
            ProductId = 3715696884,
            Amount = 1500,
            CardName = "Pack_2"
        },
        {
            ProductId = 3715696916,
            Amount = 5000,
            CardName = "Pack_3"
        },
        {
            ProductId = 3715696974,
            Amount = 12500,
            CardName = "Pack_4"
        },
        {
            ProductId = 3715697004,
            Amount = 40000,
            CardName = "Pack_5"
        }
    },
    EggPack = {
        CardName = "EggsPack",
        HeaderName = "Splitter_Featured",
        EggType = "FallenAngel",
        UnavailableText = "Fallen Angel Eggs aren't on sale yet!",
        Packs = {
            {
                ProductId = 3715295141,
                TestPlaceId = -9001,
                Amount = 1,
                PurchaseButton = "Purchase1Egg",
                GiftButton = "Gift1Egg"
            },
            {
                ProductId = 3715295747,
                TestPlaceId = -9003,
                Amount = 3,
                PurchaseButton = "Purchase3Eggs",
                GiftButton = "Gift3Eggs"
            },
            {
                ProductId = 3715295845,
                TestPlaceId = -9010,
                Amount = 10,
                PurchaseButton = "Purchase10Eggs",
                GiftButton = "Gift10Eggs"
            },
            {
                ProductId = 3715295933,
                TestPlaceId = -9050,
                Amount = 50,
                PurchaseButton = "Purchase50Eggs",
                GiftButton = "Gift50Eggs"
            }
        },
        Tiles = {
            Animal3 = "AngelAnky",
            Animal4 = "AngelTrike",
            Animal5 = "AngelMegalodon",
            Animal6 = "AngelTRex",
            Animal7 = "AngelDragon",
            Animal8 = "AngelHydra"
        }
    }
}
local FormatNumber = require(script.Parent.FormatNumber)
local PotionConfig = require(script.Parent.PotionConfig)
local TestPlacePurchaseConfig = require(script.Parent.TestPlacePurchaseConfig)

function v1.EggPackProductId(v2) -- line 174 | captures: TestPlacePurchaseConfig
    if v2.ProductId then
        return v2.ProductId
    end
    if TestPlacePurchaseConfig.IsTestPlace() then
        return v2.TestPlaceId
    end
    return nil
end

local function EggPackAmountText(v3) -- line 185
    if v3.Amount == 1 then
        return "1 Egg"
    end
    return (("%* Eggs"):format(v3.Amount))
end

v1.EggPackAmountText = EggPackAmountText

function v1.SpeedPackTitle(v4) -- line 193 | captures: FormatNumber
    return (("<font color=\"%*\">+%*</font> <font color=\"#FFFFFF\">SPEED</font>"):format(v4.TitleColor, (FormatNumber.Short(v4.Amount))))
end

function v1.CashPackTitle(v5) -- line 198 | captures: FormatNumber
    return (("$%*"):format((FormatNumber.Short(v5.Amount))))
end

function v1.FallenTokenPackTitle(v6) -- line 203 | captures: FormatNumber
    return (("+%* Tokens"):format((FormatNumber.Short(v6.Amount))))
end

function v1.SwingMultiplierFor(v7) -- line 211 | captures: v1, PotionConfig
    local v8 = if v7:GetAttribute(v1.FastSwingAttribute) == true then v1.FastSwing.SwingMultiplier else 1
    return v8 * PotionConfig.MultiplierFor(v7, "Swing")
end

function v1.OneTimeAttributeFor(v9) -- line 222 | captures: v1
    if v9 == v1.FastSwing.ProductId then
        return v1.FastSwingAttribute
    end
    if v9 == v1.DoubleCash.ProductId then
        return v1.DoubleCashAttribute
    end
    if v9 == v1.DoubleGrowth.ProductId then
        return v1.DoubleGrowthAttribute
    end
    return nil
end

function v1.CashMultiplierFor(v10) -- line 234 | captures: v1
    if v10:GetAttribute(v1.DoubleCashAttribute) == true then
        return v1.DoubleCash.CashMultiplier
    end
    return 1
end

function v1.GrowthMultiplierFor(v11) -- line 244 | captures: v1
    if v11:GetAttribute(v1.DoubleGrowthAttribute) == true then
        return v1.DoubleGrowth.GrowthMultiplier
    end
    return 1
end

return v1
