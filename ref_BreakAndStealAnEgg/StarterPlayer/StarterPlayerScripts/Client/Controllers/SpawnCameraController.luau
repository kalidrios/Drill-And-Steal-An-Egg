-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = 0

local function towardBoss(v3) -- line 56 | captures: CollectionService, HellBossConfig, HellEventConfig, LocalPlayer
    if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
        local v4 = CollectionService:GetTagged(HellBossConfig.Tag)[1]
        if v4 and v4:IsA("Model") then
            local v5 = v4:GetPivot().Position - v3.Position
            local X = v5.X
            local Z = v5.Z
            local v6 = Vector3.new(X, 0, Z)
            if v6.Magnitude > 1 then
                return v6.Unit
            end
        end
    end
    return nil
end

local function snapBehind(v7) -- line 69 | captures: Workspace, LocalPlayer, towardBoss
    local CurrentCamera = Workspace.CurrentCamera
    if not (CurrentCamera and LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson) then
        return
    end
    CurrentCamera.CameraType = Enum.CameraType.Custom
    if (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude < 2 then
        local CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance
        LocalPlayer.CameraMinZoomDistance = math.max(CameraMinZoomDistance, 10)
        task.delay(0.15, function() -- line 84 | captures: CameraMinZoomDistance, LocalPlayer
            if LocalPlayer.CameraMinZoomDistance == math.max(CameraMinZoomDistance, 10) then
                LocalPlayer.CameraMinZoomDistance = CameraMinZoomDistance
            end
        end)
    end
    local v8 = towardBoss(v7) or v7.CFrame.LookVector
    local v9 = v7.Position + Vector3.new(0, 1.5, 0)
    local v10 = v7.Position - v8 * 10 + Vector3.new(0, 4, 0)
    CurrentCamera.CFrame = CFrame.lookAt(v10, v9)
end

local function watchJumps(v11, v12, v13) -- line 101 | captures: v2, RunService, snapBehind
    if v13 then
        snapBehind(v11)
    end
    local Position = v11.Position
    local v14 = os.clock() + 4
    while true do
        if os.clock() < v14 then
            RunService.Heartbeat:Wait()
            local Position_2
            if v12 == v2 and v11.Parent then
                Position_2 = v11.Position
                if (Position_2 - Position).Magnitude > 15 then
                    snapBehind(v11)
                end
            else
                break
            end
            Position = Position_2
            continue
        end
        return
    end
end

local function onCharacter(v15) -- line 120 | captures: v2, RunService, watchJumps
    v2 += 1
    local v16 = v2
    task.spawn(function() -- line 124 | captures: v15, v16, v2, RunService, watchJumps
        local v17 = v15:WaitForChild("HumanoidRootPart", 10)
        if not (v17 and v17:IsA("BasePart") and v16 == v2) then
            return
        end
        RunService.Heartbeat:Wait()
        if v16 == v2 and v17.Parent then
            watchJumps(v17, v16, true)
        end
    end)
end

local function onHellChanged() -- line 142 | captures: v2, RunService, LocalPlayer, watchJumps
    local Character = LocalPlayer.Character
    local v18 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (v18 and v18:IsA("BasePart")) then
        return
    end
    v2 += 1
    local v19 = v2
    task.spawn(function() -- line 150 | captures: v18, v19, v2, RunService, watchJumps
        RunService.Heartbeat:Wait()
        RunService.Heartbeat:Wait()
        if v19 == v2 and v18.Parent then
            watchJumps(v18, v19, true)
        end
    end)
end

function v1.SnapBehind() -- line 169 | captures: LocalPlayer, snapBehind
    local Character = LocalPlayer.Character
    local v20 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v20 and v20:IsA("BasePart") then
        snapBehind(v20)
    end
end

function v1.Start() -- line 177 | captures: v2, RunService, HellEventConfig, LocalPlayer, watchJumps, onCharacter, onHellChanged
    LocalPlayer.CharacterAdded:Connect(onCharacter)
    if LocalPlayer.Character then
        local Character = LocalPlayer.Character
        v2 += 1
        local v21 = v2
        task.spawn(function() -- line 124 | captures: Character, v21, v2, RunService, watchJumps
            local v22 = Character:WaitForChild("HumanoidRootPart", 10)
            if not (v22 and v22:IsA("BasePart") and v21 == v2) then
                return
            end
            RunService.Heartbeat:Wait()
            if v21 == v2 and v22.Parent then
                watchJumps(v22, v21, true)
            end
        end)
    end
    LocalPlayer:GetAttributeChangedSignal(HellEventConfig.PlayerAttribute):Connect(onHellChanged)
end

return v1
