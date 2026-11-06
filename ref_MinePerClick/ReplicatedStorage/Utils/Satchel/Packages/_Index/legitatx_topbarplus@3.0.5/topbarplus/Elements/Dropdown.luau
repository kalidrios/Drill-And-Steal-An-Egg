-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ Line: 1 ]]
	local Dropdown = Instance.new("Frame")

	Dropdown.Name = "Dropdown"
	Dropdown.AutomaticSize = Enum.AutomaticSize.XY
	Dropdown.BackgroundTransparency = 1
	Dropdown.BorderSizePixel = 0
	Dropdown.AnchorPoint = Vector2.new(0.5, 0)
	Dropdown.Position = UDim2.new(0.5, 0, 1, 10)
	Dropdown.ZIndex = -2
	Dropdown.ClipsDescendants = true
	Dropdown.Parent = p1.widget

	local DropdownCorner = Instance.new("UICorner")

	DropdownCorner.Name = "DropdownCorner"
	DropdownCorner.CornerRadius = UDim.new(0, 10)
	DropdownCorner.Parent = Dropdown

	local DropdownScroller = Instance.new("ScrollingFrame")

	DropdownScroller.Name = "DropdownScroller"
	DropdownScroller.AutomaticSize = Enum.AutomaticSize.X
	DropdownScroller.BackgroundTransparency = 1
	DropdownScroller.BorderSizePixel = 0
	DropdownScroller.AnchorPoint = Vector2.new(0, 0)
	DropdownScroller.Position = UDim2.new(0, 0, 0, 0)
	DropdownScroller.ZIndex = -1
	DropdownScroller.ClipsDescendants = true
	DropdownScroller.Visible = true
	DropdownScroller.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	DropdownScroller.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	DropdownScroller.Active = false
	DropdownScroller.ScrollingEnabled = true
	DropdownScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
	DropdownScroller.ScrollBarThickness = 5
	DropdownScroller.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	DropdownScroller.ScrollBarImageTransparency = 0.8
	DropdownScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
	DropdownScroller.Selectable = false
	DropdownScroller.Active = true
	DropdownScroller.Parent = Dropdown

	local DropdownPadding = Instance.new("UIPadding")

	DropdownPadding.Name = "DropdownPadding"
	DropdownPadding.PaddingTop = UDim.new(0, 8)
	DropdownPadding.PaddingBottom = UDim.new(0, 8)
	DropdownPadding.Parent = DropdownScroller

	local DropdownList = Instance.new("UIListLayout")

	DropdownList.Name = "DropdownList"
	DropdownList.FillDirection = Enum.FillDirection.Vertical
	DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
	DropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	DropdownList.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly
	DropdownList.Parent = DropdownScroller

	local dropdownJanitor = p1.dropdownJanitor
	local iconModule = require(p1.iconModule)

	p1.dropdownChildAdded:Connect(function(p1) --[[ Line: 58 ]]
		local _, v1 = p1:modifyTheme({
			{ "Widget", "BorderSize", 0 },
			{ "IconCorners", "CornerRadius", UDim.new(0, 4) },
			{ "Widget", "MinimumWidth", 190 },
			{ "Widget", "MinimumHeight", 56 },
			{ "IconLabel", "TextSize", 19 },
			{ "PaddingLeft", "Size", UDim2.fromOffset(25, 0) },
			{ "Notice", "Position", UDim2.new(1, -24, 0, 5) },
			{ "ContentsList", "HorizontalAlignment", Enum.HorizontalAlignment.Left },
			{ "Selection", "Size", UDim2.new(1, -8, 1, -8) },
			{ "Selection", "Position", UDim2.new(0, 4, 0, 4) }
		})

		task.defer(function() --[[ Line: 72 | Upvalues: p1 (copy), v1 (copy) ]]
			p1.joinJanitor:add(function() --[[ Line: 73 | Upvalues: p1 (ref), v1 (ref) ]]
				p1:removeModification(v1)
			end)
		end)
	end)
	p1.dropdownSet:Connect(function(p12) --[[ Line: 78 | Upvalues: p1 (copy), iconModule (copy) ]]
		for k, v in pairs(p1.dropdownIcons) do
			iconModule.getIconByUID(v):destroy()
		end

		if type(p12) ~= "table" then
			return
		end

		for k, v in pairs(p12) do
			v:joinDropdown(p1)
		end
	end)

	local Utility = require(script.Parent.Parent.Utility)

	local function updateVisibility() --[[ updateVisibility | Line: 95 | Upvalues: Utility (copy), Dropdown (copy), p1 (copy) ]]
		Utility.setVisible(Dropdown, p1.isSelected, "InternalDropdown")
	end

	dropdownJanitor:add(p1.toggled:Connect(updateVisibility))
	Utility.setVisible(Dropdown, p1.isSelected, "InternalDropdown")

	local v1 = 0
	local v2 = false

	local function v3() --[[ updateMaxIcons | Line: 107 | Upvalues: v1 (ref), v2 (ref), v3 (copy), Dropdown (copy), DropdownScroller (copy), iconModule (copy), p1 (copy), DropdownPadding (copy) ]]
		v1 = v1 + 1

		if v2 then
			return
		end

		local v12 = v1

		v2 = true
		task.defer(function() --[[ Line: 116 | Upvalues: v2 (ref), v1 (ref), v12 (copy), v3 (ref) ]]
			v2 = false

			if v1 == v12 then
				return
			end

			v3()
		end)

		local v22 = Dropdown:GetAttribute("MaxIcons")

		if not v22 then
			return
		end

		local t = {}

		for k, v in pairs(DropdownScroller:GetChildren()) do
			if v:IsA("GuiObject") then
				table.insert(t, { v, v.AbsolutePosition.Y })
			end
		end

		table.sort(t, function(p1, p2) --[[ Line: 133 ]]
			return p1[2] < p2[2]
		end)

		local sum = 0
		local v32 = false

		for i = 1, v22 do
			local v4
			local v5 = t[i]

			if not v5 then
				break
			end

			local v6 = v5[1]

			sum = sum + v6.AbsoluteSize.Y

			local v7 = v6:GetAttribute("WidgetUID")
			local v8 = if v7 then iconModule.getIconByUID(v7) else v7

			if v8 then
				if v32 then
					v4 = nil
				else
					v4, v32 = p1:getInstance("ClickRegion"), true
				end

				v8:getInstance("ClickRegion").NextSelectionUp = v4
			end
		end

		DropdownScroller.Size = UDim2.fromOffset(0, sum + DropdownPadding.PaddingTop.Offset + DropdownPadding.PaddingBottom.Offset)
	end

	dropdownJanitor:add(DropdownScroller:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v3))
	dropdownJanitor:add(DropdownScroller.ChildAdded:Connect(v3))
	dropdownJanitor:add(DropdownScroller.ChildRemoved:Connect(v3))
	dropdownJanitor:add(Dropdown:GetAttributeChangedSignal("MaxIcons"):Connect(v3))
	dropdownJanitor:add(p1.childThemeModified:Connect(v3))
	v3()

	return Dropdown
end