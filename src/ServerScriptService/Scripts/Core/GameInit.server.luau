--!strict
--[[
	GameInit.server.luau: Boot do Servidor Velvet Framework
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Library = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

while not Library.Loaded do
	RunService.Heartbeat:Wait()
end

-- Pré-instanciação de Remotes essenciais para evitar delays no cliente
local remotesToRegister = {
	"StatsUpdated",
	"BreakWall",
	"UpdateWallHealth",
	"HitWall",
	"RequestStageSync",
	"TrainRockClick",
	"SwingPickaxe",
	"EggHitFeedback",
	"PlayEggHatch",
	"Start Shutdown",
	"Send Position",
}

for _, remoteName in ipairs(remotesToRegister) do
	Library.Network.Fire(remoteName) -- Cria no servidor se não existir
end

Library.Network.Invoked("GetStats")

-- Suporte retrocompatível ao handshake de intro do PSX
local thingsFolder = workspace:FindFirstChild("Things") or workspace:FindFirstChild("__THINGS")
if not thingsFolder then
	thingsFolder = Instance.new("Folder")
	thingsFolder.Name = "__THINGS"
	thingsFolder.Parent = workspace
end

local thingsRemotes = thingsFolder:FindFirstChild("Remotes") or thingsFolder:FindFirstChild("__REMOTES")
if not thingsRemotes then
	thingsRemotes = Instance.new("Folder")
	thingsRemotes.Name = "__REMOTES"
	thingsRemotes.Parent = thingsFolder
end

local introRemote = thingsRemotes:FindFirstChild("intro") :: RemoteFunction?
if not introRemote then
	introRemote = Instance.new("RemoteFunction")
	introRemote.Name = "intro"
	introRemote.Parent = thingsRemotes
end

introRemote.OnServerInvoke = function(player: Player, confirm: boolean)
	local isLoaded = false
	if Library.Saving and Library.Saving.IsLoaded then
		isLoaded = Library.Saving.IsLoaded(player)
	end

	-- Se estiver testando no Roblox Studio com Mock DataStore, aceita quando o jogador estiver pronto
	if not isLoaded and RunService:IsStudio() then
		isLoaded = true
	end

	print(string.format("[GameInit] Handshake da intro invocado por %s (Save carregado: %s)", player.Name, tostring(isLoaded)))
	return isLoaded, false, nil
end

-- Inicializa todos os serviços do servidor
if Library.Start then
	Library.Start(Library)
end

print("[Drill and Steal an Egg] Servidor Velvet inicializado com sucesso!")
