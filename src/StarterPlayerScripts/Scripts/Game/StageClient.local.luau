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

local function detectPlayerStageFromHitboxes(): number?
	local character = localPlayer.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not hrp then return nil end

	local stagesFolder = Workspace:FindFirstChild("Stages")
	if not stagesFolder then return nil end

	local playerPos = hrp.Position

	for _, stageFolder in ipairs(stagesFolder:GetChildren()) do
		local stageNum = tonumber(stageFolder.Name:match("%d+"))
		if stageNum then
			local hitbox = stageFolder:FindFirstChild("Hitbox") :: BasePart?
			if hitbox and hitbox:IsA("BasePart") then
				if isPointInsidePart(playerPos, hitbox, 2.5) then
					return stageNum
				end
			end
		end
	end

	return nil
end

task.spawn(function()
	local stagesFolder = Workspace:WaitForChild("Stages", 10)
	if not stagesFolder then return end

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
		if cur.Parent and cur.Parent.Name == "Stages" and cur.Parent.Parent and cur.Parent.Parent.Name:find("Stage") then
			local stageNum = tonumber(cur.Parent.Parent.Name:match("%d+"))
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

