local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local closeButton = script.Parent
local frame = closeButton.Parent.Parent 
local speed = 0.2 
local tweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local blurTweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local shrunkSize = UDim2.new(0, 0, 0, 0)
local function tweenBlurs(targetSize)
	for _, effect in pairs(Lighting:GetChildren()) do
		if effect.Name == "Blur" and effect:IsA("BlurEffect") then
			TweenService:Create(effect, blurTweenInfo, {Size = targetSize}):Play()
		end
	end
end

local function onCloseClicked()
	tweenBlurs(0)

	local closeTween = TweenService:Create(frame, tweenInfo, {Size = shrunkSize})
	closeTween.Completed:Connect(function()
		if frame.Size == shrunkSize then
			frame.Visible = false
		end
	end)

	closeTween:Play()
end
closeButton.Activated:Connect(onCloseClicked)