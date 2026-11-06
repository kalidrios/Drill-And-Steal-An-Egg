-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local function evalColorSequence(p1, p2) --[[ evalColorSequence | Line: 1 ]]
	local t = {}
	local v1 = p2 + 1

	for i = 0, 2 do
		for j = 1, #p1 do
			table.insert(t, {
				Time = p1[j].Time + i,
				Value = p1[j].Value
			})
		end
	end

	for k = 1, #t - 1 do
		local v2 = t[k]
		local v3 = t[k + 1]

		if v2.Time <= v1 and v1 < v3.Time then
			local v4 = (v1 - v2.Time) / (v3.Time - v2.Time)

			return Color3.new((v3.Value.R - v2.Value.R) * v4 + v2.Value.R, (v3.Value.G - v2.Value.G) * v4 + v2.Value.G, (v3.Value.B - v2.Value.B) * v4 + v2.Value.B)
		end
	end
end

return {
	calculateColorSequence = function(p1, p2) --[[ calculateColorSequence | Line: 27 | Upvalues: evalColorSequence (copy) ]]
		local v1 = 100
		local count = 5
		local t = {}

		for v2, v3 in p1.Keypoints do
			local v4 = v3.Time + p2

			if v4 > 1 or v4 < 0 then
				v4 = v4 % 1
			end

			local v5 = ColorSequenceKeypoint.new(v4, v3.Value)

			if v5.Time <= v1 then
				t[count - 1] = v5
				v1 = v5.Time
				count = count - 1

				continue
			end

			table.insert(t, v5)
		end

		local t2 = {}

		for v6, v7 in t do
			table.insert(t2, v7)
		end

		table.sort(t2, function(p1, p2) --[[ Line: 50 ]]
			return p1.Time < p2.Time
		end)

		if t2[1].Time ~= 0 then
			table.insert(t2, 1, ColorSequenceKeypoint.new(0, evalColorSequence(t2, 0)))
		end

		if t2[#t2].Time ~= 1 then
			table.insert(t2, ColorSequenceKeypoint.new(1, evalColorSequence(t2, 1)))
		end

		return ColorSequence.new(t2)
	end
}