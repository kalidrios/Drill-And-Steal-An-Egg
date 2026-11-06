-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function() --[[ Line: 1 ]]
	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(153/255, 0/255, 0/255)),
		ColorSequenceKeypoint.new(0.125, Color3.new(255/255, 0/255, 0/255)),
		ColorSequenceKeypoint.new(0.2552083432674408, Color3.new(0.411764, 0, 0)),
		ColorSequenceKeypoint.new(0.3767361044883728, Color3.new(0.3, 0, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.new(0.690196, 0, 0)),
		ColorSequenceKeypoint.new(0.6197916865348816, Color3.new(0.3, 0, 0)),
		ColorSequenceKeypoint.new(0.7378472089767456, Color3.new(255/255, 0/255, 0/255)),
		ColorSequenceKeypoint.new(0.8680555820465088, Color3.new(0.3, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.new(153/255, 0/255, 0/255))
	})

	return UIGradient
end