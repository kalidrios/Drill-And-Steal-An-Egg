-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return function(v1, v2) -- line 1
    local widget = v1.widget
    local Contents = v1:getInstance("Contents")
    local Frame = Instance.new("Frame")
    Frame.Name = "Indicator"
    Frame.LayoutOrder = 9999999
    Frame.ZIndex = 6
    Frame.Size = UDim2.new(0, 42, 0, 42)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 1
    Frame.Position = UDim2.new(1, 0, 0.5, 0)
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.Parent = Contents
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "IndicatorButton"
    Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame_2.BorderSizePixel = 0
    Frame_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.Parent = Frame
    local GuiService = game:GetService("GuiService")
    local GamepadService = game:GetService("GamepadService")
    local ClickRegion = v1:getInstance("ClickRegion")

    local function selectionChanged() -- line 28 | captures: Frame_2, GuiService, ClickRegion
        if GuiService.SelectedObject == ClickRegion then
            Frame_2.BackgroundTransparency = 1
            Frame_2.Position = UDim2.new(0.5, -2, 0.5, 0)
            Frame_2.Size = UDim2.fromScale(1.2, 1.2)
        else
            Frame_2.BackgroundTransparency = 0.75
            Frame_2.Position = UDim2.new(0.5, 2, 0.5, 0)
            Frame_2.Size = UDim2.fromScale(1, 1)
        end
    end

    v1.janitor:add(GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(selectionChanged))
    selectionChanged()
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.LayoutOrder = 2
    ImageLabel.ZIndex = 15
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel.Image = "rbxasset://textures/ui/Controls/XboxController/DPadUp@2x.png"
    ImageLabel.Parent = Frame_2
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame_2
    local UserInputService = game:GetService("UserInputService")

    local function setIndicatorVisible(v3) -- line 58 | captures: v1, Frame, GamepadService
        local v4 = if v3 == nil then Frame.Visible else v3
        if GamepadService.GamepadCursorEnabled then
            v4 = false
        end
        if v4 then
            v1:modifyTheme({
                "PaddingRight",
                "Size",
                UDim2.new(0, 0, 1, 0)
            }, "IndicatorPadding")
        elseif Frame.Visible then
            v1:removeModification("IndicatorPadding")
        end
        v1:modifyTheme({ "Indicator", "Visible", v4 })
        v1.updateSize:Fire()
    end

    v1.janitor:add(GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(setIndicatorVisible))
    v1.indicatorSet:Connect(function(v5) -- line 74 | captures: ImageLabel, UserInputService, setIndicatorVisible
        local v6
        if v5 then
            ImageLabel.Image = UserInputService:GetImageForKeyCode(v5)
            v6 = true
        else
            v6 = false
        end
        setIndicatorVisible(v6)
    end)

    local function updateSize() -- line 83 | captures: widget, Frame
        local v7 = widget.AbsoluteSize.Y * 0.96
        Frame.Size = UDim2.new(0, v7, 0, v7)
    end

    widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
    local v8 = widget.AbsoluteSize.Y * 0.96
    Frame.Size = UDim2.new(0, v8, 0, v8)
    return Frame
end
