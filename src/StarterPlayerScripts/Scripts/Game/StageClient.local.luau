--!strict
--[[
	StageClient.local.luau: Loop de Mineração de Stages por Hitbox (Padrão ref_MinePerClick)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Library = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

while not Library.Loaded do
	RunService.Heartbeat:Wait()
end

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

local isMining: boolean = false
local currentStageId: number? = nil
local currentWallId: number? = nil

-- Ordem exata de todas as cavernas do topo para a profundidade
local CAVE_ORDER = {
	[1] = "EarthCavern",
	[2] = "StoneCave",
	[3] = "RockCave",
	[4] = "EmeraldCave",
	[5] = "LavaCave",
	[6] = "Cave of Blood Crystals",
	[7] = "QuartzCave",
	[8] = "VoidCave",
}

local CAVE_INDEX_MAP = {
	["EarthCavern"] = 1,
	["StoneCave"] = 2,
	["RockCave"] = 3,
	["EmeraldCave"] = 4,
	["LavaCave"] = 5,
	["Cave of Blood Crystals"] = 6,
	["QuartzCave"] = 7,
	["VoidCave"] = 8,
}

local function getStageCmds(): any
	if Library.StageClientCmds then
		return Library.StageClientCmds
	end
	local clientFolder = (ReplicatedStorage:FindFirstChild("Library") or ReplicatedStorage:FindFirstChild("Libray"))
	local clientSub = clientFolder and clientFolder:FindFirstChild("Client")
	local mod = clientSub and clientSub:FindFirstChild("StageClientCmds")
	if mod and mod:IsA("ModuleScript") then
		return require(mod)
	end
	return nil
end

local function isPointInsidePart(point: Vector3, part: BasePart, paddingStuds: number?): boolean
	local pad = paddingStuds or 2
	local localPos = part.CFrame:PointToObjectSpace(point)
	local halfSize = (part.Size * 0.5) + Vector3.new(pad, pad + 3, pad)
	return math.abs(localPos.X) <= halfSize.X
		and math.abs(localPos.Y) <= halfSize.Y
		and math.abs(localPos.Z) <= halfSize.Z
end

-- Retorna a pasta Cave (Workspace.Map.Cave)
local function getCaveFolder(): Instance?
	local map = Workspace:FindFirstChild("Map")
	if map and map:FindFirstChild("Cave") then
		return map.Cave
	end
	return Workspace:FindFirstChild("Cave")
end

-- Detecta se o jogador está dentro do Hitbox de qualquer uma das cavernas
local function detectPlayerStageFromHitboxes(): number?
	local character = localPlayer.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not hrp then return nil end

	local caveFolder = getCaveFolder()
	if not caveFolder then return nil end

	local playerPos = hrp.Position

	for stageIndex, caveName in ipairs(CAVE_ORDER) do
		local caveModel = caveFolder:FindFirstChild(caveName)
			or caveFolder:FindFirstChild("Cave" .. stageIndex)
		if caveModel then
			local hitbox = caveModel:FindFirstChild("Hitbox") :: BasePart?
			if hitbox and hitbox:IsA("BasePart") then
				if isPointInsidePart(playerPos, hitbox, 3.0) then
					return stageIndex
				end
			end
		end
	end

	return nil
end

task.spawn(function()
	local map = Workspace:WaitForChild("Map", 10)
	local caveFolder = (map and map:WaitForChild("Cave", 10)) or Workspace:WaitForChild("Stages", 5)
	if not caveFolder then return end

	local stageCmds = getStageCmds()
	if stageCmds and stageCmds.InitAllStageVisuals then
		stageCmds.InitAllStageVisuals()
	end
end)

task.spawn(function()
	while true do
		task.wait(0.1)
		local stageCmds = getStageCmds()
		if not stageCmds then continue end

		local detectedStageId = detectPlayerStageFromHitboxes()

		if detectedStageId ~= nil then
			local nextWall = stageCmds.GetNextWallId(detectedStageId)

			if not isMining or currentStageId ~= detectedStageId then
				isMining = true
				currentStageId = detectedStageId
				currentWallId = nextWall
				localPlayer:SetAttribute("IsInMine", true)

				if currentWallId then
					stageCmds.EquipPickaxe()
					stageCmds.PlaySwingAnimation()
				else
					stageCmds.StopSwingAnimation()
				end
			else
				currentWallId = nextWall
				if not currentWallId then
					stageCmds.StopSwingAnimation()
				end
			end
		else
			if isMining then
				isMining = false
				currentStageId = nil
				currentWallId = nil
				localPlayer:SetAttribute("IsInMine", false)
				stageCmds.StopSwingAnimation()
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(0.45)
		local stageCmds = getStageCmds()
		if not stageCmds then continue end

		if isMining and currentStageId and currentWallId then
			if not stageCmds.IsWallBroken(currentStageId, currentWallId) then
				if stageCmds.EquipPickaxe() then
					stageCmds.PlaySwingAnimation()
					Library.Network.Fire("HitWall", currentStageId, currentWallId)
					continue
				end
			else
				currentWallId = stageCmds.GetNextWallId(currentStageId)
			end
		end

		if not isMining or not currentWallId then
			stageCmds.StopSwingAnimation()
		end
	end
end)

localPlayer.CharacterAdded:Connect(function()
	local stageCmds = getStageCmds()
	if stageCmds then
		stageCmds.StopSwingAnimation()
	end
	task.wait(0.35)
	if isMining and stageCmds then
		stageCmds.EquipPickaxe()
		stageCmds.PlaySwingAnimation()
	end
end)

local function ResolveStageAndWall(instance: Instance?): (number?, number?)
	if not instance then return nil, nil end

	local cur: Instance? = instance
	while cur and cur ~= Workspace do
		if cur.Parent and cur.Parent.Name == "Stages" and cur.Parent.Parent then
			local pName = cur.Parent.Parent.Name
			local stageNum = CAVE_INDEX_MAP[pName] or tonumber(pName:match("%d+"))
			local wallNum = tonumber(cur.Name)
			if stageNum and wallNum then
				return stageNum, wallNum
			end
		end
		cur = cur.Parent
	end
	return nil, nil
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local stageCmds = getStageCmds()

		if isMining and currentStageId and currentWallId and stageCmds then
			if stageCmds.EquipPickaxe() then
				stageCmds.PlaySwingAnimation()
				Library.Network.Fire("HitWall", currentStageId, currentWallId)
				return
			end
		end

		local target = mouse.Target
		if not target then return end

		local stageNum, wallNum = ResolveStageAndWall(target)
		if stageNum and wallNum and stageCmds then
			local nextWall = stageCmds.GetNextWallId(stageNum) or wallNum
			if stageCmds.EquipPickaxe() then
				stageCmds.PlaySwingAnimation()
				Library.Network.Fire("HitWall", stageNum, nextWall)
			end
		end
	end
end)

Library.Network.Fired("UpdateWallHealth"):Connect(function(stageId: number, wallId: number, currentHP: number, maxHP: number)
	local stageCmds = getStageCmds()
	if not stageCmds then return end

	stageCmds.UpdateHealth(stageId, wallId, currentHP, maxHP)

	if currentHP < maxHP then
		stageCmds.PlayHitWallEffect(stageId, wallId)
	end
end)

Library.Network.Fired("BreakWall"):Connect(function(stageId: number, wallId: number, isBroken: boolean, withVFX: boolean)
	local stageCmds = getStageCmds()
	if not stageCmds then return end

	stageCmds.BreakWall(stageId, wallId, isBroken, withVFX)

	if isBroken and currentStageId == stageId and currentWallId == wallId then
		currentWallId = stageCmds.GetNextWallId(stageId)
		if not currentWallId then
			stageCmds.StopSwingAnimation()
		end
	end
end)

task.spawn(function()
	task.wait(0.5)
	Library.Network.Fire("RequestStageSync")
end)

print("[Drill and Steal an Egg] StageClient inicializado!")
