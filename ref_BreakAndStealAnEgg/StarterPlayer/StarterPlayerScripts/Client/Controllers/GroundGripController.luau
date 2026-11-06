-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SpeedConfig = require(ReplicatedStorage.Shared.SpeedConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}

v2[Enum.HumanoidStateType.Running] = true
v2[Enum.HumanoidStateType.RunningNoPhysics] = true

local v3 = RaycastParams.new()

v3.FilterType = Enum.RaycastFilterType.Exclude
v3.IgnoreWater = true

local function floorVelocity(v4, v5, v6) -- line 51 | captures: v3
    v3.FilterDescendantsInstances = { v4 }
    local v7 = v6.HipHeight + v5.Size.Y * 0.5 + 2
    local workspace_2 = workspace
    local Position = v5.Position
    local v8 = -v7
    local v9 = workspace_2:Raycast(Position, Vector3.new(0, v8, 0), v3)
    if not (v9 and v9.Instance) then
        return (Vector3.new(0, 0, 0))
    end
    return v9.Instance:GetVelocityAtPosition(v9.Position)
end

local function step(v10) -- line 61 | captures: SpeedConfig, LocalPlayer, v2, floorVelocity
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            local RootPart = Humanoid.RootPart
            if RootPart and not (Humanoid.Health <= 0) and not Humanoid.PlatformStand and not Humanoid.Sit and not RootPart.Anchored and Humanoid.FloorMaterial ~= Enum.Material.Air and not (Humanoid.WalkSpeed < SpeedConfig.GroundGripMinWalkSpeed) and v2[Humanoid:GetState()] then
                local v11 = floorVelocity(Character, RootPart, Humanoid)
                local AssemblyLinearVelocity = RootPart.AssemblyLinearVelocity
                local v12 = AssemblyLinearVelocity.X - v11.X
                local v13 = AssemblyLinearVelocity.Z - v11.Z
                local v14 = Vector3.new(v12, 0, v13)
                local MoveDirection = Humanoid.MoveDirection
                local X = MoveDirection.X
                local Z = MoveDirection.Z
                local v15 = Vector3.new(X, 0, Z) * Humanoid.WalkSpeed
                local v16 = -SpeedConfig.GroundGripResponsiveness * v10
                local v17 = v14:Lerp(v15, 1 - math.exp(v16))
                local v18 = v17.X + v11.X
                local Y = AssemblyLinearVelocity.Y
                local v19 = v17.Z + v11.Z
                RootPart.AssemblyLinearVelocity = Vector3.new(v18, Y, v19)
            end
        end
    end
end

function v1.Start() -- line 101 | captures: RunService, step
    RunService.PreSimulation:Connect(step)
end

return v1
