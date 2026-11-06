-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local FrameFocusFXConfig = require(ReplicatedStorage.Shared.FrameFocusFXConfig)
local UiFrames = require(script.Parent.UiFrames)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local CameraFovController = require(script.Parent.CameraFovController)
local DemonEventUIController = require(script.Parent.DemonEventUIController)
local SciFiTradeInUIController = require(script.Parent.SciFiTradeInUIController)
local v1 = TweenInfo.new(FrameFocusFXConfig.OpenTweenDuration, FrameFocusFXConfig.OpenEasingStyle, FrameFocusFXConfig.OpenEasingDirection)
local v2 = TweenInfo.new(FrameFocusFXConfig.CloseTweenDuration, FrameFocusFXConfig.CloseEasingStyle, FrameFocusFXConfig.CloseEasingDirection)
local v3 = {}
local NumberValue = Instance.new("NumberValue")

NumberValue.Name = "FrameFocusAlpha"
NumberValue.Value = 0

local v4, v5
local v6 = false
local v7 = false

local function getBlur() -- line 55 | captures: v4, Lighting, FrameFocusFXConfig
    local v8 = v4
    if v8 == nil or v8.Parent == nil then
        local BlurEffect = Instance.new("BlurEffect")
        BlurEffect.Name = FrameFocusFXConfig.BlurName
        BlurEffect.Size = 0
        BlurEffect.Enabled = false
        BlurEffect.Parent = Lighting
        v4 = BlurEffect
        return BlurEffect
    end
    return v8
end

local function apply(v9) -- line 69 | captures: v4, Lighting, FrameFocusFXConfig, CameraFovController
    local v10 = v4
    if v10 == nil or v10.Parent == nil then
        v10 = Instance.new("BlurEffect")
        v10.Name = FrameFocusFXConfig.BlurName
        v10.Size = 0
        v10.Enabled = false
        v10.Parent = Lighting
        v4 = v10
    end
    v10.Size = FrameFocusFXConfig.BlurSize * v9
    v10.Enabled = v9 > 0
    CameraFovController.Set("FrameFocus", FrameFocusFXConfig.FovIncrease * v9)
end

local function setFocused(v11) -- line 77 | captures: v4, v5, v6, Lighting, TweenService, FrameFocusFXConfig, CameraFovController, v1, v2, NumberValue
    if v6 == v11 then
        return
    end
    v6 = v11
    if v5 ~= nil then
        v5:Cancel()
    end
    local v12 = if v11 then v1 else v2
    local v13 = {}
    if v11 then
        v13.Value = 1
    else
        v13.Value = 0
    end
    local v14 = TweenService:Create(NumberValue, v12, v13)
    v5 = v14
    v14.Completed:Once(function(v15) -- line 89 | captures: v11, v4, Lighting, FrameFocusFXConfig, CameraFovController
        local v16, v17
        if v15 == Enum.PlaybackState.Completed then
            if v11 then
                v17 = true
            else
                v16 = v4
                if v16 == nil or v16.Parent == nil then
                    v16 = Instance.new("BlurEffect")
                    v16.Name = FrameFocusFXConfig.BlurName
                    v16.Size = 0
                    v16.Enabled = false
                    v16.Parent = Lighting
                    v4 = v16
                end
                v17 = false
            end
        else
            v17 = true
        end
        if v17 then
            return
        end
        v16.Size = FrameFocusFXConfig.BlurSize * 0
        v16.Enabled = false
        CameraFovController.Set("FrameFocus", FrameFocusFXConfig.FovIncrease * 0)
        CameraFovController.Clear("FrameFocus")
    end)
    v14:Play()
end

local function evaluate() -- line 99 | captures: v7, FrameFocusFXConfig, UiFrames, DemonEventUIController, SciFiTradeInUIController, setFocused
    v7 = false
    local v18 = UiFrames.GetOpen()
    local v19 = if v18 == nil then false else not FrameFocusFXConfig.ExcludedFrames[v18.Name]
    v19 = v19 or DemonEventUIController.IsOpen() or SciFiTradeInUIController.IsOpen()
    setFocused(v19)
end

local function scheduleEvaluate() -- line 106 | captures: v7, evaluate
    if not v7 then
        v7 = true
        task.defer(evaluate)
    end
end

function v3.Start() -- line 114 | captures: v4, v7, Lighting, FrameFocusFXConfig, UiFrames, MainGui, CameraFovController, DemonEventUIController, SciFiTradeInUIController, NumberValue, evaluate
    NumberValue.Changed:Connect(function() -- line 116 | captures: v4, Lighting, FrameFocusFXConfig, CameraFovController, NumberValue
        local Value = NumberValue.Value
        local v20 = v4
        if v20 == nil or v20.Parent == nil then
            v20 = Instance.new("BlurEffect")
            v20.Name = FrameFocusFXConfig.BlurName
            v20.Size = 0
            v20.Enabled = false
            v20.Parent = Lighting
            v4 = v20
        end
        v20.Size = FrameFocusFXConfig.BlurSize * Value
        v20.Enabled = Value > 0
        CameraFovController.Set("FrameFocus", FrameFocusFXConfig.FovIncrease * Value)
    end)
    UiFrames.ObserveAny(function() -- line 120 | captures: v7, evaluate
        if not v7 then
            v7 = true
            task.defer(evaluate)
        end
    end)
    DemonEventUIController.Observe(function() -- line 124 | captures: v7, evaluate
        if not v7 then
            v7 = true
            task.defer(evaluate)
        end
    end)
    SciFiTradeInUIController.Observe(function() -- line 128 | captures: v7, evaluate
        if not v7 then
            v7 = true
            task.defer(evaluate)
        end
    end)
    MainGui.Observe(function() -- line 133 | captures: v7, evaluate
        if not v7 then
            v7 = true
            task.defer(evaluate)
        end
    end)
end

return v3
