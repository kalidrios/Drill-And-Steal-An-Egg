--!strict
--[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	Velvet Groups rbx.lua Framework
	-+-+-+- SPECIFICS -+-+-+-
	_L.Network (Abstração Segura de Remotes)
	===========
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local isServer = RunService:IsServer()

local function getEventsFolder(): Folder
	local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
	if not remotesFolder then
		if isServer then
			local newRemotes = Instance.new("Folder")
			newRemotes.Name = "Remotes"
			newRemotes.Parent = ReplicatedStorage
			remotesFolder = newRemotes
		else
			remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
		end
	end

	local eventsFolder = remotesFolder:FindFirstChild("Events")
	if not eventsFolder then
		if isServer then
			local newEvents = Instance.new("Folder")
			newEvents.Name = "Events"
			newEvents.Parent = remotesFolder
			eventsFolder = newEvents
		else
			eventsFolder = remotesFolder:WaitForChild("Events")
		end
	end
	return eventsFolder :: Folder
end

local function getFunctionsFolder(): Folder
	local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
	if not remotesFolder then
		if isServer then
			local newRemotes = Instance.new("Folder")
			newRemotes.Name = "Remotes"
			newRemotes.Parent = ReplicatedStorage
			remotesFolder = newRemotes
		else
			remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
		end
	end

	local functionsFolder = remotesFolder:FindFirstChild("Functions")
	if not functionsFolder then
		if isServer then
			local newFunctions = Instance.new("Folder")
			newFunctions.Name = "Functions"
			newFunctions.Parent = remotesFolder
			functionsFolder = newFunctions
		else
			functionsFolder = remotesFolder:WaitForChild("Functions")
		end
	end
	return functionsFolder :: Folder
end

local Network = {}

local function getRemoteEvent(name: string): RemoteEvent?
	local eventsFolder = getEventsFolder()
	local ev = eventsFolder:FindFirstChild(name)
	if not ev then
		if isServer then
			local newEv = Instance.new("RemoteEvent")
			newEv.Name = name
			newEv.Parent = eventsFolder
			return newEv
		else
			local found = eventsFolder:WaitForChild(name, 30)
			return found and (found :: RemoteEvent) or nil
		end
	end
	return ev :: RemoteEvent
end

local function getRemoteFunction(name: string): RemoteFunction?
	local functionsFolder = getFunctionsFolder()
	local fn = functionsFolder:FindFirstChild(name)
	if not fn then
		if isServer then
			local newFn = Instance.new("RemoteFunction")
			newFn.Name = name
			newFn.Parent = functionsFolder
			return newFn
		else
			local found = functionsFolder:WaitForChild(name, 10)
			return found and (found :: RemoteFunction) or nil
		end
	end
	return fn :: RemoteFunction
end

-- Disparo Unidirecional (Fire)
function Network.Fire(name: string, ...: any)
	local remote = getRemoteEvent(name)
	if not remote then return end

	if isServer then
		local targetPlayer = select(1, ...)
		if typeof(targetPlayer) == "Instance" and targetPlayer:IsA("Player") then
			remote:FireClient(targetPlayer, select(2, ...))
		else
			remote:FireAllClients(...)
		end
	else
		remote:FireServer(...)
	end
end

-- Disparo Unidirecional direto para Cliente específico (Server Only)
function Network.FireClient(player: Player, name: string, ...: any)
	local remote = getRemoteEvent(name)
	if not remote then return end
	if isServer then
		remote:FireClient(player, ...)
	end
end

-- Escuta Unidirecional (Fired)
function Network.Fired(name: string): RBXScriptSignal
	local remote = getRemoteEvent(name)
	assert(remote, "RemoteEvent " .. name .. " não encontrado")
	if isServer then
		return remote.OnServerEvent
	else
		return remote.OnClientEvent
	end
end

-- Chamada Bidirecional (Invoke)
function Network.Invoke(name: string, ...: any): any
	local remote = getRemoteFunction(name)
	assert(remote, "RemoteFunction " .. name .. " não encontrado")
	if isServer then
		local targetPlayer = select(1, ...)
		assert(typeof(targetPlayer) == "Instance" and targetPlayer:IsA("Player"), "TargetPlayer obrigatorio no servidor")
		return remote:InvokeClient(targetPlayer, select(2, ...))
	else
		return remote:InvokeServer(...)
	end
end

-- Resposta Bidirecional (Invoked)
function Network.Invoked(name: string): RemoteFunction?
	return getRemoteFunction(name)
end

return Network
