-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require(script.Parent.Parent)

return function(p1, p2) --[[ Line: 3 | Upvalues: v1 (copy) ]]
	local v12 = v1.Gradient.new(p1, v1.Templates.Gold.Color, 0)

	v12:SetRotation(-75, 1)
	v12:SetOffsetSpeed(p2, 1)

	return {
		Effects = { v12 }
	}
end