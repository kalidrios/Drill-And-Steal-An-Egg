-- InterfaceClient: Управление UI-окнами (открытие, закрытие, эффекты размытия и затемнения)

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local LocalPlayer = game.Players.LocalPlayer

ReplicatedStorage:WaitForChild("Client")

local Utils = ReplicatedStorage:WaitForChild("Utils")
local Satchel = require(Utils:WaitForChild("Satchel"))
local Icon = require(Utils:WaitForChild("Topbar"):WaitForChild("Icon"))
local Main = LocalPlayer.PlayerGui:WaitForChild("Main")
local Second = LocalPlayer.PlayerGui:WaitForChild("Second")
local TopFrame = Main:WaitForChild("TopFrame")
local ProgressFrame = TopFrame:WaitForChild("ProgressFrame")
local TeleportFrame = TopFrame:WaitForChild("TeleportFrame")
local LeftFrame = Main:WaitForChild("LeftFrame")
local LeftFrameStartPos = LeftFrame.Position

local RightUi = Second:WaitForChild("RightUi")
local RightUiStartPos = RightUi.Position

local Dim = Second:WaitForChild("Dim")
local UIBlur = game.Lighting:WaitForChild("UIBlur")
local Camera = game.Workspace.Camera

local InterfaceClient = {
	Active = false,
	Frames = {
		SellingFrame = Main:WaitForChild("SellingFrame"),
		IndexFrame = Main:WaitForChild("IndexFrame"),
		PickaxeFrame = Main:WaitForChild("PickaxeFrame"),
		RebirthFrame = Main:WaitForChild("RebirthFrame"),
		ShopFrame = Main:WaitForChild("ShopFrame"),
		UpgradeFrame = Main:WaitForChild("UpgradeFrame"),
		RewardFrame = Main:FindFirstChild("RewardFrame"),
		OfflineEarningsFrame = Main:WaitForChild("OfflineEarningsFrame"),
		AuraFrame = Main:WaitForChild("AurasFrame"),
		CodesFrame = Main:WaitForChild("CodesFrame"),
		DailyRewardsFrame = Main:WaitForChild("DailyRewardsFrame")
	},

	--- Управление прозрачностью фона затемнения (Dim)
	Fade = function(self, isFadingIn)
		if isFadingIn then
			TweenService:Create(Dim, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 0.5
			}):Play()
		else
			TweenService:Create(Dim, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 1
			}):Play()
		end
	end,

	--- Управление визуальными эффектами (FOV камеры, затемнение, размытие)
	Effects = function(self, isEnabled)
		if isEnabled then
			TweenService:Create(Camera, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				FieldOfView = 90
			}):Play()
			TweenService:Create(Dim, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 0.7
			}):Play()
			TweenService:Create(UIBlur, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Size = 25
			}):Play()
		else
			TweenService:Create(Camera, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				FieldOfView = 70
			}):Play()
			TweenService:Create(Dim, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 1
			}):Play()
			TweenService:Create(UIBlur, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Size = 0
			}):Play()
		end
	end,

	--- Скрытие бокового UI и отключение рюкзака при открытом окне
	Hide = function(self, isHidden)
		if isHidden then
			ProgressFrame.Visible = false
			TeleportFrame.Visible = false
			TweenService:Create(LeftFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Position = UDim2.new(1.3, 0, 0.44, 0)
			}):Play()
			if RightUi then
				TweenService:Create(RightUi, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
					Position = UDim2.new(-0.5, 0, 0.4, 0)
				}):Play()
			end
			Satchel:SetBackpackEnabled(false)
			return
		end

		LeftFrame.Visible = true
		if RightUi then
			RightUi.Visible = true
		end

		local isInMine = LocalPlayer:GetAttribute("IsInMine")

		ProgressFrame.Visible = not isInMine and not LocalPlayer:GetAttribute("InTutorial")
		TeleportFrame.Visible = isInMine
		TweenService:Create(LeftFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
			Position = LeftFrameStartPos
		}):Play()
		if RightUi then
			TweenService:Create(RightUi, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Position = RightUiStartPos
			}):Play()
		end
		Satchel:SetBackpackEnabled(true)
	end
}

--- Открывает указанное UI-окно
function InterfaceClient.Open(self, frame)
	if not frame or not frame.Parent then return end
	if not frame.Visible then
		InterfaceClient:CloseAll(true)
		Icon.setTopbarEnabled(false)
		frame.Visible = true
		TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, 0, 0.485, 0)
		}):Play()
		InterfaceClient:Effects(true)
		InterfaceClient:Hide(true)
	end
end

--- Закрывает указанное UI-окно
function InterfaceClient.Close(self, frame, instant)
	if not frame or not frame.Parent then return end
	if InterfaceClient.Active then
		return
	end

	InterfaceClient.Active = true
	Icon.setTopbarEnabled(true)
	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 1, 0)
	}):Play()
	frame.Visible = false

	if instant then
		InterfaceClient.Active = false
		return
	end

	InterfaceClient:Effects(false)
	InterfaceClient:Hide(false)
	InterfaceClient.Active = false
end

--- Закрывает все UI-окна
function InterfaceClient.CloseAll(self, instant)
	for _, frame in pairs(InterfaceClient.Frames) do
		if frame and frame.Parent and frame.Visible then
			task.spawn(function()
				InterfaceClient:Close(frame, instant)
			end)
		end
	end
end

return InterfaceClient