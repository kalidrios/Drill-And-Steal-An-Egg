-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local TweenService = game:GetService("TweenService")

game:GetService("ReplicatedStorage")

local v1 = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t2 = {}

function t.TweenScale(p1, p2, p3, p4) --[[ TweenScale | Line: 12 | Upvalues: v1 (copy), t2 (copy), TweenService (copy) ]]
	local v12 = p4 or v1

	if t2[p1] then
		t2[p1]:Cancel()
		t2[p1]:Destroy()
		t2[p1] = nil
	end

	if p1 and p1.Parent then
		local v2 = Instance.new("NumberValue")

		v2.Value = p2

		local v3 = nil

		v3 = v2:GetPropertyChangedSignal("Value"):Connect(function() --[[ Line: 29 | Upvalues: p1 (copy), v3 (ref), v2 (copy) ]]
			if p1 and p1.Parent then
				p1:ScaleTo(v2.Value)

				return
			end

			if v3 then
				v3:Disconnect()
			end

			v2:Destroy()
		end)

		local v4 = TweenService:Create(v2, v12, {
			Value = p3
		})

		t2[p1] = v4
		v4.Completed:Once(function() --[[ Line: 48 | Upvalues: t2 (ref), p1 (copy), v4 (copy), v3 (ref), v2 (copy) ]]
			if t2[p1] == v4 then
				t2[p1] = nil
			end

			if v3 then
				v3:Disconnect()
			end

			v2:Destroy()
		end)
		v4:Play()
	end
end

return t