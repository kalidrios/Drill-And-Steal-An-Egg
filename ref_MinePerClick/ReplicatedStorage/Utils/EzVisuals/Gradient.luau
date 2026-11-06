-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")

local function evalColorSequence(p1, p2) --[[ evalColorSequence | Line: 58 ]]
	local t = {}
	local v1 = p2 + 1

	for i = 0, 2 do
		for j = 1, #p1 do
			table.insert(t, {
				Time = p1[j].Time + i,
				Value = p1[j].Value
			})
		end
	end

	for k = 1, #t - 1 do
		local v2 = t[k]
		local v3 = t[k + 1]

		if v2.Time <= v1 and v1 < v3.Time then
			local v4 = (v1 - v2.Time) / (v3.Time - v2.Time)

			return Color3.new((v3.Value.R - v2.Value.R) * v4 + v2.Value.R, (v3.Value.G - v2.Value.G) * v4 + v2.Value.G, (v3.Value.B - v2.Value.B) * v4 + v2.Value.B)
		end
	end
end

local function evalNumberSequence(p1, p2) --[[ evalNumberSequence | Line: 86 ]]
	local t = {}
	local v1 = p2 + 1

	for i = 0, 2 do
		for j = 1, #p1 do
			table.insert(t, {
				Time = p1[j].Time + i,
				Value = p1[j].Value
			})
		end
	end

	for k = 1, #t - 1 do
		local v2 = t[k]
		local v3 = t[k + 1]

		if v2.Time <= v1 and v1 < v3.Time then
			return v2.Value + (v3.Value - v2.Value) * ((v1 - v2.Time) / (v3.Time - v2.Time))
		end
	end
end

local t = {}

t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 115 | Upvalues: RunService (copy), t (copy) ]]
	assert(p1, "UIInstance not provided")
	assert(p1:IsA("GuiObject") or p1:IsA("UIStroke"), "UIInstance is not a GuiObject or UIStroke")
	assert(p2, "ColorSequence not provided")
	assert(p3, "TransparencySequence not provided")
	assert(if typeof(p2) == "ColorSequence" then true else false, "ColorSequence is not a ColorSequence")
	assert(if typeof(p3) == "number" then true elseif typeof(p3) == "NumberSequence" then true else false, "TransparencySequence is not a number or NumberSequence")
	assert(if #p2.Keypoints <= 19 then true else false, "ColorSequence has too many keypoints")

	if typeof(p3) == "NumberSequence" then
		assert(#p3.Keypoints <= 19, "TransparencySequence has too many keypoints")
	end

	local t2 = {
		UIInstance = p1
	}

	t2.Instance = p1:FindFirstChildWhichIsA("UIGradient") or Instance.new("UIGradient")
	t2.IsPaused = false
	t2.ColorSequenceTarget = p2
	t2.ColorSequence = p2
	t2.TrueColorSequence = nil
	t2.ColorSequenceBlendRate = 1
	t2.TransparencySequenceTarget = nil
	t2.TransparencySequence = nil
	t2.TrueTransparencySequence = nil
	t2.TransparencySequenceBlendRate = 1
	t2.Offset = 0
	t2.OffsetTarget = nil
	t2.OffsetSpeed = 0
	t2.OffsetSpeedTarget = 0
	t2.OffsetAcceleration = 1
	t2.TransparencyOffset = 0
	t2.TransparencyOffsetTarget = nil
	t2.TransparencyOffsetSpeed = 0
	t2.TransparencyOffsetSpeedTarget = 0
	t2.TransparencyOffsetAcceleration = 1
	t2.Rotation = 0
	t2.RotationSpeed = 0
	t2.RotationSpeedTarget = 0
	t2.RotationAcceleration = 0
	t2.RotationTarget = nil
	t2.Connection = nil
	t2.IsText = false

	if typeof(p3) == "number" then
		t2.TransparencySequenceTarget = NumberSequence.new({ NumberSequenceKeypoint.new(0, p3), NumberSequenceKeypoint.new(1, p3) })
	elseif typeof(p3) == "NumberSequence" then
		t2.TransparencySequenceTarget = p3
	else
		warn("Weird type of data?")
	end

	t2.TransparencySequence = t2.TransparencySequenceTarget

	if p1:IsA("TextLabel") or (p1:IsA("TextBox") or p1:IsA("TextButton")) then
		t2.IsText = true
	end

	t2.Connection = RunService.Heartbeat:Connect(function(p1) --[[ Line: 178 | Upvalues: t2 (copy) ]]
		if t2.IsPaused then
			return
		end

		if not t2.UIInstance or t2.UIInstance.Parent == nil then
			t2:Destroy()

			return
		end

		if t2.ColorSequenceBlendRate == 1 then
			t2.ColorSequence = t2.ColorSequenceTarget
		else
			t2:EqualizeColorSequenceKeypoints()
		end

		if t2.TransparencySequenceBlendRate == 1 then
			t2.TransparencySequence = t2.TransparencySequenceTarget
		end

		if t2.OffsetTarget then
			t2.Offset = t2.Offset + (t2.OffsetTarget - t2.Offset) * t2.OffsetAcceleration
		else
			t2.OffsetSpeed = t2.OffsetSpeed + (t2.OffsetSpeedTarget - t2.OffsetSpeed) * t2.OffsetAcceleration * p1

			local v1 = t2

			v1.Offset = v1.Offset + t2.OffsetSpeed * p1
		end

		if t2.TransparencyOffsetTarget then
			t2.TransparencyOffset = t2.TransparencyOffset + (t2.TransparencyOffsetTarget - t2.TransparencyOffset) * t2.TransparencyOffsetAcceleration
		else
			t2.TransparencyOffsetSpeed = t2.TransparencyOffsetSpeed + (t2.TransparencyOffsetSpeedTarget - t2.TransparencyOffsetSpeed) * t2.TransparencyOffsetAcceleration * p1

			local v2 = t2

			v2.TransparencyOffset = v2.TransparencyOffset + t2.TransparencyOffsetSpeed * p1
		end

		if t2.RotationTarget then
			t2.Rotation = t2.Rotation + (t2.RotationTarget - t2.Rotation) * t2.RotationAcceleration
		else
			t2.RotationSpeed = t2.RotationSpeed + (t2.RotationSpeedTarget - t2.RotationSpeed) * t2.RotationAcceleration * p1

			local v3 = t2

			v3.Rotation = v3.Rotation + t2.RotationSpeed * p1
		end

		t2.Instance.Rotation = t2.Rotation
		t2.Instance.Color = t2:CalculateTrueColorSequence()
		t2.Instance.Transparency = t2:CalculateTrueTransparencySequence()
	end)
	t2.Instance.Parent = t2.UIInstance

	return setmetatable(t2, t)
end
function t.SetColorSequence(p1, p2, p3) --[[ SetColorSequence | Line: 228 ]]
	assert(if typeof(p2) == "ColorSequence" then true else false, "Sequence argument is nil or not a ColorSequence")
	p1.ColorSequenceBlendRate = p3 or 1
	p1.ColorSequenceTarget = p2

	return p1.ColorSequenceTarget
end
function t.SetOffset(p1, p2, p3) --[[ SetOffset | Line: 237 ]]
	assert(if typeof(p2) == "number" then true else false, "Offset isn\'t a number")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.OffsetTarget = p2
	p1.OffsetSpeed = 0
	p1.OffsetSpeedTarget = 0
	p1.OffsetAcceleration = math.clamp(p3, 0, 1)
end
function t.SetOffsetSpeed(p1, p2, p3) --[[ SetOffsetSpeed | Line: 249 ]]
	assert(if typeof(p2) == "number" then true else false, "Offset isn\'t a number")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.OffsetSpeedTarget = p2
	p1.OffsetTarget = nil
	p1.OffsetAcceleration = math.clamp(p3, 0, 1)
end
function t.SetRotation(p1, p2, p3) --[[ SetRotation | Line: 260 ]]
	assert(if typeof(p2) == "number" then true else false, "Offset isn\'t a number")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.RotationTarget = p2
	p1.RotationSpeed = 0
	p1.RotationSpeedTarget = 0
	p1.RotationAcceleration = math.clamp(p3, 0, 1)
end
function t.SetRotationSpeed(p1, p2, p3) --[[ SetRotationSpeed | Line: 272 ]]
	assert(if typeof(p2) == "number" then true else false, "Offset isn\'t a number")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.RotationSpeedTarget = p2
	p1.RotationTarget = nil
	p1.RotationAcceleration = math.clamp(p3, 0, 1)
end
function t.SetTransparencyOffset(p1, p2, p3) --[[ SetTransparencyOffset | Line: 283 ]]
	assert(if typeof(p2) == "number" then true else false, "Offset isn\'t a number")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.TransparencyOffsetTarget = p2
	p1.TransparencyOffsetSpeed = 0
	p1.TransparencyOffsetSpeedTarget = 0
	p1.TransparencyOffsetAcceleration = math.clamp(p3, 0, 1)
end
function t.SetTransparencyOffsetSpeed(p1, p2, p3) --[[ SetTransparencyOffsetSpeed | Line: 295 ]]
	assert(if typeof(p2) == "number" then true else false, "Offset isn\'t a number")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")
	p1.TransparencyOffsetSpeedTarget = p2
	p1.TransparencyOffsetTarget = nil
	p1.TransparencyOffsetAcceleration = math.clamp(p3, 0, 1)
end
function t.SetTransparencySequence(p1, p2, p3) --[[ SetTransparencySequence | Line: 306 ]]
	assert(p2, "Transparency is nil")
	assert(if typeof(p3) == "number" then true else false, "Acceleration isn\'t a number")

	if typeof(p2) == "number" then
		p1.TransparencyTarget = NumberSequence.new({ NumberSequenceKeypoint.new(0, p2), NumberSequenceKeypoint.new(1, p2) })
	elseif typeof(p2) == "NumberSequence" then
		p1.TransparencyTarget = p2
	else
		warn("Weird type of data?")
	end

	p1.TransparencyAcceleration = math.clamp(p3, 0, 1)
end
function t.EqualizeColorSequenceKeypoints(p1) --[[ EqualizeColorSequenceKeypoints | Line: 323 | Upvalues: evalColorSequence (copy) ]]
	local Keypoints = p1.ColorSequenceTarget.Keypoints
	local Keypoints2 = p1.ColorSequence.Keypoints
	local t = {}

	if #Keypoints == #Keypoints2 then
		for v1, v2 in Keypoints do
			table.insert(t, (ColorSequenceKeypoint.new(v2.Time, (evalColorSequence(Keypoints2, v2.Time):Lerp(v2.Value, p1.ColorSequenceBlendRate)))))
		end
	else
		for v5, v6 in Keypoints do
			table.insert(t, (ColorSequenceKeypoint.new(v6.Time, evalColorSequence(Keypoints2, v6.Time))))
		end
	end

	p1.ColorSequence = ColorSequence.new(t)
end
function t.EqualizeTransparencySequenceKeypoints(p1) --[[ EqualizeTransparencySequenceKeypoints | Line: 345 | Upvalues: evalNumberSequence (copy) ]]
	local Keypoints = p1.TransparencySequenceTarget.Keypoints
	local Keypoints2 = p1.TransparencySequence.Keypoints
	local t = {}

	if #Keypoints == #Keypoints2 then
		for v1, v2 in Keypoints do
			table.insert(t, (NumberSequenceKeypoint.new(v2.Time, (evalNumberSequence(Keypoints2, v2.Time):Lerp(v2.Value, p1.TransparencySequenceBlendRate)))))
		end
	else
		for v5, v6 in Keypoints do
			table.insert(t, (NumberSequenceKeypoint.new(v6.Time, evalNumberSequence(Keypoints2, v6.Time))))
		end
	end

	print(t[1].Value, t[2].Value, t[3].Value, t[4].Value, t[5].Value)
	p1.TransparencySequence = NumberSequence.new(t)
end
function t.CalculateTrueColorSequence(p1) --[[ CalculateTrueColorSequence | Line: 368 | Upvalues: evalColorSequence (copy) ]]
	local v1 = 100
	local count = 5
	local t = {}

	for v2, v3 in p1.ColorSequence.Keypoints do
		local v4 = v3.Time + p1.Offset

		if v4 > 1 or v4 < 0 then
			v4 = v4 % 1
		end

		local v5 = ColorSequenceKeypoint.new(v4, v3.Value)

		if v5.Time <= v1 then
			t[count - 1] = v5
			v1 = v5.Time
			count = count - 1

			continue
		end

		t[#t + 1] = v5
	end

	local t2 = {}

	for v6, v7 in t do
		table.insert(t2, v7)
	end

	table.sort(t2, function(p1, p2) --[[ Line: 393 ]]
		return p1.Time < p2.Time
	end)

	if t2[1].Time ~= 0 then
		table.insert(t2, 1, (ColorSequenceKeypoint.new(0, evalColorSequence(t2, 0))))
	end

	if t2[#t2].Time ~= 1 then
		table.insert(t2, (ColorSequenceKeypoint.new(1, evalColorSequence(t2, 1))))
	end

	p1.TrueColorSequence = ColorSequence.new(t2)

	return p1.TrueColorSequence
end
function t.CalculateTrueTransparencySequence(p1) --[[ CalculateTrueTransparencySequence | Line: 411 | Upvalues: evalNumberSequence (copy) ]]
	if #p1.TransparencySequenceTarget.Keypoints == 2 and p1.TransparencySequenceTarget.Keypoints[1].Value == p1.TransparencySequenceTarget.Keypoints[2].Value then
		p1.TrueTransparencySequence = p1.TransparencySequenceTarget

		return p1.TrueTransparencySequence
	end

	local count = #p1.TransparencySequence.Keypoints + 1
	local v1 = (1 / 0)
	local t = {}

	for v2, v3 in p1.TransparencySequence.Keypoints do
		local v4 = v3.Time + p1.TransparencyOffset

		if v4 > 1 or v4 < 0 then
			v4 = v4 % 1
		end

		local v5 = NumberSequenceKeypoint.new(v4, v3.Value)

		if v5.Time <= v1 then
			t[count - 1] = v5
			v1 = v5.Time
			count = count - 1

			continue
		end

		t[#t + 1] = v5
	end

	local t2 = {}

	for v6, v7 in t do
		table.insert(t2, v7)
	end

	table.sort(t2, function(p1, p2) --[[ Line: 443 ]]
		return p1.Time < p2.Time
	end)

	if t2[1].Time ~= 0 then
		table.insert(t2, 1, (NumberSequenceKeypoint.new(0, evalNumberSequence(t2, 0))))
	end

	if t2[#t2].Time ~= 1 then
		table.insert(t2, (NumberSequenceKeypoint.new(1, (evalNumberSequence(t2, 1)))))
	end

	p1.TrueTransparencySequence = NumberSequence.new(t2)

	return p1.TrueTransparencySequence
end
function t.Pause(p1) --[[ Pause | Line: 462 ]]
	p1.IsPaused = true
end
function t.Resume(p1) --[[ Resume | Line: 466 ]]
	p1.IsPaused = false
end
function t.Destroy(p1) --[[ Destroy | Line: 470 ]]
	p1.Connection:Disconnect()

	if not p1.Instance then
		return
	end

	p1.Instance:Destroy()
	p1.Instance = nil
end

return table.freeze(t)