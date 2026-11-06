-- SignalClient: Прослушка изменений Inventory/Index/TraitIndex и трансляция в сигналы

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Client = ReplicatedStorage:WaitForChild("Client")
local DataClient = require(Client:WaitForChild("DataClient"))
local Databases = ReplicatedStorage:WaitForChild("Databases")
local Signals = require(Databases:WaitForChild("Signals"))
local Replica = DataClient:GetReplica()
local Data = Replica.Data
local SignalClient = {}

local function ListenToLoot(itemData, uniqueId)
	Replica:ListenToChange({ "Inventory", uniqueId }, function(newValue)
		if newValue ~= nil then
			return
		end
		Signals.LootRemoved:Fire(itemData, uniqueId)
	end)
end

function SignalClient.Listen(self)
	-- Новые предметы в инвентаре
	Replica:ListenToNewKey({ "Inventory" }, function(itemData, uniqueId)
		Signals.LootAdded:Fire(itemData, uniqueId)
		Replica:ListenToChange({ "Inventory", uniqueId }, function(newValue)
			if newValue ~= nil then
				return
			end
			Signals.LootRemoved:Fire(itemData, uniqueId)
		end)
	end)

	-- Слушатели для уже существующих предметов
	for uniqueId, itemData in pairs(Data.Inventory) do
		Replica:ListenToChange({ "Inventory", uniqueId }, function(newValue)
			if newValue ~= nil then
				return
			end
			Signals.LootRemoved:Fire(itemData, uniqueId)
		end)
	end

	-- Индекс коллекции
	Replica:ListenToArrayInsert({ "InventoryIndex" }, function(_, itemId)
		Signals.IndexAdded:Fire(itemId)
	end)
	Replica:ListenToArrayRemove({ "InventoryIndex" }, function(_, itemId)
		Signals.IndexRemoved:Fire(itemId)
	end)

	-- Индекс трейтов
	Replica:ListenToArrayInsert({ "TraitIndex" }, function(_, traitId)
		Signals.TraitIndexAdded:Fire(traitId)
	end)
	Replica:ListenToArrayRemove({ "TraitIndex" }, function(_, traitId)
		Signals.TraitIndexRemoved:Fire(traitId)
	end)
end

function SignalClient.Start(self)
	SignalClient:Listen()
end

return SignalClient