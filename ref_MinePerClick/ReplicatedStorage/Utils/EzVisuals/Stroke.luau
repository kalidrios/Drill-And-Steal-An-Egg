-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local t = {}

t.__index = t
function t.new(p1, p2, p3, p4) --[[ new | Line: 32 | Upvalues: RunService (copy), t (copy) ]]
	assert(p1, "UIInstance not provided")
	assert(p1:IsA("GuiObject") or p1:IsA("UIStroke"), "UIInstance is not a GuiObject or UIStroke")
	assert(p2, "Size not provided")
	assert(if typeof(p2) == "number" then true else false, "Size is not a number")

	if p3 then
		assert(typeof(p3) == "Color3", "Color is not a Color3")
	end

	if p4 then
		assert(typeof(p4) == "number", "Transparency is not a number")
	end

	local t2 = {
		UIInstance = p1
	}

	t2.Instance = p1:FindFirstChildWhichIsA("UIStroke") or Instance.new("UIStroke")
	t2.IsPaused = false
	t2.Color = if p3 then p3 else Color3.new(255/255, 255/255, 255/255)
	t2.ColorTarget = if p3 then p3 else Color3.new(255/255, 255/255, 255/255)
	t2.ColorAcceleration = 1
	t2.Transparency = p4 or 0
	t2.TransparencyTarget = p4 or 0
	t2.TransparencyAcceleration = 1
	t2.Size = p2
	t2.SizeTarget = p2
	t2.SizeAcceleration = 1
	t2.Connection = nil
	t2.IsText = false

	if p1:IsA("TextLabel") or (p1:IsA("TextBox") or p1:IsA("TextButton")) then
		t2.IsText = true
	end

	t2.Instance.Parent = t2.UIInstance
	t2.Connection = RunService.Heartbeat:Connect(function(p1) --[[ Line: 70 | Upvalues: t2 (copy) ]]
		if t2.IsPaused then
			return
		end

		if t2.UIInstance and t2.UIInstance.Parent ~= nil then
			t2.Color = t2.Color:Lerp(t2.ColorTarget, t2.ColorAcceleration * p1)
			t2.Size = t2.Size + (t2.SizeTarget - t2.Size) * t2.SizeAcceleration * p1
			t2.Transparency = t2.Transparency + (t2.TransparencyTarget - t2.Transparency) * t2.TransparencyAcceleration * p1
			t2.Instance.Transparency = t2.Transparency
			t2.Instance.Color = t2.Color
			t2.Instance.Thickness = t2.Size
		else
			t2:Destroy()
		end
	end)

	return setmetatable(t2, t)
end
function t.SetSize(p1, p2, p3) --[[ SetSize | Line: 92 ]]
	assert(if typeof(p2) == "number" then true else false, "Size isn\'t a number")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.SizeTarget = p2
	p1.SizeAcceleration = math.clamp(p3, 0, 1)
end
function t.SetTransparency(p1, p2, p3) --[[ SetTransparency | Line: 102 ]]
	assert(if typeof(p2) == "number" then true else false, "Transparency isn\'t a number")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.TransparencyTarget = p2
	p1.TransparencyAcceleration = math.clamp(p3, 0, 1)
end
function t.SetColor(p1, p2, p3) --[[ SetColor | Line: 112 ]]
	assert(if typeof(p2) == "Color3" then true else false, "Color isn\'t a Color3")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.ColorTarget = p2
	p1.ColorAcceleration = math.clamp(p3, 0, 1)
end
function t.Pause(p1) --[[ Pause | Line: 122 ]]
	p1.IsPaused = true
end
function t.Resume(p1) --[[ Resume | Line: 126 ]]
	p1.IsPaused = false
end
function t.Destroy(p1) --[[ Destroy | Line: 130 ]]
	p1.Connection:Disconnect()

	if not p1.Instance then
		return
	end

	p1.Instance:Destroy()
	p1.Instance = nil
end

return table.freeze(t)