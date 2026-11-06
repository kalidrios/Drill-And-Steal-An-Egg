local TweenService = game:GetService("TweenService")

local button = script.Parent
local speed = 0.2 
local popInfo = TweenInfo.new(speed, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local smoothInfo = TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- 1. Grab the EXACT size from the properties tab
local normalSize = button.Size

-- 2. Calculate offsets for Hover and Click based on that size
local hoverSize = UDim2.new(normalSize.X.Scale * 1.1, normalSize.X.Offset, normalSize.Y.Scale * 1.1, normalSize.Y.Offset)
local clickSize = UDim2.new(normalSize.X.Scale * 0.9, normalSize.X.Offset, normalSize.Y.Scale * 0.9, normalSize.Y.Offset)

local isMouseInside = false

-- Setup
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Size = normalSize -- This ensures it stays the same as the others

local function tweenTo(targetSize, info)
	TweenService:Create(button, info, {Size = targetSize}):Play()
end

button.MouseEnter:Connect(function()
	isMouseInside = true
	tweenTo(hoverSize, popInfo)
end)

button.MouseLeave:Connect(function()
	isMouseInside = false
	tweenTo(normalSize, smoothInfo)
end)

button.MouseButton1Down:Connect(function()
	tweenTo(clickSize, smoothInfo)
end)

button.MouseButton1Up:Connect(function()
	if isMouseInside then
		tweenTo(hoverSize, popInfo)
	else
		tweenTo(normalSize, smoothInfo)
	end
end)