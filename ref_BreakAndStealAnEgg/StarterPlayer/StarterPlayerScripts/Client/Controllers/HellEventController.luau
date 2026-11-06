-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local HellEssenceConfig = require(ReplicatedStorage.Shared.HellEssenceConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local HellBossController = require(script.Parent.HellBossController)
local SpawnCameraController = require(script.Parent.SpawnCameraController)
local BinaryTransition = require(script.Parent.Parent.Modules.BinaryTransition)
local BossBarFX = require(script.Parent.Parent.Modules.BossBarFX)
local HpCountUp = require(script.Parent.Parent.Modules.HpCountUp)
local EssenceBar = require(script.Parent.Parent.Modules.EssenceBar)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local StackedText = require(script.Parent.Parent.Modules.StackedText)
local UiPopOffset = require(script.Parent.Parent.Modules.UiPopOffset)
local v1 = {}
local v2 = false
local v3
local v4 = {}
local v5 = {}
local v6 = {}
local v7 = 0
local ClockTime
local v8 = {}

local function resolve(v9, v10) -- line 67
    local v11 = v9
    for v12, v13 in v10 do
        v11 = v11 and v11:FindFirstChild(v13)
    end
    return v11
end

local function stash(v14) -- line 80 | captures: v4, v5, v6
    if v5[v14.ClassName] and not v4[v14] then
        v14.Parent = nil
        table.insert(v6, v14)
    end
end

local function findLightingFolder() -- line 87 | captures: ReplicatedStorage, HellEventConfig
    local v15 = ReplicatedStorage
    for v16, v17 in HellEventConfig.LightingFolderPath do
        v15 = v15 and v15:WaitForChild(v17, 5)
    end
    return v15
end

local function applyLighting() -- line 96 | captures: v2, v7, Lighting, ReplicatedStorage, HellEventConfig, v4, v5, v6, v8, stash
    local function v18(v19, ...)
        table.insert(v19, ...)
    end

    local v20 = v7
    local v21 = ReplicatedStorage
    for v22, v23 in HellEventConfig.LightingFolderPath do
        v21 = v21 and v21:WaitForChild(v23, 5)
    end
    if v2 and v20 == v7 then
        if v21 then
            local v24 = {}
            for v25, v26 in v21:GetChildren() do
                if table.find(HellEventConfig.LightingClasses, v26.ClassName) then
                    v5[v26.ClassName] = true
                    table.insert(v24, v26)
                end
            end
            for v27, v28 in Lighting:GetChildren() do
                if v5[v28.ClassName] and not v4[v28] then
                    v28.Parent = nil
                    table.insert(v6, v28)
                end
            end
            for v29, v30 in v24 do
                local v31 = v30:Clone()
                v4[v31] = true
                v31.Parent = Lighting
            end
            v18(v8, Lighting.ChildAdded:Connect(stash))
        else
            warn((("[HellEventController] ReplicatedStorage.%* not found"):format((table.concat(HellEventConfig.LightingFolderPath, ".")))))
        end
    end
end

local function restoreLighting() -- line 125 | captures: v7, Lighting, v4, v5, v6
    v7 += 1
    for v32 in v4 do
        v32:Destroy()
    end
    table.clear(v4)
    table.clear(v5)
    for v33, v34 in v6 do
        local v35 = v34
        pcall(function() -- line 134 | captures: v35, Lighting
            v35.Parent = Lighting
        end)
    end
    table.clear(v6)
end

local function applyWorld() -- line 145 | captures: ClockTime, Lighting, HellEventConfig, v8
    local function v36(v37, ...)
        table.insert(v37, ...)
    end

    ClockTime = Lighting.ClockTime
    Lighting.ClockTime = HellEventConfig.ClockTime
    v36(v8, Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function() -- line 148 | captures: ClockTime, Lighting, HellEventConfig
        if Lighting.ClockTime ~= HellEventConfig.ClockTime then
            ClockTime = Lighting.ClockTime
            Lighting.ClockTime = HellEventConfig.ClockTime
        end
    end))
end

local function restoreWorld() -- line 156 | captures: ClockTime, Lighting
    if ClockTime ~= nil then
        Lighting.ClockTime = ClockTime
        ClockTime = nil
    end
end

local PopIn = HellEventConfig.PopIn
local HpCountUp_2 = HellEventConfig.HpCountUp
local v38 = {
    ImageLabel = { "ImageTransparency", "BackgroundTransparency" },
    ImageButton = { "ImageTransparency", "BackgroundTransparency" },
    TextLabel = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" },
    TextButton = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" },
    Frame = { "BackgroundTransparency" },
    CanvasGroup = { "GroupTransparency", "BackgroundTransparency" },
    UIStroke = { "Transparency" },
    UIShadow = { "Transparency" }
}
local v39 = {}
local v40 = { __mode = "k" }
local v41 = setmetatable(v39, v40)
local v42 = 0
local v43 = 1

local function setBossHealth(v44) -- line 223 | captures: v43, v41
    v43 = v44
    for v45, v46 in v41 do
        if v46.Hp then
            v46.Hp.SetTarget(v44)
        end
    end
end

local v47 = {}

local function unwatchBoss(v48) -- line 237 | captures: v47
    local v49 = v47[v48]
    if v49 then
        v47[v48] = nil
        for v50, v51 in v49 do
            v51:Disconnect()
        end
    end
end

local function watchBoss(v52) -- line 248 | captures: HellBossConfig, BossBarFX, setBossHealth, v47
    local function v53(v54, ...)
        table.insert(v54, ...)
    end

    local function v55(v56, ...)
        table.insert(v56, ...)
    end

    local function v57(v58, ...)
        table.insert(v58, ...)
    end

    local function v59(v60, ...)
        table.insert(v60, ...)
    end

    local function v61(v62, ...)
        table.insert(v62, ...)
    end

    local v63 = v47[v52]
    if v63 then
        v47[v52] = nil
        for v64, v65 in v63 do
            v65:Disconnect()
        end
    end
    local v66 = {}
    v47[v52] = v66

    local function read() -- line 252 | captures: v52, setBossHealth
        local Health = v52:GetAttribute("Health")
        local MaxHealth = v52:GetAttribute("MaxHealth")
        if type(Health) == "number" and type(MaxHealth) == "number" and MaxHealth > 0 then
            local v67 = Health / MaxHealth
            setBossHealth((math.clamp(v67, 0, 1)))
        end
    end

    v53(v66, v52:GetAttributeChangedSignal("Health"):Connect(read))
    v55(v66, v52:GetAttributeChangedSignal("MaxHealth"):Connect(read))
    local Health = v52:GetAttribute("Health")
    local MaxHealth = v52:GetAttribute("MaxHealth")
    if type(Health) == "number" and type(MaxHealth) == "number" and MaxHealth > 0 then
        local v68 = Health / MaxHealth
        setBossHealth((math.clamp(v68, 0, 1)))
    end
    local PipOrder = HellBossConfig.Shields.PipOrder

    local function readShields() -- line 270 | captures: v52, PipOrder, BossBarFX
        local ShieldMaxHealth = v52:GetAttribute("ShieldMaxHealth")
        if type(ShieldMaxHealth) ~= "number" or ShieldMaxHealth <= 0 then
            return
        end
        local v69 = {}
        local v70 = #PipOrder
        for v71 = 1, v70 do
            local v72 = v52:GetAttribute((("ShieldHealth%*"):format(v71)))
            if type(v72) == "number" then
                local v73 = v52:GetAttribute((("ShieldSlot%*"):format(v71)))
                local v74 = { Index = v71 }
                if type(v73) ~= "number" then
                    v73 = (1/0)
                end
                v74.Slot = v73
                local v75 = v72 / ShieldMaxHealth
                v74.Fraction = math.clamp(v75, 0, 1)
                table.insert(v69, v74)
            end
        end
        table.sort(v69, function(v76, v77) -- line 287
            if v76.Slot == v77.Slot then
                return v76.Index < v77.Index
            end
            return v76.Slot < v77.Slot
        end)
        for v78, v79 in v69 do
            BossBarFX.SetShield(PipOrder[v78], v79.Fraction)
        end
    end

    local v80 = #PipOrder
    for v81 = 1, v80 do
        v57(v66, v52:GetAttributeChangedSignal((("ShieldHealth%*"):format(v81))):Connect(readShields))
        v59(v66, v52:GetAttributeChangedSignal((("ShieldSlot%*"):format(v81))):Connect(readShields))
    end
    v61(v66, v52:GetAttributeChangedSignal("ShieldMaxHealth"):Connect(readShields))
    readShields()
end

local function collectFades(v82, v83) -- line 309 | captures: v38
    local v84 = {}

    local function add(v85) -- line 311 | captures: v84, v38
        local v86 = v38[v85.ClassName]
        if v86 then
            for v87, v88 in v86 do
                local v89 = v85[v88]
                if v89 < 1 then
                    local v90 = {
                        Instance = v85,
                        Property = v88,
                        Base = v89
                    }
                    table.insert(v84, v90)
                end
            end
        end
    end

    local walk

    local function walk_2(v91) -- line 323 | captures: v83, add, walk
        add(v91)
        if not v83 then
            local CanvasGroup = v91:IsA("CanvasGroup")
            for v92, v93 in v91:GetChildren() do
                if CanvasGroup then
                    if v93:IsA("UIStroke") or v93:IsA("UIShadow") then
                        add(v93)
                    end
                else
                    walk(v93)
                end
            end
        end
    end

    walk = walk_2
    walk_2(v82)
    return v84
end

local function stateFor(v94) -- line 343 | captures: v43, HellBossConfig, HpCountUp, StackedText, PopIn, HpCountUp_2, v41, collectFades
    local v95 = v41[v94]
    if v95 then
        return v95
    end
    local v96 = {}
    for v97, v98 in PopIn.Order do
        v96[v98] = v97
    end
    local v99 = {}
    for v100, v101 in v94:GetChildren() do
        if v101:IsA("GuiObject") then
            local v102 = {
                Instance = v101,
                Size = v101.Size,
                Position = v101.Position,
                Fades = collectFades(v101)
            }
            table.insert(v99, v102)
        end
    end
    table.sort(v99, function(v103, v104) -- line 365 | captures: v96
        local v105 = v96[v103.Instance.Name] or (1/0)
        local v106 = v96[v104.Instance.Name] or (1/0)
        if v105 == v106 then
            return v103.Position.X.Scale < v104.Position.X.Scale
        end
        return v105 < v106
    end)
    local v107 = v94
    for v108, v109 in HpCountUp_2.BarPath do
        v107 = v107 and v107:FindFirstChild(v109)
    end
    local v110
    if v107 then
        v110 = HpCountUp.new(v94, HpCountUp_2)
    end
    if v110 then
        v110.SetTarget(v43)
    end
    local Title = v94:FindFirstChild("Title")
    if Title and Title:IsA("TextLabel") then
        StackedText.Set(Title, HellBossConfig.DisplayName)
    end
    local v111 = {
        Token = 0,
        Allowed = false,
        Pieces = v99,
        Tweens = {},
        Hp = v110
    }
    v41[v94] = v111
    v94:GetPropertyChangedSignal("Visible"):Connect(function() -- line 396 | captures: v94, v111
        if v94.Visible and not v111.Allowed then
            v94.Visible = false
        end
    end)
    return v111
end

local function slideFrom(v112) -- line 407 | captures: PopIn
    local FromCenter = PopIn.FromCenter
    return UDim2.new((0.5 - v112.X.Scale) * FromCenter, 0, (0.5 - v112.Y.Scale) * FromCenter, PopIn.RisePixels)
end

local function applySlide(v113, v114, v115) -- line 416 | captures: UiPopOffset
    local v116 = UDim2.new(v114.X.Scale * v115, v114.X.Offset * v115, v114.Y.Scale * v115, v114.Y.Offset * v115)
    if UiPopOffset.IsManaged(v113.Instance) then
        UiPopOffset.Set(v113.Instance, v116)
    else
        v113.Instance.Position = v113.Position + v116
    end
end

local function cancelPop(v117) -- line 425 | captures: UiPopOffset
    v117.Token += 1
    for v118, v119 in v117.Tweens do
        v119:Cancel()
    end
    table.clear(v117.Tweens)
    if v117.Slide then
        v117.Slide:Disconnect()
        v117.Slide = nil
    end
    for v120, v121 in v117.Pieces do
        UiPopOffset.Set(v121.Instance, nil)
    end
    if v117.Hp then
        v117.Hp.Stop()
    end
end

local function restorePieces(v122) -- line 445 | captures: UiPopOffset
    for v123, v124 in v122.Pieces do
        v124.Instance.Size = v124.Size
        if not UiPopOffset.IsManaged(v124.Instance) then
            v124.Instance.Position = v124.Position
        end
        for v125, v126 in v124.Fades do
            v126.Instance[v126.Property] = v126.Base
        end
    end
end

local function hideFrame(v127) -- line 457 | captures: stateFor, cancelPop, restorePieces
    local v128 = stateFor(v127)
    cancelPop(v128)
    restorePieces(v128)
    v128.Allowed = false
    v127.Visible = false
end

local v129 = {}
local v130 = { __mode = "k" }
local v131 = setmetatable(v129, v130)

local function essenceCount() -- line 468 | captures: Workspace, HellEssenceConfig
    local v132 = Workspace:GetAttribute(HellEssenceConfig.EssenceAttribute)
    local v133 = Workspace:GetAttribute(HellEssenceConfig.GoalAttribute)
    if type(v132) ~= "number" then
        v132 = 0
    end
    if type(v133) == "number" then
        return v132, v133
    end
    return v132, 1
end

local function popFrame(v134, v135) -- line 476 | captures: RunService, TweenService, Workspace, HellEssenceConfig, EssenceBar, UiPopOffset, PopIn, HpCountUp_2, stateFor, applySlide, cancelPop, restorePieces, v131
    local v136 = stateFor(v134)
    if v135 then
        v131[v134] = true
        if v136.Hp then
            v136.Hp.Release()
        end
    else
        v131[v134] = nil
        EssenceBar.Restore(v134)
    end
    cancelPop(v136)
    if v135 then
        local v137 = Workspace:GetAttribute(HellEssenceConfig.EssenceAttribute)
        local v138 = Workspace:GetAttribute(HellEssenceConfig.GoalAttribute)
        if type(v137) ~= "number" then
            v137 = 0
        end
        if type(v138) ~= "number" then
            v138 = 1
        end
        EssenceBar.Show(v134, v137, v138)
    end
    local Token = v136.Token
    local v139 = {}
    for v140, v141 in v136.Pieces do
        local Position = v141.Position
        local FromCenter = PopIn.FromCenter
        v139[v140] = UDim2.new((0.5 - Position.X.Scale) * FromCenter, 0, (0.5 - Position.Y.Scale) * FromCenter, PopIn.RisePixels)
        v141.Instance.Size = UDim2.new()
        applySlide(v141, v139[v140], 1)
        for v142, v143 in v141.Fades do
            v143.Instance[v143.Property] = 1
        end
    end
    if v136.Hp and not v135 then
        v136.Hp.Hide()
    end
    v136.Allowed = true
    v134.Visible = true

    local function play(v144, v145, v146) -- line 513 | captures: v136, TweenService
        local v147 = TweenService:Create(v144, v145, v146)
        local Tweens = v136.Tweens
        table.insert(Tweens, v147)
        v147:Play()
    end

    local Out = Enum.EasingDirection.Out
    local v148 = {}
    local v149 = 0
    for v150, v151 in v136.Pieces do
        local v152 = PopIn.StartDelay + (v150 - 1) * PopIn.Stagger
        v148[v150] = v152
        local Instance = v151.Instance
        local v153 = TweenInfo.new(PopIn.SizeTime, PopIn.SizeStyle, Out, 0, false, v152)
        local v154 = { Size = v151.Size }
        local v155 = TweenService:Create(Instance, v153, v154)
        local Tweens = v136.Tweens
        table.insert(Tweens, v155)
        v155:Play()
        local v156 = TweenInfo.new(PopIn.FadeTime, Enum.EasingStyle.Quad, Out, 0, false, v152)
        for v157, v158 in v151.Fades do
            local Instance = v158.Instance
            local v159 = { [v158.Property] = v158.Base }
            local v160 = TweenService:Create(Instance, v156, v159)
            local Tweens = v136.Tweens
            table.insert(Tweens, v160)
            v160:Play()
        end
        local SizeTime = PopIn.SizeTime
        local MoveTime = PopIn.MoveTime
        local FadeTime = PopIn.FadeTime
        local v161 = v152 + math.max(SizeTime, MoveTime, FadeTime)
        v149 = math.max(v149, v161)
        if v136.Hp and not v135 and v151.Instance.Name == HpCountUp_2.BarPath[1] then
            v136.Hp.Play(v152 + HpCountUp_2.StartDelay)
        end
    end
    local v162 = os.clock()
    local v163 = v148[#v148] and v148[#v148] + PopIn.MoveTime or 0
    local RenderStepped = RunService.RenderStepped
    v136.Slide = RenderStepped:Connect(function() -- line 542 | captures: v136, v139, Out, v148, v162, v163, TweenService, UiPopOffset, PopIn, applySlide
        local v164 = os.clock() - v162
        for v165, v166 in v136.Pieces do
            local v167 = (v164 - v148[v165]) / PopIn.MoveTime
            local v168 = math.clamp(v167, 0, 1)
            local v169 = TweenService:GetValue(v168, PopIn.MoveStyle, Out)
            applySlide(v166, v139[v165], 1 - v169)
        end
        if not (v163 <= v164 and v136.Slide) then
            return
        end
        v136.Slide:Disconnect()
        v136.Slide = nil
        for v170, v171 in v136.Pieces do
            UiPopOffset.Set(v171.Instance, nil)
        end
    end)
    task.delay(v149, function() -- line 559 | captures: v136, Token, restorePieces
        if v136.Token == Token then
            table.clear(v136.Tweens)
            restorePieces(v136)
        end
    end)
end

local function eachFrame(v172, v173) -- line 568 | captures: HellEventConfig
    for v174, v175 in HellEventConfig.ShowFrames do
        local v176 = v172
        for v177, v178 in v175 do
            v176 = v176 and v176:FindFirstChild(v178)
        end
        if v176 and v176:IsA("GuiObject") then
            v173(v176)
        else
            warn((("[HellEventController] missing MainGUI.%*"):format((table.concat(v175, ".")))))
        end
    end
end

local function applyFrames(v179) -- line 579 | captures: v2, v3, v42, Workspace, HellEssenceConfig, HellBossController, SpawnCameraController, BinaryTransition, hideFrame, v131, popFrame, eachFrame
    if not v179 then
        return
    end
    v42 += 1
    local v180 = v42
    eachFrame(v179, hideFrame)
    if v2 then
        task.spawn(function() -- line 593 | captures: v179, v180, v2, v3, v42, Workspace, HellEssenceConfig, HellBossController, SpawnCameraController, BinaryTransition, hideFrame, v131, popFrame, eachFrame
            while BinaryTransition.IsPlaying() do
                BinaryTransition.Finished.Event:Wait()
            end
            task.wait()
            while HellBossController.IsCutsceneBusy() do
                HellBossController.CutsceneEnded.Event:Wait()
            end
            if Workspace:GetAttribute(HellEssenceConfig.GatherAttribute) == true then
                if v180 == v42 and v2 and v179 == v3 and v179.Parent then
                    eachFrame(v179, function(v181) -- line 617 | captures: popFrame
                        popFrame(v181, true)
                    end)
                    while Workspace:GetAttribute(HellEssenceConfig.GatherAttribute) == true do
                        Workspace:GetAttributeChangedSignal(HellEssenceConfig.GatherAttribute):Wait()
                    end
                    if v180 == v42 and v2 and v179 == v3 and v179.Parent then
                        eachFrame(v179, hideFrame)
                        table.clear(v131)
                        task.wait(0.5)
                        while HellBossController.IsCutsceneBusy() do
                            HellBossController.CutsceneEnded.Event:Wait()
                        end
                    else
                        return
                    end
                else
                    return
                end
            end
            if not (v180 == v42 and v2 and v179 == v3 and v179.Parent) then
                return
            end
            SpawnCameraController.SnapBehind()
            eachFrame(v179, popFrame)
        end)
    end
end

local function setInHell(v182) -- line 645 | captures: v2, v3, ClockTime, v42, Lighting, Workspace, HellEssenceConfig, HellEventConfig, HellBossController, SpawnCameraController, BinaryTransition, v8, applyLighting, restoreLighting, hideFrame, v131, popFrame, eachFrame
    local function v183(v184, ...)
        table.insert(v184, ...)
    end

    if v182 ~= v2 then
        v2 = v182
        if v182 then
            ClockTime = Lighting.ClockTime
            Lighting.ClockTime = HellEventConfig.ClockTime
            v183(v8, Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function() -- line 148 | captures: ClockTime, Lighting, HellEventConfig
                if Lighting.ClockTime ~= HellEventConfig.ClockTime then
                    ClockTime = Lighting.ClockTime
                    Lighting.ClockTime = HellEventConfig.ClockTime
                end
            end))
            local v185 = v3
            if v185 then
                v42 += 1
                local v186 = v42
                eachFrame(v185, hideFrame)
                if v2 then
                    task.spawn(function() -- line 593 | captures: v185, v186, v2, v3, v42, Workspace, HellEssenceConfig, HellBossController, SpawnCameraController, BinaryTransition, hideFrame, v131, popFrame, eachFrame
                        while BinaryTransition.IsPlaying() do
                            BinaryTransition.Finished.Event:Wait()
                        end
                        task.wait()
                        while HellBossController.IsCutsceneBusy() do
                            HellBossController.CutsceneEnded.Event:Wait()
                        end
                        if Workspace:GetAttribute(HellEssenceConfig.GatherAttribute) == true then
                            if v186 == v42 and v2 and v185 == v3 and v185.Parent then
                                eachFrame(v185, function(v187) -- line 617 | captures: popFrame
                                    popFrame(v187, true)
                                end)
                                while Workspace:GetAttribute(HellEssenceConfig.GatherAttribute) == true do
                                    Workspace:GetAttributeChangedSignal(HellEssenceConfig.GatherAttribute):Wait()
                                end
                                if v186 == v42 and v2 and v185 == v3 and v185.Parent then
                                    eachFrame(v185, hideFrame)
                                    table.clear(v131)
                                    task.wait(0.5)
                                    while HellBossController.IsCutsceneBusy() do
                                        HellBossController.CutsceneEnded.Event:Wait()
                                    end
                                else
                                    return
                                end
                            else
                                return
                            end
                        end
                        if not (v186 == v42 and v2 and v185 == v3 and v185.Parent) then
                            return
                        end
                        SpawnCameraController.SnapBehind()
                        eachFrame(v185, popFrame)
                    end)
                end
            end
            applyLighting()
        else
            for v188, v189 in v8 do
                v189:Disconnect()
            end
            table.clear(v8)
            restoreLighting()
            if ClockTime ~= nil then
                Lighting.ClockTime = ClockTime
                ClockTime = nil
            end
            local v190 = v3
            if v190 then
                v42 += 1
                local v191 = v42
                eachFrame(v190, hideFrame)
                if v2 then
                    task.spawn(function() -- line 593 | captures: v190, v191, v2, v3, v42, Workspace, HellEssenceConfig, HellBossController, SpawnCameraController, BinaryTransition, hideFrame, v131, popFrame, eachFrame
                        while BinaryTransition.IsPlaying() do
                            BinaryTransition.Finished.Event:Wait()
                        end
                        task.wait()
                        while HellBossController.IsCutsceneBusy() do
                            HellBossController.CutsceneEnded.Event:Wait()
                        end
                        if Workspace:GetAttribute(HellEssenceConfig.GatherAttribute) == true then
                            if v191 == v42 and v2 and v190 == v3 and v190.Parent then
                                eachFrame(v190, function(v192) -- line 617 | captures: popFrame
                                    popFrame(v192, true)
                                end)
                                while Workspace:GetAttribute(HellEssenceConfig.GatherAttribute) == true do
                                    Workspace:GetAttributeChangedSignal(HellEssenceConfig.GatherAttribute):Wait()
                                end
                                if v191 == v42 and v2 and v190 == v3 and v190.Parent then
                                    eachFrame(v190, hideFrame)
                                    table.clear(v131)
                                    task.wait(0.5)
                                    while HellBossController.IsCutsceneBusy() do
                                        HellBossController.CutsceneEnded.Event:Wait()
                                    end
                                else
                                    return
                                end
                            else
                                return
                            end
                        end
                        if not (v191 == v42 and v2 and v190 == v3 and v190.Parent) then
                            return
                        end
                        SpawnCameraController.SnapBehind()
                        eachFrame(v190, popFrame)
                    end)
                end
            end
        end
    end
end

function v1.IsInHell() -- line 665 | captures: v2
    return v2
end

function v1.Start() -- line 669 | captures: v2, v3, v42, CollectionService, Players, Workspace, HellBossConfig, HellEssenceConfig, HellEventConfig, HellBossController, SpawnCameraController, BinaryTransition, BossBarFX, EssenceBar, MainGui, unwatchBoss, watchBoss, hideFrame, v131, popFrame, eachFrame, setInHell
    local LocalPlayer = Players.LocalPlayer
    if not HellBossConfig.Shields.Breakable then
        BossBarFX.HideShields()
    end

    local function essenceChanged() -- line 676 | captures: Workspace, HellEssenceConfig, EssenceBar, v131
        local v193 = Workspace:GetAttribute(HellEssenceConfig.EssenceAttribute)
        local v194 = Workspace:GetAttribute(HellEssenceConfig.GoalAttribute)
        if type(v193) ~= "number" then
            v193 = 0
        end
        if type(v194) ~= "number" then
            v194 = 1
        end
        for v195 in v131 do
            if v195.Parent then
                EssenceBar.Set(v195, v193, v194)
            end
        end
    end

    Workspace:GetAttributeChangedSignal(HellEssenceConfig.EssenceAttribute):Connect(essenceChanged)
    Workspace:GetAttributeChangedSignal(HellEssenceConfig.GoalAttribute):Connect(essenceChanged)
    for v196, v197 in CollectionService:GetTagged(HellBossConfig.Tag) do
        watchBoss(v197)
    end
    CollectionService:GetInstanceAddedSignal(HellBossConfig.Tag):Connect(watchBoss)
    CollectionService:GetInstanceRemovedSignal(HellBossConfig.Tag):Connect(unwatchBoss)
    MainGui.Observe(function(v198) -- line 693 | captures: v2, v3, v42, Workspace, HellEssenceConfig, HellBossController, SpawnCameraController, BinaryTransition, hideFrame, v131, popFrame, eachFrame
        v3 = v198
        if not v198 then
            return
        end
        v42 += 1
        local v199 = v42
        eachFrame(v198, hideFrame)
        if v2 then
            task.spawn(function() -- line 593 | captures: v198, v199, v2, v3, v42, Workspace, HellEssenceConfig, HellBossController, SpawnCameraController, BinaryTransition, hideFrame, v131, popFrame, eachFrame
                while BinaryTransition.IsPlaying() do
                    BinaryTransition.Finished.Event:Wait()
                end
                task.wait()
                while HellBossController.IsCutsceneBusy() do
                    HellBossController.CutsceneEnded.Event:Wait()
                end
                if Workspace:GetAttribute(HellEssenceConfig.GatherAttribute) == true then
                    if v199 == v42 and v2 and v198 == v3 and v198.Parent then
                        eachFrame(v198, function(v200) -- line 617 | captures: popFrame
                            popFrame(v200, true)
                        end)
                        while Workspace:GetAttribute(HellEssenceConfig.GatherAttribute) == true do
                            Workspace:GetAttributeChangedSignal(HellEssenceConfig.GatherAttribute):Wait()
                        end
                        if v199 == v42 and v2 and v198 == v3 and v198.Parent then
                            eachFrame(v198, hideFrame)
                            table.clear(v131)
                            task.wait(0.5)
                            while HellBossController.IsCutsceneBusy() do
                                HellBossController.CutsceneEnded.Event:Wait()
                            end
                        else
                            return
                        end
                    else
                        return
                    end
                end
                if not (v199 == v42 and v2 and v198 == v3 and v198.Parent) then
                    return
                end
                SpawnCameraController.SnapBehind()
                eachFrame(v198, popFrame)
            end)
        end
    end)

    local function sync() -- line 698 | captures: LocalPlayer, HellEventConfig, setInHell
        setInHell(LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true)
    end

    LocalPlayer:GetAttributeChangedSignal(HellEventConfig.PlayerAttribute):Connect(sync)
    setInHell(LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true)
end

return v1
