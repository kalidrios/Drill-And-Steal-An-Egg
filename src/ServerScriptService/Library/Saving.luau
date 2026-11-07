--!strict
--[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	Velvet Groups rbx.lua Framework
	-+-+-+- SPECIFICS -+-+-+-
	ServerScriptService.Library.Saving
	Encapsulamento seguro do ProfileStore + Replicação em tempo real (Speed, Strength, Money)
	===========
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local ProfileStoreModule = require(ServerScriptService:WaitForChild("Packages"):WaitForChild("ProfileStore"):WaitForChild("ProfileStore"))
local DefaultStats = require(ReplicatedStorage:WaitForChild("Directory"):WaitForChild("Saving"):WaitForChild("DefaultStats"))

local Saving = {}

local activeProfiles: { [Player]: any } = {}
local loadedProfiles: { [Player]: boolean } = {}
local lastReplicatedSnapshot: { [Player]: { [string]: any } } = {}
local Library: any = nil

-- Inicialização do ProfileStore
local PlayerProfileStore = ProfileStoreModule.New(DefaultStats.StatsVersion, DefaultStats.Template)

local function deepClone(tbl: any): any
	if type(tbl) ~= "table" then
		return tbl
	end
	local copy = {}
	for k, v in pairs(tbl) do
		copy[k] = deepClone(v)
	end
	return copy
end

local function applySpeedToCharacter(player: Player, speedValue: number)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health > 0 then
		humanoid.WalkSpeed = math.max(16, speedValue)
	end
end

local function buildPublicPayload(data: { [string]: any }): { [string]: any }
	local payload: { [string]: any } = {}
	for key, val in pairs(data) do
		if not DefaultStats.NetworkingBlacklist[key] then
			payload[key] = deepClone(val)
		end
	end
	return payload
end

-- Sincroniza atributos do Player, WalkSpeed e dispara atualização de rede para o cliente
function Saving.SyncPlayerStats(player: Player, forceFullSync: boolean?)
	local profile = activeProfiles[player]
	if not profile or not profile.Data then
		return
	end

	local data = profile.Data

	-- Mantém Money e Cash sempre espelhados caso algum sistema altere um dos dois
	local lastSnap = lastReplicatedSnapshot[player]
	if lastSnap then
		if data.Money ~= lastSnap.Money then
			data.Cash = data.Money
		elseif data.Cash ~= lastSnap.Cash then
			data.Money = data.Cash
		end
	else
		if (data.Money == nil or data.Money == 0) and (type(data.Cash) == "number" and data.Cash > 0) then
			data.Money = data.Cash
		else
			data.Cash = data.Money or 0
		end
	end

	local speed = tonumber(data.Speed) or DefaultStats.Template.Speed
	local strength = tonumber(data.Strength) or DefaultStats.Template.Strength
	local money = tonumber(data.Money) or DefaultStats.Template.Money

	data.Speed = speed
	data.Strength = strength
	data.Money = money
	data.Cash = money

	local changedFields: { [string]: any } = {}
	local hasChanges = forceFullSync == true or lastSnap == nil

	if not lastSnap then
		lastSnap = {}
		lastReplicatedSnapshot[player] = lastSnap
	end

	for key, val in pairs(data) do
		if not DefaultStats.NetworkingBlacklist[key] then
			if type(val) ~= "table" then
				if lastSnap[key] ~= val or forceFullSync then
					lastSnap[key] = val
					changedFields[key] = val
					hasChanges = true
				end
			else
				-- Clona tabelas como InventoryPets, EggInventory e EquippedPets para sincronizar
				if forceFullSync or key == "InventoryPets" or key == "EggInventory" or key == "EquippedPets" then
					changedFields[key] = deepClone(val)
					hasChanges = true
				end
			end
		end
	end

	if not hasChanges then
		return
	end

	-- 1. Atualiza Attributes no Player para leitura imediata na HUD
	player:SetAttribute("Speed", speed)
	player:SetAttribute("Strength", strength)
	player:SetAttribute("Money", money)
	player:SetAttribute("Cash", money)

	-- 2. Aplica WalkSpeed atualizado ao personagem
	applySpeedToCharacter(player, speed)

	-- 3. Dispara evento de rede da Library para atualizar o cache do cliente (Library.Save)
	if Library and Library.Network then
		local payload = if forceFullSync then buildPublicPayload(data) else changedFields
		Library.Network.FireClient(player, "StatsUpdated", payload)
	end
end

function Saving.Get(player: Player): DefaultStats.PlayerDataTemplate?
	local profile = activeProfiles[player]
	if profile then
		return profile.Data
	end
	return nil
end

function Saving.GetProfile(player: Player): any?
	return activeProfiles[player]
end

function Saving.IsLoaded(player: Player): boolean
	return loadedProfiles[player] == true and activeProfiles[player] ~= nil
end

-- Define um valor diretamente na Data do jogador e sincroniza com a UI
function Saving.Set(player: Player, statName: string, value: any): boolean
	local data: any = Saving.Get(player)
	if not data then
		return false
	end

	data[statName] = value
	if statName == "Money" then
		data.Cash = value
	elseif statName == "Cash" then
		data.Money = value
	end

	Saving.SyncPlayerStats(player, false)
	return true
end

-- Adiciona um valor numérico (positivo ou negativo) a uma stat (Speed, Strength, Money) e sincroniza
function Saving.Add(player: Player, statName: string, delta: number): number?
	local data: any = Saving.Get(player)
	if not data then
		return nil
	end

	local current = tonumber(data[statName]) or 0
	local updated = math.max(0, current + delta)
	data[statName] = updated

	if statName == "Money" then
		data.Cash = updated
	elseif statName == "Cash" then
		data.Money = updated
	end

	Saving.SyncPlayerStats(player, false)
	return updated
end

function Saving.PlayerAdded(player: Player)
	if loadedProfiles[player] or activeProfiles[player] then
		return
	end

	local profileKey = "Player_" .. tostring(player.UserId)
	local ok, profile = pcall(function()
		return PlayerProfileStore:StartSessionAsync(profileKey, {
			Cancel = function()
				return player.Parent ~= Players
			end,
		})
	end)

	-- Fallback seguro em Studio caso API Services estejam desativados temporariamente
	if (not ok or profile == nil) and RunService:IsStudio() then
		warn("[Saving] Usando perfil Mock em memória no Studio para " .. player.Name)
		profile = {
			Data = deepClone(DefaultStats.Template),
			AddUserId = function() end,
			Reconcile = function() end,
			EndSession = function() end,
		}
	end

	if profile ~= nil then
		pcall(function()
			profile:AddUserId(player.UserId)
			profile:Reconcile()
		end)

		-- Garante que todas as chaves novas existam no perfil reconciliado
		for k, v in pairs(DefaultStats.Template) do
			if profile.Data[k] == nil then
				profile.Data[k] = deepClone(v)
			end
		end

		if profile.OnSessionEnded then
			profile.OnSessionEnded:Connect(function()
				activeProfiles[player] = nil
				loadedProfiles[player] = nil
				lastReplicatedSnapshot[player] = nil
				player:Kick("Sua sessão foi encerrada em outro servidor. Por favor, reconecte-se.")
			end)
		elseif profile.OnSessionEnd then
			profile.OnSessionEnd:Connect(function()
				activeProfiles[player] = nil
				loadedProfiles[player] = nil
				lastReplicatedSnapshot[player] = nil
				player:Kick("Sua sessão foi encerrada em outro servidor. Por favor, reconecte-se.")
			end)
		end

		if player.Parent == Players then
			activeProfiles[player] = profile
			loadedProfiles[player] = true
			player:SetAttribute("__LOADED", true)

			Saving.SyncPlayerStats(player, true)

			player.CharacterAdded:Connect(function()
				task.wait(0.1)
				local currentData = Saving.Get(player)
				if currentData then
					applySpeedToCharacter(player, currentData.Speed)
				end
			end)

			print(string.format(
				"[Saving] Perfil carregado para %s | Speed: %d | Strength: %d | Money: %d",
				player.Name,
				profile.Data.Speed,
				profile.Data.Strength,
				profile.Data.Money
			))
		else
			pcall(function()
				profile:EndSession()
			end)
		end
	else
		player:Kick("Não foi possível carregar seus dados de jogo com segurança. Por favor, reconecte-se.")
	end
end

function Saving.PlayerRemoving(player: Player)
	local profile = activeProfiles[player]
	if profile ~= nil then
		pcall(function()
			profile:EndSession()
		end)
		activeProfiles[player] = nil
		loadedProfiles[player] = nil
		lastReplicatedSnapshot[player] = nil
		print(string.format("[Saving] Sessão encerrada com sucesso para %s (%d)", player.Name, player.UserId))
	end
end

function Saving.Start(frameworkLibrary: any?)
	if frameworkLibrary then
		Library = frameworkLibrary
	end

	-- Registra RPC para o cliente consultar os dados iniciais via Library.Network.Invoke("GetStats")
	if Library and Library.Network then
		Library.Network.Invoked("GetStats").OnServerInvoke = function(player: Player)
			-- Aguarda até 10s caso o cliente peça os dados enquanto o perfil ainda está abrindo sessão
			local startWait = os.clock()
			while not Saving.IsLoaded(player) and player.Parent == Players and (os.clock() - startWait) < 10 do
				task.wait(0.1)
			end
			local data = Saving.Get(player)
			if data then
				return buildPublicPayload(data)
			end
			return nil
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(Saving.PlayerAdded, player)
	end

	Players.PlayerAdded:Connect(Saving.PlayerAdded)
	Players.PlayerRemoving:Connect(Saving.PlayerRemoving)

	-- Loop leve (Padrão ref_PSX Saving) para detectar mutações diretas em profile.Data e replicar para a UI
	task.spawn(function()
		while true do
			task.wait(0.2)
			for _, player in ipairs(Players:GetPlayers()) do
				if loadedProfiles[player] then
					Saving.SyncPlayerStats(player, false)
				end
			end
		end
	end)
end

return Saving
