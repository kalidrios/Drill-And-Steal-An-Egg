-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ButtonTweenConfig = require(ReplicatedStorage.Shared.ButtonTweenConfig)
local UiSounds = require(script.Parent.Parent.Modules.UiSounds)
local FloatingIconFX = require(script.Parent.Parent.Modules.FloatingIconFX)
local ListLayoutFreeze = require(script.Parent.Parent.Modules.ListLayoutFreeze)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2 = Vector2.new(0.5, 0.5)
local v3 = TweenInfo.new(ButtonTweenConfig.TweenDuration, ButtonTweenConfig.TweenEasingStyle, ButtonTweenConfig.TweenEasingDirection)
local v4 = {}

local function enumFrom(v5, v6, v7) -- line 114
    if typeof(v6) == "string" then
        local v8, v9 = pcall(function() -- line 116 | captures: v5, v6
            return v5[v6]
        end)
        if v8 and typeof(v9) == "EnumItem" then
            return v9
        end
    end
    return v7
end

local function tweenInfoFor(v10) -- line 126 | captures: ButtonTweenConfig, v3, v4
    if v10 then
        local TweenDuration = v10:GetAttribute("TweenDuration")
        local TweenEasingStyle = v10:GetAttribute("TweenEasingStyle")
        local TweenEasingDirection = v10:GetAttribute("TweenEasingDirection")
        if TweenDuration == nil and TweenEasingStyle == nil and TweenEasingDirection == nil then
            return v3
        end
        local v11 = ("%*|%*|%*"):format(TweenDuration, TweenEasingStyle, TweenEasingDirection)
        local v12 = v4[v11]
        if v12 then
            return v12
        end
        local new = TweenInfo.new
        if typeof(TweenDuration) ~= "number" then
            TweenDuration = ButtonTweenConfig.TweenDuration
        end
        local EasingStyle = Enum.EasingStyle
        local TweenEasingStyle_2 = ButtonTweenConfig.TweenEasingStyle
        local v13, v14
        if typeof(TweenEasingStyle) == "string" then
            local v15
            v15, v13 = pcall(function() -- line 116 | captures: TweenEasingStyle, EasingStyle
                return EasingStyle[TweenEasingStyle]
            end)
            if v15 then
                v14 = typeof(v13) == "EnumItem"
            else
                v14 = false
            end
        else
            v14 = false
        end
        if not v14 then
            v13 = TweenEasingStyle_2
        end
        local EasingDirection = Enum.EasingDirection
        local TweenEasingDirection_2 = ButtonTweenConfig.TweenEasingDirection
        local v16, v17
        if typeof(TweenEasingDirection) == "string" then
            local v18
            v18, v16 = pcall(function() -- line 116 | captures: TweenEasingDirection, EasingDirection
                return EasingDirection[TweenEasingDirection]
            end)
            if v18 then
                v17 = typeof(v16) == "EnumItem"
            else
                v17 = false
            end
        else
            v17 = false
        end
        if not v17 then
            v16 = TweenEasingDirection_2
        end
        local v19 = new(TweenDuration, v13, v16)
        v4[v11] = v19
        return v19
    end
    return v3
end

local v20 = {}
local v21 = {}

local function getOrCreateScale(v22) -- line 166
    local ButtonTweenScale = v22:FindFirstChild("ButtonTweenScale")
    if ButtonTweenScale ~= nil and ButtonTweenScale:IsA("UIScale") then
        return ButtonTweenScale
    end
    local UIScale = Instance.new("UIScale")
    UIScale.Name = "ButtonTweenScale"
    UIScale.Scale = 1
    UIScale.Parent = v22
    return UIScale
end

local function getManagingLayout(v23) -- line 179
    local Parent = v23.Parent
    if Parent == nil then
        return nil
    end
    return Parent:FindFirstChildWhichIsA("UIGridStyleLayout")
end

local v24 = {}
local v25 = { __mode = "k" }
local v26 = setmetatable(v24, v25)

local function freezeListLayout(v27, v28) -- line 197 | captures: ListLayoutFreeze, v26
    if v26[v27] then
        return
    end
    v26[v27] = true
    task.spawn(function() -- line 203 | captures: v27, v28, ListLayoutFreeze, v26
        local v29 = os.clock() + 5
        while (v27.AbsoluteSize.X <= 0 or v27.AbsoluteSize.Y <= 0) and os.clock() < v29 do
            if v27.Parent == nil then
                break
            end
            task.wait()
        end
        if v27.Parent ~= nil and v28.Parent ~= nil then
            if v27.AbsoluteSize.X <= 0 or v27.AbsoluteSize.Y <= 0 then
                v26[v27] = nil
            else
                ListLayoutFreeze.Freeze(v27, v28)
            end
        end
    end)
end

local function recenterAnchor(v30) -- line 228 | captures: ListLayoutFreeze, v2, v26
    local Parent = v30.Parent
    local v31
    if Parent == nil then
    else
        v31 = Parent:FindFirstChildWhichIsA("UIGridStyleLayout")
    end
    if v31 == nil then
        local AnchorPoint = v30.AnchorPoint
        if AnchorPoint ~= v2 then
            local Position = v30.Position
            local Size = v30.Size
            local v32 = 0.5 - AnchorPoint.X
            local v33 = 0.5 - AnchorPoint.Y
            v30.Position = UDim2.new(Position.X.Scale + Size.X.Scale * v32, Position.X.Offset + Size.X.Offset * v32, Position.Y.Scale + Size.Y.Scale * v33, Position.Y.Offset + Size.Y.Offset * v33)
            v30.AnchorPoint = v2
        end
    else
        local Parent = v30.Parent
        if not v31:IsA("UIListLayout") or Parent:IsA("ScrollingFrame") then
            v30.AnchorPoint = v2
        elseif not v26[Parent] then
            v26[Parent] = true
            local spawn = task.spawn
            local v34 = v31
            spawn(function() -- line 203 | captures: Parent, v34, ListLayoutFreeze, v26
                local v35 = os.clock() + 5
                while (Parent.AbsoluteSize.X <= 0 or Parent.AbsoluteSize.Y <= 0) and os.clock() < v35 do
                    if Parent.Parent == nil then
                        break
                    end
                    task.wait()
                end
                if Parent.Parent ~= nil and v34.Parent ~= nil then
                    if Parent.AbsoluteSize.X <= 0 or Parent.AbsoluteSize.Y <= 0 then
                        v26[Parent] = nil
                    else
                        ListLayoutFreeze.Freeze(Parent, v34)
                    end
                end
            end)
        end
    end
end

local Click = UiSounds.Click
local Hover = UiSounds.Hover

local function resolveTarget(v36) -- line 268
    local Parent = v36.Parent
    if v36:GetAttribute("ButtonTweenSelf") ~= true and (v36.Name == "Button" or v36:GetAttribute("ButtonTweenParent") == true) and Parent ~= nil and Parent:IsA("GuiObject") then
        return Parent
    end
    return v36
end

local function getTargetState(v37) -- line 283 | captures: v20, recenterAnchor
    local v38 = v20[v37]
    local v39 = v38
    if v38 == nil then
        recenterAnchor(v37)
        local v40 = {
            mouseInside = false,
            selected = false,
            pressed = false,
            watching = false,
            tween = nil
        }
        local ButtonTweenScale = v37:FindFirstChild("ButtonTweenScale")
        if ButtonTweenScale == nil or not ButtonTweenScale:IsA("UIScale") then
            ButtonTweenScale = Instance.new("UIScale")
            ButtonTweenScale.Name = "ButtonTweenScale"
            ButtonTweenScale.Scale = 1
            ButtonTweenScale.Parent = v37
        end
        v40.uiScale = ButtonTweenScale
        v39 = v40
        v20[v37] = v40
        v37.Destroying:Connect(function() -- line 297 | captures: v39, v37, v20
            if v39.tween ~= nil then
                v39.tween:Cancel()
            end
            v20[v37] = nil
        end)
    end
    return v39
end

local function scaleFor(v41, v42) -- line 308 | captures: ButtonTweenConfig
    local v43 = v41 and v41:GetAttribute(v42)
    if typeof(v43) == "number" then
        return v43
    end
    return ButtonTweenConfig[v42]
end

local function applyState(v44) -- line 316 | captures: TweenService, ButtonTweenConfig, tweenInfoFor
    local Parent = v44.uiScale.Parent
    local v45
    if v44.pressed then
        local v46 = Parent and Parent:GetAttribute("PressScale")
        if typeof(v46) == "number" then
            v45 = v46
        else
            v45 = ButtonTweenConfig.PressScale
        end
    elseif v44.mouseInside or v44.selected then
        local v47 = Parent and Parent:GetAttribute("HoverScale")
        if typeof(v47) == "number" then
            v45 = v47
        else
            v45 = ButtonTweenConfig.HoverScale
        end
    else
        v45 = 1
    end
    if v44.tween ~= nil then
        v44.tween:Cancel()
    end
    local v48 = TweenService:Create(v44.uiScale, tweenInfoFor(Parent), { Scale = v45 })
    v44.tween = v48
    v48:Play()
end

local function isMouseOver(v49) -- line 340 | captures: GuiService, UserInputService
    local v50 = v49
    while v50 ~= nil do
        if v50:IsA("ScreenGui") then
            if v50.Enabled then
                break
            end
        elseif not v50:IsA("GuiObject") or v50.Visible then
            v50 = v50.Parent
            continue
        end
        return false
    end
    if v50 == nil then
        return false
    end
    local v51 = GuiService:GetGuiInset()
    local v52 = UserInputService:GetMouseLocation() - v51
    local AbsolutePosition = v49.AbsolutePosition
    local AbsoluteSize = v49.AbsoluteSize
    local X = v52.X
    if AbsolutePosition.X <= X and v52.X <= AbsolutePosition.X + AbsoluteSize.X then
        local Y = v52.Y
        if AbsolutePosition.Y <= Y then
            return v52.Y <= AbsolutePosition.Y + AbsoluteSize.Y
        end
    end
    return false
end

local function isHoverBlocked(v53) -- line 373 | captures: CollectionService, ButtonTweenConfig, isMouseOver
    for v54, v55 in CollectionService:GetTagged(ButtonTweenConfig.HoverBlockerTag) do
        if v55:IsA("GuiObject") and v55 ~= v53 and not v53:IsDescendantOf(v55) and isMouseOver(v55) then
            return true
        end
    end
    return false
end

local function watchMouseHover(v56, v57) -- line 390 | captures: applyState, isMouseOver, isHoverBlocked
    if v57.watching then
        return
    end
    v57.watching = true
    task.spawn(function() -- line 395 | captures: v56, v57, applyState, isMouseOver, isHoverBlocked
        while v57.mouseInside do
            if v56.Parent == nil then
                break
            end
            if not isMouseOver(v56) or isHoverBlocked(v56) then
                v57.mouseInside = false
                v57.pressed = false
                applyState(v57)
                break
            end
            task.wait(0.1)
        end
        v57.watching = false
    end)
end

local function hookButton(v58) -- line 409 | captures: ButtonTweenConfig, FloatingIconFX, v21, Click, Hover, getTargetState, applyState, isMouseOver, isHoverBlocked
    if v21[v58] or not (v58:GetAttribute("NoButtonTween") ~= true) or FloatingIconFX.IsConfiguredTarget(v58) then
        return
    end
    local ScreenGui = v58:FindFirstAncestorOfClass("ScreenGui")
    local v59 = ScreenGui and ButtonTweenConfig.IgnoreScreenGuis[ScreenGui.Name]
    if v59 == true or type(v59) == "table" and not v59[v58.Name] then
        return
    end
    v21[v58] = true
    local Parent = v58.Parent
    local v60
    if v58:GetAttribute("ButtonTweenSelf") == true then
        v60 = v58
        Parent = v58
    elseif (v58.Name == "Button" or v58:GetAttribute("ButtonTweenParent") == true) and Parent ~= nil and Parent:IsA("GuiObject") then
        v60 = Parent
    else
        v60 = v58
        Parent = v58
    end
    local v61 = getTargetState(Parent)
    v58:GetAttributeChangedSignal("ButtonTweenSelf"):Connect(function() -- line 435 | captures: v60, v61, v58, getTargetState, applyState
        local v62 = v58
        local Parent = v58.Parent
        if v58:GetAttribute("ButtonTweenSelf") ~= true and (v58.Name == "Button" or v58:GetAttribute("ButtonTweenParent") == true) and Parent ~= nil and Parent:IsA("GuiObject") then
            v62 = Parent
        end
        if v62 == v60 then
            return
        end
        v61.mouseInside = false
        v61.selected = false
        v61.pressed = false
        applyState(v61)
        v60 = v62
        v61 = getTargetState(v62)
    end)
    v58.MouseEnter:Connect(function() -- line 448 | captures: v60, v61, Hover, applyState, isMouseOver, isHoverBlocked
        if isHoverBlocked(v60) then
            return
        end
        if not v61.mouseInside then
            v61.mouseInside = true
            Hover()
            applyState(v61)
        end
        local v63 = v60
        local v64 = v61
        if not v64.watching then
            v64.watching = true
            task.spawn(function() -- line 395 | captures: v63, v64, applyState, isMouseOver, isHoverBlocked
                while v64.mouseInside do
                    if v63.Parent == nil then
                        break
                    end
                    if not isMouseOver(v63) or isHoverBlocked(v63) then
                        v64.mouseInside = false
                        v64.pressed = false
                        applyState(v64)
                        break
                    end
                    task.wait(0.1)
                end
                v64.watching = false
            end)
        end
    end)
    v58.MouseLeave:Connect(function() -- line 463 | captures: v61, applyState
        v61.mouseInside = false
        v61.pressed = false
        applyState(v61)
    end)
    v58.SelectionGained:Connect(function() -- line 471 | captures: v61, Hover, applyState
        if v61.selected then
            return
        end
        v61.selected = true
        Hover()
        applyState(v61)
    end)
    v58.SelectionLost:Connect(function() -- line 479 | captures: v61, applyState
        v61.selected = false
        v61.pressed = false
        applyState(v61)
    end)
    v58.MouseButton1Down:Connect(function() -- line 485 | captures: v60, v61, applyState, isHoverBlocked
        if not isHoverBlocked(v60) then
            v61.pressed = true
            applyState(v61)
        end
    end)
    v58.MouseButton1Up:Connect(function() -- line 493 | captures: v61, applyState
        v61.pressed = false
        applyState(v61)
    end)
    v58.Activated:Connect(Click)
    v58.Destroying:Connect(function() -- line 500 | captures: v58, v21
        v21[v58] = nil
    end)
end

function v1.Start() -- line 505 | captures: LocalPlayer, hookButton
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    for v65, v66 in PlayerGui:GetDescendants() do
        if v66:IsA("GuiButton") then
            hookButton(v66)
        end
    end
    PlayerGui.DescendantAdded:Connect(function(v67) -- line 514 | captures: hookButton
        if v67:IsA("GuiButton") then
            hookButton(v67)
        end
    end)
end

return v1
