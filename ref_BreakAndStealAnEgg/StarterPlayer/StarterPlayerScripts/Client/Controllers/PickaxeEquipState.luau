-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer

v1.Changed = Instance.new("BindableEvent")

local v2 = false
local v3 = false
local v4 = {}

local function isPickaxe(v5) -- line 44 | captures: PickaxeConfig
    if v5.Name == PickaxeConfig.ToolName then
        return (v5:IsA("Tool"))
    end
    return false
end

local function readState(v6) -- line 48 | captures: PickaxeConfig
    if v6 then
        local v7 = v6:FindFirstChild(PickaxeConfig.ToolName)
        if v7 == nil then
            return false
        end
        return (v7:IsA("Tool"))
    end
    return false
end

local function setState(v8) -- line 56 | captures: v2, v1
    if v2 ~= v8 then
        v2 = v8
        v1.Changed:Fire(v2)
    end
end

local function watchCharacter(v9) -- line 64 | captures: v2, PickaxeConfig, v1, LocalPlayer, v4
    local function v10(v11, ...)
        table.insert(v11, ...)
    end

    local function v12(v13, ...)
        table.insert(v13, ...)
    end

    for v14, v15 in v4 do
        v15:Disconnect()
    end
    table.clear(v4)
    v10(v4, v9.ChildAdded:Connect(function(v16) -- line 72 | captures: v2, PickaxeConfig, v1
        if not (v16.Name == PickaxeConfig.ToolName and v16:IsA("Tool")) then
            return
        end
        if v2 == true then
            return
        end
        v2 = true
        v1.Changed:Fire(v2)
    end))
    v12(v4, v9.ChildRemoved:Connect(function(v17) -- line 80 | captures: v2, PickaxeConfig, v1, LocalPlayer
        if not (v17.Name == PickaxeConfig.ToolName and v17:IsA("Tool")) then
            return
        end
        local Character = LocalPlayer.Character
        local v18
        if Character then
            local v19 = Character:FindFirstChild(PickaxeConfig.ToolName)
            if v19 == nil then
                v18 = false
            else
                v18 = v19:IsA("Tool")
            end
        else
            v18 = false
        end
        if v2 == v18 then
            return
        end
        v2 = v18
        v1.Changed:Fire(v2)
    end))
    local v20
    if v9 then
        local v21 = v9:FindFirstChild(PickaxeConfig.ToolName)
        if v21 == nil then
            v20 = false
        else
            v20 = v21:IsA("Tool")
        end
    else
        v20 = false
    end
    if v2 ~= v20 then
        v2 = v20
        v1.Changed:Fire(v2)
    end
end

local function ensureStarted() -- line 94 | captures: v2, v3, v1, LocalPlayer, watchCharacter
    if v3 then
        return
    end
    v3 = true
    LocalPlayer.CharacterAdded:Connect(watchCharacter)
    local Character = LocalPlayer.Character
    if Character then
        watchCharacter(Character)
    elseif v2 ~= false then
        v2 = false
        v1.Changed:Fire(v2)
    end
end

function v1.IsEquipped() -- line 109 | captures: v2, v3, v1, LocalPlayer, watchCharacter
    if not v3 then
        v3 = true
        LocalPlayer.CharacterAdded:Connect(watchCharacter)
        local Character = LocalPlayer.Character
        if Character then
            watchCharacter(Character)
        elseif v2 ~= false then
            v2 = false
            v1.Changed:Fire(v2)
        end
    end
    return v2
end

function v1.Observe(v22) -- line 116 | captures: v2, v3, v1, LocalPlayer, watchCharacter
    if not v3 then
        v3 = true
        LocalPlayer.CharacterAdded:Connect(watchCharacter)
        local Character = LocalPlayer.Character
        if Character then
            watchCharacter(Character)
        elseif v2 ~= false then
            v2 = false
            v1.Changed:Fire(v2)
        end
    end
    local v23 = v1.Changed.Event:Connect(v22)
    task.spawn(v22, v2)
    return v23
end

v1.Start = ensureStarted
return v1
