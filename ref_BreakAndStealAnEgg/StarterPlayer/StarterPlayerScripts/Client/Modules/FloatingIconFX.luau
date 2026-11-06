-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local FloatingIconConfig = require(ReplicatedStorage.Shared.FloatingIconConfig)
local UiSounds = require(script.Parent.UiSounds)
local v1 = {}
local v2 = Vector2.new(0.5, 0.5)
local v3 = {}
local v4

local function newSpring(v5, v6) -- line 130
    return {
        v = 0,
        x = v6,
        k = v5.Stiffness,
        d = v5.Damping
    }
end

local function settle(v7, v8) -- line 137
    local v9 = v7.x - v8
    local v10 = math.abs(v9) > 0.001
    local v11
    if not v10 then
        local v = v7.v
        v11 = math.abs(v) > 0.001
    end
    if v10 or v11 then
        return false
    end
    v7.x = v8
    v7.v = 0
    return true
end

local function stepSpring(v12, v13, v14) -- line 146
    local v15 = v12.k * (v13 - v12.x) - v12.d * v12.v
    v12.v += v15 * v14
    v12.x += v12.v * v14
end

local function mergeStyle(v16) -- line 152 | captures: FloatingIconConfig
    local v17 = table.clone(FloatingIconConfig.DefaultStyle)
    if v16 then
        for v18, v19 in v16 do
            v17[v18] = v19
        end
    end
    return v17
end

local function recenterAnchor(v20) -- line 164 | captures: v2
    local AnchorPoint = v20.AnchorPoint
    if AnchorPoint == v2 then
        return
    end
    local Position = v20.Position
    local Size = v20.Size
    local v21 = 0.5 - AnchorPoint.X
    local v22 = 0.5 - AnchorPoint.Y
    v20.Position = UDim2.new(Position.X.Scale + Size.X.Scale * v21, Position.X.Offset + Size.X.Offset * v21, Position.Y.Scale + Size.Y.Scale * v22, Position.Y.Offset + Size.Y.Offset * v22)
    v20.AnchorPoint = v2
end

local function centeredPosition(v23) -- line 184
    local Size = v23.Size
    local AnchorPoint = v23.AnchorPoint
    return UDim2.new((1 - Size.X.Scale) / 2 + AnchorPoint.X * Size.X.Scale, -Size.X.Offset / 2 + AnchorPoint.X * Size.X.Offset, (1 - Size.Y.Scale) / 2 + AnchorPoint.Y * Size.Y.Scale, -Size.Y.Offset / 2 + AnchorPoint.Y * Size.Y.Offset)
end

local function scaleUDim2(v24, v25) -- line 195
    return UDim2.new(v24.X.Scale * v25, v24.X.Offset * v25, v24.Y.Scale * v25, v24.Y.Offset * v25)
end

local function getOrCreateScale(v26) -- line 204
    local FloatingIconScale = v26:FindFirstChild("FloatingIconScale")
    if FloatingIconScale and FloatingIconScale:IsA("UIScale") then
        return FloatingIconScale
    end
    local UIScale = Instance.new("UIScale")
    UIScale.Name = "FloatingIconScale"
    UIScale.Scale = 1
    UIScale.Parent = v26
    return UIScale
end

local function isOnScreen(v27) -- line 217
    local v28 = v27
    while true do
        if v28 then
            if v28:IsA("GuiObject") then
                if v28.Visible then
                    v28 = v28.Parent
                    continue
                end
                return false
            end
            if v28:IsA("LayerCollector") then
                break
            end
            v28 = v28.Parent
            continue
        end
        return false
    end
    return v28.Enabled and v28:IsDescendantOf(game)
end

local function isPointOver(v29, v30) -- line 234
    local AbsolutePosition = v29.AbsolutePosition
    local AbsoluteSize = v29.AbsoluteSize
    local X = v30.X
    if AbsolutePosition.X <= X and v30.X <= AbsolutePosition.X + AbsoluteSize.X then
        local Y = v30.Y
        if AbsolutePosition.Y <= Y then
            return v30.Y <= AbsolutePosition.Y + AbsoluteSize.Y
        end
    end
    return false
end

local function isMouseOver(v31) -- line 240 | captures: GuiService, UserInputService
    local v32 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
    local AbsolutePosition = v31.AbsolutePosition
    local AbsoluteSize = v31.AbsoluteSize
    local X = v32.X
    if AbsolutePosition.X <= X and v32.X <= AbsolutePosition.X + AbsoluteSize.X then
        local Y = v32.Y
        if AbsolutePosition.Y <= Y then
            return v32.Y <= AbsolutePosition.Y + AbsoluteSize.Y
        end
    end
    return false
end

local function isInputOver(v33, v34) -- line 247 | captures: GuiService, UserInputService
    if v34.UserInputType == Enum.UserInputType.Touch then
        local Position = v34.Position
        local v35 = Vector2.new(Position.X, Position.Y)
        local AbsolutePosition = v33.AbsolutePosition
        local AbsoluteSize = v33.AbsoluteSize
        local X = v35.X
        if AbsolutePosition.X <= X and v35.X <= AbsolutePosition.X + AbsoluteSize.X then
            local Y = v35.Y
            if AbsolutePosition.Y <= Y then
                return v35.Y <= AbsolutePosition.Y + AbsoluteSize.Y
            end
        end
        return false
    end
    local v36 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
    local AbsolutePosition = v33.AbsolutePosition
    local AbsoluteSize = v33.AbsoluteSize
    local X = v36.X
    if AbsolutePosition.X <= X and v36.X <= AbsolutePosition.X + AbsoluteSize.X then
        local Y = v36.Y
        if AbsolutePosition.Y <= Y then
            return v36.Y <= AbsolutePosition.Y + AbsoluteSize.Y
        end
    end
    return false
end

local function isPointerPress(v37) -- line 255
    if v37.UserInputType == Enum.UserInputType.MouseButton1 then
        return true
    end
    return v37.UserInputType == Enum.UserInputType.Touch
end

local function clearInput(v38) -- line 263
    v38.mouseInside = false
    v38.selected = false
    v38.pressed = false
end

local function update(v39, v40) -- line 269 | captures: GuiService, UserInputService, isOnScreen
    local style = v39.style
    local button = v39.button
    local v41
    if v39.pulseStart then
        local v42 = (os.clock() - v39.pulseStart) / style.PulseTime
        if v42 < 1 then
            local v43 = 3.141592653589793 * v42
            v41 = math.sin(v43)
        else
            v39.pulseStart = nil
            v41 = 0
        end
    else
        v41 = 0
    end
    local v44 = v39.pulseStart ~= nil
    if v39.resting then
        if not (v39.mouseInside or v39.selected or v39.pressed or v44) then
            v39.sinceVisibilityCheck += v40
            if v39.sinceVisibilityCheck >= 0.2 then
                v39.sinceVisibilityCheck = 0
                v39.onScreen = isOnScreen(button)
            end
            return
        end
        v39.resting = false
    end
    local onScreen = v39.onScreen
    local onScreen_2, v45
    if onScreen then
        v45 = isOnScreen(button)
    else
        v39.sinceVisibilityCheck += v40
        if v39.sinceVisibilityCheck < 0.2 then
            return
        end
        v39.sinceVisibilityCheck = 0
        v39.onScreen = isOnScreen(button)
        onScreen_2 = v39.onScreen
    end
    if onScreen and v45 or not onScreen and onScreen_2 then
        local v46, v47
        if v39.mouseInside then
            v39.sinceHoverCheck += v40
            if v39.sinceHoverCheck >= 0.1 then
                v39.sinceHoverCheck = 0
                local input = v39.input
                local v48 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
                local AbsolutePosition = input.AbsolutePosition
                local AbsoluteSize = input.AbsoluteSize
                local X = v48.X
                if AbsolutePosition.X <= X and v48.X <= AbsolutePosition.X + AbsoluteSize.X then
                    local Y = v48.Y
                    if AbsolutePosition.Y <= Y then
                        v46 = v48.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                    else
                        v46 = false
                    end
                else
                    v46 = false
                end
                v47 = false
            else
                v47 = true
            end
        else
            v47 = true
        end
        if not v47 and not v46 then
            v39.mouseInside = false
            v39.pressed = false
        end
        local v49 = v39.mouseInside or v39.selected
        if v49 then
            v41 = 1
        end
        local v50 = if v39.pressed then style.PressScale else 1 + (style.HoverScale - 1) * v41
        local v51 = if v39.pressed then style.PressTilt else style.HoverTilt * v41
        local v52 = style.HoverLift * v41
        local v53 = 1 + (style.HoverFloatAmount - 1) * v41
        local v54 = if v39.pressed then style.PressLayerDepth else 1 + (style.HoverLayerDepth - 1) * v41
        local v55 = math.min(v40, 0.06666666666666667)
        while v55 > 0 do
            local v56 = math.min(v55, 0.008333333333333333)
            local scale = v39.scale
            local v57 = scale.k * (v50 - scale.x) - scale.d * scale.v
            scale.v += v57 * v56
            scale.x += scale.v * v56
            local tilt = v39.tilt
            local v58 = tilt.k * (v51 - tilt.x) - tilt.d * tilt.v
            tilt.v += v58 * v56
            tilt.x += tilt.v * v56
            local lift = v39.lift
            local v59 = lift.k * (v52 - lift.x) - lift.d * lift.v
            lift.v += v59 * v56
            lift.x += lift.v * v56
            local blend = v39.blend
            local v60 = blend.k * (v53 - blend.x) - blend.d * blend.v
            blend.v += v60 * v56
            blend.x += blend.v * v56
            local depth = v39.depth
            local v61 = depth.k * (v54 - depth.x) - depth.d * depth.v
            depth.v += v61 * v56
            depth.x += depth.v * v56
            v55 -= v56
        end
        local still = v39.still and not v49 and not v39.pressed and not v44
        local v62
        if still then
            local scale = v39.scale
            local v63 = scale.x - v50
            local v64
            if math.abs(v63) > 0.001 then
                v64 = false
            else
                local v = scale.v
                if math.abs(v) > 0.001 then
                    v64 = false
                else
                    scale.x = v50
                    scale.v = 0
                    v64 = true
                end
            end
            local tilt = v39.tilt
            local v65 = tilt.x - v51
            local v66 = math.abs(v65) > 0.001
            local v67
            if not v66 then
                local v = tilt.v
                v67 = math.abs(v) > 0.001
            end
            local v68
            if v66 or v67 then
                v68 = false
            else
                tilt.x = v51
                tilt.v = 0
                v68 = true
            end
            local lift = v39.lift
            local v69 = lift.x - v52
            local v70 = math.abs(v69) > 0.001
            local v71
            if not v70 then
                local v = lift.v
                v71 = math.abs(v) > 0.001
            end
            local v72
            if v70 or v71 then
                v72 = false
            else
                lift.x = v52
                lift.v = 0
                v72 = true
            end
            local depth = v39.depth
            local v73 = depth.x - v54
            local v74 = math.abs(v73) > 0.001
            local v75
            if not v74 then
                local v = depth.v
                v75 = math.abs(v) > 0.001
            end
            local v76
            if v74 or v75 then
                v76 = false
            else
                depth.x = v54
                depth.v = 0
                v76 = true
            end
            v62 = v64 and v68 and v72 and v76
        else
            v62 = still
        end
        v39.clock += v40
        local x = v39.blend.x
        local v77 = v39.clock * 6.283185307179586 / style.FloatPeriod
        local v78 = math.sin(v77) * x
        local v79 = v39.clock * 6.283185307179586 / style.SwayPeriod
        local v80 = math.sin(v79) * x
        local Scale = v39.uiScale.Scale
        local v81 = if Scale > 0 then button.AbsoluteSize.Y / Scale else 0
        local uiScale = v39.uiScale
        local v82 = v39.scale.x * (1 + style.BreathScale * v78)
        uiScale.Scale = math.max(v82, 0.01)
        button.Rotation = v39.tilt.x + style.SwayDegrees * v80
        button.Position = v39.basePosition + UDim2.fromOffset(0, -(v39.lift.x + style.FloatHeight * v78) * v81)
        local layer = v39.layer
        if layer then
            local layerCentered = v39.layerCentered
            local layerOffset = v39.layerOffset
            local x = v39.depth.x
            local v83 = math.max(x, 0)
            layer.Position = layerCentered + UDim2.new(layerOffset.X.Scale * v83, layerOffset.X.Offset * v83, layerOffset.Y.Scale * v83, layerOffset.Y.Offset * v83)
        end
        v39.resting = v62
    elseif onScreen then
        v39.onScreen = false
        v39.mouseInside = false
        v39.selected = false
        v39.pressed = false
    end
end

local function ensureHeartbeat() -- line 389 | captures: v4, RunService, v3, update
    v4 = v4 or
    RunService.RenderStepped:Connect(function(v84) -- line 396 | captures: v4, v3, update
        for v85, v86 in v3 do
            update(v86, v84)
        end
        if next(v3) == nil and v4 then
            v4:Disconnect()
            v4 = nil
        end
    end)
end

function v1.Detach(v87) -- line 412 | captures: v3
    local v88 = v3[v87]
    if not v88 then
        return
    end
    v3[v87] = nil
    for v89, v90 in v88.connections do
        v90:Disconnect()
    end
    if not v87.Parent then
        return
    end
    v87.Position = v88.basePosition
    v87.Rotation = 0
    v88.uiScale.Scale = 1
    if v88.layer then
        v88.layer.Position = v88.layerCentered + v88.layerOffset
    end
end

function v1.Attach(v91, v92, v93) -- line 431 | captures: v4, GuiService, RunService, UserInputService, FloatingIconConfig, UiSounds, v1, v3, recenterAnchor, centeredPosition, update
    local function v94(v95, ...)
        table.insert(v95, ...)
    end

    local function v96(v97, ...)
        table.insert(v97, ...)
    end

    local function v98(v99, ...)
        table.insert(v99, ...)
    end

    local function v100(v101, ...)
        table.insert(v101, ...)
    end

    local function v102(v103, ...)
        table.insert(v103, ...)
    end

    local function v104(v105, ...)
        table.insert(v105, ...)
    end

    local function v106(v107, ...)
        table.insert(v107, ...)
    end

    local function v108(v109, ...)
        table.insert(v109, ...)
    end

    local function v110(v111, ...)
        table.insert(v111, ...)
    end

    if not v3[v91] then
        local v112
        if v93 then
            v112 = v93
        elseif v91:IsA("GuiButton") then
            v112 = v91
        end
        if v112 then
            local v113 = table.clone(FloatingIconConfig.DefaultStyle)
            if v92 then
                for v114, v115 in v92 do
                    v113[v114] = v115
                end
            end
            recenterAnchor(v91)
            local LayerName = v113.LayerName
            local v116
            if LayerName then
                v116 = v91:FindFirstChild(LayerName)
            end
            if not (v116 and v116:IsA("GuiObject")) then
                v116 = nil
            end
            local v117, v118
            if v116 then
                v117 = centeredPosition(v116)
                v118 = v116.Position - v117
                v116.Active = false
            else
                v117 = UDim2.new()
                v118 = UDim2.new()
            end
            local v119 = {
                onScreen = false,
                sinceHoverCheck = 0,
                mouseInside = false,
                selected = false,
                pressed = false,
                kickSign = 1,
                lastHoverSound = 0,
                lastClick = 0,
                resting = false,
                pulseStart = nil,
                button = v91,
                input = v112,
                style = v113
            }
            local FloatingIconScale = v91:FindFirstChild("FloatingIconScale")
            if not (FloatingIconScale and FloatingIconScale:IsA("UIScale")) then
                FloatingIconScale = Instance.new("UIScale")
                FloatingIconScale.Name = "FloatingIconScale"
                FloatingIconScale.Scale = 1
                FloatingIconScale.Parent = v91
            end
            v119.uiScale = FloatingIconScale
            v119.basePosition = v91.Position
            v119.clock = math.random() * v113.SwayPeriod
            v119.sinceVisibilityCheck = math.random() * 0.2
            local ScaleSpring = v113.ScaleSpring
            v119.scale = {
                x = 1,
                v = 0,
                k = ScaleSpring.Stiffness,
                d = ScaleSpring.Damping
            }
            local TiltSpring = v113.TiltSpring
            v119.tilt = {
                x = 0,
                v = 0,
                k = TiltSpring.Stiffness,
                d = TiltSpring.Damping
            }
            local LiftSpring = v113.LiftSpring
            v119.lift = {
                x = 0,
                v = 0,
                k = LiftSpring.Stiffness,
                d = LiftSpring.Damping
            }
            local FloatBlendSpring = v113.FloatBlendSpring
            v119.blend = {
                x = 1,
                v = 0,
                k = FloatBlendSpring.Stiffness,
                d = FloatBlendSpring.Damping
            }
            local LayerSpring = v113.LayerSpring
            v119.depth = {
                x = 1,
                v = 0,
                k = LayerSpring.Stiffness,
                d = LayerSpring.Damping
            }
            v119.layer = v116
            v119.layerCentered = v117
            v119.layerOffset = v118
            local v120 = if v113.FloatHeight == 0 and v113.SwayDegrees == 0 then v113.BreathScale == 0 else false
            v119.still = v120
            v119.connections = {}
            v3[v91] = v119

            local function connect(v121, v122) -- line 488 | captures: v119
                local function v123(v124, ...)
                    table.insert(v124, ...)
                end

                v123(v119.connections, v121:Connect(v122))
            end

            local function playHoverSound() -- line 493 | captures: v113, v119, UiSounds
                local v125 = os.clock()
                if v113.HoverSound and v125 - v119.lastHoverSound >= 0.08 then
                    v119.lastHoverSound = v125
                    UiSounds.Play(v113.HoverSound)
                end
            end

            local MouseEnter = v112.MouseEnter

            local function v126() -- line 501 | captures: v113, v119, UiSounds
                if v119.mouseInside then
                    return
                end
                v119.mouseInside = true
                v119.sinceHoverCheck = 0
                local v127 = os.clock()
                if v113.HoverSound and v127 - v119.lastHoverSound >= 0.08 then
                    v119.lastHoverSound = v127
                    UiSounds.Play(v113.HoverSound)
                end
            end

            v94(v119.connections, MouseEnter:Connect(v126))
            local MouseLeave = v112.MouseLeave

            local function v128() -- line 509 | captures: v119
                v119.mouseInside = false
                v119.pressed = false
            end

            v96(v119.connections, MouseLeave:Connect(v128))
            local SelectionGained = v112.SelectionGained

            local function v129() -- line 515 | captures: v113, v119, UiSounds
                if v119.selected then
                    return
                end
                v119.selected = true
                local v130 = os.clock()
                if v113.HoverSound and v130 - v119.lastHoverSound >= 0.08 then
                    v119.lastHoverSound = v130
                    UiSounds.Play(v113.HoverSound)
                end
            end

            v98(v119.connections, SelectionGained:Connect(v129))
            local SelectionLost = v112.SelectionLost

            local function v131() -- line 522 | captures: v119
                v119.selected = false
                v119.pressed = false
            end

            v100(v119.connections, SelectionLost:Connect(v131))

            local function click() -- line 531 | captures: v113, v119, UiSounds
                v119.pressed = false
                local v132 = os.clock()
                if v132 - v119.lastClick < 0.1 then
                    return
                end
                v119.lastClick = v132
                v119.resting = false
                local scale = v119.scale
                scale.v += v113.ClickScaleKick
                local tilt = v119.tilt
                tilt.v += v113.ClickTiltKick * v119.kickSign
                v119.kickSign = -v119.kickSign
                if v113.ClickSound then
                    UiSounds.Play(v113.ClickSound)
                end
            end

            local InputBegan = UserInputService.InputBegan

            local function v133(v134) -- line 552 | captures: v119, GuiService, UserInputService
                if not (v119.onScreen and (v134.UserInputType == Enum.UserInputType.MouseButton1 or v134.UserInputType == Enum.UserInputType.Touch)) then
                    return
                end
                local input = v119.input
                local v135
                if v134.UserInputType == Enum.UserInputType.Touch then
                    local Position = v134.Position
                    local v136 = Vector2.new(Position.X, Position.Y)
                    local AbsolutePosition = input.AbsolutePosition
                    local AbsoluteSize = input.AbsoluteSize
                    local X = v136.X
                    if AbsolutePosition.X <= X and v136.X <= AbsolutePosition.X + AbsoluteSize.X then
                        local Y = v136.Y
                        if AbsolutePosition.Y <= Y then
                            v135 = v136.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                        else
                            v135 = false
                        end
                    else
                        v135 = false
                    end
                else
                    local v137 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
                    local AbsolutePosition = input.AbsolutePosition
                    local AbsoluteSize = input.AbsoluteSize
                    local X = v137.X
                    if AbsolutePosition.X <= X and v137.X <= AbsolutePosition.X + AbsoluteSize.X then
                        local Y = v137.Y
                        if AbsolutePosition.Y <= Y then
                            v135 = v137.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                        else
                            v135 = false
                        end
                    else
                        v135 = false
                    end
                end
                if v135 then
                    v119.pressed = true
                end
            end

            v102(v119.connections, InputBegan:Connect(v133))
            local InputEnded = UserInputService.InputEnded

            local function v138(v139) -- line 558 | captures: v119, click, GuiService, UserInputService
                if not (v119.pressed and (v139.UserInputType == Enum.UserInputType.MouseButton1 or v139.UserInputType == Enum.UserInputType.Touch)) then
                    return
                end
                v119.pressed = false
                if v119.onScreen then
                    local input = v119.input
                    if v139.UserInputType == Enum.UserInputType.Touch then
                        local Position = v139.Position
                        local v140 = Vector2.new(Position.X, Position.Y)
                        local AbsolutePosition = input.AbsolutePosition
                        local AbsoluteSize = input.AbsoluteSize
                        local X = v140.X
                        if AbsolutePosition.X <= X and v140.X <= AbsolutePosition.X + AbsoluteSize.X then
                            local Y = v140.Y
                            if AbsolutePosition.Y <= Y and v140.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
                                click()
                            end
                        end
                    else
                        local v141 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
                        local AbsolutePosition = input.AbsolutePosition
                        local AbsoluteSize = input.AbsoluteSize
                        local X = v141.X
                        if AbsolutePosition.X <= X and v141.X <= AbsolutePosition.X + AbsoluteSize.X then
                            local Y = v141.Y
                            if AbsolutePosition.Y <= Y and v141.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
                                click()
                            end
                        end
                    end
                end
            end

            v104(v119.connections, InputEnded:Connect(v138))
            local Activated = v112.Activated
            v106(v119.connections, Activated:Connect(click))
            local Destroying = v91.Destroying

            local function v142() -- line 572 | captures: v91, v1
                v1.Detach(v91)
            end

            v108(v119.connections, Destroying:Connect(v142))
            if v112 ~= v91 then
                local Destroying = v112.Destroying

                local function v143() -- line 576 | captures: v91, v1
                    v1.Detach(v91)
                end

                v110(v119.connections, Destroying:Connect(v143))
            end
            v4 = v4 or
            RunService.RenderStepped:Connect(function(v144) -- line 396 | captures: v4, v3, update
                for v145, v146 in v3 do
                    update(v146, v144)
                end
                if next(v3) == nil and v4 then
                    v4:Disconnect()
                    v4 = nil
                end
            end)
        end
    end
end

function v1.Pulse(v147) -- line 588 | captures: v3
    local v148 = v3[v147]
    if not v148 then
        return
    end
    local v149 = os.clock()
    local PulseTime = v148.style.PulseTime
    local pulseStart = v148.pulseStart
    local v150 = if pulseStart then (v149 - pulseStart) / PulseTime else 1
    if not (v150 > 0.5 and v150 < 1) then
        if v150 >= 1 then
            v148.pulseStart = v149
        end
    else
        local v151 = 3.141592653589793 * v150
        local v152 = math.sin(v151)
        v148.pulseStart = v149 - math.asin(v152) / 3.141592653589793 * PulseTime
    end
    v148.resting = false
end

function v1.ResetCopy(v153, v154) -- line 609 | captures: v3
    local v155 = v3[v153]
    if not v155 then
        return
    end
    v154.Position = v155.basePosition
    v154.Rotation = 0
    local FloatingIconScale = v154:FindFirstChild("FloatingIconScale")
    if FloatingIconScale and FloatingIconScale:IsA("UIScale") then
        FloatingIconScale.Scale = 1
    end
    local layer = v155.layer
    local v156 = layer and v154:FindFirstChild(layer.Name)
    if v156 and v156:IsA("GuiObject") then
        v156.Position = v155.layerCentered + v155.layerOffset
    end
end

function v1.IsConfiguredTarget(v157) -- line 628 | captures: FloatingIconConfig
    for v158, v159 in FloatingIconConfig.Targets do
        local Path = v159.Path
        local v160 = #Path
        local v161 = v157
        local v162 = true
        for v163 = v160, 1, -1 do
            if v161 then
                if v161.Name ~= Path[v163] then
                    v162 = false
                    break
                end
            else
                v162 = false
                break
            end
            v161 = v161.Parent
            v162 = true
        end
        if v162 and v161 and v161.Name == "MainGUI" and v161:IsA("ScreenGui") then
            return true
        end
    end
    return false
end

return v1
