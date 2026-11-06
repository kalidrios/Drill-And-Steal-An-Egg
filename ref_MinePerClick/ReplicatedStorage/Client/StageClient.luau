-- StageClient: Управление шахтами, зонами, HP стен и анимацией разрушения

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = game.Players.LocalPlayer
local Databases = ReplicatedStorage:WaitForChild("Databases")
local StagesList = require(Databases:WaitForChild("StagesList"))

require(Databases:WaitForChild("RaritiesList"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local HitWallRemote = Remotes:WaitForChild("Server"):WaitForChild("HitWall")
local BreakWallRemote = Remotes:WaitForChild("Client"):WaitForChild("BreakWall")
local UpdateWallHealthRemote = Remotes:WaitForChild("Client"):WaitForChild("UpdateWallHealth")
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))
local Zone = require(Utils:WaitForChild("Zone"))
local SwingAnimation = Instance.new("Animation")

SwingAnimation.AnimationId = "rbxassetid://76337371322946"

local StageClient = {
	BrokenWalls = {},
	IsMining = false,
	CurrentStageId = nil,
	CurrentWallId = nil,
	SwingTrack = nil,

	--- Получает инстанс стены для указанной стадии и ID стены
	GetWall = function(self, stageId, wallId)
		local stageData = StagesList[stageId]
		if not stageData then
			return
		end

		local wallData = stageData.Stages and stageData.Stages[wallId]
		if wallData then
			return wallData.Wall
		end
	end
}

--- Ищет следующую неразрушенную стену на стадии
function StageClient.GetNextWall(self, stageId)
	local stageData = StagesList[stageId]
	if not stageData then
		return
	end

	for wallId, _ in pairs(stageData.Stages or {}) do
		StageClient.BrokenWalls[stageId] = StageClient.BrokenWalls[stageId] or {}

		if not StageClient.BrokenWalls[stageId][wallId] then
			return wallId
		end
	end
end

--- Экипирует кирку из рюкзака, если она не экипирована
function StageClient.EquipPickaxe(self)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	if not character then
		return false
	end

	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then
		return false
	end

	local Backpack = LocalPlayer:WaitForChild("Backpack")

	for _, tool in pairs(character:GetChildren()) do
		if tool:IsA("Tool") and tool:GetAttribute("Pickaxe") then
			return true
		end
	end

	for _, tool in pairs(Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool:GetAttribute("Pickaxe") then
			humanoid:EquipTool(tool)
			return true
		end
	end

	return false
end

--- Проигрывает анимацию взмаха киркой
function StageClient.PlaySwingAnimation(self)
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

	if not StageClient.SwingTrack then
		StageClient.SwingTrack = animator:LoadAnimation(SwingAnimation)
		StageClient.SwingTrack.Looped = true
		StageClient.SwingTrack.Priority = Enum.AnimationPriority.Action
	end

	if StageClient.SwingTrack.IsPlaying then
		return
	end

	StageClient.SwingTrack:Play()
end

--- Останавливает анимацию взмаха
function StageClient.StopSwingAnimation(self)
	if not StageClient.SwingTrack then
		return
	end
	StageClient.SwingTrack:Stop()
end

function StageClient.OnCharacterAdded(self)
	StageClient:StopSwingAnimation()
	StageClient.SwingTrack = nil

	if not StageClient.IsMining then
		return
	end

	task.wait(0.25)
	StageClient:EquipPickaxe()
	StageClient:PlaySwingAnimation()
end

--- Скрывает или показывает стену (при разрушении/респавне)
function StageClient.HideWall(self, stageId, wallId, shouldHide)
	local wallPart = StageClient:GetWall(stageId, wallId)
	if not wallPart then
		return
	end

	local surfaceGui = wallPart:FindFirstChildWhichIsA("SurfaceGui")
	if not surfaceGui then
		return
	end

	if shouldHide then
		surfaceGui.Enabled = false
		wallPart.CanCollide = false
		wallPart.Transparency = 1

		for _, child in pairs(wallPart:GetChildren()) do
			if child:IsA("Texture") then
				child.Transparency = 1
			end
		end
	else
		surfaceGui.Enabled = true
		wallPart.CanCollide = true
		wallPart.Transparency = 0

		for _, child in pairs(wallPart:GetChildren()) do
			if child:IsA("Texture") then
				child.Transparency = 0.5
			end
		end
	end
end

--- Обновляет полосу здоровья стены
function StageClient.UpdateHealth(self, stageId, wallId, currentHP, maxHP)
	local wallPart = StageClient:GetWall(stageId, wallId)
	if not wallPart then
		return
	end

	local surfaceGui = wallPart:FindFirstChildWhichIsA("SurfaceGui")
	if not surfaceGui then
		return
	end

	local ProgressBar = surfaceGui:FindFirstChild("ProgressBar")
	if not ProgressBar then
		return
	end

	local Bar = ProgressBar:FindFirstChild("Bar")
	local Health = ProgressBar:FindFirstChild("Health")

	if not (Bar and Health) then
		return
	end

	local ratio = if maxHP > 0 then currentHP / maxHP else 0
	Health.Text = ("%*/%*"):format(Formatting:FormatNumber(currentHP), (Formatting:FormatNumber(maxHP)))

	local barColor = Color3.fromRGB(85, 255, 0)
	if ratio <= 0.5 then
		barColor = Color3.fromRGB(255, 200, 0)
	end
	if ratio <= 0.2 then
		barColor = Color3.fromRGB(255, 0, 0)
	end

	TweenService:Create(Bar, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Size = UDim2.new(ratio, 0, 1, 0),
		BackgroundColor3 = barColor
	}):Play()
end

local activeTweens = {}
local originalCFrames = {}

--- Проигрывает эффект покачивания стены при ударе
function StageClient.HitWall(self, stageId, wallId)
	local wallPart = StageClient:GetWall(stageId, wallId)
	if not wallPart then
		return
	end

	if not originalCFrames[wallPart] then
		originalCFrames[wallPart] = wallPart.CFrame
	end

	local originCFrame = originalCFrames[wallPart]

	if activeTweens[wallPart] then
		activeTweens[wallPart]:Cancel()
		activeTweens[wallPart] = nil
	end

	wallPart.CFrame = originCFrame

	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(255, 255, 255)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 1
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Parent = wallPart

	TweenService:Create(highlight, TweenInfo.new(0.04), {
		FillTransparency = 0.35,
		OutlineTransparency = 0
	}):Play()

	task.delay(0.04, function()
		if highlight.Parent then
			local fadeTween = TweenService:Create(highlight, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				FillTransparency = 1,
				OutlineTransparency = 1
			})
			fadeTween:Play()
			fadeTween.Completed:Once(function()
				highlight:Destroy()
			end)
		end
	end)

	local hitSound = SoundService:FindFirstChild("Hit")
	if hitSound then
		local clonedSound = hitSound:Clone()
		clonedSound.Parent = wallPart
		clonedSound:Play()
		task.delay(1, function()
			if clonedSound.Parent then
				clonedSound:Destroy()
			end
		end)
	end

	-- Тряска CFrame
	task.spawn(function()
		for i = 1, 5 do
			if not wallPart.Parent then
				return
			end

			local offsetTween = TweenService:Create(wallPart, TweenInfo.new(0.03, Enum.EasingStyle.Linear), {
				CFrame = originCFrame * CFrame.new(math.random(-100, 100) / 100, math.random(-60, 60) / 100, math.random(-80, 80) / 100)
			})

			activeTweens[wallPart] = offsetTween
			offsetTween:Play()
			offsetTween.Completed:Wait()
		end

		if wallPart.Parent then
			local returnTween = TweenService:Create(wallPart, TweenInfo.new(0.07, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				CFrame = originCFrame
			})

			activeTweens[wallPart] = returnTween
			returnTween:Play()
			returnTween.Completed:Once(function()
				if wallPart.Parent then
					wallPart.CFrame = originCFrame
				end
				activeTweens[wallPart] = nil
			end)
		end
	end)
end

--- Вызывается при разрушении стены (разлетание осколков)
function StageClient.BreakWall(self, stageId, wallId, isBroken, withVFX)
	if not StagesList[stageId] then
		return
	end

	local wallPart = StageClient:GetWall(stageId, wallId)
	if not wallPart then
		return
	end

	StageClient.BrokenWalls[stageId] = StageClient.BrokenWalls[stageId] or {}
	StageClient.BrokenWalls[stageId][wallId] = isBroken

	if isBroken and (StageClient.CurrentStageId == stageId and StageClient.CurrentWallId == wallId) then
		StageClient.CurrentWallId = StageClient:GetNextWall(stageId)
	end

	if isBroken and not withVFX then
		StageClient:HideWall(stageId, wallId, true)
		return
	end

	if isBroken then
		StageClient:HideWall(stageId, wallId, true)

		-- Эффект FOV
		task.spawn(function()
			TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.125, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				FieldOfView = 60
			}):Play()
			task.wait(0.125)
			TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.125, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				FieldOfView = 70
			}):Play()
		end)

		-- Спавн осколков физических
		for i = 1, 15 do
			local shard = Instance.new("Part")
			shard.Size = Vector3.new(3, 3, 3)
			shard.CFrame = wallPart.CFrame
			shard.Color = wallPart.Color
			shard.Material = wallPart.Material
			shard.Anchored = false
			shard.CanCollide = false
			shard.Parent = workspace

			local att0 = Instance.new("Attachment")
			att0.Parent = shard

			local att1 = Instance.new("Attachment")
			att1.Position = Vector3.new(0, 0, -2)
			att1.Parent = shard

			local trail = Instance.new("Trail")
			trail.Attachment0 = att0
			trail.Attachment1 = att1
			trail.Color = ColorSequence.new(wallPart.Color)
			trail.Lifetime = 0.15
			trail.MinLength = 0.05
			trail.FaceCamera = true
			trail.Parent = shard

			for _, child in pairs(wallPart:GetChildren()) do
				if child:IsA("Texture") then
					local clonedTexture = child:Clone()
					clonedTexture.Transparency = 0.5
					clonedTexture.Parent = shard
				end
			end

			local impulseDirection = Vector3.new(math.random(-8, 8), math.random(18, 30), math.random(-8, 8)).Unit
			local mass = shard:GetMass()

			shard:ApplyImpulse(impulseDirection * mass * math.random(80, 140))
			shard:ApplyAngularImpulse(Vector3.new(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15)) * mass)
			shard.Position = shard.Position + Vector3.new(0, 2, 0)

			task.delay(2, function()
				if shard.Parent then
					trail.Enabled = false
					TweenService:Create(shard, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = Vector3.new(0, 0, 0)
					}):Play()
					task.wait(0.25)
					shard:Destroy()
				end
			end)
		end

		local breakSound = SoundService:FindFirstChild("Break")
		if breakSound then
			breakSound:Play()
		end
	else
		StageClient:HideWall(stageId, wallId, false)
	end
end

--- Цикл автоматической добычи
function StageClient.StartPunchingLoop(self)
	task.spawn(function()
		while task.wait(0.5) do
			local wallStatus = StageClient.CurrentStageId and StageClient.BrokenWalls[StageClient.CurrentStageId]

			if StageClient.IsMining and (StageClient.CurrentStageId and (StageClient.CurrentWallId and (if wallStatus then not wallStatus[StageClient.CurrentWallId] else wallStatus))) then
				if StageClient:EquipPickaxe() then
					HitWallRemote:FireServer(StageClient.CurrentStageId, StageClient.CurrentWallId)
					StageClient:PlaySwingAnimation()
					continue
				end

				StageClient:StopSwingAnimation()
				continue
			end

			StageClient:StopSwingAnimation()
		end
	end)
end

--- Инициализация хитбоксов зон шахт
function StageClient.SetupStages(self)
	for stageId, stageData in pairs(StagesList) do
		local folder = stageData.Folder

		if folder then
			local hitbox = folder:FindFirstChild("Hitbox")

			if hitbox then
				StageClient.BrokenWalls[stageId] = StageClient.BrokenWalls[stageId] or {}

				local zone = Zone.new(hitbox)

				zone.localPlayerEntered:Connect(function()
					LocalPlayer:SetAttribute("IsInMine", true)
					StageClient.IsMining = true
					StageClient.CurrentStageId = stageId
					StageClient.CurrentWallId = StageClient:GetNextWall(stageId)
					StageClient:EquipPickaxe()
					StageClient:PlaySwingAnimation()
				end)

				zone.localPlayerExited:Connect(function()
					if StageClient.CurrentStageId ~= stageId then
						return
					end

					StageClient.IsMining = false
					StageClient.CurrentStageId = nil
					StageClient.CurrentWallId = nil
					StageClient:StopSwingAnimation()
				end)

				for wallId, wallData in pairs(stageData.Stages) do
					StageClient:UpdateHealth(stageId, wallId, wallData.MaxHealth, wallData.MaxHealth)

					local wallPart = StageClient:GetWall(stageId, wallId)
					if wallPart then
						local surfaceGui = wallPart:FindFirstChildWhichIsA("SurfaceGui")
						if surfaceGui then
							surfaceGui:WaitForChild("Luck"):WaitForChild("Amount").Text = ("x%* Luck"):format(stageData.Luck or 1)
						end
					end
				end
			end
		end
	end
end

function StageClient.Listen(self)
	UpdateWallHealthRemote.OnClientEvent:Connect(function(stageId, wallId, currentHP, maxHP)
		StageClient:UpdateHealth(stageId, wallId, currentHP, maxHP)

		if not (currentHP < maxHP) then
			return
		end

		StageClient:HitWall(stageId, wallId)
	end)

	BreakWallRemote.OnClientEvent:Connect(function(stageId, wallId, isBroken, withVFX)
		StageClient:BreakWall(stageId, wallId, isBroken, withVFX)
	end)
end

function StageClient.Start(self)
	StageClient:Listen()
	StageClient:SetupStages()
	StageClient:StartPunchingLoop()
end

return StageClient