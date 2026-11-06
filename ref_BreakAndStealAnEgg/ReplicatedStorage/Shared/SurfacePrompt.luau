-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2 = {}
local v3

local function localCharacterPosition() -- line 36 | captures: LocalPlayer
    local Character = LocalPlayer.Character
    local v4 = if Character then Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart") else nil
    if not (v4 and v4:IsA("BasePart")) then
        return nil
    end
    return v4.Position
end

local function closestPointOnPart(v5, v6) -- line 43
    local v7 = v5.CFrame:PointToObjectSpace(v6)
    local v8 = v5.Size * 0.5
    local CFrame = v5.CFrame
    local X = v7.X
    local v9 = -v8.X
    local X_2 = v8.X
    local v10 = math.clamp(X, v9, X_2)
    local Y = v7.Y
    local v11 = -v8.Y
    local Y_2 = v8.Y
    local v12 = math.clamp(Y, v11, Y_2)
    local Z = v7.Z
    local v13 = -v8.Z
    local Z_2 = v8.Z
    local v14 = math.clamp(Z, v13, Z_2)
    return CFrame:PointToWorldSpace((Vector3.new(v10, v12, v14)))
end

local function measureRadius(v15) -- line 60
    local PivotPart = v15.PivotPart
    local v16 = if PivotPart then PivotPart.Position else v15.Target:GetPivot().Position
    local v17 = 0
    for v18, v19 in ipairs(v15.Parts) do
        if v19.Parent ~= nil then
            local v20 = (v19.Position - v16).Magnitude + v19.Size.Magnitude * 0.5
            if v17 < v20 then
                v17 = v20
            end
        end
    end
    v15.Radius = v17
    local v21 = v15.TrackDistance + v17
    v15.RejectSq = v21 * v21
    v15.RadiusCheckAt = os.clock() + 0.5
end

local function refreshParts(v22) -- line 79 | captures: measureRadius
    table.clear(v22.Parts)
    local Target = v22.Target
    if Target:IsA("BasePart") and Target ~= v22.Anchor then
        local Parts = v22.Parts
        table.insert(Parts, Target)
    end
    for v23, v24 in ipairs(Target:GetDescendants()) do
        if v24:IsA("BasePart") and v24 ~= v22.Anchor and v24.Parent ~= nil then
            local Parts = v22.Parts
            table.insert(Parts, v24)
        end
    end
    if not Target:IsA("BasePart") then
        if not (Target:IsA("Model") and Target.PrimaryPart) then
            Target = v22.Parts[1]
        else
            Target = Target.PrimaryPart
        end
    end
    v22.PivotPart = Target
    v22.PartsDirty = false
    measureRadius(v22)
end

local function closestSurfacePoint(v25, v26) -- line 109 | captures: closestPointOnPart
    local v27 = (1/0)
    local v28
    for v29, v30 in ipairs(v25.Parts) do
        if v30.Parent ~= nil then
            local v31 = closestPointOnPart(v30, v26)
            local v32 = v26 - v31
            local v33 = v32:Dot(v32)
            if v33 < v27 then
                v27 = v33
                v28 = v31
            end
        end
    end
    if v28 == nil then
        return nil, nil
    end
    local v34 = v26 - v28
    local v35
    if v27 < 0.00000001 then
        v35 = Vector3.new(0, 1, 0)
    else
        v35 = v34.Unit
    end
    return v28 + v35 * v25.SurfaceOffset, (math.sqrt(v27))
end

local function detachPrompt(v36) -- line 135 | captures: v2
    local v37 = v2[v36]
    if v37 == nil then
        return
    end
    v2[v36] = nil
    for v38, v39 in ipairs(v37.PartConnections) do
        v39:Disconnect()
    end
    table.clear(v37.PartConnections)
    v37.Anchor:Destroy()
end

local function onHeartbeat(v40) -- line 147 | captures: v3, LocalPlayer, v2, measureRadius, refreshParts, closestSurfacePoint, detachPrompt
    if next(v2) == nil then
        if v3 ~= nil then
            v3:Disconnect()
            v3 = nil
        end
    else
        local Character = LocalPlayer.Character
        local v41 = if Character then Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart") else nil
        local Position
        if not (v41 and v41:IsA("BasePart")) then
        else
            Position = v41.Position
        end
        if Position ~= nil then
            for v42, v43 in pairs(v2) do
                if v42.Parent == nil or v43.Target.Parent == nil or v43.Anchor.Parent == nil then
                    detachPrompt(v42)
                elseif v42.Enabled then
                    local PivotPart = v43.PivotPart
                    if v43.PartsDirty or PivotPart == nil or PivotPart.Parent == nil then
                        refreshParts(v43)
                        PivotPart = v43.PivotPart
                        if PivotPart ~= nil then
                            local v44 = Position - PivotPart.Position
                            local v45 = v44:Dot(v44)
                            if not (v43.RejectSq < v45) then
                                local v46, v47 = closestSurfacePoint(v43, Position)
                                if v46 ~= nil and v47 ~= nil and v47 <= v43.TrackDistance then
                                    local Anchor = v43.Anchor
                                    local v48 = v40 * v43.FollowSpeed
                                    local v49 = math.clamp(v48, 0, 1)
                                    local v50 = Anchor.Position:Lerp(v46, v49)
                                    if (v50 - Anchor.Position).Magnitude > 0.001 then
                                        Anchor.CFrame = CFrame.new(v50)
                                    end
                                end
                            end
                        end
                    else
                        local v51 = os.clock()
                        if v43.RadiusCheckAt <= v51 then
                            measureRadius(v43)
                        end
                        local v52 = Position - PivotPart.Position
                        local v53 = v52:Dot(v52)
                        if not (v43.RejectSq < v53) then
                            local v54, v55 = closestSurfacePoint(v43, Position)
                            if v54 ~= nil and v55 ~= nil and v55 <= v43.TrackDistance then
                                local Anchor = v43.Anchor
                                local v56 = v40 * v43.FollowSpeed
                                local v57 = math.clamp(v56, 0, 1)
                                local v58 = Anchor.Position:Lerp(v54, v57)
                                if (v58 - Anchor.Position).Magnitude > 0.001 then
                                    Anchor.CFrame = CFrame.new(v58)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function ensureHeartbeat() -- line 213 | captures: v3, RunService, onHeartbeat
    if v3 == nil then
        v3 = RunService.Heartbeat:Connect(onHeartbeat)
    end
end

function v1.Attach(v59, v60, v61) -- line 221 | captures: v3, RunService, Workspace, v2, refreshParts, detachPrompt, onHeartbeat
    local function v62(v63, ...)
        table.insert(v63, ...)
    end

    local function v64(v65, ...)
        table.insert(v65, ...)
    end

    local v66 = v61 or {}
    if v66.MaxActivationDistance ~= nil then
        v59.MaxActivationDistance = v66.MaxActivationDistance
    end
    local v67 = v66.TrackDistance or v59.MaxActivationDistance + 2
    local MaxActivationDistance = v59.MaxActivationDistance
    local v68 = math.max(v67, MaxActivationDistance)
    local Part = Instance.new("Part")
    Part.Name = v66.AnchorName or "PromptAnchor"
    Part.Size = Vector3.new(1, 1, 1)
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CFrame = v60:GetPivot()
    Part.Parent = Workspace
    local v69 = {
        Radius = 0,
        RadiusCheckAt = 0,
        PartsDirty = false,
        Target = v60,
        Anchor = Part,
        Parts = {},
        PartConnections = {},
        SurfaceOffset = v66.SurfaceOffset or 0.8,
        FollowSpeed = v66.FollowSpeed or 16,
        TrackDistance = v68
    }
    refreshParts(v69)
    v62(v69.PartConnections, v60.DescendantAdded:Connect(function(v70) -- line 258 | captures: v69
        if v70:IsA("BasePart") then
            v69.PartsDirty = true
        end
    end))
    v64(v69.PartConnections, v60.DescendantRemoving:Connect(function(v71) -- line 263 | captures: v69
        if v71:IsA("BasePart") then
            v69.PartsDirty = true
        end
    end))
    v59.RequiresLineOfSight = false
    v59.Parent = Part
    v2[v59] = v69
    if v3 == nil then
        v3 = RunService.Heartbeat:Connect(onHeartbeat)
    end
    local v72 = v59.Destroying:Once(function() -- line 277 | captures: v59, detachPrompt
        detachPrompt(v59)
    end)
    local v73 = v60.Destroying:Once(function() -- line 280 | captures: v59, detachPrompt
        detachPrompt(v59)
    end)
    local PartConnections = v69.PartConnections
    table.insert(PartConnections, v72)
    local PartConnections_2 = v69.PartConnections
    table.insert(PartConnections_2, v73)
    return function() -- line 286 | captures: v59, detachPrompt
        detachPrompt(v59)
    end
end

return v1
