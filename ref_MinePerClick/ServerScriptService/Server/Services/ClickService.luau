--[[
	ClickService: Обработка кликов, начисление Strength, дебаунс-защита
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService -- ленивая загрузка
local Databases = ReplicatedStorage:WaitForChild("Databases")
local PickaxeList = require(Databases:WaitForChild("PickaxeList"))
local TrainingList = require(Databases:WaitForChild("TrainingList"))
local AurasList = require(Databases:WaitForChild("AurasList"))
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local LevelsHelper = require(Helpers:WaitForChild("LevelsHelper"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ClickRemote = Remotes:WaitForChild("Server"):WaitForChild("Click")

-- Дебаунс: минимальный интервал между кликами (0.05 сек)
local CLICK_DEBOUNCE = 0.05
local lastClickTime = {}

-- Лимит кликов в секунду для обнаружения автокликеров
local MAX_CLICKS_PER_WINDOW = 25 -- максимум 25 кликов за 5 сек (реальный максимум ~20)
local CLICK_WINDOW = 5 -- окно в секундах
local clickHistory = {} -- clickHistory[player] = {timestamps...}

local ClickService = {}

function ClickService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)

	ClickRemote.OnServerEvent:Connect(function(player, areaId)
		-- Дебаунс проверка
		local now = os.clock()
		local lastTime = lastClickTime[player]
		if lastTime and (now - lastTime) < CLICK_DEBOUNCE then
			return -- слишком быстро, игнор
		end
		lastClickTime[player] = now

		-- Анти-автокликер: проверка количества кликов за окно
		local history = clickHistory[player]
		if not history then
			history = {}
			clickHistory[player] = history
		end
		-- Удаляем старые записи за пределами окна
		while #history > 0 and (now - history[1]) > CLICK_WINDOW do
			table.remove(history, 1)
		end
		table.insert(history, now)
		if #history > MAX_CLICKS_PER_WINDOW then
			-- Превышен лимит — подозрение на автокликер, игнорируем
			return
		end

		-- Профиль
		local profile = DataService.GetProfile(player)
		if not profile then return end

		local data = profile.Data
		local replica = profile.Replica

		-- Получаем силу кирки
		local pickaxeData = PickaxeList[data.EquippedPickaxeId]
		local pickaxeStrength = if pickaxeData then pickaxeData.Strength else 1

		-- Мультипликаторы от ребиртов, донатных покупок и квестов
		local rebirthMultiplier = LevelsHelper:GetStrengthMultiplier(data.Rebirths)
		local purchaseMultiplier = data.Purchases.Multiplier or 1

		-- Множитель ауры
		local auraConfig = AurasList[data.EquippedAuraId]
		local auraMultiplier = if auraConfig then auraConfig.Multiplier else 1

		-- Итоговый прирост
		local strengthGain = math.floor(pickaxeStrength * rebirthMultiplier * purchaseMultiplier * auraMultiplier)

		-- Применяем множитель зоны, если игрок тренируется
		if type(areaId) == "string" then
			local areaData = TrainingList[areaId]
			if areaData then
				local hasRebirths = data.Rebirths >= (areaData.MinimumRebirths or 0)
				local hasPass = not areaData.GamepassId or data.Purchases[areaId] == true
				
				if hasRebirths and hasPass then
					local hitbox = areaData.Folder and areaData.Folder:FindFirstChild("Hitbox")
					local char = player.Character
					local hrp = char and char:FindFirstChild("HumanoidRootPart")
					if hitbox and hrp then
						local dist = (hrp.Position - hitbox.Position).Magnitude
						if dist <= 50 then
							strengthGain = math.floor(strengthGain * (areaData.Multiplier or 1))
						end
					end
				end
			end
		end

		if strengthGain < 1 then strengthGain = 1 end

		-- Применяем
		local newStrength = data.Strength + strengthGain
		replica:SetValue({"Strength"}, newStrength)

		-- Обновляем leaderstat
		DataService.UpdateLeaderstats(player)

		-- Отправляем клиенту для анимации "+N"
		ClickRemote:FireClient(player, strengthGain)
	end)

	-- Cleanup
	game.Players.PlayerRemoving:Connect(function(player)
		lastClickTime[player] = nil
		clickHistory[player] = nil
	end)

	print("[ClickService]: Started")
end

return ClickService