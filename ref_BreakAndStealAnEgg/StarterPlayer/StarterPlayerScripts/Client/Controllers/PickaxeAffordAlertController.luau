-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NotificationConfig = require(ReplicatedStorage.Shared.NotificationConfig)
local OfflineRewardConfig = require(ReplicatedStorage.Shared.OfflineRewardConfig)
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local TutorialConfig = require(ReplicatedStorage.Shared.TutorialConfig)
local NotificationController = require(script.Parent.NotificationController)
local UiFrames = require(script.Parent.UiFrames)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local NotificationWaypoint = require(script.Parent.Parent.Modules.NotificationWaypoint)
local PickaxeAffordAlert = NotificationConfig.PickaxeAffordAlert
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = 0
local v3 = false
local v4 = 0
local v5 = 0

local function tutorialActive() -- line 83 | captures: TutorialConfig, LocalPlayer
    return LocalPlayer:GetAttribute(TutorialConfig.StageAttribute) ~= nil
end

local function bestOwnedTier() -- line 90 | captures: PickaxeConfig, LocalPlayer
    local DefaultTier = PickaxeConfig.DefaultTier
    local PickaxeTier = LocalPlayer:GetAttribute("PickaxeTier")
    if not (typeof(PickaxeTier) == "number" and DefaultTier < PickaxeTier) then
        PickaxeTier = DefaultTier
    end
    local OwnedPickaxes = LocalPlayer:GetAttribute("OwnedPickaxes")
    if typeof(OwnedPickaxes) == "string" then
        local v6 = PickaxeTier
        for v7 in string.gmatch(OwnedPickaxes, "[^,]+") do
            local v8 = tonumber(v7)
            if v8 and v6 < v8 then
                v6 = v8
            end
            PickaxeTier = v6
        end
    end
    return PickaxeTier
end

local function nextAffordableUpgrade() -- line 114 | captures: PickaxeConfig, LocalPlayer, bestOwnedTier
    local Cash = LocalPlayer:GetAttribute("Cash")
    if typeof(Cash) == "number" then
        local v9 = bestOwnedTier()
        local v10
        for v11, v12 in PickaxeConfig.Tiers do
            if v9 < v11 and (v12.Price or 0) <= Cash and (v10 == nil or v10 < v11) then
                v10 = v11
            end
        end
        return v10
    end
    return nil
end

local function shopBoothPosition() -- line 138 | captures: TutorialConfig
    local v13 = workspace
    for v14, v15 in TutorialConfig.PickaxeShopMarker do
        v13 = v13 and v13:FindFirstChild(v15)
    end
    if not (v13 and v13:IsA("BasePart")) then
        return nil
    end
    return v13.Position
end

local function shopWindowOpen() -- line 151 | captures: UiFrames, LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v16 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v17 = v16 and v16:FindFirstChild("Frames")
    local v18 = v17 and v17:FindFirstChild("Pickaxes")
    if v18 == nil then
        return false
    end
    return v18:IsA("GuiObject") and UiFrames.IsOpen(v18)
end

local function offlineRewardOpen() -- line 161 | captures: OfflineRewardConfig, UiFrames, LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v19 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v20 = v19 and v19:FindFirstChild("Frames")
    local v21 = v20 and v20:FindFirstChild(OfflineRewardConfig.FrameName)
    if v21 == nil then
        return false
    end
    return v21:IsA("GuiObject") and UiFrames.IsOpen(v21)
end

local function hideWaypoint() -- line 169 | captures: v3, NotificationWaypoint
    if v3 then
        v3 = false
        NotificationWaypoint.Hide("PickaxeAfford")
    end
end

local function showWaypoint() -- line 176 | captures: v3, NotificationWaypoint, shopBoothPosition, shopWindowOpen, hideWaypoint
    v3 = true
    NotificationWaypoint.Show(function() -- line 181 | captures: shopBoothPosition, shopWindowOpen, hideWaypoint
        if shopWindowOpen() then
            task.defer(hideWaypoint)
            return nil
        end
        return (shopBoothPosition())
    end, "PickaxeAfford")
end

local v22

local function scheduleRecheck(v23) -- line 198 | captures: v5, v22
    v5 += 1
    local v24 = v5
    task.delay(v23 + 0.05, function() -- line 201 | captures: v24, v5, v22
        if v24 == v5 then
            v22()
        end
    end)
end

function v22() -- line 208 | captures: v2, v3, v4, v5, v22, PickaxeConfig, TutorialConfig, NotificationController, NotificationWaypoint, LocalPlayer, nextAffordableUpgrade, shopBoothPosition, shopWindowOpen, offlineRewardOpen, hideWaypoint
    if LocalPlayer:GetAttribute(TutorialConfig.StageAttribute) ~= nil then
        if v3 then
            v3 = false
            NotificationWaypoint.Hide("PickaxeAfford")
        end
    else
        local v25 = nextAffordableUpgrade()
        if v25 then
            if not (v25 <= v2) and not offlineRewardOpen() then
                local v26 = v4 - os.clock()
                if v26 > 0 then
                    v5 += 1
                    local v27 = v5
                    task.delay(v26 + 0.05, function() -- line 201 | captures: v27, v5, v22
                        if v27 == v5 then
                            v22()
                        end
                    end)
                else
                    v2 = v25
                    NotificationController.ShowPreset("PickaxeAffordable", PickaxeConfig.GetTier(v25).Name)
                    v3 = true
                    NotificationWaypoint.Show(function() -- line 181 | captures: shopBoothPosition, shopWindowOpen, hideWaypoint
                        if shopWindowOpen() then
                            task.defer(hideWaypoint)
                            return nil
                        end
                        return (shopBoothPosition())
                    end, "PickaxeAfford")
                end
            end
        elseif v3 then
            v3 = false
            NotificationWaypoint.Hide("PickaxeAfford")
        end
    end
end

function v1.Start() -- line 240 | captures: v4, v5, v22, OfflineRewardConfig, TutorialConfig, UiFrames, MainGui, PickaxeAffordAlert, LocalPlayer
    v4 = os.clock() + PickaxeAffordAlert.JoinGraceSeconds
    MainGui.Observe(function(v28) -- line 249 | captures: v4, v5, v22, OfflineRewardConfig, UiFrames, PickaxeAffordAlert
        local v29 = v28:WaitForChild("Frames", 10)
        local v30 = v29 and v29:FindFirstChild(OfflineRewardConfig.FrameName)
        if v30 and v30:IsA("GuiObject") then
            UiFrames.Observe(v30, function(v31) -- line 253 | captures: v4, v5, v22, PickaxeAffordAlert
                if v31 then
                    return
                end
                local v32 = v4
                local v33 = os.clock() + PickaxeAffordAlert.JoinGraceSeconds
                v4 = math.max(v32, v33)
                local JoinGraceSeconds = PickaxeAffordAlert.JoinGraceSeconds
                v5 += 1
                local v34 = v5
                task.delay(JoinGraceSeconds + 0.05, function() -- line 201 | captures: v34, v5, v22
                    if v34 == v5 then
                        v22()
                    end
                end)
            end)
        end
    end)
    LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(v22)
    LocalPlayer:GetAttributeChangedSignal("OwnedPickaxes"):Connect(v22)
    LocalPlayer:GetAttributeChangedSignal("PickaxeTier"):Connect(v22)
    LocalPlayer:GetAttributeChangedSignal(TutorialConfig.StageAttribute):Connect(v22)
    v22()
end

return v1
