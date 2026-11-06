-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local TweenService = game:GetService("TweenService")
local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t2 = {}

t2.__index = t2
function t2.LookTowards(p1, p2) --[[ LookTowards | Line: 11 | Upvalues: TweenService (copy), v1 (copy) ]]
	local _neck = p1._neck
	local v12 = _neck.Parent
	local v2 = v12.Parent:FindFirstChild("UpperTorso") or v12.Parent:FindFirstChild("Torso")

	if not v2 then
		return
	end

	local v4 = v2.CFrame:ToObjectSpace((CFrame.new(v12.Position, v12.Position + (p2 - v12.Position).Unit)))
	local v5 = CFrame.new(_neck.C0.Position) * CFrame.Angles(v4:ToEulerAnglesXYZ())

	if p1._tween then
		p1._tween:Cancel()
		p1._tween:Destroy()
	end

	p1._tween = TweenService:Create(_neck, v1, {
		C0 = v5
	})
	p1._tween:Play()
end
function t.new(p1) --[[ new | Line: 36 | Upvalues: t2 (copy) ]]
	local v2 = setmetatable({}, t2)

	v2._neck = p1:WaitForChild("Head").Neck

	return v2
end

return t