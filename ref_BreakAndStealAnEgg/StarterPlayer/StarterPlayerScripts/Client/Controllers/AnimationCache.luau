-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimationAssets = require(ReplicatedStorage.Shared.AnimationAssets)
local WaitFor = require(ReplicatedStorage.Shared.WaitFor)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}
local v3 = { __mode = "k" }
local v4 = setmetatable(v2, v3)
local v5 = false
local v6 = false

function v1.WarmAssets() -- line 53 | captures: v5, v6, ContentProvider, AnimationAssets, WaitFor
    if not v5 then
        if v6 then
            WaitFor.Until(function() -- line 61 | captures: v5, v6
                return v5 or not v6
            end, 60)
        else
            v6 = true
            local v7 = AnimationAssets.PreloadList()
            if #v7 > 0 then
                pcall(ContentProvider.PreloadAsync, ContentProvider, v7)
            end
            v5 = true
            v6 = false
        end
    end
end

local function getAnimator(v8) -- line 82
    local v9 = v8:FindFirstChildOfClass("Humanoid") or v8:WaitForChild("Humanoid", 10)
    local v10
    if v9 and v9:IsA("Humanoid") then
        v10 = v9:FindFirstChildOfClass("Animator") or v9:WaitForChild("Animator", 10)
    else
        return nil
    end
    if not (v10 and v10:IsA("Animator")) then
        return nil
    end
    return v10
end

local function loadTrack(v11, v12, v13, v14) -- line 94 | captures: AnimationAssets, getAnimator
    local v15 = getAnimator(v11)
    if v15 and v11.Parent ~= nil then
        local v16, v17 = pcall(v15.LoadAnimation, v15, AnimationAssets.Get(v12))
        if v16 and v17 then
            v17.Looped = v14 ~= false
            v17.Priority = v13 or Enum.AnimationPriority.Action
            return v17
        end
        warn((("[AnimationCache] couldn't load %*: %*"):format(v12, v17)))
    end
    return nil
end

function v1.Track(v18, v19, v20, v21) -- line 119 | captures: v4, loadTrack
    if v18 == nil or v19 == nil or v19 == "" then
        return nil
    end
    local v22 = v4[v18]
    if v22 == nil then
        v22 = {}
        v4[v18] = v22
    end
    local v23 = v22[v19]
    if v23 == nil then
        local v24 = loadTrack(v18, v19, v20, v21)
        local v25 = v22[v19]
        if v25 == nil then
            if v24 then
                v22[v19] = v24
            end
            return v24
        end
        if v24 and v24 ~= v25 then
            v24:Destroy()
        end
        return v25
    end
    return v23
end

function v1.Warm(v26, v27, v28, v29) -- line 162 | captures: WaitFor, v1, v4
    local v30 = {}
    local v31 = v1.Track(v26, v27, v28, v29)
    local v32 = v31
    if v31 ~= nil and v26 ~= nil and v27 ~= nil then
        local v33 = v30
        for v34 = 1, 2 do
            v33[1] = false
            local Until = WaitFor.Until
            Until((function(v35)
                return function() -- line 178 | captures: v35, v32, v26
                    if v26.Parent == nil then
                        v35[1] = true
                        return true
                    end
                    return v32.Length > 0
                end
            end)(v33), 4)
            if v33[1] then
                return nil
            end
            if v32.Length > 0 or v34 == 2 then
                local v36 = v33[1]
                break
            end
            v1.WarmAssets()
            local v37 = v4[v26]
            if v37 then
                v37[v27] = nil
            end
            v31 = v1.Track(v26, v27, v28, v29)
            if v31 == nil then
                return nil
            end
            v32 = v31
            local v38 = v33[1]
            local v39 = {}
            v39[1] = v38
            v33 = v39
        end
        return v32
    end
    return v31
end

function v1.WarmCharacter(v40) -- line 209 | captures: AnimationAssets, v1
    v1.WarmAssets()
    for v41, v42 in AnimationAssets.Character do
        if v40.Parent == nil then
            return
        end
        v1.Warm(v40, v42.Id, v42.Priority, v42.Looped)
    end
end

function v1.Start() -- line 224 | captures: v1, LocalPlayer
    task.spawn(v1.WarmAssets)
    LocalPlayer.CharacterAdded:Connect(function(v43) -- line 229 | captures: v1
        task.spawn(v1.WarmCharacter, v43)
    end)
    if LocalPlayer.Character then
        task.spawn(v1.WarmCharacter, LocalPlayer.Character)
    end
end

return v1
