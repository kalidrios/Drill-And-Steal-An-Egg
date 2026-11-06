-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local AntiAfkConfig = require(ReplicatedStorage.Shared.AntiAfkConfig)
local v1 = {}
local v2 = {}

v2[Enum.UserInputType.Keyboard] = true
v2[Enum.UserInputType.MouseButton1] = true
v2[Enum.UserInputType.MouseButton2] = true
v2[Enum.UserInputType.MouseButton3] = true
v2[Enum.UserInputType.Touch] = true
v2[Enum.UserInputType.Gamepad1] = true
v2[Enum.UserInputType.Gamepad2] = true
v2[Enum.UserInputType.Gamepad3] = true
v2[Enum.UserInputType.Gamepad4] = true
v2[Enum.UserInputType.Gamepad5] = true
v2[Enum.UserInputType.Gamepad6] = true
v2[Enum.UserInputType.Gamepad7] = true
v2[Enum.UserInputType.Gamepad8] = true

local v3 = os.clock()
local v4, v5

local function markActive() -- line 59 | captures: v3, v4, v5
    v3 = os.clock()
    v4 = nil
    v5 = nil
end

local function idleSeconds() -- line 65 | captures: v3, v4
    local v6 = os.clock()
    local v7 = v6 - v3
    local v8 = if v4 then v6 - v4 else 0
    return (math.max(v7, v8))
end

function v1.Start() -- line 72 | captures: v3, v4, v5, Players, ReplicatedStorage, UserInputService, AntiAfkConfig, v2
    UserInputService.InputBegan:Connect(function(v9) -- line 76 | captures: v3, v4, v5, v2
        if not v2[v9.UserInputType] then
            return
        end
        v3 = os.clock()
        v4 = nil
        v5 = nil
    end)
    UserInputService.InputChanged:Connect(function(v10) -- line 83 | captures: v3, v4, v5
        if v10.KeyCode ~= Enum.KeyCode.Thumbstick1 and v10.KeyCode ~= Enum.KeyCode.Thumbstick2 then
            return
        end
        v3 = os.clock()
        v4 = nil
        v5 = nil
    end)
    Players.LocalPlayer.Idled:Connect(function(v11) -- line 91 | captures: v4
        local v12 = os.clock() - v11
        if v4 == nil or v12 < v4 then
            v4 = v12
        end
    end)
    local AntiAfkRejoinRemote = ReplicatedStorage:WaitForChild("AntiAfkRejoinRemote")
    if AntiAfkRejoinRemote:IsA("RemoteEvent") then
        while true do
            task.wait(AntiAfkConfig.CheckIntervalSeconds)
            local v13 = os.clock()
            local v14 = v13 - v3
            local v15 = if v4 then v13 - v4 else 0
            local v16
            if math.max(v14, v15) < AntiAfkConfig.IdleSeconds then
                v16 = true
            elseif v5 == nil then
                v16 = false
            else
                local v17 = os.clock() - v5
                v16 = not (AntiAfkConfig.RetrySeconds <= v17)
            end
            if not v16 then
                v5 = os.clock()
                AntiAfkRejoinRemote:FireServer()
            end
        end
    end
    warn("[AntiAfkController] AntiAfkRejoinRemote is not a RemoteEvent \226\128\148 anti-AFK rejoin disabled")
end

return v1
