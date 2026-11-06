-- NotificationClient: Система уведомлений (Default/Error/Purchase/Rebirth/Mythic)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game.Players.LocalPlayer
local Utils = ReplicatedStorage:WaitForChild("Utils")

require(Utils:WaitForChild("Shimmer"))

local NotificationRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("Notification")
local NotificationsContainer = LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("TopFrame"):WaitForChild("Notifications")
local TopBarTemplate = script:WaitForChild("TopBar")

ReplicatedStorage:WaitForChild("Assets")

local NotificationClient = {
	--- Отправляет уведомление на экран
	--- @param notifType Тип: "Default", "Error", "Purchase", "Rebirth", "Mythic"
	--- @param message Текст уведомления
	--- @param duration Длительность показа
	Send = function(notifType, message, duration)
		duration = tonumber(duration) or 3.5
		local notif = TopBarTemplate:Clone()
		local Desc = notif:WaitForChild("Desc")

		Desc:WaitForChild("UIStroke")
		Desc.Text = message
		notif.Size = UDim2.new(0, 0, 0, 0)
		notif.Parent = NotificationsContainer
		TweenService:Create(notif, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = TopBarTemplate.Size
		}):Play()

		if notifType == "Default" then
			game:GetService("SoundService"):FindFirstChild("Notification"):Play()
		end

		if notifType == "Purchase" then
			game:GetService("SoundService"):FindFirstChild("Purchase"):Play()
		end
		if notifType == "Rebirth" then
			Desc.TextColor3 = Color3.fromRGB(130, 255, 28)
			game:GetService("SoundService"):FindFirstChild("Notification"):Play()
		end

		if notifType == "Mythic" then
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Parent = Desc
			UIGradient:AddTag("MythicEffect")
			game:GetService("SoundService"):FindFirstChild("Rebirth"):Play()
		end

		if notifType ~= "Error" then
			task.delay(duration, function()
				TweenService:Create(notif, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
					Size = UDim2.new(0, 0, 0, 0)
				}):Play()
				task.wait(0.25)
				notif:Destroy()
			end)

			return notif
		end

		Desc.TextColor3 = Color3.fromRGB(255, 70, 70)
		game.SoundService:FindFirstChild("Error"):Play()
		task.delay(duration, function()
			TweenService:Create(notif, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0)
			}):Play()
			task.wait(0.25)
			notif:Destroy()
		end)

		return notif
	end
}

function NotificationClient.Start(self)
	NotificationRemote.OnClientEvent:Connect(function(notifType, message, duration)
		NotificationClient.Send(notifType, message, duration)
	end)
end

return NotificationClient