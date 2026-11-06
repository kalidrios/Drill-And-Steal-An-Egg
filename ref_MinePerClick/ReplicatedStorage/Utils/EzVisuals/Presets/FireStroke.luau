-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local v1 = require(script.Parent.Parent)

return function(p1, p2, p3) --[[ Line: 5 | Upvalues: v1 (copy), RunService (copy) ]]
	local v12 = v1.Gradient.new(p1, v1.Templates.Fire.Color, 0)

	v12:SetRotation(-75, 1)
	v12:SetOffsetSpeed(p2, 1)

	local v2 = 0
	local v3 = nil

	v3 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 12 | Upvalues: v12 (copy), v3 (ref), v2 (ref), p2 (copy) ]]
		if not v12.Instance or v12.Instance.Parent == nil then
			v3:Disconnect()
		end

		v2 = v2 + p2 * p1
		v12:SetRotation(v2, 1)
	end)

	local v4 = v1.Stroke.new(p1, p3)
	local v5 = v1.Gradient.new(v4.Instance, v1.Templates.Fire.Color, 0)

	v5:SetRotation(75, 1)
	v5:SetOffsetSpeed(-p2, 1)

	return {
		Effects = { v12, v5, v4 },
		Connections = { v3 }
	}
end