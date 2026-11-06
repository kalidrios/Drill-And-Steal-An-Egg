-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local v1 = {}
local Minions = HellBossConfig.Attacks.Minions
local Minion = HellBossConfig.Visuals.Minion

local function flat(v2) -- line 65
    local X = v2.X
    local Z = v2.Z
    return (Vector3.new(X, 0, Z))
end

local function lerp(v3, v4, v5) -- line 69
    return v3 + (v4 - v3) * v5
end

local v6 = {}
local v7

local function prepareMap(v8) -- line 81 | captures: v7, v6
    if not v8 or v7 == v8 then
        return
    end
    v7 = v8
    table.clear(v6)
    for v9, v10 in v8:GetDescendants() do
        if v10:IsA("BasePart") and v10.CanCollide and v10.Transparency >= 0.95 then
            table.insert(v6, v10)
            if not v10:FindFirstChild("MinionPassThrough") then
                local PathfindingModifier = Instance.new("PathfindingModifier")
                PathfindingModifier.Name = "MinionPassThrough"
                PathfindingModifier.PassThrough = true
                PathfindingModifier.Parent = v10
            end
        end
    end
end

local v11 = RaycastParams.new()

v11.FilterType = Enum.RaycastFilterType.Exclude
v11.IgnoreWater = true

local function refreshSight(v12) -- line 105 | captures: Players, v6, v11
    local v13 = table.clone(v6)
    table.insert(v13, v12)
    for v14, v15 in Players:GetPlayers() do
        if v15.Character then
            local Character = v15.Character
            table.insert(v13, Character)
        end
    end
    v11.FilterDescendantsInstances = v13
end

local function clearLine(v16, v17) -- line 115 | captures: Workspace, v11
    local v18 = v17.X - v16.X
    local v19 = v17.Z - v16.Z
    local v20 = Vector3.new(v18, 0, v19)
    if v20.Magnitude < 0.5 then
        return true
    end
    return Workspace:Raycast(v16, v20, v11) == nil
end

local function chaseSpeed(v21, v22) -- line 127 | captures: Minions
    local v23 = v21 and v21.Character
    local v24 = v23 and v23:FindFirstChildOfClass("Humanoid")
    local v25 = if v24 then v24.WalkSpeed else Minions.Speed
    local v26 = Minions.Speed + (v25 - Minions.Speed) * Minions.SpeedPull
    local v27 = v25 * Minions.MaxShare
    local MinSpeed = Minions.MinSpeed
    local v28 = math.min(MinSpeed, v27)
    local v29 = math.clamp(v26, v28, v27)
    if Minions.CatchUpFrom < v22 then
        local v30 = (v22 - Minions.CatchUpFrom) / (Minions.CatchUpFull - Minions.CatchUpFrom)
        local v31 = math.clamp(v30, 0, 1)
        v29 *= 1 + (Minions.CatchUpMult - 1) * v31
    end
    return v29
end

local v32 = {}

local function indexTemplates(v33) -- line 152 | captures: v32
    local v34 = { v33 }
    while #v34 > 0 do
        for v35, v36 in table.remove(v34, 1):GetChildren() do
            if v36:IsA("Folder") then
                table.insert(v34, v36)
            elseif v36:IsA("Model") and v32[v36.Name] == nil then
                v32[v36.Name] = v36
            end
        end
    end
end

local function findTemplate(v37) -- line 166 | captures: ReplicatedStorage, v32, indexTemplates
    local v38 = v32[v37]
    if v38 and v38.Parent then
        return v38
    end
    local Animals = ReplicatedStorage:FindFirstChild("Animals")
    local v39 = Animals and Animals:FindFirstChild("Normal")
    if v39 then
        table.clear(v32)
        indexTemplates(v39)
        return v32[v37]
    end
    return nil
end

local function build(v40) -- line 185 | captures: Minions, findTemplate
    local v41 = findTemplate(v40)
    if v41 then
        local v42 = v41:Clone()
        for v43, v44 in v42:GetDescendants() do
            if v44:IsA("LuaSourceContainer") or v44:IsA("ProximityPrompt") or v44:IsA("BillboardGui") or v44:IsA("Highlight") or v44:IsA("SelectionBox") or v44:IsA("SelectionSphere") then
                v44:Destroy()
            end
        end
        local PrimaryPart = v42.PrimaryPart or v42:FindFirstChild("HumanoidRootPart") or v42:FindFirstChildWhichIsA("BasePart", true)
        if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
            v42:Destroy()
            return nil, nil, 0
        end
        v42.PrimaryPart = PrimaryPart
        for v45, v46 in v42:GetDescendants() do
            if v46:IsA("BasePart") then
                v46.Anchored = v46 == PrimaryPart
                v46.CanCollide = false
                v46.CanQuery = false
                v46.CanTouch = false
                v46.Massless = true
            end
        end
        local v47, v48 = v42:GetBoundingBox()
        if v48.Y > 0 then
            local v49 = Minions.Height * (Minions.HeightScale and Minions.HeightScale[v40] or 1)
            v42:ScaleTo(v42:GetScale() * v49 / v48.Y)
        end
        local v50, v51 = v42:GetBoundingBox()
        return v42, PrimaryPart, v42:GetPivot().Position.Y - (v50.Position.Y - v51.Y / 2)
    end
    warn((("[HellMinions] no animal model \"%*\" under ReplicatedStorage.Animals.Normal"):format(v40)))
    return nil, nil, 0
end

local function bombTemplate() -- line 229 | captures: ReplicatedStorage, Minion
    local v52 = ReplicatedStorage
    for v53, v54 in Minion.BombOverhead do
        v52 = v52 and v52:FindFirstChild(v54)
    end
    if not (v52 and v52:IsA("BillboardGui")) then
        return nil
    end
    return v52
end

local function formatFuse(v55) -- line 237
    local v56 = math.ceil(v55)
    return (("%*s"):format((math.max(v56, 0))))
end

local function attachBomb(v57, v58, v59) -- line 241 | captures: Minion, bombTemplate
    local v60 = bombTemplate()
    if v60 then
        local v61, v62 = v57:GetBoundingBox()
        local Attachment = Instance.new("Attachment")
        Attachment.Name = "BombOverheadAttachment"
        Attachment.Parent = v58
        local Position = v61.Position
        local v63 = v62.Y / 2 + Minion.BombHeightAboveHead
        Attachment.WorldPosition = Position + Vector3.new(0, v63, 0)
        local v64 = v60:Clone()
        v64.SizeOffset = Vector2.new(0, 0.5)
        v64.Enabled = true
        v64.Parent = Attachment
        local v65 = v64:FindFirstChild(Minion.BombTimerLabel, true)
        if not (v65 and v65:IsA("TextLabel")) then
            return nil
        end
        local v66 = math.ceil(v59)
        v65.Text = ("%*s"):format((math.max(v66, 0)))
        return v65
    end
    warn((("[HellMinions] ReplicatedStorage.%* (BillboardGui) not found"):format((table.concat(Minion.BombOverhead, ".")))))
    return nil
end

local Model, Highlight
local v67 = {}
local v68
local v69 = 0

local function groupIn(v70) -- line 274 | captures: Model, Highlight, Minion
    if Model and Model.Parent == v70 then
        return Model
    end
    local Model_2 = Instance.new("Model")
    Model_2.Name = "HellMinions"
    local Highlight_2 = Instance.new("Highlight")
    Highlight_2.Name = "MinionFlash"
    Highlight_2.FillColor = Minion.FlashColor
    Highlight_2.FillTransparency = 1
    Highlight_2.OutlineColor = Minion.OutlineColor
    Highlight_2.OutlineTransparency = Minion.OutlineTransparency
    Highlight_2.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight_2.Adornee = Model_2
    Highlight_2.Parent = Model_2
    Model_2.Parent = v70
    Model = Model_2
    Highlight = Highlight_2
    return Model_2
end

local function runFlash() -- line 294 | captures: Highlight, v68, v69, RunService, Minion, v67
    v68 = v68 or
    RunService.RenderStepped:Connect(function(v71) -- line 298 | captures: Highlight, v68, v69, Minion, v67
        local v72 = 0
        local v73 = 0
        for v74, v75 in v67 do
            if v74.Parent then
                v73 += 1
                v72 = math.max(v72, v75)
            else
                v67[v74] = nil
            end
        end
        local Highlight_2 = Highlight
        if v73 ~= 0 and Highlight_2 and Highlight_2.Parent then
            local v76 = v69
            local Min = Minion.FlashRate.Min
            v69 = v76 + v71 * (Min + (Minion.FlashRate.Max - Min) * v72)
            local v77 = v69 * 3.141592653589793 * 2
            local v78 = math.cos(v77) * 0.5 + 0.5
            local Max = Minion.FlashTransparency.Max
            Highlight_2.FillTransparency = Max + (Minion.FlashTransparency.Min - Max) * v78
        else
            v68:Disconnect()
            v68 = nil
            v69 = 0
        end
    end)
end

local v79 = {}

local function isValidTarget(v80) -- line 326 | captures: Players, HellEventConfig
    if v80 and v80.Parent == Players and v80:GetAttribute(HellEventConfig.PlayerAttribute) == true then
        local Character = v80.Character
        local v81 = Character and Character:FindFirstChildOfClass("Humanoid")
        if v81 ~= nil and v81.Health > 0 then
            return Character:FindFirstChild("HumanoidRootPart") ~= nil
        end
        return false
    end
    return false
end

local function pickTarget(v82) -- line 338 | captures: Players, v79, isValidTarget
    local v83
    local v84 = (1/0)
    local v85 = (1/0)
    for v86, v87 in Players:GetPlayers() do
        if isValidTarget(v87) then
            local v88 = v79[v87] or 0
            local v89 = v87.Character:FindFirstChild("HumanoidRootPart").Position - v82
            local X = v89.X
            local Z = v89.Z
            local Magnitude = Vector3.new(X, 0, Z).Magnitude
            if v88 < v84 or v88 == v84 and Magnitude < v85 then
                v83 = v87
                v84 = v88
                v85 = Magnitude
            end
        end
    end
    return v83
end

local v90 = {}

local function spacingPush(v91, v92) -- line 358 | captures: Minions, v90
    local v93 = Vector3.new(0, 0, 0)
    for v94, v95 in v90 do
        if v94 ~= v91 then
            local v96 = v92 - v95
            local X = v96.X
            local Z = v96.Z
            local v97 = Vector3.new(X, 0, Z)
            local Magnitude = v97.Magnitude
            if Magnitude < Minions.Spacing then
                local Unit
                if Magnitude > 0.01 then
                    Unit = v97.Unit
                else
                    local v98 = math.random() - 0.5
                    local v99 = math.random() - 0.5
                    Unit = Vector3.new(v98, 0, v99).Unit
                end
                v93 += Unit * (1 - Magnitude / Minions.Spacing)
            end
        end
    end
    return v93
end

local function spawnOne(v100, v101, v102) -- line 374 | captures: Highlight, v68, v69, CollectionService, PathfindingService, RunService, Workspace, HellBossConfig, Minions, Minion, prepareMap, v11, refreshSight, chaseSpeed, build, attachBomb, v67, groupIn, v79, isValidTarget, pickTarget, v90, spacingPush
    local Index = v101.Index
    local ExplodeAt = v101.ExplodeAt
    if ExplodeAt <= v100.Now() then
        return
    end
    local v103, v104, v105 = build(v101.Animal)
    local v106, v107, v108, v109, v110
    if v103 and v104 then
        local From = v101.From
        local X = From.X
        local Z = From.Z
        local v111 = Vector3.new(X, 0, Z)
        local v112 = v100.FloorY + v105
        v109 = v111 + Vector3.new(0, v112, 0)
        v106 = v109
        v110 = Vector3.new(0, 0, -1)
        v107 = v110
        local Target = v101.Target
        v108 = Target
        if Target and Target.Character then
            local HumanoidRootPart = Target.Character:FindFirstChild("HumanoidRootPart")
            if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                local v113 = HumanoidRootPart.Position - v109
                local X = v113.X
                local Z = v113.Z
                local v114 = Vector3.new(X, 0, Z)
                if v114.Magnitude > 0.1 then
                    v110 = v114.Unit
                    v107 = v110
                end
            end
        end
    else
        return
    end
    prepareMap(v100.Map)
    local v115 = PathfindingService:CreatePath({
        AgentRadius = 2.5,
        AgentHeight = 6,
        AgentCanJump = false,
        WaypointSpacing = 6
    })
    local v116
    local v117 = 2
    local v118 = true
    local v119 = 2
    local v120 = v110

    local function setTarget(v121) -- line 410 | captures: v108, v79
        if v108 then
            local v122 = (v79[v108] or 1) - 1
            local v123 = v108
            if not (v122 > 0) then
                v122 = nil
            end
            v79[v123] = v122
        end
        v108 = v121
        if v121 then
            v79[v121] = (v79[v121] or 0) + 1
        end
    end

    local v124 = v108
    v108 = nil
    if not isValidTarget(v124) then
        v124 = pickTarget(v109)
    end
    if v108 then
        local v125 = (v79[v108] or 1) - 1
        if not (v125 > 0) then
            v125 = nil
        end
        v79[v108] = v125
    end
    v108 = v124
    if v124 then
        v79[v124] = (v79[v124] or 0) + 1
    end
    local v126 = false
    local v127 = 0
    local v128 = 0
    local v129
    local v130 = false
    local v131 = Vector3.new(0, 0, 0)
    local v132

    local function finish() -- line 434 | captures: v108, v132, v103, v115, v67, v79, v90
        v132:Disconnect()
        v67[v103] = nil
        v90[v103] = nil
        if v108 then
            local v133 = (v79[v108] or 1) - 1
            local v134 = v108
            if not (v133 > 0) then
                v133 = nil
            end
            v79[v134] = v133
        end
        v108 = nil
        v115:Destroy()
        if v103.Parent then
            v103:Destroy()
        end
    end

    local function explode() -- line 446 | captures: v106, v108, v132, v100, Index, v103, v115, Minions, v67, v79, v90
        local v135 = v106
        local X = v135.X
        local Z = v135.Z
        local v136 = Vector3.new(X, 0, Z)
        local FloorY = v100.FloorY
        local v137 = v136 + Vector3.new(0, FloorY, 0)
        v100.Blast(v137)
        local v138, v139 = v100.MyFeet()
        if v138 then
            local v140 = v138.Position - v137
            local X = v140.X
            local Z = v140.Z
            if Vector3.new(X, 0, Z).Magnitude <= Minions.Radius + 1.5 and v139 < Minions.HitHeight then
                v100.Report(Index, v137)
            end
        end
        v132:Disconnect()
        v67[v103] = nil
        v90[v103] = nil
        if v108 then
            local v141 = (v79[v108] or 1) - 1
            local v142 = v108
            if not (v141 > 0) then
                v141 = nil
            end
            v79[v142] = v141
        end
        v108 = nil
        v115:Destroy()
        if v103.Parent then
            v103:Destroy()
        end
    end

    local function applyVelocity() -- line 457 | captures: v131, v104
        v104.AssemblyLinearVelocity = v131
    end

    v132 = RunService.RenderStepped:Connect(function(v143) -- line 461 | captures: v106, v107, v108, v116, v117, v118, v119, v120, v126, v127, v128, v129, v130, v131, v132, v100, v102, ExplodeAt, v103, v104, v115, explode, applyVelocity, Highlight, v68, v69, CollectionService, RunService, Workspace, HellBossConfig, Minions, Minion, v11, refreshSight, chaseSpeed, attachBomb, v67, groupIn, v79, isValidTarget, pickTarget, v90, spacingPush
        local v144 = v100.Now()
        if not v100.Alive() then
            v132:Disconnect()
            v67[v103] = nil
            v90[v103] = nil
            if v108 then
                local v145 = (v79[v108] or 1) - 1
                local lookAt = v108
                if not (v145 > 0) then
                    v145 = nil
                end
                v79[lookAt] = v145
            end
            v108 = nil
            v115:Destroy()
            if v103.Parent then
                v103:Destroy()
            end
        else
            if v144 < v102 then
                return
            end
            local v146, v147, X, Z
            if not v130 then
                v130 = true
                v103:PivotTo(CFrame.lookAt(v106, v106 + v107))
                v103.Parent = groupIn(v100.Parent)
                CollectionService:AddTag(v103, "AnimatedAnimal")
                v129 = attachBomb(v103, v104, ExplodeAt - v144)
                local Puff = v100.Puff
                v146 = v106
                X = v146.X
                Z = v146.Z
                v147 = Vector3.new(X, 0, Z)
                X = v100.FloorY
                Puff(v147 + Vector3.new(0, X, 0))
            end
            if not v103.Parent then
                v132:Disconnect()
                v67[v103] = nil
                v90[v103] = nil
                if v108 then
                    local v148 = (v79[v108] or 1) - 1
                    local v149 = v108
                    if not (v148 > 0) then
                        v148 = nil
                    end
                    v79[v149] = v148
                end
                v108 = nil
                v115:Destroy()
                if v103.Parent then
                    v103:Destroy()
                end
            elseif ExplodeAt <= v144 then
                explode()
            else
                v131 = Vector3.new(0, 0, 0)
                local v150, v151
                if v127 <= v144 and not isValidTarget(v108) then
                    v150 = pickTarget(v106)
                    if v108 then
                        v151 = (v79[v108] or 1) - 1
                        v146 = v108
                        if not (v151 > 0) then
                            v151 = nil
                        end
                        v79[v146] = v151
                    end
                    v108 = v150
                    if v150 then
                        v79[v150] = (v79[v150] or 0) + 1
                    end
                end
                v150 = v108 and v108.Character
                v151 = v150 and v150:FindFirstChild("HumanoidRootPart")
                local v152 = false
                local v153 = false
                local v154 = false
                local v155 = false
                local v156 = false
                if v151 then
                    v152 = true
                else
                    v156 = true
                end
                if v152 then
                    if v151:IsA("BasePart") then
                        v153 = true
                    else
                        v156 = true
                    end
                end
                v152 = false
                local Position, v157
                if v153 then
                    Position = v151.Position
                    v147 = v106.X
                    X = v100.FloorY + 3
                    local Z = v106.Z
                    v157 = Vector3.new(v147, X, Z)
                    if v127 <= v144 then
                        v152 = true
                    else
                        v156 = false
                    end
                end
                v153 = false
                local v158, v159, v160
                if v152 then
                    v127 = v144 + Minions.RepathEvery
                    refreshSight(v100.Parent)
                    v159 = Position.X
                    Z = v100.FloorY + 3
                    v160 = Position.Z
                    X = Vector3.new(v159, Z, v160)
                    Z = X.X - v157.X
                    v158 = X.Z - v157.Z
                    v159 = Vector3.new(Z, 0, v158)
                    if v159.Magnitude < 0.5 then
                        v154 = true
                    else
                        v153 = true
                    end
                end
                v152 = false
                if v153 then
                    if Workspace:Raycast(v157, v159, v11) == nil then
                        v155 = true
                    else
                        v152 = true
                    end
                end
                v153 = false
                local v161
                if v152 then
                    v161 = false
                    v153 = true
                end
                v152 = false
                if v155 then
                    v161 = true
                    v153 = true
                end
                v155 = false
                if v154 then
                    v161 = true
                    v153 = true
                end
                if v153 then
                    if v161 then
                        v152 = true
                    else
                        v155 = true
                    end
                end
                v153 = false
                local v162
                if v155 then
                    v162 = 0
                    v153 = true
                end
                v155 = false
                if v152 then
                    v162 = v119 + 1
                    v153 = true
                end
                v152 = false
                if v153 then
                    v119 = v162
                    if v119 >= 2 then
                        v155 = true
                    else
                        v152 = true
                    end
                end
                v153 = false
                local v163
                if v152 then
                    v163 = false
                    v153 = true
                end
                if v155 then
                    v163 = true
                    v153 = true
                end
                v155 = false
                if v153 then
                    v118 = v163
                    if v118 then
                        v156 = false
                    else
                        v155 = true
                    end
                end
                v153 = false
                if v155 then
                    if v126 then
                        v156 = false
                    else
                        v153 = true
                    end
                end
                if v153 then
                    v126 = true
                    v159 = v106.X
                    Z = v100.FloorY + 3
                    v160 = v106.Z
                    local v164 = Vector3.new(v159, Z, v160)
                    v159 = task.spawn
                    local Position_2 = Position
                    v159(function() -- line 513 | captures: v164, Position_2, v106, v116, v117, v126, v115
                        local v165 = pcall(function() -- line 514 | captures: v164, Position_2, v115
                            v115:ComputeAsync(v164, Position_2)
                        end)
                        v126 = false
                        if not (v165 and v115.Status == Enum.PathStatus.Success) then
                            v116 = nil
                        else
                            local v166 = v115:GetWaypoints()
                            local v167 = 1
                            local v168 = (1/0)
                            for v169, v170 in v166 do
                                local v171 = v170.Position - v106
                                local X = v171.X
                                local Z = v171.Z
                                local Magnitude = Vector3.new(X, 0, Z).Magnitude
                                if Magnitude < v168 then
                                    v167 = v169
                                    v168 = Magnitude
                                end
                            end
                            v116 = v166
                            local v172 = v167 + 1
                            local v173 = #v166
                            v117 = math.min(v172, v173)
                        end
                    end)
                    v156 = false
                end
                local Unit, v174, min
                if not v156 then
                    if v118 then
                        v161 = Position
                    elseif v116 then
                        while true do
                            if v116[v117] then
                                v159 = v116[v117].Position - v106
                                v160 = v159.X
                                Unit = v159.Z
                                if Vector3.new(v160, 0, Unit).Magnitude < 3 then
                                    v117 += 1
                                    continue
                                end
                            end
                            break
                        end
                        v162 = v116[v117]
                        if v162 then
                            v161 = v162.Position
                        else
                            v161 = Position
                        end
                    else
                        v161 = Position
                    end
                    v159 = Position - v106
                    v160 = v159.X
                    Unit = v159.Z
                    Z = Vector3.new(v160, 0, Unit)
                    local v175 = v161 - v106
                    v158 = v175.X
                    min = v175.Z
                    v160 = Vector3.new(v158, 0, min)
                    v175 = spacingPush(v103, v106)
                    local v176 = Z.Magnitude
                    if Minions.StopDistance + 0.05 < v176 and v160.Magnitude > 0.05 then
                        v176 = chaseSpeed(v108, Z.Magnitude)
                        v158 = v160.Unit + v175 * Minions.SpacingWeight
                        if v158.Magnitude < 0.05 then
                            v158 = v160.Unit
                        end
                        Unit = v120
                        v174 = v158.Unit
                        local v177 = v143 * 7
                        v120 = Unit:Lerp(v174, (math.min(v177, 1)))
                        if v120.Magnitude < 0.05 then
                            v120 = v158.Unit
                        end
                        min = v176 * v143
                        v174 = v160.Magnitude
                        Unit = math.min(min, v174)
                        v106 += v120.Unit * Unit
                        v131 = v120.Unit * v176
                        v107 = v120.Unit
                    else
                        v176 = v175.Magnitude
                        if v176 > 0.25 then
                            v176 = v106
                            Unit = v175.Unit
                            v174 = Minions.MinSpeed * 0.5 * v143
                            local v178 = v175.Magnitude * Minions.Spacing * 0.25
                            v106 = v176 + Unit * math.min(v174, v178)
                        end
                        if Z.Magnitude > 0.1 then
                            v160 = v120
                            Unit = Z.Unit
                            v174 = v143 * 7
                            v120 = v160:Lerp(Unit, (math.min(v174, 1)))
                            if v120.Magnitude > 0.05 then
                                v107 = v120.Unit
                            end
                        end
                    end
                end
                v90[v103] = v106
                local lookAt = v108 and v108.Character
                v157 = lookAt and lookAt:FindFirstChild("HumanoidRootPart")
                if v157 and v157:IsA("BasePart") then
                    v162 = v157.Position - v106
                    Z = v162.X
                    v158 = v162.Z
                    if Vector3.new(Z, 0, v158).Magnitude <= Minions.TouchRadius then
                        v161 = lookAt:FindFirstChildOfClass("Humanoid")
                        if v161 and v161.Health > 0 then
                            explode()
                            return
                        end
                    end
                end
                v103:PivotTo(CFrame.lookAt(v106, v106 + v107))
                pcall(applyVelocity)
                lookAt = ExplodeAt - v144
                local MinionBeepSlow
                if lookAt > 0 and v128 <= v144 then
                    v157 = HellBossConfig.Sfx
                    v161 = v157.MinionBeepFrom
                    MinionBeepSlow = v157.MinionBeepSlow
                    if lookAt <= v161 then
                        v159 = v157.MinionBeepEvery
                        Z = v159.Min
                        v160 = v159.Max
                        min = lookAt / v161
                        v158 = math.clamp(min, 0, 1) ^ 2
                        MinionBeepSlow = Z + (v160 - Z) * v158
                    end
                    v128 = v144 + MinionBeepSlow
                    if v100.Beep then
                        v100.Beep(v106)
                    end
                end
                MinionBeepSlow = v144 - v102
                Z = ExplodeAt - v102
                v161 = MinionBeepSlow / math.max(Z, 0.01)
                v157 = math.clamp(v161, 0, 1)
                MinionBeepSlow = v100.MyFeet()
                if MinionBeepSlow then
                    v159 = Minion.FlashNear
                    v160 = MinionBeepSlow.Position - v106
                    Unit = v160.X
                    v174 = v160.Z
                    Z = Vector3.new(Unit, 0, v174).Magnitude
                    Unit = v159.From - Z
                    v174 = v159.From - v159.Full
                    v158 = Unit / math.max(v174, 0.01)
                    v161 = math.clamp(v158, 0, 1)
                else
                    v161 = 0
                end
                v67[v103] = 1 - (1 - v157 * v157) * (1 - v161 * v161)
                v68 = v68 or
                RunService.RenderStepped:Connect(function(v179) -- line 298 | captures: Highlight, v68, v69, Minion, v67
                    local v180 = 0
                    local v181 = 0
                    for v182, v183 in v67 do
                        if v182.Parent then
                            v181 += 1
                            v180 = math.max(v180, v183)
                        else
                            v67[v182] = nil
                        end
                    end
                    local Highlight_2 = Highlight
                    if v181 ~= 0 and Highlight_2 and Highlight_2.Parent then
                        local v184 = v69
                        local Min = Minion.FlashRate.Min
                        v69 = v184 + v179 * (Min + (Minion.FlashRate.Max - Min) * v180)
                        local v185 = v69 * 3.141592653589793 * 2
                        local v186 = math.cos(v185) * 0.5 + 0.5
                        local Max = Minion.FlashTransparency.Max
                        Highlight_2.FillTransparency = Max + (Minion.FlashTransparency.Min - Max) * v186
                    else
                        v68:Disconnect()
                        v68 = nil
                        v69 = 0
                    end
                end)
                if not v129 then
                    return
                end
                Z = ExplodeAt - v144
                min = math.ceil(Z)
                v160 = ("%*s"):format((math.max(min, 0)))
                if v129.Text ~= v160 then
                    v129.Text = v160
                end
            end
        end
    end)
end

function v1.Spawn(v187, v188, v189) -- line 639 | captures: RunService, spawnOne
    task.spawn(function() -- line 640 | captures: v187, v188, v189, RunService, spawnOne
        for v190, v191 in v188 do
            if v190 > 1 then
                RunService.Heartbeat:Wait()
            end
            if v187.Alive() then
                spawnOne(v187, v191, v189)
            else
                return
            end
        end
    end)
end

return v1
