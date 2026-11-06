-- TweeningClient: Анимации кнопок (hover/click эффекты) через CollectionService

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = game.Players.LocalPlayer
local TweeningClient = {}

--- Анимация нажатия (scale down и обратно)
local function ClickScale(uiScale)
	local tweenDown = TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
		Scale = 0.65
	})
	local tweenUp = TweenService:Create(uiScale, TweenInfo.new(0.125, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = 1
	})

	tweenDown:Play()
	tweenDown.Completed:Connect(function()
		tweenUp:Play()
	end)
end

--- Настраивает hover/click анимации для ImageButton
function TweeningClient.TweenButton(self, button)
	if not (button and button:IsA("ImageButton")) then
		return
	end

	local uiScale = button:FindFirstChildWhichIsA("UIScale") or Instance.new("UIScale", button)
	uiScale.Scale = 1

	local hoverIn = TweenService:Create(uiScale, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Scale = 1.1
	})
	local hoverOut = TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = 1
	})

	button.MouseEnter:Connect(function()
		hoverIn:Play()
	end)
	button.MouseLeave:Connect(function()
		hoverOut:Play()
	end)
	button.Activated:Connect(function()
		ClickScale(uiScale)
		if not CollectionService:HasTag(button, "Purchase") then
			SoundService:WaitForChild("Hover"):Play()
		end
	end)
end

--- Настраивает hover анимацию для ImageLabel
function TweeningClient.TweenImageLabel(self, imageLabel)
	if not (imageLabel and imageLabel:IsA("ImageLabel")) then
		return
	end

	local uiScale = imageLabel:FindFirstChild("UIScale") or Instance.new("UIScale", imageLabel)
	uiScale.Scale = 1

	local hoverIn = TweenService:Create(uiScale, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Scale = 1.05
	})
	local hoverOut = TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = 1
	})

	imageLabel.MouseEnter:Connect(function()
		SoundService:WaitForChild("Hover"):Play()
		hoverIn:Play()
	end)
	imageLabel.MouseLeave:Connect(function()
		hoverOut:Play()
	end)
end

function TweeningClient.Start(self)
	-- Применить ко всем существующим элементам с тегом "Tweenable"
	for _, element in pairs(CollectionService:GetTagged("Tweenable")) do
		TweeningClient:TweenButton(element)
	end

	CollectionService:GetInstanceAddedSignal("Tweenable"):Connect(function(element)
		TweeningClient:TweenButton(element)
	end)
end

return TweeningClient