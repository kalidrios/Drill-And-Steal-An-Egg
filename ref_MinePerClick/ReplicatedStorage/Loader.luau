-- Loader: Точка входа для автозагрузки и инициализации сервисов/модулей (Server и Client)

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Loader = {
	Server = {},
	Client = {}
}

--- Собирает и требует все ModuleScripts из папок
function Loader.GatherModules(self)
	if RunService:IsServer() and next(Loader.Server) == nil then
		local Server = ServerScriptService:WaitForChild("Server")
		local Services = Server:WaitForChild("Services")
		local Modules = Server:WaitForChild("Modules")

		for _, moduleInstance in ipairs(Services:GetChildren()) do
			if moduleInstance:IsA("ModuleScript") then
				local required = require(moduleInstance)
				required.Loaded = false
				required.PlayerAddedLoaded = false
				required.CharacterAddedLoaded = false
				Loader.Server[moduleInstance.Name] = required
			end
		end

		for _, moduleInstance in ipairs(Modules:GetChildren()) do
			if moduleInstance:IsA("ModuleScript") then
				local required = require(moduleInstance)
				required.Loaded = false
				required.PlayerAddedLoaded = false
				required.CharacterAddedLoaded = false
				Loader.Server[moduleInstance.Name] = required
			end
		end
	end

	if not RunService:IsClient() or next(Loader.Client) ~= nil then
		return
	end

	local Client = ReplicatedStorage:WaitForChild("Client")

	for _, moduleInstance in ipairs(Client:GetChildren()) do
		if moduleInstance:IsA("ModuleScript") then
			local required = require(moduleInstance)
			required.Loaded = false
			required.CharacterAddedLoaded = false
			Loader.Client[moduleInstance.Name] = required
		end
	end
end

--- Запускает все собранные модули и связывает их с событиями игроков/персонажей
function Loader.StartModules(self)
	if RunService:IsServer() then
		local DataService = Loader.Server.DataService

		-- Сначала стартуем DataService (важно для загрузки данных)
		if DataService and (type(DataService.Start) == "function" and not DataService.Loaded) then
			DataService:Start()
			DataService.Loaded = true
		end

		for _, requiredModule in pairs(Loader.Server) do
			-- Обработчик OnPlayerAdded
			if type(requiredModule.OnPlayerAdded) == "function" and not requiredModule.PlayerAddedLoaded then
				requiredModule.PlayerAddedLoaded = true

				for _, player in ipairs(Players:GetPlayers()) do
					task.spawn(requiredModule.OnPlayerAdded, requiredModule, player)
				end

				Players.PlayerAdded:Connect(function(player)
					requiredModule:OnPlayerAdded(player)
				end)
			end

			-- Обработчик OnCharacterAdded
			if type(requiredModule.OnCharacterAdded) == "function" and not requiredModule.CharacterAddedLoaded then
				requiredModule.CharacterAddedLoaded = true

				for _, player in ipairs(Players:GetPlayers()) do
					if player.Character then
						task.spawn(requiredModule.OnCharacterAdded, requiredModule, player, player.Character)
					end

					player.CharacterAdded:Connect(function(character)
						requiredModule:OnCharacterAdded(player, character)
					end)
				end

				Players.PlayerAdded:Connect(function(player)
					player.CharacterAdded:Connect(function(character)
						requiredModule:OnCharacterAdded(player, character)
					end)
				end)
			end

			-- Обычный метод Start
			if type(requiredModule.Start) == "function" and not requiredModule.Loaded then
				requiredModule:Start()
				requiredModule.Loaded = true
			end
		end
	end

	if not RunService:IsClient() then
		return
	end

	local LocalPlayer = Players.LocalPlayer

	for _, requiredModule in pairs(Loader.Client) do
		-- Клиентский обработчик OnCharacterAdded
		if type(requiredModule.OnCharacterAdded) == "function" and not requiredModule.CharacterAddedLoaded then
			requiredModule.CharacterAddedLoaded = true

			if LocalPlayer.Character then
				task.spawn(requiredModule.OnCharacterAdded, requiredModule, LocalPlayer.Character)
			end

			LocalPlayer.CharacterAdded:Connect(function(character)
				requiredModule:OnCharacterAdded(character)
			end)
		end

		-- Клиентский метод Start
		if type(requiredModule.Start) == "function" and not requiredModule.Loaded then
			requiredModule:Start()
			requiredModule.Loaded = true
		end
	end
end

return Loader