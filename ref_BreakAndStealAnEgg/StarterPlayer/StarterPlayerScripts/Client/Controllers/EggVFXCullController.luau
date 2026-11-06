-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local LuckyEggConfig = require(ReplicatedStorage.Shared.LuckyEggConfig)
local EggCullQuality = require(script.Parent.Parent.Modules.EggCullQuality)
local EggViewFrustum = require(script.Parent.Parent.Modules.EggViewFrustum)
local v1 = {}

local function isCullable(v2) -- line 50
    return v2:IsA("ParticleEmitter") or v2:IsA("Trail") or v2:IsA("Beam") or v2:IsA("Light") or v2:IsA("Fire") or v2:IsA("Smoke") or v2:IsA("Sparkles")
end

local function isViewCullable(v3) -- line 61
    return v3:IsA("ParticleEmitter") or v3:IsA("Fire") or v3:IsA("Smoke") or v3:IsA("Sparkles")
end

local v4 = {}
local v5 = {}

local function effectEnabled(v6, v7) -- line 82
    if v6.near == true then
        return not (v7 and v6.offView)
    end
    return false
end

local function applyState(v8) -- line 88
    for v9, v10 in v8.effects do
        if v9.Parent then
            local v11 = if v8.near == true then not (v10 and v8.offView) else false
            if v9.Enabled ~= v11 then
                v9.Enabled = v11
            end
        else
            v8.effects[v9] = nil
        end
    end
end

local function applyNear(v12, v13) -- line 101 | captures: applyState
    v12.near = v13
    applyState(v12)
end

local function setOffView(v14, v15, v16) -- line 106 | captures: v5, applyState
    v15.offView = v16
    v15.offscreenSince = nil
    local v17 = if v16 then v15 else nil
    v5[v14] = v17
    applyState(v15)
end

local function untrack(v18) -- line 116 | captures: v4, v5
    local v19 = v4[v18]
    if not v19 then
        return
    end
    v4[v18] = nil
    v5[v18] = nil
    for v20, v21 in v19.connections do
        v21:Disconnect()
    end
end

local function track(v22) -- line 128 | captures: isCullable, v4, v5, applyState
    local function v23(v24, ...)
        table.insert(v24, ...)
    end

    local function v25(v26, ...)
        table.insert(v26, ...)
    end

    local function v27(v28, ...)
        table.insert(v28, ...)
    end

    if not v22:IsA("BasePart") or v4[v22] then
        return
    end
    if v22:GetAttribute("Hatching") or v22:GetAttribute("Broken") then
        return
    end
    local Model = v22:FindFirstAncestorOfClass("Model")
    if Model then
        if Model.PrimaryPart ~= v22 then
            Model = v22
        end
    else
        Model = v22
    end
    local v29 = {
        near = nil,
        offView = false,
        offscreenSince = nil,
        root = Model,
        effects = {},
        connections = {}
    }
    v4[v22] = v29

    local function register(v30) -- line 157 | captures: v29, isCullable
        local ParticleEmitter
        if isCullable(v30) and v30.Enabled then
            ParticleEmitter = v30:IsA("ParticleEmitter") or v30:IsA("Fire") or v30:IsA("Smoke") or v30:IsA("Sparkles")
        else
            return
        end
        v29.effects[v30] = ParticleEmitter
        if v29.near ~= nil and not (v29.near == true and not (ParticleEmitter and v29.offView)) then
            v30.Enabled = false
        end
    end

    for v31, v32 in Model:GetDescendants() do
        if isCullable(v32) and v32.Enabled then
            local ParticleEmitter = v32:IsA("ParticleEmitter") or v32:IsA("Fire") or v32:IsA("Smoke") or v32:IsA("Sparkles")
            v29.effects[v32] = ParticleEmitter
            if v29.near ~= nil and not (v29.near == true and not (ParticleEmitter and v29.offView)) then
                v32.Enabled = false
            end
        end
    end
    v23(v29.connections, Model.DescendantAdded:Connect(register))

    local function handOver() -- line 179 | captures: v22, v29, v4, v5, applyState
        if v29.offView then
            v29.offView = false
            v29.offscreenSince = nil
            v5[v22] = nil
            applyState(v29)
        end
        local v33 = v4[v22]
        if not v33 then
            return
        end
        v4[v22] = nil
        v5[v22] = nil
        for v34, v35 in v33.connections do
            v35:Disconnect()
        end
    end

    v25(v29.connections, v22:GetAttributeChangedSignal("Hatching"):Connect(function() -- line 185 | captures: v22, v29, v4, v5, applyState
        if not v22:GetAttribute("Hatching") then
            return
        end
        if v29.offView then
            v29.offView = false
            v29.offscreenSince = nil
            v5[v22] = nil
            applyState(v29)
        end
        local v36 = v4[v22]
        if not v36 then
            return
        end
        v4[v22] = nil
        v5[v22] = nil
        for v37, v38 in v36.connections do
            v38:Disconnect()
        end
    end))
    v27(v29.connections, v22:GetAttributeChangedSignal("Broken"):Connect(function() -- line 190 | captures: v22, v29, v4, v5, applyState
        if not v22:GetAttribute("Broken") then
            return
        end
        if v29.offView then
            v29.offView = false
            v29.offscreenSince = nil
            v5[v22] = nil
            applyState(v29)
        end
        local v39 = v4[v22]
        if not v39 then
            return
        end
        v4[v22] = nil
        v5[v22] = nil
        for v40, v41 in v39.connections do
            v41:Disconnect()
        end
    end))
end

function v1.Start() -- line 197 | captures: CollectionService, RunService, EggConfig, LuckyEggConfig, EggCullQuality, EggViewFrustum, v4, v5, applyState, untrack, track
    for v42, v43 in CollectionService:GetTagged("BreakableEgg") do
        track(v43)
    end
    CollectionService:GetInstanceAddedSignal("BreakableEgg"):Connect(track)
    CollectionService:GetInstanceRemovedSignal("BreakableEgg"):Connect(untrack)
    local AmbientCull = EggConfig.AmbientCull
    local ViewCull = EggConfig.ViewCull
    local v44 = ViewCull.PauseEggVFX == true
    if v44 then
        RunService:BindToRenderStep("EggVFXCullView", EggViewFrustum.RENDER_PRIORITY_AFTER, function() -- line 215 | captures: EggViewFrustum, v4, v5, applyState
            for v45, v46 in v5 do
                if v45.Parent then
                    if EggViewFrustum.IsEggVisible(v45) then
                        v46.offView = false
                        v46.offscreenSince = nil
                        v5[v45] = nil
                        applyState(v46)
                    end
                else
                    local v47 = v4[v45]
                    if v47 then
                        v4[v45] = nil
                        v5[v45] = nil
                        for v48, v49 in v47.connections do
                            v49:Disconnect()
                        end
                    end
                end
            end
        end)
    end
    local v50 = 0
    RunService.Heartbeat:Connect(function() -- line 227 | captures: v50, AmbientCull, ViewCull, v44, LuckyEggConfig, EggCullQuality, EggViewFrustum, v4, v5, applyState
        local v51 = os.clock()
        if v51 < v50 then
            return
        end
        v50 = v51 + AmbientCull.CheckInterval
        local CurrentCamera = workspace.CurrentCamera
        if CurrentCamera then
            local Position = CurrentCamera.CFrame.Position
            for v52, v53 in v4 do
                if v52.Parent then
                    local Position_2 = v52.Position
                    local v54 = Position_2 - Position
                    local v55 = v54:Dot(v54)
                    local v56 = v52:GetAttribute("Lucky") == true
                    local EggDistance = EggCullQuality.EggDistance
                    local v57 = if v56 then LuckyEggConfig.AuraViewDistance else AmbientCull.Distance
                    local v58 = EggDistance(v57, v52)
                    local v59 = v58 * v58
                    local v60 = (v58 + AmbientCull.Hysteresis) ^ 2
                    local v61 = EggCullQuality.EggHideDelay(ViewCull.HideDelay, v52)
                    if v53.near == nil then
                        v53.near = v55 <= v60
                        applyState(v53)
                    elseif v53.near and v60 <= v55 then
                        v53.near = false
                        applyState(v53)
                    elseif not v53.near and v55 <= v59 then
                        v53.near = true
                        applyState(v53)
                    end
                    if v44 and not v53.offView then
                        if v53.near then
                            if EggViewFrustum.IsVisible(Position_2, v52.Size) then
                                v53.offscreenSince = nil
                            elseif v53.offscreenSince then
                                if v61 <= v51 - v53.offscreenSince then
                                    v53.offView = true
                                    v53.offscreenSince = nil
                                    v5[v52] = v53
                                    applyState(v53)
                                end
                            else
                                v53.offscreenSince = v51
                            end
                        else
                            v53.offscreenSince = nil
                        end
                    end
                else
                    local v62 = v4[v52]
                    if v62 then
                        v4[v52] = nil
                        v5[v52] = nil
                        for v63, v64 in v62.connections do
                            v64:Disconnect()
                        end
                    end
                end
            end
        end
    end)
end

return v1
