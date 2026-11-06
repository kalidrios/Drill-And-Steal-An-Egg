-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = Color3.fromRGB(39, 41, 48)

return function(p1) --[[ Line: 3 | Upvalues: v1 (copy) ]]
	local v12 = p1:getInstance("ClickRegion")
	local Caption = Instance.new("CanvasGroup")

	Caption.Name = "Caption"
	Caption.AnchorPoint = Vector2.new(0.5, 0)
	Caption.BackgroundTransparency = 1
	Caption.BorderSizePixel = 0
	Caption.GroupTransparency = 1
	Caption.Position = UDim2.fromOffset(0, 0)
	Caption.Visible = true
	Caption.ZIndex = 30
	Caption.Parent = v12

	local Box = Instance.new("Frame")

	Box.Name = "Box"
	Box.AutomaticSize = Enum.AutomaticSize.XY
	Box.BackgroundColor3 = v1
	Box.Position = UDim2.fromOffset(4, 7)
	Box.ZIndex = 12
	Box.Parent = Caption

	local Header = Instance.new("TextLabel")

	Header.Name = "Header"
	Header.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	Header.Text = "Caption"
	Header.TextColor3 = Color3.fromRGB(255, 255, 255)
	Header.TextSize = 15
	Header.TextTruncate = Enum.TextTruncate.None
	Header.TextWrapped = false
	Header.TextXAlignment = Enum.TextXAlignment.Left
	Header.AutomaticSize = Enum.AutomaticSize.X
	Header.BackgroundTransparency = 1
	Header.LayoutOrder = 1
	Header.Size = UDim2.fromOffset(0, 16)
	Header.ZIndex = 18
	Header.Parent = Box

	local Layout = Instance.new("UIListLayout")

	Layout.Name = "Layout"
	Layout.Padding = UDim.new(0, 8)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = Box

	local CaptionCorner = Instance.new("UICorner")

	CaptionCorner.Name = "CaptionCorner"
	CaptionCorner.Parent = Box

	local Padding = Instance.new("UIPadding")

	Padding.Name = "Padding"
	Padding.PaddingBottom = UDim.new(0, 12)
	Padding.PaddingLeft = UDim.new(0, 12)
	Padding.PaddingRight = UDim.new(0, 12)
	Padding.PaddingTop = UDim.new(0, 12)
	Padding.Parent = Box

	local Hotkeys = Instance.new("Frame")

	Hotkeys.Name = "Hotkeys"
	Hotkeys.AutomaticSize = Enum.AutomaticSize.Y
	Hotkeys.BackgroundTransparency = 1
	Hotkeys.LayoutOrder = 3
	Hotkeys.Size = UDim2.fromScale(1, 0)
	Hotkeys.Visible = false
	Hotkeys.Parent = Box

	local Layout1 = Instance.new("UIListLayout")

	Layout1.Name = "Layout1"
	Layout1.Padding = UDim.new(0, 6)
	Layout1.FillDirection = Enum.FillDirection.Vertical
	Layout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Layout1.HorizontalFlex = Enum.UIFlexAlignment.None
	Layout1.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
	Layout1.VerticalFlex = Enum.UIFlexAlignment.None
	Layout1.SortOrder = Enum.SortOrder.LayoutOrder
	Layout1.Parent = Hotkeys

	local Key1 = Instance.new("ImageLabel")

	Key1.Name = "Key1"
	Key1.Image = "rbxasset://textures/ui/Controls/key_single.png"
	Key1.ImageTransparency = 0.7
	Key1.ScaleType = Enum.ScaleType.Slice
	Key1.SliceCenter = Rect.new(5, 5, 23, 24)
	Key1.AutomaticSize = Enum.AutomaticSize.X
	Key1.BackgroundTransparency = 1
	Key1.LayoutOrder = 1
	Key1.Size = UDim2.fromOffset(0, 30)
	Key1.ZIndex = 15
	Key1.Parent = Hotkeys

	local Inset = Instance.new("UIPadding")

	Inset.Name = "Inset"
	Inset.PaddingLeft = UDim.new(0, 8)
	Inset.PaddingRight = UDim.new(0, 8)
	Inset.Parent = Key1

	local LabelContent = Instance.new("TextLabel")

	LabelContent.AutoLocalize = false
	LabelContent.Name = "LabelContent"
	LabelContent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	LabelContent.Text = ""
	LabelContent.TextColor3 = Color3.fromRGB(189, 190, 190)
	LabelContent.TextSize = 15
	LabelContent.AutomaticSize = Enum.AutomaticSize.X
	LabelContent.BackgroundTransparency = 1
	LabelContent.Position = UDim2.fromOffset(0, -1)
	LabelContent.Size = UDim2.fromScale(1, 1)
	LabelContent.ZIndex = 16
	LabelContent.Parent = Key1

	local Caret = Instance.new("ImageLabel")

	Caret.Name = "Caret"
	Caret.Image = "rbxassetid://101906294438076"
	Caret.ImageColor3 = v1
	Caret.AnchorPoint = Vector2.new(0, 0.5)
	Caret.BackgroundTransparency = 1
	Caret.Position = UDim2.new(0, 0, 0, 4)
	Caret.Size = UDim2.fromOffset(16, 8)
	Caret.ZIndex = 12
	Caret.Parent = Caption

	local DropShadow = Instance.new("ImageLabel")

	DropShadow.Visible = true
	DropShadow.Name = "DropShadow"
	DropShadow.Image = "rbxassetid://124920646932671"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.45
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(12, 12, 13, 13)
	DropShadow.BackgroundTransparency = 1
	DropShadow.Position = UDim2.fromOffset(0, 5)
	DropShadow.Size = UDim2.new(1, 0, 0, 48)
	DropShadow.Parent = Caption
	Box:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 145 | Upvalues: DropShadow (copy), Box (copy) ]]
		DropShadow.Size = UDim2.new(1, 0, 0, Box.AbsoluteSize.Y + 8)
	end)

	local captionJanitor = p1.captionJanitor
	local _, v2 = p1:clipOutside(Caption)

	v2.AutomaticSize = Enum.AutomaticSize.None

	local function matchSize() --[[ matchSize | Line: 155 | Upvalues: Caption (copy), v2 (copy) ]]
		local AbsoluteSize = Caption.AbsoluteSize

		v2.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
	end

	captionJanitor:add(Caption:GetPropertyChangedSignal("AbsoluteSize"):Connect(matchSize))

	local AbsoluteSize = Caption.AbsoluteSize

	v2.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)

	local v3 = false
	local Header2 = Caption.Box.Header
	local UserInputService = game:GetService("UserInputService")

	local function updateHotkey(p12) --[[ updateHotkey | Line: 168 | Upvalues: UserInputService (copy), Caption (copy), p1 (copy), Header2 (copy), LabelContent (copy), Hotkeys (copy) ]]
		local KeyboardEnabled = UserInputService.KeyboardEnabled
		local v1 = Caption:GetAttribute("CaptionText") or ""
		local v2 = if v1 == "_hotkey_" then true else false

		if not KeyboardEnabled and v2 then
			p1:setCaption()

			return
		end

		Header2.Text = v1
		Header2.Visible = not v2

		if p12 then
			LabelContent.Text = p12.Name
			Hotkeys.Visible = true
		end

		if KeyboardEnabled then
			return
		end

		Hotkeys.Visible = false
	end

	Caption:GetAttributeChangedSignal("CaptionText"):Connect(updateHotkey)

	local Quad = Enum.EasingStyle.Quad
	local v4 = TweenInfo.new(0.2, Quad, Enum.EasingDirection.In)
	local v5 = TweenInfo.new(0.2, Quad, Enum.EasingDirection.Out)
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")

	local function getCaptionPosition(p1) --[[ getCaptionPosition | Line: 194 | Upvalues: v3 (ref) ]]
		return UDim2.new(0.5, 0, 1, if if p1 == nil then v3 else p1 then 10 else 2)
	end

	local function updatePosition(p1) --[[ updatePosition | Line: 201 | Upvalues: v3 (ref), Caret (copy), Caption (copy), v12 (copy), v2 (copy), v4 (copy), v5 (copy), TweenService (copy), RunService (copy) ]]
		if not v3 then
			return
		end

		local v1 = if p1 == nil then v3 else p1
		local v22 = not v1
		local v52 = UDim2.new(0.5, 0, 1, if if v22 == nil then v3 else v22 then 10 else 2)
		local v9 = UDim2.new(0.5, 0, 1, if if v1 == nil then v3 else v1 then 10 else 2)

		if v1 then
			Caret.Position = UDim2.fromOffset(0, Caret.Position.Y.Offset)
			Caption.AutomaticSize = Enum.AutomaticSize.XY
			Caption.Size = UDim2.fromOffset(32, 53)
		else
			local AbsoluteSize = Caption.AbsoluteSize

			Caption.AutomaticSize = Enum.AutomaticSize.Y
			Caption.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
		end

		local v10 = nil

		local function updateCaret() --[[ updateCaret | Line: 230 | Upvalues: v12 (ref), Caption (ref), Caret (ref), v10 (ref) ]]
			local v1 = v12.AbsolutePosition.X - Caption.AbsolutePosition.X + v12.AbsoluteSize.X / 2 - Caret.AbsoluteSize.X / 2
			local Offset = Caret.Position.Y.Offset
			local v2 = UDim2.fromOffset(v1, Offset)

			if v10 ~= v1 then
				v10 = v1
				Caret.Position = UDim2.fromOffset(0, Offset)
				task.wait()
			end

			Caret.Position = v2
		end

		v2.Position = v52
		updateCaret()

		local v13 = TweenService:Create(v2, v1 and v4 or v5, {
			Position = v9
		})
		local v14 = RunService.Heartbeat:Connect(updateCaret)

		v13:Play()
		v13.Completed:Once(function() --[[ Line: 253 | Upvalues: v14 (copy) ]]
			v14:Disconnect()
		end)
	end

	captionJanitor:add(v12:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 258 | Upvalues: updatePosition (copy) ]]
		updatePosition()
	end))
	updatePosition(false)
	captionJanitor:add(p1.toggleKeyAdded:Connect(updateHotkey))

	for k, v in pairs(p1.bindedToggleKeys) do
		local KeyboardEnabled = UserInputService.KeyboardEnabled
		local v6 = Caption:GetAttribute("CaptionText") or ""
		local v7 = v6 == "_hotkey_"

		if KeyboardEnabled or not v7 then
			Header2.Text = v6
			Header2.Visible = not v7

			if k then
				LabelContent.Text = k.Name
				Hotkeys.Visible = true
			end

			if not KeyboardEnabled then
				Hotkeys.Visible = false
			end
		else
			p1:setCaption()
		end

		break
	end

	captionJanitor:add(p1.fakeToggleKeyChanged:Connect(updateHotkey))

	local fakeToggleKey = p1.fakeToggleKey

	if fakeToggleKey then
		local KeyboardEnabled = UserInputService.KeyboardEnabled
		local v8 = Caption:GetAttribute("CaptionText") or ""
		local v9 = if v8 == "_hotkey_" then true else false

		if KeyboardEnabled or not v9 then
			Header2.Text = v8
			Header2.Visible = not v9

			if fakeToggleKey then
				LabelContent.Text = fakeToggleKey.Name
				Hotkeys.Visible = true
			end

			if not KeyboardEnabled then
				Hotkeys.Visible = false
			end
		else
			p1:setCaption()
		end
	end

	local function setCaptionEnabled(p12) --[[ setCaptionEnabled | Line: 274 | Upvalues: v3 (ref), p1 (copy), v4 (copy), v5 (copy), TweenService (copy), Caption (copy), v2 (copy), updatePosition (copy), UserInputService (copy), Header2 (copy), Hotkeys (copy) ]]
		if v3 == p12 then
			return
		end

		local joinedFrame = p1.joinedFrame

		if joinedFrame and string.match(joinedFrame.Name, "Dropdown") then
			p12 = false
		end

		v3 = p12
		TweenService:Create(Caption, p12 and v4 or v5, {
			GroupTransparency = if p12 then 0 else 1
		}):Play()

		if p12 then
			v2:SetAttribute("ForceUpdate", true)
		end

		updatePosition()

		local KeyboardEnabled = UserInputService.KeyboardEnabled
		local v32 = Caption:GetAttribute("CaptionText") or ""
		local v42 = v32 == "_hotkey_"

		if not KeyboardEnabled and v42 then
			p1:setCaption()

			return
		end

		Header2.Text = v32
		Header2.Visible = not v42

		if KeyboardEnabled then
			return
		end

		Hotkeys.Visible = false
	end

	local iconModule = require(p1.iconModule)

	captionJanitor:add(p1.stateChanged:Connect(function(p12) --[[ Line: 299 | Upvalues: iconModule (copy), p1 (copy), setCaptionEnabled (copy) ]]
		if p12 ~= "Viewing" then
			iconModule.captionLastClosedClock = os.clock()
			setCaptionEnabled(false)

			return
		end

		local captionLastClosedClock = iconModule.captionLastClosedClock

		task.delay(if (if captionLastClosedClock then os.clock() - captionLastClosedClock or 999 else 999) < 0.3 then 0 else 0.5, function() --[[ Line: 304 | Upvalues: p1 (ref), setCaptionEnabled (ref) ]]
			if p1.activeState ~= "Viewing" then
				return
			end

			setCaptionEnabled(true)
		end)
	end))

	return Caption
end