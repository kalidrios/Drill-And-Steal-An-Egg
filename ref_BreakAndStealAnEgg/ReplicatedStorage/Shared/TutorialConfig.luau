-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    StageAttribute = "TutorialStage",
    ActiveAttribute = "TutorialActive",
    UpgradeBoardMarker = "TUTHere",
    ReservedAttribute = "ReservedUserId",
    StealZoneId = "Zone1",
    StealTargetGraceSeconds = 1.5,
    Stages = {
        {
            Id = "EquipPickaxe",
            Text = "Equip your Pickaxe"
        },
        {
            Id = "BreakEgg",
            Text = "Break an Egg"
        },
        {
            Id = "Hatching",
            Text = ""
        },
        {
            Id = "StealAnimal",
            Text = "Steal the animal"
        },
        {
            Id = "Escape",
            Text = ""
        },
        {
            Id = "GoToPen",
            Text = "Go to your Pen"
        },
        {
            Id = "PlaceAnimal",
            Text = "Place your Animal"
        },
        {
            Id = "EarnCash",
            Text = ""
        },
        {
            Id = "UpgradePen",
            Text = "Upgrade your Pen"
        },
        {
            Id = "UseTreadmill",
            Text = "Use your Treadmill to become faster"
        },
        {
            Id = "EarnPickaxeCash",
            Text = "Use your Treadmill to become faster"
        },
        {
            Id = "BuyPickaxe",
            Text = "Buy a better Pickaxe"
        },
        {
            Id = "EquipNewPickaxe",
            Text = "Equip your new Pickaxe"
        },
        {
            Id = "BreakStrongerEgg",
            Text = "Break a Stronger Egg"
        },
        {
            Id = "CollectStrongerAnimal",
            Text = "Steal the Animal"
        },
        {
            Id = "EscapeStronger",
            Text = ""
        },
        {
            Id = "GoToPenStronger",
            Text = "Go to your Pen"
        },
        {
            Id = "PlaceAnimalStronger",
            Text = "Place your Animal"
        },
        {
            Id = "EarnTrailCash",
            Text = ""
        },
        {
            Id = "BuyTrail",
            Text = "Buy a Trail"
        }
    },
    AnimalInHandStages = {
        GoToPen = true,
        PlaceAnimal = true,
        GoToPenStronger = true,
        PlaceAnimalStronger = true
    },
    StrongEggMinTier = 2,
    FirstEggHealth = 3,
    FirstEggAttribute = "TutorialEggFor",
    FirstHatchRarity = "Common",
    StrongerHatchRarity = "Uncommon",
    EarnCashTarget = 100,
    SaveUpTextFormats = { EarnTrailCash = "Save up for a Trail <font color=\"rgb(85,255,100)\">$%d/$%d</font>" },
    EarnCashTextFormat = "Earn <font color=\"rgb(85,255,100)\">$%d/$%d</font>",
    ProgressCompleteHold = 1,
    EarnBaselineAttribute = "TutorialEarnBaseline",
    TreadmillMinSeconds = 8,
    ShopPickaxeTier = 2,
    CloseShopText = "Close the Shop",
    PickaxeShopMarker = { "Booths", "Pickaxe Shop", "HitZone" },
    TrailsShopMarker = { "Booths", "Trails Shop", "HitZone" },
    PickaxeShopArrowMarker = { "Booths", "Pickaxe Shop", "Build", "ArrowHere" },
    TrailsShopArrowMarker = { "Booths", "Trails Shop", "Build", "ArrowHere" },
    CollectFallbackSeconds = 90,
    TrailSafeSeconds = 0,
    DoneStage = "Done",
    PausedStage = "Paused",
    HellResumeStage = {
        Hatching = "BreakEgg",
        StealAnimal = "BreakEgg",
        Escape = "BreakEgg",
        CollectStrongerAnimal = "BreakStrongerEgg",
        EscapeStronger = "BreakStrongerEgg",
        BuyTrail = "EarnTrailCash"
    },
    Arrow = {
        ZIndex = 900,
        Gap = 6,
        BobDistance = 10,
        BobTime = 0.9
    },
    ScreenArrow = {
        ZIndex = 900,
        HoverHeight = 5,
        ShopHoverHeight = -2.5,
        OverheadClearance = 0.5,
        Gap = 6,
        BobDistance = 10,
        BobTime = 0.9
    },
    AwaitRevealAttribute = "TutorialAwaitReveal",
    AwaitRevealMaxSeconds = 15,
    TypewriterInterval = 0.04
}

function v1.TextFor(v2) -- line 279 | captures: v1
    if v2 == v1.DoneStage then
        return ""
    end
    for v3, v4 in v1.Stages do
        if v4.Id == v2 then
            return v4.Text
        end
    end
    return nil
end

function v1.IsStealTarget(v5, v6) -- line 293 | captures: v1
    if not (not v5:IsA("Model") or v5.Parent == nil) and not v5:GetAttribute("Despawning") and v5:GetAttribute("ZoneId") == v1.StealZoneId then
        local v7 = v5:GetAttribute(v1.ReservedAttribute)
        if v7 == nil then
            return true
        end
        return v7 == v6
    end
    return false
end

return v1
