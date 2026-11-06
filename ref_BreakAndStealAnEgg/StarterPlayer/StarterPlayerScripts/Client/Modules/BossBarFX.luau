-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local v1 = { "BossHP" }
local v2 = { "BossHpBar" }
local v3 = { "BossHpBar", "Bar" }
local v4 = { "BossHpBar", "DamageBar" }
local v5 = { "Hp" }
local v6 = { "Title" }
local v7 = { "Icon" }
local v8 = { "Shields" }
local v9 = { "Stage4", "Stage3", "Stage2", "Stage1" }
local v10 = Color3.new(0, 0, 0)
local v11 = Color3.fromRGB(45, 45, 50)
local v12 = Color3.new(1, 1, 1)
local v13 = Color3.new(1, 1, 1)
local v14 = Color3.new(1, 1, 1)
local v15 = Color3.new(1, 1, 1)
local Quad = Enum.EasingStyle.Quad
local v16 = { "BossSfx", "BarShatter" }
local v17 = { "Bo", "ss", "Na", "me", "He", "re" }
local v18 = Color3.new(1, 1, 1)
local v19 = Color3.fromRGB(210, 210, 218)
local v20 = Color3.fromRGB(190, 190, 200)
local v21 = { "BossSfx", "PipBreak" }
local v22 = {}
local Out = Enum.EasingDirection.Out
local v23 = Random.new()

local function play2d(v24) -- line 190 | captures: Debris
    local v25 = game:GetService("SoundService"):FindFirstChild(v24[1])
    local v26 = v25 and v25:FindFirstChild(v24[2])
    if not (v26 and v26:IsA("Sound")) then
        return
    end
    local v27 = v26:Clone()
    v27.Parent = v25
    v27:Play()
    Debris:AddItem(v27, v27.TimeLength + 0.5)
end

local function rand(v28, v29) -- line 201 | captures: v23
    return v28 + v23:NextNumber() * (v29 - v28)
end

local function randSign() -- line 205 | captures: v23
    if v23:NextNumber() < 0.5 then
        return -1
    end
    return 1
end

local function resolve(v30, v31) -- line 209
    local v32 = v30
    for v33, v34 in v31 do
        v32 = v32 and v32:FindFirstChild(v34)
    end
    return v32
end

local function commas(v35) -- line 217
    local v36 = v35 + 0.5
    local v37 = math.floor(v36)
    local v38 = tostring(v37)
    local v39
    while true do
        local v40
        v39, v40 = v38:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        if v40 == 0 then
            break
        end
        v38 = v39
    end
    return v39
end

local function cancelAll(v41) -- line 226
    for v42, v43 in v41 do
        v43:Cancel()
    end
    table.clear(v41)
end

local function play(v44, v45, v46, v47) -- line 233 | captures: TweenService
    local v48 = TweenService:Create(v45, v46, v47)
    if v44 then
        table.insert(v44, v48)
    end
    v48:Play()
    return v48
end

local v49
local v50 = false
local v51
local v52 = false
local v53 = false
local v54 = 0
local v55 = 0
local v56 = 0
local v57 = {}
local v58 = {}
local v59 = {}
local v60 = {}
local v61 = {}
local v62 = {}
local v63 = {}
local v64 = true
local v65 = 0
local v66 = {
    Connection = nil,
    HoldUntil = 0,
    Draining = false,
    From = 0,
    To = 0,
    Start = 0
}
local v67, v68
local v69 = {}

local function ensureFx() -- line 289 | captures: v51, Players, v15, v62
    if v51 and v51.Gui.Parent then
        return v51
    end
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if PlayerGui then
        local BossBarFX = PlayerGui:FindFirstChild("BossBarFX")
        if not (BossBarFX and BossBarFX:IsA("ScreenGui")) then
            BossBarFX = Instance.new("ScreenGui")
            BossBarFX.Name = "BossBarFX"
            BossBarFX.IgnoreGuiInset = true
            BossBarFX.ResetOnSpawn = false
            BossBarFX.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            BossBarFX.DisplayOrder = 50
            BossBarFX.Parent = PlayerGui
        end
        BossBarFX:ClearAllChildren()
        local Frame = Instance.new("Frame")
        Frame.Name = "Shards"
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.ZIndex = 1
        Frame.Parent = BossBarFX
        local Frame_2 = Instance.new("Frame")
        Frame_2.Name = "ScreenFlash"
        Frame_2.BackgroundColor3 = v15
        Frame_2.BackgroundTransparency = 1
        Frame_2.BorderSizePixel = 0
        Frame_2.Size = UDim2.fromScale(1, 1)
        Frame_2.ZIndex = 100
        Frame_2.Parent = BossBarFX
        for v70, v71 in v62 do
            v71:Disconnect()
        end
        table.clear(v62)
        v51 = {
            Gui = BossBarFX,
            Layer = Frame,
            Flash = Frame_2
        }
        return v51
    end
    return nil
end

local function slider(v72) -- line 338
    local Position = v72.Position
    local v73 = (1 - v72.AnchorPoint.X) * v72.Size.X.Scale
    local v74 = {}

    function v74.Set(v75) -- line 342 | captures: v72, Position, v73
        v72.Position = UDim2.new(v75 - v73, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
    end

    function v74.Get() -- line 345 | captures: v72, v73
        return v72.Position.X.Scale + v73
    end

    return v74
end

local function makeOverlay(v76, v77) -- line 353 | captures: v12
    local BossBarFX_Flash = v76:FindFirstChild("BossBarFX_Flash")
    if BossBarFX_Flash then
        BossBarFX_Flash:Destroy()
    end
    local Frame = Instance.new("Frame")
    Frame.Name = "BossBarFX_Flash"
    Frame.BackgroundColor3 = v12
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = 50
    local v78 = {}
    for v79, v80 in v76:GetChildren() do
        if v80:IsA("UICorner") then
            v80:Clone().Parent = Frame
        elseif v80:IsA("UIStroke") and not v77 then
            local v81 = v80:Clone()
            v81:ClearAllChildren()
            v81.Color = v12
            v81.Transparency = 1
            v81.Parent = Frame
            table.insert(v78, v81)
        end
    end
    Frame.Parent = v76
    return {
        Frame = Frame,
        Target = v76,
        Strokes = v78
    }
end

local v82 = {
    UIStroke = true,
    UITextSizeConstraint = true,
    UIPadding = true
}

local function makeGhost(v83) -- line 386 | captures: v12, v82
    local BossBarFX_Flash = v83:FindFirstChild("BossBarFX_Flash")
    if BossBarFX_Flash then
        BossBarFX_Flash:Destroy()
    end
    local v84 = v83:Clone()
    local v85 = {}
    for v86, v87 in v84:GetChildren() do
        if v82[v87.ClassName] then
            if v87:IsA("UIStroke") then
                v87:ClearAllChildren()
                v87.Color = v12
                v87.Transparency = 1
                table.insert(v85, v87)
            end
        else
            v87:Destroy()
        end
    end
    v84.Name = "BossBarFX_Flash"
    v84.AnchorPoint = Vector2.new(0.5, 0.5)
    v84.Position = UDim2.fromScale(0.5, 0.5)
    v84.Size = UDim2.fromScale(1, 1)
    v84.Rotation = 0
    v84.BackgroundTransparency = 1
    v84.TextColor3 = v12
    v84.TextTransparency = 1
    v84.TextStrokeTransparency = 1
    v84.Parent = v83
    return {
        Label = v84,
        Source = v83,
        Strokes = v85
    }
end

local v88 = {}

local function need(v89, v90, v91) -- line 417 | captures: v88
    local v92 = v89
    for v93, v94 in v90 do
        v92 = v92 and v92:FindFirstChild(v94)
    end
    if v92 and v92:IsA(v91) then
        return v92
    end
    local v95 = table.concat(v90, ".")
    if not v88[v95] then
        v88[v95] = true
        warn((("[BossBarFX] missing %*.%* (%*)"):format(v89:GetFullName(), v95, v91)))
    end
    return nil
end

local v96

local function bind() -- line 432 | captures: v49, v50, v96, Players, v1, v2, v3, v4, v5, v6, v7, v8, v9, v13, slider, makeOverlay, makeGhost, need
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v97 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v98
    if v97 then
        local v99 = v97
        v98 = v97
        for v100, v101 in v1 do
            v99 = v99 and v99:FindFirstChild(v101)
            v98 = v99
        end
    else
        v98 = v97
    end
    if v98 and v98:IsA("GuiObject") then
        if v49 and v49.Root == v98 then
            return v49
        end
        if v49 then
            v96()
        end
        local GuiObject = need(v98, v2, "GuiObject")
        local GuiObject_2 = need(v98, v3, "GuiObject")
        if GuiObject and GuiObject_2 then
            local GuiObject_3 = need(v98, v4, "GuiObject")
            local v102 = {
                Gui = v97,
                Root = v98,
                Bar = GuiObject,
                Fill = slider(GuiObject_2)
            }
            v102.Chip = GuiObject_3 and slider(GuiObject_3)
            v102.HpText = need(v98, v5, "TextLabel")
            v102.Name = need(v98, v6, "TextLabel")
            v102.Icon = need(v98, v7, "GuiObject")
            v102.BasePosition = v98.Position
            v102.BaseRotation = v98.Rotation
            v102.Overlays = {}
            v102.Ghosts = {}
            v102.Recolors = {}
            local Overlays = v102.Overlays
            local v103 = makeOverlay(GuiObject, true)
            table.insert(Overlays, v103)
            for v104, v105 in GuiObject:GetChildren() do
                if v105:IsA("UIStroke") then
                    local Recolors = v102.Recolors
                    local v106 = {
                        Property = "Color",
                        Instance = v105,
                        Original = v105.Color
                    }
                    table.insert(Recolors, v106)
                end
            end
            local v107
            if v50 then
                v107 = v98
                for v108, v109 in v8 do
                    v107 = v107 and v107:FindFirstChild(v109)
                end
                if not (v107 and v107:IsA("GuiObject")) then
                    v107 = nil
                end
            else
                v107 = need(v98, v8, "GuiObject")
            end
            if v107 then
                if v50 then
                    v107.Visible = false
                end
                for v110, v111 in v107:GetChildren() do
                    if v111:IsA("Frame") then
                        local Overlays = v102.Overlays
                        local v112 = makeOverlay(v111, true)
                        table.insert(Overlays, v112)
                        for v113, v114 in v111:GetDescendants() do
                            if v114:IsA("Frame") and v114.Name ~= "BossBarFX_Flash" then
                                local Overlays = v102.Overlays
                                local v115 = makeOverlay(v114, true)
                                table.insert(Overlays, v115)
                            end
                        end
                    end
                end
            end
            v102.FlashStrokes = {}
            for v116, v117 in GuiObject:GetChildren() do
                if v117:IsA("UIStroke") then
                    local FlashStrokes = v102.FlashStrokes
                    table.insert(FlashStrokes, v117)
                end
            end
            if v107 then
                for v118, v119 in v107:GetDescendants() do
                    if v119:IsA("UIStroke") and not v119:FindFirstAncestor("BossBarFX_Flash") then
                        local FlashStrokes = v102.FlashStrokes
                        table.insert(FlashStrokes, v119)
                    end
                end
            end
            v102.StrokesOff = {}
            for v120, v121 in {
                    v102.Name,
                    v102.HpText
                } do
                if v121 then
                    local Ghosts = v102.Ghosts
                    local v122 = makeGhost(v121)
                    table.insert(Ghosts, v122)
                end
            end
            v102.Pips = {}
            v102.PipRow = v107
            if v107 then
                for v123, v124 in v9 do
                    local v125 = v107:FindFirstChild(v124)
                    if v125 then
                        local v126 = v125:FindFirstChild("Inner")
                        if v125:IsA("GuiObject") and v126 and v126:IsA("GuiObject") then
                            local v127 = {}
                            local v128 = {}
                            for v129, v130 in v125:GetChildren() do
                                if v130:IsA("UIShadow") then
                                    v127[v130] = v130.Color
                                elseif v130:IsA("UIStroke") then
                                    v128[v130] = {
                                        Color = v130.Color,
                                        Transparency = v130.Transparency
                                    }
                                end
                            end
                            local v131 = {}
                            for v132, v133 in v125:GetDescendants() do
                                if v133:IsA("UIGradient") and not v133:IsDescendantOf(v126) then
                                    v131[v133] = v133.Enabled
                                end
                            end
                            local v134 = v125:FindFirstChild("BossBarFXScale") or Instance.new("UIScale")
                            v134.Name = "BossBarFXScale"
                            v134.Scale = 1
                            v134.Parent = v125
                            local Pips = v102.Pips
                            local v135 = {
                                Name = v124,
                                Slot = v125,
                                Shadows = v127,
                                Strokes = v128,
                                Gradients = v131,
                                SlotTransparency = v125.BackgroundTransparency,
                                SlotColor = v125.BackgroundColor3,
                                Fill = v126,
                                FillVisible = v126.Visible,
                                FillAnchor = v126.AnchorPoint,
                                FillPosition = v126.Position,
                                FillSize = v126.Size,
                                Scale = v134
                            }
                            table.insert(Pips, v135)
                        end
                    end
                end
            end
            local v136 = GuiObject_2:FindFirstChild("BossBarFX_Edge") or Instance.new("Frame")
            v136.Name = "BossBarFX_Edge"
            v136.BackgroundColor3 = v13
            v136.BackgroundTransparency = 1
            v136.BorderSizePixel = 0
            v136.AnchorPoint = Vector2.new(1, 0.5)
            v136.Position = UDim2.fromScale(1, 0.5)
            v136.Size = UDim2.new(0, 2, 1, 0)
            v136.ZIndex = 10
            v136.Parent = GuiObject_2
            v102.Edge = v136
            local v137 = v98:FindFirstChild("BossBarFXScale") or Instance.new("UIScale")
            v137.Name = "BossBarFXScale"
            v137.Scale = 1
            v137.Parent = v98
            v102.Scale = v137
            v49 = v102
            return v102
        end
        v49 = nil
    end
    return nil
end

local function isShown(v138) -- line 601
    return v138.Root.Visible and v138.Gui.Enabled and v138.Root:IsDescendantOf(game)
end

local function insetOffset(v139) -- line 606 | captures: GuiService
    if v139.Gui.IgnoreGuiInset then
        return Vector2.zero
    end
    return (GuiService:GetGuiInset())
end

local function setHpText(v140, v141, v142) -- line 617 | captures: commas
    if v140.HpText then
        v140.HpText.Text = string.format("%s/%s HP", commas((math.max(v141, 0))), (commas(v142)))
    end
end

local v143 = 0

local function flashOn(v144) -- line 627 | captures: v143, v12, v57
    for v145, v146 in v57 do
        v146:Cancel()
    end
    table.clear(v57)
    v143 += 1
    for v147, v148 in v144.FlashStrokes do
        if v148.Enabled then
            v148.Enabled = false
            v144.StrokesOff[v148] = true
        end
    end
    for v149, v150 in v144.Overlays do
        local v151 = v150.Target.Visible and v150.Target.BackgroundTransparency < 0.99
        local Frame = v150.Frame
        if v151 then
            Frame.BackgroundTransparency = 0
        else
            Frame.BackgroundTransparency = 1
        end
        for v152, v153 in v150.Strokes do
            if v151 then
                v153.Transparency = 0
            else
                v153.Transparency = 1
            end
        end
    end
    for v154, v155 in v144.Ghosts do
        local v156 = v155.Source.Visible and v155.Source.TextTransparency < 0.99
        v155.Label.Text = v155.Source.Text
        local Label = v155.Label
        if v156 then
            Label.TextTransparency = 0
        else
            Label.TextTransparency = 1
        end
        for v157, v158 in v155.Strokes do
            if v156 then
                v158.Transparency = 0
            else
                v158.Transparency = 1
            end
        end
    end
    for v159, v160 in v144.Recolors do
        v160.Instance[v160.Property] = v12
    end
end

local function strokesOn(v161) -- line 657
    for v162 in v161.StrokesOff do
        v162.Enabled = true
    end
    table.clear(v161.StrokesOff)
end

local function flashOff(v163, v164) -- line 665 | captures: v49, v143, TweenService, Quad, Out, v57
    for v165, v166 in v57 do
        v166:Cancel()
    end
    table.clear(v57)
    if v164 > 0 then
        local v167 = v143
        task.delay(v164, function() -- line 669 | captures: v163, v167, v49, v143
            if v167 == v143 and v49 == v163 then
                for v168 in v163.StrokesOff do
                    v168.Enabled = true
                end
                table.clear(v163.StrokesOff)
            end
        end)
    else
        for v169 in v163.StrokesOff do
            v169.Enabled = true
        end
        table.clear(v163.StrokesOff)
    end
    local v170 = TweenInfo.new(v164, Quad, Out)

    local function set(v171, v172) -- line 678 | captures: v164, v170, TweenService, v57
        if v164 > 0 then
            local v173 = TweenService:Create(v171, v170, v172)
            if v57 then
                table.insert(v57, v173)
            end
            v173:Play()
        else
            for v174, v175 in v172 do
                v171[v174] = v175
            end
        end
    end

    for v176, v177 in v163.Overlays do
        local Frame = v177.Frame
        local v178 = { BackgroundTransparency = 1 }
        if v164 > 0 then
            local v179 = TweenService:Create(Frame, v170, v178)
            if v57 then
                table.insert(v57, v179)
            end
            v179:Play()
        else
            for v180, v181 in v178 do
                Frame[v180] = v181
            end
        end
        for v182, v183 in v177.Strokes do
            local v184 = { Transparency = 1 }
            if v164 > 0 then
                local v185 = TweenService:Create(v183, v170, v184)
                if v57 then
                    table.insert(v57, v185)
                end
                v185:Play()
            else
                for v186, v187 in v184 do
                    v183[v186] = v187
                end
            end
        end
    end
    for v188, v189 in v163.Ghosts do
        local Label = v189.Label
        local v190 = { TextTransparency = 1 }
        if v164 > 0 then
            local v191 = TweenService:Create(Label, v170, v190)
            if v57 then
                table.insert(v57, v191)
            end
            v191:Play()
        else
            for v192, v193 in v190 do
                Label[v192] = v193
            end
        end
        for v194, v195 in v189.Strokes do
            local v196 = { Transparency = 1 }
            if v164 > 0 then
                local v197 = TweenService:Create(v195, v170, v196)
                if v57 then
                    table.insert(v57, v197)
                end
                v197:Play()
            else
                for v198, v199 in v196 do
                    v195[v198] = v199
                end
            end
        end
    end
    for v200, v201 in v163.Recolors do
        local Instance = v201.Instance
        local v202 = { [v201.Property] = v201.Original }
        if v164 > 0 then
            local v203 = TweenService:Create(Instance, v170, v202)
            if v57 then
                table.insert(v57, v203)
            end
            v203:Play()
        else
            for v204, v205 in v202 do
                Instance[v204] = v205
            end
        end
    end
end

local function setShake(v206, v207, v208) -- line 704
    v206.Root.Position = v206.BasePosition + UDim2.fromOffset(v207.X, v207.Y)
    v206.Root.Rotation = v206.BaseRotation + v208
end

local function shakeRest(v209, v210) -- line 709 | captures: TweenService, Out, v58
    for v211, v212 in v58 do
        v212:Cancel()
    end
    table.clear(v58)
    if v210 > 0 then
        local v213 = TweenInfo.new(v210, Enum.EasingStyle.Quad, Out)
        local Root = v209.Root
        local v214 = {
            Position = v209.BasePosition,
            Rotation = v209.BaseRotation
        }
        local v215 = TweenService:Create(Root, v213, v214)
        if v58 then
            table.insert(v58, v215)
        end
        v215:Play()
    else
        v209.Root.Position = v209.BasePosition
        v209.Root.Rotation = v209.BaseRotation
    end
end

local function edgeShow(v216, v217) -- line 720 | captures: TweenService, v59
    for v218, v219 in v59 do
        v219:Cancel()
    end
    table.clear(v59)
    if v217 then
        v216.Edge.BackgroundTransparency = 0
    else
        local Edge = v216.Edge
        local v220 = TweenInfo.new(0.1)
        local v221 = { BackgroundTransparency = 1 }
        local v222 = TweenService:Create(Edge, v220, v221)
        if v59 then
            table.insert(v59, v222)
        end
        v222:Play()
    end
end

local function stopChip() -- line 729 | captures: v66
    if v66.Connection then
        v66.Connection:Disconnect()
        v66.Connection = nil
    end
    v66.Draining = false
end

local function startChip(v223, v224) -- line 739 | captures: RunService, TweenService, Out, v59, v66
    if not v223.Chip then
        return
    end
    v66.To = v224
    v66.HoldUntil = os.clock() + 0.35
    v66.Draining = false
    if not v66.Connection then
        local RenderStepped = RunService.RenderStepped
        v66.Connection = RenderStepped:Connect(function() -- line 749 | captures: v223, TweenService, Out, v59, v66
            local v225 = os.clock()
            if v225 < v66.HoldUntil then
                return
            end
            if not v66.Draining then
                v66.Draining = true
                v66.From = v223.Chip.Get()
                v66.Start = v225
            end
            local v226 = (v225 - v66.Start) / 0.3
            local v227 = math.clamp(v226, 0, 1)
            local v228 = TweenService:GetValue(v227, Enum.EasingStyle.Quad, Out)
            v223.Chip.Set(v66.From + (v66.To - v66.From) * v228)
            if not (v227 >= 1) then
                return
            end
            if v66.Connection then
                v66.Connection:Disconnect()
                v66.Connection = nil
            end
            v66.Draining = false
            for v229, v230 in v59 do
                v230:Cancel()
            end
            table.clear(v59)
            local Edge = v223.Edge
            local v231 = TweenInfo.new(0.1)
            local v232 = { BackgroundTransparency = 1 }
            local v233 = TweenService:Create(Edge, v231, v232)
            if v59 then
                table.insert(v59, v233)
            end
            v233:Play()
        end)
    end
end

local function playHit(v234, v235, v236) -- line 772 | captures: v49, v52, v55, v23, v58, v59, flashOn, flashOff, shakeRest, startChip
    v55 += 1
    local v237 = v55
    flashOn(v234)
    for v238, v239 in v58 do
        v239:Cancel()
    end
    table.clear(v58)
    local new = Vector2.new
    local v240 = 2 + v23:NextNumber() * 3
    local v241 = if v23:NextNumber() < 0.5 then -1 else 1
    local v242 = v240 * v241
    local v243 = 2 + v23:NextNumber() * 3
    local v244 = if v23:NextNumber() < 0.5 then -1 else 1
    local v245 = new(v242, v243 * v244)
    local v246 = 1 + v23:NextNumber() * 2
    local v247 = if v23:NextNumber() < 0.5 then -1 else 1
    local v248 = v246 * v247
    v234.Root.Position = v234.BasePosition + UDim2.fromOffset(v245.X, v245.Y)
    v234.Root.Rotation = v234.BaseRotation + v248
    if v234.Chip and v235 and v236 then
        if v234.Chip.Get() < v236 then
            v234.Chip.Set(v236)
        end
        startChip(v234, v235)
        for v249, v250 in v59 do
            v250:Cancel()
        end
        table.clear(v59)
        v234.Edge.BackgroundTransparency = 0
    end
    task.delay(0.07, function() -- line 796 | captures: v234, v237, v49, v52, v55, flashOff, shakeRest
        if not (v237 == v55) or v52 or not (v49 == v234) then
            return
        end
        flashOff(v234, 0.12)
        shakeRest(v234, 0.12)
    end)
end

local function textRect(v251, v252) -- line 809
    local AbsoluteSize = v251.AbsoluteSize
    local TextBounds = v251.TextBounds
    if TextBounds.X > 0 and TextBounds.Y > 0 then
        local new = Vector2.new
        local X = TextBounds.X
        local X_2 = AbsoluteSize.X
        local v253 = math.min(X, X_2)
        local Y = TextBounds.Y
        local Y_2 = AbsoluteSize.Y
        AbsoluteSize = new(v253, (math.min(Y, Y_2)))
    end
    return v251.AbsolutePosition + v251.AbsoluteSize / 2 + v252 - AbsoluteSize / 2, AbsoluteSize
end

local function fragmentsOf(v254) -- line 819 | captures: v17
    local function v255(v256, ...)
        table.insert(v256, ...)
    end

    local v257 = v254:gsub("%s", "")
    local v258 = {}
    local v259 = #v257
    for v260 = 1, v259, 2 do
        v255(v258, v257:sub(v260, v260 + 2 - 1))
    end
    if #v258 > 0 then
        return v258
    end
    return v17
end

local v261

local function addShard(v262, v263, v264, v265, v266, v267, v268, v269, v270, v271) -- line 833 | captures: v51, v261, Debris, v23, v69
    local v272 = v261
    if v272 then
        v272.Count += 1
    end
    v262.AnchorPoint = Vector2.new(0.5, 0.5)
    v262.Position = UDim2.fromOffset(v264, v265)
    v262.Rotation = -45 + v23:NextNumber() * 90
    v262.Parent = v51.Layer
    Debris:AddItem(v262, v269 + 1)
    local v273 = {
        Age = 0,
        Gui = v262,
        Kind = v263,
        Stroke = v262:FindFirstChildOfClass("UIStroke"),
        X = v264,
        Y = v265,
        Vx = v266,
        Vy = v267,
        Rotation = v262.Rotation,
        Spin = v268,
        Life = v269,
        Gravity = v270,
        Radius = v271,
        Group = v272
    }
    table.insert(v69, v273)
end

local function spawnShards(v274) -- line 862 | captures: GuiService, v14, v23, v69, textRect, fragmentsOf, addShard
    local v275
    if v274.Gui.IgnoreGuiInset then
        v275 = Vector2.zero
    else
        v275 = GuiService:GetGuiInset()
    end
    local v276 = v274.Bar.AbsolutePosition + v275
    local AbsoluteSize = v274.Bar.AbsoluteSize
    local v277 = v276 + AbsoluteSize / 2
    local v278 = AbsoluteSize.X / 2
    local v279 = math.max(v278, 1)
    local v280, v281
    if v274.Name and v274.Name.Visible then
        v280, v281 = textRect(v274.Name, v275)
    end
    local Text = v274.Name and v274.Name.Text or ""
    local v282 = fragmentsOf(Text)
    local v283 = if v280 then 6 else 0
    local v284 = math.min(3, v283)
    local v285 = {}
    for v286, v287 in v274.Pips or {} do
        local AbsoluteSize = v287.Slot.AbsoluteSize
        if v287.Slot.Visible and AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
            local v288 = {
                Position = v287.Slot.AbsolutePosition + v275,
                Size = AbsoluteSize
            }
            table.insert(v285, v288)
        end
    end
    local v289 = if #v285 > 0 then 8 else 0

    local function launch(v290) -- line 888 | captures: v277, v279, v23
        local v291 = (v290 - v277.X) / v279
        local v292 = math.clamp(v291, -1, 1) * (150 + v23:NextNumber() * 350) + (-150 + v23:NextNumber() * 300)
        return math.clamp(v292, -500, 500), -450 + v23:NextNumber() * 350
    end

    for v293 = 1, 50 do
        local v294 = v293 <= v283
        local v295, v296
        if v294 then
            v295 = v280
            v296 = v281
        elseif v293 <= v283 + v289 then
            local v297 = v285[v23:NextInteger(1, #v285)]
            v295, v296 = v297.Position, v297.Size
        else
            v295 = v276
            v296 = AbsoluteSize
        end
        local v298 = v295.X + v23:NextNumber() * v296.X
        local v299 = v295.Y + v23:NextNumber() * v296.Y
        local v300 = (v298 - v277.X) / v279
        local v301 = math.clamp(v300, -1, 1) * (150 + v23:NextNumber() * 350) + (-150 + v23:NextNumber() * 300)
        local v302 = math.clamp(v301, -500, 500)
        local v303 = -450 + v23:NextNumber() * 350
        local v304 = 360 + v23:NextNumber() * 360
        local v305 = if v23:NextNumber() < 0.5 then -1 else 1
        local v306 = v304 * v305
        local v307 = 1.2 + v23:NextNumber() * 0.30000000000000004
        if v294 and v293 <= v284 then
            local v308 = v282[(v293 - 1) % #v282 + 1]
            local v309 = v281.Y * 0.9
            local v310 = math.max(v309, 12)
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "TextShard"
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.fromOffset(v310 * 0.62 * #v308 + 4, v310)
            TextLabel.Text = v308
            TextLabel.TextColor3 = v14
            TextLabel.TextScaled = true
            TextLabel.FontFace = v274.Name.FontFace
            TextLabel.ZIndex = 3
            local UIStroke = Instance.new("UIStroke")
            UIStroke.Color = v14
            local UIStroke_2 = v274.Name:FindFirstChildOfClass("UIStroke")
            if UIStroke_2 then
                UIStroke.Thickness = UIStroke_2.Thickness
            else
                UIStroke.Thickness = 2
            end
            UIStroke.Parent = TextLabel
            addShard(TextLabel, "Text", v298, v299, v302, v303, v306, v307, 1, v310)
        else
            local v311, v312
            if v23:NextNumber() < 0.5 then
                v312 = 50 + v23:NextNumber() * 40
                v311 = 5 + v23:NextNumber() * 2
            else
                v312 = 20 + v23:NextNumber() * 20
                v311 = 8 + v23:NextNumber() * 4
            end
            local Frame = Instance.new("Frame")
            Frame.Name = "Shard"
            Frame.BackgroundColor3 = v14
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.fromOffset(v312, v311)
            Frame.ZIndex = 2
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 2)
            UICorner.Parent = Frame
            addShard(Frame, "Frame", v298, v299, v302, v303, v306, v307, 1, v312)
        end
    end
    local Icon = v274.Icon
    if not (Icon and Icon.Visible) then
        return
    end
    local v313 = Icon:Clone()
    for v314, v315 in v313:GetChildren() do
        if not v315:IsA("UICorner") then
            v315:Destroy()
        end
    end
    local AbsoluteSize_2 = Icon.AbsoluteSize
    local v316 = Icon.AbsolutePosition + AbsoluteSize_2 / 2 + v275
    v313.Size = UDim2.fromOffset(AbsoluteSize_2.X, AbsoluteSize_2.Y)
    v313.ZIndex = 1
    local v317 = (v316.X - v277.X) / v279
    local v318 = math.clamp(v317, -1, 1) * (150 + v23:NextNumber() * 350) + (-150 + v23:NextNumber() * 300)
    local v319 = math.clamp(v318, -500, 500)
    local v320 = -450 + v23:NextNumber() * 350
    local X = v316.X
    local Y = v316.Y
    local v321 = v319 * 0.5
    local v322 = v320 * 0.5
    local v323 = if v23:NextNumber() < 0.5 then -1 else 1
    local v324 = v323 * 200
    local X_2 = AbsoluteSize_2.X
    local Y_2 = AbsoluteSize_2.Y
    addShard(v313, "Icon", X, Y, v321, v322, v324, 1.5, 1.35, (math.max(X_2, Y_2)))
    local v325 = v69[#v69]
    if v313:IsA("ImageLabel") then
        v325.BaseTransparency = v313.ImageTransparency
    else
        v325.BaseTransparency = 0
    end
end

local function setShardFade(v326, v327) -- line 964
    local Gui = v326.Gui
    if v326.Kind == "Frame" then
        Gui.BackgroundTransparency = v327
    elseif v326.Kind == "Text" then
        Gui.TextTransparency = v327
        if v326.Stroke then
            v326.Stroke.Transparency = v327
        end
    elseif Gui:IsA("ImageLabel") then
        local v328 = v326.BaseTransparency or 0
        Gui.ImageTransparency = v328 + (1 - v328) * v327
    end
end

local function clearShards() -- line 979 | captures: v68, v69
    if v68 then
        v68:Disconnect()
        v68 = nil
    end
    for v329, v330 in v69 do
        v330.Gui:Destroy()
    end
    table.clear(v69)
end

local function groupDone(v331) -- line 990
    if not (v331 and v331.Count <= 0 and v331.OnDone) then
        return
    end
    local OnDone = v331.OnDone
    v331.OnDone = nil
    OnDone()
end

local function ensureShardLoop() -- line 999 | captures: v51, v68, RunService, v69
    v68 = v68 or
    RunService.RenderStepped:Connect(function(v332) -- line 1003 | captures: v51, v68, v69
        local Y = v51.Gui.AbsoluteSize.Y
        local v333 = 0.98 ^ (v332 * 60)
        local v334 = #v69
        local v335
        for v336 = v334, 1, -1 do
            local v337 = v69[v336]
            v337.Age += v332
            v337.Vy += 1600 * v337.Gravity * v332
            v337.Vx *= v333
            v337.X += v337.Vx * v332
            v337.Y += v337.Vy * v332
            v337.Rotation += v337.Spin * v332
            v337.Gui.Position = UDim2.fromOffset(v337.X, v337.Y)
            v337.Gui.Rotation = v337.Rotation
            local v338 = v337.Life - 0.3
            local v339
            if v338 < v337.Age then
                local v340 = (v337.Age - v338) / 0.3
                v339 = math.clamp(v340, 0, 1)
            else
                v339 = 0
            end
            local Gui = v337.Gui
            if v337.Kind == "Frame" then
                Gui.BackgroundTransparency = v339
            elseif v337.Kind == "Text" then
                Gui.TextTransparency = v339
                if v337.Stroke then
                    v337.Stroke.Transparency = v339
                end
            elseif Gui:IsA("ImageLabel") then
                local v341 = v337.BaseTransparency or 0
                Gui.ImageTransparency = v341 + (1 - v341) * v339
            end
            local Group, v342, v343, v344
            if v339 >= 1 or Y < v337.Y - v337.Radius / 2 then
                v337.Gui:Destroy()
                table.remove(v69, v336)
                Group = v337.Group
                if Group then
                    Group.Count -= 1
                    if Group.Count <= 0 then
                        v342 = v335 or {}
                        v344 = false
                    else
                        v343 = v335
                        v344 = true
                    end
                else
                    v343 = v335
                    v344 = true
                end
            else
                v343 = v335
                v344 = true
            end
            if not v344 then
                table.insert(v342, Group)
                v343 = v342
            end
            v335 = v343
        end
        if #v69 == 0 and v68 then
            v68:Disconnect()
            v68 = nil
        end
        if v335 then
            for v345, v346 in v335 do
                if v346 and v346.Count <= 0 and v346.OnDone then
                    local OnDone = v346.OnDone
                    v346.OnDone = nil
                    OnDone()
                end
            end
        end
    end)
end

local function shatter(v347, v348) -- line 1049 | captures: v51, v68, v261, RunService, v69
    local v349 = {
        Count = 0,
        OnDone = v348
    }
    v261 = v349
    local v350, v351 = pcall(v347)
    v261 = nil
    if not v350 then
        warn((("[BossBarFX] shatter failed: %*"):format(v351)))
    end
    if v349.Count > 0 then
        v68 = v68 or
        RunService.RenderStepped:Connect(function(v352) -- line 1003 | captures: v51, v68, v69
            local Y = v51.Gui.AbsoluteSize.Y
            local v353 = 0.98 ^ (v352 * 60)
            local v354 = #v69
            local v355
            for v356 = v354, 1, -1 do
                local v357 = v69[v356]
                v357.Age += v352
                v357.Vy += 1600 * v357.Gravity * v352
                v357.Vx *= v353
                v357.X += v357.Vx * v352
                v357.Y += v357.Vy * v352
                v357.Rotation += v357.Spin * v352
                v357.Gui.Position = UDim2.fromOffset(v357.X, v357.Y)
                v357.Gui.Rotation = v357.Rotation
                local v358 = v357.Life - 0.3
                local v359
                if v358 < v357.Age then
                    local v360 = (v357.Age - v358) / 0.3
                    v359 = math.clamp(v360, 0, 1)
                else
                    v359 = 0
                end
                local Gui = v357.Gui
                if v357.Kind == "Frame" then
                    Gui.BackgroundTransparency = v359
                elseif v357.Kind == "Text" then
                    Gui.TextTransparency = v359
                    if v357.Stroke then
                        v357.Stroke.Transparency = v359
                    end
                elseif Gui:IsA("ImageLabel") then
                    local v361 = v357.BaseTransparency or 0
                    Gui.ImageTransparency = v361 + (1 - v361) * v359
                end
                local Group, v362, v363, v364
                if v359 >= 1 or Y < v357.Y - v357.Radius / 2 then
                    v357.Gui:Destroy()
                    table.remove(v69, v356)
                    Group = v357.Group
                    if Group then
                        Group.Count -= 1
                        if Group.Count <= 0 then
                            v362 = v355 or {}
                            v364 = false
                        else
                            v363 = v355
                            v364 = true
                        end
                    else
                        v363 = v355
                        v364 = true
                    end
                else
                    v363 = v355
                    v364 = true
                end
                if not v364 then
                    table.insert(v362, Group)
                    v363 = v362
                end
                v355 = v363
            end
            if #v69 == 0 and v68 then
                v68:Disconnect()
                v68 = nil
            end
            if v355 then
                for v365, v366 in v355 do
                    if v366 and v366.Count <= 0 and v366.OnDone then
                        local OnDone = v366.OnDone
                        v366.OnDone = nil
                        OnDone()
                    end
                end
            end
        end)
    elseif v349 and v349.Count <= 0 and v349.OnDone then
        local OnDone = v349.OnDone
        v349.OnDone = nil
        OnDone()
    end
end

local function pipFillSize(v367, v368) -- line 1069
    local FillSize = v367.FillSize
    return UDim2.new(FillSize.X.Scale * v368, FillSize.X.Offset * v368, FillSize.Y.Scale, FillSize.Y.Offset)
end

local function setPipFill(v369, v370) -- line 1077 | captures: v10, v11
    local Fill = v369.Fill
    if v370 >= 1 then
        Fill.AnchorPoint = v369.FillAnchor
        Fill.Position = v369.FillPosition
        Fill.Size = v369.FillSize
    else
        local FillAnchor = v369.FillAnchor
        local FillPosition = v369.FillPosition
        local FillSize = v369.FillSize
        Fill.AnchorPoint = Vector2.new(0, FillAnchor.Y)
        Fill.Position = UDim2.new(FillPosition.X.Scale - FillAnchor.X * FillSize.X.Scale, FillPosition.X.Offset - FillAnchor.X * FillSize.X.Offset, FillPosition.Y.Scale, FillPosition.Y.Offset)
        local FillSize_2 = v369.FillSize
        Fill.Size = UDim2.new(FillSize_2.X.Scale * v370, FillSize_2.X.Offset * v370, FillSize_2.Y.Scale, FillSize_2.Y.Offset)
    end
    Fill.Visible = v369.FillVisible and v370 > 0
    local v371 = v370 <= 0
    for v372, v373 in v369.Shadows do
        if v371 then
            v372.Color = v10
        else
            v372.Color = v373
        end
    end
    for v374, v375 in v369.Gradients do
        v374.Enabled = v375 and not v371
    end
    local Slot = v369.Slot
    if v371 then
        Slot.BackgroundColor3 = v11
    else
        Slot.BackgroundColor3 = v369.SlotColor
    end
    local Slot_2 = v369.Slot
    if v371 then
        Slot_2.BackgroundTransparency = 0.45
    else
        Slot_2.BackgroundTransparency = v369.SlotTransparency
    end
    for v376, v377 in v369.Strokes do
        if v371 then
            v376.Color = v11
            v376.Transparency = 0.45
        else
            v376.Color = v377.Color
            v376.Transparency = v377.Transparency
        end
    end
end

local function pipFraction(v378) -- line 1113 | captures: v63
    return v63[v378.Name] or 1
end

local function showPips(v379, v380) -- line 1118 | captures: v65, v61, v63, setPipFill
    v65 += 1
    for v381, v382 in v61 do
        v382:Cancel()
    end
    table.clear(v61)
    for v383, v384 in v379.Pips do
        v384.Slot.BackgroundColor3 = v384.SlotColor
        v384.Scale.Scale = 1
        local v385 = if v380 then 0 else v63[v384.Name] or 1
        setPipFill(v384, v385)
    end
end

local function clearDebris() -- line 1128 | captures: v62
    for v386, v387 in v62 do
        v387:Disconnect()
        v386:Destroy()
    end
    table.clear(v62)
end

local function pieceLayer(v388) -- line 1139
    local BossBarFXPieces = v388.Gui:FindFirstChild("BossBarFXPieces")
    if not (BossBarFXPieces and BossBarFXPieces:IsA("Frame")) then
        BossBarFXPieces = Instance.new("Frame")
        BossBarFXPieces.Name = "BossBarFXPieces"
        BossBarFXPieces.BackgroundTransparency = 1
        BossBarFXPieces.BorderSizePixel = 0
        BossBarFXPieces.Size = UDim2.fromScale(1, 1)
        BossBarFXPieces.ZIndex = 50
        BossBarFXPieces.Parent = v388.Gui
    end
    return BossBarFXPieces
end

local function drainPip(v389, v390, v391) -- line 1154 | captures: TweenService, Out, v61, v63, setPipFill
    setPipFill(v389, v390)
    local Fill = v389.Fill
    Fill.Visible = v389.FillVisible
    local v392 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Out)
    local v393 = {}
    local FillSize = v389.FillSize
    v393.Size = UDim2.new(FillSize.X.Scale * v391, FillSize.X.Offset * v391, FillSize.Y.Scale, FillSize.Y.Offset)
    local v394 = TweenService:Create(Fill, v392, v393)
    if v61 then
        table.insert(v61, v394)
    end
    v394:Play()
    v394.Completed:Once(function(v395) -- line 1159 | captures: v389, v63, setPipFill
        if v395 == Enum.PlaybackState.Completed then
            setPipFill(v389, v63[v389.Name] or 1)
        end
    end)
end

local function easeBetween(v396, v397, v398, v399, v400) -- line 1167 | captures: TweenService
    local v401 = (v396 - v397) / (v398 - v397)
    local v402 = math.clamp(v401, 0, 1)
    return TweenService:GetValue(v402, v399, v400)
end

local function breakPip(v403, v404) -- line 1178 | captures: v49, RunService, TweenService, v18, v19, v20, v21, Out, play2d, v62, setPipFill, pieceLayer
    local Slot = v404.Slot
    local AbsoluteSize = Slot.AbsoluteSize
    setPipFill(v404, 0)
    play2d(v21)
    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return
    end
    local v405 = pieceLayer(v403)
    local v406 = Slot.AbsolutePosition - v405.AbsolutePosition + Vector2.new(0, AbsoluteSize.Y / 2)
    local Y = AbsoluteSize.Y
    local Frame = Instance.new("Frame")
    Frame.Name = "PipPiece"
    Frame.BackgroundColor3 = v18
    Frame.BackgroundTransparency = 0
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0, 0.5)
    Frame.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
    Frame.Position = UDim2.fromOffset(v406.X, v406.Y)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), v19)
    UIGradient.Parent = Frame
    Frame.Parent = v405
    local v407 = os.clock()
    local v408
    v408 = RunService.RenderStepped:Connect(function() -- line 1210 | captures: v408, v403, v406, Y, Frame, v407, v49, TweenService, v18, v20, Out, v62
        local v409 = os.clock() - v407
        local zero, v410, v411, v412
        if v409 >= 0.62 then
            v412 = true
        elseif Frame.Parent then
            zero = Vector2.zero
            if v409 < 0.06 then
                local Sine = Enum.EasingStyle.Sine
                local v413 = (v409 - 0) / 0.06
                local v414 = math.clamp(v413, 0, 1)
                v410 = TweenService:GetValue(v414, Sine, Out) * 3
                if v49 == v403 then
                    local BasePosition = v403.BasePosition
                    local Position = v403.Root.Position
                    v411, zero = 0, Vector2.new(Position.X.Offset - BasePosition.X.Offset, Position.Y.Offset - BasePosition.Y.Offset)
                else
                    v411 = 0
                end
            else
                local Quad = Enum.EasingStyle.Quad
                local v415 = (v409 - 0.06) / 0.2
                local v416 = math.clamp(v415, 0, 1)
                local v417 = TweenService:GetValue(v416, Quad, Out)
                local v418 = v417 * 11 + 3
                local v419 = 1.5 * Y * v417
                local Quad_2 = Enum.EasingStyle.Quad
                local In = Enum.EasingDirection.In
                local v420 = (v409 - 0.26) / 0.36
                local v421 = math.clamp(v420, 0, 1)
                local v422 = TweenService:GetValue(v421, Quad_2, In)
                v410, v411 = v418 + v422 * 8, v419 + 4.5 * Y * v422
            end
            v412 = false
        else
            v412 = true
        end
        if not v412 then
            local Sine = Enum.EasingStyle.Sine
            local InOut = Enum.EasingDirection.InOut
            local v423 = (v409 - 0.1) / 0.19999999999999998
            local v424 = math.clamp(v423, 0, 1)
            local v425 = TweenService:GetValue(v424, Sine, InOut)
            local Sine_2 = Enum.EasingStyle.Sine
            local InOut_2 = Enum.EasingDirection.InOut
            local v426 = (v409 - 0.2) / 0.42
            local v427 = math.clamp(v426, 0, 1)
            local v428 = TweenService:GetValue(v427, Sine_2, InOut_2)
            Frame.Rotation = v410
            Frame.Position = UDim2.fromOffset(v406.X + zero.X, v406.Y + v411 + zero.Y)
            Frame.BackgroundColor3 = v18:Lerp(v20, v425)
            Frame.BackgroundTransparency = v428
        else
            v408:Disconnect()
            v62[Frame] = nil
            Frame:Destroy()
        end
    end)
    v62[Frame] = v408
end

function v96() -- line 1253 | captures: v49, v51, v55, v64, v65, v67, v57, v58, v59, v60, v61, v66, flashOff, clearShards, showPips, clearDebris
    v55 += 1
    for v429, v430 in v58 do
        v430:Cancel()
    end
    table.clear(v58)
    for v431, v432 in v59 do
        v432:Cancel()
    end
    table.clear(v59)
    for v433, v434 in v60 do
        v434:Cancel()
    end
    table.clear(v60)
    for v435, v436 in v61 do
        v436:Cancel()
    end
    table.clear(v61)
    v65 += 1
    if v66.Connection then
        v66.Connection:Disconnect()
        v66.Connection = nil
    end
    v66.Draining = false
    if v67 then
        v67:Disconnect()
        v67 = nil
    end
    clearShards()
    clearDebris()
    if v51 and v51.Flash then
        v51.Flash.BackgroundTransparency = 1
    end
    local v437 = v49
    if v437 then
        flashOff(v437, 0)
        for v438, v439 in v58 do
            v439:Cancel()
        end
        table.clear(v58)
        v437.Root.Position = v437.BasePosition
        v437.Root.Rotation = v437.BaseRotation
        v437.Scale.Scale = 1
        v437.Edge.BackgroundTransparency = 1
        if v437.Chip then
            v437.Chip.Set(v437.Fill.Get())
        end
        showPips(v437)
        v64 = true
    else
        for v440, v441 in v57 do
            v441:Cancel()
        end
        table.clear(v57)
    end
end

function v22.Damage(v442, v443) -- line 1293 | captures: v52, v53, v54, v22, commas, v59, v66, bind, playHit
    if v52 or not (type(v442) == "number") or not (type(v443) == "number") or v443 <= 0 then
        return
    end
    local v444 = math.clamp(v442, 0, v443)
    if v53 then
        if v444 <= 0 then
            return
        end
        v53 = false
    end
    local v445 = bind()
    if not v445 then
        return
    end
    v54 = v443
    local v446 = v445.Fill.Get()
    local v447 = v444 / v443
    v445.Fill.Set(v447)
    if v445.HpText then
        v445.HpText.Text = string.format("%s/%s HP", commas((math.max(v444, 0))), (commas(v443)))
    end
    if v447 < v446 - 0.0001 and v445.Root.Visible and v445.Gui.Enabled and v445.Root:IsDescendantOf(game) then
        playHit(v445, v447, v446)
    elseif not (not v445.Chip or not (v445.Chip.Get() <= v447) and v445.Root.Visible and v445.Gui.Enabled and v445.Root:IsDescendantOf(game)) then
        if v66.Connection then
            v66.Connection:Disconnect()
            v66.Connection = nil
        end
        v66.Draining = false
        v445.Chip.Set(v447)
        for v448, v449 in v59 do
            v449:Cancel()
        end
        table.clear(v59)
        v445.Edge.BackgroundTransparency = 1
    end
    if v444 <= 0 then
        v22.Death()
    end
end

function v22.Death() -- line 1332 | captures: v52, v53, v54, v55, v56, v67, v96, RunService, TweenService, v16, Out, v23, play2d, commas, v58, v60, v66, ensureFx, bind, flashOn, startChip, spawnShards, shatter
    if v52 or v53 then
        return
    end
    local v450 = bind()
    v52 = true
    v56 += 1
    local v451 = v56
    if v450 then
        if v450.Root.Visible and v450.Gui.Enabled and v450.Root:IsDescendantOf(game) and ensureFx() then
            v450.Fill.Set(0)
            if v54 > 0 then
                local v452 = v54
                if v450.HpText then
                    local HpText = v450.HpText
                    local format = string.format
                    local v453 = tostring(0)
                    local v454
                    while true do
                        local v455
                        v454, v455 = v453:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
                        if v455 == 0 then
                            break
                        end
                        v453 = v454
                    end
                    HpText.Text = format("%s/%s HP", v454, (commas(v452)))
                end
            end
            if v450.Chip then
                if v66.Connection then
                    v66.To = 0
                elseif v450.Chip.Get() > 0 then
                    startChip(v450, 0)
                end
            end
            task.spawn(function() -- line 1365 | captures: v450, v451, v52, v53, v55, v56, v67, v96, RunService, TweenService, v16, Out, v23, play2d, v58, v60, v66, ensureFx, flashOn, spawnShards, shatter
                task.wait(0.25)
                if v451 ~= v56 then
                    return
                end
                v55 += 1
                for v456, v457 in v58 do
                    v457:Cancel()
                end
                table.clear(v58)
                flashOn(v450)
                local Scale = v450.Scale
                local v458 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Out)
                local v459 = { Scale = 1.03 }
                local v460 = TweenService:Create(Scale, v458, v459)
                if v60 then
                    table.insert(v60, v460)
                end
                v460:Play()
                v67 = RunService.RenderStepped:Connect(function() -- line 1376 | captures: v450, v23
                    local v461 = Vector2.new(-6 + v23:NextNumber() * 12, -6 + v23:NextNumber() * 12)
                    local v462 = -4 + v23:NextNumber() * 8
                    v450.Root.Position = v450.BasePosition + UDim2.fromOffset(v461.X, v461.Y)
                    v450.Root.Rotation = v450.BaseRotation + v462
                end)
                task.wait(0.4)
                if v451 ~= v56 then
                    return
                end
                if v67 then
                    v67:Disconnect()
                    v67 = nil
                end
                local v463 = ensureFx()
                if v463 then
                    v463.Flash.BackgroundTransparency = 0.4
                    play2d(v16)
                    local v464 = false
                    local v465
                    shatter(function() -- line 1403 | captures: v450, spawnShards
                        spawnShards(v450)
                    end, function() -- line 1405 | captures: v464, v465
                        v464 = true
                        if v465 then
                            v465()
                        end
                    end)
                    if v66.Connection then
                        v66.Connection:Disconnect()
                        v66.Connection = nil
                    end
                    v66.Draining = false
                    for v466, v467 in v58 do
                        v467:Cancel()
                    end
                    table.clear(v58)
                    v450.Root.Position = v450.BasePosition
                    v450.Root.Rotation = v450.BaseRotation
                    v450.Root.Visible = false
                    task.spawn(function() -- line 1415 | captures: v463, v451, v56, RunService, TweenService, Out, v60
                        RunService.RenderStepped:Wait()
                        if v451 ~= v56 then
                            return
                        end
                        local Flash = v463.Flash
                        local v468 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Out)
                        local v469 = { BackgroundTransparency = 1 }
                        local v470 = TweenService:Create(Flash, v468, v469)
                        if v60 then
                            table.insert(v60, v470)
                        end
                        v470:Play()
                    end)

                    function v465() -- line 1423 | captures: v451, v52, v53, v56, v96
                        if v451 ~= v56 then
                            return
                        end
                        v96()
                        v52 = false
                        v53 = true
                    end

                    if v464 then
                        v465()
                    end
                end
            end)
            return
        end
        v96()
        v450.Root.Visible = false
    end
    v52 = false
    v53 = true
end

function v22.EmptyShields() -- line 1438 | captures: v64, bind, showPips
    v64 = false
    local v471 = bind()
    if v471 then
        showPips(v471, true)
    end
end

function v22.ChargeShields() -- line 1450 | captures: v49, v64, v65, TweenService, Out, v61, v63, bind, setPipFill, showPips
    local v472 = bind()
    if not v472 then
        return
    end
    showPips(v472, true)
    local v473 = v65
    local v474 = {}
    for v475, v476 in v472.Pips do
        if (v63[v476.Name] or 1) > 0 then
            table.insert(v474, v476)
        end
    end
    if #v474 ~= 0 and v472.Root.Visible and v472.Gui.Enabled and v472.Root:IsDescendantOf(game) then
        v64 = false
        local v477 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Out)
        for v478, v479 in v474 do
            local delay = task.delay
            local v480 = (v478 - 1) * 0.18 * 0.7
            local v481 = v479
            local v482 = v478
            delay(v480, function() -- line 1472 | captures: v472, v473, v474, v477, v481, v482, v49, v64, v65, TweenService, Out, v61, v63, setPipFill
                local v483
                if v473 == v65 and v49 == v472 then
                    setPipFill(v481, 0)
                    v481.Fill.Visible = v481.FillVisible
                    local Fill = v481.Fill
                    local v484 = {}
                    local v485 = v63[v481.Name] or 1
                    local FillSize = v481.FillSize
                    v484.Size = UDim2.new(FillSize.X.Scale * v485, FillSize.X.Offset * v485, FillSize.Y.Scale, FillSize.Y.Offset)
                    v483 = TweenService:Create(Fill, v477, v484)
                    if v61 then
                        table.insert(v61, v483)
                    end
                else
                    return
                end
                v483:Play()
                task.delay(0.18, function() -- line 1479 | captures: v472, v473, v474, v481, v482, v49, v64, v65, TweenService, Out, v61, v63, setPipFill
                    local v486
                    if v473 == v65 and v49 == v472 then
                        setPipFill(v481, v63[v481.Name] or 1)
                        local Scale = v481.Scale
                        local v487 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Out)
                        local v488 = { Scale = 1.15 }
                        v486 = TweenService:Create(Scale, v487, v488)
                        if v61 then
                            table.insert(v61, v486)
                        end
                    else
                        return
                    end
                    v486:Play()
                    task.delay(0.06, function() -- line 1485 | captures: v472, v473, v481, v49, v65, TweenService, v61
                        if not (v473 == v65 and v49 == v472) then
                            return
                        end
                        local Scale = v481.Scale
                        local v489 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                        local v490 = { Scale = 1 }
                        local v491 = TweenService:Create(Scale, v489, v490)
                        if v61 then
                            table.insert(v61, v491)
                        end
                        v491:Play()
                    end)
                    if v482 == #v474 then
                        v64 = true
                        for v492, v493 in v472.Pips do
                            setPipFill(v493, v63[v493.Name] or 1)
                        end
                    end
                end)
            end)
        end
    else
        showPips(v472)
        v64 = true
    end
end

function v22.HideShields() -- line 1503 | captures: v50, bind
    v50 = true
    local v494 = bind()
    if v494 and v494.PipRow then
        v494.PipRow.Visible = false
    end
end

function v22.ShowShields() -- line 1512 | captures: v64, bind, showPips
    local v495 = bind()
    if v495 then
        showPips(v495)
    end
    v64 = true
end

function v22.SetShield(v496, v497) -- line 1525 | captures: v52, v53, v64, v63, bind, playHit, setPipFill, drainPip, breakPip
    if not (type(v496) == "string" and type(v497) == "number") then
        return
    end
    local v498 = math.clamp(v497, 0, 1)
    local v499 = v63[v496] or 1
    v63[v496] = v498
    if v64 and not v52 and not v53 then
        local v500 = bind()
        if v500 then
            local v501
            for v502, v503 in v500.Pips do
                if v503.Name == v496 then
                    v501 = v503
                end
            end
            if v501 then
                if not (v499 <= v498) and v500.Root.Visible and v500.Gui.Enabled and v500.Root:IsDescendantOf(game) then
                    playHit(v500)
                    if v498 <= 0 then
                        breakPip(v500, v501)
                    else
                        drainPip(v501, v499, v498)
                    end
                else
                    setPipFill(v501, v498)
                end
            end
        end
    end
end

function v22.Reset() -- line 1563 | captures: v52, v53, v56, v96
    v56 += 1
    v96()
    v52 = false
    v53 = false
end

return v22
