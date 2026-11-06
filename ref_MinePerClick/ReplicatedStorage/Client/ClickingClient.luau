-- ClickingClient: Анимация "+N Strength" поп-апов при клике
-- Показывает всплывающий текст с набранной силой

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game.Players.LocalPlayer
local Client = ReplicatedStorage:WaitForChild("Client")
local DataClient = require(Client:WaitForChild("DataClient"))
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))
local ClickRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Click")
local Data = DataClient:GetReplica().Data
local GainsFrame = LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("Gains")
local StrengthTemplate = GainsFrame:WaitForChild("Strength")
local ClickingClient = {
	PlayAnimation = function(self, strengthGain)
		local popUp = StrengthTemplate:Clone()
		local Amount = popUp:WaitForChild("Amount")
		local UIScale = popUp:FindFirstChild("UIScale")
		local uiStroke = Amount:FindFirstChildWhichIsA("UIStroke")

		Amount.Text = ("+%*"):format((Formatting:FormatNumber(strengthGain)))
		Amount.TextTransparency = 0
		popUp.ImageTransparency = 0
		popUp.Visible = true
		popUp.Parent = GainsFrame

		if UIScale then
			UIScale.Scale = 0
		end

		popUp.Position = UDim2.new(0.5 + (math.random() - 0.5) * 2 * 0.25, 0, 0.5 + (math.random() - 0.5) * 2 * 0.25, 0)

		local randomRotation = math.random(-25, 25)

		popUp.Rotation = randomRotation
		Amount.Rotation = -randomRotation

		local moveTween = TweenService:Create(Amount, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Position = Amount.Position - UDim2.fromOffset(0, 50)
		})
		local scaleTween = if UIScale then TweenService:Create(UIScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Scale = 0.85
}) else nil

		moveTween:Play()

		if scaleTween then
			scaleTween:Play()
		end

		task.delay(0.35, function()
			if not popUp.Parent then
				return
			end

			TweenService:Create(Amount, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				TextTransparency = 1
			}):Play()

			if not uiStroke then
				return
			end

			TweenService:Create(uiStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Transparency = 1
			}):Play()
		end)
		task.delay(0.25, function()
			if popUp.Parent then
				TweenService:Create(popUp, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
					ImageTransparency = 1
				}):Play()
			end
		end)

		local popSound = SoundService:FindFirstChild("Pop")

		if not popSound then
			task.delay(1.15, function()
				if not popUp.Parent then
					return
				end

				popUp:Destroy()
			end)

			return
		end

		popSound:Play()
		task.delay(1.15, function()
			if not popUp.Parent then
				return
			end

			popUp:Destroy()
		end)
	end
}

--- Слушает ответ сервера на Click (strengthGain)
function ClickingClient.Listen(self)
	ClickRemote.OnClientEvent:Connect(function(strengthGain)
		ClickingClient:PlayAnimation(strengthGain)
	end)
end

function ClickingClient.Start(self)
	ClickingClient:Listen()

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local character = LocalPlayer.Character
			if character then
				local tool = character:FindFirstChildWhichIsA("Tool")
				if tool and tool:GetAttribute("Pickaxe") then
					ClickRemote:FireServer()
				end
			end
		end
	end)
end

return ClickingClient