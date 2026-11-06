-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local PetInventoryConfig = require(script.Parent.PetInventoryConfig)

return {
    GuiName = "Scatchel",
    MobileGuiName = "MobileScatchel",
    HotbarName = "BottomHUD",
    InventoryName = "Inventory",
    TemplateName = "Template",
    HotbarSlotsFull = 10,
    HotbarSlotsMini = 5,
    ToggleKey = Enum.KeyCode.Backquote,
    DragThreshold = 8,
    TouchHoldTime = 0.3,
    TouchDragSlop = 14,
    HotbarDropMargin = 16,
    TopbarPlusPath = { "Satchel", "SatchelLoader", "Satchel", "Packages", "topbarplus" },
    Icon = {
        Name = "Inventory",
        Caption = "Inventory",
        ImageOpen = "rbxasset://textures/ui/TopBar/inventoryOn.png",
        ImageClosed = "rbxasset://textures/ui/TopBar/inventoryOff.png",
        Order = -1
    },
    Categories = {
        Pets = {
            Button = "Pets",
            Title = "All Pets",
            CountLabel = "Pets",
            CountTag = "AnimalTool",
            Capacity = PetInventoryConfig.MaxPets
        },
        Eggs = {
            Button = "Eggs",
            Title = "All Eggs",
            CountLabel = "Eggs",
            MatchTag = "MergeEggTool",
            CountTag = "MergeEggTool",
            Capacity = nil,
            HideCount = true,
            SortBy = { "Rarity", "Kg" }
        }
    },
    DefaultCategory = "Pets",
    RestoredAttribute = "BackpackRestored",
    RestoredGoToInventory = true,
    HotbarShowInfo = true,
    InventoryShowInfo = true,
    HoverScale = 1.03,
    PressScale = 0.98,
    HoverTweenTime = 0.08,
    LockedTintColor = Color3.fromRGB(190, 55, 45),
    LockedTintTransparency = 0.1,
    LockedTintFadeTime = 0.2,
    ShakeAngle = 14,
    ShakeTime = 0.4,
    ShakeCycles = 3,
    WeightFormat = "[%sKG]",
    NameWeightFormat = "%s (%sKG)",
    AnimalInfoName = "AnimalInfo",
    AnimalInfoNameFormat = "%s [%sKG]",
    AnimalInfoEarningsFormat = "$%s/s",
    AnimalInfoEggScale = 0.8,
    AnimalInfoCursorGap = 30,
    ViewportFov = 40,
    ViewportDirection = Vector3.new(0.550000011920929, 0.3499999940395355, -1),
    SelectedStrokeName = "Selected",
    SwapMarkThicknessMult = 2,
    GamepadDoubleTapTime = 0.4
}
