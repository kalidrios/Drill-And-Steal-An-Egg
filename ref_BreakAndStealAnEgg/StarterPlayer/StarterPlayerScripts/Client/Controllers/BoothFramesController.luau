-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TutorialConfig = require(ReplicatedStorage.Shared.TutorialConfig)
local NotificationController = require(script.Parent.NotificationController)
local UiFrames = require(script.Parent.UiFrames)
local LocalCharacter = require(script.Parent.Parent.Modules.LocalCharacter)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {
    ["Pickaxe Shop"] = "Pickaxes",
    ["Trails Shop"] = "Trails"
}

local function allowedInTutorial(v2) -- line 49 | captures: Players, TutorialConfig
    if v2 == "Pickaxes" then
        return true
    end
    if v2 == "Trails" then
        local v3 = Players.LocalPlayer:GetAttribute(TutorialConfig.StageAttribute)
        if v3 == "EarnTrailCash" then
            return true
        end
        return v3 == "BuyTrail"
    end
    return false
end

local v4 = {}

local function inTutorial() -- line 71 | captures: Players, TutorialConfig
    return Players.LocalPlayer:GetAttribute(TutorialConfig.StageAttribute) ~= nil
end

local v5 = {}
local v6

local function resolveFrame(v7) -- line 80 | captures: v6
    local v8 = v6 and v6:FindFirstChild(v7)
    if v8 and v8:IsA("GuiObject") then
        return v8
    end
    return nil
end

local function disablePrompts(v9) -- line 87
    local function tryDisable(v10) -- line 88
        if v10:IsA("ProximityPrompt") then
            v10.Enabled = false
        end
    end

    for v11, v12 in v9:GetDescendants() do
        if v12:IsA("ProximityPrompt") then
            v12.Enabled = false
        end
    end
    v9.DescendantAdded:Connect(tryDisable)
end

local function bindBooth(v13, v14) -- line 100 | captures: v6, v5, disablePrompts
    disablePrompts(v13)

    local function tryBind(v15) -- line 104 | captures: v14, v6, v5
        local v16, v17, v18
        if v15.Name == "HitZone" and v15:IsA("BasePart") then
            v16 = v5
            v17 = {
                inside = false,
                zone = v15,
                frameName = v14
            }
            v18 = v6 and v6:FindFirstChild(v14)
        else
            return false
        end
        if not (v18 and v18:IsA("GuiObject")) then
            v18 = nil
        end
        v17.frame = v18
        table.insert(v16, v17)
        return true
    end

    for v19, v20 in v13:GetDescendants() do
        if tryBind(v20) then
            return
        end
    end
    local v21
    v21 = v13.DescendantAdded:Connect(function(v22) -- line 125 | captures: v21, tryBind
        if tryBind(v22) then
            v21:Disconnect()
        end
    end)
end

local function isInsideZone(v23, v24) -- line 134
    local v25 = v23.CFrame:PointToObjectSpace(v24)
    local v26 = v23.Size / 2
    local X = v25.X
    if math.abs(X) <= v26.X then
        local Y = v25.Y
        if math.abs(Y) <= v26.Y then
            local Z = v25.Z
            return math.abs(Z) <= v26.Z
        end
    end
    return false
end

function v4.Start() -- line 140 | captures: v6, Players, RunService, TutorialConfig, NotificationController, UiFrames, LocalCharacter, MainGui, v1, v5, bindBooth
    MainGui.Observe(function(v27) -- line 144 | captures: v6, v5
        v6 = v27:FindFirstChild("Frames")
        for v28, v29 in v5 do
            local frameName = v29.frameName
            local v30 = v6 and v6:FindFirstChild(frameName)
            if not (v30 and v30:IsA("GuiObject")) then
                v30 = nil
            end
            v29.frame = v30
            v29.inside = false
            if v30 then
                v30.Visible = false
            end
        end
    end)
    local v31 = workspace:WaitForChild("Booths", 30)
    if v31 then
        for v32, v33 in v1 do
            local v34 = v31:FindFirstChild(v32)
            if v34 then
                bindBooth(v34, v33)
            end
        end
        RunService.Heartbeat:Connect(function() -- line 178 | captures: Players, TutorialConfig, NotificationController, UiFrames, LocalCharacter, v5
            local v35 = LocalCharacter.GetPosition()
            for v36, v37 in v5 do
                local v38
                if v35 == nil then
                    v38 = false
                else
                    local zone = v37.zone
                    local v39 = zone.CFrame:PointToObjectSpace(v35)
                    local v40 = zone.Size / 2
                    local X = v39.X
                    if math.abs(X) <= v40.X then
                        local Y = v39.Y
                        if math.abs(Y) <= v40.Y then
                            local Z = v39.Z
                            v38 = math.abs(Z) <= v40.Z
                        else
                            v38 = false
                        end
                    else
                        v38 = false
                    end
                end
                if v38 ~= v37.inside and v37.frame ~= nil then
                    v37.inside = v38
                    if v38 then
                        if Players.LocalPlayer:GetAttribute(TutorialConfig.StageAttribute) ~= nil then
                            local frameName = v37.frameName
                            local v41
                            if frameName == "Pickaxes" then
                                v41 = true
                            elseif frameName == "Trails" then
                                local v42 = Players.LocalPlayer:GetAttribute(TutorialConfig.StageAttribute)
                                if v42 == "EarnTrailCash" then
                                    v41 = true
                                else
                                    v41 = v42 == "BuyTrail"
                                end
                            else
                                v41 = false
                            end
                            if v41 then
                                UiFrames.Open(v37.frame)
                            else
                                NotificationController.Show("Complete Tutorial First", "Error")
                            end
                        else
                            UiFrames.Open(v37.frame)
                        end
                    else
                        UiFrames.Close(v37.frame)
                    end
                end
            end
        end)
    end
end

return v4
