-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Themes = require(script.Parent.Parent.Features.Themes)

return function(p1) --[[ Line: 5 | Upvalues: Themes (copy), TweenService (copy), RunService (copy) ]]
	local Dropdown = Instance.new("Frame")

	Dropdown.Name = "Dropdown"
	Dropdown.AutomaticSize = Enum.AutomaticSize.X
	Dropdown.BackgroundTransparency = 1
	Dropdown.BorderSizePixel = 0
	Dropdown.AnchorPoint = Vector2.new(0.5, 0)
	Dropdown.Position = UDim2.new(0.5, 0, 1, 10)
	Dropdown.ZIndex = -2
	Dropdown.ClipsDescendants = true
	Dropdown.Parent = p1.widget

	local GuiService = game:GetService("GuiService")

	p1:setBehaviour("Dropdown", "BackgroundTransparency", function(p1) --[[ Line: 20 | Upvalues: GuiService (copy) ]]
		if p1 == 1 then
			return p1
		end

		return p1 * GuiService.PreferredTransparency
	end)
	p1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() --[[ Line: 28 | Upvalues: p1 (copy), Dropdown (copy) ]]
		p1:refreshAppearance(Dropdown, "BackgroundTransparency")
	end))

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
	DropdownScroller.VerticalScrollBarInset = Enum.ScrollBarInset.None
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

	local DropdownSpeed = Instance.new("NumberValue")

	DropdownSpeed.Name = "DropdownSpeed"
	DropdownSpeed.Value = 0.07
	DropdownSpeed.Parent = Dropdown

	local DropdownPadding = Instance.new("UIPadding")

	DropdownPadding.Name = "DropdownPadding"
	DropdownPadding.PaddingTop = UDim.new(0, 0)
	DropdownPadding.PaddingBottom = UDim.new(0, 0)
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

	p1.dropdownChildAdded:Connect(function(p1) --[[ Line: 81 ]]
		local _, v1 = p1:modifyTheme({
			{ "Widget", "BorderSize", 0 },
			{ "IconCorners", "CornerRadius", UDim.new(0, 10) },
			{ "Widget", "MinimumWidth", 190 },
			{ "Widget", "MinimumHeight", 58 },
			{ "IconLabel", "TextSize", 20 },
			{ "IconOverlay", "Size", UDim2.new(1, 0, 1, 0) },
			{ "PaddingLeft", "Size", UDim2.fromOffset(25, 0) },
			{ "Notice", "Position", UDim2.new(1, -24, 0, 5) },
			{ "ContentsList", "HorizontalAlignment", Enum.HorizontalAlignment.Left },
			{ "Selection", "Size", UDim2.new(1, -0, 1, -0) },
			{ "Selection", "Position", UDim2.new(0, 0, 0, 0) }
		})

		task.defer(function() --[[ Line: 95 | Upvalues: p1 (copy), v1 (copy) ]]
			p1.joinJanitor:add(function() --[[ Line: 96 | Upvalues: p1 (ref), v1 (ref) ]]
				p1:removeModification(v1)
			end)
		end)
	end)
	p1.dropdownSet:Connect(function(p12) --[[ Line: 101 | Upvalues: p1 (copy), iconModule (copy) ]]
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

	local function updateMaxIcons() --[[ updateMaxIcons | Line: 113 | Upvalues: Dropdown (copy), DropdownScroller (copy), DropdownPadding (copy) ]]
		local v1 = Dropdown:GetAttribute("MaxIcons")

		if not v1 then
			return 0
		end

		local t = {}

		for k, v in pairs(DropdownScroller:GetChildren()) do
			if v:IsA("GuiObject") and v.Visible then
				table.insert(t, v)
			end
		end

		table.sort(t, function(p1, p2) --[[ Line: 124 ]]
			return p1.AbsolutePosition.Y < p2.AbsolutePosition.Y
		end)

		local v2 = math.ceil(v1)
		local sum = 0

		for i = 1, v2 do
			local v3 = t[i]

			if not v3 then
				break
			end

			local Y = v3.AbsoluteSize.Y

			if if i == v2 then if v2 == v1 then false else true else false then
				Y = Y * (v1 - v2 + 1)
			end

			sum = sum + Y
		end

		return sum + (DropdownPadding.PaddingTop.Offset + DropdownPadding.PaddingBottom.Offset)
	end

	local v1 = nil
	local v2 = nil
	local v3 = nil
	local v4 = nil

	local function getTweenInfo() --[[ getTweenInfo | Line: 145 | Upvalues: Themes (ref), Dropdown (copy), v3 (ref), v4 (ref), DropdownSpeed (copy) ]]
		local v1 = Themes.getInstanceValue(Dropdown, "MaxIcons") or 1

		if v3 and (v3 == v1 and v4) then
			return v4
		end

		local v2 = TweenInfo.new(DropdownSpeed.Value * v1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		v4 = v2
		v3 = v1

		return v2
	end

	local function updateVisibility() --[[ updateVisibility | Line: 159 | Upvalues: Themes (ref), Dropdown (copy), v3 (ref), v4 (ref), DropdownSpeed (copy), v1 (ref), v2 (ref), p1 (copy), updateMaxIcons (copy), TweenService (ref) ]]
		local v12 = Themes.getInstanceValue(Dropdown, "MaxIcons") or 1
		local v22

		if v3 and (v3 == v12 and v4) then
			v22 = v4
		else
			local v32 = TweenInfo.new(DropdownSpeed.Value * v12, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

			v4 = v32
			v3 = v12
			v22 = v32
		end

		if v1 then
			v1:Cancel()
			v1 = nil
		end

		if v2 then
			v2:Cancel()
			v2 = nil
		end

		if p1.isSelected then
			local v42 = updateMaxIcons()

			Dropdown.Visible = true
			Dropdown.BackgroundTransparency = 0
			Dropdown.Size = UDim2.new(0, Dropdown.Size.X.Offset, 0, 0)
			v1 = TweenService:Create(Dropdown, v22, {
				Size = UDim2.new(0, Dropdown.Size.X.Offset, 0, v42)
			})
			v1:Play()
			v1.Completed:Connect(function() --[[ Line: 180 | Upvalues: v1 (ref) ]]
				v1 = nil
			end)
		else
			v2 = TweenService:Create(Dropdown, TweenInfo.new(0), {
				Size = UDim2.new(0, Dropdown.Size.X.Offset, 0, 0)
			})
			v2:Play()
			v2.Completed:Connect(function() --[[ Line: 187 | Upvalues: v2 (ref) ]]
				v2 = nil
			end)
		end
	end

	dropdownJanitor:add(p1.toggled:Connect(updateVisibility))
	updateVisibility()

	local function updateChildSize() --[[ updateChildSize | Line: 197 | Upvalues: Themes (ref), Dropdown (copy), v3 (ref), v4 (ref), DropdownSpeed (copy), p1 (copy), v1 (ref), v2 (ref), RunService (ref), updateMaxIcons (copy), TweenService (ref) ]]
		local v12 = Themes.getInstanceValue(Dropdown, "MaxIcons") or 1
		local v22

		if v3 and (v3 == v12 and v4) then
			v22 = v4
		else
			local v32 = TweenInfo.new(DropdownSpeed.Value * v12, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

			v4 = v32
			v3 = v12
			v22 = v32
		end

		if not p1.isSelected then
			return
		end

		if v1 then
			v1:Cancel()
			v1 = nil
		end

		local v42

		if not v2 then
			RunService.Heartbeat:Wait()
			v42 = updateMaxIcons()
			v1 = TweenService:Create(Dropdown, v22, {
				Size = UDim2.new(0, Dropdown.Size.X.Offset, 0, v42)
			})
			v1:Play()
			v1.Completed:Connect(function() --[[ Line: 215 | Upvalues: v1 (ref) ]]
				v1 = nil
			end)

			return
		end

		v2:Cancel()
		v2 = nil
		RunService.Heartbeat:Wait()
		v42 = updateMaxIcons()
		v1 = TweenService:Create(Dropdown, v22, {
			Size = UDim2.new(0, Dropdown.Size.X.Offset, 0, v42)
		})
		v1:Play()
		v1.Completed:Connect(function() --[[ Line: 215 | Upvalues: v1 (ref) ]]
			v1 = nil
		end)
	end

	dropdownJanitor:add(p1.toggled:Connect(updateVisibility))

	local v5 = 0
	local v6 = false

	local function v7() --[[ updateMaxIconsListener | Line: 228 | Upvalues: v5 (ref), v6 (ref), v7 (copy), Dropdown (copy), DropdownScroller (copy), iconModule (copy), p1 (copy), DropdownPadding (copy) ]]
		v5 = v5 + 1

		if v6 then
			return
		end

		local v1 = v5

		v6 = true
		task.defer(function() --[[ Line: 233 | Upvalues: v6 (ref), v5 (ref), v1 (copy), v7 (ref) ]]
			v6 = false

			if v5 == v1 then
				return
			end

			v7()
		end)

		local v2 = Dropdown:GetAttribute("MaxIcons")

		if not v2 then
			return
		end

		local t = {}

		for k, v in pairs(DropdownScroller:GetChildren()) do
			if v:IsA("GuiObject") and v.Visible then
				table.insert(t, { v, v.AbsolutePosition.Y })
			end
		end

		table.sort(t, function(p1, p2) --[[ Line: 248 ]]
			return p1[2] < p2[2]
		end)

		local v3 = math.ceil(v2)
		local sum = 0
		local v4 = false

		for i = 1, v3 do
			local v52
			local v62 = t[i]

			if not v62 then
				break
			end

			local v72 = v62[1]
			local Y = v72.AbsoluteSize.Y
			local v8 = if i == v3 then if v3 == v2 then false else true else false

			if v8 then
				Y = Y * (v2 - v3 + 1)
			end

			sum = sum + Y

			if not v8 then
				local v9 = v72:GetAttribute("WidgetUID")
				local v10 = if v9 then iconModule.getIconByUID(v9) else v9

				if v10 then
					if v4 then
						v52 = nil
					else
						v52, v4 = p1:getInstance("ClickRegion"), true
					end

					v10:getInstance("ClickRegion").NextSelectionUp = v52
				end
			end
		end

		DropdownScroller.Size = UDim2.fromOffset(0, sum + (DropdownPadding.PaddingTop.Offset + DropdownPadding.PaddingBottom.Offset))
	end

	dropdownJanitor:add(DropdownScroller:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v7))
	dropdownJanitor:add(DropdownScroller.ChildAdded:Connect(v7))
	dropdownJanitor:add(DropdownScroller.ChildRemoved:Connect(updateChildSize))
	dropdownJanitor:add(DropdownScroller.ChildRemoved:Connect(v7))
	dropdownJanitor:add(Dropdown:GetAttributeChangedSignal("MaxIcons"):Connect(v7))
	dropdownJanitor:add(Dropdown:GetAttributeChangedSignal("MaxIcons"):Connect(updateChildSize))
	dropdownJanitor:add(p1.childThemeModified:Connect(v7))
	v7()

	local function connectVisibilityListeners(p1) --[[ connectVisibilityListeners | Line: 293 | Upvalues: updateChildSize (copy) ]]
		if not p1:IsA("GuiObject") then
			return
		end

		p1:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
	end

	for k, v in pairs(DropdownScroller:GetChildren()) do
		if v:IsA("GuiObject") then
			v:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
		end
	end

	DropdownScroller.ChildAdded:Connect(function(p1) --[[ Line: 304 | Upvalues: RunService (ref), updateChildSize (copy) ]]
		RunService.Heartbeat:Wait()

		if not p1:IsA("GuiObject") then
			updateChildSize()

			return
		end

		p1:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
		updateChildSize()
	end)
	Dropdown.Visible = false

	return Dropdown
end