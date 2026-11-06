-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ColorSequenceUtils = require(script.Parent.Parent.ColorSequenceUtils)
local v1 = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.new(255/255, 255/255, 255/255)),
	ColorSequenceKeypoint.new(0.016, Color3.new(255/255, 255/255, 255/255)),
	ColorSequenceKeypoint.new(0.146, Color3.new(255/255, 255/255, 255/255)),
	ColorSequenceKeypoint.new(0.248, Color3.new(255/255, 255/255, 255/255)),
	ColorSequenceKeypoint.new(0.356, Color3.new(255/255, 255/255, 255/255)),
	ColorSequenceKeypoint.new(0.497, Color3.new(255/255, 255/255, 255/255)),
	ColorSequenceKeypoint.new(0.503, Color3.new(0/255, 0/255, 0/255)),
	ColorSequenceKeypoint.new(0.648, Color3.new(0/255, 0/255, 0/255)),
	ColorSequenceKeypoint.new(0.783, Color3.new(0/255, 0/255, 0/255)),
	ColorSequenceKeypoint.new(0.891, Color3.new(0/255, 0/255, 0/255)),
	ColorSequenceKeypoint.new(0.977, Color3.new(0/255, 0/255, 0/255)),
	ColorSequenceKeypoint.new(1, Color3.new(0/255, 0/255, 0/255))
})
local v2 = 0

return {
	simulate = function(p1) --[[ simulate | Line: 22 | Upvalues: v2 (ref), ColorSequenceUtils (copy), v1 (copy) ]]
		v2 = v2 + p1 * 0.5

		return {
			main = ColorSequenceUtils.calculateColorSequence(v1, v2),
			stroke = ColorSequenceUtils.calculateColorSequence(v1, v2 + 0.5)
		}
	end,
	apply = function(p1) --[[ apply | Line: 30 ]]
		local t = {}

		local function useOrCreate(p1, p2) --[[ useOrCreate | Line: 33 | Upvalues: t (copy) ]]
			local v1 = p1:FindFirstChildWhichIsA(p2)

			if not v1 then
				v1 = Instance.new(p2)
				v1.Parent = p1

				local function f3() --[[ Line: 38 | Upvalues: v1 (ref) ]]
					v1:Destroy()
				end

				table.insert(t, 1, f3)
			end

			return v1
		end

		if p1:IsA("TextLabel") then
			local TextColor3 = p1.TextColor3

			p1.TextColor3 = Color3.new(255/255, 255/255, 255/255)
			table.insert(t, 1, function() --[[ Line: 47 | Upvalues: p1 (copy), TextColor3 (copy) ]]
				p1.TextColor3 = TextColor3
			end)
		end

		local v1 = p1:FindFirstChildWhichIsA("UIGradient")

		if not v1 then
			v1 = Instance.new("UIGradient")
			v1.Parent = p1

			local function f2() --[[ Line: 38 | Upvalues: v1 (ref) ]]
				v1:Destroy()
			end

			table.insert(t, 1, f2)
		end

		local v3 = v1
		local v4 = p1:FindFirstChildWhichIsA("UIStroke")

		if not v4 then
			v4 = Instance.new("UIStroke")
			v4.Parent = p1

			local function f5() --[[ Line: 38 | Upvalues: v4 (ref) ]]
				v4:Destroy()
			end

			table.insert(t, 1, f5)
		end

		local v6 = v4
		local v7 = v6:FindFirstChildWhichIsA("UIGradient")

		if not v7 then
			v7 = Instance.new("UIGradient")
			v7.Parent = v6

			local function f8() --[[ Line: 38 | Upvalues: v7 (ref) ]]
				v7:Destroy()
			end

			table.insert(t, 1, f8)
		end

		local v9 = v7
		local Color = v6.Color

		v6.Color = Color3.new(255/255, 255/255, 255/255)
		table.insert(t, 1, function() --[[ Line: 60 | Upvalues: v6 (copy), Color (copy) ]]
			v6.Color = Color
		end)

		local Thickness = v6.Thickness

		v6.Thickness = 1
		table.insert(t, 1, function() --[[ Line: 64 | Upvalues: v6 (copy), Thickness (copy) ]]
			v6.Thickness = Thickness
		end)

		local Transparency = v6.Transparency

		v6.Transparency = 0
		table.insert(t, 1, function() --[[ Line: 68 | Upvalues: v6 (copy), Transparency (copy) ]]
			v6.Transparency = Transparency
		end)

		local v10 = v6:GetPropertyChangedSignal("Thickness"):Connect(function() --[[ Line: 70 | Upvalues: v6 (copy) ]]
			if v6.Thickness == 1 then
				return
			end

			v6.Thickness = 1
		end)
		local Rotation = v3.Rotation

		v3.Rotation = 90
		table.insert(t, 1, function() --[[ Line: 79 | Upvalues: v3 (copy), Rotation (copy) ]]
			v3.Rotation = Rotation
		end)

		local Transparency2 = v3.Transparency

		v3.Transparency = NumberSequence.new(0)
		table.insert(t, 1, function() --[[ Line: 83 | Upvalues: v3 (copy), Transparency2 (copy) ]]
			v3.Transparency = Transparency2
		end)

		local Rotation2 = v9.Rotation

		v9.Rotation = 90
		table.insert(t, 1, function() --[[ Line: 87 | Upvalues: v9 (copy), Rotation2 (copy) ]]
			v9.Rotation = Rotation2
		end)

		local Transparency3 = v9.Transparency

		v9.Transparency = NumberSequence.new(0)
		table.insert(t, 1, function() --[[ Line: 91 | Upvalues: v9 (copy), Transparency3 (copy) ]]
			v9.Transparency = Transparency3
		end)

		return {
			main = v3,
			stroke = v9,
			cleanup = function() --[[ cleanup | Line: 96 | Upvalues: v10 (copy), t (copy) ]]
				v10:Disconnect()

				for i, v in ipairs(t) do
					v()
				end
			end
		}
	end
}