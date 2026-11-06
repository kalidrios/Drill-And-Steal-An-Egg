-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ Line: 1 ]]
	local Menu = Instance.new("ScrollingFrame")

	Menu.Name = "Menu"
	Menu.BackgroundTransparency = 1
	Menu.Visible = true
	Menu.ZIndex = 1
	Menu.Size = UDim2.fromScale(1, 1)
	Menu.ClipsDescendants = true
	Menu.TopImage = ""
	Menu.BottomImage = ""
	Menu.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
	Menu.CanvasSize = UDim2.new(0, 0, 1, -1)
	Menu.ScrollingEnabled = true
	Menu.ScrollingDirection = Enum.ScrollingDirection.X
	Menu.ZIndex = 20
	Menu.ScrollBarThickness = 3
	Menu.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	Menu.ScrollBarImageTransparency = 0.8
	Menu.BorderSizePixel = 0
	Menu.Selectable = false

	local iconModule = require(p1.iconModule)
	local MenuUIListLayout = iconModule.container.TopbarStandard:FindFirstChild("UIListLayout", true):Clone()

	MenuUIListLayout.Name = "MenuUIListLayout"
	MenuUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	MenuUIListLayout.Parent = Menu

	local MenuGap = Instance.new("Frame")

	MenuGap.Name = "MenuGap"
	MenuGap.BackgroundTransparency = 1
	MenuGap.Visible = false
	MenuGap.AnchorPoint = Vector2.new(0, 0.5)
	MenuGap.ZIndex = 5
	MenuGap.Parent = Menu

	local v1 = false
	local Themes = require(script.Parent.Parent.Features.Themes)

	local function totalChildrenChanged() --[[ totalChildrenChanged | Line: 39 | Upvalues: p1 (copy), v1 (ref), Menu (copy), Themes (copy), MenuUIListLayout (copy) ]]
		local menuJanitor = p1.menuJanitor
		local v12 = #p1.menuIcons

		if v1 then
			if not (v12 <= 0) then
				return
			end

			menuJanitor:clean()
			v1 = false
		else
			v1 = true
			menuJanitor:add(p1.toggled:Connect(function() --[[ Line: 53 | Upvalues: p1 (ref) ]]
				if not (#p1.menuIcons > 0) then
					return
				end

				p1.updateSize:Fire()
			end))

			local _, v2 = p1:modifyTheme({
				{ "Menu", "Active", true }
			})

			task.defer(function() --[[ Line: 63 | Upvalues: menuJanitor (copy), p1 (ref), v2 (copy) ]]
				menuJanitor:add(function() --[[ Line: 64 | Upvalues: p1 (ref), v2 (ref) ]]
					p1:removeModification(v2)
				end)
			end)

			local X = Menu.AbsoluteCanvasSize.X

			local function rightAlignCanvas() --[[ rightAlignCanvas | Line: 73 | Upvalues: p1 (ref), Menu (ref), X (ref) ]]
				if p1.alignment ~= "Right" then
					return
				end

				local X2 = Menu.AbsoluteCanvasSize.X
				local v1 = X - X2

				X = X2
				Menu.CanvasPosition = Vector2.new(Menu.CanvasPosition.X - v1, 0)
			end

			menuJanitor:add(p1.selected:Connect(rightAlignCanvas))
			menuJanitor:add(Menu:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(rightAlignCanvas))

			local v3 = p1:getStateGroup()

			if Themes.getThemeValue(v3, "IconImage", "Image", "Deselected") == Themes.getThemeValue(v3, "IconImage", "Image", "Selected") then
				local v4 = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Light, Enum.FontStyle.Normal)

				p1:removeModificationWith("IconLabel", "Text", "Viewing")
				p1:removeModificationWith("IconLabel", "Image", "Viewing")
				p1:modifyTheme({
					{ "IconLabel", "FontFace", v4, "Selected" },
					{ "IconLabel", "Text", "X", "Selected" },
					{ "IconLabel", "TextSize", 20, "Selected" },
					{ "IconLabel", "TextStrokeTransparency", 0.8, "Selected" },
					{ "IconImage", "Image", "", "Selected" }
				})
			end

			local v5 = p1:getInstance("MenuGap")

			local function updateAlignent() --[[ updateAlignent | Line: 104 | Upvalues: p1 (ref), v5 (copy) ]]
				local v1, v2

				if p1.alignment == "Right" then
					v1 = 99999
					v2 = 99998
				else
					v1 = -99999
					v2 = -99998
				end

				p1:modifyTheme({ "IconSpot", "LayoutOrder", v1 })
				v5.LayoutOrder = v2
			end

			menuJanitor:add(p1.alignmentChanged:Connect(updateAlignent))

			local v6, v7

			if p1.alignment == "Right" then
				v6 = 99999
				v7 = 99998
			else
				v6 = -99999
				v7 = -99998
			end

			p1:modifyTheme({ "IconSpot", "LayoutOrder", v6 })
			v5.LayoutOrder = v7
			Menu:GetAttributeChangedSignal("MenuCanvasWidth"):Connect(function() --[[ Line: 120 | Upvalues: Menu (ref) ]]
				local v1 = Menu:GetAttribute("MenuCanvasWidth")
				local Y = Menu.CanvasSize.Y

				Menu.CanvasSize = UDim2.new(0, v1, Y.Scale, Y.Offset)
			end)
			menuJanitor:add(p1.updateMenu:Connect(function() --[[ Line: 125 | Upvalues: Menu (ref), MenuUIListLayout (ref) ]]
				local v1 = Menu:GetAttribute("MaxIcons")

				if not v1 then
					return
				end

				local t = {}

				for k, v in pairs(Menu:GetChildren()) do
					if v:GetAttribute("WidgetUID") and v.Visible then
						table.insert(t, { v, v.AbsolutePosition.X })
					end
				end

				table.sort(t, function(p1, p2) --[[ Line: 137 ]]
					return p1[2] < p2[2]
				end)

				local sum = 0

				for i = 1, v1 do
					local v2 = t[i]

					if not v2 then
						break
					end

					sum = sum + (v2[1].AbsoluteSize.X + MenuUIListLayout.Padding.Offset)
				end

				Menu:SetAttribute("MenuWidth", sum)
			end))

			local function startMenuUpdate() --[[ startMenuUpdate | Line: 152 | Upvalues: p1 (ref) ]]
				task.delay(0.1, function() --[[ Line: 153 | Upvalues: p1 (ref) ]]
					p1.startMenuUpdate:Fire()
				end)
			end

			menuJanitor:add(Menu.ChildAdded:Connect(startMenuUpdate))
			menuJanitor:add(Menu.ChildRemoved:Connect(startMenuUpdate))
			menuJanitor:add(Menu:GetAttributeChangedSignal("MaxIcons"):Connect(startMenuUpdate))
			menuJanitor:add(Menu:GetAttributeChangedSignal("MaxWidth"):Connect(startMenuUpdate))
			task.delay(0.1, function() --[[ Line: 153 | Upvalues: p1 (ref) ]]
				p1.startMenuUpdate:Fire()
			end)
		end
	end

	p1.menuChildAdded:Connect(totalChildrenChanged)
	p1.menuSet:Connect(function(p12) --[[ Line: 165 | Upvalues: p1 (copy), iconModule (copy) ]]
		for k, v in pairs(p1.menuIcons) do
			iconModule.getIconByUID(v):destroy()
		end

		if type(p12) ~= "table" then
			return
		end

		for k, v in pairs(p12) do
			v:joinMenu(p1)
		end
	end)

	return Menu
end