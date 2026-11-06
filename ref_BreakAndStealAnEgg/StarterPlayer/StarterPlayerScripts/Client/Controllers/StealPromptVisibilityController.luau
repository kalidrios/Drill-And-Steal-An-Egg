-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SatchelConfig = require(ReplicatedStorage.Shared.SatchelConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = false
local v3 = {}
local v4 = {}

local function isSatchelFull() -- line 32 | captures: SatchelConfig, LocalPlayer
    local CarryCount = LocalPlayer:GetAttribute("CarryCount")
    local v5 = LocalPlayer:GetAttribute(SatchelConfig.CapacityAttribute)
    if typeof(v5) ~= "number" then
        v5 = SatchelConfig.CapacityFor(SatchelConfig.DefaultTier)
    end
    if typeof(CarryCount) == "number" then
        return v5 <= CarryCount
    end
    return false
end

local function apply(v6) -- line 41 | captures: v2, v3
    local v7 = if v3[v6] == true then not v2 else false
    if v6.Enabled ~= v7 then
        v6.Enabled = v7
    end
end

local function untrack(v8) -- line 48 | captures: v3, v4
    local v9 = v4[v8]
    if v9 then
        for v10, v11 in v9 do
            v11:Disconnect()
        end
    end
    v4[v8] = nil
    v3[v8] = nil
end

local function track(v12) -- line 59 | captures: v2, v3, v4
    local v13, v14
    if v12:IsA("ProximityPrompt") and v12.Name == "StealPrompt" then
        if v4[v12] then
            v14 = true
        else
            v3[v12] = v12.Enabled
            local v15 = v12:GetPropertyChangedSignal("Enabled"):Connect(function() -- line 66 | captures: v12, v2, v3
                local v16 = v2
                local Enabled
                if v16 then
                    Enabled = v12.Enabled
                else
                    v3[v12] = v12.Enabled
                end
                if (not v16 or Enabled) and v16 then
                    v3[v12] = true
                    v12.Enabled = false
                end
            end)
            local Destroying = v12.Destroying
            v4[v12] = {
                v15,
                Destroying:Once(function() -- line 79 | captures: v12, v3, v4
                    local v17 = v4[v12]
                    if v17 then
                        for v18, v19 in v17 do
                            v19:Disconnect()
                        end
                    end
                    v4[v12] = nil
                    v3[v12] = nil
                end)
            }
            if v3[v12] == true then
                v13 = not v2
            else
                v13 = false
            end
            v14 = false
        end
    else
        v14 = true
    end
    if v14 then
        return
    end
    if v12.Enabled ~= v13 then
        v12.Enabled = v13
    end
end

local function refresh() -- line 86 | captures: v2, SatchelConfig, LocalPlayer, v3
    local CarryCount = LocalPlayer:GetAttribute("CarryCount")
    local v20 = LocalPlayer:GetAttribute(SatchelConfig.CapacityAttribute)
    if typeof(v20) ~= "number" then
        v20 = SatchelConfig.CapacityFor(SatchelConfig.DefaultTier)
    end
    local v21 = if typeof(CarryCount) == "number" then v20 <= CarryCount else false
    if v21 ~= v2 then
        v2 = v21
        for v22 in v3 do
            local v23 = if v3[v22] == true then not v2 else false
            if v22.Enabled ~= v23 then
                v22.Enabled = v23
            end
        end
    end
end

function v1.Start() -- line 97 | captures: v2, CollectionService, SatchelConfig, LocalPlayer, v3, v4, track, refresh
    for v24, v25 in CollectionService:GetTagged("SmartPrompt") do
        track(v25)
    end
    CollectionService:GetInstanceAddedSignal("SmartPrompt"):Connect(track)
    CollectionService:GetInstanceRemovedSignal("SmartPrompt"):Connect(function(v26) -- line 102 | captures: v3, v4
        if not (v26:IsA("ProximityPrompt") and v4[v26]) then
            return
        end
        local v27 = v3[v26]
        local v28 = v4[v26]
        if v28 then
            for v29, v30 in v28 do
                v30:Disconnect()
            end
        end
        v4[v26] = nil
        v3[v26] = nil
        if v27 ~= nil and v26.Enabled ~= v27 then
            v26.Enabled = v27
        end
    end)
    LocalPlayer:GetAttributeChangedSignal("CarryCount"):Connect(refresh)
    LocalPlayer:GetAttributeChangedSignal(SatchelConfig.CapacityAttribute):Connect(refresh)
    local CarryCount = LocalPlayer:GetAttribute("CarryCount")
    local v31 = LocalPlayer:GetAttribute(SatchelConfig.CapacityAttribute)
    if typeof(v31) ~= "number" then
        v31 = SatchelConfig.CapacityFor(SatchelConfig.DefaultTier)
    end
    local v32 = if typeof(CarryCount) == "number" then v31 <= CarryCount else false
    if v32 ~= v2 then
        v2 = v32
        for v33 in v3 do
            local v34 = if v3[v33] == true then not v2 else false
            if v33.Enabled ~= v34 then
                v33.Enabled = v34
            end
        end
    end
end

return v1
