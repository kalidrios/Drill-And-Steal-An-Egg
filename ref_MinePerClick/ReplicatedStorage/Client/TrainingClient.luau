-- TrainingClient: Управление тренировочными зонами и автокликером в них

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer
local Client = ReplicatedStorage:WaitForChild("Client")
local DataClient = require(Client:WaitForChild("DataClient"))
local Databases = ReplicatedStorage:WaitForChild("Databases")
local TrainingList = require(Databases:WaitForChild("TrainingList"))
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Zone = require(Utils:WaitForChild("Zone"))
local Trove = require(Utils:WaitForChild("Trove"))
local ModelTweener = require(Utils:WaitForChild("ModelTweener"))
local ClickRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Click")
local Data = DataClient:GetReplica().Data
local SwingAnimation = Instance.new("Animation")

SwingAnimation.AnimationId = "rbxassetid://76337371322946"

local TrainingClient = {
	CurrentAreaId = nil,
	SwingTrack = nil,
	TrainingTrove = Trove.new(),

	--- Экипирует кирку из рюкзака, если она не экипирована
	EquipPickaxe = function(self)
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		if not character then
			return
		end

		local humanoid = character:FindFirstChildWhichIsA("Humanoid")
		if not humanoid then
			return
		end

		local Backpack = LocalPlayer:WaitForChild("Backpack")

		for _, tool in pairs(character:GetChildren()) do
			if tool:IsA("Tool") and tool:GetAttribute("Pickaxe") then
				return
			end
		end

		for _, tool in pairs(Backpack:GetChildren()) do
			if tool:IsA("Tool") and tool:GetAttribute("Pickaxe") then
				humanoid:EquipTool(tool)
				return
			end
		end
	end
}

--- Запускает анимацию взмаха
function TrainingClient.PlaySwingAnimation(self)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	if not character then
		return
	end

	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then
		return
	end

	local animator = humanoid:FindFirstChildWhichIsA("Animator")
	if not animator then
		local newAnimator = Instance.new("Animator")
		newAnimator.Parent = humanoid
		animator = newAnimator
	end

	if not TrainingClient.SwingTrack then
		TrainingClient.SwingTrack = animator:LoadAnimation(SwingAnimation)
		TrainingClient.SwingTrack.Looped = true
		TrainingClient.SwingTrack.Priority = Enum.AnimationPriority.Action
	end

	if TrainingClient.SwingTrack.IsPlaying then
		return
	end

	TrainingClient.SwingTrack:Play()
end

--- Останавливает анимацию взмаха
function TrainingClient.StopSwingAnimation(self)
	if not TrainingClient.SwingTrack then
		return
	end
	TrainingClient.SwingTrack:Stop()
end

--- Эффект удара по камню (звук, вспышка, уменьшение размера камня)
function TrainingClient.HitRock(self, rockModel)
	if not rockModel then
		return
	end

	local trainingRock = rockModel:FindFirstChild("TrainingRock")
	local marker = rockModel:FindFirstChild("Marker")

	if not trainingRock then
		return
	end

	local hitSound = SoundService:FindFirstChild("Training Hit")
	if hitSound and marker then
		local clonedSound = hitSound:Clone()
		clonedSound.Parent = marker
		clonedSound:Play()
		task.delay(1, function()
			clonedSound:Destroy()
		end)
	end

	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(255, 255, 255)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 1
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Parent = trainingRock

	TweenService:Create(highlight, TweenInfo.new(0.05), {
		FillTransparency = 0.35,
		OutlineTransparency = 0
	}):Play()

	task.delay(0.05, function()
		local fadeTween = TweenService:Create(highlight, TweenInfo.new(0.12), {
			FillTransparency = 1,
			OutlineTransparency = 1
		})
		fadeTween:Play()
		fadeTween.Completed:Once(function()
			highlight:Destroy()
		end)
	end)

	local originalScale = trainingRock:GetScale()
	task.spawn(function()
		ModelTweener.TweenScale(trainingRock, originalScale, originalScale * 0.67, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
		task.wait(0.1)
		ModelTweener.TweenScale(trainingRock, originalScale * 0.67, originalScale, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	end)
end

--- Начинает тренировку (цикл кликов)
function TrainingClient.StartTraining(self, areaId, rockModel)
	if TrainingClient.CurrentAreaId ~= areaId then
		TrainingClient:StopTraining()
		TrainingClient.CurrentAreaId = areaId
		LocalPlayer:SetAttribute("IsTraining", true)
		TrainingClient:EquipPickaxe()
		TrainingClient:PlaySwingAnimation()

		TrainingClient.TrainingTrove:Add(task.spawn(function()
			while TrainingClient.CurrentAreaId == areaId do
				ClickRemote:FireServer(areaId)
				TrainingClient:HitRock(rockModel)
				task.wait(0.5)
			end
		end))
	end
end

--- Прекращает тренировку
function TrainingClient.StopTraining(self)
	TrainingClient.CurrentAreaId = nil
	TrainingClient.TrainingTrove:Clean()
	LocalPlayer:SetAttribute("IsTraining", nil)
	TrainingClient:StopSwingAnimation()
end

--- Инициализирует зоны тренировок
function TrainingClient.SetupAreas(self)
	for areaId, areaData in pairs(TrainingList) do
		local folder = areaData.Folder

		if folder then
			local hitbox = folder:FindFirstChild("Hitbox")

			if hitbox then
				local zone = Zone.new(hitbox)

				zone.localPlayerEntered:Connect(function()
					if areaData.GamepassId and not Data.Purchases[areaId] then
						game:GetService("MarketplaceService"):PromptGamePassPurchase(LocalPlayer, areaData.GamepassId)
						return
					end

					if not (Data.Rebirths < areaData.MinimumRebirths) then
						TrainingClient:StartTraining(areaId, areaData.Folder)
					end
				end)

				zone.localPlayerExited:Connect(function()
					TrainingClient:StopTraining()
				end)
			end
		end
	end
end

function TrainingClient.OnCharacterAdded(self)
	TrainingClient:StopSwingAnimation()
	TrainingClient.SwingTrack = nil

	if not TrainingClient.CurrentAreaId then
		return
	end

	task.wait(0.25)
	TrainingClient:EquipPickaxe()
	TrainingClient:PlaySwingAnimation()
end

--- Инициализирует зоны счастливчиков (LuckyOre)
function TrainingClient.SetupLuckyOre(self)
	local function OreAdded(oreInstance)
		local hitbox = oreInstance:WaitForChild("Hitbox", 5)

		if hitbox then
			local zone = Zone.new(hitbox)
			TrainingClient.LuckyOreZone = zone

			zone.localPlayerEntered:Connect(function()
				TrainingClient:StartTraining("Lucky Ore", oreInstance)
			end)

			zone.localPlayerExited:Connect(function()
				if TrainingClient.CurrentAreaId ~= "Lucky Ore" then
					return
				end
				TrainingClient:StopTraining()
			end)
		end
	end

	local function OreRemoved()
		if TrainingClient.LuckyOreZone then
			TrainingClient.LuckyOreZone:destroy()
			TrainingClient.LuckyOreZone = nil
		end

		if TrainingClient.CurrentAreaId ~= "Lucky Ore" then
			return
		end

		TrainingClient:StopTraining()
	end

	for _, oreInstance in pairs(CollectionService:GetTagged("LuckyOre")) do
		task.spawn(OreAdded, oreInstance)
	end

	CollectionService:GetInstanceAddedSignal("LuckyOre"):Connect(OreAdded)
	CollectionService:GetInstanceRemovedSignal("LuckyOre"):Connect(OreRemoved)
end

function TrainingClient.Start(self)
	TrainingClient:SetupAreas()
	TrainingClient:SetupLuckyOre()
end

return TrainingClient
