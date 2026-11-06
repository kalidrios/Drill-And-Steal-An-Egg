-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local AnimationLegMask = require(ReplicatedStorage.Shared.AnimationLegMask)
local BatConfig = require(ReplicatedStorage.Shared.BatConfig)
local BatTargeting = require(ReplicatedStorage.Shared.BatTargeting)
local BatToolQuery = require(ReplicatedStorage.Shared.BatToolQuery)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local SafeZoneQuery = require(ReplicatedStorage.Shared.SafeZoneQuery)
local BatTargetHighlight = require(script.Parent.BatTargetHighlight)
local NotificationController = require(script.Parent.NotificationController)
local HellBossController = require(script.Parent.HellBossController)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2, Character
local v3 = 0
local v4 = 0
local v5 = 0
local v6

local function getSwingAnimation() -- line 64 | captures: v6, ReplicatedStorage, BatConfig
    if v6 and v6.Parent then
        return v6
    end
    local v7 = ReplicatedStorage:WaitForChild("Assets", 30)
    local v8 = v7 and v7:WaitForChild("Animations", 10)
    local v9 = v8 and v8:WaitForChild(BatConfig.SwingAnimationName, 10)
    if not (v9 and v9:IsA("Animation")) then
        warn((("[BatController] Assets.Animations.%* not found"):format(BatConfig.SwingAnimationName)))
        return nil
    end
    v6 = v9
    return v9
end

local v10

local function getHitRemote() -- line 82 | captures: v10, ReplicatedStorage, BatConfig
    if not (v10 and v10.Parent) then
        local v11 = ReplicatedStorage:FindFirstChild(BatConfig.HitRemoteName)
        if not (v11 and v11:IsA("RemoteEvent")) then
            v11 = nil
        end
        v10 = v11
    end
    return v10
end

local function getSwingTrack() -- line 91 | captures: v2, Character, AnimationLegMask, LocalPlayer, getSwingAnimation
    local Character_2 = LocalPlayer.Character
    if Character_2 then
        if v2 and Character == Character_2 then
            return v2
        end
        local Humanoid = Character_2:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            local Animator = Humanoid:FindFirstChildOfClass("Animator")
            if Animator then
                local v12 = getSwingAnimation()
                if v12 then
                    v2 = Animator:LoadAnimation(AnimationLegMask.GetUpperBody(v12, "BatSwingUpperBody"))
                    v2.Priority = Enum.AnimationPriority.Action4
                    v2.Looped = false
                    Character = Character_2
                    return v2
                end
            end
        end
    end
    return nil
end

local function isInSafeArea() -- line 128 | captures: SafeZoneQuery, LocalPlayer
    local Character = LocalPlayer.Character
    local v13 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v13 and v13:IsA("BasePart") then
        return SafeZoneQuery.IsBankable(LocalPlayer.UserId, v13.Position)
    end
    return false
end

local function currentTarget() -- line 140 | captures: BatTargeting, SafeZoneQuery, LocalPlayer
    local Character = LocalPlayer.Character
    if Character then
        local v14 = Character:FindFirstChild("HumanoidRootPart")
        if v14 and v14:IsA("BasePart") then
            if Character:GetAttribute("Ragdolled") then
                return nil
            end
            local Character_2 = LocalPlayer.Character
            local v15 = Character_2 and Character_2:FindFirstChild("HumanoidRootPart")
            if v15 and v15:IsA("BasePart") and SafeZoneQuery.IsBankable(LocalPlayer.UserId, v15.Position) then
                return nil
            end
            return BatTargeting.SelectClosestTarget(LocalPlayer, v14.Position, BatTargeting.MaxRange(LocalPlayer))
        end
    end
    return nil
end

local function playSwooshSound() -- line 160 | captures: SoundService, BatToolQuery, LocalPlayer
    local SFX = SoundService:FindFirstChild("SFX")
    local v16 = SFX and SFX:FindFirstChild("Swoosh")
    if not (v16 and v16:IsA("Sound")) then
        return
    end
    local Character = LocalPlayer.Character
    local Handle
    if Character then
        for v17, v18 in Character:GetChildren() do
            if BatToolQuery.IsBatWeapon(v18) then
                Handle = v18:FindFirstChild("Handle")
                if Handle then
                    if not Handle:IsA("BasePart") then
                        Handle = nil
                    end
                else
                    Handle = nil
                end
                break
            end
            Handle = nil
        end
    end
    if Handle then
        local BatSwoosh = Handle:FindFirstChild("BatSwoosh")
        if BatSwoosh then
            if not BatSwoosh:IsA("Sound") then
                BatSwoosh = v16:Clone()
                BatSwoosh.Name = "BatSwoosh"
                BatSwoosh.Parent = Handle
            end
        else
            BatSwoosh = v16:Clone()
            BatSwoosh.Name = "BatSwoosh"
            BatSwoosh.Parent = Handle
        end
        BatSwoosh:Play()
    else
        v16:Play()
    end
end

local function swing() -- line 198 | captures: v3, v4, v5, v10, Players, ReplicatedStorage, BatConfig, HellEventConfig, SafeZoneQuery, NotificationController, HellBossController, LocalPlayer, getSwingTrack, currentTarget, playSwooshSound
    local v19 = os.clock()
    local Character = LocalPlayer.Character
    local v20 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v20 and v20:IsA("BasePart") and SafeZoneQuery.IsBankable(LocalPlayer.UserId, v20.Position) then
        if v19 - v4 >= 1 then
            v4 = v19
            NotificationController.ShowPreset("BatSafeZone")
        end
    else
        local v21 = Players.LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true
        local v22 = if v21 then BatConfig.HellClientCooldown else BatConfig.ClientCooldown
        if not (v19 - v3 < v22) then
            v3 = v19
            local v23 = getSwingTrack()
            if v23 then
                if v23.IsPlaying then
                    v23:Stop(0)
                end
                v23:Play(0.1, 1, BatConfig.SwingSpeed)
                v5 += 1
                local v24 = v5
                local Length = v23.Length
                if Length > 0 then
                    local v25 = (Length - BatConfig.SwingTrimEnd) / BatConfig.SwingSpeed
                    if v25 > 0.05 then
                        task.delay(v25, function() -- line 233 | captures: v23, v24, v5
                            if v24 == v5 and v23.IsPlaying then
                                v23:Stop(0.15)
                            end
                        end)
                    end
                end
            end
            local v26 = v5
            task.delay(0.1, function() -- line 248 | captures: v26, v5, playSwooshSound
                if v26 == v5 then
                    playSwooshSound()
                end
            end)
            if not (v10 and v10.Parent) then
                local v27 = ReplicatedStorage:FindFirstChild(BatConfig.HitRemoteName)
                if v27 then
                    if not v27:IsA("RemoteEvent") then
                        v27 = nil
                    end
                else
                    v27 = nil
                end
                v10 = v27
            end
            local v28 = v10
            if v28 then
                v28:FireServer(currentTarget())
            end
            if v21 then
                HellBossController.PredictBatHit()
            end
        end
    end
end

function v1.Swing() -- line 272 | captures: BatToolQuery, LocalPlayer, swing
    local Character = LocalPlayer.Character
    if Character then
        for v29, v30 in Character:GetChildren() do
            if BatToolQuery.IsBatWeapon(v30) then
                swing()
                return
            end
        end
    end
end

local v31

local function stopLockOn() -- line 290 | captures: v31, BatTargetHighlight
    if v31 then
        v31:Disconnect()
        v31 = nil
    end
    BatTargetHighlight.Clear()
end

local function startLockOn() -- line 298 | captures: v31, RunService, BatTargetHighlight, currentTarget
    v31 = v31 or
    RunService.RenderStepped:Connect(function() -- line 302 | captures: BatTargetHighlight, currentTarget
        local v32 = currentTarget()
        BatTargetHighlight.SetTarget(v32 and v32.Character)
    end)
end

local v33 = {}

local function hookTool(v34) -- line 315 | captures: v2, v5, v31, RunService, BatToolQuery, BatTargetHighlight, LocalPlayer, currentTarget, swing, startLockOn, v33
    if not BatToolQuery.IsBatWeapon(v34) or v33[v34] then
        return
    end
    v33[v34] = true
    v34.Destroying:Once(function() -- line 323 | captures: v34, v33
        v33[v34] = nil
    end)
    v34.Activated:Connect(swing)
    v34.Equipped:Connect(startLockOn)
    v34.Unequipped:Connect(function() -- line 330 | captures: v2, v5, v31, BatTargetHighlight
        if v31 then
            v31:Disconnect()
            v31 = nil
        end
        BatTargetHighlight.Clear()
        v5 += 1
        if v2 and v2.IsPlaying then
            v2:Stop(0.1)
        end
    end)
    local Character = LocalPlayer.Character
    if Character and v34.Parent == Character then
        if v31 then
            return
        end
        v31 = RunService.RenderStepped:Connect(function() -- line 302 | captures: BatTargetHighlight, currentTarget
            local v35 = currentTarget()
            BatTargetHighlight.SetTarget(v35 and v35.Character)
        end)
    end
end

local v36 = {}

local function unhookContainer(v37) -- line 354 | captures: v36
    local v38 = v36[v37]
    if v38 then
        v36[v37] = nil
        v38:Disconnect()
    end
end

local function hookContainer(v39) -- line 362 | captures: hookTool, v36
    if v36[v39] then
        return
    end
    v36[v39] = v39.ChildAdded:Connect(hookTool)
    v39.Destroying:Once(function() -- line 367 | captures: v39, v36
        local v40 = v36[v39]
        if v40 then
            v36[v39] = nil
            v40:Disconnect()
        end
    end)
    for v41, v42 in v39:GetChildren() do
        hookTool(v42)
    end
end

local function onCharacter(v43) -- line 378 | captures: v31, ContentProvider, BatTargetHighlight, LocalPlayer, getSwingAnimation, getSwingTrack, hookContainer
    if v31 then
        v31:Disconnect()
        v31 = nil
    end
    BatTargetHighlight.Clear()
    task.spawn(function() -- line 383 | captures: v43, ContentProvider, LocalPlayer, getSwingAnimation, getSwingTrack
        pcall(ContentProvider.PreloadAsync, ContentProvider, { (getSwingAnimation()) })
        local v44 = v43:WaitForChild("Humanoid", 10)
        if v44 and v44:WaitForChild("Animator", 10) and LocalPlayer.Character == v43 then
            getSwingTrack()
        end
    end)
    hookContainer(v43)
    local v45 = LocalPlayer:WaitForChild("Backpack", 10)
    if v45 then
        hookContainer(v45)
    end
end

function v1.Start() -- line 399 | captures: LocalPlayer, unhookContainer, onCharacter
    if LocalPlayer.Character then
        task.spawn(onCharacter, LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(onCharacter)
    LocalPlayer.CharacterRemoving:Connect(unhookContainer)
end

return v1
