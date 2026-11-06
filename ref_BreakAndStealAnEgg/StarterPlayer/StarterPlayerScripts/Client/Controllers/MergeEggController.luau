-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local EggTypeAnimController = require(script.Parent.EggTypeAnimController)
local MergeEggHatch = require(script.Parent.MergeEggHatch)
local MergeEggVFX = require(script.Parent.MergeEggVFX)
local EggCullQuality = require(script.Parent.Parent.Modules.EggCullQuality)
local EggViewFrustum = require(script.Parent.Parent.Modules.EggViewFrustum)
local EggTimerVisibility = require(script.Parent.Parent.Modules.EggTimerVisibility)
local PlaceClickRay = require(script.Parent.Parent.Modules.PlaceClickRay)
local v1 = {}
local LocalPlayer = Players.LocalPlayer

local function fireRemote(v2, ...) -- line 56 | captures: ReplicatedStorage, MergeConfig
    local v3 = ReplicatedStorage:FindFirstChild(MergeConfig.RemoteName)
    if v3 and v3:IsA("RemoteEvent") then
        v3:FireServer(v2, ...)
    end
end

local v4 = {}
local v5 = { __mode = "k" }
local v6 = setmetatable(v4, v5)

local function bindEggTool(v7) -- line 65 | captures: PlaceClickRay, LocalPlayer, fireRemote, v6
    if not v7:IsA("Tool") or v6[v7] then
        return
    end
    v6[v7] = true
    v7.Activated:Connect(function() -- line 70 | captures: v7, PlaceClickRay, LocalPlayer, fireRemote
        if not v7:IsDescendantOf(LocalPlayer.Character or v7) and v7.Parent ~= LocalPlayer:FindFirstChild("Backpack") then
            return
        end
        local v8 = PlaceClickRay.Get()
        if v8 then
            fireRemote("PlaceEgg", v7, v8)
        end
    end)
end

local v9 = {}

local function readEgg(v10) -- line 99 | captures: MergeConfig
    local v11, v12 = MergeConfig.RemainingSeconds(v10)
    local v13 = if v10:GetAttribute("Ready") == true then true else v11 <= 0
    return v11, v12, v13
end

local function partsReady(v14) -- line 106
    if v14.PrimaryPart == nil then
        return false
    end
    local PartCount = v14:GetAttribute("PartCount")
    local AttachmentCount = v14:GetAttribute("AttachmentCount")
    if typeof(PartCount) == "number" or typeof(AttachmentCount) == "number" then
        local v15 = 0
        local v16 = 0
        for v17, v18 in v14:GetDescendants() do
            if v18:IsA("BasePart") then
                v15 += 1
            elseif v18:IsA("Attachment") then
                v16 += 1
            end
        end
        if typeof(PartCount) ~= "number" or PartCount <= v15 then
            if typeof(AttachmentCount) == "number" then
                return AttachmentCount <= v16
            end
            return true
        end
        return false
    end
    return true
end

local function addEgg(v19) -- line 131 | captures: CollectionService, MergeConfig, MergeEggVFX, v9, partsReady
    if v19:IsA("Model") and not v9[v19] then
        task.spawn(function() -- line 142 | captures: v19, CollectionService, MergeConfig, MergeEggVFX, v9, partsReady
            local v20 = os.clock() + 10
            while v19.Parent and not partsReady(v19) and os.clock() < v20 do
                task.wait(0.1)
            end
            if v19.Parent ~= nil and not v9[v19] and v19.PrimaryPart ~= nil and CollectionService:HasTag(v19, MergeConfig.PlacedEggTag) then
                local v21 = MergeEggVFX.Attach(v19)
                if v21 then
                    local v22, v23 = MergeConfig.RemainingSeconds(v19)
                    local v24 = if v19:GetAttribute("Ready") == true then true else v22 <= 0
                    if v24 then
                        v21:BeginReady(true)
                    elseif not (v23 > 0 and v23 - 2 < v22) then
                        v21:BeginGrowing()
                    else
                        v21:BeginPlace()
                    end
                    v9[v19] = {
                        nextFarUpdate = 0,
                        handle = v21,
                        wasReady = v24,
                        lastRemaining = v22
                    }
                end
            end
        end)
    end
end

local function removeEgg(v25) -- line 171 | captures: v9
    local v26 = v9[v25]
    if v26 then
        v9[v25] = nil
        v26.handle:Destroy()
    end
end

function v1.Start() -- line 180 | captures: CollectionService, Players, ReplicatedStorage, RunService, Workspace, MergeConfig, EggTypeAnimController, MergeEggHatch, MergeEggVFX, EggCullQuality, EggViewFrustum, EggTimerVisibility, PlaceClickRay, LocalPlayer, fireRemote, v6, bindEggTool, v9, partsReady, addEgg, removeEgg
    for v27, v28 in CollectionService:GetTagged(MergeConfig.EggToolTag) do
        if v28:IsA("Tool") and not v6[v28] then
            v6[v28] = true
            local Activated = v28.Activated
            local v29 = v28
            Activated:Connect(function() -- line 70 | captures: v29, PlaceClickRay, LocalPlayer, fireRemote
                if not v29:IsDescendantOf(LocalPlayer.Character or v29) and v29.Parent ~= LocalPlayer:FindFirstChild("Backpack") then
                    return
                end
                local v30 = PlaceClickRay.Get()
                if v30 then
                    fireRemote("PlaceEgg", v29, v30)
                end
            end)
        end
    end
    CollectionService:GetInstanceAddedSignal(MergeConfig.EggToolTag):Connect(bindEggTool)

    local function lockForeignPrompt(v31) -- line 192 | captures: LocalPlayer
        if v31:IsA("ProximityPrompt") then
            local ReservedUserId = v31:GetAttribute("ReservedUserId")
            if typeof(ReservedUserId) == "number" and ReservedUserId ~= LocalPlayer.UserId then
                v31.Enabled = false
            end
        end
    end

    for v32, v33 in CollectionService:GetTagged(MergeConfig.OwnerPromptTag) do
        if v33:IsA("ProximityPrompt") then
            local ReservedUserId = v33:GetAttribute("ReservedUserId")
            if typeof(ReservedUserId) == "number" and ReservedUserId ~= LocalPlayer.UserId then
                v33.Enabled = false
            end
        end
    end
    CollectionService:GetInstanceAddedSignal(MergeConfig.OwnerPromptTag):Connect(lockForeignPrompt)
    for v34, v35 in CollectionService:GetTagged(MergeConfig.PlacedEggTag) do
        if v35:IsA("Model") and not v9[v35] then
            local spawn = task.spawn
            local v36 = v35
            spawn(function() -- line 142 | captures: v36, CollectionService, MergeConfig, MergeEggVFX, v9, partsReady
                local v37 = os.clock() + 10
                while v36.Parent and not partsReady(v36) and os.clock() < v37 do
                    task.wait(0.1)
                end
                if v36.Parent ~= nil and not v9[v36] and v36.PrimaryPart ~= nil and CollectionService:HasTag(v36, MergeConfig.PlacedEggTag) then
                    local v38 = MergeEggVFX.Attach(v36)
                    if v38 then
                        local v39, v40 = MergeConfig.RemainingSeconds(v36)
                        local v41 = if v36:GetAttribute("Ready") == true then true else v39 <= 0
                        if v41 then
                            v38:BeginReady(true)
                        elseif not (v40 > 0 and v40 - 2 < v39) then
                            v38:BeginGrowing()
                        else
                            v38:BeginPlace()
                        end
                        v9[v36] = {
                            nextFarUpdate = 0,
                            handle = v38,
                            wasReady = v41,
                            lastRemaining = v39
                        }
                    end
                end
            end)
        end
    end
    CollectionService:GetInstanceAddedSignal(MergeConfig.PlacedEggTag):Connect(addEgg)
    CollectionService:GetInstanceRemovedSignal(MergeConfig.PlacedEggTag):Connect(removeEgg)
    task.spawn(function() -- line 217 | captures: CollectionService, Players, ReplicatedStorage, Workspace, MergeConfig, EggTypeAnimController, MergeEggHatch, v9
        local v42 = ReplicatedStorage:WaitForChild(MergeConfig.RemoteName, 30)
        if v42 and v42:IsA("RemoteEvent") then
            v42.OnClientEvent:Connect(function(v43, v44, v45, v46, v47, v48) -- line 222 | captures: CollectionService, Players, Workspace, MergeConfig, EggTypeAnimController, MergeEggHatch, v9
                if v43 == "HatchAnim" and typeof(v44) == "Instance" and v44:IsA("Model") and typeof(v45) == "string" and typeof(v46) == "number" and typeof(v47) == "number" then
                    local v49 = v9[v44]
                    if v49 then
                        v9[v44] = nil
                        v49.handle:Destroy()
                    end
                else
                    return
                end
                local v50
                if v47 == Players.LocalPlayer.UserId then
                    v50 = true
                else
                    local CurrentCamera = Workspace.CurrentCamera
                    local v51, v52 = pcall(v44.GetPivot, v44)
                    if CurrentCamera and v51 then
                        v50 = not ((v52.Position - CurrentCamera.CFrame.Position).Magnitude > 250)
                    else
                        v50 = false
                    end
                end
                if not v50 then
                    return
                end
                local v53, v54 = pcall(v44.Clone, v44)
                if not v53 or not v54 then
                    return
                end
                CollectionService:RemoveTag(v54, MergeConfig.PlacedEggTag)
                for v55, v56 in v54:GetDescendants() do
                    if v56:IsA("ProximityPrompt") then
                        v56:Destroy()
                    end
                end
                v54.Parent = v44.Parent or Workspace
                EggTypeAnimController.Continue(v44, v54)
                local Play = MergeEggHatch.Play
                local v57 = {
                    Egg = v54,
                    Name = v45,
                    Kg = v46,
                    OwnerUserId = v47
                }
                if typeof(v48) == "string" then
                    v57.Variant = v48
                else
                    v57.Variant = nil
                end
                Play(v57)
            end)
        end
    end)
    RunService.Heartbeat:Connect(function() -- line 269 | captures: Workspace, MergeConfig, MergeEggVFX, EggCullQuality, EggViewFrustum, EggTimerVisibility, v9
        local v58 = os.clock()
        local CurrentCamera = Workspace.CurrentCamera
        local v59 = if CurrentCamera then CurrentCamera.CFrame.Position else nil
        for v60, v61 in v9 do
            if v60.Parent == nil then
                local v62 = v9[v60]
                if v62 then
                    v9[v60] = nil
                    v62.handle:Destroy()
                end
            else
                local v63, v64 = MergeConfig.RemainingSeconds(v60)
                if (v60:GetAttribute("Ready") == true or v63 <= 0) and not v61.wasReady then
                    v61.wasReady = true
                    v61.handle:PlayReadySound()
                    if v61.lastRemaining > 1.5 then
                        v61.handle:BeginSkip()
                    else
                        v61.handle:BeginReady()
                    end
                end
                v61.lastRemaining = v63
                local v65 = if v59 then (v61.handle.baseCenter - v59).Magnitude <= EggCullQuality.Distance(MergeEggVFX.Config.CullDistance) else true
                if v65 and not EggViewFrustum.IsSphereVisible(v61.handle.baseCenter, 25) then
                    v65 = false
                end
                local Phase = v61.handle.Phase
                if v65 then
                    v61.handle:SetTimerVisible(EggTimerVisibility.ShouldShow(v60))
                    local v66 = v60:GetAttribute("StartScale") or 1
                    local TargetScale = v60:GetAttribute("TargetScale") or MergeConfig.EggGrowthRatio
                    local v67
                    if v64 > 0 then
                        local v68 = 1 - v63 / v64
                        v67 = math.clamp(v68, 0, 1)
                    else
                        v67 = 1
                    end
                    local v69 = TargetScale / v66
                    local v70 = v67 * (math.max(v69, 1) - 1) + 1
                    v61.handle:Update(v58, v70, v63, v65)
                elseif Phase == "Growing" or Phase == "Ready" then
                    if not (v58 < v61.nextFarUpdate) then
                        v61.nextFarUpdate = v58 + 0.5
                        v61.handle:SetTimerVisible(EggTimerVisibility.ShouldShow(v60))
                        local v71 = v60:GetAttribute("StartScale") or 1
                        local TargetScale = v60:GetAttribute("TargetScale") or MergeConfig.EggGrowthRatio
                        local v72
                        if v64 > 0 then
                            local v73 = 1 - v63 / v64
                            v72 = math.clamp(v73, 0, 1)
                        else
                            v72 = 1
                        end
                        local v74 = TargetScale / v71
                        local v75 = v72 * (math.max(v74, 1) - 1) + 1
                        v61.handle:Update(v58, v75, v63, v65)
                    end
                else
                    v61.handle:SetTimerVisible(EggTimerVisibility.ShouldShow(v60))
                    local v76 = v60:GetAttribute("StartScale") or 1
                    local TargetScale = v60:GetAttribute("TargetScale") or MergeConfig.EggGrowthRatio
                    local v77
                    if v64 > 0 then
                        local v78 = 1 - v63 / v64
                        v77 = math.clamp(v78, 0, 1)
                    else
                        v77 = 1
                    end
                    local v79 = TargetScale / v76
                    local v80 = v77 * (math.max(v79, 1) - 1) + 1
                    v61.handle:Update(v58, v80, v63, v65)
                end
            end
        end
    end)
end

return v1
