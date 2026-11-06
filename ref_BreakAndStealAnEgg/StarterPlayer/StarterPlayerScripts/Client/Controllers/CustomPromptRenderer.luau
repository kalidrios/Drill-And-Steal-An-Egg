-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local PromptThemes = require(script.Parent.PromptThemes)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1 = {}
local v2 = {}

v2[Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png"
v2[Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png"
v2[Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png"
v2[Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png"
v2[Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png"

local v3 = {
    ["'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
    [","] = "rbxasset://textures/ui/Controls/comma.png",
    ["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
    ["."] = "rbxasset://textures/ui/Controls/period.png",
    [" "] = "rbxasset://textures/ui/Controls/spacebar.png"
}
local v4 = {}

v4[Enum.KeyCode.LeftControl] = "Ctrl"
v4[Enum.KeyCode.RightControl] = "Ctrl"
v4[Enum.KeyCode.LeftAlt] = "Alt"
v4[Enum.KeyCode.RightAlt] = "Alt"
v4[Enum.KeyCode.F1] = "F1"
v4[Enum.KeyCode.F2] = "F2"
v4[Enum.KeyCode.F3] = "F3"
v4[Enum.KeyCode.F4] = "F4"
v4[Enum.KeyCode.F5] = "F5"
v4[Enum.KeyCode.F6] = "F6"
v4[Enum.KeyCode.F7] = "F7"
v4[Enum.KeyCode.F8] = "F8"
v4[Enum.KeyCode.F9] = "F9"
v4[Enum.KeyCode.F10] = "F10"
v4[Enum.KeyCode.F11] = "F11"
v4[Enum.KeyCode.F12] = "F12"

local v5 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v6 = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local v7 = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local function gamepadButtonImage(v8) -- line 98 | captures: UserInputService
    local v9, v10 = pcall(function() -- line 99 | captures: v8, UserInputService
        return UserInputService:GetImageForKeyCode(v8)
    end)
    if not v9 or v10 == "" then
        return nil
    end
    return v10
end

local function getScreenGui() -- line 105 | captures: PlayerGui
    local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts")
    if ProximityPrompts ~= nil and ProximityPrompts:IsA("ScreenGui") then
        return ProximityPrompts
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ProximityPrompts"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui
    return ScreenGui
end

local v11 = {}

local function buildEntry(v12) -- line 163 | captures: TweenService, PromptThemes, v5, v6, v7
    local function v13(v14, ...)
        table.insert(v14, ...)
    end

    local function v15(v16, ...)
        table.insert(v16, ...)
    end

    local function v17(v18, ...)
        table.insert(v18, ...)
    end

    local function v19(v20, ...)
        table.insert(v20, ...)
    end

    local function v21(v22, ...)
        table.insert(v22, ...)
    end

    local function v23(v24, ...)
        table.insert(v24, ...)
    end

    local function v25(v26, ...)
        table.insert(v26, ...)
    end

    local function v27(v28, ...)
        table.insert(v28, ...)
    end

    local function v29(v30, ...)
        table.insert(v30, ...)
    end

    local function v31(v32, ...)
        table.insert(v32, ...)
    end

    local function v33(v34, ...)
        table.insert(v34, ...)
    end

    local function v35(v36, ...)
        table.insert(v36, ...)
    end

    local function v37(v38, ...)
        table.insert(v38, ...)
    end

    local function v39(v40, ...)
        table.insert(v40, ...)
    end

    local function v41(v42, ...)
        table.insert(v42, ...)
    end

    local function v43(v44, ...)
        table.insert(v44, ...)
    end

    local function v45(v46, ...)
        table.insert(v46, ...)
    end

    local Create = PromptThemes.Create
    local v47
    if v12 == "Default" then
    else
        v47 = v12
    end
    local v48 = Create(v47)
    local PromptFrame = v48:FindFirstChild("PromptFrame")
    local InputFrame = PromptFrame:FindFirstChild("InputFrame")
    local ActionText = PromptFrame:FindFirstChild("ActionText")
    local ObjectText = PromptFrame:FindFirstChild("ObjectText")
    local v49 = {}
    local v50 = {}
    local v51 = {}
    local v52 = {}
    local BackgroundTransparency = PromptFrame.BackgroundTransparency
    local ImageTransparency = PromptFrame.ImageTransparency
    PromptFrame.BackgroundTransparency = 1
    PromptFrame.ImageTransparency = 1
    v13(v49, TweenService:Create(PromptFrame, v5, {
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Size = UDim2.fromScale(0.5, 1)
    }))
    v15(v50, TweenService:Create(PromptFrame, v5, {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = BackgroundTransparency,
        ImageTransparency = ImageTransparency
    }))
    v17(v51, TweenService:Create(PromptFrame, v5, {
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Size = UDim2.fromScale(0.5, 1)
    }))
    v19(v52, TweenService:Create(PromptFrame, v5, {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = BackgroundTransparency,
        ImageTransparency = ImageTransparency
    }))

    local function setupUIStrokeTweens(v53) -- line 206 | captures: v49, v50, v51, v52, TweenService, v5
        local function v54(v55, ...)
            table.insert(v55, ...)
        end

        local function v56(v57, ...)
            table.insert(v57, ...)
        end

        local function v58(v59, ...)
            table.insert(v59, ...)
        end

        local function v60(v61, ...)
            table.insert(v61, ...)
        end

        local Transparency = v53.Transparency
        v53.Transparency = 1
        v54(v49, TweenService:Create(v53, v5, { Transparency = 1 }))
        v56(v50, TweenService:Create(v53, v5, { Transparency = Transparency }))
        v58(v51, TweenService:Create(v53, v5, { Transparency = 1 }))
        v60(v52, TweenService:Create(v53, v5, { Transparency = Transparency }))
    end

    local function setupGUIObjectTweens(v62) -- line 215 | captures: v49, v50, v51, v52, TweenService, v5
        local function v63(v64, ...)
            table.insert(v64, ...)
        end

        local function v65(v66, ...)
            table.insert(v66, ...)
        end

        local function v67(v68, ...)
            table.insert(v68, ...)
        end

        local function v69(v70, ...)
            table.insert(v70, ...)
        end

        local BackgroundTransparency = v62.BackgroundTransparency
        v62.BackgroundTransparency = 1
        v63(v49, TweenService:Create(v62, v5, { BackgroundTransparency = 1 }))
        v65(v50, TweenService:Create(v62, v5, { BackgroundTransparency = BackgroundTransparency }))
        v67(v51, TweenService:Create(v62, v5, { BackgroundTransparency = 1 }))
        v69(v52, TweenService:Create(v62, v5, { BackgroundTransparency = BackgroundTransparency }))
    end

    local function setupTextLabelTweens(v71) -- line 224 | captures: v49, v50, v51, v52, TweenService, v5
        local function v72(v73, ...)
            table.insert(v73, ...)
        end

        local function v74(v75, ...)
            table.insert(v75, ...)
        end

        local function v76(v77, ...)
            table.insert(v77, ...)
        end

        local function v78(v79, ...)
            table.insert(v79, ...)
        end

        local TextTransparency = v71.TextTransparency
        local TextStrokeTransparency = v71.TextStrokeTransparency
        v71.TextTransparency = 1
        v71.TextStrokeTransparency = 1
        v72(v49, TweenService:Create(v71, v5, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }))
        v74(v50, TweenService:Create(v71, v5, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency
        }))
        v76(v51, TweenService:Create(v71, v5, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }))
        v78(v52, TweenService:Create(v71, v5, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency
        }))
    end

    local function setupImageLabelTweens(v80) -- line 235 | captures: v49, v50, v51, v52, TweenService, v5
        local function v81(v82, ...)
            table.insert(v82, ...)
        end

        local function v83(v84, ...)
            table.insert(v84, ...)
        end

        local function v85(v86, ...)
            table.insert(v86, ...)
        end

        local function v87(v88, ...)
            table.insert(v88, ...)
        end

        local ImageTransparency = v80.ImageTransparency
        v80.ImageTransparency = 1
        v81(v49, TweenService:Create(v80, v5, { ImageTransparency = 1 }))
        v83(v50, TweenService:Create(v80, v5, { ImageTransparency = ImageTransparency }))
        v85(v51, TweenService:Create(v80, v5, { ImageTransparency = 1 }))
        v87(v52, TweenService:Create(v80, v5, { ImageTransparency = ImageTransparency }))
    end

    local setupDecorationTweens

    local function setupDecorationTweens_2(v89) -- line 244 | captures: setupUIStrokeTweens, setupGUIObjectTweens, setupTextLabelTweens, setupImageLabelTweens, setupDecorationTweens
        if v89:IsA("UIStroke") then
            setupUIStrokeTweens(v89)
        elseif not v89:IsA("UIGradient") and v89:IsA("GuiObject") then
            setupGUIObjectTweens(v89)
            if v89:IsA("TextLabel") then
                setupTextLabelTweens(v89)
            elseif v89:IsA("ImageLabel") then
                setupImageLabelTweens(v89)
            end
        end
        for v90, v91 in ipairs(v89:GetChildren()) do
            setupDecorationTweens(v91)
        end
    end

    setupDecorationTweens = setupDecorationTweens_2
    local v92 = {}
    v92[InputFrame] = false
    v92[ActionText] = true
    v92[ObjectText] = true
    for v93, v94 in ipairs(PromptFrame:GetChildren()) do
        local v95 = v92[v94]
        if v95 == nil then
            setupDecorationTweens_2(v94)
        elseif v95 == true then
            for v96, v97 in ipairs(v94:GetChildren()) do
                setupDecorationTweens_2(v97)
            end
        end
    end
    local Frame = InputFrame:FindFirstChild("Frame")
    local UIScale = Frame:FindFirstChild("UIScale")
    v21(v50, TweenService:Create(UIScale, v5, { Scale = 1 }))
    setupTextLabelTweens(ActionText)
    setupTextLabelTweens(ObjectText)
    local ButtonFrame = Frame:FindFirstChild("ButtonFrame")
    v23(v51, TweenService:Create(ButtonFrame, v6, {
        BackgroundTransparency = 1,
        ImageTransparency = 1
    }))
    v25(v52, TweenService:Create(ButtonFrame, v6, {
        BackgroundTransparency = ButtonFrame.BackgroundTransparency,
        ImageTransparency = ButtonFrame.ImageTransparency
    }))
    for v98, v99 in ipairs(ButtonFrame:GetChildren()) do
        if v99:IsA("UIStroke") then
            v27(v51, TweenService:Create(v99, v6, { Transparency = 1 }))
            v29(v52, TweenService:Create(v99, v6, { Transparency = v99.Transparency }))
        end
    end
    local ButtonImage = Frame:FindFirstChild("ButtonImage")
    local ButtonText = Frame:FindFirstChild("ButtonText")
    local ButtonTextImage = Frame:FindFirstChild("ButtonTextImage")
    local TextTransparency = ButtonText.TextTransparency
    local TextStrokeTransparency = ButtonText.TextStrokeTransparency
    local BackgroundTransparency_2 = ButtonText.BackgroundTransparency
    ButtonText.BackgroundTransparency = 1
    ButtonText.TextStrokeTransparency = 1
    ButtonText.TextTransparency = 1
    v31(v51, TweenService:Create(ButtonText, v6, {
        TextTransparency = 1,
        TextStrokeTransparency = 1,
        BackgroundTransparency = 1
    }))
    v33(v52, TweenService:Create(ButtonText, v6, {
        TextTransparency = TextTransparency,
        TextStrokeTransparency = TextStrokeTransparency,
        BackgroundTransparency = BackgroundTransparency_2
    }))
    for v100, v101 in ipairs(ButtonText:GetChildren()) do
        if v101:IsA("UIStroke") then
            v35(v51, TweenService:Create(v101, v6, { Transparency = 1 }))
            v37(v52, TweenService:Create(v101, v6, { Transparency = v101.Transparency }))
        end
    end
    local ImageTransparency_2 = ButtonImage.ImageTransparency
    local BackgroundTransparency_3 = ButtonImage.BackgroundTransparency
    ButtonImage.BackgroundTransparency = 1
    ButtonImage.ImageTransparency = 1
    v39(v51, TweenService:Create(ButtonImage, v6, {
        ImageTransparency = 1,
        BackgroundTransparency = 1
    }))
    v41(v52, TweenService:Create(ButtonImage, v6, {
        ImageTransparency = ImageTransparency_2,
        BackgroundTransparency = BackgroundTransparency_3
    }))
    local BackgroundTransparency_4 = ButtonTextImage.BackgroundTransparency
    local ImageTransparency_3 = ButtonTextImage.ImageTransparency
    ButtonTextImage.BackgroundTransparency = 1
    ButtonTextImage.ImageTransparency = 1
    v43(v51, TweenService:Create(ButtonTextImage, v6, {
        ImageTransparency = 1,
        BackgroundTransparency = 1
    }))
    v45(v52, TweenService:Create(ButtonTextImage, v6, {
        ImageTransparency = ImageTransparency_3,
        BackgroundTransparency = BackgroundTransparency_4
    }))
    local ProgressBar = Frame:FindFirstChild("ProgressBar")
    local Progress
    if ProgressBar then
        local UIGradient = ProgressBar:FindFirstChild("LeftGradient"):FindFirstChild("ProgressBarImage"):FindFirstChild("UIGradient")
        local UIGradient_2 = ProgressBar:FindFirstChild("RightGradient"):FindFirstChild("ProgressBarImage"):FindFirstChild("UIGradient")
        Progress = ProgressBar:FindFirstChild("Progress")
        Progress.Changed:Connect(function(v102) -- line 369 | captures: UIGradient, UIGradient_2
            local v103 = v102 * 360
            local v104 = math.clamp(v103, 0, 360)
            UIGradient.Rotation = math.clamp(v104, 180, 360)
            UIGradient_2.Rotation = math.clamp(v104, 0, 180)
        end)
    end
    local v105 = {
        HitButton = nil,
        ScaleHoldTween = nil,
        ScaleHoldTarget = nil,
        ProgressTween = nil,
        ProgressDuration = nil,
        Prompt = nil,
        Holding = false,
        ClickEnabled = false,
        Gui = v48,
        ThemeKey = v12,
        HoldBeganTweens = v49,
        HoldEndedTweens = v50,
        HideTweens = v51,
        ShowTweens = v52,
        PromptFrame = PromptFrame,
        ActionText = ActionText,
        ObjectText = ObjectText,
        UiScale = UIScale,
        ButtonText = ButtonText,
        ButtonImage = ButtonImage,
        ButtonTextImage = ButtonTextImage,
        ProgressValue = Progress,
        AuthoredButtonTextSize = ButtonText.TextSize,
        AuthoredTextVisible = ButtonText.Visible,
        AuthoredImageVisible = ButtonImage.Visible,
        AuthoredIconVisible = ButtonTextImage.Visible
    }
    local v106
    if Progress then
        v106 = TweenService:Create(Progress, v7, { Value = 0 })
    end
    v105.ProgressResetTween = v106
    v105.Connections = {}
    local TextButton = v48:FindFirstChild("TextButton")
    if TextButton and TextButton:IsA("TextButton") then
        v105.HitButton = TextButton
        TextButton.InputBegan:Connect(function(v107) -- line 411 | captures: v105
            local Prompt = v105.Prompt
            if Prompt and v105.ClickEnabled and (v107.UserInputType == Enum.UserInputType.Touch or v107.UserInputType == Enum.UserInputType.MouseButton1) and v107.UserInputState ~= Enum.UserInputState.Change then
                Prompt:InputHoldBegin()
                v105.Holding = true
            end
        end)
        TextButton.InputEnded:Connect(function(v108) -- line 425 | captures: v105
            local Prompt = v105.Prompt
            if Prompt and v105.Holding and (v108.UserInputType == Enum.UserInputType.Touch or v108.UserInputType == Enum.UserInputType.MouseButton1) then
                v105.Holding = false
                Prompt:InputHoldEnd()
            end
        end)
    end
    return v105
end

local v109 = {
    ActionText = true,
    ObjectText = true,
    AutoLocalize = true,
    RootLocalizationTable = true,
    UIOffset = true
}

local function getTextBoundsForLabel(v110, v111) -- line 454 | captures: TextService
    local GetTextBoundsParams = Instance.new("GetTextBoundsParams")
    GetTextBoundsParams.Font = v110.FontFace
    GetTextBoundsParams.Size = v110.TextSize
    GetTextBoundsParams.Width = 1000
    local v112 = v111 or ""
    if v110.RichText then
        v112 = v112:gsub("<[^>]->", "")
    end
    GetTextBoundsParams.Text = v112
    local v113, v114 = pcall(TextService.GetTextBoundsAsync, TextService, GetTextBoundsParams)
    GetTextBoundsParams:Destroy()
    if v113 then
        return v114
    end
    return Vector2.new(#v112 * v110.TextSize * 0.5, v110.TextSize)
end

local function acquirePrompt(v115, v116, v117) -- line 479 | captures: TweenService, UserInputService, v2, v3, v4, v5, v11, buildEntry, v109, getTextBoundsForLabel
    local function v118(v119, ...)
        table.insert(v119, ...)
    end

    local function v120(v121, ...)
        table.insert(v121, ...)
    end

    local function v122(v123, ...)
        table.insert(v123, ...)
    end

    local function v124(v125, ...)
        table.insert(v125, ...)
    end

    local function v126(v127, ...)
        table.insert(v127, ...)
    end

    local Theme = v115:GetAttribute("Theme")
    if typeof(Theme) ~= "string" then
        Theme = "Default"
    end
    local v128 = v11[Theme]
    local v129
    if v128 then
        v129 = table.remove(v128)
    end
    local v130 = v129 or buildEntry(Theme)
    local Gui = v130.Gui
    v130.Prompt = v115
    v130.Holding = false
    v130.UiScale.Scale = 1
    if v130.ProgressValue then
        v130.ProgressValue.Value = 0
    end
    local ButtonText = v130.ButtonText
    local ButtonImage = v130.ButtonImage
    local ButtonTextImage = v130.ButtonTextImage
    ButtonText.TextSize = v130.AuthoredButtonTextSize
    ButtonText.Visible = v130.AuthoredTextVisible
    ButtonImage.Visible = v130.AuthoredImageVisible
    ButtonTextImage.Visible = v130.AuthoredIconVisible
    local v131 = if v116 == Enum.ProximityPromptInputType.Touch then 1.6 else 1.33
    if v130.ScaleHoldTarget ~= v131 then
        v130.ScaleHoldTarget = v131
        v130.ScaleHoldTween = TweenService:Create(v130.UiScale, v5, { Scale = v131 })
    end
    if v130.ProgressValue and v115.HoldDuration > 0 and v130.ProgressDuration ~= v115.HoldDuration then
        v130.ProgressDuration = v115.HoldDuration
        v130.ProgressTween = TweenService:Create(v130.ProgressValue, TweenInfo.new(v115.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Value = 1 })
    end
    if v116 == Enum.ProximityPromptInputType.Gamepad then
        local GamepadKeyCode = v115.GamepadKeyCode
        local v132, v133 = pcall(function() -- line 99 | captures: GamepadKeyCode, UserInputService
            return UserInputService:GetImageForKeyCode(GamepadKeyCode)
        end)
        if v132 then
            if v133 == "" then
                v133 = nil
            end
        else
            v133 = nil
        end
        if v133 then
            ButtonTextImage.Image = v133
            ButtonText.Visible = false
            ButtonImage.Visible = false
            ButtonTextImage.Visible = true
        end
    elseif v116 == Enum.ProximityPromptInputType.Touch then
        ButtonImage.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png"
        ButtonText.Visible = false
        ButtonTextImage.Visible = false
        ButtonImage.Visible = true
    else
        ButtonImage.Visible = true
        local v134 = UserInputService:GetStringForKeyCode(v115.KeyboardKeyCode)
        local v135 = v2[v115.KeyboardKeyCode]
        if v135 == nil then
            v135 = v3[v134]
        end
        if v135 == nil then
            v134 = v4[v115.KeyboardKeyCode] or v134
        end
        if v135 then
            ButtonTextImage.Image = v135
            ButtonText.Visible = false
            ButtonTextImage.Visible = true
        else
            local v136
            if v134 == nil or v134 == "" then
                local warn_2 = warn
                local v137 = "ProximityPrompt '%*' has an unsupported keycode for rendering UI: %*"
                local Name = v115.Name
                local KeyboardKeyCode = v115.KeyboardKeyCode
                warn_2((v137:format(Name, (tostring(KeyboardKeyCode)))))
                v136 = "?"
            else
                v136 = v134
            end
            if string.len(v136) > 2 then
                local v138 = v130.AuthoredButtonTextSize * 6 / 7
                ButtonText.TextSize = math.round(v138)
            end
            ButtonText.Text = v136
            ButtonTextImage.Visible = false
            ButtonText.Visible = true
        end
    end
    local v139 = if v116 == Enum.ProximityPromptInputType.Touch then true else v115.ClickablePrompt
    v130.ClickEnabled = v139
    Gui.Active = v130.ClickEnabled
    local Connections = v130.Connections
    if v115.HoldDuration > 0 then
        local PromptButtonHoldBegan = v115.PromptButtonHoldBegan
        v118(Connections, PromptButtonHoldBegan:Connect(function() -- line 580 | captures: v130
            for v140, v141 in ipairs(v130.HoldBeganTweens) do
                v141:Play()
            end
            if v130.ScaleHoldTween then
                v130.ScaleHoldTween:Play()
            end
            if v130.ProgressTween then
                v130.ProgressTween:Play()
            end
        end))
        local PromptButtonHoldEnded = v115.PromptButtonHoldEnded
        v120(Connections, PromptButtonHoldEnded:Connect(function() -- line 591 | captures: v130
            for v142, v143 in ipairs(v130.HoldEndedTweens) do
                v143:Play()
            end
            if v130.ProgressResetTween then
                v130.ProgressResetTween:Play()
            end
        end))
    end
    local Triggered = v115.Triggered
    v122(Connections, Triggered:Connect(function() -- line 601 | captures: v130
        for v144, v145 in ipairs(v130.HideTweens) do
            v145:Play()
        end
    end))
    local TriggerEnded = v115.TriggerEnded
    v124(Connections, TriggerEnded:Connect(function() -- line 606 | captures: v130
        for v146, v147 in ipairs(v130.ShowTweens) do
            v147:Play()
        end
    end))
    local ActionText = v130.ActionText
    local ObjectText = v130.ObjectText

    local function updateUIFromPrompt() -- line 615 | captures: v115, v130, Gui, ActionText, ObjectText, getTextBoundsForLabel
        local v148
        if not (v115.ActionText == nil or v115.ActionText == "") or v115.ObjectText ~= nil and v115.ObjectText ~= "" then
            local X = getTextBoundsForLabel(ActionText, v115.ActionText).X
            local X_2 = getTextBoundsForLabel(ObjectText, v115.ObjectText).X
            v148 = math.max(X, X_2) + 72 + 24
        else
            v148 = 72
        end
        if v130.Prompt ~= v115 then
            return
        end
        local new = UDim2.new
        local v149 = 72 - v148 / 2
        local v150 = if v115.ObjectText == nil or v115.ObjectText == "" then 0 else 9
        ActionText.Position = new(0.5, v149, 0, v150)
        ObjectText.Position = UDim2.new(0.5, 72 - v148 / 2, 0, -10)
        ActionText.Text = v115.ActionText
        ObjectText.Text = v115.ObjectText
        ActionText.AutoLocalize = v115.AutoLocalize
        ActionText.RootLocalizationTable = v115.RootLocalizationTable
        ObjectText.AutoLocalize = v115.AutoLocalize
        ObjectText.RootLocalizationTable = v115.RootLocalizationTable
        Gui.Size = UDim2.fromOffset(v148, 72)
        Gui.SizeOffset = Vector2.new(v115.UIOffset.X / Gui.Size.Width.Offset, v115.UIOffset.Y / Gui.Size.Height.Offset)
    end

    local Changed = v115.Changed
    v126(Connections, Changed:Connect(function(v151) -- line 638 | captures: updateUIFromPrompt, v109
        if v109[v151] then
            updateUIFromPrompt()
        end
    end))
    updateUIFromPrompt()
    Gui.Adornee = v115.Parent
    Gui.Enabled = true
    Gui.Parent = v117
    for v152, v153 in ipairs(v130.ShowTweens) do
        v153:Play()
    end
    return function() -- line 653 | captures: v115, v130, Gui, Connections, v11
        for v154, v155 in ipairs(Connections) do
            v155:Disconnect()
        end
        table.clear(Connections)
        if v130.ProgressTween then
            v130.ProgressTween:Cancel()
        end
        if v130.ScaleHoldTween then
            v130.ScaleHoldTween:Cancel()
        end
        if v130.Holding and v115.Parent then
            v115:InputHoldEnd()
        end
        v130.Prompt = nil
        v130.Holding = false
        for v156, v157 in ipairs(v130.HideTweens) do
            v157:Play()
        end
        task.wait(0.2)
        Gui.Enabled = false
        Gui.Adornee = nil
        local v158 = v11[v130.ThemeKey]
        if not v158 then
            v158 = {}
            v11[v130.ThemeKey] = v158
        end
        if #v158 < 6 then
            table.insert(v158, v130)
        else
            Gui:Destroy()
        end
    end
end

local function reservedForOther(v159) -- line 701 | captures: LocalPlayer
    local ReservedUserId = v159:GetAttribute("ReservedUserId")
    if typeof(ReservedUserId) == "number" then
        return ReservedUserId ~= LocalPlayer.UserId
    end
    return false
end

function v1.Start() -- line 706 | captures: ProximityPromptService, LocalPlayer, PlayerGui, acquirePrompt
    ProximityPromptService.PromptShown:Connect(function(v160, v161) -- line 707 | captures: LocalPlayer, PlayerGui, acquirePrompt
        if v160.Style ~= Enum.ProximityPromptStyle.Default then
            local ReservedUserId = v160:GetAttribute("ReservedUserId")
            if not (typeof(ReservedUserId) == "number" and ReservedUserId ~= LocalPlayer.UserId) then
                local v162
                local v163 = false
                local v164 = false
                local v165, v166

                local function finish() -- line 728 | captures: v162, v163, v164, v165, v166
                    v163 = true
                    v165:Disconnect()
                    v166:Disconnect()
                    if not v164 and v162 then
                        v164 = true
                        v162()
                    end
                end

                v165 = v160.PromptHidden:Connect(finish)
                v166 = v160.Destroying:Once(finish)
                local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts")
                if not (ProximityPrompts ~= nil and ProximityPrompts:IsA("ScreenGui")) then
                    ProximityPrompts = Instance.new("ScreenGui")
                    ProximityPrompts.Name = "ProximityPrompts"
                    ProximityPrompts.ResetOnSpawn = false
                    ProximityPrompts.Parent = PlayerGui
                end
                v162 = acquirePrompt(v160, v161, ProximityPrompts)
                if v163 and not v164 then
                    v164 = true
                    v162()
                end
            end
        end
    end)
end

return v1
