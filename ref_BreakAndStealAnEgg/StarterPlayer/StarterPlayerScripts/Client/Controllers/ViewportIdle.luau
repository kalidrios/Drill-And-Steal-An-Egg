-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalAnimator = require(ReplicatedStorage.Shared.AnimalAnimator)
local v1 = {}

v1.__index = v1

function v1.new(v2) -- line 42 | captures: v1
    local v3 = {
        _destroyed = false,
        _entries = {},
        _shouldPlay = v2
    }
    return (setmetatable(v3, v1))
end

function v1._load(v4, v5, v6) -- line 50 | captures: AnimalAnimator
    v6.Loading = true
    task.spawn(function() -- line 52 | captures: v4, v5, v6, AnimalAnimator
        local v7 = AnimalAnimator.new(v6.Model, {})
        v6.Loading = false
        if not v4._destroyed and v4._entries[v5] == v6 and v6.Model:IsDescendantOf(game) then
            v6.Animator = v7
            v4:_apply(v5, v6)
        else
            v7:Destroy()
        end
    end)
end

local function _apply(v8, v9, v10) -- line 71
    if not v8._destroyed and v8._shouldPlay(v9) == true then
        if v10.Animator then
            v10.Animator:PlayIdle()
        elseif not v10.Loading then
            v8:_load(v9, v10)
        end
    elseif v10.Animator then
        v10.Animator:Stop()
    end
end

v1._apply = _apply

local function Add(v11, v12, v13) -- line 87
    if v11._destroyed or v11._entries[v12] then
        return
    end
    local v14 = {
        Animator = nil,
        Loading = false,
        Model = v13
    }
    v11._entries[v12] = v14
    task.defer(function() -- line 95 | captures: v11, v12, v14
        if v11._entries[v12] == v14 then
            v11:_apply(v12, v14)
        end
    end)
end

v1.Add = Add

local function Remove(v15, v16) -- line 102
    local v17 = v15._entries[v16]
    if v17 then
        v15._entries[v16] = nil
        if v17.Animator then
            v17.Animator:Destroy()
        end
    end
end

v1.Remove = Remove

local function Refresh(v18) -- line 114
    for v19, v20 in v18._entries do
        v18:_apply(v19, v20)
    end
end

v1.Refresh = Refresh

local function RefreshDeferred(v21) -- line 122
    task.defer(function() -- line 123 | captures: v21
        if not v21._destroyed then
            v21:Refresh()
        end
    end)
end

v1.RefreshDeferred = RefreshDeferred

local function SetPolling(v22, v23, v24) -- line 136
    v22._polling = v23
    if v23 then
        if not v22._pollRunning then
            v22._pollRunning = true
            task.spawn(function() -- line 146 | captures: v22, v24
                while v22._polling do
                    if v22._destroyed then
                        break
                    end
                    v22:Refresh()
                    task.wait(v24 or 0.25)
                end
                v22._pollRunning = false
            end)
        end
    else
        v22:RefreshDeferred()
    end
end

v1.SetPolling = SetPolling

local function Destroy(v25) -- line 155
    v25._destroyed = true
    v25._polling = false
    for v26, v27 in v25._entries do
        v25._entries[v26] = nil
        if v27.Animator then
            v27.Animator:Destroy()
        end
    end
end

v1.Destroy = Destroy
return v1
