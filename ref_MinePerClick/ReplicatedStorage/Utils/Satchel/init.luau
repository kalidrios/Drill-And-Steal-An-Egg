-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ContextActionService = game:GetService("ContextActionService")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local FavoriteItem = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("FavoriteItem")
local Data = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("DataClient")):GetReplica().Data
local t = {
	OpenClose = nil,
	IsOpen = false,
	StateChanged = Instance.new("BindableEvent"),
	ModuleName = "Backpack",
	KeepVRTopbarOpen = true,
	VRIsExclusive = true,
	VRClosesNonExclusive = true,
	BackpackEmpty = Instance.new("BindableEvent")
}

t.BackpackEmpty.Name = "BackpackEmpty"
t.BackpackItemAdded = Instance.new("BindableEvent")
t.BackpackItemAdded.Name = "BackpackAdded"
t.BackpackItemRemoved = Instance.new("BindableEvent")
t.BackpackItemRemoved.Name = "BackpackRemoved"

local v1 = script
local v2 = GuiService.PreferredTransparency or 1
local v3 = not v1:GetAttribute("OutlineEquipBorder") or false
local v4 = v1:GetAttribute("InsetIconPadding")
local v5 = v2 * 0.65

UDim.new(0, 8)

local v6 = v1:GetAttribute("BackgroundColor3") or Color3.new(25/255, 27/255, 29/255)
local v7 = Color3.new(0.356863, 0.552941, 0.913725)
local v8 = v2 * 0.5
local v9 = v1:GetAttribute("CornerRadius") or UDim.new(0, 8)
local v10 = Color3.new(255/255, 255/255, 255/255)

if not (v9 - UDim.new(0, 5)) then
	UDim.new(0, 3)
end

local v11 = v1:GetAttribute("BackgroundColor3") or Color3.new(25/255, 27/255, 29/255)
local v12 = v1:GetAttribute("TextColor3") or Color3.new(255/255, 255/255, 255/255)
local v13 = v1:GetAttribute("TextStrokeTransparency") or 0.5
local v14 = v1:GetAttribute("TextStrokeColor3") or Color3.new(0/255, 0/255, 0/255)
local v15 = Color3.new(25/255, 27/255, 29/255)
local v16 = v2 * 0.2
local v17 = Color3.new(255/255, 255/255, 255/255)

UDim.new(0, 3)

local v18 = v1:GetAttribute("FontFace") or Font.new("rbxasset://fonts/families/FredokaOne.json")

v18.Weight = Enum.FontWeight.ExtraBold

local v19 = v1:GetAttribute("TextSize") or 16
local Backspace = Enum.KeyCode.Backspace.Value
local Zero = Enum.KeyCode.Zero.Value
local t2 = {
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.MouseButton2] = true,
	[Enum.UserInputType.MouseButton3] = true,
	[Enum.UserInputType.MouseMovement] = true,
	[Enum.UserInputType.MouseWheel] = true
}
local t3 = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
}
local v20 = true
local v21 = require(script.Packages:WaitForChild("topbarplus")).new():setName("Inventory"):setImage("rbxasset://textures/ui/TopBar/inventoryOn.png", "Selected"):setImage("rbxasset://textures/ui/TopBar/inventoryOff.png", "Deselected"):setImageScale(1):setCaption("Inventory"):bindToggleKey(Enum.KeyCode.Backquote):autoDeselect(false):setOrder(-1)

v21.toggled:Connect(function() --[[ Line: 189 | Upvalues: GuiService (copy), t (copy) ]]
	if GuiService.MenuIsOpen then
		return
	end

	t.OpenClose()
end)

local BackpackGui = Instance.new("ScreenGui")

BackpackGui.DisplayOrder = 120
BackpackGui.IgnoreGuiInset = true
BackpackGui.ResetOnSpawn = false
BackpackGui.Name = "BackpackGui"
BackpackGui.Parent = PlayerGui

local v22 = GuiService:IsTenFootInterface()
local v23

if v22 then
	v19 = 24
	v23 = 100
else
	v23 = 70
end

local v24 = false
local v25 = UserInputService.TouchEnabled and workspace.CurrentCamera.ViewportSize.X < 1024
local LocalPlayer = Players.LocalPlayer
local Backpack = nil
local Hotbar = nil
local Inventory = nil
local VRInventorySelector = nil
local ScrollingFrame = nil
local UIGridFrame = nil
local v26 = nil
local v27 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = v27:WaitForChild("Humanoid")
local Backpack2 = LocalPlayer:WaitForChild("Backpack")
local t4 = {}
local v28 = nil
local t5 = {}
local t6 = {}
local t7 = {}
local v29 = 0
local v30 = nil
local v31 = false
local v32 = false
local v33 = false
local v34 = false
local t8 = {}
local v35 = false
local VREnabled = VRService.VREnabled
local v36 = if VREnabled then 6 elseif v25 then 6 else 10
local v37 = if VREnabled then 3 elseif v25 then 2 else 4
local v38 = nil

local function EvaluateBackpackPanelVisibility(p1) --[[ EvaluateBackpackPanelVisibility | Line: 252 | Upvalues: v21 (copy), v20 (ref), VRService (copy) ]]
	return if p1 then v21.enabled and (v20 and VRService.VREnabled) else p1
end

local function ShowVRBackpackPopup() --[[ ShowVRBackpackPopup | Line: 256 ]] end

local function FindLowestEmpty() --[[ FindLowestEmpty | Line: 262 | Upvalues: v36 (copy), t4 (copy) ]]
	for i = 1, v36 do
		local v1 = t4[i]

		if not v1.Tool then
			return v1
		end
	end

	return nil
end

function t.IsInventoryEmpty() --[[ isInventoryEmpty | Line: 272 | Upvalues: v36 (copy), t4 (copy) ]]
	for i = v36 + 1, #t4 do
		local v1 = t4[i]

		if v1 and v1.Tool then
			return false
		end
	end

	return true
end

local function UseGazeSelection() --[[ UseGazeSelection | Line: 284 ]]
	return false
end

local function AdjustHotbarFrames() --[[ AdjustHotbarFrames | Line: 288 | Upvalues: Inventory (ref), v36 (copy), v29 (ref), t4 (copy) ]]
	local Visible = Inventory.Visible
	local v1 = Inventory.Visible and v36 or v29
	local count = 0

	for i = 1, v36 do
		local v2 = t4[i]

		if v2.Tool or Visible then
			count = count + 1
			v2:Readjust(count, v1)
			v2.Frame.Visible = true

			continue
		end

		v2.Frame.Visible = false
	end
end

local function UpdateScrollingFrameCanvasSize() --[[ UpdateScrollingFrameCanvasSize | Line: 305 | Upvalues: ScrollingFrame (ref), v23 (ref), UIGridFrame (ref) ]]
	local v2 = math.floor(ScrollingFrame.AbsoluteSize.X / (v23 + 5))

	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, math.ceil((#UIGridFrame:GetChildren() - 1) / v2) * (v23 + 5) + 5)
end

local function AdjustInventoryFrames() --[[ AdjustInventoryFrames | Line: 312 | Upvalues: v36 (copy), t4 (copy), UpdateScrollingFrameCanvasSize (copy) ]]
	for i = v36 + 1, #t4 do
		local v1 = t4[i]

		v1.Frame.LayoutOrder = v1.Index
		v1.Frame.Visible = v1.Tool ~= nil
	end

	UpdateScrollingFrameCanvasSize()
end

local function UpdateBackpackLayout() --[[ UpdateBackpackLayout | Line: 321 | Upvalues: Hotbar (ref), v36 (copy), v23 (ref), Inventory (ref), v37 (copy), VREnabled (copy), ScrollingFrame (ref), AdjustHotbarFrames (copy), AdjustInventoryFrames (copy) ]]
	Hotbar.Size = UDim2.new(0, v36 * (v23 + 5) + 5, 0, v23 + 5 + 5)
	Hotbar.Position = UDim2.new(0.5, -Hotbar.Size.X.Offset / 2, 1, -Hotbar.Size.Y.Offset)
	Inventory.Size = UDim2.new(0, Hotbar.Size.X.Offset, 0, Hotbar.Size.Y.Offset * v37 + 40 + (if VREnabled then 80 else 0))
	Inventory.Position = UDim2.new(0.5, -Inventory.Size.X.Offset / 2, 1, Hotbar.Position.Y.Offset - Inventory.Size.Y.Offset)
	ScrollingFrame.Size = UDim2.new(1, ScrollingFrame.ScrollBarThickness + 1, 1, -40 - (if VREnabled then 80 else 0))
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 40 + (if VREnabled then 40 else 0))
	AdjustHotbarFrames()
	AdjustInventoryFrames()
end

local function Clamp(p1, p2, p3) --[[ Clamp | Line: 355 ]]
	return math.min(p2, (math.max(p1, p3)))
end

local function CheckBounds(p1, p2, p3) --[[ CheckBounds | Line: 359 ]]
	local AbsolutePosition = p1.AbsolutePosition
	local AbsoluteSize = p1.AbsoluteSize

	return if AbsolutePosition.X < p2 and (p2 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < p3) then p3 <= AbsolutePosition.Y + AbsoluteSize.Y else false
end

local function GetOffset(p1, p2) --[[ GetOffset | Line: 365 ]]
	return (p1.AbsolutePosition + p1.AbsoluteSize / 2 - p2).Magnitude
end

local function DisableActiveHopper() --[[ DisableActiveHopper | Line: 370 | Upvalues: v30 (ref), t5 (copy) ]]
	v30:ToggleSelect()
	t5[v30]:UpdateEquipView()
	v30 = nil
end

local function UnequipAllTools() --[[ UnequipAllTools | Line: 376 | Upvalues: Humanoid (ref), v30 (ref), t5 (copy) ]]
	if not Humanoid then
		return
	end

	Humanoid:UnequipTools()

	if not v30 then
		return
	end

	v30:ToggleSelect()
	t5[v30]:UpdateEquipView()
	v30 = nil
end

local function EquipNewTool(p1) --[[ EquipNewTool | Line: 385 | Upvalues: Humanoid (ref), v30 (ref), t5 (copy) ]]
	if not Humanoid then
		Humanoid:EquipTool(p1)

		return
	end

	Humanoid:UnequipTools()

	if not v30 then
		Humanoid:EquipTool(p1)

		return
	end

	v30:ToggleSelect()
	t5[v30]:UpdateEquipView()
	v30 = nil
	Humanoid:EquipTool(p1)
end

local function IsEquipped(p1) --[[ IsEquipped | Line: 391 | Upvalues: v27 (ref) ]]
	return if p1 then p1.Parent == v27 else p1
end

local function IsToolFavorited(p1) --[[ IsToolFavorited | Line: 396 | Upvalues: Data (copy) ]]
	if not p1 then
		return false
	end

	local v1 = p1:GetAttribute("UniqueId")

	if v1 == nil then
		return false
	end

	local v2 = Data.Inventory and Data.Inventory[v1]

	return if v2 == nil then false else v2.IsFavorited == true
end

local function v39(p1, p2) --[[ MakeSlot | Line: 409 | Upvalues: t4 (copy), v8 (ref), Hotbar (ref), v23 (ref), Data (copy), v36 (copy), Inventory (ref), UserInputService (copy), v29 (ref), v32 (ref), v24 (ref), ContextActionService (copy), v26 (ref), t5 (copy), v28 (ref), v27 (ref), v38 (ref), v7 (copy), v3 (copy), UpdateScrollingFrameCanvasSize (copy), Humanoid (ref), v30 (ref), Backpack2 (ref), v6 (copy), v10 (copy), v4 (copy), v12 (copy), v13 (copy), v14 (copy), v18 (copy), v19 (ref), TweenService (copy), FavoriteItem (copy), v11 (copy), v39 (copy), UIGridFrame (ref), v34 (ref), t6 (copy), Zero (copy), t7 (copy), v21 (copy), ScrollingFrame (ref) ]]
	local v1 = if p2 then p2 else #t4 + 1
	local t = {
		Tool = nil,
		Index = v1,
		Frame = nil
	}
	local v2 = nil
	local v33 = nil
	local Icon = nil
	local ToolName = nil
	local v42 = nil
	local v5 = nil
	local HoldFill = nil
	local FavoriteStar = nil
	local ToolTip = nil
	local Number = nil

	local function UpdateSlotFading() --[[ UpdateSlotFading | Line: 436 | Upvalues: v2 (ref), v8 (ref) ]]
		v2.SelectionImageObject = nil
		v2.BackgroundTransparency = if v2.Draggable then 0 else v8
	end

	function t.Readjust(p1, p2, p3) --[[ Readjust | Line: 442 | Upvalues: Hotbar (ref), v23 (ref), v2 (ref) ]]
		v2.Position = UDim2.new(0, Hotbar.Size.X.Offset / 2 - v23 / 2 + (v23 + 5) * (p2 - (p3 / 2 + 0.5)), 0, 5)
	end
	function t.Fill(p1, p2) --[[ Fill | Line: 452 | Upvalues: v2 (ref), Icon (ref), ToolName (ref), ToolTip (ref), FavoriteStar (ref), Data (ref), v42 (ref), v36 (ref), Inventory (ref), UserInputService (ref), v29 (ref), v32 (ref), v24 (ref), ContextActionService (ref), v26 (ref), t5 (ref), v28 (ref), t4 (ref) ]]
		if not p2 then
			return p1:Clear()
		end

		p1.Tool = p2

		local function assignToolData() --[[ assignToolData | Line: 461 | Upvalues: v2 (ref), p2 (copy), Icon (ref), ToolName (ref), ToolTip (ref), FavoriteStar (ref), Data (ref) ]]
			v2.Image = "rbxassetid://125569451752606"

			local TextureId = p2.TextureId

			Icon.Image = TextureId

			if TextureId == "" then
				ToolName.Visible = true
			else
				ToolName.Visible = false
			end

			ToolName.Text = p2.Name

			if ToolTip and p2:IsA("Tool") then
				ToolTip.Text = p2.ToolTip
				ToolTip.Size = UDim2.new(0, 0, 0, 16)
				ToolTip.Position = UDim2.new(0.5, 0, 0, -5)
			end

			if ToolTip then
				p2:IsA("Tool")
			end

			if not FavoriteStar then
				return
			end

			local v22 = p2
			local v3

			if v22 then
				local v4 = v22:GetAttribute("UniqueId")

				if v4 == nil then
					v3 = false
				else
					local v5 = Data.Inventory and Data.Inventory[v4]

					v3 = if v5 == nil then false elseif v5.IsFavorited == true then true else false
				end
			else
				v3 = false
			end

			FavoriteStar.Visible = v3
		end

		assignToolData()

		if v42 then
			v42:Disconnect()
			v42 = nil
		end

		v42 = p2.Changed:Connect(function(p1) --[[ Line: 507 | Upvalues: assignToolData (copy) ]]
			if p1 ~= "TextureId" and (p1 ~= "Name" and p1 ~= "ToolTip") then
				return
			end

			assignToolData()
		end)

		local v1 = p1.Index <= v36

		if (not v1 or Inventory.Visible) and not UserInputService.VREnabled then
			v2.Draggable = true
		end

		p1:UpdateEquipView()

		if v1 then
			v29 = v29 + 1

			if v32 and (v29 >= 1 and not v24) then
				v24 = true
				ContextActionService:BindAction("BackpackHotbarEquip", v26, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
			end
		end

		t5[p2] = p1

		local v22

		for i = 1, v36 do
			local v3 = t4[i]

			if not v3.Tool then
				v22 = v3
				v28 = v3

				return
			end
		end

		v22 = nil
		v28 = v22
	end
	function t.Clear(p1) --[[ Clear | Line: 543 | Upvalues: v42 (ref), Icon (ref), ToolName (ref), ToolTip (ref), FavoriteStar (ref), HoldFill (ref), v2 (ref), v36 (ref), v29 (ref), v24 (ref), ContextActionService (ref), t5 (ref), v28 (ref), t4 (ref) ]]
		if not p1.Tool then
			return
		end

		if v42 then
			v42:Disconnect()
			v42 = nil
		end

		Icon.Image = ""
		ToolName.Text = ""

		if ToolTip then
			ToolTip.Text = ""
			ToolTip.Visible = false
		end

		if FavoriteStar then
			FavoriteStar.Visible = false
		end

		if HoldFill then
			HoldFill.Visible = false
			HoldFill.Size = UDim2.new(1, 0, 0, 0)
		end

		v2.Draggable = false
		p1:UpdateEquipView(true)

		if p1.Index <= v36 then
			v29 = v29 - 1

			if v29 < 1 then
				v24 = false
				ContextActionService:UnbindAction("BackpackHotbarEquip")
			end
		end

		t5[p1.Tool] = nil
		p1.Tool = nil

		local v1

		for i = 1, v36 do
			local v22 = t4[i]

			if not v22.Tool then
				v1 = v22
				v28 = v22

				return
			end
		end

		v1 = nil
		v28 = v1
	end
	function t.UpdateEquipView(p1, p2) --[[ UpdateEquipView | Line: 585 | Upvalues: v27 (ref), v38 (ref), t (copy), v5 (ref), v7 (ref), v3 (ref), Icon (ref), v2 (ref), v8 (ref) ]]
		if p2 then
			if v5 then
				v5.Parent = nil
			end
		else
			local Tool = p1.Tool

			if if Tool then Tool.Parent == v27 else Tool then
				v38 = t

				if not v5 then
					v5 = Instance.new("UIStroke")
					v5.Name = "Border"
					v5.Thickness = 2.5
					v5.Color = v7
					v5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				end

				if v3 == true then
					v5.Parent = Icon
				else
					v5.Parent = v2
				end
			elseif v5 then
				v5.Parent = nil
			end
		end

		v2.SelectionImageObject = nil
		v2.BackgroundTransparency = if v2.Draggable then 0 else v8
	end
	function t.IsEquipped(p1) --[[ IsEquipped | Line: 609 | Upvalues: v27 (ref) ]]
		local Tool = p1.Tool

		return if Tool then Tool.Parent == v27 else Tool
	end
	function t.Delete(p1) --[[ Delete | Line: 613 | Upvalues: v2 (ref), t4 (ref), UpdateScrollingFrameCanvasSize (ref) ]]
		v2:Destroy()
		table.remove(t4, p1.Index)

		for i = p1.Index, #t4 do
			t4[i]:SlideBack()
		end

		UpdateScrollingFrameCanvasSize()
	end
	function t.Swap(p1, p2) --[[ Swap | Line: 626 ]]
		local Tool = p1.Tool
		local Tool2 = p2.Tool

		p1:Clear()

		if Tool2 then
			p2:Clear()
			p1:Fill(Tool2)
		end

		if Tool then
			p2:Fill(Tool)
		else
			p2:Clear()
		end
	end
	function t.SlideBack(p1) --[[ SlideBack | Line: 640 | Upvalues: v2 (ref) ]]
		p1.Index = p1.Index - 1
		v2.Name = p1.Index
		v2.LayoutOrder = p1.Index
	end
	function t.TurnNumber(p1, p2) --[[ TurnNumber | Line: 646 | Upvalues: Number (ref) ]]
		if not Number then
			return
		end

		Number.Visible = p2
	end
	function t.SetClickability(p1, p2) --[[ SetClickability | Line: 652 | Upvalues: UserInputService (ref), v2 (ref), v8 (ref) ]]
		if not p1.Tool then
			return
		end

		if UserInputService.VREnabled then
			v2.Draggable = false
		else
			v2.Draggable = not p2
		end

		v2.SelectionImageObject = nil
		v2.BackgroundTransparency = if v2.Draggable then 0 else v8
	end
	function t.CheckTerms(p1, p2) --[[ CheckTerms | Line: 663 | Upvalues: ToolName (ref), ToolTip (ref) ]]
		local sum = 0

		local function checkEm(p1, p2) --[[ checkEm | Line: 665 | Upvalues: sum (ref) ]]
			local _, v1 = p1:lower():gsub(p2, "")

			sum = sum + v1
		end

		local Tool = p1.Tool

		if Tool then
			for k in pairs(p2) do
				local _, v1 = ToolName.Text:lower():gsub(k, "")

				sum = sum + v1

				if Tool:IsA("Tool") then
					local _2, v3 = (if ToolTip then ToolTip.Text or "" else ""):lower():gsub(k, "")

					sum = sum + v3
				end
			end
		end

		return sum
	end
	function t.Select(p1) --[[ Select | Line: 683 | Upvalues: t (copy), v27 (ref), Humanoid (ref), v30 (ref), t5 (ref), Backpack2 (ref) ]]
		local Tool = t.Tool

		if not Tool then
			return
		end

		if if Tool then if Tool.Parent == v27 then true else false else Tool then
			if not Humanoid then
				return
			end

			Humanoid:UnequipTools()

			if v30 then
				v30:ToggleSelect()
				t5[v30]:UpdateEquipView()
				v30 = nil
			end
		else
			if Tool.Parent ~= Backpack2 then
				return
			end

			if Humanoid then
				Humanoid:UnequipTools()

				if v30 then
					v30:ToggleSelect()
					t5[v30]:UpdateEquipView()
					v30 = nil
				end
			end

			Humanoid:EquipTool(Tool)
		end
	end
	v2 = Instance.new("ImageButton")
	v2.Image = "rbxassetid://125569451752606"
	v2.Name = tostring(v1)
	v2.BackgroundColor3 = v6
	v2.BorderColor3 = v10
	v2.BorderSizePixel = 0
	v2.Size = UDim2.new(0, v23, 0, v23)
	v2.Active = true
	v2.Draggable = false
	v2.BackgroundTransparency = v8
	v2.MouseButton1Click:Connect(function() --[[ Line: 709 | Upvalues: t (copy) ]]
		if t._suppressNextClick then
			t._suppressNextClick = false
		else
			changeSlot(t)
		end
	end)
	t.Frame = v2

	local SelectionObjectClipper = Instance.new("Frame")

	SelectionObjectClipper.Name = "SelectionObjectClipper"
	SelectionObjectClipper.BackgroundTransparency = 1
	SelectionObjectClipper.Visible = false
	SelectionObjectClipper.Parent = v2

	local Selector = Instance.new("ImageLabel")

	Selector.Name = "Selector"
	Selector.BackgroundTransparency = 1
	Selector.Size = UDim2.new(1, 0, 1, 0)
	Selector.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
	Selector.ScaleType = Enum.ScaleType.Slice
	Selector.SliceCenter = Rect.new(12, 12, 52, 52)
	Selector.Parent = SelectionObjectClipper
	Icon = Instance.new("ImageLabel")
	Icon.BackgroundTransparency = 1
	Icon.Name = "Icon"
	Icon.Size = UDim2.new(1, 0, 1, 0)
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)

	if v4 == true then
		Icon.Size = UDim2.new(1, -5, 1, -5)
	else
		Icon.Size = UDim2.new(1, 0, 1, 0)
	end

	Icon.Parent = v2
	ToolName = Instance.new("TextLabel")
	ToolName.BackgroundTransparency = 1
	ToolName.Name = "ToolName"
	ToolName.Text = ""
	ToolName.TextColor3 = v12
	ToolName.TextStrokeTransparency = v13
	ToolName.TextStrokeColor3 = v14
	ToolName.FontFace = Font.new(v18.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	ToolName.TextSize = v19
	ToolName.Size = UDim2.new(1, -5, 1, -5)
	ToolName.Position = UDim2.new(0.5, 0, 0.5, 0)
	ToolName.AnchorPoint = Vector2.new(0.5, 0.5)
	ToolName.TextWrapped = true
	ToolName.TextTruncate = Enum.TextTruncate.AtEnd
	ToolName.Parent = v2
	HoldFill = Instance.new("Frame")
	HoldFill.Name = "HoldFill"
	HoldFill.BackgroundColor3 = Color3.new(0/255, 0/255, 0/255)
	HoldFill.BackgroundTransparency = 0.35
	HoldFill.BorderSizePixel = 0
	HoldFill.AnchorPoint = Vector2.new(0.5, 1)
	HoldFill.Position = UDim2.new(0.5, 0, 1, 0)
	HoldFill.Size = UDim2.new(1, 0, 0, 0)
	HoldFill.ZIndex = 5
	HoldFill.Visible = false
	HoldFill.Parent = v2
	FavoriteStar = Instance.new("ImageLabel")
	FavoriteStar.Name = "FavoriteStar"
	FavoriteStar.BackgroundTransparency = 1
	FavoriteStar.Image = "rbxassetid://87034857799385"
	FavoriteStar.AnchorPoint = Vector2.new(1, 0)
	FavoriteStar.Position = UDim2.new(1, -4, 0, 4)
	FavoriteStar.Size = UDim2.new(0.32, 0, 0.32, 0)
	FavoriteStar.SizeConstraint = Enum.SizeConstraint.RelativeXX
	FavoriteStar.ZIndex = 6
	FavoriteStar.Visible = false
	FavoriteStar.Parent = v2

	local v62 = nil
	local v72 = nil

	local function cancelHold() --[[ cancelHold | Line: 812 | Upvalues: v62 (ref), v72 (ref), HoldFill (ref) ]]
		if not v62 then
			v72 = nil
			HoldFill.Visible = false
			HoldFill.Size = UDim2.new(1, 0, 0, 0)

			return
		end

		v62:Cancel()
		v62 = nil
		v72 = nil
		HoldFill.Visible = false
		HoldFill.Size = UDim2.new(1, 0, 0, 0)
	end

	v2.InputBegan:Connect(function(p1) --[[ Line: 822 | Upvalues: t (copy), v62 (ref), v72 (ref), HoldFill (ref), TweenService (ref), Data (ref), FavoriteStar (ref), FavoriteItem (ref) ]]
		if p1.UserInputType ~= Enum.UserInputType.MouseButton1 and p1.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if not t.Tool then
			return
		end

		if t.Tool:GetAttribute("UniqueId") == nil then
			return
		end

		if v62 then
			v62:Cancel()
			v62 = nil
		end

		v72 = nil
		HoldFill.Visible = false
		HoldFill.Size = UDim2.new(1, 0, 0, 0)
		v72 = t.Tool
		HoldFill.Size = UDim2.new(1, 0, 0, 0)
		HoldFill.Visible = true
		v62 = TweenService:Create(HoldFill, TweenInfo.new(1, Enum.EasingStyle.Linear), {
			Size = UDim2.new(1, 0, 1, 0)
		})
		v62.Completed:Connect(function(p1) --[[ Line: 849 | Upvalues: v72 (ref), t (ref), v62 (ref), HoldFill (ref), Data (ref), FavoriteStar (ref), FavoriteItem (ref) ]]
			if p1 ~= Enum.PlaybackState.Completed then
				return
			end

			if v72 == nil or t.Tool ~= v72 then
				if not v62 then
					v72 = nil
					HoldFill.Visible = false
					HoldFill.Size = UDim2.new(1, 0, 0, 0)

					return
				end

				v62:Cancel()
				v62 = nil
				v72 = nil
				HoldFill.Visible = false
				HoldFill.Size = UDim2.new(1, 0, 0, 0)
			else
				local v1 = v72
				local v2

				if v1 then
					local v3 = v1:GetAttribute("UniqueId")

					if v3 == nil then
						v2 = false
					else
						local v4 = Data.Inventory and Data.Inventory[v3]

						v2 = if v4 == nil then false elseif v4.IsFavorited == true then true else false
					end
				else
					v2 = false
				end

				local v5 = not v2

				FavoriteStar.Visible = v5
				FavoriteItem:FireServer(v1:GetAttribute("UniqueId"), v5)
				t._suppressNextClick = true
				HoldFill.Visible = false
				HoldFill.Size = UDim2.new(1, 0, 0, 0)
				v62 = nil
				v72 = nil
			end
		end)
		v62:Play()
	end)
	v2.InputEnded:Connect(function(p1) --[[ Line: 879 | Upvalues: v62 (ref), v72 (ref), HoldFill (ref) ]]
		if p1.UserInputType ~= Enum.UserInputType.MouseButton1 and p1.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if v62 then
			v62:Cancel()
			v62 = nil
		end

		v72 = nil
		HoldFill.Visible = false
		HoldFill.Size = UDim2.new(1, 0, 0, 0)
	end)
	v2.MouseLeave:Connect(cancelHold)
	v2.DragBegin:Connect(function() --[[ Line: 890 | Upvalues: v62 (ref), v72 (ref), HoldFill (ref) ]]
		if not v62 then
			v72 = nil
			HoldFill.Visible = false
			HoldFill.Size = UDim2.new(1, 0, 0, 0)

			return
		end

		v62:Cancel()
		v62 = nil
		v72 = nil
		HoldFill.Visible = false
		HoldFill.Size = UDim2.new(1, 0, 0, 0)
	end)
	t.Frame.LayoutOrder = t.Index

	if v1 <= v36 then
		ToolTip = Instance.new("TextLabel")
		ToolTip.Name = "ToolTip"
		ToolTip.Text = ""
		ToolTip.Size = UDim2.new(1, 0, 1, 0)
		ToolTip.TextColor3 = v12
		ToolTip.TextStrokeTransparency = v13
		ToolTip.TextStrokeColor3 = v14
		ToolTip.FontFace = Font.new(v18.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		ToolTip.TextSize = v19
		ToolTip.ZIndex = 2
		ToolTip.TextWrapped = false
		ToolTip.TextYAlignment = Enum.TextYAlignment.Center
		ToolTip.BackgroundColor3 = v11
		ToolTip.BackgroundTransparency = v8
		ToolTip.AnchorPoint = Vector2.new(0.5, 1)
		ToolTip.BorderSizePixel = 0
		ToolTip.Visible = false
		ToolTip.AutomaticSize = Enum.AutomaticSize.X
		ToolTip.Parent = v2

		local UIPadding = Instance.new("UIPadding")

		UIPadding.PaddingLeft = UDim.new(0, 4)
		UIPadding.PaddingRight = UDim.new(0, 4)
		UIPadding.PaddingTop = UDim.new(0, 4)
		UIPadding.PaddingBottom = UDim.new(0, 4)
		UIPadding.Parent = ToolTip
		v2.MouseEnter:Connect(function() --[[ Line: 930 | Upvalues: ToolTip (ref) ]]
			if ToolTip.Text == "" then
				return
			end

			ToolTip.Visible = true
		end)
		v2.MouseLeave:Connect(function() --[[ Line: 935 | Upvalues: ToolTip (ref) ]]
			ToolTip.Visible = false
		end)
		function t.MoveToInventory(p1) --[[ MoveToInventory | Line: 939 | Upvalues: t (copy), v36 (ref), v39 (ref), UIGridFrame (ref), v27 (ref), Humanoid (ref), v30 (ref), t5 (ref), v34 (ref), Inventory (ref) ]]
			if not (t.Index <= v36) then
				return
			end

			local Tool = t.Tool

			p1:Clear()

			local v1 = v39(UIGridFrame)

			v1:Fill(Tool)

			if (if Tool then Tool.Parent == v27 else Tool) and Humanoid then
				Humanoid:UnequipTools()

				if v30 then
					v30:ToggleSelect()
					t5[v30]:UpdateEquipView()
					v30 = nil
				end
			end

			if not v34 then
				return
			end

			v1.Frame.Visible = false
			v1.Parent = Inventory
		end

		if v1 < 10 or v1 == v36 then
			local v82 = v1 < 10 and v1 or 0

			Number = Instance.new("TextLabel")
			Number.BackgroundTransparency = 1
			Number.Name = "Number"
			Number.TextColor3 = v12
			Number.TextStrokeTransparency = v13
			Number.TextStrokeColor3 = v14
			Number.TextSize = v19
			Number.Text = tostring(v82)
			Number.FontFace = Font.new(v18.Family, Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
			Number.Size = UDim2.new(0.4, 0, 0.4, 0)
			Number.Visible = false
			Number.Parent = v2
			t6[Zero + v82] = t.Select
		end
	end

	local Position = v2.Position
	local v9 = 0
	local v102 = nil

	v2.DragBegin:Connect(function(p1) --[[ Line: 980 | Upvalues: t7 (ref), v2 (ref), Position (ref), v21 (ref), Icon (ref), ToolName (ref), Number (ref), v102 (ref), UIGridFrame (ref), Inventory (ref), v33 (ref) ]]
		t7[v2] = true
		Position = p1
		v2.BorderSizePixel = 2
		v21:lock()
		v2.ZIndex = 2
		Icon.ZIndex = 2
		ToolName.ZIndex = 2
		v2.Parent.ZIndex = 2

		if Number then
			Number.ZIndex = 2
		end

		v102 = v2.Parent

		if v102 ~= UIGridFrame then
			return
		end

		local v1 = UDim2.new(0, v2.AbsolutePosition.X - Inventory.AbsolutePosition.X, 0, v2.AbsolutePosition.Y - Inventory.AbsolutePosition.Y)

		v2.Parent = Inventory
		v2.Position = v1
		v33 = Instance.new("Frame")
		v33.Name = "FakeSlot"
		v33.LayoutOrder = v2.LayoutOrder
		v33.Size = v2.Size
		v33.BackgroundTransparency = 1
		v33.Parent = UIGridFrame
	end)
	v2.DragStopped:Connect(function(p1, p2) --[[ Line: 1023 | Upvalues: v33 (ref), v2 (ref), Position (ref), v102 (ref), v21 (ref), Icon (ref), ToolName (ref), Number (ref), t7 (ref), t (copy), Inventory (ref), v36 (ref), v9 (ref), v28 (ref), Hotbar (ref), t4 (ref), v27 (ref), Humanoid (ref), v30 (ref), t5 (ref), v34 (ref) ]]
		if v33 then
			v33:Destroy()
		end

		local v1 = os.clock()

		v2.Position = Position
		v2.Parent = v102
		v2.BorderSizePixel = 0
		v21:unlock()
		v2.ZIndex = 1
		Icon.ZIndex = 1
		ToolName.ZIndex = 1
		v102.ZIndex = 1

		if Number then
			Number.ZIndex = 1
		end

		t7[v2] = nil

		if not t.Tool then
			return
		end

		local v22 = Inventory
		local AbsolutePosition = v22.AbsolutePosition
		local AbsoluteSize = v22.AbsoluteSize

		if if AbsolutePosition.X < p1 and (p1 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < p2) then if p2 <= AbsolutePosition.Y + AbsoluteSize.Y then true else false else false then
			if t.Index <= v36 then
				t:MoveToInventory()
			end

			if v36 < t.Index and v1 - v9 < 0.5 then
				if v28 then
					t:Clear()
					v28:Fill(t.Tool)
					t:Delete()
				end

				v1 = 0
			end
		else
			local v4 = Hotbar
			local AbsolutePosition2 = v4.AbsolutePosition
			local AbsoluteSize2 = v4.AbsoluteSize

			if if AbsolutePosition2.X < p1 and (p1 <= AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.Y < p2) then if p2 <= AbsolutePosition2.Y + AbsoluteSize2.Y then true else false else false then
				local t2 = { (1 / 0), nil }

				for i = 1, v36 do
					local v6 = t4[i]
					local Frame = v6.Frame
					local Magnitude = (Frame.AbsolutePosition + Frame.AbsoluteSize / 2 - Vector2.new(p1, p2)).Magnitude

					if Magnitude < t2[1] then
						t2 = { Magnitude, v6 }
					end
				end

				local v8 = t2[2]

				if v8 ~= t then
					t:Swap(v8)

					if v36 < t.Index then
						local Tool = t.Tool

						if Tool then
							if (if Tool then Tool.Parent == v27 else Tool) and Humanoid then
								Humanoid:UnequipTools()

								if v30 then
									v30:ToggleSelect()
									t5[v30]:UpdateEquipView()
									v30 = nil
								end
							end

							if v34 then
								t.Frame.Visible = false
								t.Frame.Parent = Inventory
							end
						else
							t:Delete()
						end
					end
				end
			elseif t.Index <= v36 then
				t:MoveToInventory()
			end
		end

		v9 = v1
	end)
	v2.Parent = p1
	t4[v1] = t

	if not (v36 < v1) then
		return t
	end

	UpdateScrollingFrameCanvasSize()

	if not Inventory.Visible or v34 then
		return t
	end

	ScrollingFrame.CanvasPosition = Vector2.new(0, (math.max(0, ScrollingFrame.CanvasSize.Y.Offset - ScrollingFrame.AbsoluteSize.Y)))

	return t
end

local function OnChildAdded(p1) --[[ OnChildAdded | Line: 1133 | Upvalues: v27 (ref), Humanoid (ref), v30 (ref), t5 (copy), v31 (ref), LocalPlayer (ref), v28 (ref), v39 (copy), UIGridFrame (ref), t4 (copy), Backpack2 (ref), AdjustHotbarFrames (copy), v36 (copy), Inventory (ref), t (copy) ]]
	if p1:IsA("Tool") or p1:IsA("HopperBin") then
		local isParent = p1.Parent == v27

		if v30 and p1.Parent == v27 then
			v30:ToggleSelect()
			t5[v30]:UpdateEquipView()
			v30 = nil
		end

		if not v31 and (p1.Parent == v27 and not t5[p1]) then
			local StarterGear = LocalPlayer:FindFirstChild("StarterGear")

			if StarterGear and StarterGear:FindFirstChild(p1.Name) then
				v31 = true

				for i = (v28 or v39(UIGridFrame)).Index, 1, -1 do
					local v2 = t4[i]
					local v3 = i - 1

					if v3 > 0 then
						t4[v3]:Swap(v2)

						continue
					end

					v2:Fill(p1)
				end

				for k, v in pairs(v27:GetChildren()) do
					if v:IsA("Tool") and v ~= p1 then
						v.Parent = Backpack2
					end
				end

				AdjustHotbarFrames()

				return
			end
		end

		local v4 = t5[p1]

		if v4 then
			v4:UpdateEquipView()
		else
			local v5 = v28 or v39(UIGridFrame)

			v5:Fill(p1)

			if v5.Index <= v36 and not Inventory.Visible then
				AdjustHotbarFrames()
			end

			if not (p1:IsA("HopperBin") and p1.Active) then
				t.BackpackItemAdded:Fire()

				return
			end

			if Humanoid then
				Humanoid:UnequipTools()

				if v30 then
					v30:ToggleSelect()
					t5[v30]:UpdateEquipView()
					v30 = nil
				end
			end

			v30 = p1
		end

		t.BackpackItemAdded:Fire()
	else
		if not p1:IsA("Humanoid") or p1.Parent ~= v27 then
			return
		end

		Humanoid = p1
	end
end

local function OnChildRemoved(p1) --[[ OnChildRemoved | Line: 1200 | Upvalues: v27 (ref), Backpack2 (ref), t5 (copy), v36 (copy), Inventory (ref), AdjustHotbarFrames (copy), v30 (ref), t (copy), t4 (copy) ]]
	if not (p1:IsA("Tool") or p1:IsA("HopperBin")) then
		return
	end

	local v1 = p1.Parent

	if v1 == v27 or v1 == Backpack2 then
		return
	end

	local v2 = t5[p1]

	if v2 then
		v2:Clear()

		if v36 < v2.Index then
			v2:Delete()
		elseif not Inventory.Visible then
			AdjustHotbarFrames()
		end
	end

	if p1 == v30 then
		v30 = nil
	end

	t.BackpackItemRemoved:Fire()

	local v3

	for i = v36 + 1, #t4 do
		local v4 = t4[i]

		if v4 and v4.Tool then
			v3 = false

			if not v3 then
				return
			end

			t.BackpackEmpty:Fire()

			return
		end
	end

	v3 = true

	if not v3 then
		return
	end

	t.BackpackEmpty:Fire()
end

local function OnCharacterAdded(p1) --[[ OnCharacterAdded | Line: 1234 | Upvalues: t4 (copy), v36 (copy), v30 (ref), t8 (ref), v27 (ref), OnChildRemoved (copy), OnChildAdded (copy), Backpack2 (ref), LocalPlayer (ref), AdjustHotbarFrames (copy) ]]
	for i = #t4, 1, -1 do
		local v1 = t4[i]

		if v1.Tool then
			v1:Clear()
		end

		if v36 < i then
			v1:Delete()
		end
	end

	v30 = nil

	for k, v in pairs(t8) do
		v:Disconnect()
	end

	t8 = {}
	v27 = p1
	table.insert(t8, p1.ChildRemoved:Connect(OnChildRemoved))
	table.insert(t8, p1.ChildAdded:Connect(OnChildAdded))

	for k, v in pairs(p1:GetChildren()) do
		OnChildAdded(v)
	end

	Backpack2 = LocalPlayer:WaitForChild("Backpack")
	table.insert(t8, Backpack2.ChildRemoved:Connect(OnChildRemoved))
	table.insert(t8, Backpack2.ChildAdded:Connect(OnChildAdded))

	for k, v in pairs(Backpack2:GetChildren()) do
		OnChildAdded(v)
	end

	AdjustHotbarFrames()
end

local function OnInputBegan(p1, p2) --[[ OnInputBegan | Line: 1273 | Upvalues: TextChatService (copy), v33 (ref), v32 (ref), Backspace (copy), t6 (copy), Inventory (ref), v21 (copy) ]]
	local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

	if p1.UserInputType == Enum.UserInputType.Keyboard and (not v33 and (not ChatInputBarConfiguration.IsFocused and (v32 or p1.KeyCode.Value == Backspace))) then
		local v1 = t6[p1.KeyCode.Value]

		if v1 then
			v1(p2)
		end
	end

	local UserInputType = p1.UserInputType

	if p2 or UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch or not Inventory.Visible then
		return
	end

	v21:deselect()
end

local function OnUISChanged() --[[ OnUISChanged | Line: 1299 | Upvalues: UserInputService (copy), v36 (copy), t4 (copy), t2 (copy), t3 (copy) ]]
	if UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
		for i = 1, v36 do
			t4[i]:TurnNumber(false)
		end
	elseif UserInputService:GetLastInputType() == Enum.UserInputType.Keyboard then
		for j = 1, v36 do
			t4[j]:TurnNumber(true)
		end
	else
		for k, v in pairs(t2) do
			if UserInputService:GetLastInputType() == v then
				for k2 = 1, v36 do
					t4[k2]:TurnNumber(true)
				end

				return
			end
		end

		for k, v in pairs(t3) do
			if UserInputService:GetLastInputType() == v then
				for n = 1, v36 do
					t4[n]:TurnNumber(false)
				end

				return
			end
		end
	end
end

local v40 = nil
local v41 = nil

local function f42() --[[ Line: 1340 ]] end

function unbindAllGamepadEquipActions() --[[ unbindAllGamepadEquipActions | Line: 1343 | Upvalues: ContextActionService (copy) ]]
	ContextActionService:UnbindAction("BackpackHasGamepadFocus")
	ContextActionService:UnbindAction("BackpackCloseInventory")
end
v26 = function(p1, p2, p3) --[[ Line: 1419 | Upvalues: v40 (ref), v41 (ref), Humanoid (ref), v30 (ref), t5 (copy), v36 (copy), t4 (copy), v38 (ref) ]]
	if p2 ~= Enum.UserInputState.Begin then
		return
	end

	if v40 then
		if (v40.KeyCode ~= Enum.KeyCode.ButtonR1 or p3.KeyCode ~= Enum.KeyCode.ButtonL1) and (v40.KeyCode ~= Enum.KeyCode.ButtonL1 or p3.KeyCode ~= Enum.KeyCode.ButtonR1) then
			v40 = p3
			v41 = os.clock()
			task.delay(0.06, function() --[[ Line: 1447 | Upvalues: v40 (ref), p3 (copy), v36 (ref), t4 (ref), Humanoid (ref), v30 (ref), t5 (ref), v38 (ref) ]]
				if v40 ~= p3 then
					return
				end

				local v1 = if p3.KeyCode == Enum.KeyCode.ButtonL1 then -1 else 1

				for i = 1, v36 do
					if t4[i]:IsEquipped() then
						local sum2 = v1 + i
						local v2 = false

						if v36 < sum2 then
							sum2 = 1
							v2 = true
						elseif sum2 < 1 then
							sum2 = v36
							v2 = true
						end

						local v3 = sum2

						while not t4[sum2].Tool do
							sum2 = sum2 + v1

							if sum2 == v3 then
								return
							end

							if v36 < sum2 then
								sum2 = 1
								v2 = true
							elseif sum2 < 1 then
								sum2 = v36
								v2 = true
							else
								continue
							end
						end

						if not v2 then
							t4[sum2]:Select()

							return
						end

						if not Humanoid then
							v38 = nil

							return
						end

						Humanoid:UnequipTools()

						if not v30 then
							v38 = nil

							return
						end

						v30:ToggleSelect()
						t5[v30]:UpdateEquipView()
						v30 = nil
						v38 = nil

						return
					end
				end

				if v38 and v38.Tool then
					v38:Select()

					return
				end

				for j = if v1 == -1 then v36 or 1 else 1, if v1 == -1 then 1 else v36, v1 do
					if t4[j].Tool then
						t4[j]:Select()

						return
					end
				end
			end)

			return
		end

		if os.clock() - v41 <= 0.06 then
			if not Humanoid then
				v40 = p3
				v41 = os.clock()

				return
			end

			Humanoid:UnequipTools()

			if not v30 then
				v40 = p3
				v41 = os.clock()

				return
			end

			v30:ToggleSelect()
			t5[v30]:UpdateEquipView()
			v30 = nil
			v40 = p3
			v41 = os.clock()

			return
		end
	end

	v40 = p3
	v41 = os.clock()
	task.delay(0.06, function() --[[ Line: 1447 | Upvalues: v40 (ref), p3 (copy), v36 (ref), t4 (ref), Humanoid (ref), v30 (ref), t5 (ref), v38 (ref) ]]
		if v40 ~= p3 then
			return
		end

		local v1 = if p3.KeyCode == Enum.KeyCode.ButtonL1 then -1 else 1

		for i = 1, v36 do
			if t4[i]:IsEquipped() then
				local sum2 = v1 + i
				local v2 = false

				if v36 < sum2 then
					sum2 = 1
					v2 = true
				elseif sum2 < 1 then
					sum2 = v36
					v2 = true
				end

				local v3 = sum2

				while not t4[sum2].Tool do
					sum2 = sum2 + v1

					if sum2 == v3 then
						return
					end

					if v36 < sum2 then
						sum2 = 1
						v2 = true
					elseif sum2 < 1 then
						sum2 = v36
						v2 = true
					else
						continue
					end
				end

				if not v2 then
					t4[sum2]:Select()

					return
				end

				if not Humanoid then
					v38 = nil

					return
				end

				Humanoid:UnequipTools()

				if not v30 then
					v38 = nil

					return
				end

				v30:ToggleSelect()
				t5[v30]:UpdateEquipView()
				v30 = nil
				v38 = nil

				return
			end
		end

		if v38 and v38.Tool then
			v38:Select()

			return
		end

		for j = if v1 == -1 then v36 or 1 else 1, if v1 == -1 then 1 else v36, v1 do
			if t4[j].Tool then
				t4[j]:Select()

				return
			end
		end
	end)
end
function getGamepadSwapSlot() --[[ getGamepadSwapSlot | Line: 1514 | Upvalues: t4 (copy) ]]
	for i = 1, #t4 do
		if t4[i].Frame.BorderSizePixel > 0 then
			return t4[i]
		end
	end
end
function changeSlot(p1) --[[ changeSlot | Line: 1524 | Upvalues: VRService (copy), Inventory (ref), GuiService (copy), VRInventorySelector (ref), v36 (copy) ]]
	if p1.Frame == GuiService.SelectedObject and (not VRService.VREnabled or Inventory.Visible) then
		local v2 = getGamepadSwapSlot()

		if not v2 then
			local Size = p1.Frame.Size
			local Position = p1.Frame.Position

			p1.Frame:TweenSizeAndPosition(Size + UDim2.new(0, 10, 0, 10), Position - UDim2.new(0, 5, 0, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function() --[[ Line: 1560 | Upvalues: p1 (copy), Size (copy), Position (copy) ]]
				p1.Frame:TweenSizeAndPosition(Size, Position, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true)
			end)
			p1.Frame.BorderSizePixel = 3
			VRInventorySelector.SelectionImageObject.Visible = true

			return
		end

		v2.Frame.BorderSizePixel = 0

		if v2 == p1 then
			return
		end

		p1:Swap(v2)
		VRInventorySelector.SelectionImageObject.Visible = false

		if v36 < p1.Index and not p1.Tool then
			if GuiService.SelectedObject == p1.Frame then
				GuiService.SelectedObject = v2.Frame
			end

			p1:Delete()
		end

		if not (v36 < v2.Index) or v2.Tool then
			return
		end

		if GuiService.SelectedObject ~= v2.Frame then
			v2:Delete()

			return
		end

		GuiService.SelectedObject = p1.Frame
		v2:Delete()

		return
	end

	p1:Select()
	VRInventorySelector.SelectionImageObject.Visible = false
end
function vrMoveSlotToInventory() --[[ vrMoveSlotToInventory | Line: 1580 | Upvalues: VRService (copy), VRInventorySelector (ref) ]]
	if not VRService.VREnabled then
		return
	end

	local v1 = getGamepadSwapSlot()

	if not (v1 and v1.Tool) then
		return
	end

	v1.Frame.BorderSizePixel = 0
	v1:MoveToInventory()
	VRInventorySelector.SelectionImageObject.Visible = false
end
function enableGamepadInventoryControl() --[[ enableGamepadInventoryControl | Line: 1593 | Upvalues: Inventory (ref), v21 (copy), ContextActionService (copy), f42 (copy), GuiService (copy), Hotbar (ref) ]]
	local function f1() --[[ Line: 1594 | Upvalues: Inventory (ref), v21 (ref) ]]
		if getGamepadSwapSlot() then
			local v1 = getGamepadSwapSlot()

			if v1 then
				v1.Frame.BorderSizePixel = 0
			end
		else
			if not Inventory.Visible then
				return
			end

			v21:deselect()
		end
	end

	ContextActionService:BindAction("BackpackHasGamepadFocus", f42, false, Enum.UserInputType.Gamepad1)
	ContextActionService:BindAction("BackpackCloseInventory", f1, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)
	GuiService.SelectedObject = Hotbar:FindFirstChild("1")
end
function disableGamepadInventoryControl() --[[ disableGamepadInventoryControl | Line: 1627 | Upvalues: v36 (copy), t4 (copy), GuiService (copy), Backpack (ref) ]]
	unbindAllGamepadEquipActions()

	for i = 1, v36 do
		local v1 = t4[i]

		if v1 and v1.Frame then
			v1.Frame.BorderSizePixel = 0
		end
	end

	if not (GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(Backpack)) then
		return
	end

	GuiService.SelectedObject = nil
end

local function bindBackpackHotbarAction() --[[ bindBackpackHotbarAction | Line: 1642 | Upvalues: v32 (ref), v24 (ref), ContextActionService (copy), v26 (ref) ]]
	if not v32 or v24 then
		return
	end

	v24 = true
	ContextActionService:BindAction("BackpackHotbarEquip", v26, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
end

local function unbindBackpackHotbarAction() --[[ unbindBackpackHotbarAction | Line: 1655 | Upvalues: v24 (ref), ContextActionService (copy) ]]
	disableGamepadInventoryControl()
	v24 = false
	ContextActionService:UnbindAction("BackpackHotbarEquip")
end

function gamepadDisconnected() --[[ gamepadDisconnected | Line: 1661 | Upvalues: v35 (ref) ]]
	v35 = false
	disableGamepadInventoryControl()
end
function gamepadConnected() --[[ gamepadConnected | Line: 1666 | Upvalues: v35 (ref), GuiService (copy), Backpack (ref), v29 (ref), v32 (ref), v24 (ref), ContextActionService (copy), v26 (ref), Inventory (ref) ]]
	v35 = true
	GuiService:AddSelectionParent("BackpackSelection", Backpack)

	if v29 >= 1 and (v32 and not v24) then
		v24 = true
		ContextActionService:BindAction("BackpackHotbarEquip", v26, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
	end

	if not Inventory.Visible then
		return
	end

	enableGamepadInventoryControl()
end

local function OnIconChanged(p1) --[[ OnIconChanged | Line: 1679 | Upvalues: StarterGui (copy), v32 (ref), Backpack (ref), v29 (ref), v24 (ref), ContextActionService (copy), v26 (ref) ]]
	task.wait()

	local v1 = if p1 then StarterGui:GetCore("TopbarEnabled") else p1

	v32 = v1
	Backpack.Visible = v1

	if v1 then
		if v29 >= 1 and (v1 and not v24) then
			v24 = true
			ContextActionService:BindAction("BackpackHotbarEquip", v26, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
		end
	else
		disableGamepadInventoryControl()
		v24 = false
		ContextActionService:UnbindAction("BackpackHotbarEquip")
	end
end

local function MakeVRRoundButton(p1, p2) --[[ MakeVRRoundButton | Line: 1707 ]]
	local ImageButton = Instance.new("ImageButton")

	ImageButton.BackgroundTransparency = 1
	ImageButton.Name = p1
	ImageButton.Size = UDim2.new(0, 40, 0, 40)
	ImageButton.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png"

	local Icon = Instance.new("ImageLabel")

	Icon.Name = "Icon"
	Icon.BackgroundTransparency = 1
	Icon.Size = UDim2.new(0.5, 0, 0.5, 0)
	Icon.Position = UDim2.new(0.25, 0, 0.25, 0)
	Icon.Image = p2
	Icon.Parent = ImageButton

	local Selection = Instance.new("ImageLabel")

	Selection.BackgroundTransparency = 1
	Selection.Name = "Selection"
	Selection.Size = UDim2.new(0.9, 0, 0.9, 0)
	Selection.Position = UDim2.new(0.05, 0, 0.05, 0)
	Selection.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png"
	ImageButton.SelectionImageObject = Selection

	return ImageButton, Icon, Selection
end

Backpack = Instance.new("Frame")
Backpack.BackgroundTransparency = 1
Backpack.Name = "Backpack"
Backpack.Size = UDim2.new(1, 0, 1, 0)
Backpack.Visible = false
Backpack.Parent = BackpackGui
Hotbar = Instance.new("Frame")
Hotbar.BackgroundTransparency = 1
Hotbar.Name = "Hotbar"
Hotbar.Size = UDim2.new(1, 0, 1, 0)
Hotbar.Parent = Backpack

for i = 1, v36 do
	local v43 = v39(Hotbar, i)

	v43.Frame.Visible = false

	if not v28 then
		v28 = v43
	end
end

local LeftBumper = Instance.new("ImageLabel")

LeftBumper.BackgroundTransparency = 1
LeftBumper.Name = "LeftBumper"
LeftBumper.Size = UDim2.new(0, 40, 0, 40)
LeftBumper.Position = UDim2.new(0, -LeftBumper.Size.X.Offset, 0.5, -LeftBumper.Size.Y.Offset / 2)

local RightBumper = Instance.new("ImageLabel")

RightBumper.BackgroundTransparency = 1
RightBumper.Name = "RightBumper"
RightBumper.Size = UDim2.new(0, 40, 0, 40)
RightBumper.Position = UDim2.new(1, 0, 0.5, -RightBumper.Size.Y.Offset / 2)
Inventory = Instance.new("Frame")
Inventory.Name = "Inventory"
Inventory.Size = UDim2.new(1, 0, 1, 0)
Inventory.BackgroundTransparency = v5
Inventory.BackgroundColor3 = v6
Inventory.Active = true
Inventory.Visible = false
Inventory.Parent = Backpack
VRInventorySelector = Instance.new("TextButton")
VRInventorySelector.Name = "VRInventorySelector"
VRInventorySelector.Position = UDim2.new(0, 0, 0, 0)
VRInventorySelector.Size = UDim2.new(1, 0, 1, 0)
VRInventorySelector.BackgroundTransparency = 1
VRInventorySelector.Text = ""
VRInventorySelector.Parent = Inventory

local Selector = Instance.new("ImageLabel")

Selector.BackgroundTransparency = 1
Selector.Name = "Selector"
Selector.Size = UDim2.new(1, 0, 1, 0)
Selector.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
Selector.ScaleType = Enum.ScaleType.Slice
Selector.SliceCenter = Rect.new(12, 12, 52, 52)
Selector.Visible = false
VRInventorySelector.SelectionImageObject = Selector
VRInventorySelector.MouseButton1Click:Connect(function() --[[ Line: 1804 ]]
	vrMoveSlotToInventory()
end)
ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.Selectable = false
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 8
ScrollingFrame.ScrollBarImageColor3 = Color3.new(255/255, 255/255, 255/255)
ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.Parent = Inventory
UIGridFrame = Instance.new("Frame")
UIGridFrame.BackgroundTransparency = 1
UIGridFrame.Name = "UIGridFrame"
UIGridFrame.Selectable = false
UIGridFrame.Size = UDim2.new(1, -10, 1, 0)
UIGridFrame.Position = UDim2.new(0, 5, 0, 0)
UIGridFrame.Parent = ScrollingFrame

local UIGridLayout = Instance.new("UIGridLayout")

UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellSize = UDim2.new(0, v23, 0, v23)
UIGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
UIGridLayout.Parent = UIGridFrame

local v44 = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")

v44.Size = UDim2.new(0, 34, 0, 34)
v44.Position = UDim2.new(0.5, -v44.Size.X.Offset / 2, 0, 43)
v44.Icon.Position = v44.Icon.Position - UDim2.new(0, 0, 0, 2)
v44.MouseButton1Click:Connect(function() --[[ Line: 1841 | Upvalues: ScrollingFrame (ref), v23 (ref) ]]
	ScrollingFrame.CanvasPosition = Vector2.new(ScrollingFrame.CanvasPosition.X, (math.min(ScrollingFrame.CanvasSize.Y.Offset - ScrollingFrame.AbsoluteWindowSize.Y, (math.max(0, ScrollingFrame.CanvasPosition.Y - (v23 + 5))))))
end)

local v45 = MakeVRRoundButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")

v45.Rotation = 180
v45.Icon.Position = v45.Icon.Position - UDim2.new(0, 0, 0, 2)
v45.Size = UDim2.new(0, 34, 0, 34)
v45.Position = UDim2.new(0.5, -v45.Size.X.Offset / 2, 1, -v45.Size.Y.Offset - 3)
v45.MouseButton1Click:Connect(function() --[[ Line: 1858 | Upvalues: ScrollingFrame (ref), v23 (ref) ]]
	ScrollingFrame.CanvasPosition = Vector2.new(ScrollingFrame.CanvasPosition.X, (math.min(ScrollingFrame.CanvasSize.Y.Offset - ScrollingFrame.AbsoluteWindowSize.Y, (math.max(0, ScrollingFrame.CanvasPosition.Y + (v23 + 5))))))
end)
ScrollingFrame.Changed:Connect(function(p1) --[[ Line: 1869 | Upvalues: ScrollingFrame (ref), v44 (ref), v45 (ref) ]]
	if p1 ~= "AbsoluteWindowSize" and (p1 ~= "CanvasPosition" and p1 ~= "CanvasSize") then
		return
	end

	local v1 = if ScrollingFrame.CanvasPosition.Y < ScrollingFrame.CanvasSize.Y.Offset - ScrollingFrame.AbsoluteWindowSize.Y then true else false

	v44.Visible = ScrollingFrame.CanvasPosition.Y ~= 0
	v45.Visible = v1
end)
UpdateBackpackLayout()

local GamepadHintsFrame = Instance.new("Frame")

GamepadHintsFrame.Name = "GamepadHintsFrame"

local v46 = UDim2.new
local Offset = Hotbar.Size.X.Offset

GamepadHintsFrame.Size = v46(0, Offset, 0, if v22 then 95 else 60)
GamepadHintsFrame.BackgroundTransparency = v5
GamepadHintsFrame.BackgroundColor3 = v6
GamepadHintsFrame.Visible = false
GamepadHintsFrame.Parent = Backpack

local Layout = Instance.new("UIListLayout")

Layout.Name = "Layout"
Layout.Padding = UDim.new(0, 25)
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = GamepadHintsFrame

local function addGamepadHint(p1, p2) --[[ addGamepadHint | Line: 1905 | Upvalues: GamepadHintsFrame (copy), v22 (copy), v18 (copy) ]]
	local HintFrame = Instance.new("Frame")

	HintFrame.Name = "HintFrame"
	HintFrame.AutomaticSize = Enum.AutomaticSize.XY
	HintFrame.BackgroundTransparency = 1
	HintFrame.Parent = GamepadHintsFrame

	local Layout = Instance.new("UIListLayout")

	Layout.Name = "Layout"
	Layout.Padding = v22 and UDim.new(0, 20) or UDim.new(0, 12)
	Layout.FillDirection = Enum.FillDirection.Horizontal
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.VerticalAlignment = Enum.VerticalAlignment.Center
	Layout.Parent = HintFrame

	local HintImage = Instance.new("ImageLabel")

	HintImage.Name = "HintImage"
	HintImage.Size = v22 and UDim2.new(0, 60, 0, 60) or UDim2.new(0, 30, 0, 30)
	HintImage.BackgroundTransparency = 1
	HintImage.Image = p1
	HintImage.Parent = HintFrame

	local HintText = Instance.new("TextLabel")

	HintText.Name = "HintText"
	HintText.AutomaticSize = Enum.AutomaticSize.XY
	HintText.FontFace = Font.new(v18.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	HintText.TextSize = if v22 then 32 else 19
	HintText.BackgroundTransparency = 1
	HintText.Text = p2
	HintText.TextColor3 = Color3.new(255/255, 255/255, 255/255)
	HintText.TextXAlignment = Enum.TextXAlignment.Left
	HintText.TextYAlignment = Enum.TextYAlignment.Center
	HintText.TextWrapped = true
	HintText.Parent = HintFrame

	local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

	UITextSizeConstraint.MaxTextSize = HintText.TextSize
	UITextSizeConstraint.Parent = HintText
end

addGamepadHint(UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX), "Remove From Hotbar")
addGamepadHint(UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonA), "Select/Swap")
addGamepadHint(UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonB), "Close Backpack")

local function resizeGamepadHintsFrame() --[[ resizeGamepadHintsFrame | Line: 1949 | Upvalues: GamepadHintsFrame (copy), Hotbar (ref), v22 (copy), Inventory (ref) ]]
	GamepadHintsFrame.Size = UDim2.new(Hotbar.Size.X.Scale, Hotbar.Size.X.Offset, 0, if v22 then 95 else 60)
	GamepadHintsFrame.Position = UDim2.new(Hotbar.Position.X.Scale, Hotbar.Position.X.Offset, Inventory.Position.Y.Scale, Inventory.Position.Y.Offset - GamepadHintsFrame.Size.Y.Offset - 5)

	local t = {}
	local sum = 0

	for k, v in pairs((GamepadHintsFrame:GetChildren())) do
		if v:IsA("GuiObject") then
			table.insert(t, v)
		end
	end

	for i = 1, #t do
		if t[i]:IsA("GuiObject") then
			t[i].Size = UDim2.new(1, 0, 1, -5)
			t[i].Position = UDim2.new(0, 0, 0, 0)
			sum = sum + (t[i].HintText.Position.X.Offset + t[i].HintText.TextBounds.X)
		end
	end

	local v6 = (GamepadHintsFrame.AbsoluteSize.X - sum) / (#t - 1)

	for j = 1, #t do
		t[j].Position = j == 1 and UDim2.new(0, 0, 0, 0) or UDim2.new(0, t[j - 1].Position.X.Offset + t[j - 1].Size.X.Offset + v6, 0, 0)
		t[j].Size = UDim2.new(0, t[j].HintText.Position.X.Offset + t[j].HintText.TextBounds.X, 1, -5)
	end
end

local Search = Instance.new("Frame")

Search.Name = "Search"
Search.BackgroundColor3 = v15
Search.BackgroundTransparency = v16
Search.Size = UDim2.new(0, 190, 0, 30)
Search.Position = UDim2.new(1, -Search.Size.X.Offset - 5, 0, 5)
Search.Parent = Inventory

local Border = Instance.new("UIStroke")

Border.Name = "Border"
Border.Color = v17
Border.Thickness = 1
Border.Transparency = 0.8
Border.Parent = Search

local TextBox = Instance.new("TextBox")

TextBox.BackgroundTransparency = 1
TextBox.Name = "TextBox"
TextBox.Text = ""
TextBox.TextColor3 = v12
TextBox.TextStrokeTransparency = v13
TextBox.TextStrokeColor3 = v14
TextBox.FontFace = Font.new(v18.Family, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextBox.PlaceholderText = "Search"
TextBox.TextColor3 = v12
TextBox.TextTransparency = v13
TextBox.TextStrokeColor3 = v14
TextBox.ClearTextOnFocus = false
TextBox.TextTruncate = Enum.TextTruncate.AtEnd
TextBox.TextSize = v19
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Center
TextBox.Size = UDim2.new(0, 154, 0, 14)
TextBox.AnchorPoint = Vector2.new(0, 0.5)
TextBox.Position = UDim2.new(0, 8, 0.5, 0)
TextBox.ZIndex = 2
TextBox.Parent = Search

local X = Instance.new("TextButton")

X.Name = "X"
X.Text = ""
X.Size = UDim2.new(0, 30, 0, 30)
X.Position = UDim2.new(1, -X.Size.X.Offset, 0.5, -X.Size.Y.Offset / 2)
X.ZIndex = 4
X.Visible = false
X.BackgroundTransparency = 1
X.Parent = Search

local X2 = Instance.new("ImageButton")

X2.Name = "X"
X2.Image = "rbxasset://textures/ui/InspectMenu/x.png"
X2.BackgroundTransparency = 1
X2.Size = UDim2.new(0, Search.Size.Y.Offset - 20, 0, Search.Size.Y.Offset - 20)
X2.AnchorPoint = Vector2.new(0.5, 0.5)
X2.Position = UDim2.new(0.5, 0, 0.5, 0)
X2.ZIndex = 1
X2.BorderSizePixel = 0
X2.Parent = X

local function search() --[[ search | Line: 2086 | Upvalues: TextBox (copy), v36 (copy), t4 (copy), Inventory (ref), v34 (ref), UIGridFrame (ref), ScrollingFrame (ref), UpdateScrollingFrameCanvasSize (copy), X (copy) ]]
	local t = {}

	for v1 in TextBox.Text:gmatch("%S+") do
		t[v1:lower()] = true
	end

	local list = {}

	for i = v36 + 1, #t4 do
		local v2 = t4[i]

		table.insert(list, { v2, (v2:CheckTerms(t)) })
		v2.Frame.Visible = false
		v2.Frame.Parent = Inventory
	end

	table.sort(list, function(p1, p2) --[[ Line: 2101 ]]
		return p1[2] > p2[2]
	end)
	v34 = true

	local count = 0

	for i, v in ipairs(list) do
		local v3 = v[1]

		if v[2] > 0 then
			v3.Frame.Visible = true
			v3.Frame.Parent = UIGridFrame
			v3.Frame.LayoutOrder = v36 + count
			count = count + 1
		end
	end

	ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
	UpdateScrollingFrameCanvasSize()
	X.ZIndex = 3
end

local function clearResults() --[[ clearResults | Line: 2123 | Upvalues: X (copy), v34 (ref), v36 (copy), t4 (copy), UIGridFrame (ref), UpdateScrollingFrameCanvasSize (copy) ]]
	if not (X.ZIndex > 0) then
		UpdateScrollingFrameCanvasSize()

		return
	end

	v34 = false

	for i = v36 + 1, #t4 do
		local v1 = t4[i]

		v1.Frame.LayoutOrder = v1.Index
		v1.Frame.Parent = UIGridFrame
		v1.Frame.Visible = true
	end

	X.ZIndex = 0
	UpdateScrollingFrameCanvasSize()
end

local function reset() --[[ reset | Line: 2137 | Upvalues: clearResults (copy), TextBox (copy) ]]
	clearResults()
	TextBox.Text = ""
end

local function onChanged(p1) --[[ onChanged | Line: 2142 | Upvalues: TextBox (copy), v13 (copy), clearResults (copy), search (copy), X (copy) ]]
	if p1 ~= "Text" then
		return
	end

	local Text = TextBox.Text

	if Text == "" then
		TextBox.TextTransparency = v13
		clearResults()
	elseif Text ~= "" then
		TextBox.TextTransparency = 0
		search()
	end

	X.Visible = if Text == "" then false else Text ~= ""
end

local function focusLost(p1) --[[ focusLost | Line: 2156 | Upvalues: search (copy) ]]
	if not p1 then
		return
	end

	search()
end

X.MouseButton1Click:Connect(reset)
TextBox.Changed:Connect(onChanged)
TextBox.FocusLost:Connect(focusLost)
t.StateChanged.Event:Connect(function(p1) --[[ Line: 2167 | Upvalues: clearResults (copy), TextBox (copy) ]]
	if p1 then
		return
	end

	clearResults()
	TextBox.Text = ""
end)
t6[Enum.KeyCode.Escape.Value] = function(p1) --[[ Line: 2175 | Upvalues: clearResults (copy), TextBox (copy) ]]
	if not p1 then
		return
	end

	clearResults()
	TextBox.Text = ""
end

local function detectGamepad(p1) --[[ detectGamepad | Line: 2180 | Upvalues: UserInputService (copy), Search (copy) ]]
	if p1 == Enum.UserInputType.Gamepad1 and not UserInputService.VREnabled then
		Search.Visible = false
	else
		Search.Visible = true
	end
end

UserInputService.LastInputTypeChanged:Connect(detectGamepad)
GuiService.MenuOpened:Connect(function() --[[ Line: 2191 | Upvalues: BackpackGui (copy), v21 (copy) ]]
	BackpackGui.Enabled = false
	v21:setEnabled(false)
end)
GuiService.MenuClosed:Connect(function() --[[ Line: 2197 | Upvalues: BackpackGui (copy), v21 (copy) ]]
	BackpackGui.Enabled = true
	v21:setEnabled(true)
end)

local function f50(p1, p2, p3) --[[ Line: 2204 | Upvalues: GuiService (copy), v36 (copy), t4 (copy) ]]
	if p2 ~= Enum.UserInputState.Begin then
		return
	end

	if not GuiService.SelectedObject then
		return
	end

	for i = 1, v36 do
		if t4[i].Frame == GuiService.SelectedObject and t4[i].Tool then
			t4[i]:MoveToInventory()

			return
		end
	end
end

local function openClose() --[[ openClose | Line: 2220 | Upvalues: t7 (copy), Inventory (ref), AdjustHotbarFrames (copy), Hotbar (ref), v36 (copy), t4 (copy), v35 (ref), t3 (copy), UserInputService (copy), resizeGamepadHintsFrame (copy), GamepadHintsFrame (copy), ContextActionService (copy), f50 (copy), t (copy) ]]
	if not next(t7) then
		Inventory.Visible = not Inventory.Visible

		local Visible = Inventory.Visible

		AdjustHotbarFrames()
		Hotbar.Active = not Hotbar.Active

		for i = 1, v36 do
			t4[i]:SetClickability(not Visible)
		end
	end

	if Inventory.Visible then
		if v35 then
			if t3[UserInputService:GetLastInputType()] then
				resizeGamepadHintsFrame()
				GamepadHintsFrame.Visible = not UserInputService.VREnabled
			end

			enableGamepadInventoryControl()
		end
	else
		if v35 then
			GamepadHintsFrame.Visible = false
		end

		disableGamepadInventoryControl()
	end

	if Inventory.Visible then
		ContextActionService:BindAction("BackpackRemoveSlot", f50, false, Enum.KeyCode.ButtonX)
	else
		ContextActionService:UnbindAction("BackpackRemoveSlot")
	end

	t.IsOpen = Inventory.Visible
	t.StateChanged:Fire(Inventory.Visible)
end

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
t.OpenClose = openClose

while not LocalPlayer do
	task.wait()
	LocalPlayer = Players.LocalPlayer
end

LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)

if LocalPlayer.Character then
	OnCharacterAdded(LocalPlayer.Character)
end

UserInputService.InputBegan:Connect(OnInputBegan)
UserInputService.TextBoxFocused:Connect(function() --[[ Line: 2283 | Upvalues: v33 (ref) ]]
	v33 = true
end)
UserInputService.TextBoxFocusReleased:Connect(function() --[[ Line: 2286 | Upvalues: v33 (ref) ]]
	v33 = false
end)
t6[Backspace] = function() --[[ Line: 2291 | Upvalues: v30 (ref), Humanoid (ref), t5 (copy) ]]
	if not (v30 and Humanoid) then
		return
	end

	Humanoid:UnequipTools()

	if not v30 then
		return
	end

	v30:ToggleSelect()
	t5[v30]:UpdateEquipView()
	v30 = nil
end
UserInputService.LastInputTypeChanged:Connect(OnUISChanged)
OnUISChanged()

local v51

if not UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
	UserInputService.GamepadConnected:Connect(function(p13) --[[ Line: 2305 ]]
		if p13 ~= Enum.UserInputType.Gamepad1 then
			return
		end

		gamepadConnected()
	end)
	UserInputService.GamepadDisconnected:Connect(function(p13) --[[ Line: 2310 ]]
		if p13 ~= Enum.UserInputType.Gamepad1 then
			return
		end

		gamepadDisconnected()
	end)
	function t.SetBackpackEnabled(p13, p23) --[[ SetBackpackEnabled | Line: 2318 | Upvalues: v20 (ref) ]]
		v20 = p23
	end
	function t.IsOpened(p13) --[[ IsOpened | Line: 2323 | Upvalues: t (copy) ]]
		return t.IsOpen
	end
	function t.GetBackpackEnabled(p13) --[[ GetBackpackEnabled | Line: 2328 | Upvalues: v20 (ref) ]]
		return v20
	end
	function t.GetStateChangedEvent(p13) --[[ GetStateChangedEvent | Line: 2333 | Upvalues: t (copy) ]]
		return t.StateChanged
	end
	RunService.Heartbeat:Connect(function() --[[ Line: 2338 | Upvalues: v20 (ref), StarterGui (copy), v32 (ref), Backpack (ref), v29 (ref), v24 (ref), ContextActionService (copy), v26 (ref) ]]
		local v1 = v20

		task.wait()

		local v2 = if v1 then StarterGui:GetCore("TopbarEnabled") else v1

		v32 = v2
		Backpack.Visible = v2

		if v2 then
			if v29 >= 1 and (v2 and not v24) then
				v24 = true
				ContextActionService:BindAction("BackpackHotbarEquip", v26, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
			end
		else
			disableGamepadInventoryControl()
			v24 = false
			ContextActionService:UnbindAction("BackpackHotbarEquip")
		end
	end)
	v51 = function() --[[ OnPreferredTransparencyChanged | Line: 2343 | Upvalues: GuiService (copy), v5 (ref), Inventory (ref), v8 (ref), t4 (copy), v16 (ref), Search (copy) ]]
		local PreferredTransparency = GuiService.PreferredTransparency

		v5 = PreferredTransparency * 0.65
		Inventory.BackgroundTransparency = v5
		v8 = PreferredTransparency * 0.5

		for i2, v in ipairs(t4) do
			v.Frame.BackgroundTransparency = v8
		end

		v16 = PreferredTransparency * 0.2
		Search.BackgroundTransparency = v16
	end
	GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(v51)

	return t
end

gamepadConnected()
UserInputService.GamepadConnected:Connect(function(p13) --[[ Line: 2305 ]]
	if p13 ~= Enum.UserInputType.Gamepad1 then
		return
	end

	gamepadConnected()
end)
UserInputService.GamepadDisconnected:Connect(function(p13) --[[ Line: 2310 ]]
	if p13 ~= Enum.UserInputType.Gamepad1 then
		return
	end

	gamepadDisconnected()
end)
function t.SetBackpackEnabled(p13, p23) --[[ SetBackpackEnabled | Line: 2318 | Upvalues: v20 (ref) ]]
	v20 = p23
end
function t.IsOpened(p13) --[[ IsOpened | Line: 2323 | Upvalues: t (copy) ]]
	return t.IsOpen
end
function t.GetBackpackEnabled(p13) --[[ GetBackpackEnabled | Line: 2328 | Upvalues: v20 (ref) ]]
	return v20
end
function t.GetStateChangedEvent(p13) --[[ GetStateChangedEvent | Line: 2333 | Upvalues: t (copy) ]]
	return t.StateChanged
end
RunService.Heartbeat:Connect(function() --[[ Line: 2338 | Upvalues: v20 (ref), StarterGui (copy), v32 (ref), Backpack (ref), v29 (ref), v24 (ref), ContextActionService (copy), v26 (ref) ]]
	local v1 = v20

	task.wait()

	local v2 = if v1 then StarterGui:GetCore("TopbarEnabled") else v1

	v32 = v2
	Backpack.Visible = v2

	if v2 then
		if v29 >= 1 and (v2 and not v24) then
			v24 = true
			ContextActionService:BindAction("BackpackHotbarEquip", v26, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
		end
	else
		disableGamepadInventoryControl()
		v24 = false
		ContextActionService:UnbindAction("BackpackHotbarEquip")
	end
end)
v51 = function() --[[ OnPreferredTransparencyChanged | Line: 2343 | Upvalues: GuiService (copy), v5 (ref), Inventory (ref), v8 (ref), t4 (copy), v16 (ref), Search (copy) ]]
	local PreferredTransparency = GuiService.PreferredTransparency

	v5 = PreferredTransparency * 0.65
	Inventory.BackgroundTransparency = v5
	v8 = PreferredTransparency * 0.5

	for i2, v in ipairs(t4) do
		v.Frame.BackgroundTransparency = v8
	end

	v16 = PreferredTransparency * 0.2
	Search.BackgroundTransparency = v16
end
GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(v51)

return t