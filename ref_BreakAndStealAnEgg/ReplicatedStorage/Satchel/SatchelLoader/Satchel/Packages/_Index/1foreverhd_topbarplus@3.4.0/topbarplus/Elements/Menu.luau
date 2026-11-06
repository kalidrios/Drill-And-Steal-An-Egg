-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return function(v1) -- line 1
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "Menu"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Visible = true
    ScrollingFrame.ZIndex = 1
    ScrollingFrame.Size = UDim2.fromScale(1, 1)
    ScrollingFrame.ClipsDescendants = true
    ScrollingFrame.TopImage = ""
    ScrollingFrame.BottomImage = ""
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1, -1)
    ScrollingFrame.ScrollingEnabled = true
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
    ScrollingFrame.ZIndex = 20
    ScrollingFrame.ScrollBarThickness = 3
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.ScrollBarImageTransparency = 0.8
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Selectable = false
    local iconModule = require(v1.iconModule)
    local v2 = iconModule.container.TopbarStandard:FindFirstChild("UIListLayout", true):Clone()
    v2.Name = "MenuUIListLayout"
    v2.VerticalAlignment = Enum.VerticalAlignment.Center
    v2.Parent = ScrollingFrame
    local Frame = Instance.new("Frame")
    Frame.Name = "MenuGap"
    Frame.BackgroundTransparency = 1
    Frame.Visible = false
    Frame.AnchorPoint = Vector2.new(0, 0.5)
    Frame.ZIndex = 5
    Frame.Parent = ScrollingFrame
    local v3 = false
    local Themes = require(script.Parent.Parent.Features.Themes)

    local function totalChildrenChanged() -- line 39 | captures: v3, v1, ScrollingFrame, v2, Themes
        local menuJanitor = v1.menuJanitor
        local v4 = #v1.menuIcons
        if v3 then
            if v4 <= 0 then
                menuJanitor:clean()
                v3 = false
            end
        else
            v3 = true
            menuJanitor:add(v1.toggled:Connect(function() -- line 53 | captures: v1
                if #v1.menuIcons > 0 then
                    v1.updateSize:Fire()
                end
            end))
            local v5, v6 = v1:modifyTheme({ { "Menu", "Active", true } })
            task.defer(function() -- line 63 | captures: menuJanitor, v6, v1
                menuJanitor:add(function() -- line 64 | captures: v6, v1
                    v1:removeModification(v6)
                end)
            end)
            local X = ScrollingFrame.AbsoluteCanvasSize.X

            local function rightAlignCanvas() -- line 73 | captures: X, v1, ScrollingFrame
                if v1.alignment ~= "Right" then
                    return
                end
                local X_2 = ScrollingFrame.AbsoluteCanvasSize.X
                local v7 = X - X_2
                X = X_2
                ScrollingFrame.CanvasPosition = Vector2.new(ScrollingFrame.CanvasPosition.X - v7, 0)
            end

            menuJanitor:add(v1.selected:Connect(rightAlignCanvas))
            menuJanitor:add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(rightAlignCanvas))
            local v8 = v1:getStateGroup()
            if Themes.getThemeValue(v8, "IconImage", "Image", "Deselected") == Themes.getThemeValue(v8, "IconImage", "Image", "Selected") then
                local v9 = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Light, Enum.FontStyle.Normal)
                v1:removeModificationWith("IconLabel", "Text", "Viewing")
                v1:removeModificationWith("IconLabel", "Image", "Viewing")
                v1:modifyTheme({
                    { "IconLabel", "FontFace", v9, "Selected" },
                    { "IconLabel", "Text", "X", "Selected" },
                    { "IconLabel", "TextSize", 20, "Selected" },
                    { "IconLabel", "TextStrokeTransparency", 0.8, "Selected" },
                    { "IconImage", "Image", "", "Selected" }
                })
            end
            local MenuGap = v1:getInstance("MenuGap")

            local function updateAlignent() -- line 104 | captures: MenuGap, v1
                local v10, v11
                if v1.alignment == "Right" then
                    v10 = 99999
                    v11 = 99998
                else
                    v10 = -99999
                    v11 = -99998
                end
                v1:modifyTheme({ "IconSpot", "LayoutOrder", v10 })
                MenuGap.LayoutOrder = v11
            end

            menuJanitor:add(v1.alignmentChanged:Connect(updateAlignent))
            local v12, v13
            if v1.alignment == "Right" then
                v12 = 99999
                v13 = 99998
            else
                v12 = -99999
                v13 = -99998
            end
            v1:modifyTheme({ "IconSpot", "LayoutOrder", v12 })
            MenuGap.LayoutOrder = v13
            ScrollingFrame:GetAttributeChangedSignal("MenuCanvasWidth"):Connect(function() -- line 120 | captures: ScrollingFrame
                local MenuCanvasWidth = ScrollingFrame:GetAttribute("MenuCanvasWidth")
                local Y = ScrollingFrame.CanvasSize.Y
                ScrollingFrame.CanvasSize = UDim2.new(0, MenuCanvasWidth, Y.Scale, Y.Offset)
            end)
            menuJanitor:add(v1.updateMenu:Connect(function() -- line 125 | captures: ScrollingFrame, v2
                local MaxIcons = ScrollingFrame:GetAttribute("MaxIcons")
                if not MaxIcons then
                    return
                end
                local v14 = {}
                for v15, v16 in pairs(ScrollingFrame:GetChildren()) do
                    if v16:GetAttribute("WidgetUID") and v16.Visible then
                        local v17 = {
                            v16,
                            v16.AbsolutePosition.X
                        }
                        table.insert(v14, v17)
                    end
                end
                table.sort(v14, function(v18, v19) -- line 137
                    return v18[2] < v19[2]
                end)
                local v20 = 0
                for v21 = 1, MaxIcons do
                    local v22 = v14[v21]
                    if not v22 then
                        break
                    end
                    v20 += v22[1].AbsoluteSize.X + v2.Padding.Offset
                end
                ScrollingFrame:SetAttribute("MenuWidth", v20)
            end))

            local function startMenuUpdate() -- line 152 | captures: v1
                task.delay(0.1, function() -- line 153 | captures: v1
                    v1.startMenuUpdate:Fire()
                end)
            end

            menuJanitor:add(ScrollingFrame.ChildAdded:Connect(startMenuUpdate))
            menuJanitor:add(ScrollingFrame.ChildRemoved:Connect(startMenuUpdate))
            menuJanitor:add(ScrollingFrame:GetAttributeChangedSignal("MaxIcons"):Connect(startMenuUpdate))
            menuJanitor:add(ScrollingFrame:GetAttributeChangedSignal("MaxWidth"):Connect(startMenuUpdate))
            task.delay(0.1, function() -- line 153 | captures: v1
                v1.startMenuUpdate:Fire()
            end)
        end
    end

    v1.menuChildAdded:Connect(totalChildrenChanged)
    v1.menuSet:Connect(function(v23) -- line 165 | captures: v1, iconModule
        for v24, v25 in pairs(v1.menuIcons) do
            iconModule.getIconByUID(v25):destroy()
        end
        if type(v23) == "table" then
            for v26, v27 in pairs(v23) do
                v27:joinMenu(v1)
            end
        end
    end)
    return ScrollingFrame
end
