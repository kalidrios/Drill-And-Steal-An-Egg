--!strict
--[[
	Libray/Client/StageClientCmds.luau
	Controlador de cliente para visualização, feedback de dano (shake + highlight),
	formatação de números (K, M, B, T...), animação de picareta e quebra local de paredes/estágios.
	Engenharia Reversa baseada em ref_MinePerClick/StageClient.luau.
	Clean Room Engineering: AnimationId de swing deixado como placeholder ("") para preenchimento pelo desenvolvedor.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StagesList = require(ReplicatedStorage:WaitForChild("Directory"):WaitForChild("Stages"):WaitForChild("StagesList"))

local StageClientCmds = {}

local SwingAnimation = Instance.new("Animation")
SwingAnimation.AnimationId = "" -- Placeholder Clean Room (original: rbxassetid://76337371322946)

local localPlayer = Players.LocalPlayer
local brokenWallsState: { [number]: { [number]: boolean } } = {}
local activeTweens: { [BasePart]: Tween } = {}
local originalCFrames: { [BasePart]: CFrame } = {}
local swingTrack: AnimationTrack? = nil

local NUMBER_SUFFIXES = {
	"", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc",
	"Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg",
}

-- Formata números gigantes no padrão de simuladores (1.5K, 25M, 10B...)
function StageClientCmds.FormatNumber(value: number): string
	if type(value) ~= "number" or value ~= value then
		return "0"
	end
	if value < 1000 then
		return tostring(math.floor(value))
	end

	local suffixIndex = math.min(math.floor(math.log(value, 1000)), #NUMBER_SUFFIXES - 1)
	local scaled = value / (1000 ^ suffixIndex)
	local suffix = NUMBER_SUFFIXES[suffixIndex + 1] or ""

	if scaled >= 100 then
		return string.format("%.0f%s", scaled, suffix)
	elseif scaled >= 10 then
		return string.format("%.1f%s", scaled, suffix)
	end
	return string.format("%.2f%s", scaled, suffix)
end

-- Busca a peça da parede no Workspace.Stages["Stage X"].Stages["Y"]
function StageClientCmds.GetWallPart(stageId: number, wallId: number): BasePart?
	local stagesFolder = Workspace:FindFirstChild("Stages")
	if not stagesFolder then return nil end

	local stageFolder = stagesFolder:FindFirstChild(string.format("Stage %d", stageId))
	if not stageFolder then return nil end

	local stagesModel = stageFolder:FindFirstChild("Stages")
	if not stagesModel then return nil end

	local wallPart = stagesModel:FindFirstChild(tostring(wallId))
	if wallPart and wallPart:IsA("BasePart") then
		return wallPart
	end
	return nil
end

-- Retorna o próximo WallId (1, 2 ou 3) ainda não quebrado neste Stage
function StageClientCmds.GetNextWallId(stageId: number): number?
	local stageConfig = StagesList[stageId]
	if not stageConfig then return nil end

	brokenWallsState[stageId] = brokenWallsState[stageId] or {}
	for _, wallData in ipairs(stageConfig.Walls) do
		local wId = wallData.WallId
		if not brokenWallsState[stageId][wId] then
			return wId
		end
	end
	return nil
end

function StageClientCmds.IsWallBroken(stageId: number, wallId: number): boolean
	return (brokenWallsState[stageId] and brokenWallsState[stageId][wallId]) == true
end

-- Equipa automaticamente a picareta da mochila se ainda não estiver na mão
function StageClientCmds.EquipPickaxe(): boolean
	local character = localPlayer.Character
	if not character then return false end

	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return false end

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") and (child:GetAttribute("Pickaxe") or child.Name:lower():find("pickaxe")) then
			return true
		end
	end

	local backpack = localPlayer:FindFirstChild("Backpack")
	if backpack then
		for _, child in ipairs(backpack:GetChildren()) do
			if child:IsA("Tool") and (child:GetAttribute("Pickaxe") or child.Name:lower():find("pickaxe")) then
				humanoid:EquipTool(child)
				return true
			end
		end
	end

	return false
end

-- Toca a animação de minerar com a picareta (Padrão ref_MinePerClick/StageClient)
function StageClientCmds.PlaySwingAnimation()
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	if not character then return end

	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then return end

	local animator = humanoid:FindFirstChildWhichIsA("Animator")
	if not animator then
		local newAnimator = Instance.new("Animator")
		newAnimator.Parent = humanoid
		animator = newAnimator
	end

	if SwingAnimation.AnimationId == "" then
		return
	end

	if not swingTrack then
		swingTrack = (animator :: Animator):LoadAnimation(SwingAnimation)
		swingTrack.Looped = true
		swingTrack.Priority = Enum.AnimationPriority.Action
	end

	if swingTrack.IsPlaying then
		return
	end

	swingTrack:Play()
end

function StageClientCmds.StopSwingAnimation()
	if not swingTrack then
		return
	end
	swingTrack:Stop()
end

-- Oculta ou exibe a parede apenas localmente para este jogador
function StageClientCmds.HideWall(stageId: number, wallId: number, shouldHide: boolean)
	local wallPart = StageClientCmds.GetWallPart(stageId, wallId)
	if not wallPart then return end

	local surfaceGui = wallPart:FindFirstChildWhichIsA("SurfaceGui")
	if surfaceGui then
		surfaceGui.Enabled = not shouldHide
	end

	if shouldHide then
		wallPart.CanCollide = false
		wallPart.Transparency = 1
		for _, child in ipairs(wallPart:GetChildren()) do
			if child:IsA("Texture") or child:IsA("Decal") then
				child.Transparency = 1
			end
		end
	else
		wallPart.CanCollide = true
		wallPart.Transparency = 0
		for _, child in ipairs(wallPart:GetChildren()) do
			if child:IsA("Texture") or child:IsA("Decal") then
				child.Transparency = 0.5
			end
		end
	end
end

-- Atualiza a barra de vida da parede localmente com cores dinâmicas (Verde -> Amarelo -> Vermelho)
function StageClientCmds.UpdateHealth(stageId: number, wallId: number, currentHP: number, maxHP: number)
	local wallPart = StageClientCmds.GetWallPart(stageId, wallId)
	if not wallPart then return end

	local surfaceGui = wallPart:FindFirstChildWhichIsA("SurfaceGui")
	if not surfaceGui then return end

	local progressBar = surfaceGui:FindFirstChild("ProgressBar")
	if not progressBar then return end

	local bar = progressBar:FindFirstChild("Bar") :: Frame?
	local healthLabel = progressBar:FindFirstChild("Health") :: TextLabel?

	local ratio = if maxHP > 0 then math.clamp(currentHP / maxHP, 0, 1) else 0

	if healthLabel and healthLabel:IsA("TextLabel") then
		healthLabel.Text = string.format("%s/%s", StageClientCmds.FormatNumber(currentHP), StageClientCmds.FormatNumber(maxHP))
	end

	if bar and bar:IsA("Frame") then
		local barColor = Color3.fromRGB(85, 255, 0)
		if ratio <= 0.5 then
			barColor = Color3.fromRGB(255, 200, 0)
		end
		if ratio <= 0.2 then
			barColor = Color3.fromRGB(255, 0, 0)
		end

		TweenService:Create(bar, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Size = UDim2.new(ratio, 0, 1, 0),
			BackgroundColor3 = barColor,
		}):Play()
	end
end

-- Efeito de impacto ao bater na parede (Highlight branco + Shake de CFrame + Som de Hit)
function StageClientCmds.PlayHitWallEffect(stageId: number, wallId: number)
	local wallPart = StageClientCmds.GetWallPart(stageId, wallId)
	if not wallPart then return end

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
		OutlineTransparency = 0,
	}):Play()

	task.delay(0.04, function()
		if highlight.Parent then
			local fadeTween = TweenService:Create(highlight, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				FillTransparency = 1,
				OutlineTransparency = 1,
			})
			fadeTween:Play()
			fadeTween.Completed:Once(function()
				highlight:Destroy()
			end)
		end
	end)

	local hitSound = SoundService:FindFirstChild("Hit")
	if hitSound and hitSound:IsA("Sound") then
		local clonedSound = hitSound:Clone()
		clonedSound.Parent = wallPart
		clonedSound:Play()
		task.delay(1, function()
			if clonedSound.Parent then
				clonedSound:Destroy()
			end
		end)
	end

	task.spawn(function()
		for _ = 1, 5 do
			if not wallPart.Parent then return end
			local offsetTween = TweenService:Create(wallPart, TweenInfo.new(0.03, Enum.EasingStyle.Linear), {
				CFrame = originCFrame * CFrame.new(math.random(-100, 100) / 100, math.random(-60, 60) / 100, math.random(-80, 80) / 100),
			})
			activeTweens[wallPart] = offsetTween
			offsetTween:Play()
			offsetTween.Completed:Wait()
		end

		if wallPart.Parent then
			local returnTween = TweenService:Create(wallPart, TweenInfo.new(0.07, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				CFrame = originCFrame,
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

-- Disparado quando a parede quebra (VFX de estilhaços com Trail, FOV punch e som local)
function StageClientCmds.BreakWall(stageId: number, wallId: number, isBroken: boolean, withVFX: boolean)
	brokenWallsState[stageId] = brokenWallsState[stageId] or {}
	brokenWallsState[stageId][wallId] = isBroken

	local wallPart = StageClientCmds.GetWallPart(stageId, wallId)
	if not wallPart then return end

	if isBroken and not withVFX then
		StageClientCmds.HideWall(stageId, wallId, true)
		return
	end

	if isBroken then
		StageClientCmds.HideWall(stageId, wallId, true)

		local camera = Workspace.CurrentCamera
		if camera then
			task.spawn(function()
				TweenService:Create(camera, TweenInfo.new(0.125, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					FieldOfView = 60,
				}):Play()
				task.wait(0.125)
				TweenService:Create(camera, TweenInfo.new(0.125, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					FieldOfView = 70,
				}):Play()
			end)
		end

		for _ = 1, 15 do
			local shard = Instance.new("Part")
			shard.Size = Vector3.new(3, 3, 3)
			shard.CFrame = wallPart.CFrame
			shard.Color = wallPart.Color
			shard.Material = wallPart.Material
			shard.Anchored = false
			shard.CanCollide = false
			shard.Parent = Workspace

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

			for _, child in ipairs(wallPart:GetChildren()) do
				if child:IsA("Texture") then
					local clonedTexture = child:Clone()
					clonedTexture.Transparency = 0.5
					clonedTexture.Parent = shard
				end
			end

			local impulseDir = Vector3.new(math.random(-8, 8), math.random(18, 30), math.random(-8, 8)).Unit
			local mass = shard:GetMass()

			shard:ApplyImpulse(impulseDir * mass * math.random(80, 140))
			shard:ApplyAngularImpulse(Vector3.new(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15)) * mass)
			shard.Position = shard.Position + Vector3.new(0, 2, 0)

			task.delay(2, function()
				if shard.Parent then
					trail.Enabled = false
					TweenService:Create(shard, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = Vector3.new(0, 0, 0),
					}):Play()
					task.wait(0.25)
					shard:Destroy()
				end
			end)
		end

		local breakSound = SoundService:FindFirstChild("Break")
		if breakSound and breakSound:IsA("Sound") then
			breakSound:Play()
		end
	else
		StageClientCmds.HideWall(stageId, wallId, false)
	end
end

-- Inicializa os textos de HP e Luck de todas as paredes de Workspace.Stages
function StageClientCmds.InitAllStageVisuals()
	for stageId, stageConfig in ipairs(StagesList) do
		brokenWallsState[stageId] = brokenWallsState[stageId] or {}
		for _, wallData in ipairs(stageConfig.Walls) do
			local wallId = wallData.WallId
			StageClientCmds.UpdateHealth(stageId, wallId, wallData.MaxHealth, wallData.MaxHealth)

			local wallPart = StageClientCmds.GetWallPart(stageId, wallId)
			if wallPart then
				local surfaceGui = wallPart:FindFirstChildWhichIsA("SurfaceGui")
				local luckFrame = surfaceGui and surfaceGui:FindFirstChild("Luck")
				local luckAmount = luckFrame and luckFrame:FindFirstChild("Amount") :: TextLabel?
				if luckAmount and luckAmount:IsA("TextLabel") then
					luckAmount.Text = string.format("x%d Luck", stageConfig.Luck or 1)
				end
			end
		end
	end
end

return StageClientCmds
