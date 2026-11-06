-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local DisplayHype = require(ReplicatedStorage.Shared.DisplayHype)
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local EggInfoUi = require(ReplicatedStorage.Shared.EggInfoUi)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local HatchVFX = require(ReplicatedStorage.Shared.HatchVFX)
local ModelScaler = require(ReplicatedStorage.Shared.ModelScaler)
local TitanicEggConfig = require(ReplicatedStorage.Shared.TitanicEggConfig)
local ZoneHitboxLookup = require(ReplicatedStorage.Shared.ZoneHitboxLookup)
local EggLocalHits = require(script.Parent.EggLocalHits)
local EggCullQuality = require(script.Parent.Parent.Modules.EggCullQuality)
local EggRarityBurst = require(script.Parent.Parent.Modules.EggRarityBurst)
local EggViewFrustum = require(script.Parent.Parent.Modules.EggViewFrustum)
local SfxBudget = require(script.Parent.Parent.Modules.SfxBudget)
local v1 = {}
local v2 = {}
local v3 = {}
local LocalPlayer = Players.LocalPlayer
local v4 = {}
local v5 = {}

local function preloadVariantSkins(v6) -- line 97 | captures: ContentProvider, EggRewards, v5
    local Variant = v6:GetAttribute("Variant")
    local EggType = v6:GetAttribute("EggType")
    local HatchAnimal, HatchAnimal_2, v7
    if typeof(Variant) == "string" then
        if Variant == "" then
            v7 = true
        elseif typeof(EggType) == "string" then
            local HatchAnimal_3 = v6:GetAttribute("HatchAnimal")
            HatchAnimal = HatchAnimal_3
            if typeof(HatchAnimal_3) == "string" then
                if HatchAnimal_3 == "" then
                    HatchAnimal = nil
                else
                    HatchAnimal_2 = HatchAnimal_3
                end
            else
                HatchAnimal = nil
            end
            v7 = false
        else
            v7 = true
        end
    else
        v7 = true
    end
    if v7 then
        return
    end
    local v8
    if HatchAnimal_2 then
        v8 = ("%*:%*"):format(Variant, HatchAnimal_2)
    else
        v8 = ("%*:%*"):format(Variant, EggType)
    end
    if v5[v8] then
        return
    end
    v5[v8] = true
    task.spawn(function() -- line 112 | captures: HatchAnimal, Variant, EggType, ContentProvider, EggRewards
        local v9 = {}
        if HatchAnimal then
            local v10 = EggRewards.FindAnimalTemplate(HatchAnimal, Variant)
            if v10 then
                table.insert(v9, v10)
            end
        end
        if #v9 == 0 then
            local v11 = EggRewards.ZoneOfEggType(EggType)
            for v12, v13 in EggRewards.Pool do
                if v13.Zone ~= nil and v13.Zone == v11 then
                    local v14 = EggRewards.FindAnimalTemplate(v13.Name, Variant)
                    if v14 then
                        table.insert(v9, v14)
                    end
                end
            end
        end
        local v15 = {}
        local v16 = {}
        for v17, v18 in v9 do
            for v19, v20 in v18:GetDescendants() do
                if v20:IsA("SurfaceAppearance") and v20.ColorMap ~= "" and not v15[v20.ColorMap] then
                    v15[v20.ColorMap] = true
                    local Decal = Instance.new("Decal")
                    Decal.Texture = v20.ColorMap
                    table.insert(v16, Decal)
                end
            end
        end
        if #v16 > 0 then
            pcall(ContentProvider.PreloadAsync, ContentProvider, v16)
            for v21, v22 in v16 do
                v22:Destroy()
            end
        end
    end)
end

local function getHitVfxTemplate() -- line 165 | captures: ReplicatedStorage, EggConfig
    local v23 = EggConfig.Hit.VFXName or "EggHit"
    local VFX = ReplicatedStorage:FindFirstChild("VFX")
    local v24 = VFX and VFX:FindFirstChild(v23)
    if v24 and v24:IsA("Attachment") then
        return v24
    end
    return nil
end

local function attachHitVfx(v25) -- line 180 | captures: ReplicatedStorage, EggConfig, HatchVFX
    local v26 = EggConfig.Hit.VFXName or "EggHit"
    local VFX = ReplicatedStorage:FindFirstChild("VFX")
    local v27 = VFX and VFX:FindFirstChild(v26)
    if not (v27 and v27:IsA("Attachment")) then
        v27 = nil
    end
    if v27 then
        local v28 = v27:Clone()
        v28.Name = "HitVFX"
        v28.Position = Vector3.new(0, 0, 0)
        local VFXScaleForWidth = EggConfig.VFXScaleForWidth
        local X = v25.Size.X
        local Z = v25.Size.Z
        local v29 = VFXScaleForWidth((math.min(X, Z)))
        local v30 = {}
        for v31, v32 in v28:GetDescendants() do
            if v32:IsA("ParticleEmitter") then
                v32.Enabled = false
                if v29 ~= 1 then
                    HatchVFX.ScaleParticle(v32, v29)
                end
                local v33 = { emitter = v32 }
                local v34 = (v32:GetAttribute("EmitCount") or v32.Rate) * v29
                local v35 = math.ceil(v34)
                v33.count = math.max(v35, 1)
                table.insert(v30, v33)
            end
        end
        v28.Parent = v25
        return {
            attachment = v28,
            emitters = v30
        }
    end
    return nil
end

local function emitHitVfx(v36) -- line 209
    if v36 and v36.attachment.Parent then
        for v37, v38 in v36.emitters do
            v38.emitter:Emit(v38.count)
        end
    end
end

local function quadOut(v39) -- line 222
    return 1 - (1 - v39) * (1 - v39)
end

local function expoOut(v40) -- line 226
    if v40 >= 1 then
        return 1
    end
    return 1 - 2 ^ (v40 * -10)
end

local function backOut(v41) -- line 231
    local v42 = v41 - 1
    return v42 * 2.70158 * v42 * v42 + 1 + v42 * 1.70158 * v42
end

local function quintOut(v43) -- line 239
    return 1 - (1 - v43) ^ 5
end

local function bounceOut(v44) -- line 244
    if v44 < 0.36363636363636365 then
        return v44 * 7.5625 * v44
    end
    if v44 < 0.7272727272727273 then
        local v45 = v44 - 0.5454545454545454
        return v45 * 7.5625 * v45 + 0.75
    end
    if v44 < 0.9090909090909091 then
        local v46 = v44 - 0.8181818181818182
        return v46 * 7.5625 * v46 + 0.9375
    end
    local v47 = v44 - 0.9545454545454546
    return v47 * 7.5625 * v47 + 0.984375
end

local v48 = 0
local v49

local function screenShake(v50, v51, v52) -- line 273 | captures: v48, v49, RunService, LocalPlayer
    v48 += 1
    local v53 = v48
    if v49 then
        v49()
        v49 = nil
    end
    local Character = LocalPlayer.Character
    local v54 = Character and Character:FindFirstChildOfClass("Humanoid")
    if not v54 then
        return
    end
    local CameraOffset = v54.CameraOffset
    local v55

    function v55() -- line 288 | captures: v55, v54, CameraOffset, v49
        if v54.Parent then
            v54.CameraOffset = CameraOffset
        end
        if v49 == v55 then
            v49 = nil
        end
    end

    v49 = v55
    local v56 = os.clock()
    local v57 = 10 / math.max(v52, 0.05)
    local v58
    v58 = RunService.RenderStepped:Connect(function() -- line 300 | captures: v55, v58, v50, v51, v53, v54, CameraOffset, v56, v57, v48
        local v59 = os.clock() - v56
        if v53 == v48 and not (v50 <= v59) and v54.Parent then
            local v60 = (v50 - v59) / (v50 * 0.25)
            local v61 = math.clamp(v60, 0, 1)
            local v62 = v59 * v57
            local v63 = math.noise(v62, 7.3) * 2 * v51 * v61
            local v64 = math.noise(v62, 17.9) * 2 * v51 * v61
            v54.CameraOffset = CameraOffset + Vector3.new(v63, v64, 0)
        else
            v58:Disconnect()
            if v53 == v48 then
                v55()
            end
        end
    end)
end

local v65 = {}

local function getSfxTemplate(v66, v67) -- line 335 | captures: SoundService, v65
    local v68 = v67 or "SFX"
    local v69 = v65[v68]
    if not (v69 and v69.Parent) then
        v69 = SoundService:FindFirstChild(v68)
        v65[v68] = v69
    end
    local v70 = v69 and v69:FindFirstChild(v66)
    if v70 and v70:IsA("Sound") then
        return v70
    end
    return nil
end

local function eggSoundRange(v71, v72) -- line 349 | captures: TitanicEggConfig
    if v71:GetAttribute("Titanic") then
        return v72 * (TitanicEggConfig.SoundRangeMult or 1)
    end
    return v72
end

local function playSfx(v73, v74, v75, v76, v77) -- line 359 | captures: Debris, SoundService, v65
    local v78 = v76 or "SFX"
    local v79 = v65[v78]
    if not (v79 and v79.Parent) then
        v79 = SoundService:FindFirstChild(v78)
        v65[v78] = v79
    end
    local v80 = v79 and v79:FindFirstChild(v73)
    if not (v80 and v80:IsA("Sound")) then
        v80 = nil
    end
    if not v80 then
        return
    end
    if v75 and v74 then
        local CurrentCamera = workspace.CurrentCamera
        local v81
        if v74:IsA("BasePart") then
            v81 = v74.Position
        elseif v74:IsA("Attachment") then
            v81 = v74.WorldPosition
        end
        if CurrentCamera and v81 and v75 < (CurrentCamera.CFrame.Position - v81).Magnitude then
            return
        end
    end
    local v82 = v80:Clone()
    if v75 then
        v82.RollOffMode = Enum.RollOffMode.LinearSquare
        local v83 = v75 / 2
        v82.RollOffMinDistance = math.min(10, v83)
        v82.RollOffMaxDistance = v75
    end
    if v77 then
        v82.PlaybackSpeed = v77
    end
    v82.Parent = v74 or SoundService
    v82.Ended:Once(function() -- line 387 | captures: v82
        v82:Destroy()
    end)
    local TimeLength = v82.TimeLength
    Debris:AddItem(v82, math.max(TimeLength, 1) + 1)
    v82:Play()
end

local function playLoopedSfx(v84, v85, v86, v87, v88, v89) -- line 400 | captures: Debris, SoundService, TweenService, v65
    local v90 = v87 or "SFX"
    local v91 = v65[v90]
    if not (v91 and v91.Parent) then
        v91 = SoundService:FindFirstChild(v90)
        v65[v90] = v91
    end
    local v92 = v91 and v91:FindFirstChild(v84)
    if not (v92 and v92:IsA("Sound")) then
        v92 = nil
    end
    if v92 then
        local v93 = v92:Clone()
        v93.Looped = true
        if v88 then
            v93.Volume = v88
        end
        v93.RollOffMode = Enum.RollOffMode.LinearSquare
        local v94 = v86 / 2
        v93.RollOffMinDistance = math.min(10, v94)
        v93.RollOffMaxDistance = v86
        v93.Parent = v85
        v93:Play()
        local v95 = false
        return function() -- line 425 | captures: v95, v89, v93, Debris, TweenService
            if v95 then
                return
            end
            v95 = true
            local v96 = v89 or 0
            if not (v96 > 0 and v93.Parent) then
                v93:Destroy()
            else
                TweenService:Create(v93, TweenInfo.new(v96, Enum.EasingStyle.Linear), { Volume = 0 }):Play()
                Debris:AddItem(v93, v96 + 0.1)
            end
        end
    end
    return function() -- line 410
    end
end

local function nestFullyReplicated(v97) -- line 443
    local v98 = v97:GetAttribute("NestParts") or 0
    if v98 <= 0 then
        return true
    end
    local v99 = 0
    for v100, v101 in v97:GetDescendants() do
        if v101:IsA("BasePart") then
            v99 += 1
        end
    end
    return v98 <= v99
end

local function setupEgg(v102) -- line 461 | captures: Players, RunService, TweenService, DisplayHype, EggConfig, EggInfoUi, EggRewards, HatchVFX, ModelScaler, TitanicEggConfig, ZoneHitboxLookup, EggLocalHits, EggCullQuality, EggRarityBurst, EggViewFrustum, SfxBudget, v2, v3, LocalPlayer, v4, preloadVariantSkins, attachHitVfx, emitHitVfx, screenShake, playSfx, playLoopedSfx, nestFullyReplicated
    local Size, CFrame_2, v103, Model, v104
    if v102:IsA("BasePart") then
        if v102:GetAttribute("_EffectsHooked") then
            v104 = true
        else
            v102:SetAttribute("_EffectsHooked", true)
            Size = v102.Size
            CFrame_2 = v102.CFrame
            local VFXScaleForWidth = EggConfig.VFXScaleForWidth
            local X = Size.X
            local Z = Size.Z
            v103 = VFXScaleForWidth((math.min(X, Z)))
            Model = v102:FindFirstAncestorOfClass("Model")
            if Model then
                if Model.PrimaryPart ~= v102 then
                    Model = nil
                end
            else
                Model = nil
            end
            v104 = false
        end
    else
        v104 = true
    end
    if v104 then
        return
    end
    local v105
    local v106 = false
    local v107 = 0
    local Model_2 = Model

    local function ensureEggRig() -- line 502 | captures: v105, v107, v102, Model_2, ModelScaler
        if not v105 and Model_2 then
            local v108 = v102:GetAttribute("EggParts") or 0
            if v108 > 0 then
                if os.clock() < v107 then
                    return false
                end
                local v109 = 0
                for v110, v111 in Model_2:GetDescendants() do
                    if v111:IsA("BasePart") then
                        v109 += 1
                    end
                end
                if v109 < v108 then
                    v107 = os.clock() + 0.25
                    return false
                end
            end
            v105 = ModelScaler.Capture(Model_2, v102.CFrame)
        end
        return true
    end

    local function canScale() -- line 531 | captures: v106, ensureEggRig
        return not v106 and ensureEggRig()
    end

    local Size_2 = Size
    local CFrame_3 = CFrame_2

    local function baseTransform(v112) -- line 536 | captures: v106, ensureEggRig, Size_2, CFrame_3
        local v113 = if (v112 or 1) ~= 1 and not v106 and ensureEggRig() then v112 else 1
        local v114 = Size_2 * v113
        local v115 = (v114.Y - Size_2.Y) / 2
        return v114, CFrame_3 + Vector3.new(0, v115, 0)
    end

    local function applyTransform(v116, v117) -- line 545 | captures: v105, v106, v102, ensureEggRig, Model_2, Size_2, ModelScaler
        local v118 = if not v106 and ensureEggRig() then v116 else 1
        if not (Model_2 and Model_2.Parent) then
            v102.Size = Size_2 * v118
            v102.CFrame = v117
        else
            local v119 = v105
            if v119 then
                ModelScaler.Apply(v119, math.max(v118, 0.001), v117)
            else
                Model_2:SetPrimaryPartCFrame(v117)
            end
        end
    end

    local function waitForWholeEgg() -- line 568 | captures: v102, ensureEggRig
        local v120 = os.clock() + 2
        while true do
            if v102.Parent then
                if ensureEggRig() then
                    break
                end
                if v120 <= os.clock() then
                    return false
                end
                task.wait()
                continue
            end
            return false
        end
        return true
    end

    local Highlight = Instance.new("Highlight")
    Highlight.Name = "HitHighlight"
    Highlight.FillColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Enabled = false

    local function showHighlight() -- line 597 | captures: v102, Model_2, Highlight
        Highlight.Adornee = Model_2 or v102
        Highlight.Parent = v102
        Highlight.Enabled = true
    end

    local function hideHighlight() -- line 606 | captures: Highlight
        Highlight.Enabled = false
        Highlight.Adornee = nil
        Highlight.Parent = nil
    end

    local v121 = attachHitVfx(v102)
    local v122 = {}
    local v123 = 0
    local v124 = false
    local v125 = false
    local v126 = 0

    local function cancelActiveTweens() -- line 623 | captures: v123, v124, v125, Size_2, CFrame_3, applyTransform, v122
        v123 += 1
        for v127, v128 in v122 do
            v128:Cancel()
        end
        table.clear(v122)
        if v124 or v125 then
            return
        end
        local v129 = ((Size_2 * 1).Y - Size_2.Y) / 2
        local v130 = CFrame_3 + Vector3.new(0, v129, 0)
        applyTransform(1, v130)
    end

    local v131 = TweenService:Create(Highlight, TweenInfo.new(EggConfig.Hit.FlashTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FillTransparency = 1 })
    v131.Completed:Connect(function(v132) -- line 652 | captures: Highlight
        if v132 ~= Enum.PlaybackState.Completed then
            return
        end
        Highlight.Enabled = false
        Highlight.Adornee = nil
        Highlight.Parent = nil
    end)

    local function playHitEffect(v133) -- line 658 | captures: v106, v123, v124, v126, v102, ensureEggRig, Model_2, Size_2, CFrame_3, applyTransform, Highlight, v121, v122, cancelActiveTweens, v131, RunService, TweenService, EggConfig, TitanicEggConfig, emitHitVfx, playSfx
        cancelActiveTweens()
        local playSfx_2, SoundName, v134, SoundRange, v135
        if v133 then
            playSfx_2 = playSfx
            SoundName = EggConfig.Hit.SoundName
            v134 = v102
            SoundRange = EggConfig.Hit.SoundRange
            if v102:GetAttribute("Titanic") then
                SoundRange *= TitanicEggConfig.SoundRangeMult or 1
            end
            v135 = false
        elseif EggConfig.Hit.SoundLocalOnly then
            v135 = true
        else
            playSfx_2 = playSfx
            SoundName = EggConfig.Hit.SoundName
            v134 = v102
            SoundRange = EggConfig.Hit.SoundRange
            if v102:GetAttribute("Titanic") then
                SoundRange *= TitanicEggConfig.SoundRangeMult or 1
            end
            v135 = false
        end
        if not v135 then
            playSfx_2(SoundName, v134, SoundRange, EggConfig.Hit.SoundFolder)
        end
        emitHitVfx(v121)
        local Hit = EggConfig.Hit
        local v136 = v123
        Highlight.FillTransparency = 0
        Highlight.Adornee = Model_2 or v102
        Highlight.Parent = v102
        Highlight.Enabled = true
        table.insert(v122, v131)
        v131:Play()
        local v137 = Hit.ShrinkTime + Hit.RecoverTime
        v126 = os.clock() + v137 + 0.1
        local v138 = os.clock()
        local v139 = 1
        task.spawn(function() -- line 695 | captures: v139, Hit, v136, v137, v138, v106, v123, v124, ensureEggRig, Size_2, CFrame_3, applyTransform, RunService, TweenService
            while true do
                local v140, v141
                if v136 == v123 then
                    local v142 = os.clock() - v138
                    if v137 <= v142 then
                        v141 = true
                    else
                        if v142 < Hit.ShrinkTime then
                            local v143 = TweenService:GetValue(v142 / Hit.ShrinkTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                            v140 = 1 + (Hit.ShrinkScale - 1) * v143
                        else
                            local v144 = TweenService:GetValue((v142 - Hit.ShrinkTime) / Hit.RecoverTime, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                            v140 = Hit.ShrinkScale + (1 - Hit.ShrinkScale) * v144
                        end
                        v141 = false
                    end
                else
                    v141 = true
                end
                if v141 then
                    break
                end
                local v145 = v140 - v139
                local v146 = math.abs(v145)
                if v139 * 0.015 <= v146 then
                    v139 = v140
                    local v147
                    if (v140 or 1) == 1 then
                        v147 = 1
                    elseif not v106 and ensureEggRig() then
                        v147 = v140
                    else
                        v147 = 1
                    end
                    local v148 = ((Size_2 * v147).Y - Size_2.Y) / 2
                    local v149 = CFrame_3 + Vector3.new(0, v148, 0)
                    applyTransform(v140, v149)
                end
                RunService.RenderStepped:Wait()
            end
            if not (v136 == v123) or v124 then
                return
            end
            local v150 = ((Size_2 * 1).Y - Size_2.Y) / 2
            local v151 = CFrame_3 + Vector3.new(0, v150, 0)
            applyTransform(1, v151)
        end)
    end

    local function playIdleWiggle(v152) -- line 731 | captures: v123, v124, v125, Size_2, CFrame_3, applyTransform, RunService
        local v153 = v123
        local v154 = math.random() * 6.283185307179586
        local WiggleAngle = v152.WiggleAngle
        local v155 = math.rad(WiggleAngle)
        local v156 = math.cos(v154)
        local v157 = math.sin(v154)
        local v158 = ((Size_2 * 1).Y - Size_2.Y) / 2
        local v159 = CFrame_3 + Vector3.new(0, v158, 0)
        local v160 = os.clock()
        while v153 == v123 do
            if v124 then
                break
            end
            if v125 then
                break
            end
            local v161 = os.clock() - v160
            local v162 = v161 / v152.WiggleTime
            if v162 >= 1 then
                break
            end
            local v163 = 6.283185307179586 * v152.WiggleRate * v161
            local v164 = v155 * math.sin(v163) * (1 - v162)
            applyTransform(1, v159 * CFrame.fromOrientation(v156 * v164, 0, v157 * v164))
            RunService.RenderStepped:Wait()
        end
        if v153 == v123 and not v124 and not v125 then
            applyTransform(1, v159)
        end
    end

    local function playIdleHop(v165) -- line 755 | captures: v123, v124, v125, Size_2, CFrame_3, applyTransform, RunService
        local v166 = v123
        local v167 = Size_2.Y * v165.HopHeightFrac
        local v168 = ((Size_2 * 1).Y - Size_2.Y) / 2
        local v169 = CFrame_3 + Vector3.new(0, v168, 0)
        local v170 = os.clock()
        while v166 == v123 do
            if v124 then
                break
            end
            if v125 then
                break
            end
            local v171 = (os.clock() - v170) / v165.HopTime
            if v171 >= 1 then
                break
            end
            local v172 = 3.141592653589793 * v171
            local v173 = math.sin(v172) * v167
            applyTransform(1, v169 + Vector3.new(0, v173, 0))
            RunService.RenderStepped:Wait()
        end
        if v166 == v123 and not v124 and not v125 then
            applyTransform(1, v169)
        end
    end

    local function idleVisible() -- line 786 | captures: v102, Size_2, CFrame_3, EggConfig, EggCullQuality, EggViewFrustum
        local CurrentCamera = workspace.CurrentCamera
        if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) then
            return (EggViewFrustum.IsVisible(CFrame_3.Position, Size_2))
        end
        return false
    end

    local function waitEffectStep() -- line 808 | captures: v102, Size_2, CFrame_3, RunService, EggConfig, EggCullQuality, EggViewFrustum
        if not v102:GetAttribute("Titanic") then
            local CurrentCamera = workspace.CurrentCamera
            if not (CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) and EggViewFrustum.IsVisible(CFrame_3.Position, Size_2)) then
                task.wait(0.1)
                return
            end
        end
        RunService.RenderStepped:Wait()
    end

    task.spawn(function() -- line 816 | captures: v124, v125, v126, v102, Size_2, CFrame_3, playIdleWiggle, playIdleHop, EggConfig, EggCullQuality, EggViewFrustum
        local Idle = EggConfig.Idle
        while true do
            local v174
            if v102.Parent then
                task.wait(Idle.MinDelay + math.random() * (Idle.MaxDelay - Idle.MinDelay))
                if v124 or v125 then
                    v174 = true
                else
                    if v102.Parent then
                        local v175 = os.clock()
                        if v126 <= v175 then
                            local CurrentCamera = workspace.CurrentCamera
                            if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) and EggViewFrustum.IsVisible(CFrame_3.Position, Size_2) then
                                if math.random() < Idle.HopChance then
                                    playIdleHop(Idle)
                                else
                                    playIdleWiggle(Idle)
                                end
                            end
                        end
                    end
                    v174 = false
                end
            else
                v174 = true
            end
            if v174 then
                break
            end
        end
    end)

    local function isNearEgg(v176) -- line 837 | captures: CFrame_3, LocalPlayer
        local Character = LocalPlayer.Character
        local v177 = Character and Character:FindFirstChild("HumanoidRootPart")
        if v177 == nil then
            return false
        end
        return (v177.Position - CFrame_3.Position).Magnitude < v176
    end

    local function isInEggZone() -- line 847 | captures: v102, CFrame_3, ZoneHitboxLookup, LocalPlayer
        local Character = LocalPlayer.Character
        local v178 = Character and Character:FindFirstChild("HumanoidRootPart")
        if v178 then
            local v179 = ZoneHitboxLookup.GetZoneIndexAt(v178.Position)
            if v179 then
                local ZoneIndex = v102:GetAttribute("ZoneIndex")
                if typeof(ZoneIndex) ~= "number" then
                    ZoneIndex = ZoneHitboxLookup.GetZoneIndexAt(CFrame_3.Position)
                end
                return v179 == ZoneIndex
            end
        end
        return false
    end

    local SpinIntroDuration = EggRewards.HatchSequence.SpinIntroDuration

    local function playSpinIntro() -- line 876 | captures: v102, Model_2, Size_2, CFrame_3, applyTransform, Highlight, SpinIntroDuration, RunService, TweenService, EggConfig, EggCullQuality, EggViewFrustum
        Highlight.FillTransparency = 1
        Highlight.Adornee = Model_2 or v102
        Highlight.Parent = v102
        Highlight.Enabled = true
        TweenService:Create(Highlight, TweenInfo.new(SpinIntroDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FillTransparency = 0 }):Play()

        local function spinProgress(v180) -- line 888
            if v180 < 0.4 then
                return v180 * 1.4285714285714286
            end
            local v181 = v180 - 0.4
            return (v181 - v181 * v181 / 1.2) * 1.4285714285714286 + 0.5714285714285715
        end

        local v182 = ((Size_2 * 1).Y - Size_2.Y) / 2
        local v183 = CFrame_3 + Vector3.new(0, v182, 0)
        local v184 = os.clock()
        while true do
            local v185, applyTransform_2, Angles, v186
            if v102.Parent then
                local v187 = (os.clock() - v184) / SpinIntroDuration
                v185 = math.clamp(v187, 0, 1)
                applyTransform_2 = applyTransform
                Angles = CFrame.Angles
                if v185 < 0.4 then
                    v186 = v185 * 1.4285714285714286
                else
                    local v188 = v185 - 0.4
                    v186 = (v188 - v188 * v188 / 1.2) * 1.4285714285714286 + 0.5714285714285715
                end
            else
                break
            end
            applyTransform_2(1, v183 * Angles(0, 18.84955592153876 * v186, 0))
            if v185 >= 1 then
                break
            end
            if v102:GetAttribute("Titanic") then
                RunService.RenderStepped:Wait()
            else
                local CurrentCamera = workspace.CurrentCamera
                if CurrentCamera == nil then
                    task.wait(0.1)
                elseif (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) and EggViewFrustum.IsVisible(CFrame_3.Position, Size_2) then
                    RunService.RenderStepped:Wait()
                else
                    task.wait(0.1)
                end
            end
        end
        applyTransform(1, v183)
    end

    local function getInfoUi() -- line 926 | captures: v102, EggInfoUi
        return EggInfoUi.Find(v102)
    end

    local X = Size.X
    local Z = Size.Z
    local v189 = math.min(X, Z)
    local v190

    local function scaleInfoUi() -- line 941 | captures: v190, v102, v189, EggInfoUi
        local v191 = EggInfoUi.Find(v102)
        if v191 then
            local v192 = if v189 > 0 then EggInfoUi.Footprint(v102) / v189 else 1
            local v193 = EggInfoUi.GrowScale(v189, v192, EggInfoUi.MaxScaleFor(v102))
            local v194 = v190
            local v195
            if v194 then
                local v196 = v193 - v190
                v195 = math.abs(v196) < 0.01
            end
            if not v194 or not v195 then
                v190 = v193
                EggInfoUi.ApplyScale(v191, v193, v102)
            end
        else
            v190 = nil
        end
    end

    local v197

    local function getLuckLabel() -- line 961 | captures: v197, v102, EggInfoUi
        local v198 = v197
        if v198 and v198.Parent then
            return v198
        end
        local v199 = EggInfoUi.Find(v102)
        local v200 = v199 and v199:FindFirstChild("LuckMulti", true)
        if not (v200 and v200:IsA("TextLabel")) then
            v200 = nil
        end
        v197 = v200
        return v197
    end

    local function spawnSizeMult() -- line 972 | captures: v102
        return v102:GetAttribute("SpawnSizeMult") or 1
    end

    local function setLuckCounterValue(v201) -- line 985 | captures: v197, v102, DisplayHype, EggInfoUi
        local v202 = v197
        if not (v202 and v202.Parent) then
            local v203 = EggInfoUi.Find(v102)
            v203 = v203 and v203:FindFirstChild("LuckMulti", true)
            if not (v203 and v203:IsA("TextLabel")) then
                v203 = nil
            end
            v197 = v203
            v202 = v197
        end
        if v202 then
            local v204 = DisplayHype.FormatLuckValue(v201)
            if v202.Text ~= v204 then
                v202.Text = v204
            end
        end
    end

    local function showLuckCounter(v205) -- line 1003 | captures: v197, v102, DisplayHype, EggInfoUi
        local v206 = EggInfoUi.Find(v102)
        if v206 then
            local v207
            for v208, v209 in v206:GetChildren() do
                if v209:IsA("GuiObject") then
                    local v210 = v209.Name == "LuckMultiList"
                    v209.Visible = v210
                    if v210 then
                        v207 = v209
                    end
                end
            end
            if v207 then
                local v211 = v197
                if v211 then
                    if not v211.Parent then
                        local v212 = EggInfoUi.Find(v102)
                        if v212 then
                            v212 = v212:FindFirstChild("LuckMulti", true)
                            if v212 then
                                if not v212:IsA("TextLabel") then
                                    v212 = nil
                                end
                            else
                                v212 = nil
                            end
                        else
                            v212 = nil
                        end
                        v197 = v212
                        v211 = v197
                    end
                else
                    local v213 = EggInfoUi.Find(v102)
                    if v213 then
                        v213 = v213:FindFirstChild("LuckMulti", true)
                        if v213 then
                            if not v213:IsA("TextLabel") then
                                v213 = nil
                            end
                        else
                            v213 = nil
                        end
                    else
                        v213 = nil
                    end
                    v197 = v213
                    v211 = v197
                end
                if v211 then
                    local v214 = v197
                    if v214 then
                        if not v214.Parent then
                            local v215 = EggInfoUi.Find(v102)
                            if v215 then
                                v215 = v215:FindFirstChild("LuckMulti", true)
                                if v215 then
                                    if not v215:IsA("TextLabel") then
                                        v215 = nil
                                    end
                                else
                                    v215 = nil
                                end
                            else
                                v215 = nil
                            end
                            v197 = v215
                            v214 = v197
                        end
                    else
                        local v216 = EggInfoUi.Find(v102)
                        if v216 then
                            v216 = v216:FindFirstChild("LuckMulti", true)
                            if v216 then
                                if not v216:IsA("TextLabel") then
                                    v216 = nil
                                end
                            else
                                v216 = nil
                            end
                        else
                            v216 = nil
                        end
                        v197 = v216
                        v214 = v197
                    end
                    if v214 then
                        local v217 = DisplayHype.FormatLuckValue(v205)
                        if v214.Text ~= v217 then
                            v214.Text = v217
                        end
                    end
                    v206.Enabled = true
                    return true
                end
            end
        end
        return false
    end

    local function hideLuckCounter() -- line 1032 | captures: v190, v102, v189, EggInfoUi
        local v218 = EggInfoUi.Find(v102)
        if not v218 then
            return
        end
        v218.Enabled = false
        EggInfoUi.ApplyScale(v218, EggInfoUi.ScaleFor(v189, EggInfoUi.MaxScaleFor(v102)), v102)
        v190 = nil
    end

    local function playShakeGrow(v219) -- line 1052 | captures: v106, v124, v197, v102, ensureEggRig, Size_2, CFrame_3, applyTransform, scaleInfoUi, showLuckCounter, RunService, DisplayHype, EggConfig, EggInfoUi, TitanicEggConfig, EggCullQuality, EggViewFrustum, SfxBudget, LocalPlayer, screenShake, playSfx, playLoopedSfx
        local function v220(v221, v222, ...)
            return (Vector3.new(v221, v222, ...))
        end

        local Grow = v219.Grow
        local v223 = v102:GetAttribute("SpawnSizeMult") or 1
        local v224 = v102:GetAttribute("HatchSizeMult") or 1
        local v225 = math.max(v224, 1)
        local Duration = Grow.Duration
        local v226 = v225 - 1
        local v227 = Grow.ScreenShakePerMult * v226
        local v228 = Grow.JitterPerMult * v226
        local JitterMax = Grow.JitterMax
        local v229 = math.min(v228, JitterMax)
        local v230 = v102:GetAttribute("WeightBracket") == "TITANIC"
        if v227 > 0 then
            local ScreenShakeDistance = v219.ScreenShakeDistance
            local Character = LocalPlayer.Character
            local v231 = Character and Character:FindFirstChild("HumanoidRootPart")
            if v231 ~= nil and (v231.Position - CFrame_3.Position).Magnitude < ScreenShakeDistance then
                screenShake(Duration + v219.ScreenShakeDurationBuffer, v227, 0.5)
            end
        end
        if v230 then
            task.delay(Grow.AuraDelayFrac * Duration, function() -- line 1069 | captures: v219, Grow, v124, CFrame_3, LocalPlayer, screenShake
                if not v124 then
                    return
                end
                local ScreenShakeDistance = v219.ScreenShakeDistance
                local Character = LocalPlayer.Character
                local v232 = Character and Character:FindFirstChild("HumanoidRootPart")
                if v232 ~= nil and (v232.Position - CFrame_3.Position).Magnitude < ScreenShakeDistance then
                    screenShake(Grow.AuraShakeDuration, Grow.AuraShakeMagnitude, 0.1)
                end
            end)
        end
        local v233 = v102:GetAttribute("Luck") or 1
        local v234, v235 = DisplayHype.LuckCountRange(v233, v223, v225, DisplayHype.ZoneIndexOf(v102))
        local v236 = showLuckCounter(v234)
        scaleInfoUi()
        local v237 = 1 + Grow.RattleSpeedPerMult * v226
        local ShakePreDuration = v219.ShakePreDuration
        local v238 = Duration * 0.5
        local v239 = math.min(ShakePreDuration, v238)
        local v240 = v219.ShakeTiltMagnitude or 8
        local v241 = math.rad(v240)
        local v242 = v219.ShakeTiltRate or 6
        local v243 = math.random() * 100
        local v244 = Grow.MinVisualMult or 1
        local v245 = math.max(v225, v244)
        local Tick = Grow.Tick
        local v246
        if v102:GetAttribute("SilentHatch") then
        else
            v246 = SfxBudget.TryAcquire("HatchAudio", EggConfig.HatchAudio.MaxConcurrent)
        end
        local Rumble
        if v246 then
            Rumble = Grow.Rumble
        else
            Tick = nil
        end
        local v247
        if Rumble then
            local SoundName = Rumble.SoundName
            local OpenSoundRange = v219.OpenSoundRange
            if v102:GetAttribute("Titanic") then
                OpenSoundRange *= TitanicEggConfig.SoundRangeMult or 1
            end
            v247 = playLoopedSfx(SoundName, v102, OpenSoundRange, Rumble.SoundFolder, Rumble.Volume, Rumble.FadeOutTime)
        end
        local v248 = os.clock()
        local v249 = 0
        local v250 = 1
        while true do
            local v251, v252, v253
            if v102.Parent then
                v251 = os.clock() - v248
                local v254 = v251 / Duration
                v252 = math.clamp(v254, 0, 1)
                if Tick and v249 <= v251 then
                    local v255 = Tick.StartPitch + (Tick.EndPitch - Tick.StartPitch) * v252
                    local SoundName = Tick.SoundName
                    local OpenSoundRange = v219.OpenSoundRange
                    if v102:GetAttribute("Titanic") then
                        OpenSoundRange *= TitanicEggConfig.SoundRangeMult or 1
                    end
                    playSfx(SoundName, v102, OpenSoundRange, "rransCustomSFX", v255)
                    v253 = v251 + Tick.StartInterval + (Tick.EndInterval - Tick.StartInterval) * v252
                else
                    v253 = v249
                end
            else
                break
            end
            local v256 = v251 / v239
            local v257 = math.clamp(v256, 0, 1)
            local v258 = 1 - (1 - v257) * (1 - v257)
            local v259 = v251 * v242 * v237 * (v252 + 1)
            local v260 = math.noise(v259, v243) * 2 * v241 * v258
            local v261 = math.noise(v243, v259) * 2 * v241 * v258
            local v262 = v245 ^ v252
            if v262 < v250 * 1.01 then
                v262 = v250
            else
                v250 = v262
            end
            local v263 = if (v262 or 1) ~= 1 and not v106 and ensureEggRig() then v262 else 1
            local v264 = ((Size_2 * v263).Y - Size_2.Y) / 2
            local v265 = CFrame_3 + Vector3.new(0, v264, 0)
            if v229 > 0 then
                v265 += v220(math.noise(v252 * Grow.ShakeRate, -v227, v227), 0, math.noise(-v252 * Grow.ShakeRate, -v227, v227)) * v229
            end
            applyTransform(v262, v265 * CFrame.fromOrientation(v260, 0, v261))
            if v236 then
                local v266 = v234 * v235 ^ v252
                local v267 = v197
                if v267 then
                    if not v267.Parent then
                        local v268 = EggInfoUi.Find(v102)
                        if v268 then
                            v268 = v268:FindFirstChild("LuckMulti", true)
                            if v268 then
                                if not v268:IsA("TextLabel") then
                                    v268 = nil
                                end
                            else
                                v268 = nil
                            end
                        else
                            v268 = nil
                        end
                        v197 = v268
                        v267 = v197
                    end
                else
                    local v269 = EggInfoUi.Find(v102)
                    if v269 then
                        v269 = v269:FindFirstChild("LuckMulti", true)
                        if v269 then
                            if not v269:IsA("TextLabel") then
                                v269 = nil
                            end
                        else
                            v269 = nil
                        end
                    else
                        v269 = nil
                    end
                    v197 = v269
                    v267 = v197
                end
                if v267 then
                    local v270 = DisplayHype.FormatLuckValue(v266)
                    if v267.Text ~= v270 then
                        v267.Text = v270
                    end
                end
            else
                v236 = showLuckCounter(v234 * v235 ^ v252)
            end
            scaleInfoUi()
            if v252 >= 1 then
                break
            end
            if v102:GetAttribute("Titanic") then
                RunService.RenderStepped:Wait()
            else
                local CurrentCamera = workspace.CurrentCamera
                if CurrentCamera == nil then
                    task.wait(0.1)
                elseif (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) and EggViewFrustum.IsVisible(CFrame_3.Position, Size_2) then
                    RunService.RenderStepped:Wait()
                else
                    task.wait(0.1)
                end
            end
            v249 = v253
        end
        local v271 = if (v245 or 1) ~= 1 and not v106 and ensureEggRig() then v245 else 1
        local v272 = ((Size_2 * v271).Y - Size_2.Y) / 2
        local v273 = CFrame_3 + Vector3.new(0, v272, 0)
        applyTransform(v245, v273)
        if v247 then
            v247()
        end
        if v246 then
            v246()
        end
        return v245
    end

    local function findHatchedPickup() -- line 1235 | captures: v102, CFrame_3, v2, v3
        local HatchId = v102:GetAttribute("HatchId")
        for v274 in v2 do
            if v274:GetAttribute("Hatched") and not v3[v274] then
                local HatchId_2 = v274:GetAttribute("HatchId")
                if HatchId == nil or HatchId_2 == nil then
                    local Position = v274:GetPivot().Position
                    local v275 = Position.X - CFrame_3.Position.X
                    local v276 = Position.Z - CFrame_3.Position.Z
                    if not (v275 * v275 + v276 * v276 >= 22500) then
                        local v277, v278 = v274:GetBoundingBox()
                        local v279 = v277.Position.X - CFrame_3.Position.X
                        local v280 = v277.Position.Z - CFrame_3.Position.Z
                        local X = v278.X
                        local Z = v278.Z
                        local v281 = math.max(X, Z) / 2 + 6
                        if v279 * v279 + v280 * v280 < v281 * v281 then
                            v3[v274] = true
                            return v274
                        end
                    end
                elseif HatchId_2 == HatchId then
                    v3[v274] = true
                    return v274
                end
            end
        end
        return nil
    end

    local function setPickupLocallyHidden(v282, v283) -- line 1277
        for v284, v285 in v282:GetDescendants() do
            if v285:IsA("BasePart") then
                if v283 then
                    v285.LocalTransparencyModifier = 1
                else
                    v285.LocalTransparencyModifier = 0
                end
            end
        end
    end

    local function stopBakedVfx(v286) -- line 1292
        for v287, v288 in v286:GetDescendants() do
            if v288:IsA("ParticleEmitter") or v288:IsA("Trail") then
                v288.Enabled = false
                v288:Clear()
            elseif v288:IsA("Beam") or v288:IsA("Light") then
                v288.Enabled = false
            elseif v288:IsA("Fire") or v288:IsA("Smoke") or v288:IsA("Sparkles") then
                v288:Destroy()
            end
        end
    end

    local v289 = v103

    local function playExplode(v290, v291, v292) -- line 1310 | captures: v106, v190, v102, ensureEggRig, Model_2, Size_2, CFrame_3, applyTransform, Highlight, v189, findHatchedPickup, stopBakedVfx, v289, RunService, EggConfig, EggInfoUi, HatchVFX, EggCullQuality, EggViewFrustum, LocalPlayer, screenShake
        local v293 = EggInfoUi.Find(v102)
        if v293 then
            v293.Enabled = false
            EggInfoUi.ApplyScale(v293, EggInfoUi.ScaleFor(v189, EggInfoUi.MaxScaleFor(v102)), v102)
            v190 = nil
        end
        local v294 = {}
        if Model_2 then
            for v295, v296 in Model_2:GetDescendants() do
                if v296:IsA("BasePart") then
                    table.insert(v294, v296)
                end
            end
        else
            table.insert(v294, v102)
        end
        for v297, v298 in v294 do
            if v298:IsA("MeshPart") then
                v298.TextureID = ""
            end
            local SurfaceAppearance = v298:FindFirstChildOfClass("SurfaceAppearance")
            if SurfaceAppearance then
                SurfaceAppearance:Destroy()
            end
            v298.Color = Color3.new(1, 1, 1)
            v298.Material = Enum.Material.SmoothPlastic
        end
        local v299 = Model_2 or v102
        stopBakedVfx(v299)
        for v300, v301 in v299:GetDescendants() do
            if v301:IsA("Decal") or v301:IsA("Texture") then
                v301.Transparency = 1
            end
        end
        if not v102:GetAttribute("NoPickup") then
            HatchVFX.Emit("Explode", v102.Position, {
                LifetimeMult = 1.5,
                Scale = v291 * v289
            })
        end
        if v102:GetAttribute("WeightBracket") == "TITANIC" then
            HatchVFX.Emit("TitanicExplode", v102.Position, {
                LifetimeMult = 1.5,
                Scale = v289
            })
            local EnableFor = HatchVFX.EnableFor
            local Position = CFrame_3.Position
            local v302 = Size_2.Y / 2
            EnableFor("TitanicExplodeAOE", Position - Vector3.new(0, v302, 0), 7)
            local ScreenShakeDistance = v290.ScreenShakeDistance
            local Character = LocalPlayer.Character
            local v303 = Character and Character:FindFirstChild("HumanoidRootPart")
            if v303 ~= nil and (v303.Position - CFrame_3.Position).Magnitude < ScreenShakeDistance then
                screenShake(2.5, 1, 0.5)
            end
        end
        local v304 = v291 * v290.ExplodeUpscaleSize
        local v305 = os.clock()
        local v306
        local v307 = v291
        local v308
        while true do
            local v309, v310
            if v102.Parent then
                local v311 = (os.clock() - v305) / v290.ExplodeDuration
                v309 = math.clamp(v311, 0, 1)
                if v309 >= 1 then
                    v310 = 1
                else
                    v310 = 1 - 2 ^ (v309 * -10)
                end
            else
                v308 = v306
                break
            end
            local v312 = v291 + (v304 - v291) * v310
            if v312 < v307 * 1.01 then
                v312 = v307
            else
                v307 = v312
            end
            local v313 = if (v312 or 1) ~= 1 and not v106 and ensureEggRig() then v312 else 1
            local v314 = ((Size_2 * v313).Y - Size_2.Y) / 2
            local v315 = CFrame_3 + Vector3.new(0, v314, 0)
            applyTransform(v312, v315)
            for v316, v317 in v294 do
                v317.Transparency = v310
            end
            if not (v306 or v102:GetAttribute("NoPickup")) then
                v306 = findHatchedPickup()
                if v306 then
                    for v318, v319 in v306:GetDescendants() do
                        if v319:IsA("BasePart") then
                            v319.LocalTransparencyModifier = 1
                        end
                    end
                    task.spawn(v292, v306)
                end
            end
            if v309 >= 1 then
                v308 = v306
                break
            end
            if v102:GetAttribute("Titanic") then
                RunService.RenderStepped:Wait()
            else
                local CurrentCamera = workspace.CurrentCamera
                if CurrentCamera == nil then
                    task.wait(0.1)
                elseif (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) and EggViewFrustum.IsVisible(CFrame_3.Position, Size_2) then
                    RunService.RenderStepped:Wait()
                else
                    task.wait(0.1)
                end
            end
        end
        for v320, v321 in v294 do
            v321.Transparency = 1
        end
        Highlight.Enabled = false
        Highlight.Adornee = nil
        Highlight.Parent = nil
        if v308 or v102:GetAttribute("NoPickup") then
            return
        end
        local v322 = os.clock() + 2
        local v323
        while true do
            if os.clock() < v322 then
                v323 = findHatchedPickup()
                if v323 then
                    break
                end
                task.wait(0.05)
                continue
            end
            return
        end
        for v324, v325 in v323:GetDescendants() do
            if v325:IsA("BasePart") then
                v325.LocalTransparencyModifier = 1
            end
        end
        task.spawn(v292, v323)
    end

    local function playRevealHighlight(v326) -- line 1440 | captures: TweenService
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "RevealHighlight"
        Highlight.Adornee = v326
        Highlight.FillColor = Color3.fromRGB(255, 255, 255)
        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        Highlight.FillTransparency = 0
        Highlight.OutlineTransparency = 0
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.Enabled = true
        Highlight.Parent = v326
        TweenService:Create(Highlight, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FillTransparency = 1 }):Play()
        task.delay(3, function() -- line 1457 | captures: Highlight, TweenService
            if not Highlight.Parent then
                return
            end
            local v327 = TweenService:Create(Highlight, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { OutlineTransparency = 1 })
            v327.Completed:Once(function() -- line 1464 | captures: Highlight
                Highlight:Destroy()
            end)
            v327:Play()
        end)
    end

    local function waitForFullRig(v328) -- line 1481
        local v329 = v328:GetAttribute("RigCount") or 0
        if not (v329 <= 0) then
            local v330 = {}
            local v331 = 0

            local function addPiece(v332) -- line 1494 | captures: v331, v330
                if (v332:IsA("BasePart") or v332:IsA("Bone")) and not v330[v332] then
                    v330[v332] = true
                    v331 += 1
                end
            end

            local v333 = v328.DescendantAdded:Connect(addPiece)
            for v334, v335 in v328:GetDescendants() do
                if (v335:IsA("BasePart") or v335:IsA("Bone")) and not v330[v335] then
                    v330[v335] = true
                    v331 += 1
                end
            end
            local v336 = os.clock() + 2
            while true do
                if v328.Parent and os.clock() < v336 then
                    if v329 <= v331 then
                        break
                    end
                    task.wait()
                    continue
                end
                v333:Disconnect()
                return false
            end
            v333:Disconnect()
        end
        return true
    end

    local function playNestPopAway() -- line 1522 | captures: v102, Size_2, CFrame_3, RunService, EggConfig, ModelScaler, EggCullQuality, EggViewFrustum, nestFullyReplicated
        local Nest = v102:FindFirstChild("Nest")
        local Value
        if not (Nest and Nest:IsA("ObjectValue")) then
        else
            Value = Nest.Value
        end
        if not (Value and Value:IsA("Model") and Value.Parent) then
            return
        end
        local NestPop = EggConfig.NestPop
        if not nestFullyReplicated(Value) then
            return
        end
        local v337 = ModelScaler.Capture(Value)
        local v338 = NestPop.PopTime + NestPop.ShrinkTime
        local v339 = os.clock()
        while true do
            local v340, v341
            if Value.Parent then
                v340 = os.clock() - v339
                if v340 < NestPop.PopTime then
                    local v342 = NestPop.PopScale - 1
                    local v343 = v340 / NestPop.PopTime
                    v341 = 1 + v342 * (1 - (1 - v343) * (1 - v343))
                else
                    local v344 = (v340 - NestPop.PopTime) / NestPop.ShrinkTime
                    local v345 = math.clamp(v344, 0, 1)
                    v341 = NestPop.PopScale * (1 - v345 * v345)
                end
            else
                break
            end
            ModelScaler.Apply(v337, (math.max(v341, 0.01)))
            if v338 <= v340 then
                break
            end
            if v102:GetAttribute("Titanic") then
                RunService.RenderStepped:Wait()
            else
                local CurrentCamera = workspace.CurrentCamera
                if CurrentCamera == nil then
                    task.wait(0.1)
                elseif (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) and EggViewFrustum.IsVisible(CFrame_3.Position, Size_2) then
                    RunService.RenderStepped:Wait()
                else
                    task.wait(0.1)
                end
            end
        end
        if Value.Parent then
            for v346, v347 in Value:GetDescendants() do
                if v347:IsA("BasePart") then
                    v347.LocalTransparencyModifier = 1
                end
            end
        end
    end

    local function playPetIntro(v348, v349, v350) -- line 1572 | captures: v106, v102, ensureEggRig, Size_2, CFrame_3, isInEggZone, playRevealHighlight, waitForFullRig, playNestPopAway, Players, RunService, EggConfig, EggRewards, HatchVFX, ModelScaler, TitanicEggConfig, EggCullQuality, EggRarityBurst, EggViewFrustum, LocalPlayer, playSfx
        if v349 and v349.Parent then
            local v351 = waitForFullRig(v349)
            if v349.Parent then
                local function playRarityBurst() -- line 1588 | captures: v349, v102, isInEggZone, EggRewards, EggRarityBurst, LocalPlayer
                    if not (v102:GetAttribute("HatchBreakerUserId") == LocalPlayer.UserId and isInEggZone()) then
                        return
                    end
                    local HatchAnimal = v102:GetAttribute("HatchAnimal")
                    if typeof(HatchAnimal) ~= "string" or HatchAnimal == "" then
                        HatchAnimal = v349.Name
                    end
                    EggRarityBurst.Play(EggRewards.RarityOf(HatchAnimal))
                end

                local function playRevealSounds() -- line 1602 | captures: v348, v102, TitanicEggConfig, playSfx
                    local OpenSoundRange = v348.OpenSoundRange
                    if v102:GetAttribute("Titanic") then
                        OpenSoundRange *= TitanicEggConfig.SoundRangeMult or 1
                    end
                    playSfx("Egg Open", v102, OpenSoundRange)
                    playSfx("Confetti", v102, OpenSoundRange, "rransCustomSFX")
                    playSfx("Reveal", v102, OpenSoundRange, "rransCustomSFX")
                end

                if v351 then
                    for v352, v353 in v349:GetDescendants() do
                        if v353:IsA("BasePart") then
                            v353.LocalTransparencyModifier = 1
                        end
                    end
                    local v354 = v349:GetPivot()
                    local v355 = Players:GetPlayerByUserId(v102:GetAttribute("HatchBreakerUserId") or 0)

                    local function faceBreaker(v356) -- line 1627 | captures: v354, v355
                        local v357 = CFrame.new(v356) * v354.Rotation
                        local v358 = v355 and v355.Character
                        local v359 = v358 and v358:FindFirstChild("HumanoidRootPart")
                        if v359 and v359:IsA("BasePart") then
                            local X = v359.Position.X
                            local Y = v356.Y
                            local Z = v359.Position.Z
                            local v360 = Vector3.new(X, Y, Z)
                            if (v360 - v356).Magnitude > 0.001 then
                                v357 = CFrame.lookAt(v356, v360)
                            end
                        end
                        return v357
                    end

                    local v361 = if (v350 or 1) ~= 1 and not v106 and ensureEggRig() then v350 else 1
                    local v362 = ((Size_2 * v361).Y - Size_2.Y) / 2
                    local v363 = (CFrame_3 + Vector3.new(0, v362, 0)).Position.Y - v354.Position.Y
                    local v364 = math.max(v363, 3)
                    local v365 = ModelScaler.Capture(v349, v354)

                    local function placePickup(v366, v367) -- line 1650 | captures: v365, ModelScaler
                        ModelScaler.Apply(v365, math.max(v366, 0.01), v367)
                    end

                    local v368 = faceBreaker(v354.Position)
                    ModelScaler.Apply(v365, 0.01, v368)
                    for v369, v370 in v349:GetDescendants() do
                        if v370:IsA("BasePart") then
                            v370.LocalTransparencyModifier = 0
                        end
                    end
                    local OpenSoundRange = v348.OpenSoundRange
                    if v102:GetAttribute("Titanic") then
                        OpenSoundRange *= TitanicEggConfig.SoundRangeMult or 1
                    end
                    playSfx("Egg Open", v102, OpenSoundRange)
                    playSfx("Confetti", v102, OpenSoundRange, "rransCustomSFX")
                    playSfx("Reveal", v102, OpenSoundRange, "rransCustomSFX")
                    playRevealHighlight(v349)
                    playRarityBurst()
                    task.spawn(playNestPopAway)
                    local v371 = os.clock()
                    while true do
                        local v372 = (os.clock() - v371) / 0.6
                        local v373 = math.clamp(v372, 0, 1)
                        local v374 = v373 - 1
                        local v375 = v374 * 2.70158 * v374 * v374 + 1 + v374 * 1.70158 * v374
                        local v376 = 18.84955592153876 * (1 - (1 - v373) ^ 5)
                        local Position = v354.Position
                        local v377 = v364 * v375
                        local v378 = faceBreaker(Position + Vector3.new(0, v377, 0)) * CFrame.Angles(0, v376, 0)
                        ModelScaler.Apply(v365, math.max(v375, 0.01), v378)
                        local v379
                        if v373 >= 1 then
                            v379 = true
                        elseif v349.Parent then
                            if v102:GetAttribute("Titanic") then
                                RunService.RenderStepped:Wait()
                            else
                                local CurrentCamera = workspace.CurrentCamera
                                if CurrentCamera == nil then
                                    task.wait(0.1)
                                elseif (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) and EggViewFrustum.IsVisible(CFrame_3.Position, Size_2) then
                                    RunService.RenderStepped:Wait()
                                else
                                    task.wait(0.1)
                                end
                            end
                            v379 = false
                        else
                            v379 = true
                        end
                        if v379 then
                            break
                        end
                    end
                    if v349.Parent then
                        local v380 = faceBreaker(v354.Position + Vector3.new(0, v364, 0))
                        ModelScaler.Apply(v365, 1, v380)
                        local v381 = os.clock()
                        while true do
                            local v382 = (os.clock() - v381) / 0.55
                            local v383 = math.clamp(v382, 0, 1)
                            local v384
                            if v383 < 0.36363636363636365 then
                                v384 = v383 * 7.5625 * v383
                            elseif v383 < 0.7272727272727273 then
                                local v385 = v383 - 0.5454545454545454
                                v384 = v385 * 7.5625 * v385 + 0.75
                            elseif v383 < 0.9090909090909091 then
                                local v386 = v383 - 0.8181818181818182
                                v384 = v386 * 7.5625 * v386 + 0.9375
                            else
                                local v387 = v383 - 0.9545454545454546
                                v384 = v387 * 7.5625 * v387 + 0.984375
                            end
                            local v388 = v364 * (1 - v384)
                            v349:PivotTo((faceBreaker(v354.Position + Vector3.new(0, v388, 0))))
                            local v389
                            if v383 >= 1 then
                                v389 = true
                            elseif v349.Parent then
                                if v102:GetAttribute("Titanic") then
                                    RunService.RenderStepped:Wait()
                                else
                                    local CurrentCamera = workspace.CurrentCamera
                                    if CurrentCamera == nil then
                                        task.wait(0.1)
                                    elseif (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) and EggViewFrustum.IsVisible(CFrame_3.Position, Size_2) then
                                        RunService.RenderStepped:Wait()
                                    else
                                        task.wait(0.1)
                                    end
                                end
                                v389 = false
                            else
                                v389 = true
                            end
                            if v389 then
                                break
                            end
                        end
                        local v390, v391 = v349:GetBoundingBox()
                        local Emit = HatchVFX.Emit
                        local Position = v354.Position
                        local v392 = v391.Y / 2
                        Emit("Impact", Position - Vector3.new(0, v392, 0), { LifetimeMult = 0.5 })
                        local v393 = os.clock()
                        while true do
                            local v394 = os.clock() - v393
                            local v395
                            if v348.PetLookDuration <= v394 then
                                v395 = true
                            elseif v349.Parent then
                                local v396 = (v348.PetLookDuration - v394) / 0.5
                                local v397 = math.clamp(v396, 0, 1)
                                local v398 = 6.283185307179586 * v394 * v348.PetFloatRate
                                local v399 = math.sin(v398)
                                local v400 = math.abs(v399) * v348.PetFloatHeight * v397
                                v349:PivotTo((faceBreaker(v354.Position + Vector3.new(0, v400, 0))))
                                if v102:GetAttribute("Titanic") then
                                    RunService.RenderStepped:Wait()
                                else
                                    local CurrentCamera = workspace.CurrentCamera
                                    if CurrentCamera == nil then
                                        task.wait(0.1)
                                    elseif (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) and EggViewFrustum.IsVisible(CFrame_3.Position, Size_2) then
                                        RunService.RenderStepped:Wait()
                                    else
                                        task.wait(0.1)
                                    end
                                end
                                v395 = false
                            else
                                v395 = true
                            end
                            if v395 then
                                break
                            end
                        end
                        if v349.Parent then
                            v349:PivotTo((faceBreaker(v354.Position)))
                        end
                    end
                else
                    for v401, v402 in v349:GetDescendants() do
                        if v402:IsA("BasePart") then
                            v402.LocalTransparencyModifier = 0
                        end
                    end
                    local OpenSoundRange = v348.OpenSoundRange
                    if v102:GetAttribute("Titanic") then
                        OpenSoundRange *= TitanicEggConfig.SoundRangeMult or 1
                    end
                    playSfx("Egg Open", v102, OpenSoundRange)
                    playSfx("Confetti", v102, OpenSoundRange, "rransCustomSFX")
                    playSfx("Reveal", v102, OpenSoundRange, "rransCustomSFX")
                    playRevealHighlight(v349)
                    playRarityBurst()
                    task.spawn(playNestPopAway)
                end
            end
        end
    end

    local function playHatchSequence() -- line 1721 | captures: v106, v124, v102, waitForWholeEgg, Highlight, cancelActiveTweens, playSpinIntro, playShakeGrow, playExplode, playPetIntro, EggRewards, preloadVariantSkins
        v124 = true
        cancelActiveTweens()
        Highlight.Enabled = false
        Highlight.Adornee = nil
        Highlight.Parent = nil
        preloadVariantSkins(v102)
        if not waitForWholeEgg() then
            v106 = true
        end
        local HatchSequence = EggRewards.HatchSequence
        playSpinIntro()
        local v403 = playShakeGrow(HatchSequence)
        playExplode(HatchSequence, v403, function(v404) -- line 1741 | captures: HatchSequence, v403, playPetIntro
            local v405, v406 = pcall(playPetIntro, HatchSequence, v404, v403)
            if not v405 then
                if v404.Parent then
                    for v407, v408 in v404:GetDescendants() do
                        if v408:IsA("BasePart") then
                            v408.LocalTransparencyModifier = 0
                        end
                    end
                end
                warn((("[EggEffects] pet intro failed for %*: %*"):format(v404.Name, v406)))
            end
        end)
    end

    local function getNest() -- line 1764 | captures: v102
        local Nest = v102:FindFirstChild("Nest")
        local Value
        if not (Nest and Nest:IsA("ObjectValue")) then
        else
            Value = Nest.Value
        end
        if Value and Value:IsA("Model") and Value.Parent then
            return Value
        end
        return nil
    end

    local function pinNest() -- line 1775 | captures: v102, ModelScaler, nestFullyReplicated
        local Nest = v102:FindFirstChild("Nest")
        local Value
        if not (Nest and Nest:IsA("ObjectValue")) then
        else
            Value = Nest.Value
        end
        if not (Value and Value:IsA("Model") and Value.Parent) then
            Value = nil
        end
        if Value and nestFullyReplicated(Value) then
            local v409 = Value:GetPivot()
            local v410, v411 = Value:GetBoundingBox()
            return {
                nest = Value,
                rig = ModelScaler.Capture(Value, v409),
                pivot = v409,
                bottomY = v410.Position.Y - v411.Y / 2
            }
        end
        return nil
    end

    local function scaleUnit(v412, v413, v414) -- line 1802 | captures: v106, ensureEggRig, Size_2, CFrame_3, applyTransform, ModelScaler
        local v415 = math.max(v413, 0.01)
        local v416 = v414 or 0
        local v417 = if (v415 or 1) ~= 1 and not v106 and ensureEggRig() then v415 else 1
        local v418 = ((Size_2 * v417).Y - Size_2.Y) / 2
        local v419 = CFrame_3 + Vector3.new(0, v418, 0)
        applyTransform(v415, v419 + Vector3.new(0, v416, 0))
        if v412 and v412.nest.Parent then
            local v420 = v412.bottomY + (v412.pivot.Position.Y - v412.bottomY) * v415 + v416
            ModelScaler.Apply(v412.rig, v415, CFrame.new(v412.pivot.Position.X, v420, v412.pivot.Position.Z) * v412.pivot.Rotation)
        end
    end

    local function playSpawnRise() -- line 1813 | captures: v124, v125, v126, v102, Size_2, CFrame_3, waitForWholeEgg, pinNest, scaleUnit, RunService, EggConfig, EggCullQuality, EggViewFrustum
        local v421 = waitForWholeEgg()
        if not v102.Parent or v124 or v125 or not v421 then
            return
        end
        local SpawnRise = EggConfig.SpawnRise
        local v422 = pinNest()
        v126 = os.clock() + SpawnRise.Duration + 0.1
        local v423 = os.clock()
        while true do
            local v424
            if v102.Parent then
                if v124 or v125 then
                    v424 = true
                else
                    local v425 = (os.clock() - v423) / SpawnRise.Duration
                    local v426 = math.clamp(v425, 0, 1)
                    scaleUnit(v422, 1 - (1 - v426) * (1 - v426))
                    if v426 >= 1 then
                        v424 = true
                    else
                        if v102:GetAttribute("Titanic") then
                            RunService.RenderStepped:Wait()
                        else
                            local CurrentCamera = workspace.CurrentCamera
                            if CurrentCamera == nil then
                                task.wait(0.1)
                            elseif (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) and EggViewFrustum.IsVisible(CFrame_3.Position, Size_2) then
                                RunService.RenderStepped:Wait()
                            else
                                task.wait(0.1)
                            end
                        end
                        v424 = false
                    end
                end
            else
                v424 = true
            end
            if v424 then
                break
            end
        end
        if v102.Parent and not v124 and not v125 then
            scaleUnit(v422, 1)
        end
    end

    local function playDespawnShrink() -- line 1843 | captures: v123, v125, v102, Model_2, Size_2, CFrame_3, stopBakedVfx, pinNest, scaleUnit, RunService, EggConfig, EggCullQuality, EggViewFrustum
        if v125 then
            return
        end
        v125 = true
        v123 += 1
        local DespawnSink = EggConfig.DespawnSink
        local v427 = pinNest()
        local v428 = os.clock()
        while true do
            local v429
            if v102.Parent then
                local v430 = (os.clock() - v428) / DespawnSink.Duration
                local v431 = math.clamp(v430, 0, 1)
                scaleUnit(v427, 1 - v431 * v431)
                if v431 >= 1 then
                    v429 = true
                else
                    if v102:GetAttribute("Titanic") then
                        RunService.RenderStepped:Wait()
                    else
                        local CurrentCamera = workspace.CurrentCamera
                        if CurrentCamera == nil then
                            task.wait(0.1)
                        elseif (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) and EggViewFrustum.IsVisible(CFrame_3.Position, Size_2) then
                            RunService.RenderStepped:Wait()
                        else
                            task.wait(0.1)
                        end
                    end
                    v429 = false
                end
            else
                v429 = true
            end
            if v429 then
                break
            end
        end
        stopBakedVfx(Model_2 or v102)
        local v432 = {}
        v432[1] = Model_2 or v102
        if v427 then
            local nest = v427.nest
            table.insert(v432, nest)
        end
        for v433, v434 in v432 do
            if v434.Parent then
                if v434:IsA("BasePart") then
                    v434.LocalTransparencyModifier = 1
                end
                for v435, v436 in v434:GetDescendants() do
                    if v436:IsA("BasePart") then
                        v436.LocalTransparencyModifier = 1
                    end
                end
            end
        end
    end

    local SpawnedAt = v102:GetAttribute("SpawnedAt")
    if SpawnedAt and workspace:GetServerTimeNow() - SpawnedAt < EggConfig.SpawnRise.MaxAge then
        task.spawn(playSpawnRise)
    end
    v102:GetAttributeChangedSignal("Despawning"):Connect(function() -- line 1896 | captures: v124, v102, playDespawnShrink
        if v102:GetAttribute("Despawning") and not v124 then
            task.spawn(playDespawnShrink)
        end
    end)
    if v102:GetAttribute("Despawning") then
        task.spawn(playDespawnShrink)
    end

    v4[v102] = function() -- line 1911 | captures: v124, v102, playHitEffect
        if not v124 and not v102:GetAttribute("Broken") then
            playHitEffect(true)
        end
    end

    v102.Destroying:Connect(function() -- line 1916 | captures: v102, Highlight, EggLocalHits, v4
        v4[v102] = nil
        EggLocalHits.Forget(v102)
        Highlight:Destroy()
    end)
    local v437 = v102:GetAttribute("Health") or 0
    v102:GetAttributeChangedSignal("Health"):Connect(function() -- line 1925 | captures: v124, v437, v102, Size_2, CFrame_3, playHitEffect, EggConfig, EggLocalHits, EggCullQuality, EggViewFrustum
        local v438 = v102:GetAttribute("Health") or 0
        local v439, v440
        if v438 < v437 then
            if v124 or EggLocalHits.ConsumeConfirm(v102) then
                v440 = true
            else
                local CurrentCamera = workspace.CurrentCamera
                if CurrentCamera == nil then
                    v439 = false
                elseif (CurrentCamera.CFrame.Position - CFrame_3.Position).Magnitude < EggCullQuality.EggDistance(EggConfig.AmbientCull.Distance, v102) then
                    v439 = EggViewFrustum.IsVisible(CFrame_3.Position, Size_2)
                else
                    v439 = false
                end
                v440 = false
            end
        else
            v440 = true
        end
        if not v440 and v439 then
            playHitEffect(false)
        end
        v437 = v438
    end)
    v102:GetAttributeChangedSignal("Hatching"):Connect(function() -- line 1945 | captures: v124, v102, playHatchSequence, EggLocalHits, v4
        if not v102:GetAttribute("Hatching") or v124 then
            return
        end
        v4[v102] = nil
        EggLocalHits.Forget(v102)
        task.spawn(playHatchSequence)
    end)
end

function v1.Start() -- line 1954 | captures: CollectionService, EggLocalHits, v2, v3, v4, setupEgg
    for v441, v442 in CollectionService:GetTagged("AnimalPickup") do
        v2[v442] = true
    end
    CollectionService:GetInstanceAddedSignal("AnimalPickup"):Connect(function(v443) -- line 1958 | captures: v2
        v2[v443] = true
    end)
    CollectionService:GetInstanceRemovedSignal("AnimalPickup"):Connect(function(v444) -- line 1961 | captures: v2, v3
        v2[v444] = nil
        v3[v444] = nil
    end)
    for v445, v446 in CollectionService:GetTagged("BreakableEgg") do
        setupEgg(v446)
    end
    CollectionService:GetInstanceAddedSignal("BreakableEgg"):Connect(setupEgg)
    EggLocalHits.OnHit(function(v447) -- line 1973 | captures: v4
        local v448 = v4[v447]
        if v448 then
            v448()
        end
    end)
end

return v1
