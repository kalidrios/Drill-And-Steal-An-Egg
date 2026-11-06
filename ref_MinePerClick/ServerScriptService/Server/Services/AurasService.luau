local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService
local Databases = ReplicatedStorage:WaitForChild("Databases")
local AurasList = require(Databases:WaitForChild("AurasList"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local PurchaseAuraRemote = Remotes:WaitForChild("Server"):WaitForChild("PurchaseAura")
local EquipAuraRemote = Remotes:WaitForChild("Server"):WaitForChild("EquipAura")

local AurasService = {}

function AurasService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)

	PurchaseAuraRemote.OnServerEvent:Connect(function(player, auraId)
		if type(auraId) ~= "string" then return end
		local auraConfig = AurasList[auraId]
		if not auraConfig then return end

		local profile = DataService.GetProfile(player)
		if not profile then return end

		local data = profile.Data
		local replica = profile.Replica

		-- Если уже куплено, просто экипируем или снимаем
		if table.find(data.Auras, auraId) then
			if data.EquippedAuraId == auraId then
				replica:SetValue({"EquippedAuraId"}, "")
			else
				replica:SetValue({"EquippedAuraId"}, auraId)
			end
			return
		end

		-- Проверяем цену
		if data.Cash >= auraConfig.Price then
			replica:SetValue({"Cash"}, data.Cash - auraConfig.Price)
			replica:ArrayInsert({"Auras"}, auraId)
			replica:SetValue({"EquippedAuraId"}, auraId)
			DataService.UpdateLeaderstats(player)
		end
	end)

	EquipAuraRemote.OnServerEvent:Connect(function(player, auraId)
		if type(auraId) ~= "string" then return end
		local profile = DataService.GetProfile(player)
		if not profile then return end

		local data = profile.Data
		local replica = profile.Replica

		if auraId == "" or auraId == "Unequip" or data.EquippedAuraId == auraId then
			-- Снятие ауры
			replica:SetValue({"EquippedAuraId"}, "")
		elseif table.find(data.Auras, auraId) then
			-- Экипировка ауры
			replica:SetValue({"EquippedAuraId"}, auraId)
		end
	end)

	print("[AurasService]: Started")
end

return AurasService
