-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local Timer = HellEventConfig.Timer
local TimeLimit = HellBossConfig.TimeLimit
local LocalPlayer = Players.LocalPlayer
local v2, v3

local function formatRemaining(v4) -- line 53
    local v5 = math.ceil(v4)
    local v6 = math.max(v5, 0)
    if v6 >= 60 then
        return (("%*m %*s"):format(v6 // 60, v6 % 60))
    end
    return (("%*s"):format(v6))
end

local function formatClock(v7) -- line 62
    local v8 = math.ceil(v7)
    local v9 = math.max(v8, 0)
    return string.format("%d:%02d", v9 // 60, v9 % 60)
end

local function bossTimeLeft() -- line 69 | captures: Workspace, TimeLimit
    local v10 = TimeLimit and Workspace:GetAttribute(TimeLimit.Attribute)
    if type(v10) == "number" then
        local v11 = v10 - Workspace:GetServerTimeNow()
        if TimeLimit.Total - TimeLimit.ShowAfter < v11 then
            return nil
        end
        return v11
    end
    return nil
end

local function adopt(v12) -- line 81 | captures: v2, v3, Timer
    v2 = nil
    v3 = nil
    local v13 = v12
    for v14, v15 in Timer.FramePath do
        v13 = v13 and v13:FindFirstChild(v15)
    end
    if not (v13 and v13:IsA("GuiObject")) then
        warn((("[HellTimerController] MainGUI.%* not found"):format((table.concat(Timer.FramePath, ".")))))
    else
        local v16 = v13:FindFirstChild(Timer.LabelName)
        if not (v16 and v16:IsA("TextLabel")) then
            warn((("[HellTimerController] %*.%* not found"):format(v13:GetFullName(), Timer.LabelName)))
        else
            v13.Visible = false
            v2 = v13
            v3 = v16
        end
    end
end

local function refresh() -- line 100 | captures: v2, v3, Workspace, HellEventConfig, Timer, TimeLimit, LocalPlayer, formatClock
    local v17
    if v2 and v3 and v2.Parent then
        v17 = LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true
    else
        return
    end
    local v18 = not v17 and Workspace:GetAttribute(HellEventConfig.JoinableAttribute) == true
    local v19 = not v17 and Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute) ~= nil
    local v20 = TimeLimit and Workspace:GetAttribute(TimeLimit.Attribute)
    local v21
    if type(v20) == "number" then
        v21 = v20 - Workspace:GetServerTimeNow()
        if TimeLimit.Total - TimeLimit.ShowAfter < v21 then
            v21 = nil
        end
    end
    if not (not v21 or not v17 and (v18 or v19 and Timer.ChargingText)) then
        v2.Visible = true
        v3.Text = string.format(TimeLimit.Text, formatClock(v21))
    else
        local v22 = Workspace:GetAttribute(HellEventConfig.NextAtAttribute)
        local v23 = Workspace:GetAttribute(HellEventConfig.StartDelay.Attribute)
        if type(v22) ~= "number" then
            v22 = nil
        end
        local v24 = if type(v23) == "number" and (v22 == nil or v23 < v22) then v23 else v22
        if v24 == nil then
            if not (v18 or v19 and Timer.ChargingText) then
                v2.Visible = false
            else
                v2.Visible = true
                local v25 = v3
                if v18 then
                    v25.Text = Timer.JoinText
                else
                    v25.Text = Timer.ChargingText
                end
            end
        else
            v2.Visible = true
            if v17 then
                v3.Text = Timer.LiveText
            elseif v18 then
                v3.Text = Timer.JoinText
            elseif not (v19 and Timer.ChargingText) then
                local v26 = v3
                local format = string.format
                local Countdown = Timer.Countdown
                local v27 = v24 - Workspace:GetServerTimeNow()
                local v28 = math.ceil(v27)
                local v29 = math.max(v28, 0)
                local v30
                if v29 >= 60 then
                    v30 = ("%*m %*s"):format(v29 // 60, v29 % 60)
                else
                    v30 = ("%*s"):format(v29)
                end
                v26.Text = format(Countdown, v30)
            else
                v3.Text = Timer.ChargingText
            end
        end
    end
end

function v1.Start() -- line 148 | captures: Workspace, HellEventConfig, MainGui, LocalPlayer, adopt, refresh
    MainGui.Observe(function(v31) -- line 149 | captures: adopt, refresh
        adopt(v31)
        refresh()
    end)
    Workspace:GetAttributeChangedSignal(HellEventConfig.NextAtAttribute):Connect(refresh)
    Workspace:GetAttributeChangedSignal(HellEventConfig.StartDelay.Attribute):Connect(refresh)
    Workspace:GetAttributeChangedSignal(HellEventConfig.JoinableAttribute):Connect(refresh)
    Workspace:GetAttributeChangedSignal(HellEventConfig.PortalChargeAttribute):Connect(refresh)
    LocalPlayer:GetAttributeChangedSignal(HellEventConfig.PlayerAttribute):Connect(refresh)
    while true do
        refresh()
        task.wait(0.25)
    end
end

return v1
