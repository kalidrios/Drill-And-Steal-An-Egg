-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return function(v1, v2) -- line 6
    local Frame = Instance.new("Frame")
    Frame:SetAttribute("WidgetUID", v1.UID)
    Frame.Name = "Widget"
    Frame.BackgroundTransparency = 1
    Frame.Visible = true
    Frame.ZIndex = 20
    Frame.Active = false
    Frame.ClipsDescendants = true
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "IconButton"
    Frame_2.Visible = true
    Frame_2.ZIndex = 2
    Frame_2.BorderSizePixel = 0
    Frame_2.Parent = Frame
    Frame_2.ClipsDescendants = true
    Frame_2.Active = false
    v1.deselected:Connect(function() -- line 25 | captures: v1, Frame_2
        Frame_2.ClipsDescendants = true
        task.delay(0.2, function() -- line 27 | captures: v1, Frame_2
            if v1.isSelected then
                Frame_2.ClipsDescendants = false
            end
        end)
    end)
    local GuiService = game:GetService("GuiService")
    v1:setBehaviour("IconButton", "BackgroundTransparency", function(v3) -- line 36 | captures: GuiService
        local v4 = v3 * GuiService.PreferredTransparency
        if v3 == 1 then
            return v3
        end
        return v4
    end)
    v1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line 44 | captures: v1, Frame_2
        v1:refreshAppearance(Frame_2, "BackgroundTransparency")
    end))
    local UICorner = Instance.new("UICorner")
    UICorner:SetAttribute("Collective", "IconCorners")
    UICorner.Name = "UICorner"
    UICorner.Parent = Frame_2
    local v5 = require(script.Parent.Menu)(v1)
    local MenuUIListLayout = v5.MenuUIListLayout
    local MenuGap = v5.MenuGap
    v5.Parent = Frame_2
    local Frame_3 = Instance.new("Frame")
    Frame_3.Name = "IconSpot"
    Frame_3.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
    Frame_3.BackgroundTransparency = 0.9
    Frame_3.Visible = true
    Frame_3.AnchorPoint = Vector2.new(0, 0.5)
    Frame_3.ZIndex = 5
    Frame_3.Parent = v5
    UICorner:Clone().Parent = Frame_3
    local v6 = Frame_3:Clone()
    v6.UICorner.Name = "OverlayUICorner"
    v6.Name = "IconOverlay"
    v6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    v6.ZIndex = Frame_3.ZIndex + 1
    v6.Size = UDim2.new(1, 0, 1, 0)
    v6.Position = UDim2.new(0, 0, 0, 0)
    v6.AnchorPoint = Vector2.new(0, 0)
    v6.Visible = false
    v6.Parent = Frame_3
    local TextButton = Instance.new("TextButton")
    TextButton:SetAttribute("CorrespondingIconUID", v1.UID)
    TextButton.Name = "ClickRegion"
    TextButton.BackgroundTransparency = 1
    TextButton.Visible = true
    TextButton.Text = ""
    TextButton.ZIndex = 20
    TextButton.Selectable = true
    TextButton.SelectionGroup = true
    TextButton.Parent = Frame_3
    require(script.Parent.Parent.Features.Gamepad).registerButton(TextButton)
    UICorner:Clone().Parent = TextButton
    local Frame_4 = Instance.new("Frame")
    Frame_4.Name = "Contents"
    Frame_4.BackgroundTransparency = 1
    Frame_4.Size = UDim2.fromScale(1, 1)
    Frame_4.Parent = Frame_3
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "ContentsList"
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.Parent = Frame_4
    local Frame_5 = Instance.new("Frame")
    Frame_5.Name = "PaddingLeft"
    Frame_5.LayoutOrder = 1
    Frame_5.ZIndex = 5
    Frame_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_5.BackgroundTransparency = 1
    Frame_5.BorderSizePixel = 0
    Frame_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame_5.Parent = Frame_4
    local Frame_6 = Instance.new("Frame")
    Frame_6.Name = "PaddingCenter"
    Frame_6.LayoutOrder = 3
    Frame_6.ZIndex = 5
    Frame_6.Size = UDim2.new(0, 0, 1, 0)
    Frame_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_6.BackgroundTransparency = 1
    Frame_6.BorderSizePixel = 0
    Frame_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame_6.Parent = Frame_4
    local Frame_7 = Instance.new("Frame")
    Frame_7.Name = "PaddingRight"
    Frame_7.LayoutOrder = 5
    Frame_7.ZIndex = 5
    Frame_7.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_7.BackgroundTransparency = 1
    Frame_7.BorderSizePixel = 0
    Frame_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame_7.Parent = Frame_4
    local Frame_8 = Instance.new("Frame")
    Frame_8.Name = "IconLabelContainer"
    Frame_8.LayoutOrder = 4
    Frame_8.ZIndex = 3
    Frame_8.AnchorPoint = Vector2.new(0, 0.5)
    Frame_8.Size = UDim2.new(0, 0, 0.5, 0)
    Frame_8.BackgroundTransparency = 1
    Frame_8.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame_8.Parent = Frame_4
    local TextLabel = Instance.new("TextLabel")
    local v7 = workspace.CurrentCamera.ViewportSize.X + 200
    TextLabel.Name = "IconLabel"
    TextLabel.LayoutOrder = 4
    TextLabel.ZIndex = 15
    TextLabel.AnchorPoint = Vector2.new(0, 0)
    TextLabel.Size = UDim2.new(0, v7, 1, 0)
    TextLabel.ClipsDescendants = false
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.fromScale(0, 0)
    TextLabel.RichText = true
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Text = ""
    TextLabel.TextWrapped = true
    TextLabel.TextWrap = true
    TextLabel.TextScaled = false
    TextLabel.Active = false
    TextLabel.AutoLocalize = true
    TextLabel.Parent = Frame_8
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "IconImage"
    ImageLabel.LayoutOrder = 2
    ImageLabel.ZIndex = 15
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.Size = UDim2.new(0, 0, 0.5, 0)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 11, 0.5, 0)
    ImageLabel.ScaleType = Enum.ScaleType.Stretch
    ImageLabel.Active = false
    ImageLabel.Parent = Frame_4
    local v8 = UICorner:Clone()
    v8:SetAttribute("Collective", nil)
    v8.CornerRadius = UDim.new(0, 0)
    v8.Name = "IconImageCorner"
    v8.Parent = ImageLabel
    local TweenService = game:GetService("TweenService")
    local v9 = 0

    local function handleLabelAndImageChangesUnstaggered(v10) -- line 195 | captures: v9, v1, v2, Frame, Frame_2, v5, MenuUIListLayout, MenuGap, Frame_3, TextButton, Frame_4, UIListLayout, Frame_5, Frame_6, Frame_7, Frame_8, TextLabel, v7, ImageLabel, TweenService
        task.defer(function() -- line 202 | captures: v9, v1, v2, Frame, Frame_2, v5, MenuUIListLayout, MenuGap, Frame_3, TextButton, Frame_4, UIListLayout, Frame_5, Frame_6, Frame_7, Frame_8, TextLabel, v7, ImageLabel, TweenService
            local indicator = v1.indicator
            local v11 = indicator and indicator.Visible
            local v12 = v11 or TextLabel.Text ~= ""
            local v13 = if ImageLabel.Image == "" then false else ImageLabel.Image ~= nil
            local Center = Enum.HorizontalAlignment.Center
            local v14 = UDim2.fromScale(1, 1)
            if not v13 or v12 then
                if v13 or not v12 then
                    if v13 and v12 then
                        Frame_8.Visible = true
                        ImageLabel.Visible = true
                        Frame_5.Visible = true
                        Frame_6.Visible = not v11
                        Frame_7.Visible = not v11
                        local Left = Enum.HorizontalAlignment.Left
                    end
                else
                    Frame_8.Visible = true
                    ImageLabel.Visible = false
                    Frame_5.Visible = true
                    Frame_6.Visible = false
                    Frame_7.Visible = true
                end
            else
                Frame_8.Visible = false
                ImageLabel.Visible = true
                Frame_5.Visible = false
                Frame_6.Visible = false
                Frame_7.Visible = false
            end
            Frame_2.Size = v14

            local function getItemWidth(v15) -- line 232
                return v15:GetAttribute("TargetWidth") or v15.AbsoluteSize.X
            end

            local Offset = UIListLayout.Padding.Offset
            local X = TextLabel.TextBounds.X
            Frame_8.Size = UDim2.new(0, X, TextLabel.Size.Y.Scale, 0)
            local v16 = Offset
            for v17, v18 in pairs(Frame_4:GetChildren()) do
                if v18:IsA("GuiObject") and v18.Visible == true then
                    v16 += (v18:GetAttribute("TargetWidth") or v18.AbsoluteSize.X) + Offset
                end
            end
            local MinimumWidth = Frame:GetAttribute("MinimumWidth")
            local MinimumHeight = Frame:GetAttribute("MinimumHeight")
            local BorderSize = Frame:GetAttribute("BorderSize")
            local v19 = math.clamp(v16, MinimumWidth, v7)
            local v20 = #v1.menuIcons > 0 and v1.isSelected
            local v21
            if v20 then
                local v22 = 0
                for v23, v24 in pairs(v5:GetChildren()) do
                    if v24 ~= Frame_3 and v24:IsA("GuiObject") and v24.Visible then
                        v22 += (v24:GetAttribute("TargetWidth") or v24.AbsoluteSize.X) + MenuUIListLayout.Padding.Offset
                    end
                end
                local v25 = if Frame_3.Visible then v19 else v19 - ((Frame_3:GetAttribute("TargetWidth") or Frame_3.AbsoluteSize.X) + MenuUIListLayout.Padding.Offset * 2 + BorderSize)
                v21 = v22 - BorderSize * 0.5
                v19 = v25 + (v21 - BorderSize * 0.75)
            else
                v21 = 0
            end
            MenuGap.Visible = v20 and Frame_3.Visible
            local DesiredWidth = Frame:GetAttribute("DesiredWidth")
            if not (DesiredWidth and v19 < DesiredWidth) then
                DesiredWidth = v19
            end
            v1.updateMenu:Fire()
            local v26 = DesiredWidth - v21
            local v27 = math.max(v26, MinimumWidth) - BorderSize * 2
            local MenuWidth = v5:GetAttribute("MenuWidth")
            local v28 = MenuWidth and MenuWidth + v27 + MenuUIListLayout.Padding.Offset + 10
            if v28 then
                local MaxWidth = v5:GetAttribute("MaxWidth")
                if MaxWidth then
                    v28 = math.max(MaxWidth, MinimumWidth)
                end
                v5:SetAttribute("MenuCanvasWidth", DesiredWidth)
                if not (v28 < DesiredWidth) then
                    v28 = DesiredWidth
                end
            else
                v28 = DesiredWidth
            end
            local Quint = Enum.EasingStyle.Quint
            local Out = Enum.EasingDirection.Out
            local v29 = Frame_3:GetAttribute("TargetWidth") or Frame_3.AbsoluteSize.X
            local X_2 = Frame_3.AbsoluteSize.X
            local v30 = math.max(v27, v29, X_2)
            local v31 = Frame:GetAttribute("TargetWidth") or Frame.AbsoluteSize.X
            local X_3 = Frame.AbsoluteSize.X
            local v32 = math.max(v28, v31, X_3)
            local v33 = TweenInfo.new(v30 / 750, Quint, Out)
            local v34 = TweenInfo.new(v32 / 750, Quint, Out)
            TweenService:Create(Frame_3, v33, {
                Position = UDim2.new(0, BorderSize, 0.5, 0),
                Size = UDim2.new(0, v27, 1, -BorderSize * 2)
            }):Play()
            TweenService:Create(TextButton, v33, { Size = UDim2.new(0, v27, 1, 0) }):Play()
            local v35 = UDim2.fromOffset(v28, MinimumHeight)
            if Frame.Size.Y.Offset ~= MinimumHeight then
                Frame.Size = v35
            end
            Frame:SetAttribute("TargetWidth", v35.X.Offset)
            TweenService:Create(Frame, v34, { Size = v35 }):Play()
            v9 += 1
            local v36 = v34.Time * 100
            for v37 = 1, v36 do
                task.delay(v37 / 100, function() -- line 314 | captures: v1, v2
                    v2.iconChanged:Fire(v1)
                end)
            end
            task.delay(v34.Time - 0.2, function() -- line 318 | captures: v9, v1
                v9 -= 1
                task.defer(function() -- line 320 | captures: v9, v1
                    if v9 == 0 then
                        v1.resizingComplete:Fire()
                    end
                end)
            end)
            v1:updateParent()
        end)
    end

    local v38 = require(script.Parent.Parent.Utility).createStagger(0.01, handleLabelAndImageChangesUnstaggered)
    local v39 = true
    v1:setBehaviour("IconLabel", "Text", v38)
    v1:setBehaviour("IconLabel", "FontFace", function(v40) -- line 333 | captures: v39, TextLabel, v38
        if TextLabel.FontFace ~= v40 then
            task.spawn(function() -- line 338 | captures: v39, v38
                v38()
                if v39 then
                    v39 = false
                    for v41 = 1, 10 do
                        task.wait(1)
                        v38()
                    end
                end
            end)
        end
    end)

    local function updateBorderSize() -- line 360 | captures: v1, Frame, v5, MenuUIListLayout, MenuGap, Frame_3, v38
        task.defer(function() -- line 361 | captures: v1, Frame, v5, MenuUIListLayout, MenuGap, Frame_3, v38
            local BorderSize = Frame:GetAttribute("BorderSize")
            local alignment = v1.alignment
            local v42 = if Frame_3.Visible == false then 0 else alignment == "Right" and -BorderSize or BorderSize
            v5.Position = UDim2.new(0, v42, 0, 0)
            MenuGap.Size = UDim2.fromOffset(BorderSize, 0)
            MenuUIListLayout.Padding = UDim.new(0, 0)
            v38()
        end)
    end

    v1:setBehaviour("Widget", "BorderSize", updateBorderSize)
    v1:setBehaviour("IconSpot", "Visible", updateBorderSize)
    v1.startMenuUpdate:Connect(v38)
    v1.updateSize:Connect(v38)
    v1:setBehaviour("ContentsList", "HorizontalAlignment", v38)
    v1:setBehaviour("Widget", "Visible", v38)
    v1:setBehaviour("Widget", "DesiredWidth", v38)
    v1:setBehaviour("Widget", "MinimumWidth", v38)
    v1:setBehaviour("Widget", "MinimumHeight", v38)
    v1:setBehaviour("Indicator", "Visible", v38)
    v1:setBehaviour("IconImageRatio", "AspectRatio", v38)
    v1:setBehaviour("IconImage", "Image", function(v43) -- line 382 | captures: ImageLabel, v38
        local v44 = tonumber(v43) and "http://www.roblox.com/asset/?id=" .. v43 or v43 or ""
        if ImageLabel.Image ~= v44 then
            v38()
        end
        return v44
    end)
    v1.alignmentChanged:Connect(function(v45) -- line 389 | captures: v1, Frame, v5, MenuUIListLayout, MenuGap, Frame_3, v38
        local v46 = if v45 == "Center" then "Left" else v45
        MenuUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment[v46]
        task.defer(function() -- line 361 | captures: v1, Frame, v5, MenuUIListLayout, MenuGap, Frame_3, v38
            local BorderSize = Frame:GetAttribute("BorderSize")
            local alignment = v1.alignment
            local v47 = if Frame_3.Visible == false then 0 else alignment == "Right" and -BorderSize or BorderSize
            v5.Position = UDim2.new(0, v47, 0, 0)
            MenuGap.Size = UDim2.fromOffset(BorderSize, 0)
            MenuUIListLayout.Padding = UDim.new(0, 0)
            v38()
        end)
    end)
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local LocaleId = LocalPlayer.LocaleId
    v1.janitor:add(LocalPlayer:GetPropertyChangedSignal("LocaleId"):Connect(function() -- line 401 | captures: LocaleId, v1, LocalPlayer
        task.delay(0.2, function() -- line 402 | captures: LocaleId, v1, LocalPlayer
            local LocaleId_2 = LocalPlayer.LocaleId
            if LocaleId_2 == LocaleId then
                return
            end
            LocaleId = LocaleId_2
            v1:refresh()
            task.wait(0.5)
            v1:refresh()
        end)
    end))
    local NumberValue = Instance.new("NumberValue")
    NumberValue.Name = "IconImageScale"
    NumberValue.Parent = ImageLabel
    NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line 416 | captures: ImageLabel, NumberValue
        ImageLabel.Size = UDim2.new(NumberValue.Value, 0, NumberValue.Value, 0)
    end)
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint.Name = "IconImageRatio"
    UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
    UIAspectRatioConstraint.Parent = ImageLabel
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Name = "IconGradient"
    UIGradient.Enabled = true
    UIGradient.Parent = Frame_2
    local UIGradient_2 = Instance.new("UIGradient")
    UIGradient_2.Name = "IconSpotGradient"
    UIGradient_2.Enabled = true
    UIGradient_2.Parent = Frame_3
    return Frame
end
