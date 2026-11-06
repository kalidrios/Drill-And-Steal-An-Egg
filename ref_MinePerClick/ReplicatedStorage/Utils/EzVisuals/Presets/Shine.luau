-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require(script.Parent.Parent)

local function makeLighter(p1, p2) --[[ makeLighter | Line: 4 ]]
	return p1:Lerp(Color3.fromRGB(255, 255, 255), p2)
end

local function findColorFromObject(p1) --[[ findColorFromObject | Line: 8 ]]
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

return function(p1, p2, p3, p4) --[[ Line: 28 | Upvalues: findColorFromObject (copy), v1 (copy) ]]
	local v12 = if p4 then p4 else findColorFromObject(p1)
	local v2 = v12:Lerp(Color3.fromRGB(255, 255, 255), 0.417505)
	local v4 = v1.Gradient.new(p1, ColorSequence.new({ ColorSequenceKeypoint.new(0, v12), ColorSequenceKeypoint.new(0.5, v2), ColorSequenceKeypoint.new(1, v12) }), 0)

	v4:SetOffsetSpeed(p2 * 0.6, 1)
	v4:SetRotation(60, 1)

	return {
		Effects = { v4 }
	}
end