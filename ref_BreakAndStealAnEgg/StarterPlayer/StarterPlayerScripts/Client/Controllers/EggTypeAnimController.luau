-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local AnimationAssets = require(ReplicatedStorage.Shared.AnimationAssets)
local EggTypeConfig = require(ReplicatedStorage.Shared.EggTypeConfig)
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local EggCullQuality = require(script.Parent.Parent.Modules.EggCullQuality)
local v1 = {}
local v2 = {}

local function stopTrack(v3) -- line 48
    local Track = v3.Track
    if not Track then
        return
    end
    v3.Track = nil
    v3.Playing = false
    Track:Stop(0.2)
    Track:Destroy()
end

local function inRange(v4) -- line 59 | captures: Workspace, EggTypeConfig, EggCullQuality
    local Anchor = v4.Anchor
    local CurrentCamera = Workspace.CurrentCamera
    if Anchor and Anchor.Parent and CurrentCamera then
        local v5 = Anchor.Position - CurrentCamera.CFrame.Position
        local Magnitude = v5.Magnitude
        if EggCullQuality.Distance(EggTypeConfig.AnimMaxDistance) < Magnitude then
            return false
        end
        if Magnitude < 20 then
            return true
        end
        local v6 = v5:Dot(CurrentCamera.CFrame.LookVector)
        return -0.3 * Magnitude < v6
    end
    return true
end

local function applyRange(v7) -- line 77 | captures: inRange
    local Track = v7.Track
    if Track then
        local v8 = inRange(v7)
        if not v8 or v7.Playing then
            if not v8 and v7.Playing then
                v7.Playing = false
                Track:Stop(0.3)
            end
        else
            v7.Playing = true
            Track:Play(0.2)
        end
    end
end

local function refresh(v9) -- line 92 | captures: Workspace, AnimationAssets, EggTypeConfig, v2, inRange
    local v10 = v2[v9]
    if not v10 then
        return
    end
    local v11 = EggTypeConfig.Get(v9:GetAttribute(EggTypeConfig.Attribute))
    if v11 and v11.IdleAnimationId and v9:IsDescendantOf(Workspace) then
        if not v10.Track then
            local v12 = v9:FindFirstChildWhichIsA("Animator", true)
            if v12 then
                local AttachmentCount = v9:GetAttribute("AttachmentCount")
                local v13 = typeof(AttachmentCount) == "number"
                local v14
                if v13 then
                    local v15 = 0
                    for v16, v17 in v9:GetDescendants() do
                        if v17:IsA("Attachment") then
                            v15 += 1
                        end
                    end
                    v14 = v15 < AttachmentCount
                end
                if not v13 or not v14 then
                    local v18 = AnimationAssets.Get(v11.IdleAnimationId, (("%* Idle"):format(v11.DisplayName)))
                    local v19, v20 = pcall(function() -- line 126 | captures: v12, v18
                        return v12:LoadAnimation(v18)
                    end)
                    if v19 and v20 then
                        v20.Looped = true
                        v20.Priority = Enum.AnimationPriority.Idle
                        v10.Track = v20
                        v10.Playing = false
                        if v9:IsA("Model") and v9.PrimaryPart then
                            v10.Anchor = v9.PrimaryPart
                        else
                            v10.Anchor = v9:FindFirstChildWhichIsA("BasePart", true)
                        end
                        local Track = v10.Track
                        if Track then
                            local v21 = inRange(v10)
                            if not v21 or v10.Playing then
                                if not v21 and v10.Playing then
                                    v10.Playing = false
                                    Track:Stop(0.3)
                                end
                            else
                                v10.Playing = true
                                Track:Play(0.2)
                            end
                        end
                    else
                        warn((("[EggTypeAnimController] couldn't load %* idle: %*"):format(v11.DisplayName, v20)))
                    end
                end
            end
        end
    else
        local Track = v10.Track
        if Track then
            v10.Track = nil
            v10.Playing = false
            Track:Stop(0.2)
            Track:Destroy()
        end
    end
end

local function unwatch(v22) -- line 143 | captures: v2
    local v23 = v2[v22]
    if not v23 then
        return
    end
    v2[v22] = nil
    local Track = v23.Track
    if Track then
        v23.Track = nil
        v23.Playing = false
        Track:Stop(0.2)
        Track:Destroy()
    end
    for v24, v25 in v23.Connections do
        v25:Disconnect()
    end
end

local function watch(v26) -- line 155 | captures: EggTypeConfig, v2, refresh
    local function v27(v28, ...)
        table.insert(v28, ...)
    end

    local function v29(v30, ...)
        table.insert(v30, ...)
    end

    local function v31(v32, ...)
        table.insert(v32, ...)
    end

    local function v33(v34, ...)
        table.insert(v34, ...)
    end

    if v2[v26] then
        return
    end
    local v35 = {
        Track = nil,
        Playing = false,
        Anchor = nil,
        Connections = {}
    }
    v2[v26] = v35

    local function again() -- line 161 | captures: v26, refresh
        refresh(v26)
    end

    v27(v35.Connections, v26.AncestryChanged:Connect(again))
    v29(v35.Connections, v26:GetAttributeChangedSignal(EggTypeConfig.Attribute):Connect(again))
    v31(v35.Connections, v26.DescendantAdded:Connect(function(v36) -- line 166 | captures: v26, refresh
        if v36:IsA("Animator") or v36:IsA("Attachment") then
            refresh(v26)
        end
    end))
    v33(v35.Connections, v26.Destroying:Connect(function() -- line 171 | captures: v26, v2
        local v37 = v2[v26]
        if not v37 then
            return
        end
        v2[v26] = nil
        local Track = v37.Track
        if Track then
            v37.Track = nil
            v37.Playing = false
            Track:Stop(0.2)
            Track:Destroy()
        end
        for v38, v39 in v37.Connections do
            v39:Disconnect()
        end
    end))
    refresh(v26)
end

function v1.Continue(v40, v41) -- line 180 | captures: v2, watch
    local v42 = v2[v40]
    local v43 = v42 and v42.Track
    local v44 = if v43 then v43.TimePosition else nil
    watch(v41)
    local v45 = v2[v41]
    if v45 and v45.Track and v44 then
        if not v45.Playing then
            v45.Playing = true
            v45.Track:Play(0)
        end
        v45.Track.TimePosition = v44
    end
end

function v1.Start() -- line 196 | captures: CollectionService, RunService, EggTypeConfig, MergeConfig, v2, inRange, unwatch, watch
    for v46, v47 in {
            MergeConfig.EggToolTag,
            MergeConfig.PlacedEggTag
        } do
        for v48, v49 in CollectionService:GetTagged(v47) do
            watch(v49)
        end
        CollectionService:GetInstanceAddedSignal(v47):Connect(watch)
        CollectionService:GetInstanceRemovedSignal(v47):Connect(unwatch)
    end
    local v50 = 0
    RunService.Heartbeat:Connect(function(v51) -- line 207 | captures: v50, EggTypeConfig, v2, inRange
        v50 += v51
        if not (v50 < EggTypeConfig.AnimCheckInterval) then
            v50 = 0
            for v52, v53 in v2 do
                local Track = v53.Track
                if Track then
                    if inRange(v53) then
                        if not v53.Playing then
                            v53.Playing = true
                            Track:Play(0.2)
                        end
                    elseif v53.Playing then
                        v53.Playing = false
                        Track:Stop(0.3)
                    end
                end
            end
        end
    end)
end

return v1
