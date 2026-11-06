-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ Line: 1 ]]
	local widget = p1.widget
	local v1 = p1:getInstance("Contents")
	local Indicator = Instance.new("Frame")

	Indicator.Name = "Indicator"
	Indicator.LayoutOrder = 9999999
	Indicator.ZIndex = 6
	Indicator.Size = UDim2.new(0, 42, 0, 42)
	Indicator.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Indicator.BackgroundTransparency = 1
	Indicator.Position = UDim2.new(1, 0, 0.5, 0)
	Indicator.BorderSizePixel = 0
	Indicator.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Indicator.Parent = v1

	local IndicatorButton = Instance.new("Frame")

	IndicatorButton.Name = "IndicatorButton"
	IndicatorButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	IndicatorButton.AnchorPoint = Vector2.new(0.5, 0.5)
	IndicatorButton.BorderSizePixel = 0
	IndicatorButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	IndicatorButton.Parent = Indicator

	local GuiService = game:GetService("GuiService")
	local GamepadService = game:GetService("GamepadService")
	local v2 = p1:getInstance("ClickRegion")

	local function selectionChanged() --[[ selectionChanged | Line: 28 | Upvalues: GuiService (copy), v2 (copy), IndicatorButton (copy) ]]
		if GuiService.SelectedObject == v2 then
			IndicatorButton.BackgroundTransparency = 1
			IndicatorButton.Position = UDim2.new(0.5, -2, 0.5, 0)
			IndicatorButton.Size = UDim2.fromScale(1.2, 1.2)
		else
			IndicatorButton.BackgroundTransparency = 0.75
			IndicatorButton.Position = UDim2.new(0.5, 2, 0.5, 0)
			IndicatorButton.Size = UDim2.fromScale(1, 1)
		end
	end

	p1.janitor:add(GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(selectionChanged))
	selectionChanged()

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.LayoutOrder = 2
	ImageLabel.ZIndex = 15
	ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel.Image = "rbxasset://textures/ui/Controls/XboxController/DPadUp@2x.png"
	ImageLabel.Parent = IndicatorButton

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = IndicatorButton

	local UserInputService = game:GetService("UserInputService")

	local function setIndicatorVisible(p12) --[[ setIndicatorVisible | Line: 58 | Upvalues: Indicator (copy), GamepadService (copy), p1 (copy) ]]
		if p12 == nil then
			p12 = Indicator.Visible
		end

		if GamepadService.GamepadCursorEnabled then
			p12 = false
		end

		if p12 then
			p1:modifyTheme({ "PaddingRight", "Size", UDim2.new(0, 0, 1, 0) }, "IndicatorPadding")
		else
			if not Indicator.Visible then
				p1:modifyTheme({ "Indicator", "Visible", p12 })
				p1.updateSize:Fire()

				return
			end

			p1:removeModification("IndicatorPadding")
		end

		p1:modifyTheme({ "Indicator", "Visible", p12 })
		p1.updateSize:Fire()
	end

	p1.janitor:add(GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(setIndicatorVisible))
	p1.indicatorSet:Connect(function(p1) --[[ Line: 74 | Upvalues: ImageLabel (copy), UserInputService (copy), setIndicatorVisible (copy) ]]
		local v1

		if p1 then
			ImageLabel.Image = UserInputService:GetImageForKeyCode(p1)
			v1 = true
		else
			v1 = false
		end

		setIndicatorVisible(v1)
	end)

	local function updateSize() --[[ updateSize | Line: 83 | Upvalues: widget (copy), Indicator (copy) ]]
		local v1 = widget.AbsoluteSize.Y * 0.96

		Indicator.Size = UDim2.new(0, v1, 0, v1)
	end

	widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)

	local v3 = widget.AbsoluteSize.Y * 0.96

	Indicator.Size = UDim2.new(0, v3, 0, v3)

	return Indicator
end