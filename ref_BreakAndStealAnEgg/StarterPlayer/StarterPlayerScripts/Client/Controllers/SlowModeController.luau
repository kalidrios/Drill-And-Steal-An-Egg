-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SlowModeConfig = require(ReplicatedStorage.Shared.SlowModeConfig)
local StrokeColors = require(ReplicatedStorage.Shared.StrokeColors)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = TweenInfo.new(SlowModeConfig.TweenDuration, SlowModeConfig.TweenEasingStyle, SlowModeConfig.TweenEasingDirection)
local v2 = { Changed = Instance.new("BindableEvent") }
local v3 = false

function v2.IsOn() -- line 48 | captures: v3
    return v3
end

local function gradientAt(v4) -- line 53 | captures: SlowModeConfig
    local OffGradient = SlowModeConfig.OffGradient
    local OnGradient = SlowModeConfig.OnGradient
    return OffGradient[1]:Lerp(OnGradient[1], v4), OffGradient[2]:Lerp(OnGradient[2], v4)
end

local v5, v6

function v2.Start() -- line 65 | captures: v5, v6, ReplicatedStorage, MainGui
    task.spawn(function() -- line 66 | captures: v5, ReplicatedStorage
        local v7 = ReplicatedStorage:WaitForChild("SlowModeRemote", 30)
        if not (v7 and v7:IsA("RemoteEvent")) then
            warn("[SlowModeController] SlowModeRemote missing \226\128\148 slow mode won't affect WalkSpeed")
        else
            v5 = v7
        end
    end)
    MainGui.Observe(v6)
end

function v6(v8) -- line 82 | captures: v3, v5, TweenService, SlowModeConfig, StrokeColors, v1, v2
    local LeftHUD = v8:FindFirstChild("LeftHUD")
    local v9 = LeftHUD and LeftHUD:FindFirstChild("Slow Mode")
    if not (v9 and v9:IsA("GuiButton")) then
        return
    end
    local ToggleOn = v9:FindFirstChild("ToggleOn")
    if not (ToggleOn and ToggleOn:IsA("GuiObject")) then
        return
    end
    local UiGradient = ToggleOn:FindFirstChild("UiGradient")
    local Inner, Outer, Outer_2
    if UiGradient and UiGradient:IsA("UIGradient") then
        local Inner_2 = ToggleOn:FindFirstChild("Inner")
        Inner = Inner_2
        Outer_2 = ToggleOn:FindFirstChild("Outer")
        Outer = Outer_2
        if Inner_2 and not Inner_2:IsA("UIStroke") then
            Inner = nil
        end
    else
        return
    end
    if Outer_2 and not Outer_2:IsA("UIStroke") then
        Outer = nil
    end

    local function applyColors(v10) -- line 115 | captures: Inner, Outer, UiGradient, SlowModeConfig, StrokeColors
        local OffGradient = SlowModeConfig.OffGradient
        local OnGradient = SlowModeConfig.OnGradient
        local v11 = OffGradient[1]:Lerp(OnGradient[1], v10)
        local v12 = OffGradient[2]:Lerp(OnGradient[2], v10)
        UiGradient.Color = ColorSequence.new(v11, v12)
        if Inner then
            Inner.Color = StrokeColors.Inner(v11, v12)
        end
        if Outer then
            Outer.Color = StrokeColors.Outer(v11:Lerp(v12, 0.5), SlowModeConfig.OuterStrokeDarken)
        end
    end

    local NumberValue = Instance.new("NumberValue")
    NumberValue.Name = "SlowModeColorAlpha"
    NumberValue.Parent = ToggleOn
    NumberValue.Changed:Connect(applyColors)
    local v13, v14

    local function applyState(v15) -- line 137 | captures: v13, v14, ToggleOn, applyColors, NumberValue, v3, TweenService, SlowModeConfig, v1
        local v16 = if v3 then SlowModeConfig.OnPosition else SlowModeConfig.OffPosition
        local v17 = if v3 then 1 else 0
        if v13 ~= nil then
            v13:Cancel()
            v13 = nil
        end
        if v14 ~= nil then
            v14:Cancel()
            v14 = nil
        end
        if v15 then
            v13 = TweenService:Create(ToggleOn, v1, { Position = v16 })
            v14 = TweenService:Create(NumberValue, v1, { Value = v17 })
            v13:Play()
            v14:Play()
        else
            ToggleOn.Position = v16
            NumberValue.Value = v17
            applyColors(v17)
        end
    end

    local v18 = if v3 then SlowModeConfig.OnPosition else SlowModeConfig.OffPosition
    local v19 = if v3 then 1 else 0
    if v13 ~= nil then
        v13:Cancel()
        v13 = nil
    end
    if v14 ~= nil then
        v14:Cancel()
        v14 = nil
    end
    ToggleOn.Position = v18
    NumberValue.Value = v19
    applyColors(v19)
    v9.Activated:Connect(function() -- line 168 | captures: applyState, v3, v5, v2
        v3 = not v3
        applyState(true)
        if v5 then
            v5:FireServer(v3)
        end
        v2.Changed:Fire(v3)
    end)
end

return v2
