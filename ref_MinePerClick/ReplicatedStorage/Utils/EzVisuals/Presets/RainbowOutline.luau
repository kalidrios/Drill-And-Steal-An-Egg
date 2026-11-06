-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local v1 = require(script.Parent.Parent)

return function(p1, p2, p3) --[[ Line: 5 | Upvalues: v1 (copy), RunService (copy) ]]
	local v12 = v1.Stroke.new(p1, p3)
	local v2 = v1.Gradient.new(v12.Instance, v1.Templates.Rainbow.Color, 0)
	local v3 = 5
	local v4 = nil

	v4 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 11 | Upvalues: v12 (copy), v4 (ref), v3 (ref), p2 (copy), v2 (copy) ]]
		if not v12.Instance or v12.Instance.Parent == nil then
			v4:Disconnect()
		end

		v3 = v3 + p2 * p1
		v2:SetRotation(v3, 1)
	end)

	return {
		Effects = { v2, v12 },
		Connections = { v4 }
	}
end