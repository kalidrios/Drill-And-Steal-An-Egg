-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local BinaryTransitionConfig = require(ReplicatedStorage.Shared.BinaryTransitionConfig)
local BinaryTransition = require(script.Parent.Parent.Modules.BinaryTransition)
local v1 = {}
local v2
local v3 = {}

local function resumeReady(v4) -- line 35 | captures: v3
    local v5 = v3[v4]
    if v5 then
        v3[v4] = nil
        task.spawn(v5)
    end
end

local function playFromServer(v6, v7, v8) -- line 45 | captures: v2, Players, BinaryTransitionConfig, BinaryTransition, v3, resumeReady
    BinaryTransition.Play(function() -- line 46 | captures: v6, v7, v2, Players, BinaryTransitionConfig, v3, resumeReady
        if not (v7 and v2) then
            return
        end
        v3[v6] = coroutine.running()
        task.delay(BinaryTransitionConfig.SCENE_READY_TIMEOUT, resumeReady, v6)
        v2:FireServer("Covered", v6)
        coroutine.yield()
        local v9 = os.clock() + 5
        while true do
            local Character, v10
            if os.clock() < v9 then
                Character = Players.LocalPlayer.Character
                v10 = Character and Character:FindFirstChildOfClass("Humanoid")
            else
                break
            end
            if v10 and v10.Health > 0 and Character:FindFirstChild("HumanoidRootPart") then
                break
            end
            task.wait(0.1)
        end
    end, v8)
end

local function isAdmin() -- line 68 | captures: Players, AdminConfig
    return Players.LocalPlayer:GetAttribute(AdminConfig.Attribute) == true
end

function v1.Play(v11) -- line 72 | captures: BinaryTransition
    BinaryTransition.Play(v11)
end

function v1.Start() -- line 76 | captures: v2, Players, ReplicatedStorage, UserInputService, AdminConfig, BinaryTransitionConfig, BinaryTransition, v3, playFromServer
    UserInputService.InputBegan:Connect(function(v12, v13) -- line 77 | captures: Players, UserInputService, AdminConfig, BinaryTransitionConfig, BinaryTransition
        if not v13 and v12.KeyCode == BinaryTransitionConfig.PREVIEW_KEY and not UserInputService:GetFocusedTextBox() and Players.LocalPlayer:GetAttribute(AdminConfig.Attribute) == true and not BinaryTransition.IsPlaying() then
            task.spawn(BinaryTransition.Play)
        end
    end)
    local v14 = ReplicatedStorage:WaitForChild(BinaryTransitionConfig.REMOTE_NAME, 30)
    if not (v14 and v14:IsA("RemoteEvent")) then
        warn((("[TransitionController] ReplicatedStorage.%* not found"):format(BinaryTransitionConfig.REMOTE_NAME)))
    else
        v2 = v14
        v14.OnClientEvent:Connect(function(v15, v16, v17, v18) -- line 93 | captures: v3, playFromServer
            if typeof(v16) == "number" then
                if v15 == "Play" then
                    local spawn = task.spawn
                    local v19 = v17 == true
                    local v20 = if typeof(v18) == "number" then v18 else nil
                    spawn(playFromServer, v16, v19, v20)
                elseif v15 == "Ready" then
                    local v21 = v3[v16]
                    if v21 then
                        v3[v16] = nil
                        task.spawn(v21)
                    end
                end
            end
        end)
    end
end

return v1
