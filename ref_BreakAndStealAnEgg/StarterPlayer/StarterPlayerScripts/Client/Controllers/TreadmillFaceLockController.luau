-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = Enum.RenderPriority.Character.Value + 1
local v3 = false
local v4, v5
local v6 = true

local function unlock() -- line 47 | captures: v3, v4, v5, v6, RunService, LocalPlayer
    if not v3 then
        return
    end
    v3 = false
    v4 = nil
    v5 = nil
    RunService:UnbindFromRenderStep("TreadmillFaceLock")
    local Character = LocalPlayer.Character
    local v7 = Character and Character:FindFirstChildOfClass("Humanoid")
    if v7 then
        v7.AutoRotate = v6
    end
end

local function step() -- line 63 | captures: v4, v5
    local v8 = v4
    local v9 = v5
    if v8 and v9 and v9.Parent and v9.CFrame ~= v8 then
        v9.CFrame = v8
    end
end

local function lock(v10) -- line 79 | captures: v3, v4, v5, v6, RunService, LocalPlayer, v2, step
    local Character = LocalPlayer.Character
    local v11, v12
    if Character then
        v11 = Character:FindFirstChild("HumanoidRootPart")
        v12 = Character:FindFirstChildOfClass("Humanoid")
    else
        v11 = Character
        v12 = Character
    end
    if v11 and v11:IsA("BasePart") and v12 then
        v4 = v10
        v5 = v11
        if not v3 then
            v3 = true
            if Character:GetAttribute("Ragdolled") then
                v6 = true
            else
                v6 = v12.AutoRotate
            end
            RunService:BindToRenderStep("TreadmillFaceLock", v2, step)
        end
    else
        return
    end
    v12.AutoRotate = false
    v11.CFrame = v10
end

function v1.Start() -- line 103 | captures: v3, v4, v5, v6, ReplicatedStorage, RunService, HellEventConfig, LocalPlayer, unlock, lock
    local v13 = ReplicatedStorage:WaitForChild("TreadmillSessionRemote", 30)
    if not (v13 and v13:IsA("RemoteEvent")) then
        warn("[TreadmillFaceLockController] TreadmillSessionRemote missing")
    else
        v13.OnClientEvent:Connect(function(v14, v15) -- line 110 | captures: v3, v4, v5, v6, RunService, LocalPlayer, lock
            if typeof(v14) == "number" then
                if typeof(v15) == "CFrame" then
                    lock(v15)
                end
            else
                local v16
                if v3 then
                    v3 = false
                    v4 = nil
                    v5 = nil
                    RunService:UnbindFromRenderStep("TreadmillFaceLock")
                    local Character = LocalPlayer.Character
                    v16 = Character and Character:FindFirstChildOfClass("Humanoid")
                else
                    return
                end
                if v16 then
                    v16.AutoRotate = v6
                end
            end
        end)
        LocalPlayer.CharacterAdded:Connect(unlock)
        LocalPlayer:GetAttributeChangedSignal(HellEventConfig.PlayerAttribute):Connect(function() -- line 127 | captures: v3, v4, v5, v6, RunService, HellEventConfig, LocalPlayer
            if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
                local v17
                if v3 then
                    v3 = false
                    v4 = nil
                    v5 = nil
                    RunService:UnbindFromRenderStep("TreadmillFaceLock")
                    local Character = LocalPlayer.Character
                    v17 = Character and Character:FindFirstChildOfClass("Humanoid")
                else
                    return
                end
                if v17 then
                    v17.AutoRotate = v6
                end
            end
        end)
    end
end

return v1
