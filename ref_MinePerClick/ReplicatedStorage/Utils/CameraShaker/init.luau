-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}

t.__index = t

local profilebegin = debug.profilebegin
local profileend = debug.profileend
local v1 = Vector3.new
local v2 = CFrame.new
local Angles = CFrame.Angles
local rad = math.rad
local v3 = v1()
local CameraShakeInstance = require(script.CameraShakeInstance)
local CameraShakeState = CameraShakeInstance.CameraShakeState

t.CameraShakeInstance = CameraShakeInstance
t.Presets = require(script:WaitForChild("CameraShakePresets"))
function t.new(p1, p2) --[[ new | Line: 86 | Upvalues: v3 (copy), t (copy) ]]
	assert(if type(p1) == "number" then true else false, "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)")
	assert(if type(p2) == "function" then true else false, "Callback must be a function")

	return setmetatable({
		_running = false,
		_renderName = "CameraShaker",
		_renderPriority = p1,
		_posAddShake = v3,
		_rotAddShake = v3,
		_camShakeInstances = {},
		_removeInstances = {},
		_callback = p2
	}, t)
end
function t.Start(p1) --[[ Start | Line: 107 | Upvalues: profilebegin (copy), profileend (copy) ]]
	if not p1._running then
		p1._running = true

		local _callback = p1._callback

		game:GetService("RunService"):BindToRenderStep(p1._renderName, p1._renderPriority, function(p12) --[[ Line: 111 | Upvalues: profilebegin (ref), p1 (copy), profileend (ref), _callback (copy) ]]
			profilebegin("CameraShakerUpdate")

			local v1 = p1:Update(p12)

			profileend()
			_callback(v1)
		end)
	end
end
function t.Stop(p1) --[[ Stop | Line: 120 ]]
	if p1._running then
		game:GetService("RunService"):UnbindFromRenderStep(p1._renderName)
		p1._running = false
	end
end
function t.StopSustained(p1, p2) --[[ StopSustained | Line: 127 ]]
	for k, v in pairs(p1._camShakeInstances) do
		if v.fadeOutDuration == 0 then
			v:StartFadeOut(if p2 then p2 else v.fadeInDuration)
		end
	end
end
function t.Update(p1, p2) --[[ Update | Line: 136 | Upvalues: v3 (copy), CameraShakeState (copy), v2 (copy), Angles (copy), rad (copy) ]]
	local sum = v3
	local sum2 = v3
	local _camShakeInstances = p1._camShakeInstances

	for i = 1, #_camShakeInstances do
		local v1 = _camShakeInstances[i]
		local v22 = v1:GetState()

		if v22 == CameraShakeState.Inactive and v1.DeleteOnInactive then
			p1._removeInstances[#p1._removeInstances + 1] = i

			continue
		end

		if v22 ~= CameraShakeState.Inactive then
			local v32 = v1:UpdateShake(p2)

			sum = sum + v32 * v1.PositionInfluence
			sum2 = sum2 + v32 * v1.RotationInfluence
		end
	end

	for j = #p1._removeInstances, 1, -1 do
		table.remove(_camShakeInstances, p1._removeInstances[j])
		p1._removeInstances[j] = nil
	end

	return v2(sum) * Angles(0, rad(sum2.Y), 0) * Angles(rad(sum2.X), 0, (rad(sum2.Z)))
end
function t.Shake(p1, p2) --[[ Shake | Line: 173 ]]
	assert(if type(p2) == "table" then p2._camShakeInstance else false, "ShakeInstance must be of type CameraShakeInstance")
	p1._camShakeInstances[#p1._camShakeInstances + 1] = p2

	return p2
end
function t.ShakeSustain(p1, p2) --[[ ShakeSustain | Line: 180 ]]
	assert(if type(p2) == "table" then p2._camShakeInstance else false, "ShakeInstance must be of type CameraShakeInstance")
	p1._camShakeInstances[#p1._camShakeInstances + 1] = p2
	p2:StartFadeIn(p2.fadeInDuration)

	return p2
end
function t.ShakeOnce(p1, p2, p3, p4, p5, p6, p7) --[[ ShakeOnce | Line: 188 | Upvalues: CameraShakeInstance (copy) ]]
	local v1 = CameraShakeInstance.new(p2, p3, p4, p5)

	v1.PositionInfluence = if typeof(p6) == "Vector3" and p6 then p6 else Vector3.new(0.15, 0.15, 0.15)
	v1.RotationInfluence = if typeof(p7) == "Vector3" and p7 then p7 else Vector3.new(1, 1, 1)
	p1._camShakeInstances[#p1._camShakeInstances + 1] = v1

	return v1
end
function t.StartShake(p1, p2, p3, p4, p5, p6) --[[ StartShake | Line: 197 | Upvalues: CameraShakeInstance (copy) ]]
	local v1 = CameraShakeInstance.new(p2, p3, p4)

	v1.PositionInfluence = if typeof(p5) == "Vector3" and p5 then p5 else Vector3.new(0.15, 0.15, 0.15)
	v1.RotationInfluence = if typeof(p6) == "Vector3" and p6 then p6 else Vector3.new(1, 1, 1)
	v1:StartFadeIn(p4)
	p1._camShakeInstances[#p1._camShakeInstances + 1] = v1

	return v1
end

return t