-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {}
local v2 = {}

local function resolveAnimator(v3) -- line 60
    local v4 = v3:FindFirstChildOfClass("AnimationController") or v3:FindFirstChildOfClass("Humanoid")
    if v4 == nil then
        return nil
    end
    local Animator = v4:FindFirstChildOfClass("Animator")
    if Animator == nil then
        Animator = Instance.new("Animator")
        Animator.Parent = v4
    end
    return Animator
end

local function findAttackAnimation(v5) -- line 74
    local Animations = v5:FindFirstChild("Animations")
    local v6 = Animations and Animations:FindFirstChild("Attack")
    if v6 and v6:IsA("Animation") and v6.AnimationId ~= "" then
        return v6
    end
    return nil
end

local function loadTrack(v7) -- line 86 | captures: v2
    if v7.Loading then
        return
    end
    v7.Loading = true
    task.spawn(function() -- line 91 | captures: v7, v2
        local Model = v7.Model
        for v8 = 1, 10 do
            if v2[Model] == v7 then
                local Animations = Model:FindFirstChild("Animations")
                local v9 = Animations and Animations:FindFirstChild("Attack")
                if not (v9 and v9:IsA("Animation") and v9.AnimationId ~= "") then
                    v9 = nil
                end
                local v10
                if v9 then
                    local v11 = Model:FindFirstChildOfClass("AnimationController") or Model:FindFirstChildOfClass("Humanoid")
                    if v11 == nil then
                    else
                        local Animator = v11:FindFirstChildOfClass("Animator")
                        if Animator == nil then
                            Animator = Instance.new("Animator")
                            Animator.Parent = v11
                        end
                        v10 = Animator
                    end
                else
                    v10 = v9
                end
                if not v9 or not v10 then
                    if v8 < 10 then
                        task.wait(0.5)
                    end
                else
                    local pcall_2 = pcall
                    local v12 = v10
                    local v13 = v9
                    local v14, v15 = pcall_2(function() -- line 100 | captures: v12, v13
                        return v12:LoadAnimation(v13)
                    end)
                    if v14 and v15 then
                        if v2[Model] == v7 then
                            v15.Priority = Enum.AnimationPriority.Action
                            v15.Looped = false
                            v7.Track = v15
                        else
                            v15:Destroy()
                        end
                    end
                    break
                end
            else
                break
            end
        end
        v7.Loading = nil
    end)
end

local function onCatchPulse(v16) -- line 125 | captures: v2
    local v17 = v2[v16]
    if v17 then
        local v18 = v16:GetAttribute("CatchPulse") or 0
        if v18 ~= v17.LastCatchPulse then
            v17.LastCatchPulse = v18
            local Track = v17.Track
            if Track == nil then
                if not v17.Loading then
                    v17.Loading = true
                    task.spawn(function() -- line 91 | captures: v17, v2
                        local Model = v17.Model
                        for v19 = 1, 10 do
                            if v2[Model] == v17 then
                                local Animations = Model:FindFirstChild("Animations")
                                local v20 = Animations and Animations:FindFirstChild("Attack")
                                if not (v20 and v20:IsA("Animation") and v20.AnimationId ~= "") then
                                    v20 = nil
                                end
                                local v21
                                if v20 then
                                    local v22 = Model:FindFirstChildOfClass("AnimationController") or Model:FindFirstChildOfClass("Humanoid")
                                    if v22 == nil then
                                    else
                                        local Animator = v22:FindFirstChildOfClass("Animator")
                                        if Animator == nil then
                                            Animator = Instance.new("Animator")
                                            Animator.Parent = v22
                                        end
                                        v21 = Animator
                                    end
                                else
                                    v21 = v20
                                end
                                if not v20 or not v21 then
                                    if v19 < 10 then
                                        task.wait(0.5)
                                    end
                                else
                                    local pcall_2 = pcall
                                    local v23 = v21
                                    local v24 = v20
                                    local v25, v26 = pcall_2(function() -- line 100 | captures: v23, v24
                                        return v23:LoadAnimation(v24)
                                    end)
                                    if v25 and v26 then
                                        if v2[Model] == v17 then
                                            v26.Priority = Enum.AnimationPriority.Action
                                            v26.Looped = false
                                            v17.Track = v26
                                        else
                                            v26:Destroy()
                                        end
                                    end
                                    break
                                end
                            else
                                break
                            end
                        end
                        v17.Loading = nil
                    end)
                end
            else
                if Track.IsPlaying then
                    Track:Stop(0)
                end
                Track:Play(0.1)
            end
        end
    end
end

local function trackGuard(v27) -- line 154 | captures: v2, onCatchPulse
    if not v27:IsA("Model") or v2[v27] then
        return
    end
    local v28 = {
        Track = nil,
        PulseWatch = nil,
        Loading = nil,
        Model = v27,
        LastCatchPulse = v27:GetAttribute("CatchPulse") or 0
    }
    v2[v27] = v28
    local CatchPulse = v27:GetAttributeChangedSignal("CatchPulse")
    v28.PulseWatch = CatchPulse:Connect(function() -- line 166 | captures: v27, onCatchPulse
        onCatchPulse(v27)
    end)
    if not v28.Loading then
        v28.Loading = true
        task.spawn(function() -- line 91 | captures: v28, v2
            local Model = v28.Model
            for v29 = 1, 10 do
                if v2[Model] == v28 then
                    local Animations = Model:FindFirstChild("Animations")
                    local v30 = Animations and Animations:FindFirstChild("Attack")
                    if not (v30 and v30:IsA("Animation") and v30.AnimationId ~= "") then
                        v30 = nil
                    end
                    local v31
                    if v30 then
                        local v32 = Model:FindFirstChildOfClass("AnimationController") or Model:FindFirstChildOfClass("Humanoid")
                        if v32 == nil then
                        else
                            local Animator = v32:FindFirstChildOfClass("Animator")
                            if Animator == nil then
                                Animator = Instance.new("Animator")
                                Animator.Parent = v32
                            end
                            v31 = Animator
                        end
                    else
                        v31 = v30
                    end
                    if not v30 or not v31 then
                        if v29 < 10 then
                            task.wait(0.5)
                        end
                    else
                        local pcall_2 = pcall
                        local v33 = v31
                        local v34 = v30
                        local v35, v36 = pcall_2(function() -- line 100 | captures: v33, v34
                            return v33:LoadAnimation(v34)
                        end)
                        if v35 and v36 then
                            if v2[Model] == v28 then
                                v36.Priority = Enum.AnimationPriority.Action
                                v36.Looped = false
                                v28.Track = v36
                            else
                                v36:Destroy()
                            end
                        end
                        break
                    end
                else
                    break
                end
            end
            v28.Loading = nil
        end)
    end
end

local function untrackGuard(v37) -- line 175 | captures: v2
    local v38 = v2[v37]
    if not v38 then
        return
    end
    v2[v37] = nil
    if v38.PulseWatch then
        v38.PulseWatch:Disconnect()
    end
    if v38.Track then
        v38.Track:Stop(0)
        v38.Track:Destroy()
    end
end

function v1.Start() -- line 190 | captures: CollectionService, trackGuard, untrackGuard
    for v39, v40 in CollectionService:GetTagged("ZoneGuard") do
        trackGuard(v40)
    end
    CollectionService:GetInstanceAddedSignal("ZoneGuard"):Connect(trackGuard)
    CollectionService:GetInstanceRemovedSignal("ZoneGuard"):Connect(untrackGuard)
end

return v1
