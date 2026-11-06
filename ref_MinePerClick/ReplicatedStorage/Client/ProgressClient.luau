-- ProgressClient: Управление полосой прогресса уровня игрока и эффектами повышения уровня

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = game.Players.LocalPlayer
local Client = ReplicatedStorage:WaitForChild("Client")
local DataClient = require(Client:WaitForChild("DataClient"))
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local LevelsHelper = require(Helpers:WaitForChild("LevelsHelper"))
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))
local Replica = DataClient:GetReplica()
local Data = Replica.Data
local Main = LocalPlayer.PlayerGui:WaitForChild("Main")

Main:WaitForChild("TopFrame")

local ProgressFrame = Main:WaitForChild("TopFrame"):WaitForChild("ProgressFrame")
local Amount = ProgressFrame:WaitForChild("Strength"):WaitForChild("Amount")
local ProgressBar = ProgressFrame:WaitForChild("ProgressBar")
local Bar = ProgressBar:WaitForChild("Bar")
local Level = ProgressBar:WaitForChild("Level")
local Needed = ProgressBar:WaitForChild("Needed")

local ProgressClient = {
	--- Обновляет отображаемое количество силы игрока
	UpdateStrengthAmount = function(self, strength)
		Amount.Text = ("%* Strength"):format((Formatting:FormatNumber(strength)))
	end
}

--- Обновляет полосу прогресса и текстовые поля уровня
function ProgressClient.UpdateProgressBar(self, strength)
	local currentLevel, currentExp, nextLevelExp = LevelsHelper:GetLevel(strength)

	ProgressClient:UpdateStrengthAmount(Data.Strength)
	Level.Text = ("Level %*"):format(currentLevel)
	Needed.Text = ("%*/%*"):format(Formatting:FormatNumber(currentExp), (Formatting:FormatNumber(nextLevelExp)))

	local progressRatio = math.clamp(currentExp / nextLevelExp, 0, 1)

	TweenService:Create(Bar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(progressRatio, 0, 1, 0)
	}):Play()
end

--- Проигрывает анимацию и звук при получении нового уровня
function ProgressClient.PlayLevelUpAnimation(self)
	task.spawn(function()
		local UIScale = ProgressFrame:FindFirstChild("UIScale")

		if UIScale then
			TweenService:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Scale = 1.25
			}):Play()
			task.wait(0.15)
			TweenService:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Scale = 1
			}):Play()
		end
	end)

	local levelUpSound = SoundService:FindFirstChild("Levelup"):Clone()
	levelUpSound.Parent = LocalPlayer.Character.PrimaryPart
	levelUpSound:Play()

	local levelUpVFX = script:WaitForChild("Levelup"):Clone()
	levelUpVFX.Parent = LocalPlayer.Character.PrimaryPart
	levelUpVFX.Enabled = true

	task.delay(0.2, function()
		levelUpVFX.Enabled = false
	end)
	task.delay(2, function()
		levelUpVFX:Destroy()
	end)
	levelUpSound.Ended:Once(function()
		levelUpSound:Destroy()
	end)
end

--- Подписка на изменение силы игрока
function ProgressClient.Listen(self)
	Replica:ListenToChange({ "Strength" }, function(newStrength, oldStrength)
		if LevelsHelper:GetLevel(oldStrength) < LevelsHelper:GetLevel(newStrength) then
			ProgressClient:PlayLevelUpAnimation()
		end

		ProgressClient:UpdateProgressBar(newStrength)
	end)
end

function ProgressClient.Start(self)
	ProgressClient:Listen()
	ProgressClient:UpdateProgressBar(Data.Strength)
end

return ProgressClient