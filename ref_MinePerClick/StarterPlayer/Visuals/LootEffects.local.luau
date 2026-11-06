-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("MarketplaceService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game.Players.LocalPlayer
local LootClaimed = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("LootClaimed")
local Success = LocalPlayer.PlayerGui:WaitForChild("Second"):WaitForChild("Success")
local CurrentCamera = game.Workspace.CurrentCamera

LootClaimed.OnClientEvent:Connect(function() --[[ Line: 18 | Upvalues: TweenService (copy), Success (copy) ]]
	task.spawn(function() --[[ Line: 19 | Upvalues: TweenService (ref) ]]
		TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.125, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			FieldOfView = 60
		}):Play()
		task.wait(0.125)
		TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.125, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			FieldOfView = 70
		}):Play()
	end)
	task.spawn(function() --[[ Line: 25 | Upvalues: Success (ref), TweenService (ref) ]]
		Success.Visible = true
		Success.BackgroundTransparency = 1
		TweenService:Create(Success, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 0.45
		}):Play()
		task.wait(0.125)
		TweenService:Create(Success, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.125)
		Success.BackgroundTransparency = 1
		Success.Visible = false
	end)
	game:GetService("SoundService"):FindFirstChild("Purchase"):Play()
end)