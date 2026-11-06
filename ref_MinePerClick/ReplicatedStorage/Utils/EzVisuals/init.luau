-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Presets = script.Presets
local t = {
	Gradient = require(script.Gradient),
	Stroke = require(script.Stroke),
	Dropshadow = require(script.Dropshadow),
	Templates = require(script.GradientTemplates)
}

t.__index = t
t.CurrentEffects = {}

local t2 = {
	GuiObject = "Visible",
	ScreenGui = "Enabled",
	BillboardGui = "Enabled",
	SurfaceGui = "Enabled"
}

local function ValidateIsPreset(p1) --[[ ValidateIsPreset | Line: 32 | Upvalues: Presets (copy) ]]
	return Presets:FindFirstChild(p1) ~= nil
end

function t.new(p1, p2, p3, p4, p5, p6, p7, p8) --[[ new | Line: 36 | Upvalues: Presets (copy), t2 (copy), t (copy) ]]
	assert(p1, "UIInstance not provided")
	assert(p2, "EffectType not provided")
	assert(p1:IsA("GuiObject"), "UIInstance is not a GuiObject")
	assert(if typeof(p2) == "string" then true else false, "effectType is not a string")
	assert(if Presets:FindFirstChild(p2) == nil then false else true, "effectType is not a valid preset")

	if p3 then
		assert(typeof(p3) == "number", "speed is not a number")
	end

	if p4 then
		assert(typeof(p4) == "number", "size is not a number")
	end

	if p6 then
		assert(if typeof(p6) == "ColorSequence" then true elseif typeof(p6) == "Color3" then true else false, "customColor is not a ColorSequence or Color3")
	end

	if p7 then
		assert(if typeof(p7) == "NumberSequence" then true elseif typeof(p7) == "number" then true else false, "customTransparency is not a NumberSequence or number")
	end

	local t3 = {
		IsPaused = false,
		Diagnostic = "DIAGNOSTIC VALUE",
		UIInstance = p1
	}

	t3.ResumesOnShown = if p8 == nil then true else p8
	t3.EffectObjects = {}
	t3.SavedObjects = {}
	t3.Connections = {}
	t3.Speed = p3 or 0.007
	t3.Size = p4 or 1

	local function v9(p1) --[[ RecursiveAncestryChanged | Line: 69 | Upvalues: t2 (ref), v9 (copy), t3 (copy) ]]
		if not p1 then
			return
		end

		if p1:IsA("PlayerGui") or p1:IsA("Workspace") then
			return
		end

		local v1 = t2[p1.ClassName]

		if v1 then
			local Connections = t3.Connections

			local function f3() --[[ Line: 86 | Upvalues: t3 (ref), p1 (copy), v1 (copy) ]]
				t3.IsPaused = not p1[v1]

				if t3.IsPaused then
					t3:Pause()

					return
				end

				if not t3.ResumesOnShown then
					return
				end

				t3:Resume()
			end

			table.insert(Connections, p1:GetPropertyChangedSignal(v1):Connect(f3))
		end

		v9(p1.Parent)
	end

	v9(p1)

	if p5 then
		for v10, v11 in p1:GetChildren() do
			if v11:IsA("UIStroke") or v11:IsA("UIGradient") then
				table.insert(t3.SavedObjects, v11)
				v11.Parent = nil
			end
		end
	end

	local v12 = require(Presets:FindFirstChild(p2))(p1, t3.Speed, t3.Size, p6, p7)

	if v12.Connections then
		for v13, v14 in v12.Connections do
			table.insert(t3.Connections, v14)
		end
	end

	if v12.Effects then
		for v15, v16 in v12.Effects do
			table.insert(t3.EffectObjects, v16)
		end
	end

	t3.Connection = p1.AncestryChanged:Connect(function() --[[ Line: 124 | Upvalues: p1 (copy), t3 (copy) ]]
		if p1:IsDescendantOf(game) then
			return
		end

		t3:Destroy()
	end)

	return setmetatable(t3, t)
end
function t.Pause(p1) --[[ Pause | Line: 133 ]]
	for v1, v2 in p1.EffectObjects do
		if v2.Pause then
			v2:Pause()
		end
	end
end
function t.Resume(p1) --[[ Resume | Line: 142 ]]
	for v1, v2 in p1.EffectObjects do
		if v2.Resume then
			v2:Resume()
		end
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 151 ]]
	for v1, v2 in p1.SavedObjects do
		v2.Parent = p1.UIInstance
	end

	for v3, v4 in p1.Connections do
		v4:Disconnect()
	end

	table.clear(p1.SavedObjects)
	table.clear(p1.Connections)

	for v5, v6 in p1.EffectObjects do
		if v6.Destroy then
			v6:Destroy()
		end
	end

	p1.Connection:Disconnect()
end

return table.freeze(t)