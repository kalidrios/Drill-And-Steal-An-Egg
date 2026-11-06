-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}

t.__index = t

local TweenService = game:GetService("TweenService")

local function createShimmer(p1, p2) --[[ createShimmer | Line: 39 ]]
	local UIShimmer = Instance.new("Frame")

	UIShimmer.Name = "UIShimmer"

	if p2 then
		UIShimmer.BackgroundColor3 = p2
	else
		UIShimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end

	UIShimmer.BackgroundTransparency = 0
	UIShimmer.ClipsDescendants = true
	UIShimmer.Size = UDim2.new(1, 0, 1, 0)
	UIShimmer.AnchorPoint = Vector2.new(0.5, 0.5)
	UIShimmer.Position = UDim2.new(0.5, 0, 0.5, 0)
	UIShimmer.BorderSizePixel = 0
	UIShimmer.Visible = false
	UIShimmer.Parent = p1

	local function v1() --[[ updateCornerRadius | Line: 58 | Upvalues: UIShimmer (copy), v1 (copy) ]]
		if not UIShimmer.Parent:FindFirstChildOfClass("UICorner") then
			return
		end

		local UICorner = UIShimmer.Parent:FindFirstChildOfClass("UICorner")
		local UICorner2 = Instance.new("UICorner")

		UICorner2.CornerRadius = UICorner.CornerRadius
		UICorner2.Parent = UIShimmer
		UICorner2:GetPropertyChangedSignal("CornerRadius"):Connect(v1)
	end

	UIShimmer:GetPropertyChangedSignal("Parent"):Connect(v1)
	v1()

	local function v2() --[[ updatePaddingOffset | Line: 75 | Upvalues: UIShimmer (copy), v2 (copy) ]]
		if not UIShimmer.Parent:FindFirstChildOfClass("UIPadding") then
			return
		end

		local UIPadding = UIShimmer.Parent:FindFirstChildOfClass("UIPadding")

		UIShimmer.Size = UDim2.new(1 / (1 - (UIPadding.PaddingLeft.Scale + UIPadding.PaddingRight.Scale)), UIPadding.PaddingLeft.Offset + UIPadding.PaddingRight.Offset, 1 / (1 - (UIPadding.PaddingTop.Scale + UIPadding.PaddingBottom.Scale)), UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)
		UIShimmer.Position = UDim2.new(0.5, -(UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / 2, 0.5, -(UIPadding.PaddingTop.Offset - UIPadding.PaddingBottom.Offset) / 2)
		print(UIShimmer.Position)
		UIPadding:GetPropertyChangedSignal("PaddingLeft"):Connect(v2)
		UIPadding:GetPropertyChangedSignal("PaddingRight"):Connect(v2)
		UIPadding:GetPropertyChangedSignal("PaddingTop"):Connect(v2)
		UIPadding:GetPropertyChangedSignal("PaddingBottom"):Connect(v2)
	end

	UIShimmer:GetPropertyChangedSignal("Parent"):Connect(v2)
	v2()

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Rotation = 15

	if p2 then
		UIGradient.Color = ColorSequence.new(p2)
	else
		UIGradient.Color = ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
	end

	UIGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.15, 1),
		NumberSequenceKeypoint.new(0.5, 0.55),
		NumberSequenceKeypoint.new(0.85, 1),
		NumberSequenceKeypoint.new(1, 1)
	})
	UIGradient.Offset = Vector2.new(-1, 0)
	UIGradient.Parent = UIShimmer

	return UIShimmer
end

t.PlaybackState = nil
function t.new(p1, p2, p3, p4, p5, p6, p7, p8) --[[ new | Line: 129 | Upvalues: t (copy), createShimmer (copy), TweenService (copy) ]]
	assert(if typeof(p1) == "Instance" then p1:IsA("GuiObject") else false, "Invalid parent argument. Expected GuiObject.")

	local v2 = p2 or 1

	assert(if typeof(v2) == "number" then true else false, "Invalid time argument. Expected number.")

	local v4 = p3 or Enum.EasingStyle.Linear
	local v5, v6

	if typeof(v4) == "EnumItem" and v4.EnumType == Enum.EasingStyle then
		v5 = v4
		v6 = true
	else
		v5 = v4
		v6 = false
	end

	assert(v6, "Invalid style argument. Expected EasingStyle enum.")

	local v7 = p4 or Enum.EasingDirection.InOut
	local v8, v9

	if typeof(v7) == "EnumItem" and v7.EnumType == Enum.EasingDirection then
		v8 = v7
		v9 = true
	else
		v8 = v7
		v9 = false
	end

	assert(v9, "Invalid direction argument. Expected EasingDirection enum.")

	local v10 = p5 or -1

	assert(if typeof(v10) == "number" then true else false, "Invalid repeatCount argument. Expected number.")

	local v12 = p6 or false

	assert(if typeof(v12) == "boolean" then true else false, "Invalid reverses argument. Expected boolean.")

	local v14 = p7 or 0

	assert(if typeof(v14) == "number" then true else false, "Invalid delayTime argument. Expected number.")

	local v17 = setmetatable({}, t)
	local v19 = if v5 then v5 else Enum.EasingStyle.Linear
	local v20 = if v8 then v8 else Enum.EasingDirection.InOut
	local v21 = createShimmer(p1, p8)

	v17._frame = v21
	v17._gradient = v21:FindFirstChildOfClass("UIGradient")
	v17._corner = v21:FindFirstChildOfClass("UICorner")
	v17._tween = TweenService:Create(v17._gradient, TweenInfo.new(v2 or 1, v19, v20, v10 or -1, v12 or false, v14 or 0), {
		Offset = Vector2.new(1, 0)
	})
	v17._tween.Completed:Connect(function() --[[ Line: 190 | Upvalues: v17 (copy) ]]
		v17:_TweenCompleted()
	end)

	return v17
end
function t._TweenCompleted(p1) --[[ _TweenCompleted | Line: 198 ]]
	p1._frame.Visible = false
	p1.PlaybackState = Enum.PlaybackState.Completed
end
function t.GetFrame(p1) --[[ GetFrame | Line: 204 ]]
	return p1._frame
end
function t.GetGradient(p1) --[[ GetGradient | Line: 209 ]]
	return p1._gradient
end
function t.GetCorner(p1) --[[ GetCorner | Line: 214 ]]
	return p1._corner
end
function t.Play(p1) --[[ Play | Line: 219 ]]
	pcall(function() --[[ Line: 220 | Upvalues: p1 (copy) ]]
		p1.PlaybackState = Enum.PlaybackState.Begin
		p1._frame.Visible = true
		p1._tween:Play()
		p1.PlaybackState = Enum.PlaybackState.Playing
	end)
end
function t.Pause(p1) --[[ Pause | Line: 229 ]]
	if p1.PlaybackState ~= Enum.PlaybackState.Playing then
		return
	end

	p1._tween:Pause()
	p1.PlaybackState = Enum.PlaybackState.Paused
end
function t.Cancel(p1) --[[ Cancel | Line: 237 ]]
	p1._tween:Cancel()
	p1._frame.Visible = false
	p1.PlaybackState = Enum.PlaybackState.Cancelled
end

return t