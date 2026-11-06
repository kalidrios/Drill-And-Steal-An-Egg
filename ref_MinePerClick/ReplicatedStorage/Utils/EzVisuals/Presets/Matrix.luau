-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require(script.Parent.Parent)

return function(p1, p2, p3) --[[ Line: 3 | Upvalues: v1 (copy) ]]
	local v12 = v1.Gradient.new(p1, v1.Templates.Matrix.Color, 0)

	v12:SetOffsetSpeed(p2, 1)
	v12:SetRotation(90, 1)

	local v2 = v1.Stroke.new(p1, p3)
	local v3 = v1.Gradient.new(v2.Instance, v1.Templates.Matrix.Color, 0)

	v3:SetOffset(0.5, 1)
	v3:SetRotation(90, 1)
	task.delay(0.1, function() --[[ Line: 14 | Upvalues: v3 (copy), p2 (copy) ]]
		v3:SetOffsetSpeed(p2, 1)
	end)

	return {
		Effects = { v12, v3, v2 }
	}
end