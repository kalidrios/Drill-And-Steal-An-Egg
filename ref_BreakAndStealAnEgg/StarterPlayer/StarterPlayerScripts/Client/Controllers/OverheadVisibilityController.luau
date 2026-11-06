-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SafeZoneQuery = require(ReplicatedStorage.Shared.SafeZoneQuery)
local LocalCharacter = require(script.Parent.Parent.Modules.LocalCharacter)
local WaitFor = require(ReplicatedStorage.Shared.WaitFor)
local v1 = {}
local v2 = {}
local v3 = {}
local v4 = {}

local function resolveHitbox(v5) -- line 42
    local v6 = v5
    local v7
    while true do
        if v6 then
            if not (v6:IsA("Folder") and v6.Name == "PlacedAnimals") then
                v6 = v6.Parent
                continue
            end
            local Parent = v6.Parent
            v7 = Parent and Parent:FindFirstChild("Hitbox")
            break
        end
        return nil
    end
    if not (v7 and v7:IsA("BasePart")) then
        return nil
    end
    return v7
end

local function setEnabled(v8, v9) -- line 58
    if v8.Enabled ~= v9 then
        v8.Enabled = v9
    end
end

local function untrack(v10) -- line 66 | captures: v2, v3, v4
    local v11 = v2[v10]
    v2[v10] = nil
    if v10.Parent and v10.Enabled ~= false then
        v10.Enabled = false
    end
    if v11 then
        local v12 = v3[v11]
        if v12 then
            v12[v10] = nil
            if next(v12) == nil then
                v3[v11] = nil
                v4[v11] = nil
            end
        end
    end
end

local function bind(v13, v14) -- line 87 | captures: v2, v3, v4
    local v15 = v2[v13]
    v2[v13] = nil
    if v13.Parent and v13.Enabled ~= false then
        v13.Enabled = false
    end
    if v15 then
        local v16 = v3[v15]
        if v16 then
            v16[v13] = nil
            if next(v16) == nil then
                v3[v15] = nil
                v4[v15] = nil
            end
        end
    end
    v2[v13] = v14
    local v17 = v3[v14]
    if not v17 then
        v17 = {}
        v3[v14] = v17
    end
    v17[v13] = true
    local v18 = v4[v14] == true
    if v13.Enabled ~= v18 then
        v13.Enabled = v18
    end
end

local function trackOverhead(v19) -- line 106 | captures: WaitFor, v2, v3, v4, resolveHitbox
    if v19:IsA("BillboardGui") then
        local v20 = resolveHitbox(v19)
        if v20 then
            local v21 = v2[v19]
            v2[v19] = nil
            if v19.Parent and v19.Enabled ~= false then
                v19.Enabled = false
            end
            if v21 then
                local v22 = v3[v21]
                if v22 then
                    v22[v19] = nil
                    if next(v22) == nil then
                        v3[v21] = nil
                        v4[v21] = nil
                    end
                end
            end
            v2[v19] = v20
            local v23 = v3[v20]
            if not v23 then
                v23 = {}
                v3[v20] = v23
            end
            v23[v19] = true
            local v24 = v4[v20] == true
            if v19.Enabled ~= v24 then
                v19.Enabled = v24
            end
        else
            task.spawn(function() -- line 119 | captures: v19, WaitFor, v2, v3, v4, resolveHitbox
                local v25 = WaitFor.Until(function() -- line 120 | captures: v19, resolveHitbox
                    if v19.Parent then
                        return (resolveHitbox(v19))
                    end
                    return "gone"
                end, 5)
                local v26, v27, v28
                if typeof(v25) == "Instance" and v19.Parent then
                    if v2[v19] then
                        v28 = true
                    else
                        v26 = v19
                        v27 = v2[v19]
                        v2[v19] = nil
                        if v19.Parent and v19.Enabled ~= false then
                            v19.Enabled = false
                        end
                        v28 = false
                    end
                else
                    v28 = true
                end
                if v28 then
                    return
                end
                if v27 then
                    local v29 = v3[v27]
                    if v29 then
                        v29[v26] = nil
                        if next(v29) == nil then
                            v3[v27] = nil
                            v4[v27] = nil
                        end
                    end
                end
                v2[v26] = v25
                local v30 = v3[v25]
                if not v30 then
                    v30 = {}
                    v3[v25] = v30
                end
                v30[v26] = true
                local v31 = v4[v25] == true
                if v26.Enabled ~= v31 then
                    v26.Enabled = v31
                end
            end)
        end
    end
end

local IsPositionInPart = SafeZoneQuery.IsPositionInPart

function v1.Start() -- line 135 | captures: CollectionService, RunService, LocalCharacter, v2, v3, v4, trackOverhead, IsPositionInPart
    for v32, v33 in CollectionService:GetTagged("PlotOverhead") do
        trackOverhead(v33)
    end
    CollectionService:GetInstanceAddedSignal("PlotOverhead"):Connect(trackOverhead)
    CollectionService:GetInstanceRemovedSignal("PlotOverhead"):Connect(function(v34) -- line 140 | captures: v2, v3, v4
        if not v34:IsA("BillboardGui") then
            return
        end
        local v35 = v2[v34]
        v2[v34] = nil
        if v34.Parent and v34.Enabled ~= false then
            v34.Enabled = false
        end
        if v35 then
            local v36 = v3[v35]
            if v36 then
                v36[v34] = nil
                if next(v36) == nil then
                    v3[v35] = nil
                    v4[v35] = nil
                end
            end
        end
    end)
    RunService.Heartbeat:Connect(function() -- line 146 | captures: LocalCharacter, v2, v3, v4, IsPositionInPart
        local v37 = LocalCharacter.GetPosition()
        for v38, v39 in v3 do
            if v38.Parent then
                local v40
                if v37 == nil then
                    v40 = false
                else
                    v40 = IsPositionInPart(v38, v37)
                end
                if v4[v38] ~= v40 then
                    v4[v38] = v40
                    for v41 in v39 do
                        if v41.Parent then
                            if v41.Enabled ~= v40 then
                                v41.Enabled = v40
                            end
                        else
                            v39[v41] = nil
                            v2[v41] = nil
                        end
                    end
                end
            else
                for v42 in v39 do
                    v2[v42] = nil
                end
                v3[v38] = nil
                v4[v38] = nil
            end
        end
    end)
end

return v1
