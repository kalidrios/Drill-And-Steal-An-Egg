-- TutorialClient: Пошаговый туториал для новичков (5 шагов) с ориентированием по лучам

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game.Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local TutorialCompleteRemote = Remotes:WaitForChild("Analytics"):WaitForChild("TutorialComplete")
local TutorialStepRemote = Remotes:WaitForChild("Analytics"):WaitForChild("TutorialStep")
local GotoSurfaceRemote = Remotes:WaitForChild("Server"):WaitForChild("GotoSurface")
local Databases = ReplicatedStorage:WaitForChild("Databases")
local ItemsList = require(Databases:WaitForChild("ItemsList"))
local Client = ReplicatedStorage:WaitForChild("Client")
local Replica = require(Client:WaitForChild("DataClient")):GetReplica()
local Data = Replica.Data
local Storage = LocalPlayer:WaitForChild("data"):WaitForChild("Storage")
local TopFrame = LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("TopFrame")
local Notifications = TopFrame:WaitForChild("Notifications")
local ProgressFrame = TopFrame:WaitForChild("ProgressFrame")

TopFrame:WaitForChild("TeleportFrame")

local Step1Frame = Notifications:WaitForChild("Step 1")
local Step2Frame = Notifications:WaitForChild("Step 2")
local Step3Frame = Notifications:WaitForChild("Step 3")
local Step4Frame = Notifications:WaitForChild("Step 4")
local Step5Frame = Notifications:WaitForChild("Step 5")
local Map = game.Workspace:WaitForChild("Map")
local TutorialPoint = Map:WaitForChild("Markers"):WaitForChild("TutorialPoint")
local SellMarker = Map:WaitForChild("Shops"):WaitForChild("Selling"):WaitForChild("Model"):WaitForChild("Marker")
local ShopMarker = Map:WaitForChild("Shops"):WaitForChild("Pickaxes"):WaitForChild("Model"):WaitForChild("Marker")
local Stage1 = game.Workspace:WaitForChild("Stages"):WaitForChild("Stage 1")
local currentBeam = nil
local startedSteps = {}
local TutorialClient = {}

local function CanStartStep(stepId)
	if startedSteps[stepId] then
		return false
	end

	startedSteps[stepId] = true
	return true
end

--- Находит лучший спавнпоинт предмета на первой стадии
local function GetBestSpawnpointItem()
	local Spawnpoints = Stage1:WaitForChild("Spawnpoints")
	local bestRevenue = -math.huge
	local bestPart = nil

	for _, spawnpoint in ipairs(Spawnpoints:GetChildren()) do
		local model = spawnpoint:FindFirstChildWhichIsA("Model")

		if model then
			local itemId = spawnpoint:GetAttribute("ItemId_" .. LocalPlayer.Name)

			if itemId then
				local itemConfig = ItemsList[itemId]

				if itemConfig then
					local revenue = itemConfig.Revenue or 0

					if bestRevenue < revenue then
						bestRevenue, bestPart = revenue, model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
					end
				end
			end
		end
	end

	return bestPart
end

--- Создаёт направляющий луч (Beam) от игрока к цели
local function CreateTrail(targetPart)
	if not targetPart then
		return
	end

	if currentBeam then
		currentBeam:Destroy()
	end

	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local rootPart = character.PrimaryPart or character:WaitForChild("HumanoidRootPart")
	local templatePart = script:WaitForChild("Part")
	local clonedBeam = templatePart:WaitForChild("Beam"):Clone()
	local att1 = templatePart:WaitForChild("Attachment1"):Clone()
	local att2 = templatePart:WaitForChild("Attachment2"):Clone()

	att1.Parent = targetPart
	att2.Parent = rootPart
	clonedBeam.Attachment0 = att1
	clonedBeam.Attachment1 = att2
	clonedBeam.Parent = rootPart
	att1.Position = Vector3.new(0, 0, 0)
	att2.Position = Vector3.new(0, 0, 0)
	currentBeam = clonedBeam
end

function TutorialClient.IsTutorialActive(self)
	return not Data.TutorialCompleted
end

function TutorialClient.RemoveTrail(self)
	if not currentBeam then
		return
	end

	currentBeam:Destroy()
	currentBeam = nil
end

function TutorialClient.HideSteps(self)
	Step1Frame.Visible = false
	Step2Frame.Visible = false
	Step3Frame.Visible = false
	Step4Frame.Visible = false
	Step5Frame.Visible = false
end

--- Шаг 1: Нажмите 5 раз киркой
function TutorialClient.StartFirstStep(self)
	if not TutorialClient:IsTutorialActive() then
		return
	end

	local isNew = CanStartStep(1)

	if not isNew then
		TutorialClient:UpdateFirstStep()
		return
	end

	TutorialClient:HideSteps()
	Step1Frame.Visible = true
	TutorialClient:UpdateFirstStep()
end

--- Шаг 2: Идите к шахте Stage 1
function TutorialClient.StartSecondStep(self)
	if not TutorialClient:IsTutorialActive() then
		return
	end

	local isNew = CanStartStep(2)

	if isNew then
		TutorialStepRemote:FireServer(1)
		TutorialClient:HideSteps()
		Step2Frame.Visible = true
		CreateTrail(TutorialPoint)
	end
end

--- Шаг 3: Добудьте предмет
function TutorialClient.StartThirdStep(self)
	if not TutorialClient:IsTutorialActive() then
		return
	end

	local isNew = CanStartStep(3)

	if isNew then
		TutorialStepRemote:FireServer(2)
		TutorialClient:HideSteps()
		Step3Frame.Visible = true
		task.spawn(function()
			while TutorialClient:IsTutorialActive() and Step3Frame.Visible do
				local target = GetBestSpawnpointItem()

				if target then
					CreateTrail(target)
				else
					TutorialClient:RemoveTrail()
				end

				task.wait(1)
			end
		end)
	end
end

--- Шаг 4: Вернитесь на поверхность и продайте добытое
function TutorialClient.StartFourthStep(self)
	if not TutorialClient:IsTutorialActive() then
		return
	end

	local isNew = CanStartStep(4)

	if isNew then
		TutorialStepRemote:FireServer(3)
		TutorialClient:HideSteps()
		TutorialClient:RemoveTrail()
		Step4Frame.Visible = true
		GotoSurfaceRemote:FireServer()
		CreateTrail(SellMarker)
	end
end

--- Шаг 5: Купите новую кирку
function TutorialClient.StartFifthStep(self)
	if not TutorialClient:IsTutorialActive() then
		return
	end

	local isNew = CanStartStep(5)

	if isNew then
		TutorialStepRemote:FireServer(4)
		TutorialClient:HideSteps()
		TutorialClient:RemoveTrail()
		Step5Frame.Visible = true
		CreateTrail(ShopMarker)
	end
end

--- Завершение туториала
function TutorialClient.CompleteTutorial(self)
	TutorialStepRemote:FireServer(5)
	TutorialClient:HideSteps()
	TutorialClient:RemoveTrail()
	LocalPlayer:SetAttribute("InTutorial", false)
	ProgressFrame.Visible = true
	TutorialCompleteRemote:FireServer()
end

--- Обновление счётчика кликов для первого шага
function TutorialClient.UpdateFirstStep(self)
	if not TutorialClient:IsTutorialActive() then
		return
	end

	local clicksNeeded = math.max(5 - Data.Strength, 0)

	Step1Frame:FindFirstChild("Desc").Text = ("Click %* Times (With Pickaxe) \240\159\146\170"):format(clicksNeeded)

	if clicksNeeded <= 0 then
		TutorialClient:StartSecondStep()
	end
end

function TutorialClient.StartTutorial(self)
	LocalPlayer:SetAttribute("InTutorial", true)
	ProgressFrame.Visible = false
	TutorialClient:StartFirstStep()
end

function TutorialClient.Listen(self)
	Replica:ListenToChange({ "Strength" }, function()
		if not TutorialClient:IsTutorialActive() then
			return
		end

		if not Step1Frame.Visible then
			return
		end

		TutorialClient:UpdateFirstStep()
	end)

	Replica:ListenToChange({ "Cash" }, function(newValue, oldValue)
		if not TutorialClient:IsTutorialActive() then
			return
		end

		if not (Step4Frame.Visible and oldValue < newValue) then
			return
		end

		TutorialClient:StartFifthStep()
	end)

	Replica:ListenToArrayInsert({ "Pickaxes" }, function()
		if not TutorialClient:IsTutorialActive() then
			return
		end

		if not Step5Frame.Visible then
			return
		end

		TutorialClient:CompleteTutorial()
	end)

	LocalPlayer:GetAttributeChangedSignal("FirstStageCompleted"):Connect(function()
		if not TutorialClient:IsTutorialActive() then
			return
		end

		if LocalPlayer:GetAttribute("FirstStageCompleted") ~= true then
			return
		end

		TutorialClient:StartThirdStep()
	end)

	Storage:GetPropertyChangedSignal("Value"):Connect(function()
		if not TutorialClient:IsTutorialActive() then
			return
		end

		if not (Storage.Value > 0) then
			return
		end

		TutorialClient:StartFourthStep()
	end)
end

function TutorialClient.Start(self)
	TutorialClient:Listen()

	if Data.TutorialCompleted then
		LocalPlayer:SetAttribute("InTutorial", false)
		TutorialClient:HideSteps()
		TutorialClient:RemoveTrail()
	else
		TutorialClient:StartTutorial()
	end
end

return TutorialClient