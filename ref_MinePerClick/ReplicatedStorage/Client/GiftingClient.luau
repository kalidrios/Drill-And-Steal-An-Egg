-- GiftingClient: Дарение лута другим игрокам через ProximityPrompt

game:GetService("CollectionService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = game.Players.LocalPlayer
local GiftLoot = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("GiftLoot")
local GiftingClient = {}

--- Проверяет, держит ли игрок Tool с UniqueId (лут-гир)
local function IsHoldingGear()
	local Character = LocalPlayer.Character
	if not Character then
		return false
	end

	for _, child in ipairs(Character:GetChildren()) do
		if child:IsA("Tool") and child:GetAttribute("UniqueId") then
			return true
		end
	end

	return false
end

--- Создаёт ProximityPrompt для дарения над другим игроком
function GiftingClient.Create(self, targetPlayer)
	if targetPlayer == Players.LocalPlayer then
		return
	end

	local character = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
	if not character then
		return
	end

	local attachment = script:WaitForChild("Attachment"):Clone()
	attachment.Parent = character:FindFirstChild("HumanoidRootPart")

	local ProximityPrompt = attachment:FindFirstChild("ProximityPrompt")
	if ProximityPrompt then
		ProximityPrompt.Enabled = false
		ProximityPrompt.HoldDuration = 1.5

		UserInputService.InputChanged:Connect(function()
			ProximityPrompt.Enabled = IsHoldingGear()
		end)

		ProximityPrompt.Triggered:Connect(function(triggeringPlayer)
			if triggeringPlayer ~= Players.LocalPlayer then
				return
			end
			GiftLoot:FireServer(targetPlayer.UserId)
		end)
	end
end

function GiftingClient.Start(self)
	Players.PlayerAdded:Connect(function(player)
		if player.Character then
			GiftingClient:Create(player)
		end
		player.CharacterAdded:Connect(function()
			GiftingClient:Create(player)
		end)
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			GiftingClient:Create(player)
		end
		player.CharacterAdded:Connect(function()
			GiftingClient:Create(player)
		end)
	end
end

return GiftingClient