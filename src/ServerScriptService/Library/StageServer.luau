--!strict
--[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	Velvet Groups rbx.lua Framework
	-+-+-+- SPECIFICS -+-+-+-
	ServerScriptService.Library.StageServer
	Controle autoritativo e isolamento de HP de paredes por jogador
	Baseado em ref_MinePerClick/StageService
	===========
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local StagesList = require(ReplicatedStorage:WaitForChild("Directory"):WaitForChild("Stages"):WaitForChild("StagesList"))

local StageServer = {}

-- Estado de HP por jogador: playerWallHealth[player][stageId][wallId] = currentHP
local playerWallHealth: { [Player]: { [number]: { [number]: number } } } = {}

-- Controle de debounce anti-spam por jogador
local lastHitTimestamps: { [Player]: number } = {}
local HIT_COOLDOWN_SECONDS: number = 0.25
local MAX_HIT_DISTANCE_STUDS: number = 65

local Library: any = nil

function StageServer.InitPlayerStages(player: Player)
	playerWallHealth[player] = {}
	for stageId, stageConfig in ipairs(StagesList) do
		playerWallHealth[player][stageId] = {}
		for _, wallData in ipairs(stageConfig.Walls) do
			playerWallHealth[player][stageId][wallData.WallId] = wallData.MaxHealth
		end
	end
end

function StageServer.GetWallHP(player: Player, stageId: number, wallId: number): number
	if not playerWallHealth[player] or not playerWallHealth[player][stageId] then
		return 0
	end
	return playerWallHealth[player][stageId][wallId] or 0
end

function StageServer.HitWall(player: Player, stageId: number, wallId: number)
	-- 1. Validações de tipo e range
	if type(stageId) ~= "number" or type(wallId) ~= "number" then return end
	if stageId < 1 or stageId > #StagesList then return end

	local stageConfig = StagesList[stageId]
	if not stageConfig then return end

	local targetWallConfig = nil
	for _, wallData in ipairs(stageConfig.Walls) do
		if wallData.WallId == wallId then
			targetWallConfig = wallData
			break
		end
	end
	if not targetWallConfig then return end

	-- 2. Anti-spam / Cooldown
	local now = os.clock()
	local lastHit = lastHitTimestamps[player] or 0
	if (now - lastHit) < HIT_COOLDOWN_SECONDS then return end
	lastHitTimestamps[player] = now

	-- 3. Validação de distância física até a parede no Workspace (Workspace.Map.Cave)
	local caveFolder = (Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Cave"))
		or Workspace:FindFirstChild("Cave")
		or Workspace:FindFirstChild("Stages")

	local stageFolder = caveFolder and (
		caveFolder:FindFirstChild(string.format("Cave%d", stageId))
		or caveFolder:FindFirstChild(string.format("Stage %d", stageId))
		or caveFolder:FindFirstChild(tostring(stageId))
	)
	local wallsContainer = stageFolder and stageFolder:FindFirstChild("Stages")
	local wallPart = wallsContainer and wallsContainer:FindFirstChild(tostring(wallId)) :: BasePart?

	local character = player.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if wallPart and humanoidRootPart then
		local distance = (humanoidRootPart.Position - wallPart.Position).Magnitude
		if distance > MAX_HIT_DISTANCE_STUDS then
			return
		end
	end

	-- 4. Cálculo de dano baseado na Força e Picareta do jogador
	local savingModule = Library and Library.Saving
	local playerData = savingModule and savingModule.Get(player)
	local playerStrength = (playerData and playerData.Strength) or 1
	
	local equippedPickaxe = (playerData and playerData.EquippedPickaxe) or "Wood Pickaxe"
	local pickaxeDamage = 1
	local pickaxeDir = Library.Directory and Library.Directory.Pickaxes
	if pickaxeDir and pickaxeDir[equippedPickaxe] then
		pickaxeDamage = pickaxeDir[equippedPickaxe].Damage or 1
	end

	local damage = math.max(1, playerStrength + pickaxeDamage)

	-- 5. Aplicação do dano no estado individual do jogador
	if not playerWallHealth[player] or not playerWallHealth[player][stageId] then
		StageServer.InitPlayerStages(player)
	end

	local currentHP = playerWallHealth[player][stageId][wallId]
	if not currentHP or currentHP <= 0 then
		return -- Parede já destruída para este jogador
	end

	local maxHealth = targetWallConfig.MaxHealth
	currentHP = math.max(0, currentHP - damage)
	playerWallHealth[player][stageId][wallId] = currentHP

	print(string.format("[StageServer.HitWall] Recebido golpe de %s no Stage %d, Parede %d (Dano: %d, HP atual: %s)", player.Name, stageId, wallId, damage, tostring(currentHP)))

	-- 6. Notifica o cliente do jogador para atualizar a barra de vida local
	Library.Network.FireClient(player, "UpdateWallHealth", stageId, wallId, currentHP, maxHealth)

	-- 7. Se o HP zerar, dispara a quebra local apenas para esse jogador
	if currentHP <= 0 then
		print(string.format("[StageServer.HitWall] Parede %d do Stage %d DESTRUÍDA por %s!", wallId, stageId, player.Name))
		Library.Network.FireClient(player, "BreakWall", stageId, wallId, true, true)
	end
end

function StageServer.ResetPlayerStages(player: Player)
	StageServer.InitPlayerStages(player)
	for stageId, stageConfig in ipairs(StagesList) do
		for _, wallData in ipairs(stageConfig.Walls) do
			Library.Network.FireClient(player, "BreakWall", stageId, wallData.WallId, false, false)
			Library.Network.FireClient(player, "UpdateWallHealth", stageId, wallData.WallId, wallData.MaxHealth, wallData.MaxHealth)
		end
	end
end

function StageServer.OnPlayerAdded(player: Player)
	StageServer.InitPlayerStages(player)
end

function StageServer.OnPlayerRemoving(player: Player)
	playerWallHealth[player] = nil
	lastHitTimestamps[player] = nil
end

function StageServer.Start(lib: any)
	Library = lib

	Players.PlayerAdded:Connect(StageServer.OnPlayerAdded)
	Players.PlayerRemoving:Connect(StageServer.OnPlayerRemoving)

	for _, player in ipairs(Players:GetPlayers()) do
		StageServer.InitPlayerStages(player)
	end

	-- Escuta o evento de ataque à parede vindo do cliente
	Library.Network.Fired("HitWall"):Connect(function(player: Player, stageId: number, wallId: number)
		StageServer.HitWall(player, stageId, wallId)
	end)

	-- Permite que o cliente solicite a sincronização inicial das paredes ao carregar
	Library.Network.Fired("RequestStageSync"):Connect(function(player: Player)
		local stagesData = playerWallHealth[player]
		if not stagesData then
			StageServer.InitPlayerStages(player)
			stagesData = playerWallHealth[player]
		end

		for stageId, walls in pairs(stagesData) do
			local stageConfig = StagesList[stageId]
			if stageConfig then
				for _, wallData in ipairs(stageConfig.Walls) do
					local hp = walls[wallData.WallId] or wallData.MaxHealth
					local isBroken = (hp <= 0)
					if isBroken then
						Library.Network.FireClient(player, "BreakWall", stageId, wallData.WallId, true, false)
					end
					Library.Network.FireClient(player, "UpdateWallHealth", stageId, wallData.WallId, hp, wallData.MaxHealth)
				end
			end
		end
	end)

	print("[StageServer] Serviço de paredes locais Velvet inicializado com sucesso!")
end

return StageServer
