-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BatToolQuery = require(ReplicatedStorage.Shared.BatToolQuery)
local v1 = {}
local LocalPlayer = Players.LocalPlayer

v1.Changed = Instance.new("BindableEvent")

local v2 = false
local v3 = false
local v4 = {}

local function readState(v5) -- line 34 | captures: BatToolQuery
    if v5 then
        for v6, v7 in v5:GetChildren() do
            if BatToolQuery.IsBatWeapon(v7) then
                return true
            end
        end
    end
    return false
end

local function setState(v8) -- line 46 | captures: v2, v1
    if v2 ~= v8 then
        v2 = v8
        v1.Changed:Fire(v2)
    end
end

local function watchCharacter(v9) -- line 54 | captures: v2, BatToolQuery, v1, LocalPlayer, v4
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

    local function reread(v16) -- line 60 | captures: v2, BatToolQuery, v1, LocalPlayer
        if not v16:IsA("Tool") then
            return
        end
        local Character = LocalPlayer.Character
        local v17
        if Character then
            local v18 = false
            for v19, v20 in Character:GetChildren() do
                if BatToolQuery.IsBatWeapon(v20) then
                    v17 = true
                    v18 = true
                    break
                end
            end
            if not v18 then
                v17 = false
            end
        else
            v17 = false
        end
        if v2 == v17 then
            return
        end
        v2 = v17
        v1.Changed:Fire(v2)
    end

    v10(v4, v9.ChildAdded:Connect(reread))
    v12(v4, v9.ChildRemoved:Connect(reread))
    local v21
    if v9 then
        local v22 = false
        for v23, v24 in v9:GetChildren() do
            if BatToolQuery.IsBatWeapon(v24) then
                v21 = true
                v22 = true
                break
            end
        end
        if not v22 then
            v21 = false
        end
    else
        v21 = false
    end
    if v2 ~= v21 then
        v2 = v21
        v1.Changed:Fire(v2)
    end
end

local function ensureStarted() -- line 71 | captures: v2, v3, v1, LocalPlayer, watchCharacter
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

function v1.IsEquipped() -- line 86 | captures: v2, v3, v1, LocalPlayer, watchCharacter
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

function v1.Observe(v25) -- line 91 | captures: v2, v3, v1, LocalPlayer, watchCharacter
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
    local v26 = v1.Changed.Event:Connect(v25)
    task.spawn(v25, v2)
    return v26
end

v1.Start = ensureStarted
return v1
