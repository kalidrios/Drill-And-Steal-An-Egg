--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

local rng = Random.new()
local SpinnyWheel = _L.Things.SpinnyWheel
local spinner = SpinnyWheel:FindFirstChild("Main")
local originalCFrame = spinner.CFrame
local isSpinning = false
local canSpin = false
local SpinnyWheelGUI = _L.GUI.SpinnyWheel
local camera = game.Workspace.CurrentCamera

function Math(int: number): number
	return int / 8 - 0.0625 + (math.random() - 0.5) * 1 / 8
end

function Animate(int: number)
	spinner.CFrame = originalCFrame * CFrame.Angles(-int * math.pi * 2, 0, 0)
end

local guis = {}
function disableGUI()
	for _, gui in ipairs(_L.LocalPlayer.PlayerGui:GetChildren()) do
		if gui.Enabled then
			table.insert(guis, gui.Name)
		end
		gui.Enabled = false
	end 
end

function enableGUI()
	for _, gui in ipairs(_L.LocalPlayer.PlayerGui:GetChildren()) do
		if table.find(guis, gui.Name) then
			gui.Enabled = true
		end
	end 
end

function setCamera(start: boolean)
	if start then
		disableGUI()
		_L.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
		camera.CameraSubject = _L.Things.SpinWheelCamera
		camera.CFrame = _L.Things.SpinWheelCameraCFramePos.CFrame
		task.wait(0.1)
		camera.CameraType = Enum.CameraType.Fixed
	elseif not start then
		task.wait(0.5)
		enableGUI()
		_L.LocalPlayer.CameraMode = Enum.CameraMode.Classic
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = _L.LocalPlayer.Character.Humanoid
	end
end

function Spin(int: number)
	warn(int)
	setCamera(true)
	SpinnyWheelGUI.Gui.Enabled = false
	local mathint = Math(int) - 0.2666666666666675
	local n, m = 0, 0
	_L.Audio.Play(12227403373, script, 1, 0.6)
	while n < 5.333333333333334 do
		n = math.min(n + _L.RunService.Heartbeat:Wait(), 5.333333333333334)
	    local _m = mathint + (1.6 * n - 0.15 * n ^ 2)
		if math.floor(m % 1 * 8) ~= math.floor(_m % 1 * 8) then
			_L.Audio.Play(11309481090, script, 1, 0.85)
		end
		m = _m
		Animate(_m)
	end
	_L.Audio.Play(5368504446, script, 1, 0.75)
	isSpinning = false
	setCamera(false)
end

function Update()
	local rewards = _L.Network.Invoke("Get Spin Rewards", game.JobId)
	warn(rewards)
	for k, v in pairs(rewards) do
		local img = spinner.ScreenGui:FindFirstChild(k)
		if img then
			local rewardType = v.RewardType
			if rewardType then
				if rewardType == "Pets" then
					img.Image = _L.Directory.Pets[v.Reward].thumbnail
				elseif rewardType == "Currency" then
					img.Image = _L.Directory.Currency[v.Currency].ImageOutline
				end
				img:WaitForChild("Percent").Text = v.Chance
				if v.Hide then
					img.ImageColor3 = Color3.new(0,0,0)
					img:WaitForChild("Unknown").Visible = true
				else
					img.ImageColor3 = Color3.new(255,255,255)
					img:WaitForChild("Unknown").Visible = false
				end
			end
		end
	end
end

_L.Network.Fired("Spin Wheel"):Connect(function(int: number)
	isSpinning = true
	Spin(int)
end)

_L.Signal.Fired("World Changed"):Connect(function(world: string)
	if world == "Spawn" then
		canSpin = true
		return
	end
	canSpin = false
end)

Update()