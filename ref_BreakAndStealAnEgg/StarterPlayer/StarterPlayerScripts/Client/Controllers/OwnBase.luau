-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WaitFor = require(ReplicatedStorage.Shared.WaitFor)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2
local v3 = {}
local v4 = {}

local function isMine(v5) -- line 46 | captures: LocalPlayer
    return v5:GetAttribute("OwnerUserId") == LocalPlayer.UserId
end

local function notify(v6, v7) -- line 50
    if v6.Last ~= v7 then
        v6.Last = v7
        task.spawn(v6.Callback, v7)
    end
end

local function setCurrent(v8) -- line 58 | captures: v2, v3
    v2 = v8
    for v9, v10 in table.clone(v3) do
        if v10.Last ~= v8 then
            v10.Last = v8
            task.spawn(v10.Callback, v8)
        end
    end
end

local function consider(v11) -- line 67 | captures: v2, LocalPlayer, v3, v4
    if v11:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
        v2 = v11
        for v12, v13 in table.clone(v3) do
            if v13.Last ~= v11 then
                v13.Last = v11
                task.spawn(v13.Callback, v11)
            end
        end
    end
    if not v4[v11] then
        local OwnerUserId = v11:GetAttributeChangedSignal("OwnerUserId")
        v4[v11] = OwnerUserId:Connect(function() -- line 76 | captures: v11, v2, LocalPlayer, v3
            if v11:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                v2 = v11
                for v14, v15 in table.clone(v3) do
                    if v15.Last ~= v11 then
                        v15.Last = v11
                        task.spawn(v15.Callback, v11)
                    end
                end
            elseif v2 == v11 then
                v2 = nil
            end
        end)
    end
end

local function forget(v16) -- line 85 | captures: v2, v4
    local v17 = v4[v16]
    if v17 then
        v17:Disconnect()
        v4[v16] = nil
    end
    if v2 == v16 then
        v2 = nil
    end
end

local function hookPlots(v18) -- line 96 | captures: consider, forget
    for v19, v20 in v18:GetChildren() do
        consider(v20)
    end
    v18.ChildAdded:Connect(consider)
    v18.ChildRemoved:Connect(forget)
end

local Plots = Workspace:FindFirstChild("Plots")

if Plots then
    hookPlots(Plots)
else
    local v21
    v21 = Workspace.ChildAdded:Connect(function(v22) -- line 111 | captures: v21, hookPlots
        if v22.Name == "Plots" then
            if v21 then
                v21:Disconnect()
            end
            hookPlots(v22)
        end
    end)
end

function v1.Get() -- line 124 | captures: v2
    if not (v2 and v2.Parent) then
        return nil
    end
    return v2
end

function v1.Wait(v23) -- line 137 | captures: WaitFor, v1
    return (WaitFor.Until(v1.Get, v23 or 30))
end

function v1.Observe(v24) -- line 145 | captures: v1, v3
    local v25 = {
        Last = nil,
        Callback = v24
    }
    table.insert(v3, v25)
    local v26 = v1.Get()
    if v26 then
        v25.Last = v26
        task.defer(v24, v26)
    end
end

function v1.Hitbox() -- line 156 | captures: v1
    local v27 = v1.Get()
    local v28 = v27 and v27:FindFirstChild("Hitbox")
    if v28 and v28:IsA("BasePart") then
        return v28
    end
    return nil
end

return v1
