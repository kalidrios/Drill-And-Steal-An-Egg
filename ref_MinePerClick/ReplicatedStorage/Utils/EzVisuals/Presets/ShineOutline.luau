-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local v1 = require(script.Parent.Parent)

local function makeLighter(p1, p2) --[[ makeLighter | Line: 5 ]]
	return p1:Lerp(Color3.fromRGB(255, 255, 255), p2)
end

local function findColorFromObject(p1) --[[ findColorFromObject | Line: 9 ]]
	local v1 = p1[({
		TextButton = "BackgroundColor3",
		TextLabel = "TextColor3",
		ImageLabel = "ImageColor3",
		ImageButton = "ImageColor3",
		Frame = "BackgroundColor3",
		ScrollingFrame = "BackgroundColor3",
		ViewportFrame = "BackgroundColor3"
	})[p1.ClassName]]

	if v1 then
		return v1
	end

	return Color3.fromRGB(255, 255, 255)
end

return function(p1, p2, p3, p4) --[[ Line: 29 | Upvalues: findColorFromObject (copy), v1 (copy), RunService (copy) ]]
	local v12 = if p4 then p4 else findColorFromObject(p1)
	local v2 = v12:Lerp(Color3.fromRGB(255, 255, 255), 0.6)
	local v3 = ColorSequence.new({ ColorSequenceKeypoint.new(0, v12), ColorSequenceKeypoint.new(0.5, v2), ColorSequenceKeypoint.new(1, v12) })
	local v4 = v1.Stroke.new(p1, p3)
	local v5 = v1.Gradient.new(v4.Instance, v3, 0)
	local v6 = 0.75
	local v7 = nil

	v7 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 48 | Upvalues: v4 (copy), v7 (ref), v6 (ref), p2 (copy), v5 (copy) ]]
		if not v4.Instance or v4.Instance.Parent == nil then
			v7:Disconnect()
		end

		v6 = v6 + p2 * p1
		v5:SetRotation(v6, 1)
	end)

	return {
		Effects = { v5, v4 },
		Connections = { v7 }
	}
end