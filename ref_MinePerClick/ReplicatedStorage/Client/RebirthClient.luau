-- RebirthClient: UI реберсов, прогресс-бар, VFX
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = game.Players.LocalPlayer
local Client = ReplicatedStorage:WaitForChild("Client")
local DataClient = require(Client:WaitForChild("DataClient"))
local InterfaceClient = require(Client:WaitForChild("InterfaceClient"))
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local LevelsHelper = require(Helpers:WaitForChild("LevelsHelper"))
local Rebirth = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Rebirth")
local Replica = DataClient:GetReplica()
local Data = Replica.Data
local Main = LocalPlayer.PlayerGui:WaitForChild("Main")
local Second = LocalPlayer.PlayerGui:WaitForChild("Second")
local RebirthFrame = Main:WaitForChild("RebirthFrame")
local Options = RebirthFrame:WaitForChild("Options")
local RebirthButton = Options:WaitForChild("RebirthButton")
local SkipButton = Options:WaitForChild("SkipButton")
local Changes = RebirthFrame:WaitForChild("Changes")
local SpeedProgressBar = RebirthFrame:WaitForChild("SpeedProgressBar")

Second:WaitForChild("Rebirth")

local Title = RebirthFrame:WaitForChild("Title")
local Assets = ReplicatedStorage:WaitForChild("Assets")
local RebirthClient = {
	UpdateProgressBar = function(self, currentStrength)
		local ProgressBar = SpeedProgressBar:WaitForChild("ProgressBar")
		local Level = SpeedProgressBar:WaitForChild("Level")
		local currentLevel, _, _2 = LevelsHelper:GetLevel(currentStrength)

		if not currentLevel then
			return
		end

		local strengthMultiplier = LevelsHelper:GetStrengthMultiplier(Data.Rebirths)
		local requiredLevel = LevelsHelper:GetRequiredRebirthLevel(Data.Rebirths)

		if not (strengthMultiplier and requiredLevel) then
			return
		end

		local progress = math.clamp(currentLevel / requiredLevel, 0, 1)

		if requiredLevel <= currentLevel then
			progress = 1
			currentLevel = requiredLevel
		end

		TweenService:Create(ProgressBar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(progress, 1)
		}):Play()
		Level.Text = ("Level: %*/%*"):format(currentLevel, requiredLevel)
	end,
	UpdateFrames = function(self, rebirthCount)
		Title.Text = ("Rebirth %*"):format(rebirthCount)

		local strengthMult = LevelsHelper:GetStrengthMultiplier(Data.Rebirths)
		local cashMult = LevelsHelper:GetCashMultiplier(Data.Rebirths)

		Changes:WaitForChild("BeforeStrength"):WaitForChild("Before").Text = ("%*x Strength"):format(strengthMult)
		Changes:WaitForChild("AfterStrength"):WaitForChild("After").Text = ("%*x Strength"):format(strengthMult + 0.5)
		Changes:WaitForChild("BeforeCash"):WaitForChild("Before").Text = ("%*x Cash"):format((string.format("%.1f", cashMult)))
		Changes:WaitForChild("AfterCash"):WaitForChild("After").Text = ("%*x Cash"):format((string.format("%.1f", cashMult + 0.2)))
	end
}

function RebirthClient.Listen(self)
	Replica:ListenToChange({ "Rebirths" }, function(newRebirths, oldRebirths)
		RebirthClient:UpdateFrames(newRebirths)
		RebirthClient:UpdateProgressBar(Data.Strength)

		if not (oldRebirths < newRebirths) then
			return
		end

		InterfaceClient:Close(RebirthFrame)
		SoundService:FindFirstChild("Rebirth"):Play()

		local Character = LocalPlayer.Character
		if not Character then
			return
		end

		local rebirthVFX = Assets:WaitForChild("VFX"):WaitForChild("RebirthVFX"):Clone()
		rebirthVFX.Parent = Character.PrimaryPart

		for _, descendant in pairs(rebirthVFX:GetDescendants()) do
			if descendant:IsA("ParticleEmitter") then
				task.spawn(function()
					local emitCount = descendant:GetAttribute("EmitCount")
					local emitDelay = descendant:GetAttribute("EmitDelay")
					local emitDuration = descendant:GetAttribute("EmitDuration")

					descendant.Enabled = false

					if emitDelay and emitDelay > 0 then
						task.wait(emitDelay)
					end

					descendant:Emit(if emitCount and emitCount > 0 then emitCount else 10)

					if emitDuration and emitDuration > 0 then
						task.wait(emitDuration)
					end

					descendant.Enabled = false
				end)
			end
		end

		task.delay(5, function()
			rebirthVFX:Destroy()
		end)
	end)
	Replica:ListenToChange({ "Strength" }, function(newStrength)
		RebirthClient:UpdateProgressBar(newStrength)
	end)
end

function RebirthClient.Setup(self)
	RebirthButton.Activated:Connect(function()
		Rebirth:FireServer("Rebirth")
	end)
	SkipButton.Activated:Connect(function()
		Rebirth:FireServer("Skip")
	end)
	RebirthClient:UpdateFrames(Data.Rebirths)
	RebirthClient:UpdateProgressBar(Data.Strength)
end

function RebirthClient.Start(self)
	RebirthClient:Listen()
	RebirthClient:Setup()
end

return RebirthClient