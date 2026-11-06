-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Themes = require(script.Parent.Parent.Features.Themes)
return function(v1) -- line 5 | captures: TweenService, RunService, Themes
    local Frame = Instance.new("Frame")
    Frame.Name = "Dropdown"
    Frame.AutomaticSize = Enum.AutomaticSize.X
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.new(0.5, 0, 1, 10)
    Frame.ZIndex = -2
    Frame.ClipsDescendants = true
    Frame.Parent = v1.widget
    local GuiService = game:GetService("GuiService")
    v1:setBehaviour("Dropdown", "BackgroundTransparency", function(v2) -- line 20 | captures: GuiService
        local v3 = v2 * GuiService.PreferredTransparency
        if v2 == 1 then
            return v2
        end
        return v3
    end)
    v1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line 28 | captures: v1, Frame
        v1:refreshAppearance(Frame, "BackgroundTransparency")
    end))
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "DropdownCorner"
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "DropdownScroller"
    ScrollingFrame.AutomaticSize = Enum.AutomaticSize.X
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.AnchorPoint = Vector2.new(0, 0)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ZIndex = -1
    ScrollingFrame.ClipsDescendants = true
    ScrollingFrame.Visible = true
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
    ScrollingFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    ScrollingFrame.Active = false
    ScrollingFrame.ScrollingEnabled = true
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.ScrollBarImageTransparency = 0.8
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.Selectable = false
    ScrollingFrame.Active = true
    ScrollingFrame.Parent = Frame
    local NumberValue = Instance.new("NumberValue")
    NumberValue.Name = "DropdownSpeed"
    NumberValue.Value = 0.07
    NumberValue.Parent = Frame
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "DropdownPadding"
    UIPadding.PaddingTop = UDim.new(0, 0)
    UIPadding.PaddingBottom = UDim.new(0, 0)
    UIPadding.Parent = ScrollingFrame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "DropdownList"
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly
    UIListLayout.Parent = ScrollingFrame
    local dropdownJanitor = v1.dropdownJanitor
    local iconModule = require(v1.iconModule)
    v1.dropdownChildAdded:Connect(function(v4) -- line 81
        local v5, v6 = v4:modifyTheme({
            { "Widget", "BorderSize", 0 },
            {
                "IconCorners",
                "CornerRadius",
                UDim.new(0, 10)
            },
            { "Widget", "MinimumWidth", 190 },
            { "Widget", "MinimumHeight", 58 },
            { "IconLabel", "TextSize", 20 },
            {
                "IconOverlay",
                "Size",
                UDim2.new(1, 0, 1, 0)
            },
            {
                "PaddingLeft",
                "Size",
                UDim2.fromOffset(25, 0)
            },
            {
                "Notice",
                "Position",
                UDim2.new(1, -24, 0, 5)
            },
            {
                "ContentsList",
                "HorizontalAlignment",
                Enum.HorizontalAlignment.Left
            },
            {
                "Selection",
                "Size",
                UDim2.new(1, -0, 1, -0)
            },
            {
                "Selection",
                "Position",
                UDim2.new(0, 0, 0, 0)
            }
        })
        task.defer(function() -- line 95 | captures: v4, v6
            v4.joinJanitor:add(function() -- line 96 | captures: v4, v6
                v4:removeModification(v6)
            end)
        end)
    end)
    v1.dropdownSet:Connect(function(v7) -- line 101 | captures: v1, iconModule
        for v8, v9 in pairs(v1.dropdownIcons) do
            iconModule.getIconByUID(v9):destroy()
        end
        if type(v7) == "table" then
            for v10, v11 in pairs(v7) do
                v11:joinDropdown(v1)
            end
        end
    end)

    local function updateMaxIcons() -- line 113 | captures: Frame, ScrollingFrame, UIPadding
        local MaxIcons = Frame:GetAttribute("MaxIcons")
        if MaxIcons then
            local v12 = {}
            for v13, v14 in pairs(ScrollingFrame:GetChildren()) do
                if v14:IsA("GuiObject") and v14.Visible then
                    table.insert(v12, v14)
                end
            end
            table.sort(v12, function(v15, v16) -- line 124
                return v15.AbsolutePosition.Y < v16.AbsolutePosition.Y
            end)
            local v17 = math.ceil(MaxIcons)
            local v18 = 0
            for v19 = 1, v17 do
                local v20 = v12[v19]
                local Y
                if v20 then
                    Y = v20.AbsoluteSize.Y
                    if v19 == v17 and v17 ~= MaxIcons then
                        Y *= MaxIcons - v17 + 1
                    end
                else
                    break
                end
                v18 += Y
            end
            return v18 + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)
        end
        return 0
    end

    local v21, v22, v23, v24

    local function getTweenInfo() -- line 145 | captures: v23, v24, Frame, NumberValue, Themes
        local v25 = Themes.getInstanceValue(Frame, "MaxIcons") or 1
        if v23 and v23 == v25 and v24 then
            return v24
        end
        local v26 = TweenInfo.new(NumberValue.Value * v25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
        v24 = v26
        v23 = v25
        return v26
    end

    local function updateVisibility() -- line 159 | captures: v21, v22, v23, v24, v1, Frame, NumberValue, updateMaxIcons, TweenService, Themes
        local v27 = Themes.getInstanceValue(Frame, "MaxIcons") or 1
        local v28
        if v23 and v23 == v27 and v24 then
            v28 = v24
        else
            v28 = TweenInfo.new(NumberValue.Value * v27, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            v24 = v28
            v23 = v27
        end
        if v21 then
            v21:Cancel()
            v21 = nil
        end
        if v22 then
            v22:Cancel()
            v22 = nil
        end
        if v1.isSelected then
            local v29 = updateMaxIcons()
            Frame.Visible = true
            Frame.BackgroundTransparency = 0
            Frame.Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0)
            v21 = TweenService:Create(Frame, v28, { Size = UDim2.new(0, Frame.Size.X.Offset, 0, v29) })
            v21:Play()
            v21.Completed:Connect(function() -- line 180 | captures: v21
                v21 = nil
            end)
        else
            local v30 = TweenInfo.new(0)
            v22 = TweenService:Create(Frame, v30, { Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0) })
            v22:Play()
            v22.Completed:Connect(function() -- line 187 | captures: v22
                v22 = nil
            end)
        end
    end

    dropdownJanitor:add(v1.toggled:Connect(updateVisibility))
    updateVisibility()

    local function updateChildSize() -- line 197 | captures: v21, v22, v23, v24, v1, Frame, NumberValue, updateMaxIcons, TweenService, RunService, Themes
        local v31 = Themes.getInstanceValue(Frame, "MaxIcons") or 1
        local v32
        if v23 and v23 == v31 and v24 then
            v32 = v24
        else
            v32 = TweenInfo.new(NumberValue.Value * v31, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            v24 = v32
            v23 = v31
        end
        if not v1.isSelected then
            return
        end
        if v21 then
            v21:Cancel()
            v21 = nil
        end
        if v22 then
            v22:Cancel()
            v22 = nil
        end
        RunService.Heartbeat:Wait()
        local v33 = updateMaxIcons()
        v21 = TweenService:Create(Frame, v32, { Size = UDim2.new(0, Frame.Size.X.Offset, 0, v33) })
        v21:Play()
        v21.Completed:Connect(function() -- line 215 | captures: v21
            v21 = nil
        end)
    end

    dropdownJanitor:add(v1.toggled:Connect(updateVisibility))
    local v34 = 0
    local v35 = false
    local updateMaxIconsListener

    local function updateMaxIconsListener_2() -- line 228 | captures: v34, v35, v1, Frame, ScrollingFrame, UIPadding, iconModule, updateMaxIconsListener
        v34 += 1
        if v35 then
            return
        end
        local v36 = v34
        v35 = true
        task.defer(function() -- line 233 | captures: v36, v34, v35, updateMaxIconsListener
            v35 = false
            if v34 ~= v36 then
                updateMaxIconsListener()
            end
        end)
        local MaxIcons = Frame:GetAttribute("MaxIcons")
        if not MaxIcons then
            return
        end
        local v37 = {}
        for v38, v39 in pairs(ScrollingFrame:GetChildren()) do
            if v39:IsA("GuiObject") and v39.Visible then
                local v40 = {
                    v39,
                    v39.AbsolutePosition.Y
                }
                table.insert(v37, v40)
            end
        end
        table.sort(v37, function(v41, v42) -- line 248
            return v41[2] < v42[2]
        end)
        local v43 = math.ceil(MaxIcons)
        local v44 = 0
        local v45 = false
        for v46 = 1, v43 do
            local v47 = v37[v46]
            if v47 then
                local v48 = v47[1]
                local Y = v48.AbsoluteSize.Y
                local v49 = if v46 == v43 then v43 ~= MaxIcons else false
                if v49 then
                    Y *= MaxIcons - v43 + 1
                end
                v44 += Y
                if not v49 then
                    local WidgetUID = v48:GetAttribute("WidgetUID")
                    local v50 = WidgetUID and iconModule.getIconByUID(WidgetUID)
                    if v50 then
                        local v51, v52
                        if v45 then
                            v52 = v45
                        else
                            v52, v51 = true, v1:getInstance("ClickRegion")
                        end
                        v50:getInstance("ClickRegion").NextSelectionUp = v51
                        v45 = v52
                    end
                end
            else
                break
            end
        end
        local v53 = v44 + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)
        ScrollingFrame.Size = UDim2.fromOffset(0, v53)
    end

    updateMaxIconsListener = updateMaxIconsListener_2
    dropdownJanitor:add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateMaxIconsListener_2))
    dropdownJanitor:add(ScrollingFrame.ChildAdded:Connect(updateMaxIconsListener_2))
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateChildSize))
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateMaxIconsListener_2))
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateMaxIconsListener_2))
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateChildSize))
    dropdownJanitor:add(v1.childThemeModified:Connect(updateMaxIconsListener_2))
    updateMaxIconsListener_2()

    local function connectVisibilityListeners(v54) -- line 293 | captures: updateChildSize
        if v54:IsA("GuiObject") then
            v54:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
            v54:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
        end
    end

    for v55, v56 in pairs(ScrollingFrame:GetChildren()) do
        if v56:IsA("GuiObject") then
            v56:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
            v56:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
        end
    end
    ScrollingFrame.ChildAdded:Connect(function(v57) -- line 305 | captures: updateChildSize, RunService
        RunService.Heartbeat:Wait()
        if v57:IsA("GuiObject") then
            v57:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
            v57:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
        end
        updateChildSize()
    end)
    Frame.Visible = false
    return Frame
end
