--[[
	ReplicaService: Легковесный серверный модуль репликации данных,
	совместимый с клиентским ReplicaController (Madwork)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ReplicaRemoteEvents = ReplicatedStorage:WaitForChild("ReplicaRemoteEvents")

-- Remote references
local ReplicaRequestData = ReplicaRemoteEvents:WaitForChild("Replica_ReplicaRequestData")
local ReplicaCreate = ReplicaRemoteEvents:WaitForChild("Replica_ReplicaCreate")
local ReplicaDestroy = ReplicaRemoteEvents:WaitForChild("Replica_ReplicaDestroy")
local ReplicaSetValue = ReplicaRemoteEvents:WaitForChild("Replica_ReplicaSetValue")
local ReplicaSetValues = ReplicaRemoteEvents:WaitForChild("Replica_ReplicaSetValues")
local ReplicaArrayInsert = ReplicaRemoteEvents:WaitForChild("Replica_ReplicaArrayInsert")
local ReplicaArraySet = ReplicaRemoteEvents:WaitForChild("Replica_ReplicaArraySet")
local ReplicaArrayRemove = ReplicaRemoteEvents:WaitForChild("Replica_ReplicaArrayRemove")
local ReplicaSignal = ReplicaRemoteEvents:WaitForChild("Replica_ReplicaSignal")

-- State
local _nextReplicaId = 1
local _replicas = {}
local _playerSubscriptions = {}
local _pendingPlayers = {}

-- Replica class
local Replica = {}
Replica.__index = Replica



--- Создаёт новую реплику
function Replica.new(config)
	local id = _nextReplicaId
	_nextReplicaId += 1

	local self = setmetatable({}, Replica)
	self.Id = id
	self.Class = config.ClassToken
	self.Tags = config.Tags or {}
	self.Data = config.Data or {}
	self.Parent = config.Parent or nil
	self.Children = {}
	self._writeLib = config.WriteLib
	self._subscribers = {} -- Player -> true
	self._destroyed = false

	_replicas[id] = self

	-- Handle replication targets
	local replication = config.Replication
	if replication == "All" then
		-- Subscribe all current and future players
		for _, player in ipairs(Players:GetPlayers()) do
			self._subscribers[player] = true
			if not _pendingPlayers[player] then
				_sendReplicaCreate(player, self)
			end
		end
	elseif typeof(replication) == "Instance" and replication:IsA("Player") then
		self._subscribers[replication] = true
		if not _pendingPlayers[replication] then
			_sendReplicaCreate(replication, self)
		end
	elseif type(replication) == "table" then
		for _, player in ipairs(replication) do
			self._subscribers[player] = true
			if not _pendingPlayers[player] then
				_sendReplicaCreate(player, self)
			end
		end
	end

	-- Track in parent
	if self.Parent then
		table.insert(self.Parent.Children, self)
	end

	return self
end

--- Помощник: отправляет создание реплики конкретному игроку
function _sendReplicaCreate(player, replica)
	local parentId = if replica.Parent then replica.Parent.Id else 0
	local createData = {
		[tostring(replica.Id)] = {
			replica.Class,    -- [1] class
			replica.Tags,     -- [2] tags
			replica.Data,     -- [3] data
			parentId,         -- [4] parent id
			replica._writeLib -- [5] write lib module
		}
	}
	ReplicaCreate:FireClient(player, replica.Id, createData[tostring(replica.Id)])

	-- Track subscription
	if not _playerSubscriptions[player] then
		_playerSubscriptions[player] = {}
	end
	_playerSubscriptions[player][replica.Id] = true
end

--- Отправляет все реплики, на которые подписан игрок, одним пакетом
local function sendAllReplicasToPlayer(player)
	local bulk = {}
	local sortedIds = {}

	for id, replica in pairs(_replicas) do
		if replica._subscribers[player] then
			table.insert(sortedIds, id)
		end
	end
	table.sort(sortedIds)

	for _, id in ipairs(sortedIds) do
		local replica = _replicas[id]
		local parentId = if replica.Parent then replica.Parent.Id else 0
		table.insert(bulk, {
			id,
			{
				[tostring(id)] = {
					replica.Class,
					replica.Tags,
					replica.Data,
					parentId,
					replica._writeLib
				}
			}
		})

		if not _playerSubscriptions[player] then
			_playerSubscriptions[player] = {}
		end
		_playerSubscriptions[player][id] = true
	end

	if #bulk > 0 then
		ReplicaCreate:FireClient(player, bulk)
	end
	-- Signal initial data complete
	ReplicaRequestData:FireClient(player)
end

-- SetValue: мутирует данные и отправляет клиенту
function Replica:SetValue(path, value)
	if self._destroyed then return end

	local data = self.Data
	for i = 1, #path - 1 do
		data = data[path[i]]
		if data == nil then
			warn("[ReplicaService]: Invalid path in SetValue", table.concat(path, "."))
			return
		end
	end
	data[path[#path]] = value

	for player in pairs(self._subscribers) do
		if player.Parent and not _pendingPlayers[player] then -- still connected and not pending
			ReplicaSetValue:FireClient(player, self.Id, path, value)
		end
	end
end

-- SetValues: мутирует несколько ключей
function Replica:SetValues(path, values)
	if self._destroyed then return end

	local data = self.Data
	for i = 1, #path do
		data = data[path[i]]
		if data == nil then return end
	end
	for k, v in pairs(values) do
		data[k] = v
	end

	for player in pairs(self._subscribers) do
		if player.Parent and not _pendingPlayers[player] then
			ReplicaSetValues:FireClient(player, self.Id, path, values)
		end
	end
end

-- ArrayInsert
function Replica:ArrayInsert(path, value)
	if self._destroyed then return 0 end

	local data = self.Data
	for i = 1, #path do
		data = data[path[i]]
		if data == nil then return 0 end
	end
	table.insert(data, value)
	local index = #data

	for player in pairs(self._subscribers) do
		if player.Parent and not _pendingPlayers[player] then
			ReplicaArrayInsert:FireClient(player, self.Id, path, value)
		end
	end
	return index
end

-- ArrayRemove
function Replica:ArrayRemove(path, index)
	if self._destroyed then return nil end

	local data = self.Data
	for i = 1, #path do
		data = data[path[i]]
		if data == nil then return nil end
	end
	local removed = table.remove(data, index)

	for player in pairs(self._subscribers) do
		if player.Parent and not _pendingPlayers[player] then
			ReplicaArrayRemove:FireClient(player, self.Id, path, index)
		end
	end
	return removed
end

-- ArraySet
function Replica:ArraySet(path, index, value)
	if self._destroyed then return end

	local data = self.Data
	for i = 1, #path do
		data = data[path[i]]
		if data == nil then return end
	end
	data[index] = value

	for player in pairs(self._subscribers) do
		if player.Parent and not _pendingPlayers[player] then
			ReplicaArraySet:FireClient(player, self.Id, path, index, value)
		end
	end
end

-- FireClient signal
function Replica:FireClient(player, ...)
	if self._destroyed then return end
	if not _pendingPlayers[player] then
		ReplicaSignal:FireClient(player, self.Id, ...)
	end
end

-- FireAllClients signal
function Replica:FireAllClients(...)
	if self._destroyed then return end
	for player in pairs(self._subscribers) do
		if player.Parent and not _pendingPlayers[player] then
			ReplicaSignal:FireClient(player, self.Id, ...)
		end
	end
end

-- Destroy
function Replica:Destroy()
	if self._destroyed then return end
	self._destroyed = true

	-- Destroy children
	for _, child in ipairs(self.Children) do
		child:Destroy()
	end

	-- Notify clients
	for player in pairs(self._subscribers) do
		if player.Parent and not _pendingPlayers[player] then
			ReplicaDestroy:FireClient(player, self.Id)
		end
		if _playerSubscriptions[player] then
			_playerSubscriptions[player][self.Id] = nil
		end
	end

	-- Remove from parent
	if self.Parent then
		local children = self.Parent.Children
		local idx = table.find(children, self)
		if idx then
			table.remove(children, idx)
		end
	end

	_replicas[self.Id] = nil
end

--- Добавляет подписчика на существующую реплику
function Replica:ReplicateFor(player)
	if self._destroyed then return end
	if self._subscribers[player] then return end

	self._subscribers[player] = true
	if not _pendingPlayers[player] then
		_sendReplicaCreate(player, self)
	end
end

--- Убирает подписчика
function Replica:DestroyFor(player)
	if self._destroyed then return end
	if not self._subscribers[player] then return end

	self._subscribers[player] = nil
	if player.Parent and not _pendingPlayers[player] then
		ReplicaDestroy:FireClient(player, self.Id)
	end
	if _playerSubscriptions[player] then
		_playerSubscriptions[player][self.Id] = nil
	end
end

-- Модуль
local ReplicaService = {}

function ReplicaService.NewReplica(config)
	return Replica.new(config)
end

function ReplicaService.GetReplicaById(id)
	return _replicas[id]
end

-- Handle initial data requests from clients
ReplicaRequestData.OnServerEvent:Connect(function(player)
	_pendingPlayers[player] = nil
	sendAllReplicasToPlayer(player)
end)

-- Cleanup on player leave
Players.PlayerRemoving:Connect(function(player)
	_pendingPlayers[player] = nil
	_playerSubscriptions[player] = nil

	for _, replica in pairs(_replicas) do
		replica._subscribers[player] = nil
	end
end)

-- Mark new players as pending
Players.PlayerAdded:Connect(function(player)
	_pendingPlayers[player] = true
end)

for _, player in ipairs(Players:GetPlayers()) do
	_pendingPlayers[player] = true
end

return ReplicaService
