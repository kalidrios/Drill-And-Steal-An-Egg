-- Client-side Loot Floating and Spinning Effect
local TweenService = game:GetService("TweenService")
local Stages = workspace:WaitForChild("Stages")

-- Watch all spawnpoints under all stages
local LocalPlayer = game.Players.LocalPlayer
local activeTweens = {}

local function setupFloating(model)
	if not model:IsA("Model") then return end

	-- Проверяем владельца
	local ownerName = model:GetAttribute("Owner")
	if ownerName and ownerName ~= LocalPlayer.Name then
		model:Destroy() -- удаляем чужой лут локально
		return
	end

	local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
	if not primaryPart then return end

	task.wait(0.1) -- wait for placing to finish
	if not model.Parent then return end

	local startPivot = model:GetPivot()
	local val = Instance.new("NumberValue")
	val.Value = 0

	local connection = val.Changed:Connect(function(v)
		if model.Parent then
			model:PivotTo(startPivot * CFrame.new(0, v, 0) * CFrame.Angles(0, os.clock() * 0.4, 0))
		else
			val:Destroy()
		end
	end)

	local tweenInfo = TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local tween = TweenService:Create(val, tweenInfo, { Value = 1.0 })
	tween:Play()

	activeTweens[model] = {
		val = val,
		connection = connection,
		tween = tween
	}
end

local function cleanupFloating(model)
	local data = activeTweens[model]
	if data then
		data.connection:Disconnect()
		data.tween:Cancel()
		data.val:Destroy()
		activeTweens[model] = nil
	end
end

-- Watch all spawnpoints under all stages
for _, stageFolder in ipairs(Stages:GetChildren()) do
	local spawnpoints = stageFolder:WaitForChild("Spawnpoints", 5)
	if spawnpoints then
		for _, spawnPart in ipairs(spawnpoints:GetChildren()) do
			spawnPart.ChildAdded:Connect(setupFloating)
			spawnPart.ChildRemoved:Connect(cleanupFloating)
			for _, child in ipairs(spawnPart:GetChildren()) do
				task.spawn(setupFloating, child)
			end
		end
	end
end

Stages.ChildAdded:Connect(function(stageFolder)
	local spawnpoints = stageFolder:WaitForChild("Spawnpoints", 5)
	if spawnpoints then
		for _, spawnPart in ipairs(spawnpoints:GetChildren()) do
			spawnPart.ChildAdded:Connect(setupFloating)
			spawnPart.ChildRemoved:Connect(cleanupFloating)
		end
	end
end)
