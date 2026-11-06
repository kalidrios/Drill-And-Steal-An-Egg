-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local v1 = require(script.Parent.Parent)

return function(p1, p2, p3) --[[ Line: 5 | Upvalues: v1 (copy), RunService (copy) ]]
	local v12 = v1.Gradient.new(p1, v1.Templates.Bubblegum.Color, 0)

	v12:SetRotation(-90, 1)
	v12:SetOffsetSpeed(p2, 1)

	local v2 = v1.Stroke.new(p1, p3)
	local v3 = v1.Gradient.new(v2.Instance, v1.Templates.Bubblegum.Color, 0)

	v3:SetRotation(-45, 1)
	v3:SetOffsetSpeed(p2 * 0.9, 1)

	local v4 = p3 * 3
	local v5 = nil

	v5 = RunService.Heartbeat:Connect(function() --[[ Line: 17 | Upvalues: v2 (copy), v5 (ref), p2 (copy), v4 (copy), p3 (copy) ]]
		if v2.Instance and v2.Instance.Parent ~= nil then
			v2:SetSize(p3 * (v4 * math.sin(tick() * p2) + 1), 0.055)
		else
			v5:Disconnect()
		end
	end)

	return {
		Effects = { v12, v3, v2 },
		Connections = { v5 }
	}
end