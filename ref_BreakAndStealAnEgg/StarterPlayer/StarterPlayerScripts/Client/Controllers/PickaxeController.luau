-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local AnimationLegMask = require(ReplicatedStorage.Shared.AnimationLegMask)
local AutoSwingConfig = require(ReplicatedStorage.Shared.AutoSwingConfig)
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local EggTargeting = require(ReplicatedStorage.Shared.EggTargeting)
local GamepadConfig = require(ReplicatedStorage.Shared.GamepadConfig)
local HellLoadout = require(ReplicatedStorage.Shared.HellLoadout)
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local RobuxShopConfig = require(ReplicatedStorage.Shared.RobuxShopConfig)
local EggLocalHits = require(script.Parent.EggLocalHits)
local PickaxeEquipState = require(script.Parent.PickaxeEquipState)
local PickaxeHitbox = require(script.Parent.PickaxeHitbox)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2, Character
local SwingCooldown = PickaxeConfig.SwingCooldown
local v3 = 0

local function currentSwingCooldown() -- line 55 | captures: RobuxShopConfig, LocalPlayer, SwingCooldown
    return SwingCooldown / RobuxShopConfig.SwingMultiplierFor(LocalPlayer)
end

local function isWielding() -- line 72 | captures: PickaxeConfig, LocalPlayer
    local Character = LocalPlayer.Character
    local v4 = Character and Character:FindFirstChild(PickaxeConfig.ToolName)
    if v4 == nil then
        return false
    end
    return (v4:IsA("Tool"))
end

local v5

local function getSwingAnimation() -- line 83 | captures: v5, ReplicatedStorage
    if v5 and v5.Parent then
        return v5
    end
    local v6 = ReplicatedStorage:WaitForChild("Assets", 30)
    local v7 = v6 and v6:WaitForChild("Animations", 10)
    local v8 = v7 and v7:WaitForChild("PickaxeSwing", 10)
    if not (v8 and v8:IsA("Animation")) then
        warn("[PickaxeController] Assets.Animations.PickaxeSwing not found")
        return nil
    end
    v5 = v8
    return v8
end

local EggHitRequest

local function getHitRemote() -- line 102 | captures: EggHitRequest, ReplicatedStorage
    if not (EggHitRequest and EggHitRequest.Parent) then
        local EggHitRequest_2 = ReplicatedStorage:FindFirstChild("EggHitRequest")
        if not (EggHitRequest_2 and EggHitRequest_2:IsA("RemoteEvent")) then
            EggHitRequest_2 = nil
        end
        EggHitRequest = EggHitRequest_2
    end
    return EggHitRequest
end

local function getSwingTrack() -- line 111 | captures: v2, Character, AnimationLegMask, LocalPlayer, getSwingAnimation
    local Character_2 = LocalPlayer.Character
    if Character_2 then
        if v2 and Character == Character_2 then
            return v2
        end
        local Humanoid = Character_2:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            local Animator = Humanoid:FindFirstChildOfClass("Animator")
            if Animator then
                local v9 = getSwingAnimation()
                if v9 then
                    v2 = Animator:LoadAnimation(AnimationLegMask.Get(v9, "PickaxeSwingUpperBody"))
                    v2.Priority = Enum.AnimationPriority.Action4
                    Character = Character_2
                    return v2
                end
            end
        end
    end
    return nil
end

local function warmSwingTrack(v10) -- line 145 | captures: ContentProvider, LocalPlayer, getSwingAnimation, getSwingTrack
    task.spawn(function() -- line 146 | captures: v10, ContentProvider, LocalPlayer, getSwingAnimation, getSwingTrack
        pcall(ContentProvider.PreloadAsync, ContentProvider, { (getSwingAnimation()) })
        local v11 = v10:WaitForChild("Humanoid", 10)
        if v11 and v11:WaitForChild("Animator", 10) and LocalPlayer.Character == v10 then
            getSwingTrack()
        end
    end)
end

local v12

local function reportHit(v13, v14) -- line 169 | captures: EggHitRequest, v12, ReplicatedStorage, PickaxeConfig, EggLocalHits, LocalPlayer
    v12 = v14
    local v15 = v13:FindFirstChild(PickaxeConfig.ToolName)
    local v16 = v15 and v15:GetAttribute("PickaxeTier")
    if typeof(v16) ~= "number" then
        v16 = LocalPlayer:GetAttribute("PickaxeTier")
    end
    local FixedDamage = v14:GetAttribute("FixedDamage")
    if not (type(FixedDamage) == "number" and FixedDamage > 0) then
        FixedDamage = PickaxeConfig.GetDamage(v16)
    end
    local v17 = EggLocalHits.Announce(v14, FixedDamage)
    if not (EggHitRequest and EggHitRequest.Parent) then
        local EggHitRequest_2 = ReplicatedStorage:FindFirstChild("EggHitRequest")
        if EggHitRequest_2 then
            if not EggHitRequest_2:IsA("RemoteEvent") then
                EggHitRequest_2 = nil
            end
        else
            EggHitRequest_2 = nil
        end
        EggHitRequest = EggHitRequest_2
    end
    local EggHitRequest_2 = EggHitRequest
    if EggHitRequest_2 then
        EggHitRequest_2:FireServer(v14, v17)
    end
end

local function reportHitAt(v18, v19, v20) -- line 199 | captures: EggTargeting, PickaxeConfig, LocalPlayer, reportHit
    local v21 = 0.25 - (os.clock() - v18)
    if v21 <= 0 then
        reportHit(v19, v20)
    else
        task.delay(v21, function() -- line 205 | captures: v19, v20, EggTargeting, PickaxeConfig, LocalPlayer, reportHit
            if v19 ~= LocalPlayer.Character then
                return
            end
            local Character = LocalPlayer.Character
            local v22 = Character and Character:FindFirstChild(PickaxeConfig.ToolName)
            if v22 ~= nil and v22:IsA("Tool") and EggTargeting.IsLive(v20) then
                reportHit(v19, v20)
            end
        end)
    end
end

local function playSwooshSound() -- line 222 | captures: SoundService, PickaxeConfig, LocalPlayer
    local SFX = SoundService:FindFirstChild("SFX")
    local v23 = SFX and SFX:FindFirstChild("Swoosh")
    local v24
    if v23 and v23:IsA("Sound") then
        local Character = LocalPlayer.Character
        v24 = Character and Character:FindFirstChild(PickaxeConfig.ToolName)
    else
        return
    end
    local v25 = v24 and v24:FindFirstChild("Handle")
    if v25 and v25:IsA("BasePart") then
        local PickaxeSwoosh = v25:FindFirstChild("PickaxeSwoosh")
        if PickaxeSwoosh then
            if not PickaxeSwoosh:IsA("Sound") then
                PickaxeSwoosh = v23:Clone()
                PickaxeSwoosh.Name = "PickaxeSwoosh"
                PickaxeSwoosh.Parent = v25
            end
        else
            PickaxeSwoosh = v23:Clone()
            PickaxeSwoosh.Name = "PickaxeSwoosh"
            PickaxeSwoosh.Parent = v25
        end
        PickaxeSwoosh:Play()
    else
        v23:Play()
    end
end

local v26

function v1.SetAutoTargeting(v27) -- line 263 | captures: v26
    v26 = v27
end

local v28 = EggConfig.HitRange - AutoSwingConfig.RangeMargin
local v29 = math.max(0, v28)
local v30 = EggConfig.HitRange - AutoSwingConfig.StickyRangeMargin
local v31 = math.max(v29, v30)

local function whiffAssistTarget(v32) -- line 277 | captures: v12, EggTargeting, PickaxeConfig, v29, v31
    local HumanoidRootPart = v32:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        local v33 = EggTargeting.Pick(HumanoidRootPart.Position, v29, v12, v31)
        if v33 then
            if not (EggTargeting.SurfaceDistance(v33, HumanoidRootPart.Position) <= 0) then
                local v34 = v33.Position - HumanoidRootPart.Position
                local X = v34.X
                local Z = v34.Z
                local v35 = Vector3.new(X, 0, Z)
                local LookVector = HumanoidRootPart.CFrame.LookVector
                local X_2 = LookVector.X
                local Z_2 = LookVector.Z
                local v36 = Vector3.new(X_2, 0, Z_2)
                if not (v35.Magnitude < 0.001 or v36.Magnitude < 0.001) and v35.Unit:Dot(v36.Unit) < (PickaxeConfig.Hitbox.WhiffAssistFacingDot or 0) then
                    return nil
                end
            end
            return v33
        end
    end
    return nil
end

local function describePickaxe(v37) -- line 307 | captures: PickaxeConfig, LocalPlayer
    local Character = LocalPlayer.Character
    local v38 = Character and Character:FindFirstChild(PickaxeConfig.ToolName)
    if v38 then
        local Handle = v38:FindFirstChild("Handle")
        if Handle and Handle:IsA("BasePart") then
            local v39 = Character and Character:FindFirstChild("HumanoidRootPart")
            local Magnitude
            if not (v39 and v39:IsA("BasePart")) then
            else
                Magnitude = (Handle.Position - v39.Position).Magnitude
            end
            if Magnitude and Magnitude > 10 then
                warn((("[PickaxeDebug] %*: equipped but the handle is %* studs from the body \226\128\148 WELD BROKEN, blade is loose"):format(v37, (math.floor(Magnitude)))))
            end
        else
            warn((("[PickaxeDebug] %*: equipped but the HANDLE IS MISSING \226\128\148 husk tool, it can never show or hit"):format(v37)))
        end
    else
        local v40
        if v37 == "swing blocked" then
            local Backpack = LocalPlayer:FindFirstChild("Backpack")
            if Backpack then
                v40 = not not Backpack:FindFirstChild(PickaxeConfig.ToolName)
            else
                v40 = false
            end
        else
            v40 = true
        end
        if not v40 then
            warn((("[PickaxeDebug] %*: NO PICKAXE TOOL AT ALL"):format(v37)))
        end
    end
end

local v41 = false

local function reportHuskIfMissing() -- line 343 | captures: v41, ReplicatedStorage, PickaxeConfig, LocalPlayer
    if not v41 then
        local function huskNow() -- line 347 | captures: PickaxeConfig, LocalPlayer
            local Character = LocalPlayer.Character
            local Backpack = LocalPlayer:FindFirstChild("Backpack")
            local v42 = Character and Character:FindFirstChild(PickaxeConfig.ToolName) or Backpack and Backpack:FindFirstChild(PickaxeConfig.ToolName)
            if v42 == nil then
                return false
            end
            return v42:IsA("Tool") and v42:FindFirstChild("Handle") == nil
        end

        if huskNow() then
            v41 = true
            task.delay(0.5, function() -- line 358 | captures: huskNow, v41, ReplicatedStorage
                v41 = false
                if not huskNow() then
                    return
                end
                warn("[PickaxeDebug] handle still missing on our copy \226\128\148 asking the server for a fresh pickaxe")
                local PickaxeHandleMissingReport = ReplicatedStorage:FindFirstChild("PickaxeHandleMissingReport")
                if PickaxeHandleMissingReport and PickaxeHandleMissingReport:IsA("RemoteEvent") then
                    PickaxeHandleMissingReport:FireServer()
                end
            end)
        end
    end
end

local v43 = 0

local function swing(v44) -- line 379 | captures: v3, v26, v43, EggTargeting, HellLoadout, PickaxeConfig, RobuxShopConfig, PickaxeHitbox, LocalPlayer, SwingCooldown, getSwingTrack, reportHitAt, playSwooshSound, whiffAssistTarget, describePickaxe, reportHuskIfMissing
    local Character = LocalPlayer.Character
    local v45 = Character and Character:FindFirstChild(PickaxeConfig.ToolName)
    if v45 ~= nil and v45:IsA("Tool") then
        if not v44 or EggTargeting.IsLive(v44) then
            local v46 = os.clock()
            if v46 - v3 < SwingCooldown / RobuxShopConfig.SwingMultiplierFor(LocalPlayer) then
                return false
            end
            v3 = v46
            local v47
            if v44 then
                v47 = v44
            else
                local v48 = v26
                if v48 then
                    local v49
                    v49, v47 = pcall(v48)
                    if not (v49 and v47 and EggTargeting.IsLive(v47)) then
                        v47 = v44
                    end
                else
                    v47 = v44
                end
            end
            local v50, v51 = pcall(function() -- line 431 | captures: RobuxShopConfig, LocalPlayer, getSwingTrack
                local v52 = getSwingTrack()
                if not v52 then
                    return
                end
                if v52.IsPlaying then
                    v52:Stop(0)
                end
                v52:Play(0.1)
                v52:AdjustSpeed(2 * RobuxShopConfig.SwingMultiplierFor(LocalPlayer))
            end)
            if not v50 then
                warn((("[PickaxeController] swing animation failed: %*"):format(v51)))
            end
            task.delay(0.1, function() -- line 448 | captures: PickaxeConfig, LocalPlayer, playSwooshSound
                local Character = LocalPlayer.Character
                local v53 = Character and Character:FindFirstChild(PickaxeConfig.ToolName)
                if v53 ~= nil and v53:IsA("Tool") then
                    pcall(playSwooshSound)
                end
            end)
            local Character = LocalPlayer.Character
            if Character then
                if v47 then
                    PickaxeHitbox.Flush()
                    reportHitAt(v46, Character, v47)
                else
                    local Sweep = PickaxeHitbox.Sweep

                    local function v54(v55) -- line 484 | captures: v46, Character, reportHitAt
                        reportHitAt(v46, Character, v55)
                    end

                    Sweep(Character, v54, function() -- line 486 | captures: v46, Character, v26, EggTargeting, PickaxeConfig, LocalPlayer, reportHitAt, whiffAssistTarget
                        local v56 = v26
                        local v57 = v56 and v56() or whiffAssistTarget(Character)
                        if not (v57 and Character == LocalPlayer.Character) then
                            return
                        end
                        local Character_2 = LocalPlayer.Character
                        local v58 = Character_2 and Character_2:FindFirstChild(PickaxeConfig.ToolName)
                        if v58 ~= nil and v58:IsA("Tool") and EggTargeting.IsLive(v57) then
                            reportHitAt(v46, Character, v57)
                        end
                    end, PickaxeConfig.Hitbox.SweepDuration / RobuxShopConfig.SwingMultiplierFor(LocalPlayer))
                end
            end
            return true
        end
    else
        local Character = LocalPlayer.Character
        local v59 = if Character == nil then false else Character:FindFirstChildOfClass("Tool") ~= nil
        local v60 = os.clock()
        if not v59 and not HellLoadout.InHell(LocalPlayer) and v60 - v43 > 2 then
            v43 = v60
            describePickaxe("swing blocked")
            reportHuskIfMissing()
        end
    end
    return false
end

v1.Swing = swing
v1.IsWielding = isWielding

function v1.GetLastHitEgg() -- line 509 | captures: v12, EggTargeting
    local v61 = v12
    if v61 and EggTargeting.IsLive(v61) then
        return v61
    end
    v12 = nil
    return nil
end

function v1.Start() -- line 518 | captures: v12, ContentProvider, ReplicatedStorage, UserInputService, GamepadConfig, EggLocalHits, PickaxeEquipState, LocalPlayer, getSwingAnimation, getSwingTrack, warmSwingTrack, describePickaxe, reportHuskIfMissing, swing
    PickaxeEquipState.Observe(function(v62) -- line 523 | captures: describePickaxe, reportHuskIfMissing
        if not v62 then
            return
        end
        describePickaxe("equipped")
        task.delay(0.5, function() -- line 530 | captures: reportHuskIfMissing
            reportHuskIfMissing()
        end)
        task.delay(1.5, function() -- line 533 | captures: describePickaxe, reportHuskIfMissing
            describePickaxe("1.5s after equip")
            reportHuskIfMissing()
        end)
    end)
    LocalPlayer.CharacterAdded:Connect(function() -- line 538 | captures: describePickaxe, reportHuskIfMissing
        task.delay(3, function() -- line 539 | captures: describePickaxe, reportHuskIfMissing
            describePickaxe("3s after spawn")
            reportHuskIfMissing()
        end)
    end)
    if LocalPlayer.Character then
        local Character = LocalPlayer.Character
        task.spawn(function() -- line 146 | captures: Character, ContentProvider, LocalPlayer, getSwingAnimation, getSwingTrack
            pcall(ContentProvider.PreloadAsync, ContentProvider, { (getSwingAnimation()) })
            local v63 = Character:WaitForChild("Humanoid", 10)
            if v63 and v63:WaitForChild("Animator", 10) and LocalPlayer.Character == Character then
                getSwingTrack()
            end
        end)
    end
    LocalPlayer.CharacterAdded:Connect(warmSwingTrack)
    UserInputService.InputBegan:Connect(function(v64, v65) -- line 553 | captures: GamepadConfig, swing
        if not v65 and (v64.UserInputType == Enum.UserInputType.MouseButton1 or v64.KeyCode == GamepadConfig.SwingButton) then
            swing()
        end
    end)
    local v66 = {}
    local v67 = { __mode = "k" }
    local v68 = setmetatable(v66, v67)
    UserInputService.InputBegan:Connect(function(v69, v70) -- line 573 | captures: v68
        if v69.UserInputType == Enum.UserInputType.Touch and not v70 then
            v68[v69] = v69.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(v71) -- line 578 | captures: v68, swing
        local v72 = v68[v71]
        if v72 then
            v68[v71] = nil
            if (Vector2.new(v71.Position.X, v71.Position.Y) - Vector2.new(v72.X, v72.Y)).Magnitude <= 25 then
                swing()
            end
        end
    end)
    task.spawn(function() -- line 596 | captures: v12, ReplicatedStorage, EggLocalHits
        local v73 = ReplicatedStorage:WaitForChild("EggHitRejected", 30)
        if v73 and v73:IsA("RemoteEvent") then
            v73.OnClientEvent:Connect(function(v74, v75) -- line 601 | captures: v12, EggLocalHits
                if not (typeof(v74) == "Instance" and v74:IsA("BasePart")) then
                    return
                end
                if v74 == v12 then
                    v12 = nil
                end
                local Reject = EggLocalHits.Reject
                local v76 = if typeof(v75) == "number" then v75 else nil
                Reject(v74, v76)
            end)
        end
    end)
    task.spawn(function() -- line 619 | captures: ReplicatedStorage, EggLocalHits
        local v77 = ReplicatedStorage:WaitForChild("EggHitConfirmed", 30)
        if v77 and v77:IsA("RemoteEvent") then
            v77.OnClientEvent:Connect(function(v78, v79, v80) -- line 624 | captures: EggLocalHits
                if not (typeof(v78) == "Instance" and v78:IsA("BasePart") and typeof(v80) == "number") then
                    return
                end
                local Confirm = EggLocalHits.Confirm
                local v81 = if typeof(v79) == "number" then v79 else nil
                Confirm(v78, v81, v80)
            end)
        end
    end)
end

return v1
