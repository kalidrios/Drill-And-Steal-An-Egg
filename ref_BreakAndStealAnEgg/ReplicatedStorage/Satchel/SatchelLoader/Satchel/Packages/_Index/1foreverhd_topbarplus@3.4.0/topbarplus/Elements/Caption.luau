-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = Color3.fromRGB(39, 41, 48)
return function(v2) -- line 3 | captures: v1
    local ClickRegion = v2:getInstance("ClickRegion")
    local CanvasGroup = Instance.new("CanvasGroup")
    CanvasGroup.Name = "Caption"
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0)
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.BorderSizePixel = 0
    CanvasGroup.GroupTransparency = 1
    CanvasGroup.Position = UDim2.fromOffset(0, 0)
    CanvasGroup.Visible = true
    CanvasGroup.ZIndex = 30
    CanvasGroup.Parent = ClickRegion
    local Frame = Instance.new("Frame")
    Frame.Name = "Box"
    Frame.AutomaticSize = Enum.AutomaticSize.XY
    Frame.BackgroundColor3 = v1
    Frame.Position = UDim2.fromOffset(4, 7)
    Frame.ZIndex = 12
    Frame.Parent = CanvasGroup
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Header"
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TextLabel.Text = "Caption"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 15
    TextLabel.TextTruncate = Enum.TextTruncate.None
    TextLabel.TextWrapped = false
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.BackgroundTransparency = 1
    TextLabel.LayoutOrder = 1
    TextLabel.Size = UDim2.fromOffset(0, 16)
    TextLabel.ZIndex = 18
    TextLabel.Parent = Frame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "Layout"
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "CaptionCorner"
    UICorner.Parent = Frame
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "Padding"
    UIPadding.PaddingBottom = UDim.new(0, 12)
    UIPadding.PaddingLeft = UDim.new(0, 12)
    UIPadding.PaddingRight = UDim.new(0, 12)
    UIPadding.PaddingTop = UDim.new(0, 12)
    UIPadding.Parent = Frame
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "Hotkeys"
    Frame_2.AutomaticSize = Enum.AutomaticSize.Y
    Frame_2.BackgroundTransparency = 1
    Frame_2.LayoutOrder = 3
    Frame_2.Size = UDim2.fromScale(1, 0)
    Frame_2.Visible = false
    Frame_2.Parent = Frame
    local UIListLayout_2 = Instance.new("UIListLayout")
    UIListLayout_2.Name = "Layout1"
    UIListLayout_2.Padding = UDim.new(0, 6)
    UIListLayout_2.FillDirection = Enum.FillDirection.Vertical
    UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout_2.HorizontalFlex = Enum.UIFlexAlignment.None
    UIListLayout_2.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    UIListLayout_2.VerticalFlex = Enum.UIFlexAlignment.None
    UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_2.Parent = Frame_2
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "Key1"
    ImageLabel.Image = "rbxasset://textures/ui/Controls/key_single.png"
    ImageLabel.ImageTransparency = 0.7
    ImageLabel.ScaleType = Enum.ScaleType.Slice
    ImageLabel.SliceCenter = Rect.new(5, 5, 23, 24)
    ImageLabel.AutomaticSize = Enum.AutomaticSize.X
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.LayoutOrder = 1
    ImageLabel.Size = UDim2.fromOffset(0, 30)
    ImageLabel.ZIndex = 15
    ImageLabel.Parent = Frame_2
    local UIPadding_2 = Instance.new("UIPadding")
    UIPadding_2.Name = "Inset"
    UIPadding_2.PaddingLeft = UDim.new(0, 8)
    UIPadding_2.PaddingRight = UDim.new(0, 8)
    UIPadding_2.Parent = ImageLabel
    local TextLabel_2 = Instance.new("TextLabel")
    TextLabel_2.AutoLocalize = false
    TextLabel_2.Name = "LabelContent"
    TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TextLabel_2.Text = ""
    TextLabel_2.TextColor3 = Color3.fromRGB(189, 190, 190)
    TextLabel_2.TextSize = 15
    TextLabel_2.AutomaticSize = Enum.AutomaticSize.X
    TextLabel_2.BackgroundTransparency = 1
    TextLabel_2.Position = UDim2.fromOffset(0, -1)
    TextLabel_2.Size = UDim2.fromScale(1, 1)
    TextLabel_2.ZIndex = 16
    TextLabel_2.Parent = ImageLabel
    local ImageLabel_2 = Instance.new("ImageLabel")
    ImageLabel_2.Name = "Caret"
    ImageLabel_2.Image = "rbxassetid://101906294438076"
    ImageLabel_2.ImageColor3 = v1
    ImageLabel_2.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel_2.BackgroundTransparency = 1
    ImageLabel_2.Position = UDim2.new(0, 0, 0, 4)
    ImageLabel_2.Size = UDim2.fromOffset(16, 8)
    ImageLabel_2.ZIndex = 12
    ImageLabel_2.Parent = CanvasGroup
    local ImageLabel_3 = Instance.new("ImageLabel")
    ImageLabel_3.Visible = true
    ImageLabel_3.Name = "DropShadow"
    ImageLabel_3.Image = "rbxassetid://124920646932671"
    ImageLabel_3.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel_3.ImageTransparency = 0.45
    ImageLabel_3.ScaleType = Enum.ScaleType.Slice
    ImageLabel_3.SliceCenter = Rect.new(12, 12, 13, 13)
    ImageLabel_3.BackgroundTransparency = 1
    ImageLabel_3.Position = UDim2.fromOffset(0, 5)
    ImageLabel_3.Size = UDim2.new(1, 0, 0, 48)
    ImageLabel_3.Parent = CanvasGroup
    Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line 145 | captures: Frame, ImageLabel_3
        ImageLabel_3.Size = UDim2.new(1, 0, 0, Frame.AbsoluteSize.Y + 8)
    end)
    local captionJanitor = v2.captionJanitor
    local v3, v4 = v2:clipOutside(CanvasGroup)
    v4.AutomaticSize = Enum.AutomaticSize.None

    local function matchSize() -- line 155 | captures: CanvasGroup, v4
        local AbsoluteSize = CanvasGroup.AbsoluteSize
        v4.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
    end

    captionJanitor:add(CanvasGroup:GetPropertyChangedSignal("AbsoluteSize"):Connect(matchSize))
    local AbsoluteSize = CanvasGroup.AbsoluteSize
    v4.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
    local v5 = false
    local Header = CanvasGroup.Box.Header
    local UserInputService = game:GetService("UserInputService")

    local function updateHotkey(v6) -- line 168 | captures: v2, CanvasGroup, Frame_2, TextLabel_2, Header, UserInputService
        local KeyboardEnabled = UserInputService.KeyboardEnabled
        local v7 = CanvasGroup:GetAttribute("CaptionText") or ""
        local v8 = v7 == "_hotkey_"
        if KeyboardEnabled or not v8 then
            Header.Text = v7
            Header.Visible = not v8
            if v6 then
                TextLabel_2.Text = v6.Name
                Frame_2.Visible = true
            end
            if not KeyboardEnabled then
                Frame_2.Visible = false
            end
        else
            v2:setCaption()
        end
    end

    CanvasGroup:GetAttributeChangedSignal("CaptionText"):Connect(updateHotkey)
    local Quad = Enum.EasingStyle.Quad
    local v9 = TweenInfo.new(0.2, Quad, Enum.EasingDirection.In)
    local v10 = TweenInfo.new(0.2, Quad, Enum.EasingDirection.Out)
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")

    local function getCaptionPosition(v11) -- line 194 | captures: v5
        local v12 = if v11 == nil then v5 else v11
        local v13 = if v12 then 10 else 2
        return UDim2.new(0.5, 0, 1, v13)
    end

    local function updatePosition(v14) -- line 201 | captures: v5, ClickRegion, CanvasGroup, ImageLabel_2, v4, v9, v10, TweenService, RunService
        if not v5 then
            return
        end
        local v15 = if v14 == nil then v5 else v14
        local v16 = not v15
        if v16 == nil then
            v16 = v5
        end
        local v17 = if v16 then 10 else 2
        local v18 = UDim2.new(0.5, 0, 1, v17)
        local v19 = if v15 == nil then v5 else v15
        local v20 = if v19 then 10 else 2
        local v21 = UDim2.new(0.5, 0, 1, v20)
        if v15 then
            local Offset = ImageLabel_2.Position.Y.Offset
            ImageLabel_2.Position = UDim2.fromOffset(0, Offset)
            CanvasGroup.AutomaticSize = Enum.AutomaticSize.XY
            CanvasGroup.Size = UDim2.fromOffset(32, 53)
        else
            local AbsoluteSize = CanvasGroup.AbsoluteSize
            CanvasGroup.AutomaticSize = Enum.AutomaticSize.Y
            CanvasGroup.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
        end
        local v22

        local function updateCaret() -- line 230 | captures: v22, ClickRegion, CanvasGroup, ImageLabel_2
            local v23 = ClickRegion.AbsolutePosition.X - CanvasGroup.AbsolutePosition.X + ClickRegion.AbsoluteSize.X / 2 - ImageLabel_2.AbsoluteSize.X / 2
            local Offset = ImageLabel_2.Position.Y.Offset
            local v24 = UDim2.fromOffset(v23, Offset)
            if v22 ~= v23 then
                v22 = v23
                ImageLabel_2.Position = UDim2.fromOffset(0, Offset)
                task.wait()
            end
            ImageLabel_2.Position = v24
        end

        v4.Position = v18
        updateCaret()
        local v25 = v15 and v9 or v10
        local v26 = TweenService:Create(v4, v25, { Position = v21 })
        local v27 = RunService.Heartbeat:Connect(updateCaret)
        v26:Play()
        v26.Completed:Once(function() -- line 253 | captures: v27
            v27:Disconnect()
        end)
    end

    captionJanitor:add(ClickRegion:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line 258 | captures: updatePosition
        updatePosition()
    end))
    updatePosition(false)
    captionJanitor:add(v2.toggleKeyAdded:Connect(updateHotkey))
    for v28, v29 in pairs(v2.bindedToggleKeys) do
        local KeyboardEnabled = UserInputService.KeyboardEnabled
        local v30 = CanvasGroup:GetAttribute("CaptionText") or ""
        local v31 = v30 == "_hotkey_"
        local v32
        if KeyboardEnabled then
            Header.Text = v30
            Header.Visible = not v31
            if v28 then
                TextLabel_2.Text = v28.Name
                Frame_2.Visible = true
            end
            v32 = false
        elseif v31 then
            v32 = true
        else
            Header.Text = v30
            Header.Visible = not v31
            if v28 then
                TextLabel_2.Text = v28.Name
                Frame_2.Visible = true
            end
            v32 = false
        end
        if v32 then
            v2:setCaption()
        elseif not KeyboardEnabled then
            Frame_2.Visible = false
        end
        break
    end
    captionJanitor:add(v2.fakeToggleKeyChanged:Connect(updateHotkey))
    local fakeToggleKey = v2.fakeToggleKey
    if fakeToggleKey then
        local KeyboardEnabled = UserInputService.KeyboardEnabled
        local v33 = CanvasGroup:GetAttribute("CaptionText") or ""
        local v34 = v33 == "_hotkey_"
        local v35
        if KeyboardEnabled then
            Header.Text = v33
            Header.Visible = not v34
            TextLabel_2.Text = fakeToggleKey.Name
            Frame_2.Visible = true
            v35 = false
        elseif v34 then
            v35 = true
        else
            Header.Text = v33
            Header.Visible = not v34
            TextLabel_2.Text = fakeToggleKey.Name
            Frame_2.Visible = true
            v35 = false
        end
        if v35 then
            v2:setCaption()
        elseif not KeyboardEnabled then
            Frame_2.Visible = false
        end
    end

    local function setCaptionEnabled(v36) -- line 274 | captures: v5, v2, CanvasGroup, Frame_2, v4, Header, UserInputService, v9, v10, TweenService, updatePosition
        if v5 == v36 then
            return
        end
        local joinedFrame = v2.joinedFrame
        local v37 = if joinedFrame and string.match(joinedFrame.Name, "Dropdown") then false else v36
        v5 = v37
        local v38, v39
        if v37 then
            v39 = 0
            v38 = v9
        else
            v39 = 1
        end
        if not v37 or not v38 then
            v38 = v10
        end
        TweenService:Create(CanvasGroup, v38, { GroupTransparency = v39 }):Play()
        if v37 then
            v4:SetAttribute("ForceUpdate", true)
        end
        updatePosition()
        local KeyboardEnabled = UserInputService.KeyboardEnabled
        local v40 = CanvasGroup:GetAttribute("CaptionText") or ""
        local v41 = v40 == "_hotkey_"
        if KeyboardEnabled or not v41 then
            Header.Text = v40
            Header.Visible = not v41
            if not KeyboardEnabled then
                Frame_2.Visible = false
            end
        else
            v2:setCaption()
        end
    end

    local iconModule = require(v2.iconModule)
    captionJanitor:add(v2.stateChanged:Connect(function(v42) -- line 299 | captures: v2, setCaptionEnabled, iconModule
        if v42 == "Viewing" then
            local captionLastClosedClock = iconModule.captionLastClosedClock
            local v43 = if (captionLastClosedClock and os.clock() - captionLastClosedClock or 999) < 0.3 then 0 else 0.5
            task.delay(v43, function() -- line 304 | captures: v2, setCaptionEnabled
                if v2.activeState == "Viewing" then
                    setCaptionEnabled(true)
                end
            end)
        else
            iconModule.captionLastClosedClock = os.clock()
            setCaptionEnabled(false)
        end
    end))
    return CanvasGroup
end
