-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HeldToolVisualsConfig = require(ReplicatedStorage.Shared.HeldToolVisualsConfig)
local v1 = {}

local function isEffect(v2) -- line 29
    return v2:IsA("ParticleEmitter") or v2:IsA("Beam") or v2:IsA("Trail") or v2:IsA("Light") or v2:IsA("Fire") or v2:IsA("Smoke") or v2:IsA("Sparkles")
end

local v3 = {}

local function thaw(v4) -- line 38 | captures: v3
    local v5 = v3[v4]
    if not v5 then
        return
    end
    v3[v4] = nil
    v4.Anchored = v5.anchored
    v4.LocalTransparencyModifier = 0
    for v6, v7 in v5.effects do
        if v6.Parent then
            v6.Enabled = v7
        end
    end
end

local function freeze(v8) -- line 53 | captures: HeldToolVisualsConfig, isEffect, v3
    if v3[v8] then
        return
    end
    local v9 = {
        anchored = v8.Anchored,
        effects = {}
    }
    v3[v8] = v9
    v8.Anchored = true
    v8.LocalTransparencyModifier = 1
    for v10, v11 in v8:GetDescendants() do
        if isEffect(v11) then
            v9.effects[v11] = v11.Enabled
            v11.Enabled = false
        end
    end
    local v12
    v12 = v8.AncestryChanged:Connect(function() -- line 69 | captures: v12, v8, HeldToolVisualsConfig, v3
        local Parent = v8.Parent
        if Parent and Parent.Parent and Parent.Parent.Name == HeldToolVisualsConfig.FolderName then
            return
        end
        v12:Disconnect()
        local v13 = v3[v8]
        if not v13 then
            return
        end
        v3[v8] = nil
        v8.Anchored = v13.anchored
        v8.LocalTransparencyModifier = 0
        for v14, v15 in v13.effects do
            if v14.Parent then
                v14.Enabled = v15
            end
        end
    end)
end

local function bindHolder(v16) -- line 79 | captures: Workspace, HeldToolVisualsConfig, freeze
    if not v16:IsA("Model") then
        return
    end
    local v17 = v16:WaitForChild(HeldToolVisualsConfig.HandleLinkName, 5)
    local v18, freezeAll
    if v17 and v17:IsA("ObjectValue") then
        local function handleGone() -- line 88 | captures: v17, Workspace
            local Value = v17.Value
            if Value == nil then
                return true
            end
            return not Value:IsDescendantOf(Workspace)
        end

        function freezeAll() -- line 93 | captures: v16, freeze
            for v19, v20 in v16:GetChildren() do
                if v20:IsA("BasePart") then
                    freeze(v20)
                end
            end
        end

        v18 = nil
        local freezeAll_2 = freezeAll

        local function watchHandle() -- line 102 | captures: v18, v17, freezeAll_2, Workspace
            if v18 then
                v18:Disconnect()
                v18 = nil
            end
            local Value = v17.Value
            if Value then
                v18 = Value.AncestryChanged:Connect(function() -- line 109 | captures: v17, freezeAll_2, Workspace
                    local Value = v17.Value
                    if Value == nil or not Value:IsDescendantOf(Workspace) then
                        freezeAll_2()
                    end
                end)
            end
        end

        v17.Changed:Connect(watchHandle)
        if v18 then
            v18:Disconnect()
            v18 = nil
        end
    else
        return
    end
    local Value = v17.Value
    if Value then
        local AncestryChanged = Value.AncestryChanged
        local freezeAll_2 = freezeAll
        v18 = AncestryChanged:Connect(function() -- line 109 | captures: v17, freezeAll_2, Workspace
            local Value = v17.Value
            if Value == nil or not Value:IsDescendantOf(Workspace) then
                freezeAll_2()
            end
        end)
    end
    v16.ChildAdded:Connect(function(v21) -- line 120 | captures: v17, Workspace, freeze
        if v21:IsA("BasePart") and v17.Value then
            local Value = v17.Value
            if Value == nil or not Value:IsDescendantOf(Workspace) then
                freeze(v21)
            end
        end
    end)
    v16.Destroying:Once(function() -- line 125 | captures: v18
        if v18 then
            v18:Disconnect()
            v18 = nil
        end
    end)
    if v17.Value then
        local Value = v17.Value
        if Value == nil or not Value:IsDescendantOf(Workspace) then
            freezeAll()
        end
    end
end

local function bindFolder(v22) -- line 136 | captures: HeldToolVisualsConfig, bindHolder
    if v22.Name == HeldToolVisualsConfig.FolderName then
        v22.ChildAdded:Connect(function(v23) -- line 140 | captures: bindHolder
            task.spawn(bindHolder, v23)
        end)
        for v24, v25 in v22:GetChildren() do
            task.spawn(bindHolder, v25)
        end
    end
end

function v1.Start() -- line 148 | captures: Workspace, HeldToolVisualsConfig, bindFolder
    Workspace.ChildAdded:Connect(bindFolder)
    local v26 = Workspace:FindFirstChild(HeldToolVisualsConfig.FolderName)
    if v26 then
        bindFolder(v26)
    end
end

return v1
