--[[
	AdminClient: Клиентская логика для админ-панели.
	Инициализирует интерфейс для администратора, управляет вкладками,
	поиском предметов и отправкой событий на сервер.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local AdminFolder = Remotes:WaitForChild("Admin")
local AdminActionRemote = AdminFolder:WaitForChild("AdminAction")

local ItemsList = require(ReplicatedStorage:WaitForChild("Databases"):WaitForChild("ItemsList"))

local AdminClient = {}

local RarityColors = {
	Common = Color3.fromRGB(60, 60, 60),
	Uncommon = Color3.fromRGB(38, 115, 38),
	Rare = Color3.fromRGB(21, 91, 172),
	Epic = Color3.fromRGB(103, 31, 142),
	Legendary = Color3.fromRGB(209, 98, 0),
	Mythic = Color3.fromRGB(178, 20, 20),
	Secret = Color3.fromRGB(0, 130, 116),
	Godly = Color3.fromRGB(203, 20, 89),
	Divine = Color3.fromRGB(195, 175, 15),
}

-- Порядок редкостей для сортировки в UI
local RARITY_ORDER = {
	Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Legendary = 5,
	Mythic = 6, Secret = 7, Godly = 8, Divine = 9
}

function AdminClient:Start()
	-- Ждем, пока сервер проверит права и выдаст атрибут IsAdmin
	local isAdmin = LocalPlayer:GetAttribute("IsAdmin")
	if not isAdmin then
		LocalPlayer:GetAttributeChangedSignal("IsAdmin"):Wait()
	end

	-- Получаем ScreenGui админ-панели
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")
	local adminPanel = playerGui:WaitForChild("AdminPanel")
	
	local toggleBtn = adminPanel:WaitForChild("ToggleBtn")
	local mainFrame = adminPanel:WaitForChild("MainFrame")
	local header = mainFrame:WaitForChild("Header")
	local closeBtn = header:WaitForChild("CloseBtn")
	local sidebar = mainFrame:WaitForChild("Sidebar")
	local pagesFrame = mainFrame:WaitForChild("Pages")
	local pageLayout = pagesFrame:WaitForChild("UIPageLayout")
	
	-- Страницы
	local statsPage = pagesFrame:WaitForChild("StatsPage")
	local itemsPage = pagesFrame:WaitForChild("ItemsPage")
	local serverPage = pagesFrame:WaitForChild("ServerPage")

	-- Показываем кнопку открытия
	toggleBtn.Visible = true

	-- Анимация для ToggleBtn при наведении
	toggleBtn.MouseEnter:Connect(function()
		TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(0, 162, 255),
			Size = UDim2.new(0, 44, 0, 44)
		}):Play()
	end)
	toggleBtn.MouseLeave:Connect(function()
		TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			Size = UDim2.new(0, 40, 0, 40)
		}):Play()
	end)

	-- Открытие/Закрытие панели
	local function setPanelOpen(isOpen)
		if isOpen then
			mainFrame.Visible = true
			mainFrame.Size = UDim2.new(0, 100, 0, 70)
			mainFrame.BackgroundTransparency = 1
			mainFrame.Position = UDim2.new(0.5, -50, 0.5, -35)

			TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 500, 0, 350),
				Position = UDim2.new(0.5, -250, 0.5, -175),
				BackgroundTransparency = 0.15
			}):Play()
		else
			local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 100, 0, 70),
				Position = UDim2.new(0.5, -50, 0.5, -35),
				BackgroundTransparency = 1
			})
			tween:Play()
			tween.Completed:Connect(function()
				if mainFrame.Size.X.Offset < 150 then
					mainFrame.Visible = false
				end
			end)
		end
	end

	toggleBtn.MouseButton1Click:Connect(function()
		setPanelOpen(not mainFrame.Visible)
	end)

	closeBtn.MouseButton1Click:Connect(function()
		setPanelOpen(false)
	end)

	-- Логика Вкладок (Sidebar)
	local tabButtons = {
		Stats = sidebar:WaitForChild("StatsBtn"),
		Items = sidebar:WaitForChild("ItemsBtn"),
		Server = sidebar:WaitForChild("ServerBtn")
	}

	local function selectTab(tabName)
		for name, btn in pairs(tabButtons) do
			if name == tabName then
				btn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
				btn.BackgroundTransparency = 0
			else
				btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
				btn.BackgroundTransparency = 0.5
			end
		end
		
		local targetPage = pagesFrame:FindFirstChild(tabName .. "Page")
		if targetPage then
			pageLayout:JumpTo(targetPage)
		end
	end

	for name, btn in pairs(tabButtons) do
		btn.MouseButton1Click:Connect(function()
			selectTab(name)
		end)
	end
	
	selectTab("Stats")

	----------------------------------------------------
	-- Вкладка 1: StatsPage
	----------------------------------------------------
	local playerInput = statsPage:WaitForChild("PlayerInput")
	local clearInvBtn = statsPage:WaitForChild("ClearInvBtn")
	local statsScroll = statsPage:WaitForChild("StatsScroll")

	local function getTargetPlayer()
		local text = playerInput.Text
		if text == "" then
			return LocalPlayer.Name
		end
		for _, p in ipairs(Players:GetPlayers()) do
			if string.lower(string.sub(p.Name, 1, string.len(text))) == string.lower(text) then
				return p.Name
			end
		end
		return text
	end

	clearInvBtn.MouseButton1Click:Connect(function()
		local target = getTargetPlayer()
		AdminActionRemote:FireServer("ClearInventory", { PlayerName = target })
	end)

	for _, row in ipairs(statsScroll:GetChildren()) do
		if row:IsA("Frame") then
			local statName = row.Name
			local valInput = row:WaitForChild("ValInput")
			local setBtn = row:WaitForChild("SetBtn")
			local addBtn = row:WaitForChild("AddBtn")

			setBtn.MouseButton1Click:Connect(function()
				local target = getTargetPlayer()
				local val = valInput.Text
				AdminActionRemote:FireServer("SetStat", {
					PlayerName = target,
					StatName = statName,
					Value = val
				})
			end)

			addBtn.MouseButton1Click:Connect(function()
				local target = getTargetPlayer()
				local val = valInput.Text
				AdminActionRemote:FireServer("AddStat", {
					PlayerName = target,
					StatName = statName,
					Value = val
				})
			end)
		end
	end

	----------------------------------------------------
	-- Вкладка 2: ItemsPage
	----------------------------------------------------
	local searchBox = itemsPage:WaitForChild("SearchBox")
	local itemGrid = itemsPage:WaitForChild("ItemGrid")
	local templateCell = itemGrid:WaitForChild("TemplateCell")
	templateCell.Visible = false

	local givePopup = itemsPage:WaitForChild("GivePopup")
	local popupTitle = givePopup:WaitForChild("Title")
	local amountInput = givePopup:WaitForChild("AmountInput")
	local giveSelfBtn = givePopup:WaitForChild("GiveSelfBtn")
	local giveTargetBtn = givePopup:WaitForChild("GiveTargetBtn")
	local cancelPopupBtn = givePopup:WaitForChild("CancelBtn")
	
	local selectedItemId = nil

	-- Наполняем сетку предметов
	local sortedItems = {}
	for id, data in pairs(ItemsList) do
		table.insert(sortedItems, { id = id, data = data })
	end

	table.sort(sortedItems, function(a, b)
		local aRarity = RARITY_ORDER[a.data.Rarity] or 0
		local bRarity = RARITY_ORDER[b.data.Rarity] or 0
		if aRarity ~= bRarity then
			return aRarity < bRarity
		end
		return (a.data.Revenue or 0) < (b.data.Revenue or 0)
	end)

	for _, item in ipairs(sortedItems) do
		local cell = templateCell:Clone()
		cell.Name = item.id
		cell.Visible = true
		cell.Parent = itemGrid

		local nameLabel = cell:WaitForChild("ItemName")
		nameLabel.Text = item.data.Name
		
		local img = cell:WaitForChild("Icon")
		img.Image = item.data.ImageId or ""

		-- Цвет фона по редкости
		local rarity = item.data.Rarity or "Common"
		cell.BackgroundColor3 = RarityColors[rarity] or Color3.fromRGB(60,60,60)
		
		-- Обводка
		local stroke = cell:FindFirstChildWhichIsA("UIStroke")
		if stroke then
			stroke.Color = RarityColors[rarity]
		end

		cell.MouseButton1Click:Connect(function()
			selectedItemId = item.id
			popupTitle.Text = "Give " .. item.data.Name
			amountInput.Text = "1"
			givePopup.Visible = true
		end)
	end

	-- Фильтрация по поиску
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local text = string.lower(searchBox.Text)
		for _, cell in ipairs(itemGrid:GetChildren()) do
			if cell:IsA("TextButton") and cell.Name ~= "TemplateCell" then
				if text == "" or string.find(string.lower(cell.Name), text) then
					cell.Visible = true
				else
					cell.Visible = false
				end
			end
		end
	end)

	-- Кнопки GivePopup
	cancelPopupBtn.MouseButton1Click:Connect(function()
		givePopup.Visible = false
		selectedItemId = nil
	end)

	giveSelfBtn.MouseButton1Click:Connect(function()
		if selectedItemId then
			AdminActionRemote:FireServer("GiveItem", {
				PlayerName = LocalPlayer.Name,
				ItemId = selectedItemId,
				Amount = amountInput.Text
			})
			givePopup.Visible = false
			selectedItemId = nil
		end
	end)

	giveTargetBtn.MouseButton1Click:Connect(function()
		if selectedItemId then
			local target = getTargetPlayer()
			AdminActionRemote:FireServer("GiveItem", {
				PlayerName = target,
				ItemId = selectedItemId,
				Amount = amountInput.Text
			})
			givePopup.Visible = false
			selectedItemId = nil
		end
	end)

	----------------------------------------------------
	-- Вкладка 3: ServerPage
	----------------------------------------------------
	local spawnLootFrame = serverPage:WaitForChild("SpawnLootFrame")
	local clearLootBtn = serverPage:WaitForChild("ClearLootBtn")
	local adminUtilityFrame = serverPage:WaitForChild("AdminUtilityFrame")
	local serverTargetInput = adminUtilityFrame:WaitForChild("ServerTargetInput")
	local kickReasonInput = adminUtilityFrame:WaitForChild("KickReasonInput")
	local kickBtn = adminUtilityFrame:WaitForChild("KickBtn")
	local bringBtn = adminUtilityFrame:WaitForChild("BringBtn")
	local teleportBtn = adminUtilityFrame:WaitForChild("TeleportBtn")

	-- Кнопки спавна лута по редкостям
	for _, btn in ipairs(spawnLootFrame:GetChildren()) do
		if btn:IsA("TextButton") then
			local rarity = btn.Name -- Имя кнопки соответствует редкости
			btn.MouseButton1Click:Connect(function()
				AdminActionRemote:FireServer("SpawnLoot", { Rarity = rarity })
			end)
		end
	end

	clearLootBtn.MouseButton1Click:Connect(function()
		AdminActionRemote:FireServer("ClearLoot")
	end)

	kickBtn.MouseButton1Click:Connect(function()
		local target = serverTargetInput.Text
		local reason = kickReasonInput.Text
		if target ~= "" then
			AdminActionRemote:FireServer("Kick", { TargetPlayerName = target, Reason = reason })
		end
	end)

	bringBtn.MouseButton1Click:Connect(function()
		local target = serverTargetInput.Text
		if target ~= "" then
			AdminActionRemote:FireServer("Bring", { TargetPlayerName = target })
		end
	end)

	teleportBtn.MouseButton1Click:Connect(function()
		local target = serverTargetInput.Text
		if target ~= "" then
			AdminActionRemote:FireServer("TeleportTo", { TargetPlayerName = target })
		end
	end)
end

return AdminClient