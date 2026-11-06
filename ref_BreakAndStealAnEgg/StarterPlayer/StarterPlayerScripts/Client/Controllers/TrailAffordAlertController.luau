-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NotificationConfig = require(ReplicatedStorage.Shared.NotificationConfig)
local OfflineRewardConfig = require(ReplicatedStorage.Shared.OfflineRewardConfig)
local TrailsConfig = require(ReplicatedStorage.Shared.TrailsConfig)
local TutorialConfig = require(ReplicatedStorage.Shared.TutorialConfig)
local NotificationController = require(script.Parent.NotificationController)
local UiFrames = require(script.Parent.UiFrames)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local NotificationWaypoint = require(script.Parent.Parent.Modules.NotificationWaypoint)
local TrailAffordAlert = NotificationConfig.TrailAffordAlert
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = 0
local v3 = false
local v4 = 0
local v5 = 0

local function tutorialActive() -- line 62 | captures: TutorialConfig, LocalPlayer
    return LocalPlayer:GetAttribute(TutorialConfig.StageAttribute) ~= nil
end

local function bestOwnedMultiplier() -- line 67 | captures: TrailsConfig, LocalPlayer
    local DefaultMultiplier = TrailsConfig.DefaultMultiplier
    local v6 = LocalPlayer:GetAttribute(TrailsConfig.OwnedAttribute)
    if typeof(v6) == "string" then
        local v7 = DefaultMultiplier
        for v8 in string.gmatch(v6, "[^,]+") do
            local v9 = TrailsConfig.Get((tonumber(v8)))
            if v9 and v7 < v9.Multiplier then
                v7 = v9.Multiplier
            end
            DefaultMultiplier = v7
        end
    end
    return DefaultMultiplier
end

local function nextAffordableUpgrade() -- line 82 | captures: TrailsConfig, LocalPlayer, bestOwnedMultiplier
    local Cash = LocalPlayer:GetAttribute("Cash")
    if typeof(Cash) == "number" then
        local v10 = bestOwnedMultiplier()
        local v11
        for v12, v13 in TrailsConfig.Trails do
            if v10 < v13.Multiplier and v13.Price <= Cash then
                if v11 == nil then
                    v11 = v13
                else
                    local Multiplier = v13.Multiplier
                    if v11.Multiplier < Multiplier then
                        v11 = v13
                    end
                end
            end
        end
        return v11
    end
    return nil
end

local function shopBoothPosition() -- line 105 | captures: TutorialConfig
    local v14 = workspace
    for v15, v16 in TutorialConfig.TrailsShopMarker do
        v14 = v14 and v14:FindFirstChild(v16)
    end
    if not (v14 and v14:IsA("BasePart")) then
        return nil
    end
    return v14.Position
end

local function frameOpen(v17) -- line 116 | captures: UiFrames, LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v18 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v19 = v18 and v18:FindFirstChild("Frames")
    local v20 = v19 and v19:FindFirstChild(v17)
    if v20 == nil then
        return false
    end
    return v20:IsA("GuiObject") and UiFrames.IsOpen(v20)
end

local function hideWaypoint() -- line 124 | captures: v3, NotificationWaypoint
    if v3 then
        v3 = false
        NotificationWaypoint.Hide("TrailAfford")
    end
end

local function showWaypoint() -- line 131 | captures: v3, NotificationWaypoint, shopBoothPosition, frameOpen, hideWaypoint
    v3 = true
    NotificationWaypoint.Show(function() -- line 135 | captures: shopBoothPosition, frameOpen, hideWaypoint
        if frameOpen("Trails") then
            task.defer(hideWaypoint)
            return nil
        end
        return (shopBoothPosition())
    end, "TrailAfford")
end

local v21

local function scheduleRecheck(v22) -- line 150 | captures: v5, v21
    v5 += 1
    local v23 = v5
    task.delay(v22 + 0.05, function() -- line 153 | captures: v23, v5, v21
        if v23 == v5 then
            v21()
        end
    end)
end

function v21() -- line 160 | captures: v2, v3, v4, v5, v21, OfflineRewardConfig, TutorialConfig, NotificationController, NotificationWaypoint, LocalPlayer, nextAffordableUpgrade, shopBoothPosition, frameOpen, hideWaypoint
    if LocalPlayer:GetAttribute(TutorialConfig.StageAttribute) ~= nil then
        if v3 then
            v3 = false
            NotificationWaypoint.Hide("TrailAfford")
        end
    else
        local v24 = nextAffordableUpgrade()
        if v24 then
            if not (v24.Multiplier <= v2) and not frameOpen(OfflineRewardConfig.FrameName) then
                local v25 = v4 - os.clock()
                if v25 > 0 then
                    v5 += 1
                    local v26 = v5
                    task.delay(v25 + 0.05, function() -- line 153 | captures: v26, v5, v21
                        if v26 == v5 then
                            v21()
                        end
                    end)
                else
                    v2 = v24.Multiplier
                    NotificationController.ShowPreset("TrailAffordable", v24.Name)
                    v3 = true
                    NotificationWaypoint.Show(function() -- line 135 | captures: shopBoothPosition, frameOpen, hideWaypoint
                        if frameOpen("Trails") then
                            task.defer(hideWaypoint)
                            return nil
                        end
                        return (shopBoothPosition())
                    end, "TrailAfford")
                end
            end
        elseif v3 then
            v3 = false
            NotificationWaypoint.Hide("TrailAfford")
        end
    end
end

function v1.Start() -- line 190 | captures: v4, v5, v21, OfflineRewardConfig, TrailsConfig, TutorialConfig, UiFrames, MainGui, TrailAffordAlert, LocalPlayer
    v4 = os.clock() + TrailAffordAlert.JoinGraceSeconds
    MainGui.Observe(function(v27) -- line 195 | captures: v4, v5, v21, OfflineRewardConfig, UiFrames, TrailAffordAlert
        local v28 = v27:WaitForChild("Frames", 10)
        local v29 = v28 and v28:FindFirstChild(OfflineRewardConfig.FrameName)
        if v29 and v29:IsA("GuiObject") then
            UiFrames.Observe(v29, function(v30) -- line 199 | captures: v4, v5, v21, TrailAffordAlert
                if v30 then
                    return
                end
                local v31 = v4
                local v32 = os.clock() + TrailAffordAlert.JoinGraceSeconds
                v4 = math.max(v31, v32)
                local JoinGraceSeconds = TrailAffordAlert.JoinGraceSeconds
                v5 += 1
                local v33 = v5
                task.delay(JoinGraceSeconds + 0.05, function() -- line 153 | captures: v33, v5, v21
                    if v33 == v5 then
                        v21()
                    end
                end)
            end)
        end
    end)
    LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(v21)
    LocalPlayer:GetAttributeChangedSignal(TrailsConfig.OwnedAttribute):Connect(v21)
    LocalPlayer:GetAttributeChangedSignal(TutorialConfig.StageAttribute):Connect(v21)
    v21()
end

return v1
