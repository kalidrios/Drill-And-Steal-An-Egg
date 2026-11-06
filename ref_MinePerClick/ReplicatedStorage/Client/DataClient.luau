-- DataClient: Управление реплицированными данными игроков
-- Обеспечивает доступ к ReplicaController профилям через Promise-based API

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ReplicaController = require(ReplicatedStorage.Utils.ReplicaController)
local Promise = require(ReplicatedStorage.Utils.Promise)

local DataClient = {
	PlayerReplicas = {},
	GlobalReplicas = {},
	ReplicaLoaded = require(ReplicatedStorage.Utils.Signal).new(),
	_initialized = false
}

function DataClient.Init()
	if DataClient._initialized then return end
	DataClient._initialized = true

	ReplicaController.ReplicaOfClassCreated("Profile", function(replica)
		local Player = replica.Tags.Player

		if Player then
			DataClient.PlayerReplicas[Player] = replica
			DataClient.ReplicaLoaded:Fire(Player, replica)
		end
	end)

	ReplicaController.ReplicaOfClassCreated("Server", function(replica)
		DataClient.GlobalReplicas.Server = replica
		DataClient.ReplicaLoaded:Fire("Server", replica)
	end)

	Players.PlayerRemoving:Connect(function(player)
		DataClient.PlayerReplicas[player] = nil
	end)
end

-- Инициализируем подписки сразу при require, чтобы избежать дедлока в :GetReplica():await() до вызова StartModules()
DataClient.Init()

--- Получает реплику игрока (Promise)
local function FetchPlayerReplica(player)
	return Promise.new(function(resolve)
		local connection = nil
		connection = DataClient.ReplicaLoaded:Connect(function(loadedPlayer, replica)
			if loadedPlayer == player then
				resolve(replica)
				connection:Disconnect()
			end
		end)
	end)
end

--- Получает глобальную реплику (Promise)
local function FetchGlobalReplica(replicaName)
	return Promise.new(function(resolve)
		local connection = nil
		connection = DataClient.ReplicaLoaded:Connect(function(name, replica)
			if name == replicaName then
				resolve(replica)
				connection:Disconnect()
			end
		end)
	end)
end

--- Возвращает реплику для указанного игрока (или LocalPlayer)
function DataClient.GetReplica(self, player)
	local targetPlayer = player or Players.LocalPlayer
	local cached = DataClient.PlayerReplicas[targetPlayer]

	if cached then
		return cached
	end

	local _, replica = Promise.new(function(resolve)
		local connection = nil
		connection = DataClient.ReplicaLoaded:Connect(function(loadedPlayer, loadedReplica)
			if loadedPlayer == targetPlayer then
				resolve(loadedReplica)
				connection:Disconnect()
			end
		end)
	end):await()

	return replica
end

--- Возвращает глобальную реплику по имени
function DataClient.GetGlobalReplica(self, replicaName)
	local cached = DataClient.GlobalReplicas[replicaName]

	if cached then
		return cached
	end

	local _, replica = Promise.new(function(resolve)
		local connection = nil
		connection = DataClient.ReplicaLoaded:Connect(function(name, loadedReplica)
			if name == replicaName then
				resolve(loadedReplica)
				connection:Disconnect()
			end
		end)
	end):await()

	return replica
end

--- Запуск: подписка на создание реплик "Profile" и "Server"
function DataClient.Start(self)
	DataClient.Init()
end

return DataClient