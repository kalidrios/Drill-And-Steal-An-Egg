-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require(script.Parent.Parent)

return function(p1, p2, p3) --[[ Line: 3 | Upvalues: v1 (copy) ]]
	local v12 = v1.Gradient.new(p1, v1.Templates.Ice.Color, 0)

	v12:SetRotation(-65, 1)
	v12:SetOffsetSpeed(p2, 1)

	local v2 = v1.Stroke.new(p1, p3)
	local v3 = v1.Gradient.new(v2.Instance, v1.Templates.Ice.Color, 0)

	v3:SetRotation(-61, 1)
	v3:SetOffsetSpeed(p2 * 0.23, 1)

	return {
		Effects = { v12, v3, v2 }
	}
end