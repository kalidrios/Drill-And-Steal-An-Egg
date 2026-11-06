-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local FloatingIconConfig = require(ReplicatedStorage.Shared.FloatingIconConfig)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local FloatingIconFX = require(script.Parent.FloatingIconFX)
local v1 = {
    HoverScale = 1.03,
    PressScale = 0.95
}

function v1.SetRender(v2, v3, v4) -- line 42 | captures: AnimalRenders
    if v2 and v2:IsA("ImageLabel") then
        AnimalRenders.Apply(v2, v3, v4)
        for v5, v6 in v2:GetDescendants() do
            if v6:IsA("ImageLabel") then
                AnimalRenders.Apply(v6, v3, v4)
            end
        end
    end
end

function v1.PaintBackground(v7, v8) -- line 54 | captures: EggRewards, RarityGradientFX
    local v9 = v7:FindFirstChild("RarityGradient") or v7:FindFirstChildOfClass("UIGradient")
    if not v9 then
        v9 = Instance.new("UIGradient")
        v9.Name = "RarityGradient"
        v9.Parent = v7
    end
    if not v9:IsA("UIGradient") then
        return
    end
    v7.BackgroundColor3 = Color3.new(1, 1, 1)
    local Attach = RarityGradientFX.Attach
    local v10 = if v8 and EggRewards.RarityGradients[v8] then v8 else "Common"
    Attach(v9, v10)
end

function v1.Prepare(v11, v12) -- line 69 | captures: FloatingIconConfig, FloatingIconFX, v1
    v11.Active = true
    for v13, v14 in v11:GetDescendants() do
        if v14:IsA("GuiObject") then
            v14.Active = false
        end
    end
    v11:SetAttribute("HoverScale", v1.HoverScale)
    v11:SetAttribute("PressScale", v1.PressScale)
    if v12 and v12:IsA("GuiObject") and v11:IsA("GuiButton") then
        FloatingIconFX.Attach(v12, FloatingIconConfig.Styles.AnimalTile, v11)
    end
end

local function SetupGrid(v15) -- line 88
    local UIListLayout = v15:FindFirstChildOfClass("UIListLayout")
    if UIListLayout then
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.Wraps = true
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    end
    local Title = v15:FindFirstChild("Title")
    if Title and Title:IsA("GuiObject") then
        Title.LayoutOrder = -2
    end
    local None = v15:FindFirstChild("None")
    if None and None:IsA("GuiObject") then
        None.LayoutOrder = -1
    end
    v15.CanvasSize = UDim2.new()
    v15.AutomaticCanvasSize = Enum.AutomaticSize.Y
end

v1.SetupGrid = SetupGrid
return v1
