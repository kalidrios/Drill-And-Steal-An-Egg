--[[
	AdminService: Серверный обработчик админ-панели.
	Проверяет права доступа и выполняет команды разработчика.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(ServerScriptService.Server.Services.DataService)
local LootService = require(ServerScriptService.Server.Services.LootService)
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local ItemsList = require(ReplicatedStorage:WaitForChild("Databases"):WaitForChild("ItemsList"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local AdminFolder = Remotes:WaitForChild("Admin")
local AdminActionRemote = AdminFolder:FindFirstChild("AdminAction")
if not AdminActionRemote then
	AdminActionRemote = Instance.new("RemoteEvent")
	AdminActionRemote.Name = "AdminAction"
	AdminActionRemote.Parent = AdminFolder
end

local LootAddedRemote = Remotes:WaitForChild("Client"):WaitForChild("LootAdded")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")

-- Разрешенные разработчики
local ALLOWED_USER_IDS = {
	[2897930534] = true,
	[4113316813] = true,-- ID владельца/разработчика
}

local AdminService = {}

-- Проверка прав админа
function AdminService.IsPlayerAdmin(player)
	if ALLOWED_USER_IDS[player.UserId] then
		return true
	end
	if player.UserId == game.CreatorId then
		return true
	end
	if game:GetService("RunService"):IsStudio() then
		return true
	end
	return false
end

function AdminService:OnPlayerAdded(player)
	if self.IsPlayerAdmin(player) then
		player:SetAttribute("IsAdmin", true)
		print("[AdminService]: Admin rights granted to", player.Name)
	end
end

function AdminService:Start()
	AdminActionRemote.OnServerEvent:Connect(function(player, action, data)
		if not self.IsPlayerAdmin(player) then
			warn("[AdminService]: Unauthorized action attempt by", player.Name, "action:", action)
			player:Kick("Unauthorized Admin Action")
			return
		end

		local profile = DataService.GetProfile(player)
		if not profile then return end
		local profileData = profile.Data

		if action == "SetStat" then
			local targetPlayerName = data.PlayerName
			local statName = data.StatName
			local value = tonumber(data.Value)
			if not value or value < 0 then return end

			local targetPlayer = Players:FindFirstChild(targetPlayerName)
			if not targetPlayer then return end

			local targetProfile = DataService.GetProfile(targetPlayer)
			if not targetProfile then return end

			if statName == "Cash" or statName == "Strength" or statName == "Rebirths" or statName == "WallsBroken" then
				targetProfile.Replica:SetValue({statName}, value)
				DataService.UpdateLeaderstats(targetPlayer)
				if statName == "Cash" or statName == "Strength" then
					NotificationRemote:FireClient(player, "Admin Success", string.format("Set %s to %d for %s", statName, value, targetPlayer.Name), 2)
				end
			end

		elseif action == "AddStat" then
			local targetPlayerName = data.PlayerName
			local statName = data.StatName
			local addValue = tonumber(data.Value)
			if not addValue or addValue == 0 then return end

			local targetPlayer = Players:FindFirstChild(targetPlayerName)
			if not targetPlayer then return end

			local targetProfile = DataService.GetProfile(targetPlayer)
			if not targetProfile then return end

			if statName == "Cash" or statName == "Strength" or statName == "Rebirths" or statName == "WallsBroken" then
				local currentValue = targetProfile.Data[statName] or 0
				local newValue = math.max(0, currentValue + addValue)
				targetProfile.Replica:SetValue({statName}, newValue)
				DataService.UpdateLeaderstats(targetPlayer)
				NotificationRemote:FireClient(player, "Admin Success", string.format("Added %d %s to %s", addValue, statName, targetPlayer.Name), 2)
			end

		elseif action == "GiveItem" then
			local targetPlayerName = data.PlayerName
			local itemId = data.ItemId
			local amount = math.clamp(tonumber(data.Amount) or 1, 1, 100)

			local targetPlayer = Players:FindFirstChild(targetPlayerName)
			if not targetPlayer then return end

			local targetProfile = DataService.GetProfile(targetPlayer)
			if not targetProfile then return end

			local itemConfig = ItemsList[itemId]
			if not itemConfig then
				NotificationRemote:FireClient(player, "Error", "Item not found in database: " .. tostring(itemId), 3)
				return
			end

			-- Выдача предметов
			for i = 1, amount do
				local uniqueId = HttpService:GenerateGUID(false)
				local inventoryItem = {
					ItemId = itemId,
					InTraitMachine = false,
					IsFavorited = false,
					InBackpack = true,
				}
				targetProfile.Replica:SetValue({"Inventory", uniqueId}, inventoryItem)
				
				if not table.find(targetProfile.Data.InventoryIndex, itemId) then
					targetProfile.Replica:ArrayInsert({"InventoryIndex"}, itemId)
				end
				LootAddedRemote:FireClient(targetPlayer, inventoryItem, uniqueId)
			end

			DataService.UpdateInventoryCount(targetPlayer)
			NotificationRemote:FireClient(player, "Admin Success", string.format("Gave %dx %s to %s", amount, itemConfig.Name, targetPlayer.Name), 2.5)

		elseif action == "ClearInventory" then
			local targetPlayerName = data.PlayerName
			local targetPlayer = Players:FindFirstChild(targetPlayerName)
			if not targetPlayer then return end

			local targetProfile = DataService.GetProfile(targetPlayer)
			if not targetProfile then return end

			targetProfile.Replica:SetValue({"Inventory"}, {})
			DataService.UpdateInventoryCount(targetPlayer)
			NotificationRemote:FireClient(player, "Admin Success", "Cleared inventory of " .. targetPlayer.Name, 2.5)

		elseif action == "SpawnLoot" then
			local rarity = data.Rarity or "Common"
			local character = player.Character
			local hrp = character and character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local spawnPos = hrp.Position + hrp.CFrame.LookVector * 10 + Vector3.new(0, 2, 0)
				LootService.SpawnGlobalLoot(rarity, spawnPos)
				NotificationRemote:FireClient(player, "Admin Success", "Spawned global public " .. rarity .. " item!", 2)
			end

		elseif action == "ClearLoot" then
			for _, child in ipairs(workspace:GetChildren()) do
				if child:IsA("Model") and child:FindFirstChildWhichIsA("ProximityPrompt") then
					child:Destroy()
				end
			end
			NotificationRemote:FireClient(player, "Admin Success", "Cleared all public loot in workspace!", 2)

		elseif action == "TeleportTo" then
			local targetPlayerName = data.TargetPlayerName
			local targetPlayer = Players:FindFirstChild(targetPlayerName)
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			
			if targetPlayer and targetPlayer.Character and hrp then
				local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
				if targetHrp then
					hrp.CFrame = targetHrp.CFrame + Vector3.new(0, 3, 0)
					NotificationRemote:FireClient(player, "Admin Success", "Teleported to " .. targetPlayerName, 1.5)
				end
			end

		elseif action == "Bring" then
			local targetPlayerName = data.TargetPlayerName
			local targetPlayer = Players:FindFirstChild(targetPlayerName)
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			
			if targetPlayer and targetPlayer.Character and hrp then
				local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
				if targetHrp then
					targetHrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 5 + Vector3.new(0, 2, 0)
					NotificationRemote:FireClient(player, "Admin Success", "Brought " .. targetPlayerName, 1.5)
				end
			end

		elseif action == "Kick" then
			local targetPlayerName = data.TargetPlayerName
			local reason = data.Reason or "Kicked by Developer"
			local targetPlayer = Players:FindFirstChild(targetPlayerName)
			if targetPlayer then
				targetPlayer:Kick("\n[Developer Kick]\nReason: " .. reason)
				NotificationRemote:FireClient(player, "Admin Success", "Kicked " .. targetPlayerName, 2)
			end
		end
	end)
end

return AdminService