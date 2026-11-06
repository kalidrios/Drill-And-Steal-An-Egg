-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SettingsConfig = require(ReplicatedStorage.Shared.SettingsConfig)
local StrokeColors = require(ReplicatedStorage.Shared.StrokeColors)
local SettingsState = require(script.Parent.Parent.Modules.SettingsState)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local v2 = TweenInfo.new(SettingsConfig.ToggleTweenDuration, SettingsConfig.ToggleTweenEasingStyle, SettingsConfig.ToggleTweenEasingDirection)
local v3

local function isPressInput(v4) -- line 56
    if v4.UserInputType == Enum.UserInputType.MouseButton1 then
        return true
    end
    return v4.UserInputType == Enum.UserInputType.Touch
end

local function isMoveInput(v5) -- line 61
    if v5.UserInputType == Enum.UserInputType.MouseMovement then
        return true
    end
    return v5.UserInputType == Enum.UserInputType.Touch
end

local function fractionAt(v6, v7) -- line 67
    local X = v6.AbsoluteSize.X
    if X <= 0 then
        return 0
    end
    local v8 = (v7 - v6.AbsolutePosition.X) / X
    return (math.clamp(v8, 0, 1))
end

local function bindSlider(v9, v10, v11) -- line 79 | captures: v3, SettingsState
    local Container = v9:FindFirstChild("Container")
    local v12 = Container and Container:FindFirstChild("DragBar")
    if v12 then
        local v13 = v12:FindFirstChild("DragButton")
        local v14 = v12:FindFirstChild("Fill")
        if v12:IsA("GuiObject") and v13 and v13:IsA("GuiButton") and v14 and v14:IsA("GuiObject") then
            local v15 = SettingsState.Observe(v10, function(v16) -- line 90 | captures: v13, v14
                if type(v16) == "number" then
                    v13.Position = UDim2.new(v16, 0, v13.Position.Y.Scale, v13.Position.Y.Offset)
                    v14.Size = UDim2.new(v16, 0, v14.Size.Y.Scale, v14.Size.Y.Offset)
                end
            end)
            table.insert(v11, v15)

            local function beginDrag(v17) -- line 101 | captures: v10, v12, v3, SettingsState
                if v17.UserInputType ~= Enum.UserInputType.MouseButton1 and v17.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end
                v3 = {
                    bar = v12,
                    apply = function(v18) -- apply | line 107 | captures: v10, SettingsState
                        SettingsState.Set(v10, v18)
                    end
                }
                local Set = SettingsState.Set
                local X = v17.Position.X
                local X_2 = v12.AbsoluteSize.X
                local v19
                if X_2 <= 0 then
                    v19 = 0
                else
                    local v20 = (X - v12.AbsolutePosition.X) / X_2
                    v19 = math.clamp(v20, 0, 1)
                end
                Set(v10, v19)
            end

            v13.InputBegan:Connect(beginDrag)
            v12.InputBegan:Connect(beginDrag)
            return
        end
    end
    warn((("[SettingsController] slider row %* missing DragBar/DragButton/Fill"):format(v9.Name)))
end

local function luminance(v21) -- line 122
    return 0.299 * v21.R + 0.587 * v21.G + 0.114 * v21.B
end

local function bindToggle(v22, v23, v24) -- line 126 | captures: TweenService, SettingsConfig, StrokeColors, SettingsState, v2
    local v25 = {}
    local Container = v22:FindFirstChild("Container")
    local v26 = Container and Container:FindFirstChild("Toggle")
    local UiGradient, Position, BackgroundColor3, v27, UiGradient_2, v28, v29, v30
    if v26 then
        v28 = v26:FindFirstChild("ToggleOn")
        v29 = v26:FindFirstChild("Title")
        if v26:IsA("GuiButton") and v28 and v28:IsA("GuiObject") then
            Position = v28.Position
            BackgroundColor3 = v28.BackgroundColor3
            local v31 = 1 - Position.X.Scale + (2 * v28.AnchorPoint.X - 1) * v28.Size.X.Scale
            v27 = UDim2.new(v31, -Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
            local UiGradient_3 = v28:FindFirstChild("UiGradient")
            UiGradient = UiGradient_3
            if UiGradient_3 then
                if UiGradient_3:IsA("UIGradient") then
                    UiGradient_2 = UiGradient_3
                else
                    UiGradient = nil
                end
            else
                UiGradient_2 = UiGradient_3
            end
            v30 = false
        else
            v30 = true
        end
    else
        v28 = v26
        v29 = v26
        v30 = true
    end
    if not v30 then
        local NumberValue, v32
        if UiGradient_2 then
            local Keypoints = UiGradient_2.Color.Keypoints
            local v33 = SettingsConfig.ToggleOffGradient[1]
            v25[1] = v33
            local v34 = SettingsConfig.ToggleOffGradient[2]
            local v35 = v34
            local Value = Keypoints[1].Value
            local Value_2 = Keypoints[#Keypoints].Value
            local v36 = 0.299 * Value.R + 0.587 * Value.G + 0.114 * Value.B
            local v37 = 0.299 * Value_2.R + 0.587 * Value_2.G + 0.114 * Value_2.B < v36
            local v38 = 0.299 * v33.R + 0.587 * v33.G + 0.114 * v33.B
            if v37 ~= (0.299 * v34.R + 0.587 * v34.G + 0.114 * v34.B < v38) then
                v35 = v33
                v25[1] = v34
                v33, v34 = v34, v33
            end
            local Inner = v28:FindFirstChild("Inner")
            local Inner_2 = Inner
            local Inner_3
            if Inner then
                if Inner:IsA("UIStroke") then
                    Inner_3 = Inner
                else
                    Inner_2 = nil
                end
            else
                Inner_3 = Inner
            end
            local Outer = v28:FindFirstChild("Outer")
            local Outer_2 = Outer
            local Outer_3
            if Outer then
                if Outer:IsA("UIStroke") then
                    Outer_3 = Outer
                else
                    Outer_2 = nil
                end
            else
                Outer_3 = Outer
            end
            local v39 = Inner_3 and Inner_3.Color
            local v40 = StrokeColors.Inner(v33, v34)
            local v41 = Outer_3 and Outer_3.Color
            local v42 = StrokeColors.Outer(v33:Lerp(v34, 0.5))
            local applyColors = (function(v43)
                local function applyColors(v44) -- line 187 | captures: v43, UiGradient, v35, Inner_2, Outer_2, Keypoints, v40, v42, v41, v39
                    local v45 = math.clamp(v44, 0, 1)
                    local v46 = table.create(#Keypoints)
                    for v47, v48 in Keypoints do
                        local v49 = v43[1]:Lerp(v35, v48.Time)
                        v46[v47] = ColorSequenceKeypoint.new(v48.Time, v49:Lerp(v48.Value, v45))
                    end
                    UiGradient.Color = ColorSequence.new(v46)
                    if Inner_2 then
                        Inner_2.Color = v40:Lerp(v39, v45)
                    end
                    if Outer_2 then
                        Outer_2.Color = v42:Lerp(v41, v45)
                    end
                end

                return applyColors
            end)(v25)
            local NumberValue_2 = Instance.new("NumberValue")
            NumberValue_2.Name = "ToggleColorAlpha"
            NumberValue_2.Value = 1
            NumberValue_2.Changed:Connect(applyColors)
            NumberValue_2.Parent = v28
            NumberValue = NumberValue_2
            local v50 = v25[1]
            local v51 = {}
            v51[1] = v50
            v32 = v51
        else
            v32 = v25
        end
        local v52
        v32[1] = nil
        local Observe = SettingsState.Observe
        local v53 = v29
        local Position_2 = Position
        local v54 = v27
        local BackgroundColor3_2 = BackgroundColor3
        local v55 = v28
        local v56 = Observe(v23, ((function(v57)
            return function(v58) -- line 214 | captures: v57, NumberValue, v52, v53, Position_2, v54, BackgroundColor3_2, v55, TweenService, SettingsConfig, v2
                local v59 = v58 == true
                if v53 and v53:IsA("TextLabel") then
                    local v60 = if v59 then SettingsConfig.ToggleOnText else SettingsConfig.ToggleOffText
                    v53.Text = v60
                end
                if v52 then
                    v52:Cancel()
                end
                if v57[1] then
                    v57[1]:Cancel()
                end
                local v61 = {}
                if v59 then
                    v61.Position = Position_2
                else
                    v61.Position = v54
                end
                if NumberValue then
                    local NumberValue_2 = NumberValue
                    local v62 = {}
                    if v59 then
                        v62.Value = 1
                    else
                        v62.Value = 0
                    end
                    v57[1] = TweenService:Create(NumberValue_2, v2, v62)
                    v57[1]:Play()
                elseif v59 then
                    v61.BackgroundColor3 = BackgroundColor3_2
                else
                    v61.BackgroundColor3 = SettingsConfig.ToggleOffColor
                end
                local v63 = TweenService:Create(v55, v2, v61)
                v52 = v63
                v63:Play()
            end
        end)(v32)))
        table.insert(v24, v56)
        v26.Activated:Connect(function() -- line 240 | captures: v23, SettingsState
            SettingsState.Set(v23, SettingsState.Get(v23) ~= true)
        end)
    else
        warn((("[SettingsController] toggle row %* missing Toggle/ToggleOn"):format(v22.Name)))
    end
end

function v1.Start() -- line 247 | captures: v3, UserInputService, SettingsConfig, MainGui, bindSlider, bindToggle
    UserInputService.InputChanged:Connect(function(v64) -- line 250 | captures: v3
        local v65 = v3
        if v65 ~= nil and (v64.UserInputType == Enum.UserInputType.MouseMovement or v64.UserInputType == Enum.UserInputType.Touch) then
            if v65.bar.Parent then
                local apply = v65.apply
                local bar = v65.bar
                local X = v64.Position.X
                local X_2 = bar.AbsoluteSize.X
                local v66
                if X_2 <= 0 then
                    v66 = 0
                else
                    local v67 = (X - bar.AbsolutePosition.X) / X_2
                    v66 = math.clamp(v67, 0, 1)
                end
                apply(v66)
            else
                v3 = nil
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(v68) -- line 261 | captures: v3
        if v68.UserInputType == Enum.UserInputType.MouseButton1 or v68.UserInputType == Enum.UserInputType.Touch then
            v3 = nil
        end
    end)
    MainGui.Observe(function(v69) -- line 267 | captures: SettingsConfig, bindSlider, bindToggle
        local v70 = v69:WaitForChild("Frames", 30)
        local v71 = v70 and v70:WaitForChild("Settings", 30)
        local v72 = v71 and v71:FindFirstChild("SettingsList")
        if v72 then
            local v73 = {}
            v72.Destroying:Connect(function() -- line 278 | captures: v73
                for v74, v75 in v73 do
                    v75()
                end
            end)
            for v76, v77 in SettingsConfig.SliderRows do
                local v78 = v72:FindFirstChild(v77)
                if v78 then
                    bindSlider(v78, v77, v73)
                else
                    warn((("[SettingsController] slider row %* missing"):format(v77)))
                end
            end
            for v79, v80 in SettingsConfig.ToggleRows do
                local v81 = v72:FindFirstChild(v80)
                if v81 then
                    bindToggle(v81, v80, v73)
                else
                    warn((("[SettingsController] toggle row %* missing"):format(v80)))
                end
            end
        else
            warn("[SettingsController] MainGUI.Frames.Settings.SettingsList missing")
        end
    end)
end

return v1
