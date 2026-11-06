-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local ButtonTweenConfig = require(ReplicatedStorage.Shared.ButtonTweenConfig)
local RichWordTyper = require(script.Parent.RichWordTyper)
local v1 = {}
local v2 = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local PanelHoverScale = AdminConfig.PanelHoverScale
local PanelPressScale = AdminConfig.PanelPressScale
local v6 = {
    Client = Color3.fromRGB(255, 60, 60),
    Server = Color3.fromRGB(0, 255, 0),
    Global = Color3.fromRGB(0, 170, 255)
}
local v7 = Color3.new(1, 1, 1)

local function evalSequence(v8, v9) -- line 120
    local Keypoints = v8.Keypoints
    local v10 = #Keypoints - 1
    for v11 = 1, v10 do
        local v12 = Keypoints[v11]
        local v13 = Keypoints[v11 + 1]
        if v9 <= v13.Time then
            local v14 = v13.Time - v12.Time
            if v14 > 0 then
                return (v12.Value:Lerp(v13.Value, (v9 - v12.Time) / v14))
            end
            return v13.Value
        end
    end
    return Keypoints[#Keypoints].Value
end

local function optionColor(v15, v16) -- line 134 | captures: v6, v7, evalSequence
    local UIGradient = v16:FindFirstChildWhichIsA("UIGradient")
    if UIGradient then
        local v17 = evalSequence(UIGradient.Color, 0.5)
        local BackgroundColor3 = v16.BackgroundColor3
        local v18 = Color3.new(v17.R * BackgroundColor3.R, v17.G * BackgroundColor3.G, v17.B * BackgroundColor3.B)
        local v19, v20, v21 = v18:ToHSV()
        if v20 >= 0.25 and v21 >= 0.3 then
            local v22 = v18:ToHSV()
            return Color3.fromHSV(v22, v20, 1)
        end
    end
    return v6[v15] or v7
end

local function unrollTimeFor(v23) -- line 152
    return 1 - (1 - math.clamp(v23, 0, 1)) ^ 0.2
end

local function reanchor(v24, v25) -- line 157
    local AnchorPoint = v24.AnchorPoint
    if AnchorPoint == v25 then
        return
    end
    local Size = v24.Size
    local Position = v24.Position
    local v26 = v25.X - AnchorPoint.X
    local v27 = v25.Y - AnchorPoint.Y
    v24.AnchorPoint = v25
    v24.Position = UDim2.new(Position.X.Scale + Size.X.Scale * v26, Position.X.Offset + Size.X.Offset * v26, Position.Y.Scale + Size.Y.Scale * v27, Position.Y.Offset + Size.Y.Offset * v27)
end

local function offsetBy(v28, v29, v30) -- line 175
    return UDim2.new(v28.X.Scale, v28.X.Offset + v29, v28.Y.Scale, v28.Y.Offset + v30)
end

local function toGuiSpace(v31, v32) -- line 182 | captures: GuiService
    local ScreenGui = v31:FindFirstAncestorWhichIsA("ScreenGui")
    if not (ScreenGui and ScreenGui.IgnoreGuiInset) then
        return v32
    end
    return v32 + GuiService:GetGuiInset()
end

local function isOver(v33, v34) -- line 190
    local AbsolutePosition = v33.AbsolutePosition
    local v35 = AbsolutePosition + v33.AbsoluteSize
    local X = v34.X
    if AbsolutePosition.X <= X and v34.X <= v35.X then
        local Y = v34.Y
        if AbsolutePosition.Y <= Y then
            return v34.Y <= v35.Y
        end
    end
    return false
end

function v1.Bind(v36, v37, v38, v39) -- line 208 | captures: CollectionService, GuiService, RunService, TweenService, UserInputService, ButtonTweenConfig, RichWordTyper, v2, v3, v4, v5, PanelHoverScale, PanelPressScale, v6, v7, optionColor, reanchor
    local function v40(v41, ...)
        table.insert(v41, ...)
    end

    local function v42(v43, ...)
        table.insert(v43, ...)
    end

    local function v44(v45, ...)
        table.insert(v45, ...)
    end

    local function v46(v47, ...)
        table.insert(v47, ...)
    end

    local v48
    if not (v39 and v39.Toggle) then
        v48 = v36:FindFirstChild("Edit")
    else
        v48 = v39.Toggle
    end
    local v49
    if not (v39 and v39.List) then
        v49 = v36:FindFirstChild("EditList")
    else
        v49 = v39.List
    end
    local v50
    if v48 and v48:IsA("GuiButton") and v49 and v49:IsA("GuiObject") then
        if v49:IsA("ScrollingFrame") then
            v50 = v49
        end
    else
        return nil
    end
    local v51
    if not v39 or v39.Setting == nil then
        v51 = v36:FindFirstChild("Setting")
    else
        local Setting = v39.Setting
        if typeof(Setting) == "Instance" then
            v51 = v39.Setting
        end
    end
    local v52
    if not (v51 and v51:IsA("TextLabel")) then
    else
        v52 = RichWordTyper.new(v51)
    end
    local v53 = if v39 == nil then false else v39.Direction == "Up"
    local new = Vector2.new
    local v54 = if v53 then 1 else 0
    reanchor(v49, new(0.5, v54))
    local Position = v49.Position
    local Size = v49.Size
    local v55 = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0)
    local v56, CanvasSize
    if v50 then
        CanvasSize = v50.CanvasSize
        v56 = v50.ScrollBarThickness
    else
        v56 = 0
    end
    local Icon = v48:FindFirstChild("Icon")
    if not (Icon and Icon:IsA("GuiObject")) then
        Icon = nil
    end
    local v57 = if Icon then Icon.Rotation else 0
    local v58 = {}
    for v59, v60 in v49:GetChildren() do
        local Button = v60:FindFirstChild("Button")
        if v60.Name ~= "Template" and v60:IsA("GuiObject") and Button and Button:IsA("GuiButton") then
            local v61 = {
                Frame = v60,
                Button = Button,
                Size = v60.Size
            }
            table.insert(v58, v61)
            Button:SetAttribute("HoverScale", PanelHoverScale)
            Button:SetAttribute("PressScale", PanelPressScale)
            Button:SetAttribute("ButtonTweenSelf", true)
            v60:SetAttribute("HoverScale", nil)
            v60:SetAttribute("PressScale", nil)
        end
    end
    table.sort(v58, function(v62, v63) -- line 263
        if v62.Frame.LayoutOrder == v63.Frame.LayoutOrder then
            return v62.Frame.Name < v63.Frame.Name
        end
        return v62.Frame.LayoutOrder < v63.Frame.LayoutOrder
    end)
    local v64 = v37
    local v65 = false
    local v66 = 0
    local v67 = {}
    local v68 = {}

    local function cancelTweens() -- line 276 | captures: v67
        for v69, v70 in v67 do
            v70:Cancel()
        end
        table.clear(v67)
    end

    local function play(v71, v72, v73) -- line 283 | captures: v67, TweenService
        local v74 = TweenService:Create(v71, v72, v73)
        v74:Play()
        table.insert(v67, v74)
    end

    local function captureRowRests() -- line 289 | captures: v58
        for v75, v76 in v58 do
            if v76.Rest == nil then
                v76.Rest = v76.Button.Position
            end
        end
    end

    local v77 = false
    local v78 = v50
    local CanvasSize_2 = CanvasSize

    local function pinRows() -- line 302 | captures: v77, v58, v78, CanvasSize_2
        if v77 then
            return
        end
        v77 = true
        for v79, v80 in v58 do
            local Y = v80.Frame.AbsoluteSize.Y
            local Size = v80.Size
            v80.Frame.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, Y)
        end
        if v78 and CanvasSize_2 then
            v78.CanvasSize = UDim2.new(CanvasSize_2.X.Scale, CanvasSize_2.X.Offset, 0, v78.AbsoluteCanvasSize.Y)
            v78.ScrollBarThickness = 0
        end
    end

    local v81 = v56

    local function unpinRows() -- line 318 | captures: v77, v58, v78, CanvasSize_2, v81
        v77 = false
        for v82, v83 in v58 do
            v83.Frame.Size = v83.Size
        end
        if v78 and CanvasSize_2 then
            v78.CanvasSize = CanvasSize_2
            v78.ScrollBarThickness = v81
        end
    end

    local v84
    local v85 = 0

    local function stopKeeper() -- line 335 | captures: v84, v78
        if v84 then
            v84:Disconnect()
            v84 = nil
        end
        if v78 then
            v78.CanvasPosition = Vector2.zero
        end
    end

    local v86 = v53

    local function startKeeper(v87) -- line 344 | captures: v84, v85, v78, v86, RunService
        v85 = v87
        if v84 or not v86 or not v78 then
            return
        end
        v84 = RunService.RenderStepped:Connect(function() -- line 350 | captures: v85, v78
            local Parent = v78.Parent
            local v88 = if not (Parent and Parent:IsA("GuiObject")) then 0 else Parent.AbsoluteSize.Y
            local Size = v78.Size
            local v89 = Size.Y.Scale * v88 + Size.Y.Offset
            local new = Vector2.new
            local v90 = v85 - v89
            v78.CanvasPosition = new(0, (math.max(v90, 0)))
        end)
    end

    local v91 = {}
    for v92, v93 in v58 do
        v91[v93.Frame.Name] = optionColor(v93.Frame.Name, v93.Button)
    end
    local v94 = v52

    local function showValue(v95) -- line 366 | captures: v64, v91, v94, v6, v7
        if not v94 then
            return
        end
        local v96 = v91[v64] or v6[v64] or v7
        v94:Set(v64, v96, v95)
    end

    local v97 = v49
    local Icon_2 = Icon
    local v98 = v57

    local function resetClosed() -- line 374 | captures: v77, v84, Position, Size, v58, v67, v78, CanvasSize_2, v81, v97, Icon_2, v98, CollectionService, ButtonTweenConfig
        for v99, v100 in v67 do
            v100:Cancel()
        end
        table.clear(v67)
        v97.Visible = false
        v97.Position = Position
        v97.Size = Size
        if v84 then
            v84:Disconnect()
            v84 = nil
        end
        if v78 then
            v78.CanvasPosition = Vector2.zero
        end
        v77 = false
        for v101, v102 in v58 do
            v102.Frame.Size = v102.Size
        end
        if v78 and CanvasSize_2 then
            v78.CanvasSize = CanvasSize_2
            v78.ScrollBarThickness = v81
        end
        if v78 then
            v78.CanvasPosition = Vector2.zero
        end
        for v103, v104 in v58 do
            v104.Button.Visible = true
            if v104.Rest then
                v104.Button.Position = v104.Rest
            end
        end
        if Icon_2 then
            Icon_2.Rotation = v98
        end
        CollectionService:RemoveTag(v97, ButtonTweenConfig.HoverBlockerTag)
    end

    local v105 = {}

    function v105.IsOpen() -- line 398 | captures: v65
        return v65
    end

    function v105.GetValue() -- line 402 | captures: v64
        return v64
    end

    function v105.SetValue(v106) -- line 406 | captures: v64, v91, v94, v6, v7
        v64 = v106
        if not v94 then
            return
        end
        local v107 = v91[v64] or v6[v64] or v7
        v94:Set(v64, v107, nil)
    end

    function v105.Open() -- line 411 | captures: v65, v66, v77, v84, v85, Position, Size, v55, v58, v67, pinRows, v78, CanvasSize_2, v81, v86, v97, Icon_2, v98, CollectionService, RunService, TweenService, ButtonTweenConfig, v2, v3, v4
        if v65 then
            return
        end
        v65 = true
        v66 += 1
        local v108 = v66
        for v109, v110 in v67 do
            v110:Cancel()
        end
        table.clear(v67)
        for v111, v112 in v58 do
            if v112.Rest == nil then
                v112.Rest = v112.Button.Position
            end
        end
        v97.Size = Size
        local Y = v97.AbsoluteSize.Y
        local v113 = math.max(Y, 1)
        local Y_2 = v97.AbsolutePosition.Y
        local v114 = if v78 then v78.CanvasPosition.Y else 0
        pinRows()
        if v78 then
            v78.CanvasPosition = Vector2.zero
        end
        local v115 = {}
        for v116, v117 in v58 do
            local v118 = v117.Frame.AbsolutePosition.Y - Y_2 + v114
            local Y = v117.Frame.AbsoluteSize.Y
            local v119
            if v113 <= v118 then
                v119 = 1
            elseif v86 then
                v119 = 1 - (v118 + Y * 0.7) / v113
            else
                v119 = (v118 + Y * 0.3) / v113
            end
            v115[v116] = (1 - (1 - math.clamp(v119, 0, 1)) ^ 0.2) * 0.7
        end
        local v120 = {}
        for v121 in v58 do
            table.insert(v120, v121)
        end
        table.sort(v120, function(v122, v123) -- line 455 | captures: v115, v86
            if v115[v122] == v115[v123] then
                if v86 then
                    return v123 < v122
                end
                return v122 < v123
            end
            return v115[v122] < v115[v123]
        end)
        local v124 = {}
        local v125 = (-1/0)
        for v126, v127 in v120 do
            local v128 = v115[v127]
            local v129 = v125 + 0.08
            v125 = math.max(v128, v129)
            v124[v127] = v125
        end
        local v130 = if v86 then 16 else -16
        for v131, v132 in v58 do
            v132.Button.Visible = false
            local Button = v132.Button
            local Rest = v132.Rest
            Button.Position = UDim2.new(Rest.X.Scale, Rest.X.Offset + 0, Rest.Y.Scale, Rest.Y.Offset + v130)
        end
        v97.Size = v55
        v97.Position = Position
        v85 = v113
        if not v84 and v86 and v78 then
            v84 = RunService.RenderStepped:Connect(function() -- line 350 | captures: v85, v78
                local Parent = v78.Parent
                local v133 = if not (Parent and Parent:IsA("GuiObject")) then 0 else Parent.AbsoluteSize.Y
                local Size = v78.Size
                local v134 = Size.Y.Scale * v133 + Size.Y.Offset
                local new = Vector2.new
                local v135 = v85 - v134
                v78.CanvasPosition = new(0, (math.max(v135, 0)))
            end)
        end
        v97.Visible = true
        CollectionService:AddTag(v97, ButtonTweenConfig.HoverBlockerTag)
        local v136 = { Size = Size }
        local v137 = TweenService:Create(v97, v2, v136)
        v137:Play()
        table.insert(v67, v137)
        if Icon_2 then
            local v138 = { Rotation = v98 + -14 }
            local v139 = TweenService:Create(Icon_2, v4, v138)
            v139:Play()
            table.insert(v67, v139)
        end
        for v140, v141 in v58 do
            local delay = task.delay
            local v142 = v124[v140]
            local v143 = v141
            delay(v142, function() -- line 490 | captures: v108, v143, v65, v66, v67, TweenService, v3
                if not (v66 == v108 and v65) then
                    return
                end
                v143.Button.Visible = true
                local Button = v143.Button
                local v144 = { Position = v143.Rest }
                local v145 = TweenService:Create(Button, v3, v144)
                v145:Play()
                table.insert(v67, v145)
            end)
        end
        task.delay(0.7, function() -- line 500 | captures: v108, v65, v66, v77, v84, v58, v78, CanvasSize_2, v81
            if not (v66 == v108 and v65) then
                return
            end
            if v84 then
                v84:Disconnect()
                v84 = nil
            end
            if v78 then
                v78.CanvasPosition = Vector2.zero
            end
            v77 = false
            for v146, v147 in v58 do
                v147.Frame.Size = v147.Size
            end
            if v78 and CanvasSize_2 then
                v78.CanvasSize = CanvasSize_2
                v78.ScrollBarThickness = v81
            end
        end)
    end

    function v105.Close(v148) -- line 508 | captures: v65, v66, v84, v85, v55, v67, pinRows, v78, v86, resetClosed, v97, Icon_2, v98, RunService, TweenService, v4, v5
        if v65 then
            v65 = false
            v66 += 1
            local v149 = v66
            for v150, v151 in v67 do
                v151:Cancel()
            end
            table.clear(v67)
            if v148 then
                resetClosed()
            else
                if not v84 then
                    local Y = v97.AbsoluteSize.Y
                    v85 = math.max(Y, 1)
                    if not v84 and v86 and v78 then
                        v84 = RunService.RenderStepped:Connect(function() -- line 350 | captures: v85, v78
                            local Parent = v78.Parent
                            local v152 = if not (Parent and Parent:IsA("GuiObject")) then 0 else Parent.AbsoluteSize.Y
                            local Size = v78.Size
                            local v153 = Size.Y.Scale * v152 + Size.Y.Offset
                            local new = Vector2.new
                            local v154 = v85 - v153
                            v78.CanvasPosition = new(0, (math.max(v154, 0)))
                        end)
                    end
                end
                pinRows()
                local v155 = { Size = v55 }
                local v156 = TweenService:Create(v97, v5, v155)
                v156:Play()
                table.insert(v67, v156)
                if Icon_2 then
                    local v157 = { Rotation = v98 }
                    local v158 = TweenService:Create(Icon_2, v4, v157)
                    v158:Play()
                    table.insert(v67, v158)
                end
                task.delay(v5.Time, function() -- line 536 | captures: v149, v65, v66, resetClosed
                    if v66 == v149 and not v65 then
                        resetClosed()
                    end
                end)
            end
        elseif v148 then
            resetClosed()
        end
    end

    local v159 = (-1/0)

    function v105.Toggle() -- line 550 | captures: v65, v159, v105
        if v65 then
            v105.Close()
        elseif os.clock() - v159 > 0.25 then
            v105.Open()
        end
    end

    function v105.Destroy() -- line 558 | captures: v65, v66, v84, v67, v68
        for v160, v161 in v68 do
            v161:Disconnect()
        end
        table.clear(v68)
        for v162, v163 in v67 do
            v163:Cancel()
        end
        table.clear(v67)
        v65 = false
        v66 += 1
        if v84 then
            v84:Disconnect()
            v84 = nil
        end
    end

    v40(v68, v48.Activated:Connect(v105.Toggle))
    for v164, v165 in v58 do
        local Activated = v165.Button.Activated
        local v166 = v165
        local v167 = v52
        v42(v68, Activated:Connect(function() -- line 579 | captures: v64, v65, v38, v91, v105, v166, v167, v6, v7
            v64 = v166.Frame.Name
            if v167 then
                local v168 = v91[v64] or v6[v64] or v7
                v167:Set(v64, v168, nil)
            end
            if v38 then
                task.spawn(v38, v64)
            end
            task.delay(0.1, function() -- line 585 | captures: v65, v105
                if v65 then
                    v105.Close()
                end
            end)
        end))
    end
    local InputBegan = UserInputService.InputBegan
    local v169 = v48
    v44(v68, InputBegan:Connect(function(v170) -- line 598 | captures: v65, v159, v97, v105, v169, GuiService
        if v65 then
            local UserInputType = v170.UserInputType
            if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
                local v171 = Vector2.new(v170.Position.X, v170.Position.Y)
                local ScreenGui = v97:FindFirstAncestorWhichIsA("ScreenGui")
                if ScreenGui and ScreenGui.IgnoreGuiInset then
                    v171 += GuiService:GetGuiInset()
                end
                local AbsolutePosition = v97.AbsolutePosition
                local v172 = AbsolutePosition + v97.AbsoluteSize
                local X = v171.X
                local v173
                if AbsolutePosition.X <= X and v171.X <= v172.X then
                    local Y = v171.Y
                    if AbsolutePosition.Y <= Y then
                        v173 = v171.Y <= v172.Y
                    else
                        v173 = false
                    end
                else
                    v173 = false
                end
                if not v173 then
                    local AbsolutePosition = v169.AbsolutePosition
                    local v174 = AbsolutePosition + v169.AbsoluteSize
                    local X = v171.X
                    local v175
                    if AbsolutePosition.X <= X and v171.X <= v174.X then
                        local Y = v171.Y
                        if AbsolutePosition.Y <= Y then
                            v175 = v171.Y <= v174.Y
                        else
                            v175 = false
                        end
                    else
                        v175 = false
                    end
                    if not v175 then
                        v159 = os.clock()
                        v105.Close()
                    end
                end
            end
        end
    end))
    local Destroying = v49.Destroying
    v46(v68, Destroying:Connect(function() -- line 618 | captures: v105
        v105.Destroy()
    end))
    resetClosed()
    if v52 then
        local v176 = v91[v64] or v6[v64] or v7
        v52:Set(v64, v176, true)
    end
    return v105
end

return v1
