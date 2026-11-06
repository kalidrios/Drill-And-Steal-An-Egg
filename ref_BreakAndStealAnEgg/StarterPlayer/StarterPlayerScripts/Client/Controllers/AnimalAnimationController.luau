-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local AnimalAnimator = require(ReplicatedStorage.Shared.AnimalAnimator)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local WaitFor = require(ReplicatedStorage.Shared.WaitFor)
local PlacedAnimalViewCullController = require(script.Parent.PlacedAnimalViewCullController)
local ZonePlotCullController = require(script.Parent.ZonePlotCullController)
local LocalModelHider = require(script.Parent.Parent.Modules.LocalModelHider)
local v1 = {}
local v2 = {}

local function getRoot(v3) -- line 75
    local v4 = v3.PrimaryPart or v3:FindFirstChild("HumanoidRootPart")
    if v4 and v4:IsA("BasePart") then
        return v4
    end
    for v5, v6 in v3:GetDescendants() do
        if v6:IsA("BasePart") then
            return v6
        end
    end
    return nil
end

local function countBones(v7) -- line 90
    local v8 = 0
    for v9, v10 in v7:GetDescendants() do
        if v10:IsA("Bone") then
            v8 += 1
        end
    end
    return v8
end

local function hasBody(v11) -- line 104
    if v11.PrimaryPart then
        return true
    end
    return v11:FindFirstChildWhichIsA("BasePart", true) ~= nil
end

local function hasAnimDriver(v12) -- line 116
    if v12:FindFirstChildOfClass("AnimationController") == nil then
        return v12:FindFirstChildOfClass("Humanoid") ~= nil
    end
    return true
end

local function waitForSkeleton(v13) -- line 126 | captures: EggRewards, WaitFor, countBones
    local v14 = v13:GetAttribute("AnimalName") or v13.Name
    local v15
    if typeof(v14) == "string" then
        v15 = EggRewards.FindAnimalTemplate(v14)
    end
    local v16
    if v15 then
        v16 = countBones(v15)
    else
        v16 = 0
    end
    if v16 <= 0 then
        return
    end
    local v17 = {}
    local v18 = 0
    local v19 = 0

    local function addBone(v20) -- line 148 | captures: v18, v19, v17
        if not v20:IsA("Bone") or v17[v20] then
            return
        end
        v17[v20] = true
        v18 += 1
        v19 += 1
    end

    local v21 = v13.DescendantAdded:Connect(addBone)
    for v22, v23 in v13:GetDescendants() do
        if v23:IsA("Bone") and not v17[v23] then
            v17[v23] = true
            v18 += 1
            v19 += 1
        end
    end
    local v24 = os.clock() + 5
    local v25 = 0
    local v26 = v19
    while true do
        local v27, v28, v29
        if os.clock() < v24 and v18 < v16 then
            WaitFor.Frame()
            if v19 == v26 then
                local v30 = v25 + 1
                if v30 >= 4 and v18 > 0 then
                    v29 = true
                else
                    v28 = v30
                    v27 = v26
                    v29 = false
                end
            else
                v28 = 0
                v27 = v19
                v29 = false
            end
        else
            v29 = true
        end
        if v29 then
            break
        end
        v25 = v28
        v26 = v27
    end
    v21:Disconnect()
end

local function teardown(v31) -- line 185 | captures: v2
    local v32 = v2[v31]
    if v32 == nil then
        return
    end
    v2[v31] = nil
    if v32.AncestryWatch then
        v32.AncestryWatch:Disconnect()
    end
    if v32.DestroyWatch then
        v32.DestroyWatch:Disconnect()
    end
    if v32.AttrWatch then
        v32.AttrWatch:Disconnect()
    end
    if v32.Animator then
        v32.Animator:Destroy()
    end
end

local function applyStatic(v33) -- line 208
    if v33.Animator ~= nil and v33.Static then
        if v33.Model:IsDescendantOf(workspace) then
            v33.Animator:PlayIdle()
        else
            v33.Animator:Stop()
        end
    end
end

local function build(v34) -- line 221 | captures: AnimalAnimator, WaitFor, v2, getRoot, waitForSkeleton
    local Model = v34.Model
    if not WaitFor.Until(function() -- line 229 | captures: Model
            if Model.PrimaryPart then
                return true
            end
            return Model:FindFirstChildWhichIsA("BasePart", true) ~= nil
        end, 10) then
        return
    end
    if Model:FindFirstChildOfClass("AnimationController") == nil and Model:FindFirstChildOfClass("Humanoid") == nil then
        WaitFor.Until(function() -- line 238 | captures: Model
            if Model:FindFirstChildOfClass("AnimationController") == nil then
                return Model:FindFirstChildOfClass("Humanoid") ~= nil
            end
            return true
        end, 1)
    end
    waitForSkeleton(Model)
    if v2[Model] == v34 then
        local v35 = AnimalAnimator.new(Model, v34.Config)
        if v2[Model] == v34 then
            v34.Animator = v35
            v34.Root = v34.Root or getRoot(Model)
            if v34.Static then
                if v34.AncestryWatch == nil then
                    local AncestryChanged = Model.AncestryChanged
                    v34.AncestryWatch = AncestryChanged:Connect(function() -- line 262 | captures: v34
                        if v34.Animator ~= nil then
                            if v34.Static then
                                if v34.Model:IsDescendantOf(workspace) then
                                    v34.Animator:PlayIdle()
                                    return
                                end
                            else
                                return
                            end
                            v34.Animator:Stop()
                        end
                    end)
                end
                if v34.Animator ~= nil then
                    if v34.Static then
                        if v34.Model:IsDescendantOf(workspace) then
                            v34.Animator:PlayIdle()
                            return
                        end
                    else
                        return
                    end
                    v34.Animator:Stop()
                end
            end
        else
            v35:Destroy()
        end
    end
end

local function startBuild(v36) -- line 273 | captures: build
    if v36.Building then
        return
    end
    v36.Building = true
    v36.Attempts = (v36.Attempts or 0) + 1
    task.spawn(function() -- line 279 | captures: v36, build
        local v37, v38 = pcall(build, v36)
        v36.Building = nil
        if not v37 then
            warn((("[AnimalAnimationController] build failed for %*: %*"):format(v36.Model.Name, v38)))
        end
    end)
end

local function setup(v39) -- line 288 | captures: v2, teardown, build
    local AnimationBaseWalkSpeed, v40, v41, v42
    if v39:IsA("Model") then
        if v2[v39] then
            v42 = true
        else
            AnimationBaseWalkSpeed = v39:GetAttribute("AnimationBaseWalkSpeed")
            v40 = {
                Animator = nil,
                AncestryWatch = nil,
                DestroyWatch = nil,
                AttrWatch = nil,
                Root = nil,
                Model = v39
            }
            v41 = v39:GetAttribute("AnimStatic") == true
            v42 = false
        end
    else
        v42 = true
    end
    if v42 then
        return
    end
    v40.Static = v41
    local v43 = {}
    if typeof(AnimationBaseWalkSpeed) ~= "number" then
        AnimationBaseWalkSpeed = nil
    end
    v43.AnimationBaseWalkSpeed = AnimationBaseWalkSpeed
    v40.Config = v43
    v40.HoldIdle = v39:GetAttribute("ChaseState") == "WindUp"
    v2[v39] = v40
    local AttributeChanged = v39.AttributeChanged
    local v44 = v40
    v40.AttrWatch = AttributeChanged:Connect(function(v45) -- line 326 | captures: v39, v44
        if v45 == "AnimStatic" then
            local v46 = v39:GetAttribute("AnimStatic") == true
            if v46 == v44.Static then
                return
            end
            v44.Static = v46
            v44.Moving = nil
            if v46 then
                if v44.AncestryWatch == nil then
                    v44.AncestryWatch = v39.AncestryChanged:Connect(function() -- line 336 | captures: v44
                        if v44.Animator ~= nil then
                            if v44.Static then
                                if v44.Model:IsDescendantOf(workspace) then
                                    v44.Animator:PlayIdle()
                                    return
                                end
                            else
                                return
                            end
                            v44.Animator:Stop()
                        end
                    end)
                end
                if v44.Animator ~= nil and v44.Static then
                    if v44.Model:IsDescendantOf(workspace) then
                        v44.Animator:PlayIdle()
                    else
                        v44.Animator:Stop()
                    end
                end
            end
        elseif v45 == "AnimationBaseWalkSpeed" then
            local AnimationBaseWalkSpeed = v39:GetAttribute("AnimationBaseWalkSpeed")
            if typeof(AnimationBaseWalkSpeed) == "number" then
                v44.Config.AnimationBaseWalkSpeed = AnimationBaseWalkSpeed
            end
        elseif v45 == "ChaseState" then
            local v47 = v39:GetAttribute("ChaseState") == "WindUp"
            if v47 ~= v44.HoldIdle then
                v44.HoldIdle = v47
                v44.Moving = nil
            end
        end
    end)
    v40.DestroyWatch = v39.Destroying:Once(function() -- line 364 | captures: v39, teardown
        teardown(v39)
    end)
    if v40.Building then
        return
    end
    v40.Building = true
    v40.Attempts = (v40.Attempts or 0) + 1
    task.spawn(function() -- line 279 | captures: v44, build
        local v48, v49 = pcall(build, v44)
        v44.Building = nil
        if not v48 then
            warn((("[AnimalAnimationController] build failed for %*: %*"):format(v44.Model.Name, v49)))
        end
    end)
end

local function sweepTag() -- line 376 | captures: CollectionService, v2, build, setup
    for v50, v51 in CollectionService:GetTagged("AnimatedAnimal") do
        if v51:IsA("Model") and v51:IsDescendantOf(game) then
            local v52 = v2[v51]
            if v52 == nil then
                setup(v51)
            elseif v52.Animator == nil and not v52.Building and ((v52.Attempts or 0) < 3 or v51.PrimaryPart or v51:FindFirstChildWhichIsA("BasePart", true) ~= nil) and not v52.Building then
                v52.Building = true
                v52.Attempts = (v52.Attempts or 0) + 1
                task.spawn(function() -- line 279 | captures: v52, build
                    local v53, v54 = pcall(build, v52)
                    v52.Building = nil
                    if not v53 then
                        warn((("[AnimalAnimationController] build failed for %*: %*"):format(v52.Model.Name, v54)))
                    end
                end)
            end
        end
    end
end

function v1.Start() -- line 398 | captures: CollectionService, RunService, PlacedAnimalViewCullController, ZonePlotCullController, LocalModelHider, v2, getRoot, teardown, setup, sweepTag
    for v55, v56 in CollectionService:GetTagged("AnimatedAnimal") do
        setup(v56)
    end
    CollectionService:GetInstanceAddedSignal("AnimatedAnimal"):Connect(setup)
    CollectionService:GetInstanceRemovedSignal("AnimatedAnimal"):Connect(teardown)
    local v57 = 0
    local v58 = 0
    local v59 = 0
    local v60 = 0
    RunService.Heartbeat:Connect(function(v61) -- line 438 | captures: v57, v58, v59, v60, CollectionService, PlacedAnimalViewCullController, ZonePlotCullController, LocalModelHider, v2, getRoot, teardown, sweepTag
        v57 += v61
        local v62 = v57 >= 2
        if v62 then
            v57 = 0
        end
        v58 += v61
        local v63 = v58 >= 0.5
        if v63 then
            v58 = 0
        end
        v60 += v61
        local v64 = v60 >= 0.1
        if v64 then
            v60 = 0
        end
        local CurrentCamera = workspace.CurrentCamera
        local v65 = CurrentCamera and CurrentCamera.CFrame.Position
        v59 += v61
        if v59 >= 2 then
            v59 = 0
            task.spawn(sweepTag)
        end
        local v66 = os.clock()
        for v67, v68 in v2 do
            if v63 then
                local v69 = v67.Parent == nil
                if not v69 and v62 then
                    v69 = not v67:IsDescendantOf(game)
                end
                if v69 then
                    v68.OrphanSince = v68.OrphanSince or v66
                    if v66 - v68.OrphanSince >= 5 then
                        teardown(v67)
                    end
                else
                    if v68.OrphanSince ~= nil and v62 then
                        v68.OrphanSince = nil
                    end
                    local Animator = v68.Animator
                    if Animator ~= nil then
                        if v68.Static then
                            if v62 and v67:IsDescendantOf(workspace) then
                                Animator:PlayIdle()
                            end
                        else
                            local Root = v68.Root
                            local Parent, v70
                            if Root then
                                Parent = Root.Parent
                            else
                                v70 = getRoot(v67)
                                v68.Root = v70
                            end
                            if Root and Parent or not Root and v70 then
                                Root = Root or v70
                                if v65 then
                                    if not v68.Guard then
                                        v68.Guard = CollectionService:HasTag(v67, "ZoneGuard")
                                    end
                                    local Magnitude = (Root.Position - v65).Magnitude
                                    local v71
                                    if Magnitude < 150 then
                                        v71 = 0
                                    elseif Magnitude < 350 then
                                        v71 = 1
                                    elseif Magnitude < 1000 then
                                        v71 = 2
                                    else
                                        v71 = 3
                                    end
                                    if v68.Guard and v71 >= 3 then
                                        v71 = 2
                                    end
                                    v68.Lod = v71
                                end
                                local v72 = not v68.Guard
                                if v72 then
                                    if (v68.Lod or 0) >= 3 then
                                        v72 = true
                                    else
                                        v72 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                    end
                                end
                                if v72 then
                                    if not v68.Paused then
                                        v68.Paused = true
                                        v68.Moving = nil
                                        Animator:Stop()
                                    end
                                else
                                    if v68.Paused then
                                        v68.Paused = false
                                        v68.Moving = nil
                                    end
                                    if (v68.Lod or 0) < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                    end
                                    local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                    if typeof(ClientMoveSpeed) ~= "number" then
                                        local AssemblyLinearVelocity = Root.AssemblyLinearVelocity
                                        local X = AssemblyLinearVelocity.X
                                        local Z = AssemblyLinearVelocity.Z
                                        ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                    end
                                    local v73 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                    local v74 = v73 ~= v68.Moving
                                    v68.Moving = v73
                                    if v73 then
                                        Animator:PlayRun(ClientMoveSpeed)
                                    else
                                        Animator:PlayIdle()
                                    end
                                end
                            elseif Root then
                                v70 = getRoot(v67)
                                v68.Root = v70
                                if v70 then
                                    if v65 then
                                        if not v68.Guard then
                                            v68.Guard = CollectionService:HasTag(v67, "ZoneGuard")
                                        end
                                        local Magnitude = (v70.Position - v65).Magnitude
                                        local v75
                                        if Magnitude < 150 then
                                            v75 = 0
                                        elseif Magnitude < 350 then
                                            v75 = 1
                                        elseif Magnitude < 1000 then
                                            v75 = 2
                                        else
                                            v75 = 3
                                        end
                                        if v68.Guard and v75 >= 3 then
                                            v75 = 2
                                        end
                                        v68.Lod = v75
                                    end
                                    local v76 = not v68.Guard
                                    if v76 then
                                        if (v68.Lod or 0) >= 3 then
                                            v76 = true
                                        else
                                            v76 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                        end
                                    end
                                    if v76 then
                                        if not v68.Paused then
                                            v68.Paused = true
                                            v68.Moving = nil
                                            Animator:Stop()
                                        end
                                    else
                                        if v68.Paused then
                                            v68.Paused = false
                                            v68.Moving = nil
                                        end
                                        if (v68.Lod or 0) < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                        end
                                        local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                        if typeof(ClientMoveSpeed) ~= "number" then
                                            local AssemblyLinearVelocity = v70.AssemblyLinearVelocity
                                            local X = AssemblyLinearVelocity.X
                                            local Z = AssemblyLinearVelocity.Z
                                            ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                        end
                                        local v77 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                        local v78 = v77 ~= v68.Moving
                                        v68.Moving = v77
                                        if v77 then
                                            Animator:PlayRun(ClientMoveSpeed)
                                        else
                                            Animator:PlayIdle()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            elseif v62 then
                if v67.Parent == nil or not v67:IsDescendantOf(game) then
                    v68.OrphanSince = v68.OrphanSince or v66
                    if v66 - v68.OrphanSince >= 5 then
                        teardown(v67)
                    end
                else
                    if v68.OrphanSince ~= nil then
                        v68.OrphanSince = nil
                    end
                    local Animator = v68.Animator
                    if Animator ~= nil then
                        if v68.Static then
                            if v67:IsDescendantOf(workspace) then
                                Animator:PlayIdle()
                            end
                        else
                            local v79 = v68.Lod or 0
                            if v79 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                v79 = 2
                            end
                            if v79 == 1 then
                                if v64 and not (v79 >= 2) then
                                    local Root = v68.Root
                                    if Root then
                                        local Parent = Root.Parent
                                        if Parent then
                                            local v80 = not v68.Guard
                                            if v80 then
                                                if (v68.Lod or 0) >= 3 then
                                                    v80 = true
                                                else
                                                    v80 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                                end
                                            end
                                            if v80 then
                                                if not v68.Paused then
                                                    v68.Paused = true
                                                    v68.Moving = nil
                                                    Animator:Stop()
                                                end
                                            else
                                                if v68.Paused then
                                                    v68.Paused = false
                                                    v68.Moving = nil
                                                end
                                                local v81 = v68.Lod or 0
                                                if v81 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                                    v81 = 2
                                                end
                                                if v81 ~= 2 then
                                                    local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                                    if typeof(ClientMoveSpeed) ~= "number" then
                                                        local AssemblyLinearVelocity = Root.AssemblyLinearVelocity
                                                        local X = AssemblyLinearVelocity.X
                                                        local Z = AssemblyLinearVelocity.Z
                                                        ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                                    end
                                                    local v82 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                                    local v83 = v82 ~= v68.Moving
                                                    v68.Moving = v82
                                                    if v82 then
                                                        Animator:PlayRun(ClientMoveSpeed)
                                                    elseif v83 then
                                                        Animator:PlayIdle()
                                                    end
                                                end
                                            end
                                        else
                                            local v84 = getRoot(v67)
                                            v68.Root = v84
                                            if v84 then
                                                local v85 = not v68.Guard
                                                if v85 then
                                                    if (v68.Lod or 0) >= 3 then
                                                        v85 = true
                                                    else
                                                        v85 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                                    end
                                                end
                                                if v85 then
                                                    if not v68.Paused then
                                                        v68.Paused = true
                                                        v68.Moving = nil
                                                        Animator:Stop()
                                                    end
                                                else
                                                    if v68.Paused then
                                                        v68.Paused = false
                                                        v68.Moving = nil
                                                    end
                                                    local v86 = v68.Lod or 0
                                                    if v86 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                                        v86 = 2
                                                    end
                                                    if v86 ~= 2 then
                                                        local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                                        if typeof(ClientMoveSpeed) ~= "number" then
                                                            local AssemblyLinearVelocity = v84.AssemblyLinearVelocity
                                                            local X = AssemblyLinearVelocity.X
                                                            local Z = AssemblyLinearVelocity.Z
                                                            ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                                        end
                                                        local v87 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                                        local v88 = v87 ~= v68.Moving
                                                        v68.Moving = v87
                                                        if v87 then
                                                            Animator:PlayRun(ClientMoveSpeed)
                                                        elseif v88 then
                                                            Animator:PlayIdle()
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        local v89 = getRoot(v67)
                                        v68.Root = v89
                                        if v89 then
                                            local v90 = not v68.Guard
                                            if v90 then
                                                if (v68.Lod or 0) >= 3 then
                                                    v90 = true
                                                else
                                                    v90 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                                end
                                            end
                                            if v90 then
                                                if not v68.Paused then
                                                    v68.Paused = true
                                                    v68.Moving = nil
                                                    Animator:Stop()
                                                end
                                            else
                                                if v68.Paused then
                                                    v68.Paused = false
                                                    v68.Moving = nil
                                                end
                                                local v91 = v68.Lod or 0
                                                if v91 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                                    v91 = 2
                                                end
                                                if v91 ~= 2 then
                                                    local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                                    if typeof(ClientMoveSpeed) ~= "number" then
                                                        local AssemblyLinearVelocity = v89.AssemblyLinearVelocity
                                                        local X = AssemblyLinearVelocity.X
                                                        local Z = AssemblyLinearVelocity.Z
                                                        ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                                    end
                                                    local v92 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                                    local v93 = v92 ~= v68.Moving
                                                    v68.Moving = v92
                                                    if v92 then
                                                        Animator:PlayRun(ClientMoveSpeed)
                                                    elseif v93 then
                                                        Animator:PlayIdle()
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            elseif not (v79 >= 2) then
                                local Root = v68.Root
                                if Root then
                                    local Parent = Root.Parent
                                    if Parent then
                                        local v94 = not v68.Guard
                                        if v94 then
                                            if (v68.Lod or 0) >= 3 then
                                                v94 = true
                                            else
                                                v94 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                            end
                                        end
                                        if v94 then
                                            if not v68.Paused then
                                                v68.Paused = true
                                                v68.Moving = nil
                                                Animator:Stop()
                                            end
                                        else
                                            if v68.Paused then
                                                v68.Paused = false
                                                v68.Moving = nil
                                            end
                                            local v95 = v68.Lod or 0
                                            if v95 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                                v95 = 2
                                            end
                                            if v95 == 1 then
                                                if v64 and v95 ~= 2 then
                                                    local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                                    if typeof(ClientMoveSpeed) ~= "number" then
                                                        local AssemblyLinearVelocity = Root.AssemblyLinearVelocity
                                                        local X = AssemblyLinearVelocity.X
                                                        local Z = AssemblyLinearVelocity.Z
                                                        ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                                    end
                                                    local v96 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                                    local v97 = v96 ~= v68.Moving
                                                    v68.Moving = v96
                                                    if v96 then
                                                        Animator:PlayRun(ClientMoveSpeed)
                                                    elseif v97 then
                                                        Animator:PlayIdle()
                                                    end
                                                end
                                            elseif v95 ~= 2 then
                                                local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                                if typeof(ClientMoveSpeed) ~= "number" then
                                                    local AssemblyLinearVelocity = Root.AssemblyLinearVelocity
                                                    local X = AssemblyLinearVelocity.X
                                                    local Z = AssemblyLinearVelocity.Z
                                                    ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                                end
                                                local v98 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                                local v99 = v98 ~= v68.Moving
                                                v68.Moving = v98
                                                if v98 then
                                                    Animator:PlayRun(ClientMoveSpeed)
                                                elseif v99 then
                                                    Animator:PlayIdle()
                                                end
                                            end
                                        end
                                    else
                                        local v100 = getRoot(v67)
                                        v68.Root = v100
                                        if v100 then
                                            local v101 = not v68.Guard
                                            if v101 then
                                                if (v68.Lod or 0) >= 3 then
                                                    v101 = true
                                                else
                                                    v101 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                                end
                                            end
                                            if v101 then
                                                if not v68.Paused then
                                                    v68.Paused = true
                                                    v68.Moving = nil
                                                    Animator:Stop()
                                                end
                                            else
                                                if v68.Paused then
                                                    v68.Paused = false
                                                    v68.Moving = nil
                                                end
                                                local v102 = v68.Lod or 0
                                                if v102 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                                    v102 = 2
                                                end
                                                if v102 == 1 then
                                                    if v64 and v102 ~= 2 then
                                                        local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                                        if typeof(ClientMoveSpeed) ~= "number" then
                                                            local AssemblyLinearVelocity = v100.AssemblyLinearVelocity
                                                            local X = AssemblyLinearVelocity.X
                                                            local Z = AssemblyLinearVelocity.Z
                                                            ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                                        end
                                                        local v103 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                                        local v104 = v103 ~= v68.Moving
                                                        v68.Moving = v103
                                                        if v103 then
                                                            Animator:PlayRun(ClientMoveSpeed)
                                                        elseif v104 then
                                                            Animator:PlayIdle()
                                                        end
                                                    end
                                                elseif v102 ~= 2 then
                                                    local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                                    if typeof(ClientMoveSpeed) ~= "number" then
                                                        local AssemblyLinearVelocity = v100.AssemblyLinearVelocity
                                                        local X = AssemblyLinearVelocity.X
                                                        local Z = AssemblyLinearVelocity.Z
                                                        ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                                    end
                                                    local v105 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                                    local v106 = v105 ~= v68.Moving
                                                    v68.Moving = v105
                                                    if v105 then
                                                        Animator:PlayRun(ClientMoveSpeed)
                                                    elseif v106 then
                                                        Animator:PlayIdle()
                                                    end
                                                end
                                            end
                                        end
                                    end
                                else
                                    local v107 = getRoot(v67)
                                    v68.Root = v107
                                    if v107 then
                                        local v108 = not v68.Guard
                                        if v108 then
                                            if (v68.Lod or 0) >= 3 then
                                                v108 = true
                                            else
                                                v108 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                            end
                                        end
                                        if v108 then
                                            if not v68.Paused then
                                                v68.Paused = true
                                                v68.Moving = nil
                                                Animator:Stop()
                                            end
                                        else
                                            if v68.Paused then
                                                v68.Paused = false
                                                v68.Moving = nil
                                            end
                                            local v109 = v68.Lod or 0
                                            if v109 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                                v109 = 2
                                            end
                                            if v109 == 1 then
                                                if v64 and v109 ~= 2 then
                                                    local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                                    if typeof(ClientMoveSpeed) ~= "number" then
                                                        local AssemblyLinearVelocity = v107.AssemblyLinearVelocity
                                                        local X = AssemblyLinearVelocity.X
                                                        local Z = AssemblyLinearVelocity.Z
                                                        ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                                    end
                                                    local v110 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                                    local v111 = v110 ~= v68.Moving
                                                    v68.Moving = v110
                                                    if v110 then
                                                        Animator:PlayRun(ClientMoveSpeed)
                                                    elseif v111 then
                                                        Animator:PlayIdle()
                                                    end
                                                end
                                            elseif v109 ~= 2 then
                                                local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                                if typeof(ClientMoveSpeed) ~= "number" then
                                                    local AssemblyLinearVelocity = v107.AssemblyLinearVelocity
                                                    local X = AssemblyLinearVelocity.X
                                                    local Z = AssemblyLinearVelocity.Z
                                                    ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                                end
                                                local v112 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                                local v113 = v112 ~= v68.Moving
                                                v68.Moving = v112
                                                if v112 then
                                                    Animator:PlayRun(ClientMoveSpeed)
                                                elseif v113 then
                                                    Animator:PlayIdle()
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            elseif v68.OrphanSince == nil then
                local Animator = v68.Animator
                if Animator ~= nil and not v68.Static then
                    local v114 = v68.Lod or 0
                    if v114 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                        v114 = 2
                    end
                    if v114 == 1 then
                        if v64 and not (v114 >= 2) then
                            local Root = v68.Root
                            if Root then
                                local Parent = Root.Parent
                                if Parent then
                                    local v115 = not v68.Guard
                                    if v115 then
                                        if (v68.Lod or 0) >= 3 then
                                            v115 = true
                                        else
                                            v115 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                        end
                                    end
                                    if v115 then
                                        if not v68.Paused then
                                            v68.Paused = true
                                            v68.Moving = nil
                                            Animator:Stop()
                                        end
                                    else
                                        if v68.Paused then
                                            v68.Paused = false
                                            v68.Moving = nil
                                        end
                                        local v116 = v68.Lod or 0
                                        if v116 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                            v116 = 2
                                        end
                                        if v116 ~= 2 then
                                            local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                            if typeof(ClientMoveSpeed) ~= "number" then
                                                local AssemblyLinearVelocity = Root.AssemblyLinearVelocity
                                                local X = AssemblyLinearVelocity.X
                                                local Z = AssemblyLinearVelocity.Z
                                                ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                            end
                                            local v117 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                            local v118 = v117 ~= v68.Moving
                                            v68.Moving = v117
                                            if v117 then
                                                Animator:PlayRun(ClientMoveSpeed)
                                            elseif v118 then
                                                Animator:PlayIdle()
                                            end
                                        end
                                    end
                                else
                                    local v119 = getRoot(v67)
                                    v68.Root = v119
                                    if v119 then
                                        local v120 = not v68.Guard
                                        if v120 then
                                            if (v68.Lod or 0) >= 3 then
                                                v120 = true
                                            else
                                                v120 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                            end
                                        end
                                        if v120 then
                                            if not v68.Paused then
                                                v68.Paused = true
                                                v68.Moving = nil
                                                Animator:Stop()
                                            end
                                        else
                                            if v68.Paused then
                                                v68.Paused = false
                                                v68.Moving = nil
                                            end
                                            local v121 = v68.Lod or 0
                                            if v121 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                                v121 = 2
                                            end
                                            if v121 ~= 2 then
                                                local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                                if typeof(ClientMoveSpeed) ~= "number" then
                                                    local AssemblyLinearVelocity = v119.AssemblyLinearVelocity
                                                    local X = AssemblyLinearVelocity.X
                                                    local Z = AssemblyLinearVelocity.Z
                                                    ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                                end
                                                local v122 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                                local v123 = v122 ~= v68.Moving
                                                v68.Moving = v122
                                                if v122 then
                                                    Animator:PlayRun(ClientMoveSpeed)
                                                elseif v123 then
                                                    Animator:PlayIdle()
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                local v124 = getRoot(v67)
                                v68.Root = v124
                                if v124 then
                                    local v125 = not v68.Guard
                                    if v125 then
                                        if (v68.Lod or 0) >= 3 then
                                            v125 = true
                                        else
                                            v125 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                        end
                                    end
                                    if v125 then
                                        if not v68.Paused then
                                            v68.Paused = true
                                            v68.Moving = nil
                                            Animator:Stop()
                                        end
                                    else
                                        if v68.Paused then
                                            v68.Paused = false
                                            v68.Moving = nil
                                        end
                                        local v126 = v68.Lod or 0
                                        if v126 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                            v126 = 2
                                        end
                                        if v126 ~= 2 then
                                            local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                            if typeof(ClientMoveSpeed) ~= "number" then
                                                local AssemblyLinearVelocity = v124.AssemblyLinearVelocity
                                                local X = AssemblyLinearVelocity.X
                                                local Z = AssemblyLinearVelocity.Z
                                                ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                            end
                                            local v127 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                            local v128 = v127 ~= v68.Moving
                                            v68.Moving = v127
                                            if v127 then
                                                Animator:PlayRun(ClientMoveSpeed)
                                            elseif v128 then
                                                Animator:PlayIdle()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    elseif not (v114 >= 2) then
                        local Root = v68.Root
                        if Root then
                            local Parent = Root.Parent
                            if Parent then
                                local v129 = not v68.Guard
                                if v129 then
                                    if (v68.Lod or 0) >= 3 then
                                        v129 = true
                                    else
                                        v129 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                    end
                                end
                                if v129 then
                                    if not v68.Paused then
                                        v68.Paused = true
                                        v68.Moving = nil
                                        Animator:Stop()
                                    end
                                else
                                    if v68.Paused then
                                        v68.Paused = false
                                        v68.Moving = nil
                                    end
                                    local v130 = v68.Lod or 0
                                    if v130 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                        v130 = 2
                                    end
                                    if v130 == 1 then
                                        if v64 and v130 ~= 2 then
                                            local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                            if typeof(ClientMoveSpeed) ~= "number" then
                                                local AssemblyLinearVelocity = Root.AssemblyLinearVelocity
                                                local X = AssemblyLinearVelocity.X
                                                local Z = AssemblyLinearVelocity.Z
                                                ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                            end
                                            local v131 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                            local v132 = v131 ~= v68.Moving
                                            v68.Moving = v131
                                            if v131 then
                                                Animator:PlayRun(ClientMoveSpeed)
                                            elseif v132 then
                                                Animator:PlayIdle()
                                            end
                                        end
                                    elseif v130 ~= 2 then
                                        local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                        if typeof(ClientMoveSpeed) ~= "number" then
                                            local AssemblyLinearVelocity = Root.AssemblyLinearVelocity
                                            local X = AssemblyLinearVelocity.X
                                            local Z = AssemblyLinearVelocity.Z
                                            ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                        end
                                        local v133 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                        local v134 = v133 ~= v68.Moving
                                        v68.Moving = v133
                                        if v133 then
                                            Animator:PlayRun(ClientMoveSpeed)
                                        elseif v134 then
                                            Animator:PlayIdle()
                                        end
                                    end
                                end
                            else
                                local v135 = getRoot(v67)
                                v68.Root = v135
                                if v135 then
                                    local v136 = not v68.Guard
                                    if v136 then
                                        if (v68.Lod or 0) >= 3 then
                                            v136 = true
                                        else
                                            v136 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                        end
                                    end
                                    if v136 then
                                        if not v68.Paused then
                                            v68.Paused = true
                                            v68.Moving = nil
                                            Animator:Stop()
                                        end
                                    else
                                        if v68.Paused then
                                            v68.Paused = false
                                            v68.Moving = nil
                                        end
                                        local v137 = v68.Lod or 0
                                        if v137 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                            v137 = 2
                                        end
                                        if v137 == 1 then
                                            if v64 and v137 ~= 2 then
                                                local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                                if typeof(ClientMoveSpeed) ~= "number" then
                                                    local AssemblyLinearVelocity = v135.AssemblyLinearVelocity
                                                    local X = AssemblyLinearVelocity.X
                                                    local Z = AssemblyLinearVelocity.Z
                                                    ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                                end
                                                local v138 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                                local v139 = v138 ~= v68.Moving
                                                v68.Moving = v138
                                                if v138 then
                                                    Animator:PlayRun(ClientMoveSpeed)
                                                elseif v139 then
                                                    Animator:PlayIdle()
                                                end
                                            end
                                        elseif v137 ~= 2 then
                                            local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                            if typeof(ClientMoveSpeed) ~= "number" then
                                                local AssemblyLinearVelocity = v135.AssemblyLinearVelocity
                                                local X = AssemblyLinearVelocity.X
                                                local Z = AssemblyLinearVelocity.Z
                                                ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                            end
                                            local v140 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                            local v141 = v140 ~= v68.Moving
                                            v68.Moving = v140
                                            if v140 then
                                                Animator:PlayRun(ClientMoveSpeed)
                                            elseif v141 then
                                                Animator:PlayIdle()
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            local v142 = getRoot(v67)
                            v68.Root = v142
                            if v142 then
                                local v143 = not v68.Guard
                                if v143 then
                                    if (v68.Lod or 0) >= 3 then
                                        v143 = true
                                    else
                                        v143 = ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v67, ZonePlotCullController.HIDE_REASON)
                                    end
                                end
                                if v143 then
                                    if not v68.Paused then
                                        v68.Paused = true
                                        v68.Moving = nil
                                        Animator:Stop()
                                    end
                                else
                                    if v68.Paused then
                                        v68.Paused = false
                                        v68.Moving = nil
                                    end
                                    local v144 = v68.Lod or 0
                                    if v144 < 2 and PlacedAnimalViewCullController.IsCulled(v67) then
                                        v144 = 2
                                    end
                                    if v144 == 1 then
                                        if v64 and v144 ~= 2 then
                                            local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                            if typeof(ClientMoveSpeed) ~= "number" then
                                                local AssemblyLinearVelocity = v142.AssemblyLinearVelocity
                                                local X = AssemblyLinearVelocity.X
                                                local Z = AssemblyLinearVelocity.Z
                                                ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                            end
                                            local v145 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                            local v146 = v145 ~= v68.Moving
                                            v68.Moving = v145
                                            if v145 then
                                                Animator:PlayRun(ClientMoveSpeed)
                                            elseif v146 then
                                                Animator:PlayIdle()
                                            end
                                        end
                                    elseif v144 ~= 2 then
                                        local ClientMoveSpeed = v67:GetAttribute("ClientMoveSpeed")
                                        if typeof(ClientMoveSpeed) ~= "number" then
                                            local AssemblyLinearVelocity = v142.AssemblyLinearVelocity
                                            local X = AssemblyLinearVelocity.X
                                            local Z = AssemblyLinearVelocity.Z
                                            ClientMoveSpeed = Vector3.new(X, 0, Z).Magnitude
                                        end
                                        local v147 = if ClientMoveSpeed > 2 then not v68.HoldIdle else false
                                        local v148 = v147 ~= v68.Moving
                                        v68.Moving = v147
                                        if v147 then
                                            Animator:PlayRun(ClientMoveSpeed)
                                        elseif v148 then
                                            Animator:PlayIdle()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

return v1
