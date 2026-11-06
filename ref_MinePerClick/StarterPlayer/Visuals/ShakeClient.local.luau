-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

ReplicatedStorage:WaitForChild("Client")

local Utils = ReplicatedStorage:WaitForChild("Utils")
local Shake = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("Shake")
local CameraShaker = require(Utils:WaitForChild("CameraShaker"))
local Camera = game.Workspace.Camera
local v1 = Camera.CFrame
local v2 = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(p1) --[[ Line: 21 | Upvalues: v1 (ref), Camera (copy) ]]
	v1 = Camera.CFrame
	Camera.CFrame = Camera.CFrame * p1
end)

v2:Start()
Shake.OnClientEvent:Connect(function() --[[ Line: 29 | Upvalues: v2 (copy), CameraShaker (copy) ]]
	v2:Shake(CameraShaker.Presets.Explosion)
end)
task.spawn(function() --[[ Line: 33 | Upvalues: RunService (copy), Camera (copy), v1 (ref) ]]
	RunService.Heartbeat:Connect(function() --[[ Line: 34 | Upvalues: Camera (ref), v1 (ref) ]]
		Camera.CFrame = v1
	end)
end)