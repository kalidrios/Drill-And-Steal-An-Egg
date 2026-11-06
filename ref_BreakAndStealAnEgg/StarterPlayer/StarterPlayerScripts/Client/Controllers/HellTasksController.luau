-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local HellEssenceConfig = require(ReplicatedStorage.Shared.HellEssenceConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local ShieldModel = require(ReplicatedStorage.Shared.ShieldModel)
local HellBossController = require(script.Parent.HellBossController)
local BinaryTransition = require(script.Parent.Parent.Modules.BinaryTransition)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local ShieldArrow = HellBossConfig.ShieldArrow
local Tasks = HellBossConfig.Tasks
local Shields = HellBossConfig.Shields

local function inHell() -- line 62 | captures: HellEventConfig, LocalPlayer
    return LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true
end

local function getBoss() -- line 66 | captures: CollectionService, HellBossConfig
    local v2 = CollectionService:GetTagged(HellBossConfig.Tag)[1]
    if not (v2 and v2:IsA("Model")) then
        return nil
    end
    return v2
end

local function getShieldFolder() -- line 71 | captures: HellEventConfig, Shields
    local v3 = workspace:FindFirstChild(HellEventConfig.MapName)
    return v3 and v3:FindFirstChild(Shields.Folder)
end

local function shieldProgress() -- line 77 | captures: CollectionService, HellBossConfig, Shields
    local v4 = #Shields.PipOrder
    local v5 = CollectionService:GetTagged(HellBossConfig.Tag)[1]
    if not (v5 and v5:IsA("Model")) then
        v5 = nil
    end
    if v5 then
        local v6 = 0
        local v7 = 0
        for v8 = 1, v4 do
            local v9 = v5:GetAttribute((("ShieldHealth%*"):format(v8)))
            if type(v9) == "number" then
                v6 += 1
                if v9 <= 0 then
                    v7 += 1
                end
            end
        end
        if v6 == 0 then
            return 0, v4
        end
        return v7, v6
    end
    return 0, v4
end

local function isStanding(v10, v11) -- line 101 | captures: CollectionService, HellBossConfig
    local Health = v10:GetAttribute("Health")
    if type(Health) == "number" then
        return Health > 0
    end
    local ShieldIndex = v10:GetAttribute("ShieldIndex")
    local v12 = CollectionService:GetTagged(HellBossConfig.Tag)[1]
    if not (v12 and v12:IsA("Model")) then
        v12 = nil
    end
    local v13, v14
    if v12 and type(ShieldIndex) == "number" then
        local v15 = v12:GetAttribute((("ShieldHealth%*"):format(ShieldIndex)))
        if type(v15) == "number" then
            v13 = v15 > 0
            v14 = false
        else
            v14 = true
        end
    else
        v14 = true
    end
    if not v14 then
        return v13
    end
    return v11.CanQuery
end

local function nearestShield(v16) -- line 117 | captures: HellEventConfig, ShieldModel, Shields, isStanding
    if Shields.Breakable then
        local v17 = workspace:FindFirstChild(HellEventConfig.MapName)
        local v18 = v17 and v17:FindFirstChild(Shields.Folder)
        if v18 then
            local v19
            local v20 = (1/0)
            for v21, v22 in v18:GetChildren() do
                local v23 = ShieldModel.HitPart(v22)
                if v23 and isStanding(v22, v23) then
                    local Magnitude = (v23.Position - v16).Magnitude
                    if Magnitude < v20 then
                        v19 = v23
                        v20 = Magnitude
                    end
                end
            end
            return v19
        end
    end
    return nil
end

local v24, v25, v26
local v27 = CFrame.identity

local function getArrowTemplate() -- line 149 | captures: ReplicatedStorage, ShieldArrow
    local v28 = ReplicatedStorage
    for v29, v30 in ShieldArrow.Asset do
        v28 = v28 and v28:FindFirstChild(v30)
    end
    return v28
end

local function destroyArrow() -- line 157 | captures: v24, v25, v26
    if v24 then
        v24:Destroy()
    end
    v24 = nil
    v25 = nil
    v26 = nil
end

local function ensureArrow() -- line 164 | captures: v24, v25, v26, ReplicatedStorage, ShieldArrow
    if v24 and v24.Parent and v25 and v26 then
        return true
    end
    if v24 then
        v24:Destroy()
    end
    v24 = nil
    v25 = nil
    v26 = nil
    local v31 = ReplicatedStorage
    for v32, v33 in ShieldArrow.Asset do
        v31 = v31 and v31:FindFirstChild(v33)
    end
    if v31 then
        local v34 = v31:Clone()
        v34.Name = "HellShieldArrow"
        local v35 = v34:FindFirstChild(ShieldArrow.StartPart)
        local v36 = v34:FindFirstChild(ShieldArrow.EndPart)
        if v35 and v35:IsA("BasePart") and v36 and v36:IsA("BasePart") then
            for v37, v38 in { v35, v36 } do
                v38.Anchored = true
                v38.CanCollide = false
                v38.CanTouch = false
                v38.CanQuery = false
                v38.CastShadow = false
            end
            v34.Parent = workspace
            v24 = v34
            v25 = v35
            v26 = v36
            return true
        end
        warn((("[HellTasksController] RedArrow needs %* and %* parts"):format(ShieldArrow.StartPart, ShieldArrow.EndPart)))
        v34:Destroy()
    else
        warn((("[HellTasksController] ReplicatedStorage.%* not found"):format((table.concat(ShieldArrow.Asset, ".")))))
    end
    return false
end

local function placeArrow(v39, v40) -- line 198 | captures: v25, v26, v27
    local v41 = v40.X - v39.X
    local v42 = v40.Z - v39.Z
    local v43 = Vector3.new(v41, 0, v42)
    if v43.Magnitude > 0.05 then
        v27 = CFrame.lookAt(Vector3.new(0, 0, 0), v43) * CFrame.Angles(0, 1.5707963267948966, 0)
    end
    local v44 = v25
    local v45 = v26
    v44.CFrame = CFrame.new(v39) * v27
    v45.CFrame = CFrame.new(v40) * v27
end

local function nearestEssenceEgg(v46) -- line 211 | captures: CollectionService, Workspace, HellEssenceConfig, ShieldArrow
    if not (ShieldArrow.Essence and Workspace:GetAttribute(HellEssenceConfig.GatherAttribute) == true) then
        return nil
    end
    local v47
    local v48 = (1/0)
    for v49, v50 in CollectionService:GetTagged(HellEssenceConfig.EggTag) do
        if v50:IsA("BasePart") and v50:IsDescendantOf(Workspace) and not (v50:GetAttribute("Hatching") or v50:GetAttribute("Broken")) then
            local Magnitude = (v50.Position - v46).Magnitude
            if Magnitude < v48 then
                v47 = v50
                v48 = Magnitude
            end
        end
    end
    return v47
end

local v51 = false
local v52 = {}
local Id, v53, v54

local function progressFor(v55) -- line 242 | captures: CollectionService, Workspace, HellBossConfig, HellEssenceConfig, shieldProgress
    if v55 == "Shields" then
        return shieldProgress()
    end
    if v55 == "Essence" then
        local v56 = Workspace:GetAttribute(HellEssenceConfig.EssenceAttribute)
        local v57 = Workspace:GetAttribute(HellEssenceConfig.GoalAttribute)
        if not (type(v56) == "number" and type(v57) == "number") then
            return 1, 1
        end
        return math.min(v56, v57), v57
    end
    if v55 == "Boss" then
        local v58 = CollectionService:GetTagged(HellBossConfig.Tag)[1]
        if not (v58 and v58:IsA("Model")) then
            v58 = nil
        end
        local v59 = v58 and v58:GetAttribute("Health")
        local v60 = if not (type(v59) == "number" and v59 <= 0) then 0 else 1
        return v60, 1
    end
    return 0, 1
end

local function refreshTasks() -- line 263 | captures: v51, Id, v53, v54, HellBossController, Tasks, v52, progressFor
    local v61
    local Id_2
    local ShowFor
    local v62 = false
    for v63, v64 in Tasks.List do
        local v65, v66 = progressFor(v64.Id)
        local v67 = v52[v64.Id]
        v52[v64.Id] = v65
        v61 = string.format(v64.Text, v65, v66)
        if v66 <= v65 then
            v61 = ("<s>%*</s>"):format(v61)
        end
        Id_2 = v64.Id
        ShowFor = v64.ShowFor
        if v67 == nil then
            v62 = false
        elseif v67 < v65 then
            v62 = not v64.NoPop
        else
            v62 = false
        end
        if v65 < v66 then
            break
        end
    end
    if Id_2 ~= Id then
        Id = Id_2
        v53 = nil
    end
    if v51 and not v53 then
        v53 = os.clock()
    end
    if not (ShowFor and v53) then
        v54 = nil
    else
        v54 = v53 + ShowFor
    end
    if v54 then
        local v68 = os.clock()
        if v54 <= v68 then
            v61 = nil
        end
    end
    local SetTask = HellBossController.SetTask
    if not v51 then
        v61 = nil
    end
    SetTask(v61, v51 and v62, Id_2)
end

local v69, v70
local v71 = (-1/0)

local function isFightReady() -- line 302 | captures: v69, HellEventConfig, HellBossController, BinaryTransition, LocalPlayer
    local v72, v73
    if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
        if BinaryTransition.IsPlaying() or HellBossController.IsCutsceneBusy() then
            v73 = true
        else
            local v74 = os.clock()
            v69 = v69 or v74
            v72 = v74 - v69 >= 0.3
            v73 = false
        end
    else
        v73 = true
    end
    if not v73 then
        return v72
    end
    v69 = nil
    return false
end

local function step() -- line 312 | captures: v24, v25, v26, v51, v54, v69, v70, v71, HellEventConfig, HellBossController, BinaryTransition, LocalPlayer, nearestShield, ensureArrow, placeArrow, nearestEssenceEgg, refreshTasks
    local v75
    if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true and not BinaryTransition.IsPlaying() and not HellBossController.IsCutsceneBusy() then
        local v76 = os.clock()
        v69 = v69 or v76
        v75 = v76 - v69 >= 0.3
    else
        v69 = nil
        v75 = false
    end
    if v51 == v75 then
        if v54 then
            local v77 = os.clock()
            if v54 <= v77 then
                refreshTasks()
                v54 = nil
            end
        end
    else
        v51 = v75
        refreshTasks()
    end
    local Character = LocalPlayer.Character
    local v78 = Character and Character:FindFirstChild("HumanoidRootPart")
    local v79
    if v75 and v78 then
        local v80 = os.clock()
        if v80 - v71 >= 0.2 then
            v71 = v80
            v70 = nearestEssenceEgg(v78.Position) or nearestShield(v78.Position)
        elseif v70 then
            if not v70.Parent then
                v71 = v80
                v70 = nearestEssenceEgg(v78.Position) or nearestShield(v78.Position)
            end
        else
            v71 = v80
            v70 = nearestEssenceEgg(v78.Position) or nearestShield(v78.Position)
        end
        v79 = v70
    else
        v70 = nil
        v71 = (-1/0)
    end
    if v79 and v78 then
        if ensureArrow() then
            placeArrow(v78.Position, v79.Position)
        end
    else
        if not v24 then
            return
        end
        if v24 then
            v24:Destroy()
        end
        v24 = nil
        v25 = nil
        v26 = nil
    end
end

local v81 = {}

local function unwatchBoss(v82) -- line 354 | captures: v81
    local v83 = v81[v82]
    if v83 then
        v81[v82] = nil
        for v84, v85 in v83 do
            v85:Disconnect()
        end
    end
end

local function watchBoss(v86) -- line 365 | captures: Shields, refreshTasks, v81
    local function v87(v88, ...)
        table.insert(v88, ...)
    end

    local function v89(v90, ...)
        table.insert(v90, ...)
    end

    local function v91(v92, ...)
        table.insert(v92, ...)
    end

    local v93 = v81[v86]
    if v93 then
        v81[v86] = nil
        for v94, v95 in v93 do
            v95:Disconnect()
        end
    end
    local v96 = {}
    v81[v86] = v96
    local v97 = #Shields.PipOrder
    for v98 = 1, v97 do
        v87(v96, v86:GetAttributeChangedSignal((("ShieldHealth%*"):format(v98))):Connect(refreshTasks))
    end
    v89(v96, v86:GetAttributeChangedSignal("ShieldsUp"):Connect(refreshTasks))
    v91(v96, v86:GetAttributeChangedSignal("Health"):Connect(refreshTasks))
    refreshTasks()
end

function v1.Start() -- line 377 | captures: CollectionService, RunService, Workspace, HellBossConfig, HellEssenceConfig, refreshTasks, step, v81, watchBoss
    refreshTasks()
    Workspace:GetAttributeChangedSignal(HellEssenceConfig.EssenceAttribute):Connect(refreshTasks)
    Workspace:GetAttributeChangedSignal(HellEssenceConfig.GoalAttribute):Connect(refreshTasks)
    for v99, v100 in CollectionService:GetTagged(HellBossConfig.Tag) do
        watchBoss(v100)
    end
    CollectionService:GetInstanceAddedSignal(HellBossConfig.Tag):Connect(watchBoss)
    CollectionService:GetInstanceRemovedSignal(HellBossConfig.Tag):Connect(function(v101) -- line 387 | captures: refreshTasks, v81
        local v102 = v81[v101]
        if v102 then
            v81[v101] = nil
            for v103, v104 in v102 do
                v104:Disconnect()
            end
        end
        refreshTasks()
    end)
    RunService.RenderStepped:Connect(step)
end

return v1
