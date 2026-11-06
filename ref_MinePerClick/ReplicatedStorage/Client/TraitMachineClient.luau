-- TraitMachineClient: Управление машиной трейтов (помещение лута, таймер, дымовые трубы)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game.Players.LocalPlayer
local DataClient = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("DataClient"))
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local ItemsHelper = require(Helpers:WaitForChild("ItemsHelper"))
local SellingHelper = require(Helpers:WaitForChild("SellingHelper"))

require(Helpers:WaitForChild("LevelsHelper"))
require(Helpers:WaitForChild("IndexHelper"))

local Databases = ReplicatedStorage:WaitForChild("Databases")

require(Databases:WaitForChild("ItemsList"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local TraitMachinePlaceRemote = Remotes:WaitForChild("Server"):WaitForChild("TraitMachinePlace")
local TraitMachineStartRemote = Remotes:WaitForChild("Server"):WaitForChild("TraitMachineStart")
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))
local Replica = DataClient:GetReplica()
local Data = Replica.Data
local machineModel = game.Workspace:WaitForChild("Map"):WaitForChild("Trait Machine"):WaitForChild("Trait Machine")
local smokeStacks = {
	machineModel:FindFirstChild("TraitMachine"):WaitForChild("Smoke Stack 1"),
	machineModel:FindFirstChild("TraitMachine"):WaitForChild("Smoke Stack 2"),
	machineModel:FindFirstChild("TraitMachine"):WaitForChild("Smoke Stack 3")
}

local TraitMachineClient = {
	IsStarted = function(self)
		return (Data.TraitMachine.StartedAt or 0) > 0
	end,

	IsFinished = function(self)
		local startedAt = Data.TraitMachine.StartedAt or 0

		if startedAt <= 0 then
			return false
		end

		return startedAt + (Data.TraitMachine.Duration or 0) <= os.time()
	end
}

function TraitMachineClient.IsRunning(self)
	return TraitMachineClient:IsStarted() and not TraitMachineClient:IsFinished()
end

function TraitMachineClient.GetTimeLeft(self)
	local startedAt = Data.TraitMachine.StartedAt or 0

	if startedAt <= 0 then
		return 0
	end

	return math.max(0, startedAt + (Data.TraitMachine.Duration or 0) - os.time())
end

--- Анимация движения дымовых труб вверх-вниз во время работы машины
function TraitMachineClient.SetupSmokeStacks(self)
	local smokeStackCFrames = {}

	for i, stack in ipairs(smokeStacks) do
		smokeStackCFrames[i] = stack.PrimaryPart.CFrame
	end

	task.spawn(function()
		while true do
			while not TraitMachineClient:IsRunning() do
				for i, stack in ipairs(smokeStacks) do
					stack:PivotTo(smokeStackCFrames[i])
				end

				task.wait(0.5)
			end

			-- Движение вниз
			for i, stack in ipairs(smokeStacks) do
				task.delay((i - 1) * 0.15, function()
					TweenService:Create(stack.PrimaryPart, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						CFrame = smokeStackCFrames[i] + Vector3.new(0, -2, 0)
					}):Play()
				end)
			end

			task.wait(0.35)

			-- Движение вверх
			for i, stack in ipairs(smokeStacks) do
				task.delay((i - 1) * 0.15, function()
					TweenService:Create(stack.PrimaryPart, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						CFrame = smokeStackCFrames[i]
					}):Play()
				end)
			end

			task.wait(0.35)
		end
	end)
end

--- Считает общую стоимость активации на основе предметов в слотах
function TraitMachineClient.GetPrice(self)
	local sum = 0

	for _, slotName in ipairs({ "Slot 1", "Slot 2" }) do
		local slotData = Data.TraitMachine[slotName]

		if slotData then
			sum = sum + SellingHelper:GetTraitMachinePrice(slotData, Data.Rebirths, Data.Purchases.CashMultiplier or 1, Data.TraitIndex or {}, 1)
		end
	end

	return sum
end

--- Обновляет визуальное отображение предмета на слоте
function TraitMachineClient.UpdateSlot(self, slotName, itemData)
	local slotPart = machineModel:FindFirstChild(slotName)

	if not slotPart then
		return
	end

	local marker = slotPart:FindFirstChild("Marker")
	if not marker then
		return
	end

	local prompt = marker:FindFirstChild("ProximityPrompt")
	if not prompt then
		return
	end

	prompt.ActionText = if itemData then "Pickup" else "Place"

	for _, child in ipairs(marker:GetChildren()) do
		if child:IsA("Model") then
			child:Destroy()
		end
	end

	if itemData == nil then
		return
	end

	local itemModel = ItemsHelper:GetItemModel(itemData)
	if itemModel then
		itemModel:AddTag("Float")
		ItemsHelper:PlaceItemModel(marker, itemModel, itemData)
	end
end

--- Обновляет текст и доступность подсказок ProximityPrompt
function TraitMachineClient.UpdatePrompts(self)
	local isStarted = TraitMachineClient:IsStarted()
	local prompt = machineModel:WaitForChild("Marker"):WaitForChild("Prompt"):WaitForChild("ProximityPrompt")

	if isStarted then
		prompt.ObjectText = ""
		prompt.ActionText = "Skip Timer"
	else
		local price = TraitMachineClient:GetPrice()

		prompt.ObjectText = "Start?"
		prompt.ActionText = if price > 0 then "$" .. Formatting:FormatNumber(price) else "Start"
	end

	for _, slotName in ipairs({ "Slot 1", "Slot 2" }) do
		local slotPart = machineModel:FindFirstChild(slotName)

		if slotPart then
			local marker = slotPart:FindFirstChild("Marker")

			if marker then
				local slotPrompt = marker:FindFirstChild("ProximityPrompt")

				if slotPrompt then
					slotPrompt.Enabled = not isStarted
				end
			end
		end
	end
end

--- Настройка триггеров взаимодействия с машиной
function TraitMachineClient.SetupMachine(self)
	local marker = machineModel:WaitForChild("Marker")
	local slot1 = machineModel:WaitForChild("Slot 1")
	local slot2 = machineModel:WaitForChild("Slot 2")
	local mainPrompt = marker:WaitForChild("Prompt"):WaitForChild("ProximityPrompt")
	local prompt1 = slot1:WaitForChild("Marker"):WaitForChild("ProximityPrompt")
	local prompt2 = slot2:WaitForChild("Marker"):WaitForChild("ProximityPrompt")

	mainPrompt.Triggered:Connect(function(player)
		if player ~= LocalPlayer then
			return
		end

		TraitMachineStartRemote:FireServer()
	end)

	prompt1.Triggered:Connect(function(player)
		if player ~= LocalPlayer then
			return
		end

		TraitMachinePlaceRemote:FireServer(1)
	end)

	prompt2.Triggered:Connect(function(player)
		if player ~= LocalPlayer then
			return
		end

		TraitMachinePlaceRemote:FireServer(2)
	end)
end

--- Настройка таймера обратного отсчёта
function TraitMachineClient.SetupTimer(self)
	local timerFrame = machineModel:WaitForChild("Marker"):WaitForChild("Title"):WaitForChild("BillboardGui"):WaitForChild("TimerFrame")
	local amountLabel = timerFrame:WaitForChild("Amount")
	local uiScale = timerFrame:WaitForChild("UIScale")
	local wasStarted = false

	task.spawn(function()
		while true do
			local isStarted = TraitMachineClient:IsStarted()
			local timeLeft = TraitMachineClient:GetTimeLeft()

			if isStarted ~= wasStarted then
				wasStarted = isStarted

				if isStarted then
					timerFrame.Visible = true
					uiScale.Scale = 0
					TweenService:Create(uiScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Scale = 1
					}):Play()
				else
					local returnTween = TweenService:Create(uiScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
						Scale = 0
					})

					returnTween:Play()
					returnTween.Completed:Wait()
					timerFrame.Visible = false
				end
			end

			if isStarted then
				amountLabel.Text = if timeLeft > 0 then timeLeft .. "s" else "Ready!"
			end

			TraitMachineClient:UpdatePrompts()
			task.wait(1)
		end
	end)
end

function TraitMachineClient.Listen(self)
	Replica:ListenToChange({ "TraitMachine", "Slot 1" }, function(newItemData)
		TraitMachineClient:UpdateSlot("Slot 1", newItemData)
		TraitMachineClient:UpdatePrompts()
	end)

	Replica:ListenToChange({ "TraitMachine", "Slot 2" }, function(newItemData)
		TraitMachineClient:UpdateSlot("Slot 2", newItemData)
		TraitMachineClient:UpdatePrompts()
	end)

	Replica:ListenToChange({ "TraitMachine", "StartedAt" }, function()
		TraitMachineClient:UpdatePrompts()
	end)

	Replica:ListenToChange({ "TraitMachine", "Duration" }, function()
		TraitMachineClient:UpdatePrompts()
	end)

	TraitMachineClient:UpdateSlot("Slot 1", Data.TraitMachine["Slot 1"])
	TraitMachineClient:UpdateSlot("Slot 2", Data.TraitMachine["Slot 2"])
	TraitMachineClient:UpdatePrompts()
end

function TraitMachineClient.Start(self)
	TraitMachineClient:Listen()
	TraitMachineClient:SetupMachine()
	TraitMachineClient:SetupTimer()
	TraitMachineClient:SetupSmokeStacks()
end

return TraitMachineClient