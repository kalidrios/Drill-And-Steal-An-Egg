-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ Line: 1 ]]
	local GuiService = game:GetService("GuiService")
	local isOldTopbar = p1.isOldTopbar
	local t = {}
	local v1 = GuiService:GetGuiInset()
	local v2 = GuiService:IsTenFootInterface()
	local v3 = if isOldTopbar then 12 else v1.Y - 46

	if v2 then
		v3 = 10
	end

	local TopbarStandard = Instance.new("ScreenGui")

	TopbarStandard:SetAttribute("StartInset", v3)
	TopbarStandard.Name = "TopbarStandard"
	TopbarStandard.Enabled = true
	TopbarStandard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	TopbarStandard.IgnoreGuiInset = true
	TopbarStandard.ResetOnSpawn = false
	TopbarStandard.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
	t[TopbarStandard.Name] = TopbarStandard
	TopbarStandard.DisplayOrder = p1.baseDisplayOrder
	p1.baseDisplayOrderChanged:Connect(function() --[[ Line: 22 | Upvalues: TopbarStandard (copy), p1 (copy) ]]
		TopbarStandard.DisplayOrder = p1.baseDisplayOrder
	end)

	local Holders = Instance.new("Frame")
	local sum = if isOldTopbar then 2 else 0
	local v4

	if v2 then
		sum = sum + 13
		v4 = 50
	else
		v4 = -2
	end

	Holders.Name = "Holders"
	Holders.BackgroundTransparency = 1
	Holders.Position = UDim2.new(0, 0, 0, sum)
	Holders.Size = UDim2.new(1, 0, 1, v4)
	Holders.Visible = true
	Holders.ZIndex = 1
	Holders.Parent = TopbarStandard

	local TopbarCentered = TopbarStandard:Clone()
	local Holders2 = TopbarCentered.Holders
	local GuiService2 = game:GetService("GuiService")

	local function updateCenteredHoldersHeight() --[[ updateCenteredHoldersHeight | Line: 44 | Upvalues: Holders2 (copy), GuiService2 (copy), v4 (ref) ]]
		Holders2.Size = UDim2.new(1, 0, 0, GuiService2.TopbarInset.Height + v4)
	end

	TopbarCentered.Name = "TopbarCentered"
	TopbarCentered.ScreenInsets = Enum.ScreenInsets.None
	p1.baseDisplayOrderChanged:Connect(function() --[[ Line: 49 | Upvalues: TopbarCentered (copy), p1 (copy) ]]
		TopbarCentered.DisplayOrder = p1.baseDisplayOrder
	end)
	t[TopbarCentered.Name] = TopbarCentered
	GuiService2:GetPropertyChangedSignal("TopbarInset"):Connect(updateCenteredHoldersHeight)
	Holders2.Size = UDim2.new(1, 0, 0, GuiService2.TopbarInset.Height + v4)

	local v5 = TopbarStandard:Clone()

	v5.Name = v5.Name .. "Clipped"
	v5.DisplayOrder = v5.DisplayOrder + 1
	p1.baseDisplayOrderChanged:Connect(function() --[[ Line: 59 | Upvalues: v5 (copy), p1 (copy) ]]
		v5.DisplayOrder = p1.baseDisplayOrder + 1
	end)
	t[v5.Name] = v5

	local v6 = TopbarCentered:Clone()

	v6.Name = v6.Name .. "Clipped"
	v6.DisplayOrder = v6.DisplayOrder + 1
	p1.baseDisplayOrderChanged:Connect(function() --[[ Line: 67 | Upvalues: v6 (copy), p1 (copy) ]]
		v6.DisplayOrder = p1.baseDisplayOrder + 1
	end)
	t[v6.Name] = v6

	local Left, v7, Center, Right

	if not isOldTopbar then
		Left = Instance.new("ScrollingFrame")
		Left:SetAttribute("IsAHolder", true)
		Left.Name = "Left"
		Left.Position = UDim2.fromOffset(v3, 0)
		Left.Size = UDim2.new(1, -24, 1, 0)
		Left.BackgroundTransparency = 1
		Left.Visible = true
		Left.ZIndex = 1
		Left.Active = false
		Left.ClipsDescendants = true
		Left.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		Left.CanvasSize = UDim2.new(0, 0, 1, -1)
		Left.AutomaticCanvasSize = Enum.AutomaticSize.X
		Left.ScrollingDirection = Enum.ScrollingDirection.X
		Left.ScrollBarThickness = 0
		Left.BorderSizePixel = 0
		Left.Selectable = false
		Left.ScrollingEnabled = false
		Left.ElasticBehavior = Enum.ElasticBehavior.Never
		Left.Parent = Holders
		v7 = Instance.new("UIListLayout")
		v7.Padding = UDim.new(0, v3)
		v7.FillDirection = Enum.FillDirection.Horizontal
		v7.SortOrder = Enum.SortOrder.LayoutOrder
		v7.VerticalAlignment = Enum.VerticalAlignment.Bottom
		v7.HorizontalAlignment = Enum.HorizontalAlignment.Left
		v7.Parent = Left
		Center = Left:Clone()
		Center.ScrollingEnabled = false
		Center.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		Center.Name = "Center"
		Center.Parent = Holders2
		Right = Left:Clone()
		Right.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		Right.Name = "Right"
		Right.AnchorPoint = Vector2.new(1, 0)
		Right.Position = UDim2.new(1, -12, 0, 0)
		Right.Parent = Holders

		return t
	end

	task.defer(function() --[[ Line: 73 | Upvalues: GuiService2 (copy), p1 (copy) ]]
		local function decideToHideTopbar() --[[ decideToHideTopbar | Line: 74 | Upvalues: GuiService2 (ref), p1 (ref) ]]
			if GuiService2.MenuIsOpen then
				p1.setTopbarEnabled(false, true)
			else
				p1.setTopbarEnabled()
			end
		end

		GuiService2:GetPropertyChangedSignal("MenuIsOpen"):Connect(decideToHideTopbar)

		if GuiService2.MenuIsOpen then
			p1.setTopbarEnabled(false, true)
		else
			p1.setTopbarEnabled()
		end
	end)
	Left = Instance.new("ScrollingFrame")
	Left:SetAttribute("IsAHolder", true)
	Left.Name = "Left"
	Left.Position = UDim2.fromOffset(v3, 0)
	Left.Size = UDim2.new(1, -24, 1, 0)
	Left.BackgroundTransparency = 1
	Left.Visible = true
	Left.ZIndex = 1
	Left.Active = false
	Left.ClipsDescendants = true
	Left.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	Left.CanvasSize = UDim2.new(0, 0, 1, -1)
	Left.AutomaticCanvasSize = Enum.AutomaticSize.X
	Left.ScrollingDirection = Enum.ScrollingDirection.X
	Left.ScrollBarThickness = 0
	Left.BorderSizePixel = 0
	Left.Selectable = false
	Left.ScrollingEnabled = false
	Left.ElasticBehavior = Enum.ElasticBehavior.Never
	Left.Parent = Holders
	v7 = Instance.new("UIListLayout")
	v7.Padding = UDim.new(0, v3)
	v7.FillDirection = Enum.FillDirection.Horizontal
	v7.SortOrder = Enum.SortOrder.LayoutOrder
	v7.VerticalAlignment = Enum.VerticalAlignment.Bottom
	v7.HorizontalAlignment = Enum.HorizontalAlignment.Left
	v7.Parent = Left
	Center = Left:Clone()
	Center.ScrollingEnabled = false
	Center.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Center.Name = "Center"
	Center.Parent = Holders2
	Right = Left:Clone()
	Right.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	Right.Name = "Right"
	Right.AnchorPoint = Vector2.new(1, 0)
	Right.Position = UDim2.new(1, -12, 0, 0)
	Right.Parent = Holders

	return t
end