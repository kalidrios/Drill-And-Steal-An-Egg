-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ColorSequenceUtils = require(script.Parent.Parent.ColorSequenceUtils)
local v1 = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.new(255/255, 0/255, 0/255)),
	ColorSequenceKeypoint.new(0.151, Color3.new(0.616, 0, 1)),
	ColorSequenceKeypoint.new(0.307, Color3.new(0.067, 0, 1)),
	ColorSequenceKeypoint.new(0.497, Color3.new(0/255, 255/255, 255/255)),
	ColorSequenceKeypoint.new(0.665, Color3.new(0.016, 1, 0)),
	ColorSequenceKeypoint.new(0.839, Color3.new(255/255, 255/255, 0/255)),
	ColorSequenceKeypoint.new(1, Color3.new(255/255, 0/255, 0/255))
})
local v2 = 0

return {
	simulate = function(p1) --[[ simulate | Line: 17 | Upvalues: v2 (ref), ColorSequenceUtils (copy), v1 (copy) ]]
		v2 = v2 + p1 * 0.5

		return {
			main = ColorSequenceUtils.calculateColorSequence(v1, v2)
		}
	end,
	apply = function(p1) --[[ apply | Line: 25 ]]
		local t = {}
		local v1 = p1:FindFirstChildWhichIsA("UIGradient")
		local v2 = v1 and v1.Color

		if not v1 then
			v1 = Instance.new("UIGradient")
			v1.Parent = p1
			table.insert(t, v1)
		end

		local v3 = v1

		assert(v3)

		return {
			main = v1,
			cleanup = function() --[[ cleanup | Line: 40 | Upvalues: v2 (copy), v1 (ref), t (copy) ]]
				if v2 then
					v1.Color = v2
				end

				for i, v in ipairs(t) do
					v:Destroy()
				end
			end
		}
	end
}