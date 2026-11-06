-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local EggInfoUi = require(ReplicatedStorage.Shared.EggInfoUi)
local EggCullQuality = require(script.Parent.Parent.Modules.EggCullQuality)
local EggViewFrustum = require(script.Parent.Parent.Modules.EggViewFrustum)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}
local v3 = {}

local function hideInstance(v4, v5) -- line 68 | captures: LocalPlayer
    if v4.saved[v5] ~= nil then
        return
    end
    if not (v5:IsA("BasePart") or v5:IsA("Decal")) then
        if v5:IsA("BillboardGui") then
            v4.saved[v5] = v5.PlayerToHideFrom or false
            v5.PlayerToHideFrom = LocalPlayer
        end
    else
        v4.saved[v5] = true
        v5.LocalTransparencyModifier = 1
    end
end

local function showInstance(v6, v7) -- line 84
    if not (v6:IsA("BasePart") or v6:IsA("Decal")) then
        if v6:IsA("BillboardGui") then
            if v7 == false then
                v6.PlayerToHideFrom = nil
            else
                v6.PlayerToHideFrom = v7
            end
        end
    else
        v6.LocalTransparencyModifier = 0
    end
end

local function applyHidden(v8, v9) -- line 92 | captures: hideInstance
    v8.hidden = v9
    if v9 then
        if v8.root:IsA("BasePart") then
            hideInstance(v8, v8.root)
        end
        for v10, v11 in v8.root:GetDescendants() do
            hideInstance(v8, v11)
        end
    else
        for v12, v13 in v8.saved do
            if v12:IsA("BasePart") or v12:IsA("Decal") then
                v12.LocalTransparencyModifier = 0
            elseif v12:IsA("BillboardGui") then
                if v13 == false then
                    v12.PlayerToHideFrom = nil
                else
                    v12.PlayerToHideFrom = v13
                end
            end
        end
        table.clear(v8.saved)
    end
end

local function refresh(v14) -- line 110 | captures: applyHidden
    local v15 = if v14.far == true then true else v14.offView
    if v14.hidden ~= v15 then
        applyHidden(v14, v15)
    end
end

local function setOffView(v16, v17, v18) -- line 117 | captures: v3, applyHidden
    v17.offView = v18
    v17.offscreenSince = nil
    local v19 = if v18 then v17 else nil
    v3[v16] = v19
    local v20 = if v17.far == true then true else v17.offView
    if v17.hidden ~= v20 then
        applyHidden(v17, v20)
    end
end

local function untrack(v21) -- line 127 | captures: EggInfoUi, LocalPlayer, v2, v3
    local v22 = v2[v21]
    if not v22 then
        return
    end
    v2[v21] = nil
    v3[v21] = nil
    for v23, v24 in v22.connections do
        v24:Disconnect()
    end
    for v25, v26 in v22.saved do
        if v25:IsA("BasePart") or v25:IsA("Decal") then
            v25.LocalTransparencyModifier = 0
        elseif v25:IsA("BillboardGui") then
            if v26 == false then
                v25.PlayerToHideFrom = nil
            else
                v25.PlayerToHideFrom = v26
            end
        end
    end
    table.clear(v22.saved)
    if v21:IsA("BasePart") then
        local v27 = EggInfoUi.Find(v21)
        if v27 and v27.PlayerToHideFrom == LocalPlayer then
            v27.PlayerToHideFrom = nil
        end
    end
end

local function track(v28) -- line 154 | captures: v2, hideInstance, untrack
    local function v29(v30, ...)
        table.insert(v30, ...)
    end

    local function v31(v32, ...)
        table.insert(v32, ...)
    end

    local function v33(v34, ...)
        table.insert(v34, ...)
    end

    local function v35(v36, ...)
        table.insert(v36, ...)
    end

    local function v37(v38, ...)
        table.insert(v38, ...)
    end

    if not v28:IsA("BasePart") or v2[v28] or v28:GetAttribute("Titanic") then
        return
    end
    if v28:GetAttribute("Hatching") or v28:GetAttribute("Broken") then
        return
    end
    local Model = v28:FindFirstAncestorOfClass("Model")
    if Model then
        if Model.PrimaryPart ~= v28 then
            Model = v28
        end
    else
        Model = v28
    end
    local v39 = {
        hidden = nil,
        far = nil,
        offView = false,
        offscreenSince = nil,
        root = Model,
        saved = {},
        connections = {}
    }
    v2[v28] = v39
    v29(v39.connections, Model.DescendantAdded:Connect(function(v40) -- line 184 | captures: v39, hideInstance
        if v39.hidden then
            hideInstance(v39, v40)
        end
    end))
    v31(v39.connections, Model.DescendantRemoving:Connect(function(v41) -- line 189 | captures: v39
        local v42 = v39.saved[v41]
        if v42 == nil then
            return
        end
        v39.saved[v41] = nil
        if v41:IsA("BasePart") or v41:IsA("Decal") then
            v41.LocalTransparencyModifier = 0
        elseif v41:IsA("BillboardGui") then
            if v42 == false then
                v41.PlayerToHideFrom = nil
            else
                v41.PlayerToHideFrom = v42
            end
        end
    end))
    v33(v39.connections, v28:GetAttributeChangedSignal("Hatching"):Connect(function() -- line 207 | captures: v28, untrack
        if v28:GetAttribute("Hatching") then
            untrack(v28)
        end
    end))
    v35(v39.connections, v28:GetAttributeChangedSignal("Broken"):Connect(function() -- line 212 | captures: v28, untrack
        if v28:GetAttribute("Broken") then
            untrack(v28)
        end
    end))
    v37(v39.connections, v28:GetAttributeChangedSignal("Titanic"):Connect(function() -- line 218 | captures: v28, untrack
        if v28:GetAttribute("Titanic") then
            untrack(v28)
        end
    end))
end

function v1.Start() -- line 225 | captures: CollectionService, RunService, EggConfig, EggInfoUi, EggCullQuality, EggViewFrustum, LocalPlayer, v2, v3, applyHidden, untrack, track
    for v43, v44 in CollectionService:GetTagged("BreakableEgg") do
        track(v44)
    end
    CollectionService:GetInstanceAddedSignal("BreakableEgg"):Connect(track)
    CollectionService:GetInstanceRemovedSignal("BreakableEgg"):Connect(untrack)
    local HideCull = EggConfig.HideCull
    local ViewCull = EggConfig.ViewCull
    local v45 = ViewCull.HideEggShells == true
    if v45 then
        RunService:BindToRenderStep("EggHideCullView", EggViewFrustum.RENDER_PRIORITY_AFTER, function() -- line 243 | captures: EggViewFrustum, v3, applyHidden, untrack
            for v46, v47 in v3 do
                if v46.Parent then
                    if EggViewFrustum.IsEggVisible(v46) then
                        v47.offView = false
                        v47.offscreenSince = nil
                        v3[v46] = nil
                        local v48 = if v47.far == true then true else v47.offView
                        if v47.hidden ~= v48 then
                            applyHidden(v47, v48)
                        end
                    end
                else
                    untrack(v46)
                end
            end
        end)
    end
    local v49 = 0
    RunService.Heartbeat:Connect(function() -- line 255 | captures: v49, HideCull, ViewCull, v45, EggInfoUi, EggCullQuality, EggViewFrustum, LocalPlayer, v2, v3, applyHidden, untrack
        local v50 = os.clock()
        if v50 < v49 then
            return
        end
        v49 = v50 + HideCull.CheckInterval
        local CurrentCamera = workspace.CurrentCamera
        if CurrentCamera then
            local Position = CurrentCamera.CFrame.Position
            for v51, v52 in v2 do
                if v51.Parent then
                    local v53 = EggCullQuality.EggDistance(HideCull.Distance, v51)
                    local v54 = v53 * v53
                    local v55 = (v53 + HideCull.Hysteresis) ^ 2
                    local v56 = EggCullQuality.EggHideDelay(ViewCull.HideDelay, v51)
                    local Position_2 = v51.Position
                    local v57 = Position_2 - Position
                    local v58 = v57:Dot(v57)
                    if v52.far == nil then
                        v52.far = v55 <= v58
                    elseif v52.far and v58 <= v54 then
                        v52.far = false
                    elseif not v52.far and v55 <= v58 then
                        v52.far = true
                    end
                    if v45 and not v52.offView then
                        if v52.far or EggViewFrustum.IsVisible(Position_2, v51.Size) then
                            v52.offscreenSince = nil
                        elseif v52.offscreenSince then
                            if v56 <= v50 - v52.offscreenSince then
                                v52.offView = true
                                v52.offscreenSince = nil
                                v3[v51] = v52
                                local v59 = if v52.far == true then true else v52.offView
                                if v52.hidden ~= v59 then
                                    applyHidden(v52, v59)
                                end
                            end
                        else
                            v52.offscreenSince = v50
                        end
                    end
                    local v60 = if v52.far == true then true else v52.offView
                    if v52.hidden ~= v60 then
                        applyHidden(v52, v60)
                    end
                    if not v52.hidden then
                        local v61 = EggInfoUi.Find(v51)
                        if v61 and v61.PlayerToHideFrom == LocalPlayer and v52.saved[v61] == nil then
                            v61.PlayerToHideFrom = nil
                        end
                    end
                else
                    untrack(v51)
                end
            end
        end
    end)
end

return v1
