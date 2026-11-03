--!strict
--[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	Velvet Groups rbx.lua Framework
	-+-+-+- SPECIFICS -+-+-+-
	ReplicatedStorage.Libray.Client.Save
	Cache local de dados do jogador (Speed, Strength, Money) sincronizado com Saving do servidor
	===========
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Network"))
local DefaultStats = require(ReplicatedStorage:WaitForChild("Directory"):WaitForChild("Saving"):WaitForChild("DefaultStats"))

local LocalPlayer = Players.LocalPlayer

local Save = {}

local cachedData: { [string]: any }? = nil
local isFetching = false
local statListeners: { [string]: { (any) -> () } } = {}
local anyStatListeners: { ({ [string]: any }) -> () } = {}

local function notifyStatChanged(statName: string, newValue: any)
	local listeners = statListeners[statName]
	if listeners then
		for _, callback in ipairs(listeners) do
			task.spawn(callback, newValue)
		end
	end
end

local function applyChangesToCache(changes: { [string]: any })
	if not cachedData then
		cachedData = {}
		for k, v in pairs(DefaultStats.Template) do
			if not DefaultStats.NetworkingBlacklist[k] then
				cachedData[k] = v
			end
		end
	end

	local currentCache = cachedData :: { [string]: any }
	for key, val in pairs(changes) do
		currentCache[key] = val
		notifyStatChanged(key, val)
	end

	for _, callback in ipairs(anyStatListeners) do
		task.spawn(callback, currentCache)
	end
end

function Save.Get(): { [string]: any }
	if cachedData then
		return cachedData
	end

	if not isFetching then
		isFetching = true
		local ok, serverStats = pcall(function()
			return Network.Invoke("GetStats")
		end)
		isFetching = false

		if ok and type(serverStats) == "table" then
			applyChangesToCache(serverStats)
			return cachedData :: { [string]: any }
		end
	end

	-- Fallback imediato lendo Attributes replicados no LocalPlayer enquanto aguarda rede
	local fallback: { [string]: any } = {}
	for k, v in pairs(DefaultStats.Template) do
		if not DefaultStats.NetworkingBlacklist[k] then
			local attrVal = LocalPlayer:GetAttribute(k)
			fallback[k] = if attrVal ~= nil then attrVal else v
		end
	end
	return fallback
end

function Save.OnStatChanged(statName: string, callback: (any) -> ())
	statListeners[statName] = statListeners[statName] or {}
	table.insert(statListeners[statName], callback)
end

function Save.OnUpdated(callback: ({ [string]: any }) -> ())
	table.insert(anyStatListeners, callback)
end

-- Escuta atualizações em tempo real enviadas pelo servidor via Library.Network
task.spawn(function()
	Network.Fired("StatsUpdated"):Connect(function(changes: { [string]: any })
		if type(changes) == "table" then
			applyChangesToCache(changes)
		end
	end)
end)

return Save

