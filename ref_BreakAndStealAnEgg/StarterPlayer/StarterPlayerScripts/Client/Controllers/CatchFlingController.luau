-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local RagdollPhysics = require(ReplicatedStorage.Shared.RagdollPhysics)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2 = 0
local v3 = 0
local v4, v5

local function getCharacter() -- line 75 | captures: LocalPlayer
    local Character = LocalPlayer.Character
    return Character, Character and Character:FindFirstChildOfClass("Humanoid")
end

local function stopFlightUpkeep() -- line 81 | captures: v4, v5
    if v4 then
        v4:Disconnect()
        v4 = nil
    end
    if v5 then
        v5:Disconnect()
        v5 = nil
    end
end

local function recover() -- line 97 | captures: v4, v5, RagdollPhysics, LocalPlayer
    if v4 then
        v4:Disconnect()
        v4 = nil
    end
    if v5 then
        v5:Disconnect()
        v5 = nil
    end
    local Character = LocalPlayer.Character
    local v6
    if Character then
        v6 = Character:FindFirstChildOfClass("Humanoid")
        RagdollPhysics.SetCharacterVelocity(Character, Vector3.new(0, 0, 0), (Vector3.new(0, 0, 0)))
        RagdollPhysics.SnapUpright(Character)
    else
        v6 = Character
    end
    if v6 then
        v6:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        v6:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

local function onFling(v7, v8, v9) -- line 111 | captures: v2, v3, v4, v5, RunService, RagdollPhysics, LocalPlayer, recover
    local v10 = os.clock()
    if v10 - v2 < 0.5 then
        return
    end
    v2 = v10
    local Character = LocalPlayer.Character
    local v11 = Character and Character:FindFirstChildOfClass("Humanoid")
    v3 += 1
    local v12 = v3
    if v4 then
        v4:Disconnect()
        v4 = nil
    end
    if v5 then
        v5:Disconnect()
        v5 = nil
    end
    local v13, v14
    if Character and v11 then
        v14 = Vector3.new(0, 0, 0)
        v13 = v14
        local X = v7.X
        local Z = v7.Z
        local v15 = Vector3.new(X, 0, Z)
        local v16 = v9 or 0
        if v16 ~= 0 and v15.Magnitude > 0.01 then
            v14 = Vector3.new(0, 1, 0):Cross(v15.Unit) * v16
            v13 = v14
        end
    else
        return
    end
    local Animator = v11:FindFirstChildOfClass("Animator")
    if Animator then
        for v17, v18 in Animator:GetPlayingAnimationTracks() do
            v18:Stop(0)
        end
    end
    v11:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    v11:ChangeState(Enum.HumanoidStateType.Physics)
    v5 = v11.StateChanged:Connect(function(v19, v20) -- line 169 | captures: v11
        if v20 ~= Enum.HumanoidStateType.Physics and v20 ~= Enum.HumanoidStateType.Dead and v20 ~= Enum.HumanoidStateType.PlatformStanding then
            v11:ChangeState(Enum.HumanoidStateType.Physics)
        end
    end)
    RagdollPhysics.SetCharacterVelocity(Character, v7, v14)
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local v21 = {}
    for v22, v23 in Character:GetChildren() do
        if v23:IsA("BasePart") and v23 ~= HumanoidRootPart and (v23.Name == "Head" or v11:GetBodyPartR15(v23) ~= Enum.BodyPartR15.Unknown) then
            table.insert(v21, v23)
        end
    end
    local v24 = v10 + 0.25
    v4 = RunService.Heartbeat:Connect(function() -- line 198 | captures: v13, v7, Character, v12, v21, v24, v3, v4, v5, RagdollPhysics
        local v25
        if v12 == v3 then
            if Character.Parent == nil then
                v25 = true
            else
                if os.clock() < v24 then
                    RagdollPhysics.SetCharacterVelocity(Character, v7, v13)
                end
                v25 = false
            end
        else
            v25 = true
        end
        if not v25 then
            for v26, v27 in v21 do
                if v27.Parent and not v27.CanCollide then
                    v27.CanCollide = true
                end
            end
        else
            if v4 then
                v4:Disconnect()
                v4 = nil
            end
            if v5 then
                v5:Disconnect()
                v5 = nil
            end
        end
    end)
    local v28 = v8 or 5
    task.delay(v28 + 1 + 1, function() -- line 216 | captures: v12, v3, recover
        if v12 == v3 then
            recover()
        end
    end)
end

local function onRelease() -- line 223 | captures: v3, recover
    v3 += 1
    recover()
end

function v1.Start() -- line 228 | captures: v3, v4, v5, ReplicatedStorage, LocalPlayer, recover, onFling
    local v29 = ReplicatedStorage:WaitForChild("CatchFlingRemote", 30)
    if not (v29 and v29:IsA("RemoteEvent")) then
        warn("[CatchFlingController] ReplicatedStorage.CatchFlingRemote not found")
    else
        v29.OnClientEvent:Connect(function(v30, v31, v32, v33) -- line 237 | captures: v3, recover, onFling
            if v30 == "fling" and typeof(v31) == "Vector3" then
                local v34 = if typeof(v32) == "number" then v32 else nil
                local v35 = if typeof(v33) == "number" then v33 else nil
                onFling(v31, v34, v35)
            elseif v30 == "release" then
                v3 += 1
                recover()
            end
        end)
        LocalPlayer.CharacterAdded:Connect(function() -- line 251 | captures: v3, v4, v5
            v3 += 1
            if v4 then
                v4:Disconnect()
                v4 = nil
            end
            if v5 then
                v5:Disconnect()
                v5 = nil
            end
        end)
    end
end

return v1
