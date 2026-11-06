-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function() --[[ Line: 1 ]]
	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(255/255, 255/255, 255/255)),
		ColorSequenceKeypoint.new(0.015625, Color3.new(255/255, 255/255, 255/255)),
		ColorSequenceKeypoint.new(0.1458333283662796, Color3.new(255/255, 255/255, 255/255)),
		ColorSequenceKeypoint.new(0.2482638955116272, Color3.new(255/255, 255/255, 255/255)),
		ColorSequenceKeypoint.new(0.3559027910232544, Color3.new(255/255, 255/255, 255/255)),
		ColorSequenceKeypoint.new(0.4970000088214874, Color3.new(255/255, 255/255, 255/255)),
		ColorSequenceKeypoint.new(0.503000020980835, Color3.new(0/255, 0/255, 0/255)),
		ColorSequenceKeypoint.new(0.647569477558136, Color3.new(0/255, 0/255, 0/255)),
		ColorSequenceKeypoint.new(0.7829861044883728, Color3.new(0/255, 0/255, 0/255)),
		ColorSequenceKeypoint.new(0.890625, Color3.new(0/255, 0/255, 0/255)),
		ColorSequenceKeypoint.new(0.9774305820465088, Color3.new(0/255, 0/255, 0/255)),
		ColorSequenceKeypoint.new(1, Color3.new(0/255, 0/255, 0/255))
	})

	return UIGradient
end