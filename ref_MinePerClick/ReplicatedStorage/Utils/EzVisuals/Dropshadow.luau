-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local t = {}

t.__index = t
function t.new(p1, p2, p3, p4) --[[ new | Line: 30 | Upvalues: RunService (copy), t (copy) ]]
	assert(p1, "UIInstance not provided")
	assert(p1:IsA("GuiObject") or p1:IsA("UIStroke"), "UIInstance is not a GuiObject or UIStroke")

	if p2 then
		assert(typeof(p2) == "Color3", "Color is not a Color3")
	end

	if p3 then
		assert(typeof(p3) == "number", "Transparency is not a number")
	end

	if p4 then
		assert(typeof(p4) == "Vector2", "Offset is not a Vector2")
	end

	local t2 = {
		UIInstance = p1,
		Instance = p1:Clone(),
		IsPaused = false
	}

	t2.Color = if p2 then p2 else Color3.new()
	t2.ColorTarget = if p2 then p2 else Color3.new()
	t2.ColorAcceleration = 1
	t2.Transparency = p3 or 0
	t2.TransparencyTarget = p3 or 0
	t2.TransparencyAcceleration = 1
	t2.Offset = if p4 then p4 else Vector2.new(-4, 4)
	t2.OffsetTarget = if p4 then p4 else Vector2.new()
	t2.OffsetAcceleration = 1
	t2.Connection = nil
	t2.IsText = false
	t2.Instance.Size = UDim2.new(1, 0, 1, 0)
	t2.Instance:ClearAllChildren()
	t2.Instance.Position = UDim2.new(0, t2.Offset.X, 0, t2.Offset.Y)

	if p1:IsA("TextLabel") or (p1:IsA("TextBox") or p1:IsA("TextButton")) then
		t2.Instance.TextColor3 = t2.Color
		t2.IsText = true
	end

	t2.Instance.Parent = t2.UIInstance
	t2.Connection = RunService.Heartbeat:Connect(function(p1) --[[ Line: 73 | Upvalues: t2 (copy) ]]
		if t2.IsPaused then
			return
		end

		if not t2.UIInstance or t2.UIInstance.Parent == nil then
			t2:Destroy()

			return
		end

		t2.Color = t2.Color:Lerp(t2.ColorTarget, t2.ColorAcceleration)
		t2.Offset = t2.Offset:Lerp(t2.OffsetTarget, t2.OffsetAcceleration)
		t2.Transparency = t2.Transparency + (t2.TransparencyTarget - t2.Transparency) * t2.TransparencyAcceleration
		t2.Instance.Position = UDim2.new(0, t2.Offset.X, 0, t2.Offset.Y)

		if t2.IsText then
			t2.Instance.Text = t2.UIInstance.Text
			t2.Instance.TextTransparency = t2.Transparency
			t2.Instance.TextColor3 = t2.Color
		end

		t2.Instance.ZIndex = t2.UIInstance.ZIndex - 1
	end)

	return setmetatable(t2, t)
end
function t.SetOffset(p1, p2, p3) --[[ SetOffset | Line: 101 ]]
	assert(if typeof(p2) == "Vector2" then true else false, "Offset isn\'t a Vector2")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.OffsetTarget = p2
	p1.OffsetAcceleration = math.clamp(p3, 0, 1)
end
function t.SetTransparency(p1, p2, p3) --[[ SetTransparency | Line: 111 ]]
	assert(if typeof(p2) == "number" then true else false, "Transparency isn\'t a number")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.TransparencyTarget = p2
	p1.TransparencyAcceleration = math.clamp(p3, 0, 1)
end
function t.SetColor(p1, p2, p3) --[[ SetColor | Line: 121 ]]
	assert(if typeof(p2) == "Color3" then true else false, "Color isn\'t a Color3")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.ColorTarget = p2
	p1.ColorAcceleration = math.clamp(p3, 0, 1)
end
function t.Pause(p1) --[[ Pause | Line: 131 ]]
	p1.IsPaused = true
end
function t.Resume(p1) --[[ Resume | Line: 135 ]]
	p1.IsPaused = false
end
function t.Destroy(p1) --[[ Destroy | Line: 139 ]]
	p1.Connection:Disconnect()

	if not p1.Instance then
		return
	end

	p1.Instance:Destroy()
	p1.Instance = nil
end

return table.freeze(t)