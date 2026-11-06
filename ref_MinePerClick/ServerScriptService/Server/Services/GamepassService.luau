--[[
	GamepassService: Обработка покупок GamePass и DevProducts через MarketplaceService
]]

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService -- lazy
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local Databases = ReplicatedStorage:WaitForChild("Databases")
local PickaxeList = require(Databases:WaitForChild("PickaxeList"))
local ItemsList = require(Databases:WaitForChild("ItemsList"))
local StagesList = require(Databases:WaitForChild("StagesList"))
local HttpService = game:GetService("HttpService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")
local PurchasedProductRemote = Remotes:WaitForChild("Client"):WaitForChild("PurchasedProduct")

local GamepassService = {}

-- Маппинг GamepassId -> действие
local GAMEPASS_HANDLERS = {}

-- Маппинг ProductId -> действие  
local PRODUCT_HANDLERS = {}

--- Инициализация маппингов из Config
local function InitHandlers()
	-- Gamepasses
	if Config.Gamepasses then
		-- Кирки за Robux
		for pickaxeName, gamepassId in pairs(Config.Gamepasses) do
			local actualPickaxeName = pickaxeName
			if pickaxeName == "67 Pickaxe" then
				actualPickaxeName = "Six Seven Pickaxe"
			end
			if PickaxeList[actualPickaxeName] then
				GAMEPASS_HANDLERS[gamepassId] = function(player)
					local PickaxeService = require(ServerScriptService.Server.Services.PickaxeService)
					local profile = DataService.GetProfile(player)
					if not profile then return end
					local data = profile.Data
					local replica = profile.Replica
					if not table.find(data.Pickaxes, actualPickaxeName) then
						replica:ArrayInsert({"Pickaxes"}, actualPickaxeName)
					end
					replica:SetValue({"EquippedPickaxeId"}, actualPickaxeName)
					PickaxeService.GivePickaxeTool(player, actualPickaxeName)
					NotificationRemote:FireClient(player, "Purchased!", "You unlocked " .. actualPickaxeName .. "!")
				end
			end
		end

		-- Тренировочные зоны
		local areaGamepasses = {
			["x10 Amethyst Area"] = "Amethyst",
			["x25 Emerald Area"] = "Emerald",
			["x100 Azurite Area"] = "Azurite",
		}
		for passName, areaId in pairs(areaGamepasses) do
			local gpId = Config.Gamepasses[passName]
			if gpId then
				GAMEPASS_HANDLERS[gpId] = function(player)
					local profile = DataService.GetProfile(player)
					if not profile then return end
					profile.Replica:SetValue({"Purchases", areaId}, true)
					NotificationRemote:FireClient(player, "Purchased!", "You unlocked the " .. areaId .. " training area!")
				end
			end
		end

		-- x2 Cash
		local x2CashId = Config.Gamepasses["x2 Cash"]
		if x2CashId then
			GAMEPASS_HANDLERS[x2CashId] = function(player)
				local profile = DataService.GetProfile(player)
				if not profile then return end
				local data = profile.Data
				local newMultiplier = (data.Purchases.CashMultiplier or 1) * 2
				profile.Replica:SetValue({"Purchases", "CashMultiplier"}, newMultiplier)
				NotificationRemote:FireClient(player, "Purchased!", "You now have x2 Cash multiplier!")
			end
		end

		-- x2 Slots
		local x2SlotsId = Config.Gamepasses["x2 Slots"]
		if x2SlotsId then
			GAMEPASS_HANDLERS[x2SlotsId] = function(player)
				local profile = DataService.GetProfile(player)
				if not profile then return end
				local data = profile.Data
				local newSize = data.BackpackSize * 2
				profile.Replica:SetValue({"BackpackSize"}, newSize)
				NotificationRemote:FireClient(player, "Purchased!", "Your backpack size is now " .. tostring(newSize) .. "!")
			end
		end
	end

	-- DevProducts
	if Config.Products then
		-- Skip Rebirth
		if Config.Products["Skip Rebirth"] then
			PRODUCT_HANDLERS[Config.Products["Skip Rebirth"]] = function(player)
				local RebirthService = require(ServerScriptService.Server.Services.RebirthService)
				RebirthService.ForceRebirth(player)
				NotificationRemote:FireClient(player, "Rebirth!", "You skipped the rebirth requirement!")
			end
		end

		-- Sell Here
		if Config.Products["Sell Here"] then
			PRODUCT_HANDLERS[Config.Products["Sell Here"]] = function(player)
				local SellingService = require(ServerScriptService.Server.Services.SellingService)
				local revenue = SellingService.SellAll(player)
				if revenue > 0 then
					NotificationRemote:FireClient(player, "Sold!", "You earned $" .. tostring(revenue) .. "!")
				end
			end
		end

		-- Upgrades: +1 Slot, +1 Walkspeed
		if Config.Products.Upgrades then
			if Config.Products.Upgrades["+1 Slot"] then
				PRODUCT_HANDLERS[Config.Products.Upgrades["+1 Slot"]] = function(player)
					local UpgradesService = require(ServerScriptService.Server.Services.UpgradesService)
					local profile = DataService.GetProfile(player)
					if not profile then return end
					local data = profile.Data
					profile.Replica:SetValue({"BackpackSize"}, data.BackpackSize + 1)
					NotificationRemote:FireClient(player, "Upgraded!", "Backpack size is now " .. tostring(data.BackpackSize) .. "!")
				end
			end
			if Config.Products.Upgrades["+1 Walkspeed"] then
				PRODUCT_HANDLERS[Config.Products.Upgrades["+1 Walkspeed"]] = function(player)
					local UpgradesService = require(ServerScriptService.Server.Services.UpgradesService)
					local profile = DataService.GetProfile(player)
					if not profile then return end
					local data = profile.Data
					local newSpeed = (data.ExtraWalkSpeed or 0) + 1
					profile.Replica:SetValue({"ExtraWalkSpeed"}, newSpeed)
					UpgradesService.ApplyWalkspeed(player, newSpeed)
					NotificationRemote:FireClient(player, "Upgraded!", "Walkspeed increased!")
				end
			end
		end

		-- Strength multipliers (Double Strength)
		if Config.Products["Double Strength"] then
			for productName, productId in pairs(Config.Products["Double Strength"]) do
				local mult = tonumber(productName:match("(%d+)x"))
				if mult then
					PRODUCT_HANDLERS[productId] = function(player)
						local profile = DataService.GetProfile(player)
						if not profile then return end
						local data = profile.Data
						profile.Replica:SetValue({"Purchases", "Multiplier"}, mult)
						NotificationRemote:FireClient(player, "Purchased!", "You now have " .. productName .. " Strength!")
					end
				end
			end
		end

		-- Strength Packs
		if Config.Products["Strength Packs"] then
			local strengthAmounts = {
				["Strength Pack 1"] = 10000,
				["Strength Pack 2"] = 100000,
				["Strength Pack 3"] = 1000000,
				["Strength Pack 4"] = 10000000,
			}
			for packName, productId in pairs(Config.Products["Strength Packs"]) do
				local amount = strengthAmounts[packName] or 10000
				PRODUCT_HANDLERS[productId] = function(player)
					local profile = DataService.GetProfile(player)
					if not profile then return end
					local data = profile.Data
					profile.Replica:SetValue({"Strength"}, data.Strength + amount)
					DataService.UpdateLeaderstats(player)
					NotificationRemote:FireClient(player, "Purchased!", "You received +" .. tostring(amount) .. " Strength!")
				end
			end
		end

		-- Cash Packs
		if Config.Products["Cash Packs"] then
			local cashAmounts = {
				["Cash Pack 1"] = 50000,
				["Cash Pack 2"] = 250000,
				["Cash Pack 3"] = 1000000,
				["Cash Pack 4"] = 5000000,
			}
			for packName, productId in pairs(Config.Products["Cash Packs"]) do
				local amount = cashAmounts[packName] or 50000
				PRODUCT_HANDLERS[productId] = function(player)
					local profile = DataService.GetProfile(player)
					if not profile then return end
					local data = profile.Data
					profile.Replica:SetValue({"Cash"}, data.Cash + amount)
					DataService.UpdateLeaderstats(player)
					NotificationRemote:FireClient(player, "Purchased!", "You received $" .. tostring(amount) .. "!")
				end
			end
		end

		-- Loot products
		if Config.Products.Loot then
			for itemName, productId in pairs(Config.Products.Loot) do
				PRODUCT_HANDLERS[productId] = function(player)
					local profile = DataService.GetProfile(player)
					if not profile then return end
					local data = profile.Data
					local replica = profile.Replica

					-- Специальные имена: +1 Secret, +1 Godly, +1 Divine -> рандомный артефакт
					local rarity = nil
					if itemName == "+1 Secret" then rarity = "Secret"
					elseif itemName == "+1 Godly" then rarity = "Godly"
					elseif itemName == "+1 Divine" then rarity = "Divine"
					end

					local targetItemId = nil
					if rarity then
						-- Ищем рандомный предмет этой редкости
						local LootService = require(ServerScriptService.Server.Services.LootService)
						targetItemId = LootService.GetRandomItem(rarity)
					else
						-- Ищем предмет по имени
						for id, itemData in pairs(ItemsList) do
							if itemData.Name == itemName then
								targetItemId = id
								break
							end
						end
					end

					if targetItemId then
						local uniqueId = HttpService:GenerateGUID(false)
						local inventoryItem = {
							ItemId = targetItemId,
							InTraitMachine = false,
							IsFavorited = false,
							InBackpack = false,
						}
						replica:SetValue({"Inventory", uniqueId}, inventoryItem)
						if not table.find(data.InventoryIndex, targetItemId) then
							replica:ArrayInsert({"InventoryIndex"}, targetItemId)
						end
						NotificationRemote:FireClient(player, "Purchased!", "You received " .. (itemName or targetItemId) .. "!")
					end
				end
			end
		end

		-- Spawn Mythic / Spawn Secret
		if Config.Products["Spawn Mythic"] then
			PRODUCT_HANDLERS[Config.Products["Spawn Mythic"]] = function(player)
				local LootService = require(ServerScriptService.Server.Services.LootService)
				local profile = DataService.GetProfile(player)
				if not profile then return end
				local data = profile.Data
				local replica = profile.Replica
				local itemId = LootService.GetRandomItem("Mythic")
				if itemId then
					local uniqueId = HttpService:GenerateGUID(false)
					replica:SetValue({"Inventory", uniqueId}, {
						ItemId = itemId,
						InTraitMachine = false,
						IsFavorited = false,
						InBackpack = false,
					})
					if not table.find(data.InventoryIndex, itemId) then
						replica:ArrayInsert({"InventoryIndex"}, itemId)
					end
					NotificationRemote:FireClient(player, "Mythic!", "You received a Mythic item!")
				end
			end
		end

		if Config.Products["Spawn Secret"] then
			PRODUCT_HANDLERS[Config.Products["Spawn Secret"]] = function(player)
				local LootService = require(ServerScriptService.Server.Services.LootService)
				local profile = DataService.GetProfile(player)
				if not profile then return end
				local data = profile.Data
				local replica = profile.Replica
				local itemId = LootService.GetRandomItem("Secret")
				if itemId then
					local uniqueId = HttpService:GenerateGUID(false)
					replica:SetValue({"Inventory", uniqueId}, {
						ItemId = itemId,
						InTraitMachine = false,
						IsFavorited = false,
						InBackpack = false,
					})
					if not table.find(data.InventoryIndex, itemId) then
						replica:ArrayInsert({"InventoryIndex"}, itemId)
					end
					NotificationRemote:FireClient(player, "Secret!", "You received a Secret item!")
				end
			end
		end

		-- Skip Timer
		if Config.Products["Skip Timer?"] then
			PRODUCT_HANDLERS[Config.Products["Skip Timer?"]] = function(player)
				local profile = DataService.GetProfile(player)
				if not profile then return end
				local data = profile.Data
				local replica = profile.Replica
				if (data.TraitMachine.StartedAt or 0) > 0 then
					replica:SetValue({"TraitMachine", "StartedAt"}, os.time() - (data.TraitMachine.Duration or 0) - 1)
					NotificationRemote:FireClient(player, "Skipped!", "Trait Machine timer has been skipped!")
				end
			end
		end

		-- Starter Pack
		if Config.Products["Starter Pack"] then
			PRODUCT_HANDLERS[Config.Products["Starter Pack"]] = function(player)
				local profile = DataService.GetProfile(player)
				if not profile then return end
				local data = profile.Data
				local replica = profile.Replica
				replica:SetValue({"Cash"}, data.Cash + 50000)
				replica:SetValue({"Strength"}, data.Strength + 50000)
				replica:SetValue({"BackpackSize"}, data.BackpackSize + 3)
				DataService.UpdateLeaderstats(player)
				NotificationRemote:FireClient(player, "Starter Pack!", "You received 50K Cash, 50K Strength, +3 Slots!")
			end
		end
	end

	-- Skip Stage ProductIds from StagesList
	for stageId, stageData in ipairs(StagesList) do
		local productId = stageData.ProductId
		if productId and productId > 0 then
			PRODUCT_HANDLERS[productId] = function(player)
				local StageService = require(ServerScriptService.Server.Services.StageService)
				StageService.SkipStage(player, stageId)
				NotificationRemote:FireClient(player, "Skipped!", "You skipped Stage " .. tostring(stageId) .. "!")
			end
		end
	end

	-- Pickaxes ProductIds dynamically
	for pickaxeName, pickaxeData in pairs(PickaxeList) do
		local productId = pickaxeData.ProductId
		if productId and productId > 0 then
			PRODUCT_HANDLERS[productId] = function(player)
				local profile = DataService.GetProfile(player)
				if not profile then return end
				local data = profile.Data
				local replica = profile.Replica
				
				if not table.find(data.Pickaxes, pickaxeName) then
					replica:ArrayInsert({"Pickaxes"}, pickaxeName)
				end
				replica:SetValue({"EquippedPickaxeId"}, pickaxeName)
				
				local PickaxeService = require(ServerScriptService.Server.Services.PickaxeService)
				PickaxeService.GivePickaxeTool(player, pickaxeName)
				DataService.UpdateLeaderstats(player)
				NotificationRemote:FireClient(player, "Purchased!", "You bought " .. pickaxeName .. "!")
			end
		end
	end
end

function GamepassService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)
	InitHandlers()

	-- Обработка покупки GamePass
	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
		if not wasPurchased then return end

		local handler = GAMEPASS_HANDLERS[gamePassId]
		if handler then
			local success, err = pcall(handler, player)
			if not success then
				warn("[GamepassService]: Error processing gamepass", gamePassId, err)
			end
		end

		PurchasedProductRemote:FireClient(player, "GamePass", gamePassId)
	end)

	-- Обработка покупки DevProduct
	MarketplaceService.ProcessReceipt = function(receiptInfo)
		local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
		if not player then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end

		-- Ждём загрузку профиля
		local profile = DataService.GetProfile(player)
		if not profile then
			-- Ждём до 10 секунд
			for _ = 1, 20 do
				task.wait(0.5)
				profile = DataService.GetProfile(player)
				if profile then break end
			end
		end

		if not profile then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end

		local handler = PRODUCT_HANDLERS[receiptInfo.ProductId]
		if handler then
			local success, err = pcall(handler, player)
			if not success then
				warn("[GamepassService]: Error processing product", receiptInfo.ProductId, err)
				return Enum.ProductPurchaseDecision.NotProcessedYet
			end
		end

		PurchasedProductRemote:FireClient(player, "DevProduct", receiptInfo.ProductId)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	-- Проверяем уже купленные геймпасы при входе (восстановление)
	Players.PlayerAdded:Connect(function(player)
		task.defer(function()
			for gamepassId, handler in pairs(GAMEPASS_HANDLERS) do
				local ownsPass = false
				pcall(function()
					ownsPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassId)
				end)
				if ownsPass then
					pcall(handler, player)
				end
			end
		end)
	end)

	-- Для уже загруженных игроков
	for _, player in ipairs(Players:GetPlayers()) do
		task.defer(function()
			for gamepassId, handler in pairs(GAMEPASS_HANDLERS) do
				local ownsPass = false
				pcall(function()
					ownsPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassId)
				end)
				if ownsPass then
					pcall(handler, player)
				end
			end
		end)
	end

	print("[GamepassService]: Started")
end

return GamepassService
