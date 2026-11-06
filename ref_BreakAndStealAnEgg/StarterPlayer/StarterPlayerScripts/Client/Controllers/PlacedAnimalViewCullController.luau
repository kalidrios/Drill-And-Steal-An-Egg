-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local EggViewFrustum = require(script.Parent.Parent.Modules.EggViewFrustum)
local LocalModelHider = require(script.Parent.Parent.Modules.LocalModelHider)
local ZonePlotCullController = require(script.Parent.ZonePlotCullController)
local v1 = {}
local v2 = {}
local v3 = {}

function v1.IsCulled(v4) -- line 60 | captures: LocalModelHider, ZonePlotCullController, v3
    if v3[v4] == nil then
        return ZonePlotCullController.IsActive() and LocalModelHider.IsHidden(v4, ZonePlotCullController.HIDE_REASON)
    end
    return true
end

local function resolveRoot(v5) -- line 65
    local root = v5.root
    if root and root.Parent then
        return root
    end
    local v6 = v5.model.PrimaryPart or v5.model:FindFirstChildWhichIsA("BasePart", true)
    v5.root = v6
    return v6
end

local function isVisible(v7, v8) -- line 78 | captures: EggViewFrustum
    local root = v7.root
    local v9
    if root and root.Parent then
        v9 = root
    else
        local PrimaryPart = v7.model.PrimaryPart or v7.model:FindFirstChildWhichIsA("BasePart", true)
        v7.root = PrimaryPart
        v9 = PrimaryPart
    end
    if v9 then
        if v7.size == nil or v7.sizeAt <= v8 then
            v7.size = v7.model:GetExtentsSize()
            v7.sizeAt = v8 + 3
        end
        return EggViewFrustum.IsVisible(v9.Position, v7.size)
    end
    return true
end

local v10 = EggConfig.ViewCull.HidePlacedAnimals == true

local function setCulled(v11, v12) -- line 97 | captures: LocalModelHider, v3, v10
    v11.culled = v12
    v11.offscreenSince = nil
    local model = v11.model
    if v12 then
        v3[model] = v11
        if v10 then
            LocalModelHider.Hide(model, "ViewCull")
        end
    else
        v3[model] = nil
        if v10 then
            LocalModelHider.Show(model, "ViewCull")
        end
    end
end

local function track(v13) -- line 114 | captures: v2
    if v13:IsA("Model") and not v2[v13] then
        v2[v13] = {
            root = nil,
            size = nil,
            sizeAt = 0,
            culled = false,
            offscreenSince = nil,
            model = v13
        }
    end
end

local function untrack(v14) -- line 130 | captures: LocalModelHider, v2, v3, v10
    local v15 = v2[v14]
    if v15 then
        v2[v14] = nil
        if v15.culled then
            v15.culled = false
            v15.offscreenSince = nil
            local model = v15.model
            v3[model] = nil
            if v10 then
                LocalModelHider.Show(model, "ViewCull")
            end
        end
    end
end

function v1.Start() -- line 141 | captures: CollectionService, RunService, EggConfig, EggViewFrustum, LocalModelHider, ZonePlotCullController, v2, v3, v10, track, untrack
    for v16, v17 in CollectionService:GetTagged("PlacedAnimal") do
        if v17:IsA("Model") and not v2[v17] then
            v2[v17] = {
                root = nil,
                size = nil,
                sizeAt = 0,
                culled = false,
                offscreenSince = nil,
                model = v17
            }
        end
    end
    CollectionService:GetInstanceAddedSignal("PlacedAnimal"):Connect(track)
    CollectionService:GetInstanceRemovedSignal("PlacedAnimal"):Connect(untrack)
    local HideDelay = EggConfig.ViewCull.HideDelay
    RunService:BindToRenderStep("PlacedAnimalViewCull", EggViewFrustum.RENDER_PRIORITY_AFTER, function() -- line 152 | captures: EggViewFrustum, LocalModelHider, v2, v3, v10
        if next(v3) ~= nil then
            local v18 = os.clock()
            for v19, v20 in v3 do
                if v19.Parent then
                    local root = v20.root
                    if not (root and root.Parent) then
                        root = v20.model.PrimaryPart or v20.model:FindFirstChildWhichIsA("BasePart", true)
                        v20.root = root
                    end
                    local v21
                    if root then
                        if v20.size == nil or v20.sizeAt <= v18 then
                            v20.size = v20.model:GetExtentsSize()
                            v20.sizeAt = v18 + 3
                        end
                        v21 = EggViewFrustum.IsVisible(root.Position, v20.size)
                    else
                        v21 = true
                    end
                    if v21 then
                        v20.culled = false
                        v20.offscreenSince = nil
                        local model = v20.model
                        v3[model] = nil
                        if v10 then
                            LocalModelHider.Show(model, "ViewCull")
                        end
                    end
                else
                    local v22 = v2[v19]
                    if v22 then
                        v2[v19] = nil
                        if v22.culled then
                            v22.culled = false
                            v22.offscreenSince = nil
                            local model = v22.model
                            v3[model] = nil
                            if v10 then
                                LocalModelHider.Show(model, "ViewCull")
                            end
                        end
                    end
                end
            end
        end
    end)
    local v23 = 0
    RunService.Heartbeat:Connect(function() -- line 168 | captures: v23, HideDelay, EggViewFrustum, LocalModelHider, ZonePlotCullController, v2, v3, v10
        local v24 = os.clock()
        if not (v24 < v23) then
            v23 = v24 + 0.25
            if not ZonePlotCullController.IsActive() then
                for v25, v26 in v2 do
                    if not v26.culled then
                        if v25.Parent then
                            local root = v26.root
                            if not (root and root.Parent) then
                                root = v26.model.PrimaryPart or v26.model:FindFirstChildWhichIsA("BasePart", true)
                                v26.root = root
                            end
                            local v27
                            if root then
                                if v26.size == nil or v26.sizeAt <= v24 then
                                    v26.size = v26.model:GetExtentsSize()
                                    v26.sizeAt = v24 + 3
                                end
                                v27 = EggViewFrustum.IsVisible(root.Position, v26.size)
                            else
                                v27 = true
                            end
                            if v27 then
                                v26.offscreenSince = nil
                            elseif v26.offscreenSince then
                                local v28 = v24 - v26.offscreenSince
                                if HideDelay <= v28 then
                                    v26.culled = true
                                    v26.offscreenSince = nil
                                    local model = v26.model
                                    v3[model] = v26
                                    if v10 then
                                        LocalModelHider.Hide(model, "ViewCull")
                                    end
                                end
                            else
                                v26.offscreenSince = v24
                            end
                        else
                            v26.offscreenSince = nil
                        end
                    end
                end
            end
        end
    end)
end

return v1
