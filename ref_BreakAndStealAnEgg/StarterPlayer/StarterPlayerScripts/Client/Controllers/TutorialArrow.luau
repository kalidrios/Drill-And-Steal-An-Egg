-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2, P0, P1, v3, v4, v5

local function destroyParts() -- line 29 | captures: v2, P0, P1, v3
    if v2 then
        v2:Destroy()
    end
    v2 = nil
    P0 = nil
    P1 = nil
    v3 = nil
end

local function ensureParts() -- line 38 | captures: v2, P0, P1, v3, ReplicatedStorage
    if v2 and v2.Parent and P0 and P1 and v3 then
        return true
    end
    if v2 then
        v2:Destroy()
    end
    v2 = nil
    P0 = nil
    P1 = nil
    v3 = nil
    local TutorialArrowParts = ReplicatedStorage:FindFirstChild("TutorialArrowParts")
    if TutorialArrowParts then
        local v6 = TutorialArrowParts:Clone()
        for v7, v8 in v6:GetChildren() do
            if v8:IsA("BasePart") then
                v8.Anchored = true
                v8.Transparency = 1
                v8.CanCollide = false
                v8.CanQuery = false
                v8.CanTouch = false
            end
        end
        local P0_2 = v6:FindFirstChild("P0")
        local P1_2 = v6:FindFirstChild("P1")
        local v9 = v6:FindFirstChild("Beam", true)
        if P0_2 and P0_2:IsA("BasePart") and P1_2 and P1_2:IsA("BasePart") and v9 and v9:IsA("Beam") then
            v9.Enabled = false
            v6.Parent = workspace
            v2 = v6
            P0 = P0_2
            P1 = P1_2
            v3 = v9
            return true
        end
        v6:Destroy()
    end
    return false
end

local function step() -- line 78 | captures: P0, P1, v3, v4, LocalPlayer, ensureParts
    local Character = LocalPlayer.Character
    local v10 = Character and Character:FindFirstChild("HumanoidRootPart")
    local v11 = v4 and v4()
    if v10 and v10:IsA("BasePart") and v11 and ensureParts() then
        P0.CFrame = CFrame.new(v10.Position)
        P1.CFrame = CFrame.new(v11)
        v3.Enabled = true
    elseif v3 then
        v3.Enabled = false
    end
end

function v1.Show(v12) -- line 97 | captures: v4, v5, RunService, step
    v4 = v12
    v5 = v5 or RunService.Heartbeat:Connect(step)
end

function v1.Hide() -- line 104 | captures: v2, P0, P1, v3, v4, v5
    v4 = nil
    if v5 then
        v5:Disconnect()
        v5 = nil
    end
    if v2 then
        v2:Destroy()
    end
    v2 = nil
    P0 = nil
    P1 = nil
    v3 = nil
end

return v1
