-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ Line: 6 ]]
	local Widget = Instance.new("Frame")

	Widget:SetAttribute("WidgetUID", p1.UID)
	Widget.Name = "Widget"
	Widget.BackgroundTransparency = 1
	Widget.Visible = true
	Widget.ZIndex = 20
	Widget.Active = false
	Widget.ClipsDescendants = true

	local IconButton = Instance.new("Frame")

	IconButton.Name = "IconButton"
	IconButton.Visible = true
	IconButton.ZIndex = 2
	IconButton.BorderSizePixel = 0
	IconButton.Parent = Widget
	IconButton.ClipsDescendants = true
	IconButton.Active = false
	p1.deselected:Connect(function() --[[ Line: 25 | Upvalues: IconButton (copy), p1 (copy) ]]
		IconButton.ClipsDescendants = true
		task.delay(0.2, function() --[[ Line: 27 | Upvalues: p1 (ref), IconButton (ref) ]]
			if not p1.isSelected then
				return
			end

			IconButton.ClipsDescendants = false
		end)
	end)

	local GuiService = game:GetService("GuiService")

	p1:setBehaviour("IconButton", "BackgroundTransparency", function(p1) --[[ Line: 36 | Upvalues: GuiService (copy) ]]
		if p1 == 1 then
			return p1
		end

		return p1 * GuiService.PreferredTransparency
	end)
	p1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() --[[ Line: 44 | Upvalues: p1 (copy), IconButton (copy) ]]
		p1:refreshAppearance(IconButton, "BackgroundTransparency")
	end))

	local UICorner = Instance.new("UICorner")

	UICorner:SetAttribute("Collective", "IconCorners")
	UICorner.Name = "UICorner"
	UICorner.Parent = IconButton

	local v1 = require(script.Parent.Menu)(p1)
	local MenuUIListLayout = v1.MenuUIListLayout
	local MenuGap = v1.MenuGap

	v1.Parent = IconButton

	local IconSpot = Instance.new("Frame")

	IconSpot.Name = "IconSpot"
	IconSpot.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
	IconSpot.BackgroundTransparency = 0.9
	IconSpot.Visible = true
	IconSpot.AnchorPoint = Vector2.new(0, 0.5)
	IconSpot.ZIndex = 5
	IconSpot.Parent = v1
	UICorner:Clone().Parent = IconSpot

	local IconOverlay = IconSpot:Clone()

	IconOverlay.UICorner.Name = "OverlayUICorner"
	IconOverlay.Name = "IconOverlay"
	IconOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	IconOverlay.ZIndex = IconSpot.ZIndex + 1
	IconOverlay.Size = UDim2.new(1, 0, 1, 0)
	IconOverlay.Position = UDim2.new(0, 0, 0, 0)
	IconOverlay.AnchorPoint = Vector2.new(0, 0)
	IconOverlay.Visible = false
	IconOverlay.Parent = IconSpot

	local ClickRegion = Instance.new("TextButton")

	ClickRegion:SetAttribute("CorrespondingIconUID", p1.UID)
	ClickRegion.Name = "ClickRegion"
	ClickRegion.BackgroundTransparency = 1
	ClickRegion.Visible = true
	ClickRegion.Text = ""
	ClickRegion.ZIndex = 20
	ClickRegion.Selectable = true
	ClickRegion.SelectionGroup = true
	ClickRegion.Parent = IconSpot
	require(script.Parent.Parent.Features.Gamepad).registerButton(ClickRegion)
	UICorner:Clone().Parent = ClickRegion

	local Contents = Instance.new("Frame")

	Contents.Name = "Contents"
	Contents.BackgroundTransparency = 1
	Contents.Size = UDim2.fromScale(1, 1)
	Contents.Parent = IconSpot

	local ContentsList = Instance.new("UIListLayout")

	ContentsList.Name = "ContentsList"
	ContentsList.FillDirection = Enum.FillDirection.Horizontal
	ContentsList.VerticalAlignment = Enum.VerticalAlignment.Center
	ContentsList.SortOrder = Enum.SortOrder.LayoutOrder
	ContentsList.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
	ContentsList.Padding = UDim.new(0, 3)
	ContentsList.Parent = Contents

	local PaddingLeft = Instance.new("Frame")

	PaddingLeft.Name = "PaddingLeft"
	PaddingLeft.LayoutOrder = 1
	PaddingLeft.ZIndex = 5
	PaddingLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PaddingLeft.BackgroundTransparency = 1
	PaddingLeft.BorderSizePixel = 0
	PaddingLeft.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PaddingLeft.Parent = Contents

	local PaddingCenter = Instance.new("Frame")

	PaddingCenter.Name = "PaddingCenter"
	PaddingCenter.LayoutOrder = 3
	PaddingCenter.ZIndex = 5
	PaddingCenter.Size = UDim2.new(0, 0, 1, 0)
	PaddingCenter.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PaddingCenter.BackgroundTransparency = 1
	PaddingCenter.BorderSizePixel = 0
	PaddingCenter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PaddingCenter.Parent = Contents

	local PaddingRight = Instance.new("Frame")

	PaddingRight.Name = "PaddingRight"
	PaddingRight.LayoutOrder = 5
	PaddingRight.ZIndex = 5
	PaddingRight.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PaddingRight.BackgroundTransparency = 1
	PaddingRight.BorderSizePixel = 0
	PaddingRight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PaddingRight.Parent = Contents

	local IconLabelContainer = Instance.new("Frame")

	IconLabelContainer.Name = "IconLabelContainer"
	IconLabelContainer.LayoutOrder = 4
	IconLabelContainer.ZIndex = 3
	IconLabelContainer.AnchorPoint = Vector2.new(0, 0.5)
	IconLabelContainer.Size = UDim2.new(0, 0, 0.5, 0)
	IconLabelContainer.BackgroundTransparency = 1
	IconLabelContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
	IconLabelContainer.Parent = Contents

	local IconLabel = Instance.new("TextLabel")
	local v2 = workspace.CurrentCamera.ViewportSize.X + 200

	IconLabel.Name = "IconLabel"
	IconLabel.LayoutOrder = 4
	IconLabel.ZIndex = 15
	IconLabel.AnchorPoint = Vector2.new(0, 0)
	IconLabel.Size = UDim2.new(0, v2, 1, 0)
	IconLabel.ClipsDescendants = false
	IconLabel.BackgroundTransparency = 1
	IconLabel.Position = UDim2.fromScale(0, 0)
	IconLabel.RichText = true
	IconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	IconLabel.TextXAlignment = Enum.TextXAlignment.Left
	IconLabel.Text = ""
	IconLabel.TextWrapped = true
	IconLabel.TextWrap = true
	IconLabel.TextScaled = false
	IconLabel.Active = false
	IconLabel.AutoLocalize = true
	IconLabel.Parent = IconLabelContainer

	local IconImage = Instance.new("ImageLabel")

	IconImage.Name = "IconImage"
	IconImage.LayoutOrder = 2
	IconImage.ZIndex = 15
	IconImage.AnchorPoint = Vector2.new(0, 0.5)
	IconImage.Size = UDim2.new(0, 0, 0.5, 0)
	IconImage.BackgroundTransparency = 1
	IconImage.Position = UDim2.new(0, 11, 0.5, 0)
	IconImage.ScaleType = Enum.ScaleType.Stretch
	IconImage.Active = false
	IconImage.Parent = Contents

	local IconImageCorner = UICorner:Clone()

	IconImageCorner:SetAttribute("Collective", nil)
	IconImageCorner.CornerRadius = UDim.new(0, 0)
	IconImageCorner.Name = "IconImageCorner"
	IconImageCorner.Parent = IconImage

	local TweenService = game:GetService("TweenService")
	local v3 = 0

	local function handleLabelAndImageChangesUnstaggered(p12) --[[ handleLabelAndImageChangesUnstaggered | Line: 195 | Upvalues: p1 (copy), IconLabel (copy), IconImage (copy), IconLabelContainer (copy), PaddingLeft (copy), PaddingCenter (copy), PaddingRight (copy), IconButton (copy), ContentsList (copy), Contents (copy), Widget (copy), v2 (copy), v1 (copy), IconSpot (copy), MenuUIListLayout (copy), MenuGap (copy), TweenService (copy), ClickRegion (copy), v3 (ref), p2 (copy) ]]
		task.defer(function() --[[ Line: 202 | Upvalues: p1 (ref), IconLabel (ref), IconImage (ref), IconLabelContainer (ref), PaddingLeft (ref), PaddingCenter (ref), PaddingRight (ref), IconButton (ref), ContentsList (ref), Contents (ref), Widget (ref), v2 (ref), v1 (ref), IconSpot (ref), MenuUIListLayout (ref), MenuGap (ref), TweenService (ref), ClickRegion (ref), v3 (ref), p2 (ref) ]]
			local indicator = p1.indicator
			local v12 = if indicator then indicator.Visible else indicator
			local v22 = if v12 then v12 else IconLabel.Text ~= ""
			local v32 = if IconImage.Image == "" then false else IconImage.Image ~= nil
			local Center = Enum.HorizontalAlignment.Center
			local v4 = UDim2.fromScale(1, 1)

			if v32 and not v22 then
				IconLabelContainer.Visible = false
				IconImage.Visible = true
				PaddingLeft.Visible = false
				PaddingCenter.Visible = false
				PaddingRight.Visible = false
			elseif v32 or not v22 then
				if v32 and v22 then
					IconLabelContainer.Visible = true
					IconImage.Visible = true
					PaddingLeft.Visible = true
					PaddingCenter.Visible = not v12
					PaddingRight.Visible = not v12

					local Left = Enum.HorizontalAlignment.Left
				end
			else
				IconLabelContainer.Visible = true
				IconImage.Visible = false
				PaddingLeft.Visible = true
				PaddingCenter.Visible = false
				PaddingRight.Visible = true
			end

			IconButton.Size = v4

			local function getItemWidth(p1) --[[ getItemWidth | Line: 232 ]]
				return p1:GetAttribute("TargetWidth") or p1.AbsoluteSize.X
			end

			local Offset = ContentsList.Padding.Offset

			IconLabelContainer.Size = UDim2.new(0, IconLabel.TextBounds.X, IconLabel.Size.Y.Scale, 0)

			local sum = Offset

			for k, v in pairs(Contents:GetChildren()) do
				if v:IsA("GuiObject") and v.Visible == true then
					sum = sum + ((v:GetAttribute("TargetWidth") or v.AbsoluteSize.X) + Offset)
				end
			end

			local v6 = Widget:GetAttribute("MinimumWidth")
			local v7 = Widget:GetAttribute("MinimumHeight")
			local v8 = Widget:GetAttribute("BorderSize")
			local sum2 = math.clamp(sum, v6, v2)
			local sum3 = 0
			local v10 = #p1.menuIcons > 0
			local v11 = if v10 then p1.isSelected else v10

			if v11 then
				for k, v in pairs(v1:GetChildren()) do
					if v ~= IconSpot and (v:IsA("GuiObject") and v.Visible) then
						sum3 = sum3 + ((v:GetAttribute("TargetWidth") or v.AbsoluteSize.X) + MenuUIListLayout.Padding.Offset)
					end
				end

				if not IconSpot.Visible then
					local v13 = IconSpot

					sum2 = sum2 - ((v13:GetAttribute("TargetWidth") or v13.AbsoluteSize.X) + MenuUIListLayout.Padding.Offset * 2 + v8)
				end

				sum3 = sum3 - v8 * 0.5
				sum2 = sum2 + (sum3 - v8 * 0.75)
			end

			MenuGap.Visible = if v11 then IconSpot.Visible else v11

			local v17 = Widget:GetAttribute("DesiredWidth")

			if v17 and sum2 < v17 then
				sum2 = v17
			end

			p1.updateMenu:Fire()

			local v18 = math.max(sum2 - sum3, v6) - v8 * 2
			local v19 = v1:GetAttribute("MenuWidth")
			local v20 = if v19 then v19 + v18 + MenuUIListLayout.Padding.Offset + 10 else v19

			if v20 then
				local v21 = v1:GetAttribute("MaxWidth")

				if v21 then
					v20 = math.max(v21, v6)
				end

				v1:SetAttribute("MenuCanvasWidth", sum2)

				if v20 < sum2 then
					sum2 = v20
				end
			end

			local Quint = Enum.EasingStyle.Quint
			local Out = Enum.EasingDirection.Out
			local v23 = IconSpot
			local v25 = math.max(v18, v23:GetAttribute("TargetWidth") or v23.AbsoluteSize.X, IconSpot.AbsoluteSize.X)
			local v26 = Widget
			local v28 = math.max(sum2, v26:GetAttribute("TargetWidth") or v26.AbsoluteSize.X, Widget.AbsoluteSize.X)
			local v29 = TweenInfo.new(v25 / 750, Quint, Out)
			local v30 = TweenInfo.new(v28 / 750, Quint, Out)

			TweenService:Create(IconSpot, v29, {
				Position = UDim2.new(0, v8, 0.5, 0),
				Size = UDim2.new(0, v18, 1, -v8 * 2)
			}):Play()
			TweenService:Create(ClickRegion, v29, {
				Size = UDim2.new(0, v18, 1, 0)
			}):Play()

			local v31 = UDim2.fromOffset(sum2, v7)

			if Widget.Size.Y.Offset ~= v7 then
				Widget.Size = v31
			end

			Widget:SetAttribute("TargetWidth", v31.X.Offset)
			TweenService:Create(Widget, v30, {
				Size = v31
			}):Play()
			v3 = v3 + 1

			for i = 1, v30.Time * 100 do
				task.delay(i / 100, function() --[[ Line: 314 | Upvalues: p2 (ref), p1 (ref) ]]
					p2.iconChanged:Fire(p1)
				end)
			end

			task.delay(v30.Time - 0.2, function() --[[ Line: 318 | Upvalues: v3 (ref), p1 (ref) ]]
				v3 = v3 - 1
				task.defer(function() --[[ Line: 320 | Upvalues: v3 (ref), p1 (ref) ]]
					if v3 ~= 0 then
						return
					end

					p1.resizingComplete:Fire()
				end)
			end)
			p1:updateParent()
		end)
	end

	local v4 = require(script.Parent.Parent.Utility).createStagger(0.01, handleLabelAndImageChangesUnstaggered)
	local v5 = true

	p1:setBehaviour("IconLabel", "Text", v4)
	p1:setBehaviour("IconLabel", "FontFace", function(p1) --[[ Line: 333 | Upvalues: IconLabel (copy), v4 (copy), v5 (ref) ]]
		if IconLabel.FontFace ~= p1 then
			task.spawn(function() --[[ Line: 338 | Upvalues: v4 (ref), v5 (ref) ]]
				v4()

				if not v5 then
					return
				end

				v5 = false

				for i = 1, 10 do
					task.wait(1)
					v4()
				end
			end)
		end
	end)

	local function updateBorderSize() --[[ updateBorderSize | Line: 360 | Upvalues: Widget (copy), p1 (copy), IconSpot (copy), v1 (copy), MenuGap (copy), MenuUIListLayout (copy), v4 (copy) ]]
		task.defer(function() --[[ Line: 361 | Upvalues: Widget (ref), p1 (ref), IconSpot (ref), v1 (ref), MenuGap (ref), MenuUIListLayout (ref), v4 (ref) ]]
			local v12 = Widget:GetAttribute("BorderSize")

			v1.Position = UDim2.new(0, if IconSpot.Visible == false then 0 else p1.alignment == "Right" and -v12 or v12, 0, 0)
			MenuGap.Size = UDim2.fromOffset(v12, 0)
			MenuUIListLayout.Padding = UDim.new(0, 0)
			v4()
		end)
	end

	p1:setBehaviour("Widget", "BorderSize", updateBorderSize)
	p1:setBehaviour("IconSpot", "Visible", updateBorderSize)
	p1.startMenuUpdate:Connect(v4)
	p1.updateSize:Connect(v4)
	p1:setBehaviour("ContentsList", "HorizontalAlignment", v4)
	p1:setBehaviour("Widget", "Visible", v4)
	p1:setBehaviour("Widget", "DesiredWidth", v4)
	p1:setBehaviour("Widget", "MinimumWidth", v4)
	p1:setBehaviour("Widget", "MinimumHeight", v4)
	p1:setBehaviour("Indicator", "Visible", v4)
	p1:setBehaviour("IconImageRatio", "AspectRatio", v4)
	p1:setBehaviour("IconImage", "Image", function(p1) --[[ Line: 382 | Upvalues: IconImage (copy), v4 (copy) ]]
		local v1 = tonumber(p1) and "http://www.roblox.com/asset/?id=" .. p1 or (if p1 then p1 else "")

		if IconImage.Image == v1 then
			return v1
		end

		v4()

		return v1
	end)
	p1.alignmentChanged:Connect(function(p12) --[[ Line: 389 | Upvalues: MenuUIListLayout (copy), Widget (copy), p1 (copy), IconSpot (copy), v1 (copy), MenuGap (copy), v4 (copy) ]]
		if p12 == "Center" then
			p12 = "Left"
		end

		MenuUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment[p12]
		task.defer(function() --[[ Line: 361 | Upvalues: Widget (ref), p1 (ref), IconSpot (ref), v1 (ref), MenuGap (ref), MenuUIListLayout (ref), v4 (ref) ]]
			local v12 = Widget:GetAttribute("BorderSize")

			v1.Position = UDim2.new(0, if IconSpot.Visible == false then 0 else p1.alignment == "Right" and -v12 or v12, 0, 0)
			MenuGap.Size = UDim2.fromOffset(v12, 0)
			MenuUIListLayout.Padding = UDim.new(0, 0)
			v4()
		end)
	end)

	local LocalPlayer = game:GetService("Players").LocalPlayer
	local LocaleId = LocalPlayer.LocaleId

	p1.janitor:add(LocalPlayer:GetPropertyChangedSignal("LocaleId"):Connect(function() --[[ Line: 401 | Upvalues: LocalPlayer (copy), LocaleId (ref), p1 (copy) ]]
		task.delay(0.2, function() --[[ Line: 402 | Upvalues: LocalPlayer (ref), LocaleId (ref), p1 (ref) ]]
			local LocaleId2 = LocalPlayer.LocaleId

			if LocaleId2 == LocaleId then
				return
			end

			LocaleId = LocaleId2
			p1:refresh()
			task.wait(0.5)
			p1:refresh()
		end)
	end))

	local IconImageScale = Instance.new("NumberValue")

	IconImageScale.Name = "IconImageScale"
	IconImageScale.Parent = IconImage
	IconImageScale:GetPropertyChangedSignal("Value"):Connect(function() --[[ Line: 416 | Upvalues: IconImage (copy), IconImageScale (copy) ]]
		IconImage.Size = UDim2.new(IconImageScale.Value, 0, IconImageScale.Value, 0)
	end)

	local IconImageRatio = Instance.new("UIAspectRatioConstraint")

	IconImageRatio.Name = "IconImageRatio"
	IconImageRatio.AspectType = Enum.AspectType.FitWithinMaxSize
	IconImageRatio.DominantAxis = Enum.DominantAxis.Height
	IconImageRatio.Parent = IconImage

	local IconGradient = Instance.new("UIGradient")

	IconGradient.Name = "IconGradient"
	IconGradient.Enabled = true
	IconGradient.Parent = IconButton

	local IconSpotGradient = Instance.new("UIGradient")

	IconSpotGradient.Name = "IconSpotGradient"
	IconSpotGradient.Enabled = true
	IconSpotGradient.Parent = IconSpot

	return Widget
end