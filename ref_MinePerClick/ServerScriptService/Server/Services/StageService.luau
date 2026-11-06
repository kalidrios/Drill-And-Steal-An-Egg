--[[
	StageService: HP стен, HitWall, BreakWall, респавн + квестовый трекинг WallsBroken
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService -- lazy
local Databases = ReplicatedStorage:WaitForChild("Databases")
local StagesList = require(Databases:WaitForChild("StagesList"))
local PickaxeList = require(Databases:WaitForChild("PickaxeList"))
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local LevelsHelper = require(Helpers:WaitForChild("LevelsHelper"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local HitWallRemote = Remotes:WaitForChild("Server"):WaitForChild("HitWall")
local BreakWallRemote = Remotes:WaitForChild("Client"):WaitForChild("BreakWall")
local UpdateWallHealthRemote = Remotes:WaitForChild("Client"):WaitForChild("UpdateWallHealth")
local ShakeRemote = Remotes:WaitForChild("Client"):WaitForChild("Shake")

-- Состояние HP стен per player
-- wallHealth[player][stageId][wallId] = currentHP
local wallHealth = {}

-- Дебаунс для HitWall (0.3 сек)
local HIT_DEBOUNCE = 0.3
local lastHitTime = {}

-- Максимальная дистанция для удара по стене (studs)
local MAX_HIT_DISTANCE = 60

-- Время восстановления стены (сек)
local WALL_RESPAWN_TIME = 4

local StageService = {}

--- Получить текущее HP стены для игрока
function StageService.GetWallHP(player, stageId, wallId)
	if not wallHealth[player] then return 0 end
	if not wallHealth[player][stageId] then return 0 end
	return wallHealth[player][stageId][wallId] or 0
end

--- Инициализация HP стен для игрока
function StageService.InitPlayerWalls(player)
	wallHealth[player] = {}
	for stageId, stageData in ipairs(StagesList) do
		wallHealth[player][stageId] = {}
		for wallId, wallData in ipairs(stageData.Stages) do
			wallHealth[player][stageId][wallId] = wallData.MaxHealth
		end
	end
end

--- Сброс всех стен для игрока (при GotoSurface)
function StageService.ResetAllWalls(player)
	for stageId, stageData in ipairs(StagesList) do
		if wallHealth[player] and wallHealth[player][stageId] then
			for wallId, wallData in ipairs(stageData.Stages) do
				wallHealth[player][stageId][wallId] = wallData.MaxHealth
				-- Восстанавливаем на клиенте (без VFX)
				BreakWallRemote:FireClient(player, stageId, wallId, false)
				UpdateWallHealthRemote:FireClient(player, stageId, wallId, wallData.MaxHealth, wallData.MaxHealth)
			end
		end
	end
end

--- Пропустить стадию (DevProduct Skip Stage)
function StageService.SkipStage(player, stageId)
	local stageData = StagesList[stageId]
	if not stageData then return end

	-- Разрушаем все стены на этой стадии
	if wallHealth[player] and wallHealth[player][stageId] then
		for wallId, wallData in ipairs(stageData.Stages) do
			wallHealth[player][stageId][wallId] = 0
			BreakWallRemote:FireClient(player, stageId, wallId, true, true)
			UpdateWallHealthRemote:FireClient(player, stageId, wallId, 0, wallData.MaxHealth)
		end
	end

	-- Телепортируем игрока на следующую стадию (stageId + 1), если она существует
	local nextStage = StagesList[stageId + 1]
	if nextStage and nextStage.Folder then
		local spawnpoints = nextStage.Folder:FindFirstChild("Spawnpoints")
		if spawnpoints then
			local spawns = spawnpoints:GetChildren()
			if #spawns > 0 then
				local randomSpawn = spawns[math.random(1, #spawns)]
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					char.HumanoidRootPart.CFrame = randomSpawn.CFrame + Vector3.new(0, 3, 0)
				end
			end
		end
	end
end

function StageService.OnPlayerAdded(self, player)
	StageService.InitPlayerWalls(player)
end

function StageService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)
	
	-- Начальная отправка HP клиенту после загрузки профиля
	HitWallRemote.OnServerEvent:Connect(function(player, stageId, wallId)
		-- Валидация
		if type(stageId) ~= "number" or type(wallId) ~= "number" then return end
		if stageId < 1 or stageId > #StagesList then return end

		local stageData = StagesList[stageId]
		if not stageData or not stageData.Stages[wallId] then return end

		-- Дебаунс
		local now = os.clock()
		local lastTime = lastHitTime[player]
		if lastTime and (now - lastTime) < HIT_DEBOUNCE then return end
		lastHitTime[player] = now

		-- Профиль
		local profile = DataService.GetProfile(player)
		if not profile then return end

		local data = profile.Data

		-- Валидация дистанции: игрок должен быть рядом со стеной
		local wallData = stageData.Stages[wallId]
		local wall = wallData and wallData.Wall
		if wall then
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp and wall then
				local dist = (hrp.Position - wall.Position).Magnitude
				if dist > MAX_HIT_DISTANCE then
					return -- слишком далеко от стены
				end
			end
		end

		-- Сила удара = Strength игрока
		local damage = data.Strength
		if damage <= 0 then damage = 1 end

		-- Текущее HP
		if not wallHealth[player] or not wallHealth[player][stageId] then
			StageService.InitPlayerWalls(player)
		end

		local currentHP = wallHealth[player][stageId][wallId]
		if not currentHP or currentHP <= 0 then return end -- уже сломана

		-- Наносим урон
		local maxHP = stageData.Stages[wallId].MaxHealth
		currentHP = math.max(0, currentHP - damage)
		wallHealth[player][stageId][wallId] = currentHP

		-- Отправляем обновление HP
		UpdateWallHealthRemote:FireClient(player, stageId, wallId, currentHP, maxHP)

		-- Стена разрушена!
		if currentHP <= 0 then
			-- VFX разрушения
			BreakWallRemote:FireClient(player, stageId, wallId, true, true)

			if stageId == 1 then
				player:SetAttribute("FirstStageCompleted", true)
			end

			-- Спавним лут на следующей стадии
			local LootService = require(ServerScriptService.Server.Services.LootService)
			LootService.SpawnLootForPlayer(player, stageId)
		end
	end)

	-- Cleanup
	game.Players.PlayerRemoving:Connect(function(player)
		wallHealth[player] = nil
		lastHitTime[player] = nil
	end)

	print("[StageService]: Started")
end

return StageService
