local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService
local Databases = ReplicatedStorage:WaitForChild("Databases")
local TraitsList = require(Databases:WaitForChild("TraitsList"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local TraitMachinePlaceRemote = Remotes:WaitForChild("Server"):WaitForChild("TraitMachinePlace")
local TraitMachineStartRemote = Remotes:WaitForChild("Server"):WaitForChild("TraitMachineStart")
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local SellingHelper = require(Helpers:WaitForChild("SellingHelper"))

local TraitMachineService = {}

local function RollRandomTrait()
	local roll = math.random() * 100
	local sum = 0
	-- Lucky (1%), Cursed (3.5%), Toxic (5%), Frozen (10%), Berry (20%), Flame (60.5%)
	local orderedTraits = {
		{ name = "Lucky", chance = 1 },
		{ name = "Cursed", chance = 3.5 },
		{ name = "Toxic", chance = 5 },
		{ name = "Frozen", chance = 10 },
		{ name = "Berry", chance = 20 },
		{ name = "Flame", chance = 60.5 }
	}
	for _, trait in ipairs(orderedTraits) do
		sum += trait.chance
		if roll <= sum then
			return trait.name
		end
	end
	return "Flame"
end

function TraitMachineService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)

	TraitMachinePlaceRemote.OnServerEvent:Connect(function(player, slotNum)
		if slotNum ~= 1 and slotNum ~= 2 then return end
		local slotName = "Slot " .. slotNum

		local profile = DataService.GetProfile(player)
		if not profile then return end

		local data = profile.Data
		local replica = profile.Replica

		-- Машина работает — нельзя менять слоты
		if (data.TraitMachine.StartedAt or 0) > 0 then return end

		local currentItem = data.TraitMachine[slotName]
		if currentItem then
			-- Забираем предмет обратно (Pickup)
			local uniqueId = nil
			for id, item in pairs(data.Inventory) do
				if item.ItemId == currentItem.ItemId and item.InTraitMachine == true then
					uniqueId = id
					break
				end
			end

			if uniqueId then
				replica:SetValue({"Inventory", uniqueId, "InTraitMachine"}, false)
				replica:SetValue({"TraitMachine", slotName}, nil)
				DataService.UpdateInventoryCount(player)
				
				-- Перевыдаем инструменты на Surface
				local SellingService = require(ServerScriptService.Server.Services.SellingService)
				SellingService.GiveInventoryTools(player)
			end
		else
			-- Кладем предмет из рук или инвентаря (Place)
			local char = player.Character
			local tool = char and char:FindFirstChildOfClass("Tool")
			local uniqueId = tool and tool:GetAttribute("UniqueId")

			if not uniqueId then
				-- Ищем первый доступный инструмент в Backpack
				local backpack = player:FindFirstChild("Backpack")
				if backpack then
					for _, bTool in ipairs(backpack:GetChildren()) do
						if bTool:IsA("Tool") and bTool:GetAttribute("UniqueId") then
							tool = bTool
							uniqueId = bTool:GetAttribute("UniqueId")
							break
						end
					end
				end
			end

			if uniqueId then
				local itemData = data.Inventory[uniqueId]
				if itemData and not itemData.InTraitMachine and not itemData.IsFavorited then
					-- Уничтожаем физический инструмент
					if tool then tool:Destroy() end

					replica:SetValue({"Inventory", uniqueId, "InTraitMachine"}, true)
					replica:SetValue({"TraitMachine", slotName}, itemData)
					DataService.UpdateInventoryCount(player)
				end
			end
		end
	end)

	TraitMachineStartRemote.OnServerEvent:Connect(function(player)
		local profile = DataService.GetProfile(player)
		if not profile then return end

		local data = profile.Data
		local replica = profile.Replica
		local tm = data.TraitMachine

		local startedAt = tm.StartedAt or 0
		if startedAt > 0 then
			-- Проверяем завершение таймера (Claim)
			if startedAt + (tm.Duration or 0) <= os.time() then
				local slot1Item = tm["Slot 1"]
				local slot2Item = tm["Slot 2"]

				if slot1Item then
					-- Находим uniqueId предмета в Slot 1
					local slot1UniqueId = nil
					for id, item in pairs(data.Inventory) do
						if item.ItemId == slot1Item.ItemId and item.InTraitMachine == true then
							slot1UniqueId = id
							break
						end
					end

					if slot1UniqueId then
						-- Применяем случайный трейт
						local traitId = RollRandomTrait()
						replica:SetValue({"Inventory", slot1UniqueId, "TraitIds"}, { traitId })
						replica:SetValue({"Inventory", slot1UniqueId, "InTraitMachine"}, false)

						-- Добавляем в коллекцию (Индекс трейтов)
						if not table.find(data.TraitIndex, traitId) then
							replica:ArrayInsert({"TraitIndex"}, traitId)
						end
					end
				end

				if slot2Item then
					-- Находим uniqueId предмета в Slot 2
					local slot2UniqueId = nil
					for id, item in pairs(data.Inventory) do
						if item.ItemId == slot2Item.ItemId and item.InTraitMachine == true then
							-- Исключаем уже обработанный Slot 1, если они одинаковые
							local slot1UniqueId = nil
							if slot1Item then
								for s1Id, s1Item in pairs(data.Inventory) do
									if s1Item.ItemId == slot1Item.ItemId and s1Item.InTraitMachine == false then -- уже сбросили флаг на false выше
										slot1UniqueId = s1Id
										break
									end
								end
							end
							if id ~= slot1UniqueId then
								slot2UniqueId = id
								break
							end
						end
					end

					if slot2UniqueId then
						-- Применяем случайный трейт
						local traitId = RollRandomTrait()
						replica:SetValue({"Inventory", slot2UniqueId, "TraitIds"}, { traitId })
						replica:SetValue({"Inventory", slot2UniqueId, "InTraitMachine"}, false)

						-- Добавляем в коллекцию (Индекс трейтов)
						if not table.find(data.TraitIndex, traitId) then
							replica:ArrayInsert({"TraitIndex"}, traitId)
						end
					end
				end

				-- Сброс состояния машины
				replica:SetValue({"TraitMachine", "Slot 1"}, nil)
				replica:SetValue({"TraitMachine", "Slot 2"}, nil)
				replica:SetValue({"TraitMachine", "StartedAt"}, 0)
				replica:SetValue({"TraitMachine", "Duration"}, 0)
				DataService.UpdateInventoryCount(player)

				-- Перевыдаем инструменты
				local SellingService = require(ServerScriptService.Server.Services.SellingService)
				SellingService.GiveInventoryTools(player)
			end
		else
			-- Запуск машины
			local slot1Item = tm["Slot 1"]
			if not slot1Item then return end -- обязателен предмет в 1 слоте

			-- Вычисляем цену
			local price = 0
			for _, slotName in ipairs({ "Slot 1", "Slot 2" }) do
				local slotData = tm[slotName]
				if slotData then
					price += SellingHelper:GetTraitMachinePrice(
						slotData,
						data.Rebirths,
						data.Purchases.CashMultiplier or 1,
						data.TraitIndex or {},
						1
					)
				end
			end

			-- Проверяем Cash
			if data.Cash >= price then
				replica:SetValue({"Cash"}, data.Cash - price)
				replica:SetValue({"TraitMachine", "StartedAt"}, os.time())
				replica:SetValue({"TraitMachine", "Duration"}, 15) -- 15 секунд таймер
				DataService.UpdateLeaderstats(player)
			end
		end
	end)

	print("[TraitMachineService]: Started")
end

return TraitMachineService
