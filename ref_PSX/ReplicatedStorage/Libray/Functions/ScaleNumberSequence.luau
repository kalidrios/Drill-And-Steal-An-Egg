-- its june and i making a game instead study for my entrance exame
return function(p1, p2)
	local v2 = {}
	for v16, v11 in ipairs(p1.Keypoints) do
		table.insert(v2, NumberSequenceKeypoint.new(v11.Time, (v11.Value) * p2, (v11.Envelope) * p2))
	end
	return NumberSequence.new(v2)
end
