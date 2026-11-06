-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Enum_2 = game and Enum or (nil).Enum
local Color3_2 = game and Color3 or (nil).Color3
local Vector3_2 = game and Vector3 or (nil).Vector3

return {
    CanvasGroup = nil,
    Part = {
        Anchored = true,
        Material = Enum_2.Material.SmoothPlastic,
        Size = Vector3_2.new(1, 1, 1)
    },
    BillboardGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum_2.ZIndexBehavior.Sibling
    },
    Frame = {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3_2.new(1, 1, 1),
        BorderColor3 = Color3_2.new(0, 0, 0)
    },
    ImageButton = {
        BorderSizePixel = 0,
        AutoButtonColor = false,
        BackgroundColor3 = Color3_2.new(1, 1, 1),
        BorderColor3 = Color3_2.new(0, 0, 0)
    },
    ImageLabel = {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3_2.new(1, 1, 1),
        BorderColor3 = Color3_2.new(0, 0, 0)
    },
    ScreenGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum_2.ZIndexBehavior.Sibling
    },
    ScrollingFrame = {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3_2.new(1, 1, 1),
        BorderColor3 = Color3_2.new(0, 0, 0),
        ScrollBarImageColor3 = Color3_2.new(0, 0, 0)
    },
    SurfaceGui = {
        ResetOnSpawn = false,
        PixelsPerStud = 50,
        ZIndexBehavior = Enum_2.ZIndexBehavior.Sibling,
        SizingMode = Enum_2.SurfaceGuiSizingMode.PixelsPerStud
    },
    TextBox = {
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Text = "",
        BackgroundColor3 = Color3_2.new(1, 1, 1),
        BorderColor3 = Color3_2.new(0, 0, 0),
        Font = Enum_2.Font.SourceSans,
        TextColor3 = Color3_2.new(0, 0, 0)
    },
    TextButton = {
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        BackgroundColor3 = Color3_2.new(1, 1, 1),
        BorderColor3 = Color3_2.new(0, 0, 0),
        Font = Enum_2.Font.SourceSans,
        TextColor3 = Color3_2.new(0, 0, 0)
    },
    TextLabel = {
        BorderSizePixel = 0,
        Text = "",
        BackgroundColor3 = Color3_2.new(1, 1, 1),
        BorderColor3 = Color3_2.new(0, 0, 0),
        Font = Enum_2.Font.SourceSans,
        TextColor3 = Color3_2.new(0, 0, 0)
    },
    UIListLayout = { SortOrder = Enum_2.SortOrder.LayoutOrder },
    UIGridLayout = { SortOrder = Enum_2.SortOrder.LayoutOrder },
    UITableLayout = { SortOrder = Enum_2.SortOrder.LayoutOrder },
    UIPageLayout = { SortOrder = Enum_2.SortOrder.LayoutOrder },
    VideoFrame = {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3_2.new(1, 1, 1),
        BorderColor3 = Color3_2.new(0, 0, 0)
    },
    ViewportFrame = {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3_2.new(1, 1, 1),
        BorderColor3 = Color3_2.new(0, 0, 0)
    }
}
