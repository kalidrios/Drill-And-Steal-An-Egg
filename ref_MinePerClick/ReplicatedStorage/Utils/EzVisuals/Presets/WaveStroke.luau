-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require(script.Parent.Parent)

return function(p1, p2, p3, p4) --[[ Line: 3 | Upvalues: v1 (copy) ]]
	local v12 = ColorSequence.new({ ColorSequenceKeypoint.new(0, p4), ColorSequenceKeypoint.new(0.5, p4), ColorSequenceKeypoint.new(1, p4) })
	local v2 = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.25, 1),
		NumberSequenceKeypoint.new(0.5, 1),
		NumberSequenceKeypoint.new(0.75, 1),
		NumberSequenceKeypoint.new(1, 0)
	})
	local v3 = v1.Stroke.new(p1, p3)
	local v4 = v1.Gradient.new(v3.Instance, v12, v2)

	v4:SetOffsetSpeed(p2, 1)
	v4:SetTransparencyOffsetSpeed(p2 * 0.9, 1)

	return {
		Effects = { v4, v3 }
	}
end