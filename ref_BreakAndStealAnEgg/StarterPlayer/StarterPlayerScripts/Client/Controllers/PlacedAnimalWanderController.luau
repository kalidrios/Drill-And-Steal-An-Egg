-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local PlacedAnimalCelebration = require(ReplicatedStorage.Shared.PlacedAnimalCelebration)
local PlacedAnimalFootprint = require(ReplicatedStorage.Shared.PlacedAnimalFootprint)
local PlacedAnimalScatter = require(ReplicatedStorage.Shared.PlacedAnimalScatter)
local WaitFor = require(ReplicatedStorage.Shared.WaitFor)
local PlacedAnimalViewCullController = require(script.Parent.PlacedAnimalViewCullController)
local v1 = {}
local v2 = Random.new()
local v3 = {}
local v4 = {}
local v5 = {}
local v6 = {}

local function getRoot(v7) -- line 108
    local PrimaryPart = v7.PrimaryPart
    if PrimaryPart then
        return PrimaryPart
    end
    local v8
    local v9 = -1
    for v10, v11 in v7:GetDescendants() do
        if v11:IsA("BasePart") then
            local Size = v11.Size
            local v12 = Size.X * Size.Y * Size.Z
            if v9 < v12 then
                v8 = v11
                v9 = v12
            end
        end
    end
    return v8
end

local function getHitbox(v13) -- line 130
    local Parent = v13.Parent
    local v14 = Parent and Parent.Parent
    local v15 = v14 and v14:FindFirstChild("Hitbox")
    if not (v15 and v15:IsA("BasePart")) then
        return nil
    end
    return v15
end

local function penMates(v16) -- line 143 | captures: v5, v6
    table.clear(v6)
    local v17 = v5[v16.Hitbox]
    if v17 then
        for v18, v19 in v17 do
            if v19 ~= v16 then
                local v20 = {}
                v20.Position = v19.Target or v19.Root.Position
                v20.HalfSpan = v19.HalfSpan
                table.insert(v6, v20)
            end
        end
    end
    return v6
end

local function randomPointInHitbox(v21) -- line 164 | captures: PlacedAnimalScatter, v2, penMates
    local v22 = PlacedAnimalScatter.Point(v21.Hitbox, v21.HalfSpan, penMates(v21), v2, v21.FootSpan)
    local X = v22.X
    local Y = v21.Y
    local Z = v22.Z
    return (Vector3.new(X, Y, Z))
end

local function yawFromLook(v23) -- line 169
    local v24 = -v23.X
    local v25 = -v23.Z
    return (math.atan2(v24, v25))
end

local function shortestAngle(v26) -- line 174
    return (v26 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

local function setup(v27) -- line 178 | captures: PlacedAnimalCelebration, PlacedAnimalFootprint, PlacedAnimalScatter, WaitFor, v2, v3, v4, v5, getRoot
    if not v27:IsA("Model") or v3[v27] or v4[v27] then
        return
    end
    v4[v27] = true
    task.spawn(function() -- line 184 | captures: v27, PlacedAnimalCelebration, PlacedAnimalFootprint, PlacedAnimalScatter, WaitFor, v2, v3, v4, v5, getRoot
        local v28 = 0
        local v29 = v27.DescendantAdded:Connect(function() -- line 199 | captures: v28
            v28 += 1
        end)
        if WaitFor.Until(function() -- line 202 | captures: v27
                local Parent = v27.Parent
                local v30 = Parent and Parent.Parent
                local v31 = v30 and v30:FindFirstChild("Hitbox")
                if not (v31 and v31:IsA("BasePart")) then
                    v31 = nil
                end
                if v31 == nil then
                    return false
                end
                return v27:FindFirstChildWhichIsA("BasePart", true) ~= nil
            end, 5) then
            WaitFor.Stable(function() -- line 206 | captures: v28
                return v28
            end, 3, 1)
        end
        v29:Disconnect()
        v4[v27] = nil
        local v32 = getRoot(v27)
        local Parent = v27.Parent
        local v33 = Parent and Parent.Parent
        local v34 = v33 and v33:FindFirstChild("Hitbox")
        if not (v34 and v34:IsA("BasePart")) then
            v34 = nil
        end
        local v35
        if v32 and v34 and v27.Parent then
            if v3[v27] then
                v35 = true
            else
                if not v27.PrimaryPart then
                    v27.PrimaryPart = v32
                end
                v35 = false
            end
        else
            v35 = true
        end
        if v35 then
            return
        end
        local WanderSpeed = v27:GetAttribute("WanderSpeed")
        local v36 = {
            Moving = false,
            Target = nil,
            Accum = 0,
            Model = v27,
            Root = v32,
            Hitbox = v34,
            HalfSpan = PlacedAnimalScatter.HalfSpanOf(v27),
            FootSpan = PlacedAnimalFootprint.FootSpanOf(v27),
            Y = v32.Position.Y
        }
        if typeof(WanderSpeed) ~= "number" then
            WanderSpeed = 6
        end
        v36.Speed = WanderSpeed
        local LookVector = v32.CFrame.LookVector
        local v37 = -LookVector.X
        local v38 = -LookVector.Z
        v36.Yaw = math.atan2(v37, v38)
        v36.NextMoveAt = os.clock() + v2:NextNumber(0.5, 2)
        v3[v27] = v36
        local v39 = v5[v34]
        if not v39 then
            v39 = {}
            v5[v34] = v39
        end
        v39[v27] = v36
        v27:SetAttribute("ClientMoveSpeed", 0)
        if PlacedAnimalCelebration.IsFresh(v27) then
            v36.Celebration = PlacedAnimalCelebration.Begin(v27, v34, v36.HalfSpan, v32.Position, v36.Yaw, v36.Speed, v2, v36.FootSpan)
        end
    end)
end

local function teardown(v40) -- line 270 | captures: v3, v5
    local v41 = v3[v40]
    if not v41 then
        return
    end
    v3[v40] = nil
    local v42 = v5[v41.Hitbox]
    if v42 then
        v42[v40] = nil
        if next(v42) == nil then
            v5[v41.Hitbox] = nil
        end
    end
    if v40:GetAttribute("ClientMoveSpeed") ~= nil then
        v40:SetAttribute("ClientMoveSpeed", nil)
    end
end

local function step(v43, v44, v45) -- line 296 | captures: PlacedAnimalCelebration, PlacedAnimalScatter, v2, penMates
    local Model = v43.Model
    local Position = v43.Root.Position
    local Celebration = v43.Celebration
    if Celebration then
        local v46, v47, v48, v49, v50, v51 = PlacedAnimalCelebration.Step(Celebration, v45)
        v43.Yaw = v49
        Model:SetPrimaryPartCFrame(CFrame.new(v46, v43.Y + v47, v48) * CFrame.Angles(0, v49, 0))
        if v50 ~= Celebration.Published then
            Celebration.Published = v50
            Model:SetAttribute("ClientMoveSpeed", v50)
        end
        if v51 then
            v43.Celebration = nil
            v43.Moving = false
            v43.Target = nil
            v43.NextMoveAt = v44 + v2:NextNumber(0.3, 1.2)
        end
    else
        local Yaw = v43.Yaw
        local v52
        if v43.Moving then
            local Target = v43.Target
            local v53 = Target.X - Position.X
            local v54 = Target.Z - Position.Z
            local v55 = Vector3.new(v53, 0, v54)
            local Magnitude = v55.Magnitude
            local v56 = v43.Speed * v45
            local v57
            if Magnitude <= math.max(v56, 0.1) then
                v43.Moving = false
                v43.Target = nil
                v43.NextMoveAt = v44 + v2:NextNumber(1.5, 4)
                Model:SetAttribute("ClientMoveSpeed", 0)
                v57 = Yaw
            else
                local v58 = v55 / Magnitude
                Target = Position + v58 * v56
                local v59 = -v58.X
                local v60 = -v58.Z
                v57 = math.atan2(v59, v60)
            end
            Position = Target
            Yaw = v57
            v52 = true
        else
            if v43.NextMoveAt <= v44 then
                v43.Moving = true
                local v61 = PlacedAnimalScatter.Point(v43.Hitbox, v43.HalfSpan, penMates(v43), v2, v43.FootSpan)
                local X = v61.X
                local Y = v43.Y
                local Z = v61.Z
                v43.Target = Vector3.new(X, Y, Z)
                Model:SetAttribute("ClientMoveSpeed", v43.Speed)
            end
            v52 = false
        end
        local v62 = (Yaw - v43.Yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
        if math.abs(v62) > 0.005 then
            local Yaw = v43.Yaw
            local v63 = -v45 * 6
            v43.Yaw = Yaw + v62 * (1 - math.exp(v63))
            v52 = true
        elseif v62 ~= 0 then
            v43.Yaw = Yaw
            v52 = true
        end
        if v52 then
            Model:SetPrimaryPartCFrame(CFrame.new(Position.X, v43.Y, Position.Z) * CFrame.Angles(0, v43.Yaw, 0))
        end
    end
end

function v1.Start() -- line 375 | captures: CollectionService, RunService, Workspace, PlacedAnimalCelebration, PlacedAnimalFootprint, PlacedAnimalScatter, WaitFor, PlacedAnimalViewCullController, v2, v3, v4, v5, getRoot, setup, teardown, step
    for v64, v65 in CollectionService:GetTagged("PlacedAnimal") do
        if v65:IsA("Model") and not v3[v65] and not v4[v65] then
            v4[v65] = true
            local spawn = task.spawn
            local v66 = v65
            spawn(function() -- line 184 | captures: v66, PlacedAnimalCelebration, PlacedAnimalFootprint, PlacedAnimalScatter, WaitFor, v2, v3, v4, v5, getRoot
                local v67 = 0
                local v68 = v66.DescendantAdded:Connect(function() -- line 199 | captures: v67
                    v67 += 1
                end)
                if WaitFor.Until(function() -- line 202 | captures: v66
                        local Parent = v66.Parent
                        local v69 = Parent and Parent.Parent
                        local v70 = v69 and v69:FindFirstChild("Hitbox")
                        if not (v70 and v70:IsA("BasePart")) then
                            v70 = nil
                        end
                        if v70 == nil then
                            return false
                        end
                        return v66:FindFirstChildWhichIsA("BasePart", true) ~= nil
                    end, 5) then
                    WaitFor.Stable(function() -- line 206 | captures: v67
                        return v67
                    end, 3, 1)
                end
                v68:Disconnect()
                v4[v66] = nil
                local v71 = getRoot(v66)
                local Parent = v66.Parent
                local v72 = Parent and Parent.Parent
                local v73 = v72 and v72:FindFirstChild("Hitbox")
                if not (v73 and v73:IsA("BasePart")) then
                    v73 = nil
                end
                local v74
                if v71 and v73 and v66.Parent then
                    if v3[v66] then
                        v74 = true
                    else
                        if not v66.PrimaryPart then
                            v66.PrimaryPart = v71
                        end
                        v74 = false
                    end
                else
                    v74 = true
                end
                if v74 then
                    return
                end
                local WanderSpeed = v66:GetAttribute("WanderSpeed")
                local v75 = {
                    Moving = false,
                    Target = nil,
                    Accum = 0,
                    Model = v66,
                    Root = v71,
                    Hitbox = v73,
                    HalfSpan = PlacedAnimalScatter.HalfSpanOf(v66),
                    FootSpan = PlacedAnimalFootprint.FootSpanOf(v66),
                    Y = v71.Position.Y
                }
                if typeof(WanderSpeed) ~= "number" then
                    WanderSpeed = 6
                end
                v75.Speed = WanderSpeed
                local LookVector = v71.CFrame.LookVector
                local v76 = -LookVector.X
                local v77 = -LookVector.Z
                v75.Yaw = math.atan2(v76, v77)
                v75.NextMoveAt = os.clock() + v2:NextNumber(0.5, 2)
                v3[v66] = v75
                local v78 = v5[v73]
                if not v78 then
                    v78 = {}
                    v5[v73] = v78
                end
                v78[v66] = v75
                v66:SetAttribute("ClientMoveSpeed", 0)
                if PlacedAnimalCelebration.IsFresh(v66) then
                    v75.Celebration = PlacedAnimalCelebration.Begin(v66, v73, v75.HalfSpan, v71.Position, v75.Yaw, v75.Speed, v2, v75.FootSpan)
                end
            end)
        end
    end
    CollectionService:GetInstanceAddedSignal("PlacedAnimal"):Connect(setup)
    CollectionService:GetInstanceRemovedSignal("PlacedAnimal"):Connect(teardown)
    local CurrentCamera = Workspace.CurrentCamera
    local v79 = 0
    RunService.Heartbeat:Connect(function(v80) -- line 386 | captures: CurrentCamera, v79, CollectionService, Workspace, PlacedAnimalCelebration, PlacedAnimalFootprint, PlacedAnimalScatter, WaitFor, PlacedAnimalViewCullController, v2, v3, v4, v5, getRoot, teardown, step
        local v81 = os.clock()
        if CurrentCamera == nil or CurrentCamera.Parent == nil then
            CurrentCamera = Workspace.CurrentCamera
        end
        local v82 = CurrentCamera and CurrentCamera.CFrame.Position
        v79 += v80
        if v79 >= 2 then
            v79 = 0
            for v83, v84 in CollectionService:GetTagged("PlacedAnimal") do
                if v84:IsA("Model") and v84:IsDescendantOf(game) and not v3[v84] and v84:IsA("Model") and not v3[v84] and not v4[v84] then
                    v4[v84] = true
                    local spawn = task.spawn
                    local v85 = v84
                    spawn(function() -- line 184 | captures: v85, PlacedAnimalCelebration, PlacedAnimalFootprint, PlacedAnimalScatter, WaitFor, v2, v3, v4, v5, getRoot
                        local v86 = 0
                        local v87 = v85.DescendantAdded:Connect(function() -- line 199 | captures: v86
                            v86 += 1
                        end)
                        if WaitFor.Until(function() -- line 202 | captures: v85
                                local Parent = v85.Parent
                                local v88 = Parent and Parent.Parent
                                local v89 = v88 and v88:FindFirstChild("Hitbox")
                                if not (v89 and v89:IsA("BasePart")) then
                                    v89 = nil
                                end
                                if v89 == nil then
                                    return false
                                end
                                return v85:FindFirstChildWhichIsA("BasePart", true) ~= nil
                            end, 5) then
                            WaitFor.Stable(function() -- line 206 | captures: v86
                                return v86
                            end, 3, 1)
                        end
                        v87:Disconnect()
                        v4[v85] = nil
                        local v90 = getRoot(v85)
                        local Parent = v85.Parent
                        local v91 = Parent and Parent.Parent
                        local v92 = v91 and v91:FindFirstChild("Hitbox")
                        if not (v92 and v92:IsA("BasePart")) then
                            v92 = nil
                        end
                        local v93
                        if v90 and v92 and v85.Parent then
                            if v3[v85] then
                                v93 = true
                            else
                                if not v85.PrimaryPart then
                                    v85.PrimaryPart = v90
                                end
                                v93 = false
                            end
                        else
                            v93 = true
                        end
                        if v93 then
                            return
                        end
                        local WanderSpeed = v85:GetAttribute("WanderSpeed")
                        local v94 = {
                            Moving = false,
                            Target = nil,
                            Accum = 0,
                            Model = v85,
                            Root = v90,
                            Hitbox = v92,
                            HalfSpan = PlacedAnimalScatter.HalfSpanOf(v85),
                            FootSpan = PlacedAnimalFootprint.FootSpanOf(v85),
                            Y = v90.Position.Y
                        }
                        if typeof(WanderSpeed) ~= "number" then
                            WanderSpeed = 6
                        end
                        v94.Speed = WanderSpeed
                        local LookVector = v90.CFrame.LookVector
                        local v95 = -LookVector.X
                        local v96 = -LookVector.Z
                        v94.Yaw = math.atan2(v95, v96)
                        v94.NextMoveAt = os.clock() + v2:NextNumber(0.5, 2)
                        v3[v85] = v94
                        local v97 = v5[v92]
                        if not v97 then
                            v97 = {}
                            v5[v92] = v97
                        end
                        v97[v85] = v94
                        v85:SetAttribute("ClientMoveSpeed", 0)
                        if PlacedAnimalCelebration.IsFresh(v85) then
                            v94.Celebration = PlacedAnimalCelebration.Begin(v85, v92, v94.HalfSpan, v90.Position, v94.Yaw, v94.Speed, v2, v94.FootSpan)
                        end
                    end)
                end
            end
        end
        for v98, v99 in v3 do
            if v98.Parent and v99.Root.Parent and v99.Hitbox.Parent then
                v99.Accum += v80
                if v82 then
                    local v100 = v99.Root.Position - v82
                    local v101 = v100.X * v100.X + v100.Y * v100.Y + v100.Z * v100.Z
                    local v102
                    if v101 <= 22500 then
                        v102 = 0
                    elseif v101 <= 122500 then
                        v102 = 0.06666666666666667
                    else
                        v102 = 0.25
                    end
                    if v102 < 0.25 and PlacedAnimalViewCullController.IsCulled(v98) then
                        v102 = 0.25
                    end
                    if not (v99.Accum < v102) then
                        local Accum = v99.Accum
                        v99.Accum = 0
                        step(v99, v81, Accum)
                    end
                else
                    local Accum = v99.Accum
                    v99.Accum = 0
                    step(v99, v81, Accum)
                end
            else
                teardown(v98)
            end
        end
    end)
end

return v1
