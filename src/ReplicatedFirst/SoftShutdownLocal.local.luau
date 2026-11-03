--[[
	SoftShutdownLocal.local.luau — Handles client reconnection UI and character position saving during server soft restarts.
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

while not Library.Loaded do
	RunService.Heartbeat:Wait()
end

if Library.Network then
	task.spawn(function()
		local startShutdownSignal = Library.Network.Fired and pcall(Library.Network.Fired, "Start Shutdown")
		if startShutdownSignal then
			Library.Network.Fired("Start Shutdown"):Connect(function()
				local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
				local shutdownUI = script:FindFirstChild("ShutdownUI")
				if shutdownUI and playerGui then
					shutdownUI.Parent = playerGui
				end
			end)
		end
	end)
end

local isWorldChangeTrackingActive = false
if Library.Signal and Library.Signal.Connect then
	Library.Signal.Connect("World Changed", function()
		if isWorldChangeTrackingActive then
			return
		end
		isWorldChangeTrackingActive = true

		local accumulatedHeartbeatTime = 0
		RunService.Heartbeat:Connect(function(deltaTime)
			accumulatedHeartbeatTime = accumulatedHeartbeatTime + deltaTime
			if accumulatedHeartbeatTime >= 1 then
				accumulatedHeartbeatTime = 0
				local localPlayer = Library.LocalPlayer or Players.LocalPlayer
				local localCharacter = localPlayer and localPlayer.Character
				if localCharacter and localCharacter.PrimaryPart and Library.Network then
					Library.Network.Fire(
						"Send Position",
						localCharacter:GetPrimaryPartCFrame(),
						workspace.CurrentCamera.CFrame,
						workspace.CurrentCamera.Focus
					)
				end
			end
		end)
	end)
end

if Library.Network then
	task.spawn(function()
		local checkOpeningRemote = Library.Network.Invoked("Check Opening Status")
		if checkOpeningRemote then
			checkOpeningRemote.OnClientInvoke = function()
				local vars = Library.Variables or {}
				return vars.AutoOpenEnabled or vars.AutoHatchEnabled,
					vars.AutoOpenBoxId or vars.AutoHatchEggId
			end
		end
	end)
end
