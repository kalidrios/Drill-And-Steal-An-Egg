local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local trollGui = script.Parent
local targetFrame = trollGui:WaitForChild("Frame")
local targetLabel = targetFrame:WaitForChild("TextLabel")
local nextButton = trollGui:WaitForChild("next")
local previousButton = trollGui:WaitForChild("previous")
local setTrollTarget = ReplicatedStorage:WaitForChild("Events"):WaitForChild("SetTrollTarget")

local targets = {}
local selectedPlayer = nil
local characterAddedConnection = nil

local function rebuildTargets()
	targets = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			table.insert(targets, player)
		end
	end
	table.sort(targets, function(a, b)
		return a.UserId < b.UserId
	end)
end

local function indexOf(player)
	for index, target in ipairs(targets) do
		if target == player then
			return index
		end
	end
	return nil
end

local function updateTargetLabel(player)
	if not player then
		targetLabel.Text = "No players available"
		return
	end
	targetLabel.Text = player.DisplayName .. string.char(10) .. "@" .. player.Name
end

local function restoreOwnCamera()
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end
	camera.CameraType = Enum.CameraType.Custom
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	camera.CameraSubject = humanoid or character or camera.CameraSubject
end

local function attachCamera(player)
	if characterAddedConnection then
		characterAddedConnection:Disconnect()
		characterAddedConnection = nil
	end
	local camera = Workspace.CurrentCamera
	if not (camera and player) then
		return
	end

	local function applyCharacter(character)
		local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
		if humanoid and trollGui.Enabled and selectedPlayer == player then
			camera.CameraType = Enum.CameraType.Custom
			camera.CameraSubject = humanoid
		end
	end

	if player.Character then
		applyCharacter(player.Character)
	end
	characterAddedConnection = player.CharacterAdded:Connect(applyCharacter)
end

local function selectCurrent()
	updateTargetLabel(selectedPlayer)
	setTrollTarget:FireServer(selectedPlayer)
	if selectedPlayer then
		attachCamera(selectedPlayer)
	else
		if characterAddedConnection then
			characterAddedConnection:Disconnect()
			characterAddedConnection = nil
		end
		restoreOwnCamera()
	end
end

local function step(direction)
	rebuildTargets()
	if #targets == 0 then
		selectedPlayer = nil
		selectCurrent()
		return
	end
	local index = selectedPlayer and indexOf(selectedPlayer)
	if not index then
		index = direction > 0 and 0 or 1
	end
	index = ((index - 1 + direction) % #targets) + 1
	selectedPlayer = targets[index]
	selectCurrent()
end

nextButton.Active = true
previousButton.Active = true
nextButton.Activated:Connect(function()
	step(1)
end)
previousButton.Activated:Connect(function()
	step(-1)
end)

Players.PlayerRemoving:Connect(function(player)
	if player == selectedPlayer and trollGui.Enabled then
		step(1)
	end
end)

trollGui:GetPropertyChangedSignal("Enabled"):Connect(function()
	if trollGui.Enabled then
		rebuildTargets()
		selectedPlayer = targets[1]
		selectCurrent()
	else
		selectedPlayer = nil
		selectCurrent()
	end
end)