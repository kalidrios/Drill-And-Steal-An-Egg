--[[
	LeaderboardService: Управление глобальными таблицами лидеров и тегами чата
]]

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService -- lazy
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))

local LeaderboardService = {}

-- Ordered Data Stores
local CashDataStore = DataStoreService:GetOrderedDataStore("Leaderboard_Cash_v1")
local StrengthDataStore = DataStoreService:GetOrderedDataStore("Leaderboard_Strength_v1")
local TimeDataStore = DataStoreService:GetOrderedDataStore("Leaderboard_Time_v1")
-- Физические доски
local LeaderboardsFolder = game.Workspace:FindFirstChild("Map") 
	and game.Workspace.Map:FindFirstChild("Leaderboards")

-- Локальные кэшированные топ-листы для тегов чата
-- cache[statName][userId] = rank
local rankCache = {
	Cash = {},
	Strength = {},
	Time = {}
}

-- Шаблоны элементов доски (будут клонироваться)
local boardTemplates = {}

--- Инициализация шаблонов досок
local function InitTemplates()
	if not LeaderboardsFolder then return end

	local boards = {
		{ name = "Cash Leaderboard", store = CashDataStore, key = "Cash" },
		{ name = "Strength Leaderboard", store = StrengthDataStore, key = "Strength" },
		{ name = "Time Leaderboard", store = TimeDataStore, key = "Time" }
	}

	for _, boardInfo in ipairs(boards) do
		local boardModel = LeaderboardsFolder:FindFirstChild(boardInfo.name)
		local display = boardModel and boardModel:FindFirstChild("Display")
		local surfaceGui = display and display:FindFirstChild("SurfaceGui")
		local frame = surfaceGui and surfaceGui:FindFirstChild("Frame")
		local contents = frame and frame:FindFirstChild("Contents")
		local itemsFrame = contents and contents:FindFirstChild("Items")

		if itemsFrame then
			-- Находим первый попавшийся фрейм игрока для использования как шаблон
			local template = nil
			for _, child in ipairs(itemsFrame:GetChildren()) do
				if child:IsA("Frame") and child.Name ~= "GuideTopBar" then
					template = child:Clone()
					-- Очищаем шаблон
					local values = template:FindFirstChild("Values")
					if values then
						local username = values:FindFirstChild("Username")
						local number = values:FindFirstChild("Number")
						local value = values:FindFirstChild("Value")
						if username then username.Text = "" end
						if number then number.Text = "" end
						if value then value.Text = "" end
					end
					break
				end
			end

			-- Если нашли, сохраняем шаблон и очищаем доску от старых записей
			if template then
				boardTemplates[boardInfo.name] = template
				for _, child in ipairs(itemsFrame:GetChildren()) do
					if child:IsA("Frame") and child.Name ~= "GuideTopBar" then
						child:Destroy()
					end
				end
			end
		end
	end
end

--- Обновление конкретной доски лидеров
local function UpdateBoard(boardName, dataStore, rankCacheKey)
	if not LeaderboardsFolder then return end
	local template = boardTemplates[boardName]
	if not template then return end

	local boardModel = LeaderboardsFolder:FindFirstChild(boardName)
	local display = boardModel and boardModel:FindFirstChild("Display")
	local surfaceGui = display and display:FindFirstChild("SurfaceGui")
	local frame = surfaceGui and surfaceGui:FindFirstChild("Frame")
	local contents = frame and frame:FindFirstChild("Contents")
	local itemsFrame = contents and contents:FindFirstChild("Items")
	if not itemsFrame then return end

	-- Получаем топ 100 записей
	local success, pages = pcall(function()
		return dataStore:GetSortedAsync(false, 100)
	end)

	if not success or not pages then
		warn("[LeaderboardService]: Failed to fetch data for", boardName)
		return
	end

	local chunk = pages:GetCurrentPage()
	
	-- Очищаем старые записи
	for _, child in ipairs(itemsFrame:GetChildren()) do
		if child:IsA("Frame") and child.Name ~= "GuideTopBar" then
			child:Destroy()
		end
	end

	-- Сбрасываем кэш рангов для этого стата
	rankCache[rankCacheKey] = {}

	-- Заполняем новые записи
	for rank, entry in ipairs(chunk) do
		local userId = tonumber(entry.key)
		local value = entry.value

		if userId then
			-- Кэшируем ранг для тегов чата
			rankCache[rankCacheKey][userId] = rank

			-- Получаем имя игрока
			local username = "Player_" .. userId
			pcall(function()
				username = Players:GetNameFromUserIdAsync(userId)
			end)

			-- Клонируем шаблон
			local itemFrame = template:Clone()
			itemFrame.Name = tostring(userId)
			itemFrame.LayoutOrder = rank

			local values = itemFrame:FindFirstChild("Values")
			if values then
				local numberLabel = values:FindFirstChild("Number")
				local usernameLabel = values:FindFirstChild("Username")
				local valueLabel = values:FindFirstChild("Value")

				if numberLabel then numberLabel.Text = "#" .. tostring(rank) end
				if usernameLabel then usernameLabel.Text = username end
				if valueLabel then 
					if rankCacheKey == "Time" then
						valueLabel.Text = Formatting:FormatTime(value)
					else
						valueLabel.Text = Formatting:FormatNumber(value) 
					end
				end
			end

			itemFrame.Parent = itemsFrame
		end
	end

	-- Обновляем атрибуты тегов для всех онлайн игроков
	for _, player in ipairs(Players:GetPlayers()) do
		local userRank = rankCache[rankCacheKey][player.UserId]
		if userRank then
			player:SetAttribute("Rank_" .. rankCacheKey, userRank)
		else
			player:SetAttribute("Rank_" .. rankCacheKey, nil)
		end
	end
end

--- Обновление рангов при входе игрока
function LeaderboardService.OnPlayerAdded(self, player)
	-- Выставляем теги чата из кэша
	for key, cache in pairs(rankCache) do
		local userRank = cache[player.UserId]
		if userRank then
			player:SetAttribute("Rank_" .. key, userRank)
		end
	end
end

--- Записать текущие данные игрока в OrderedDataStore
function LeaderboardService.SubmitPlayerScores(player)
	if not DataService then
		DataService = require(ServerScriptService.Server.Services.DataService)
	end
	local profile = DataService.GetProfile(player)
	if not profile then return end

	local data = profile.Data
	local userId = tostring(player.UserId)

	pcall(function()
		if data.Cash > 0 then
			CashDataStore:SetAsync(userId, math.floor(data.Cash))
		end
		if data.Strength > 0 then
			StrengthDataStore:SetAsync(userId, math.floor(data.Strength))
		end
		if (data.TotalPlaytime or 0) > 0 then
			TimeDataStore:SetAsync(userId, math.floor(data.TotalPlaytime))
		end
	end)
end

function LeaderboardService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)

	-- Инициализация шаблонов
	InitTemplates()

	-- Периодическое обновление
	task.spawn(function()
		while true do
			-- Отправляем результаты всех игроков в OrderedDataStores
			for _, player in ipairs(Players:GetPlayers()) do
				pcall(function()
					LeaderboardService.SubmitPlayerScores(player)
				end)
			end

			-- Обновляем физические доски и кэш
			pcall(function() UpdateBoard("Cash Leaderboard", CashDataStore, "Cash") end)
			pcall(function() UpdateBoard("Strength Leaderboard", StrengthDataStore, "Strength") end)
			pcall(function() UpdateBoard("Time Leaderboard", TimeDataStore, "Time") end)

			task.wait(60) -- Каждые 60 секунд
		end
	end)

	-- Сохранение при выходе
	Players.PlayerRemoving:Connect(function(player)
		pcall(function()
			LeaderboardService.SubmitPlayerScores(player)
		end)
	end)

	print("[LeaderboardService]: Started")
end

return LeaderboardService