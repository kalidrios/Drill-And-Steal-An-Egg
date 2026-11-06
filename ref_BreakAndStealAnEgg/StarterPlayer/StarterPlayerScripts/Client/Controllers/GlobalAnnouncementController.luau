-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GlobalAnnouncementConfig = require(ReplicatedStorage.Shared.GlobalAnnouncementConfig)
local GuiFade = require(script.Parent.Parent.Modules.GuiFade)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local MessagesLift = require(script.Parent.Parent.Modules.MessagesLift)
local v1 = {}
local v2 = { "Texts", "Shadow" }
local v3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4, v5, Position
local v6 = {}
local v7 = 0

local function escapeRichText(v8) -- line 92
    return (v8:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"):gsub("'", "&apos;"))
end

local function cancelTweens(v9) -- line 96
    for v10, v11 in v9.Tweens do
        v11:Cancel()
    end
    table.clear(v9.Tweens)
end

local function play(v12, v13, v14, v15) -- line 103 | captures: TweenService
    local v16 = TweenService:Create(v13, v14, v15)
    v16:Play()
    local Tweens = v12.Tweens
    table.insert(Tweens, v16)
end

local function restack(v17) -- line 111 | captures: v4, Position, TweenService, GlobalAnnouncementConfig, v6
    local v18 = v4
    local Position_2 = Position
    if not v18 or not Position_2 or v18:FindFirstChildOfClass("UIListLayout") then
        return
    end
    local v19 = 0
    for v20, v21 in v6 do
        if not v21.Hiding then
            local Y = v21.Frame.AbsoluteSize.Y
            local v22 = UDim2.new(Position_2.X.Scale, Position_2.X.Offset, Position_2.Y.Scale, Position_2.Y.Offset + v19 * Y)
            if v17 then
                v21.Frame.Position = v22
            else
                TweenService:Create(v21.Frame, GlobalAnnouncementConfig.ShowTween, { Position = v22 }):Play()
            end
            v19 += 1
        end
    end
end

local function gapBelow(v23, v24) -- line 136 | captures: GlobalAnnouncementConfig
    local v25 = GlobalAnnouncementConfig.GapBelow[v23.Name]
    if v25 then
        local v26 = 0
        for v27, v28 in v23:GetChildren() do
            if v28:IsA("GuiObject") and not v28:IsA("TextLabel") then
                local v29 = v26
                for v30, v31 in v28:GetChildren() do
                    if v31:IsA("UIStroke") and v31.Enabled and v31.BorderStrokePosition == Enum.BorderStrokePosition.Outer then
                        local Thickness = v31.Thickness
                        v29 = math.max(v29, Thickness)
                    end
                    v26 = v29
                end
            end
        end
        return v25 * v24 + v26
    end
    return 0
end

local function gapAbove(v32) -- line 161 | captures: gapBelow
    local Parent = v32.Parent
    if not (Parent and Parent:IsA("GuiObject")) then
        return 0
    end
    local Y = Parent.AbsoluteSize.Y
    local v33 = 0
    for v34, v35 in Parent:GetChildren() do
        if v35 ~= v32 and v35:IsA("GuiObject") and v35.Visible and v35.LayoutOrder < v32.LayoutOrder then
            v33 += gapBelow(v35, Y)
        end
    end
    return v33
end

local function placeParts(v36) -- line 184 | captures: v6, gapAbove
    if #v6 == 0 then
        return
    end
    local v37 = -14 * (v36 or 0)
    local v38 = 1 - math.exp(v37)
    for v39, v40 in v6 do
        local v41 = v40.Frame.AbsolutePosition.Y + gapAbove(v40.Frame)
        local ShownY = v40.ShownY
        local v42 = if ShownY then ShownY + (v41 - ShownY) * v38 else v41
        v40.ShownY = v42
        local v43 = v40.Slide.Value + (v42 - v41)
        for v44, v45 in v40.Parts do
            local Rest = v45.Rest
            v45.Part.Position = UDim2.new(Rest.X.Scale, Rest.X.Offset, Rest.Y.Scale, Rest.Y.Offset + v43)
        end
    end
end

local function removeEntry(v46) -- line 202 | captures: v6
    local v47 = table.find(v6, v46)
    if v47 then
        table.remove(v6, v47)
    end
end

local function hide(v48) -- line 209 | captures: TweenService, GlobalAnnouncementConfig, GuiFade, v6, restack
    if v48.Hiding or not v48.Frame.Parent then
        return
    end
    v48.Hiding = true
    for v49, v50 in v48.Tweens do
        v50:Cancel()
    end
    table.clear(v48.Tweens)
    local HideTween = GlobalAnnouncementConfig.HideTween
    local v51 = v48.Frame.AbsoluteSize.Y * 0.9
    local Slide = v48.Slide
    local v52 = { Value = -v51 }
    local v53 = TweenService:Create(Slide, HideTween, v52)
    v53:Play()
    local Tweens = v48.Tweens
    table.insert(Tweens, v53)
    for v54, v55 in GuiFade.Tween(v48.Fade, HideTween, 1) do
        local Tweens = v48.Tweens
        table.insert(Tweens, v55)
    end
    task.delay(HideTween.Time, function() -- line 223 | captures: v48, v6, restack
        local v56 = table.find(v6, v48)
        if v56 then
            table.remove(v6, v56)
        end
        v48.Frame:Destroy()
        v48.Slide:Destroy()
        restack()
    end)
end

local function setContent(v57, v58) -- line 231 | captures: GlobalAnnouncementConfig, escapeRichText
    local Texts = v57:FindFirstChild("Texts")
    local v59 = v58.Kind == "Gift"
    local v60 = v58.Kind == "Line"
    local v61 = v59 or v60
    local v62 = Texts and Texts:FindFirstChild("PlayerDisplay")
    if v62 and v62:IsA("ImageLabel") then
        v62.Visible = not v61
        if not v61 then
            v62.Image = GlobalAnnouncementConfig.HeadshotUrl(v58.UserId)
        end
    end
    local v63 = Texts and Texts:FindFirstChild("Text")
    if not (v63 and v63:IsA("TextLabel")) then
        return
    end
    v63.RichText = true
    if v60 then
        v63.Text = v58.Text
    else
        local v64 = escapeRichText(v58.DisplayName)
        local v65
        if v59 then
            v65 = v58.Text
        else
            v65 = escapeRichText(v58.Text)
        end
        local v66 = GlobalAnnouncementConfig.NameColors[v58.UserId]
        if v66 then
            v64 = ("<font color=\"#%*\">%*</font>"):format(v66:ToHex(), v64)
        end
        local v67 = if v59 then " " else ": "
        v63.Text = ("%*%*%*%*"):format(v64, GlobalAnnouncementConfig.VerifiedBadge, v67, v65)
    end
end

local function show(v68) -- line 274 | captures: v4, v5, v7, RunService, TweenService, GlobalAnnouncementConfig, GuiFade, v2, v6, restack, gapAbove, placeParts, hide, setContent
    local v69 = v4
    local v70 = v5
    if not (v69 and v69.Parent and v70) then
        return
    end
    v7 += 1
    local v71 = v70:Clone()
    v71.Name = "ActiveGlobalAnnouncement"
    v71.LayoutOrder = v7
    setContent(v71, v68)
    local v72 = {}
    for v73, v74 in v2 do
        local v75 = v71:FindFirstChild(v74)
        if v75 and v75:IsA("GuiObject") then
            local v76 = {
                Part = v75,
                Rest = v75.Position
            }
            table.insert(v72, v76)
        end
    end
    local v77 = GuiFade.Capture(v71)
    GuiFade.Set(v77, 1)
    v71.Visible = true
    v71.Parent = v69
    local v78 = {
        Hiding = false,
        Frame = v71,
        Parts = v72,
        Fade = v77,
        Slide = Instance.new("NumberValue"),
        Tweens = {}
    }
    table.insert(v6, v78)
    restack(true)
    local v79 = 0
    for v80, v81 in v6 do
        if not v81.Hiding then
            v79 += 1
        end
    end
    for v82, v83 in v6 do
        if v79 <= GlobalAnnouncementConfig.MaxOnScreen then
            break
        end
        if not (v83.Hiding or v83 == v78) then
            hide(v83)
            v79 -= 1
        end
    end
    RunService.Heartbeat:Wait()
    if v78.Hiding or not v71.Parent then
        return
    end
    local v84 = v71.AbsolutePosition.Y + gapAbove(v71) + v71.AbsoluteSize.Y + 36
    v78.Slide.Value = -v84
    v78.ShownY = nil
    placeParts()
    local Slide = v78.Slide
    local ShowTween = GlobalAnnouncementConfig.ShowTween
    local v85 = { Value = 0 }
    local v86 = TweenService:Create(Slide, ShowTween, v85)
    v86:Play()
    local Tweens = v78.Tweens
    table.insert(Tweens, v86)
    GuiFade.Set(v77, 0)
    local v87 = GlobalAnnouncementConfig.ClampHold(v68.Hold)
    task.delay(GlobalAnnouncementConfig.ShowTween.Time + v87, function() -- line 345 | captures: v78, hide
        hide(v78)
    end)
end

local function occupiedHeight(v88) -- line 354 | captures: gapBelow
    local UIListLayout = v88:FindFirstChildOfClass("UIListLayout")
    local Y = v88.AbsoluteSize.Y
    local v89 = if UIListLayout then UIListLayout.Padding.Scale * Y + UIListLayout.Padding.Offset else 0
    local v90 = 0
    local v91 = 0
    local LayoutOrder
    local v92 = 0
    for v93, v94 in v88:GetChildren() do
        if v94:IsA("GuiObject") and v94.Visible then
            v90 += v94.AbsoluteSize.Y
            v91 += 1
            local v95 = gapBelow(v94, Y)
            if LayoutOrder == nil or LayoutOrder < v94.LayoutOrder then
                LayoutOrder = v94.LayoutOrder
                v92 = v95
            elseif v94.LayoutOrder == LayoutOrder then
                v92 = math.max(v92, v95)
            end
        end
    end
    if v91 == 0 then
        return 0
    end
    local v96 = v90 + v89 * (v91 - 1)
    local v97
    if UIListLayout and UIListLayout.FillDirection == Enum.FillDirection.Vertical then
        if UIListLayout.VerticalAlignment == Enum.VerticalAlignment.Center then
            v97 = (Y - v96) / 2
        elseif UIListLayout.VerticalAlignment == Enum.VerticalAlignment.Bottom then
            v97 = Y - v96
        else
            v97 = 0
        end
    else
        v97 = 0
    end
    local v98 = v97 + v96 + v89 + v92
    return (math.max(v98, 0))
end

local function onScreen(v99) -- line 396
    local v100 = v99
    while true do
        if v100 then
            if not v100:IsA("GuiObject") or v100.Visible then
                if v100:IsA("LayerCollector") then
                    return v100.Enabled
                end
                v100 = v100.Parent
                continue
            end
            break
        end
        return false
    end
    return false
end

local function resolveAvoid(v101, v102) -- line 415
    local v103 = v101
    for v104, v105 in v102.Path do
        v103 = v103 and v103:FindFirstChild(v105)
    end
    if not (v103 and v103:IsA("GuiObject")) then
        return nil
    end
    local v106 = {}
    for v107, v108 in v102.Parts do
        local v109 = v103:FindFirstChild(v108)
        if v109 and v109:IsA("GuiObject") then
            table.insert(v106, v109)
        end
    end
    return {
        Frame = v103,
        Parts = v106,
        Gui = v103:FindFirstAncestorWhichIsA("LayerCollector")
    }
end

local function findAvoids(v110, v111, v112, v113) -- line 436 | captures: GlobalAnnouncementConfig, resolveAvoid
    local function v114(v115, ...)
        table.insert(v115, ...)
    end

    local Parent = v110.Parent
    for v116, v117 in GlobalAnnouncementConfig.AvoidBelow or {} do
        if v117.Gui then
            local v118 = v117

            local function try(v119) -- line 440 | captures: v111, v112, v118, resolveAvoid
                if v119.Name == v118.Gui and v119:IsA("LayerCollector") then
                    local v120 = resolveAvoid(v119, v118)
                    if v120 then
                        table.insert(v111, v120)
                        v112(v120)
                    end
                end
            end

            if Parent then
                for v121, v122 in Parent:GetChildren() do
                    if v122.Name == v117.Gui and v122:IsA("LayerCollector") then
                        local v123 = resolveAvoid(v122, v117)
                        if v123 then
                            table.insert(v111, v123)
                            v112(v123)
                        end
                    end
                end
                v114(v113, Parent.ChildAdded:Connect(try))
            end
        else
            local v124 = resolveAvoid(v110, v117)
            if v124 then
                table.insert(v111, v124)
                v112(v124)
            end
        end
    end
end

local function avoidHeight(v125, v126) -- line 468 | captures: GlobalAnnouncementConfig, onScreen
    local v127
    for v128, v129 in v125 do
        if onScreen(v129.Frame) then
            local v130
            if #v129.Parts > 0 then
                v130 = v129.Parts
            else
                v130 = v129.Frame:GetChildren()
            end
            local v131 = v127
            for v132, v133 in v130 do
                if v133:IsA("GuiObject") and v133.Visible then
                    local v134 = v133.AbsolutePosition.Y + v133.AbsoluteSize.Y
                    if v131 then
                        v131 = math.max(v131, v134)
                    else
                        v131 = v134
                    end
                end
                v127 = v131
            end
        end
    end
    if v127 then
        local v135 = v127 + (GlobalAnnouncementConfig.AvoidGap or 0) - v126
        return (math.max(v135, 0))
    end
    return 0
end

local function buildHolder(v136, v137) -- line 491 | captures: TweenService, MessagesLift, v3, occupiedHeight, findAvoids, avoidHeight
    local v138 = v136:Clone()
    v138.Name = "GlobalAnnouncements"
    for v139, v140 in v138:GetChildren() do
        if not v140:IsA("UIListLayout") and not v140:IsA("UIAspectRatioConstraint") then
            v140:Destroy()
        end
    end
    local UIListLayout = v138:FindFirstChildOfClass("UIListLayout")
    if UIListLayout then
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    end
    v138.Position = v137
    v138.Visible = true
    v138.Parent = v136.Parent
    local v141 = {}
    local NumberValue = Instance.new("NumberValue")
    NumberValue.Parent = v138
    local v142, v143
    local v144 = false

    local function place() -- line 520 | captures: v137, v138, NumberValue, MessagesLift
        local v145 = v137.Y.Offset - MessagesLift.Get() + NumberValue.Value
        v138.Position = UDim2.new(v137.X.Scale, v137.X.Offset, v137.Y.Scale, v145)
    end

    NumberValue.Changed:Connect(place)
    local v146 = MessagesLift.Changed:Connect(function() -- line 525 | captures: v137, v138, NumberValue, MessagesLift
        if v138.Parent then
            local v147 = v137.Y.Offset - MessagesLift.Get() + NumberValue.Value
            v138.Position = UDim2.new(v137.X.Scale, v137.X.Offset, v137.Y.Scale, v147)
        end
    end)
    local v148
    v138.Destroying:Once(function() -- line 532 | captures: v148, v146
        v146:Disconnect()
        if v148 then
            v148:Disconnect()
        end
    end)

    local function restTop() -- line 541 | captures: v137, v138
        local Parent = v138.Parent
        if not (Parent and Parent:IsA("GuiBase2d")) then
            return 0
        end
        return Parent.AbsolutePosition.Y + v137.Y.Scale * Parent.AbsoluteSize.Y + v137.Y.Offset - v138.AnchorPoint.Y * v138.AbsoluteSize.Y
    end

    local function follow(v149) -- line 552 | captures: v142, v143, v136, v137, v138, v141, NumberValue, TweenService, MessagesLift, v3, occupiedHeight, avoidHeight
        local Parent = v138.Parent
        local v150 = if not (Parent and Parent:IsA("GuiBase2d")) then 0 else Parent.AbsolutePosition.Y + v137.Y.Scale * Parent.AbsoluteSize.Y + v137.Y.Offset - v138.AnchorPoint.Y * v138.AbsoluteSize.Y
        local v151 = v150 - MessagesLift.Target()
        local v152 = occupiedHeight(v136)
        local v153 = avoidHeight(v141, v151)
        local v154 = math.max(v152, v153)
        local v155 = v142 == nil
        local v156
        if not v155 then
            local v157 = v154 - v142
            v156 = math.abs(v157) < 0.5
        end
        if not v155 and v156 then
            return
        end
        v142 = v154
        if v143 then
            v143:Cancel()
            v143 = nil
        end
        if v149 then
            NumberValue.Value = v154
            local v158 = v137.Y.Offset - MessagesLift.Get() + NumberValue.Value
            v138.Position = UDim2.new(v137.X.Scale, v137.X.Offset, v137.Y.Scale, v158)
        else
            v143 = TweenService:Create(NumberValue, v3, { Value = v154 })
            v143:Play()
        end
    end

    local function queueFollow() -- line 578 | captures: v144, v138, follow
        if not v144 then
            v144 = true
            task.defer(function() -- line 583 | captures: v144, v138, follow
                v144 = false
                if v138.Parent then
                    follow()
                end
            end)
        end
    end

    local function watch(v159) -- line 591 | captures: queueFollow
        if v159:IsA("GuiObject") then
            v159:GetPropertyChangedSignal("Visible"):Connect(queueFollow)
            v159:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueFollow)
        end
    end

    for v160, v161 in v136:GetChildren() do
        if v161:IsA("GuiObject") then
            v161:GetPropertyChangedSignal("Visible"):Connect(queueFollow)
            v161:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueFollow)
        end
    end
    v136.ChildAdded:Connect(function(v162) -- line 600 | captures: v144, v138, follow, queueFollow
        if v162:IsA("GuiObject") then
            v162:GetPropertyChangedSignal("Visible"):Connect(queueFollow)
            v162:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueFollow)
        end
        if not v144 then
            v144 = true
            task.defer(function() -- line 583 | captures: v144, v138, follow
                v144 = false
                if v138.Parent then
                    follow()
                end
            end)
        end
    end)
    v136.ChildRemoved:Connect(queueFollow)
    v136:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueFollow)
    v148 = MessagesLift.TargetChanged:Connect(queueFollow)
    local v163 = {}

    local function hookAvoid(v164) -- line 611 | captures: v144, v138, follow, queueFollow, v163
        local function v165(v166, ...)
            table.insert(v166, ...)
        end

        local function v167(v168, ...)
            table.insert(v168, ...)
        end

        local function v169(v170, ...)
            table.insert(v170, ...)
        end

        local function v171(v172, ...)
            table.insert(v172, ...)
        end

        local function v173(v174, ...)
            table.insert(v174, ...)
        end

        local function v175(v176, ...)
            table.insert(v176, ...)
        end

        local function v177(v178, ...)
            table.insert(v178, ...)
        end

        local function v179(v180, ...)
            table.insert(v180, ...)
        end

        local function on(v181) -- line 612 | captures: queueFollow, v163
            local function v182(v183, ...)
                table.insert(v183, ...)
            end

            v182(v163, v181:Connect(queueFollow))
        end

        local Visible = v164.Frame:GetPropertyChangedSignal("Visible")
        v165(v163, Visible:Connect(queueFollow))
        local AbsolutePosition = v164.Frame:GetPropertyChangedSignal("AbsolutePosition")
        v167(v163, AbsolutePosition:Connect(queueFollow))
        for v184, v185 in v164.Parts do
            local Visible = v185:GetPropertyChangedSignal("Visible")
            v169(v163, Visible:Connect(queueFollow))
            local AbsoluteSize = v185:GetPropertyChangedSignal("AbsoluteSize")
            v171(v163, AbsoluteSize:Connect(queueFollow))
        end
        if v164.Gui then
            local Enabled = v164.Gui:GetPropertyChangedSignal("Enabled")
            v173(v163, Enabled:Connect(queueFollow))
        end
        if #v164.Parts == 0 then
            local ChildAdded = v164.Frame.ChildAdded
            v175(v163, ChildAdded:Connect(queueFollow))
            local ChildRemoved = v164.Frame.ChildRemoved
            v177(v163, ChildRemoved:Connect(queueFollow))
            v179(v163, v164.Frame.ChildAdded:Connect(function(v186) -- line 628 | captures: queueFollow, v163
                local function v187(v188, ...)
                    table.insert(v188, ...)
                end

                if v186:IsA("GuiObject") then
                    v187(v163, v186:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueFollow))
                end
            end))
        end
        if not v144 then
            v144 = true
            task.defer(function() -- line 583 | captures: v144, v138, follow
                v144 = false
                if v138.Parent then
                    follow()
                end
            end)
        end
    end

    findAvoids(v136.Parent, v141, hookAvoid, v163)
    v138.Destroying:Once(function() -- line 637 | captures: v163
        for v189, v190 in v163 do
            v190:Disconnect()
        end
    end)
    local Parent = v138.Parent
    local v191 = if not (Parent and Parent:IsA("GuiBase2d")) then 0 else Parent.AbsolutePosition.Y + v137.Y.Scale * Parent.AbsoluteSize.Y + v137.Y.Offset - v138.AnchorPoint.Y * v138.AbsoluteSize.Y
    local v192 = v191 - MessagesLift.Target()
    local v193 = occupiedHeight(v136)
    local v194 = avoidHeight(v141, v192)
    local v195 = math.max(v193, v194)
    local v196
    if v142 == nil then
        v142 = v195
        if v143 then
            v143:Cancel()
            v143 = nil
        end
        v196 = false
    else
        local v197 = v195 - v142
        if math.abs(v197) < 0.5 then
            v196 = true
        else
            v142 = v195
            if v143 then
                v143:Cancel()
                v143 = nil
            end
            v196 = false
        end
    end
    if not v196 then
        NumberValue.Value = v195
        local v198 = v137.Y.Offset - MessagesLift.Get() + NumberValue.Value
        v138.Position = UDim2.new(v137.X.Scale, v137.X.Offset, v137.Y.Scale, v198)
    end
    return v138
end

local function adopt(v199) -- line 650 | captures: v4, v5, Position, GlobalAnnouncementConfig, MessagesLift, v6, buildHolder
    table.clear(v6)
    v4 = nil
    v5 = nil
    Position = nil
    local Messages = v199:FindFirstChild("Messages")
    if Messages then
        local v200 = Messages:FindFirstChild(GlobalAnnouncementConfig.TemplateName)
        if Messages:IsA("Frame") and v200 and v200:IsA("GuiObject") then
            v200.Visible = false
            v4 = buildHolder(Messages, MessagesLift.Rest(Messages))
            v5 = v200
            Position = v200.Position
            return
        end
    end
    warn((("[GlobalAnnouncement] MainGUI.Messages.%* missing"):format(GlobalAnnouncementConfig.TemplateName)))
end

function v1.GetHolder() -- line 677 | captures: v4
    local v201 = v4
    if not (v201 and v201.Parent) then
        return nil
    end
    return v201
end

function v1.GapAbove(v202) -- line 684 | captures: gapAbove
    return (gapAbove(v202))
end

function v1.Show(v203) -- line 689 | captures: show
    task.spawn(show, v203)
end

function v1.Start() -- line 693 | captures: ReplicatedStorage, RunService, GlobalAnnouncementConfig, MainGui, placeParts, show, adopt
    MainGui.Observe(adopt)
    RunService:BindToRenderStep("GlobalAnnouncementPlace", Enum.RenderPriority.Last.Value, placeParts)
    ReplicatedStorage:WaitForChild(GlobalAnnouncementConfig.RemoteName).OnClientEvent:Connect(function(v204) -- line 700 | captures: show
        local v205 = type(v204) == "table"
        local v206
        if v205 then
            local Text = v204.Text
            v206 = type(Text) == "string"
        end
        if v205 and v206 then
            task.spawn(show, v204)
        end
    end)
end

return v1
