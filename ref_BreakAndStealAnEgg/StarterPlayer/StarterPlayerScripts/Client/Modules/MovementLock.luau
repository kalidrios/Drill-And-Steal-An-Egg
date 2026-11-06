-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}
local v3
local v4 = 16
local v5 = false
local v6

local function isLocked() -- line 28 | captures: v2
    return next(v2) ~= nil
end

local function release() -- line 32 | captures: v3, v4, v5, v6
    if v6 then
        v6:Disconnect()
        v6 = nil
    end
    local v7 = v3
    v3 = nil
    if not (v7 and v7.Parent) then
        return
    end
    v5 = true
    v7.WalkSpeed = v4
    v5 = false
end

local function apply() -- line 46 | captures: v3, v4, v5, v6, LocalPlayer
    local Character = LocalPlayer.Character
    local v8 = Character and Character:FindFirstChildOfClass("Humanoid")
    local v9
    if v8 then
        if v8 == v3 then
            v9 = true
        else
            if v6 then
                v6:Disconnect()
                v6 = nil
            end
            v9 = false
        end
    else
        v9 = true
    end
    if v9 then
        return
    end
    local v10 = v3
    v3 = nil
    if v10 and v10.Parent then
        v5 = true
        v10.WalkSpeed = v4
        v5 = false
    end
    v3 = v8
    v4 = v8.WalkSpeed
    v5 = true
    v8.WalkSpeed = 0
    v5 = false
    v6 = v8:GetPropertyChangedSignal("WalkSpeed"):Connect(function() -- line 58 | captures: v8, v3, v4, v5
        if not v5 and v3 == v8 and v8.WalkSpeed ~= 0 then
            v4 = v8.WalkSpeed
            v5 = true
            v8.WalkSpeed = 0
            v5 = false
        end
    end)
end

function v1.Lock(v11) -- line 72 | captures: v2, apply
    v2[v11] = true
    apply()
end

function v1.Unlock(v12) -- line 77 | captures: v3, v4, v5, v6, v2
    v2[v12] = nil
    if next(v2) ~= nil then
        return
    end
    if v6 then
        v6:Disconnect()
        v6 = nil
    end
    local v13 = v3
    v3 = nil
    if not (v13 and v13.Parent) then
        return
    end
    v5 = true
    v13.WalkSpeed = v4
    v5 = false
end

function v1.IsLocked() -- line 84 | captures: v2
    return next(v2) ~= nil
end

LocalPlayer.CharacterAdded:Connect(function(v14) -- line 88 | captures: v3, v6, LocalPlayer, v2, apply
    if v6 then
        v6:Disconnect()
        v6 = nil
    end
    v3 = nil
    local v15, v16
    if next(v2) ~= nil then
        v14:WaitForChild("Humanoid", 10)
        if LocalPlayer.Character == v14 then
            v15 = next(v2) ~= nil
            v16 = false
        else
            v16 = true
        end
    else
        v16 = true
    end
    if not v16 and v15 then
        apply()
    end
end)
return v1
