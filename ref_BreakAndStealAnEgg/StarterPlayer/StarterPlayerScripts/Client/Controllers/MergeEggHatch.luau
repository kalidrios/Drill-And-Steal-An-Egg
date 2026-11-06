-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AnimalOverhead = require(ReplicatedStorage.Shared.AnimalOverhead)
local EggColors = require(ReplicatedStorage.Shared.EggColors)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local MergeSfx = require(script.Parent.MergeSfx)
local SpatialSfx = require(script.Parent.Parent.Modules.SpatialSfx)
local ModelScaler = require(ReplicatedStorage.Shared.ModelScaler)
local v1 = {}
local v2 = {
    PrepSeconds = 0.4,
    ShakePassSeconds = 0.5,
    ShakeGapSeconds = 0.3,
    ShakeHz = 90,
    ImpulseOutward = 16,
    ImpulseUp = 24,
    ShellLieSeconds = 3,
    ShellFadeSeconds = 1,
    DebrisCollisionGroup = "EggDebris",
    ShellMaterialVariant = "2022 Small Stud",
    HighlightFadeSeconds = 0.5,
    GrowSeconds = 1.3,
    AdmireSeconds = 3,
    BobHeight = 1,
    FlySeconds = 0.7,
    FlyShrinkStart = 0.6,
    RootPartName = "Root",
    CorePartName = "Main",
    ShakeIntensities = { 7, 9, 13 }
}

v1.Config = v2

local function renderFor(v3, v4) -- line 89 | captures: RunService
    local v5 = os.clock()
    while true do
        local v6 = (os.clock() - v5) / v3
        local v7 = math.clamp(v6, 0, 1)
        if v4(v7) then
            break
        end
        if v7 >= 1 then
            break
        end
        RunService.Heartbeat:Wait()
    end
end

local function quadOut(v8) -- line 100
    return 1 - (1 - v8) * (1 - v8)
end

local function elasticOut(v9) -- line 104
    if v9 <= 0 then
        return 0
    end
    if v9 >= 1 then
        return 1
    end
    local v10 = 2 ^ (v9 * -10)
    local v11 = (v9 * 10 - 0.75) * 2.0943951023931953
    return v10 * math.sin(v11) + 1
end

local function expIn(v12) -- line 115
    if v12 <= 0 then
        return 0
    end
    return 2 ^ (v12 * 10 - 10)
end

local function bezier(v13, v14, v15, v16) -- line 119
    local v17 = 1 - v16
    return v13 * v17 * v17 + v14 * 2 * v17 * v16 + v15 * v16 * v16
end

local function autoControlPoint(v18, v19) -- line 124
    local v20 = (v18 + v19) / 2
    local Magnitude = ((v18 - v19) * Vector3.new(1, 0, 1)).Magnitude
    local X = v20.X
    local Y = v18.Y
    local Y_2 = v19.Y
    local v21 = math.max(Y, Y_2) + Magnitude * 0.5
    local Z = v20.Z
    return (Vector3.new(X, v21, Z))
end

local function ownerRootPosition(v22, v23) -- line 130 | captures: Players
    local v24 = Players:GetPlayerByUserId(v22)
    local v25 = v24 and v24.Character
    local v26 = v25 and v25.PrimaryPart
    if v26 then
        return v26:GetPivot().Position
    end
    return v23
end

local function lookAtFlat(v27, v28, v29) -- line 137
    local X = v28.X
    local Y = v27.Y
    local Z = v28.Z
    local v30 = Vector3.new(X, Y, Z)
    if (v27 - v30).Magnitude < 0.001 then
        return CFrame.new(v27) * v29
    end
    return CFrame.lookAt(v27, v30)
end

local function pinBottomTo(v31, v32) -- line 146
    local v33 = v31:GetPivot()
    local v34, v35 = v31:GetBoundingBox()
    local Position = v34.Position
    local v36 = v35.Y * 0.5
    local v37 = Position - Vector3.new(0, v36, 0) - v33.Position
    v31:PivotTo(CFrame.new(v32.Position - v37) * (v32 - v32.Position))
end

local function emitDescendants(v38) -- line 155
    for v39, v40 in v38:GetDescendants() do
        if v40:IsA("ParticleEmitter") then
            local EmitCount = v40:GetAttribute("EmitCount")
            if typeof(EmitCount) ~= "number" then
                EmitCount = 1
            end
            v40:Emit(EmitCount)
        end
    end
end

local function shellMaterial(v41) -- line 166 | captures: v2
    local ShellMaterialVariant = v2.ShellMaterialVariant
    local v42 = ShellMaterialVariant and game:GetService("MaterialService"):FindFirstChild(ShellMaterialVariant)
    if v42 and v42:IsA("MaterialVariant") then
        return v42.BaseMaterial, v42.Name
    end
    return v41, ""
end

local function placedEggOpen() -- line 176 | captures: MergeConfig
    local v43 = MergeConfig.EggVfxFolder()
    return v43 and v43:FindFirstChild("PlacedEggOpen")
end

local function localFolder() -- line 181 | captures: Workspace
    local MergeEggVFX_Local = Workspace:FindFirstChild("MergeEggVFX_Local")
    if MergeEggVFX_Local then
        return MergeEggVFX_Local
    end
    local Folder = Instance.new("Folder")
    Folder.Name = "MergeEggVFX_Local"
    Folder.Parent = Workspace
    return Folder
end

local function shakeEgg(v44, v45, v46) -- line 196 | captures: MergeSfx, v2, renderFor
    local v47 = v44.PrimaryPart or v44:FindFirstChildWhichIsA("BasePart", true)
    for v48, v49 in v2.ShakeIntensities do
        if v47 and v47.Parent then
            MergeSfx.Play("Shake", v47, { Mine = v46 })
        end
        local ShakePassSeconds = v2.ShakePassSeconds
        local v50 = v49
        renderFor(ShakePassSeconds, function(v51) -- line 204 | captures: v44, v45, v50, v2
            if v44.Parent == nil then
                return true
            end
            local v52 = 1 - v51
            local v53 = os.clock() * v2.ShakeHz
            local v54 = v52 * math.sin(v53) * v50
            local v55 = math.rad(v54)
            v44:PivotTo(v45 * CFrame.Angles(0, 0, v55))
            return nil
        end)
        if v44.Parent == nil then
            return
        end
        v44:PivotTo(v45)
        if v48 < #v2.ShakeIntensities then
            task.wait(v2.ShakeGapSeconds)
        end
    end
end

local function eggLook(v56) -- line 225
    local v57 = 0
    local v58 = 0
    local v59 = 0
    local v60 = 0
    local v61 = 0
    for v62, v63 in v56:GetDescendants() do
        if v63:IsA("BasePart") and v63.Transparency < 1 then
            v57 += v63.Color.R
            v58 += v63.Color.G
            v59 += v63.Color.B
            v60 += 1
            if v63.Transparency > 0.3 then
                v61 = v63.Transparency
            end
        end
    end
    local v64
    if v60 > 0 then
        v64 = Color3.new(v57 / v60, v58 / v60, v59 / v60)
    else
        v64 = Color3.fromRGB(248, 248, 248)
    end
    local v65 = if v56.PrimaryPart then v56.PrimaryPart.Material else Enum.Material.SmoothPlastic
    return v64, v65, v61
end

local function buildAnimal(v66, v67, v68) -- line 246 | captures: EggRewards, MergeConfig, ModelScaler
    local v69 = EggRewards.FindAnimalTemplate(v66, v68)
    if v69 then
        local v70 = v69:Clone()
        v70.Name = ("Hatched_%*"):format(v66)
        local AnimSaves = v70:FindFirstChild("AnimSaves")
        if AnimSaves then
            AnimSaves:Destroy()
        end
        for v71, v72 in v70:GetDescendants() do
            if v72:IsA("Humanoid") or v72:IsA("ProximityPrompt") or v72:IsA("LuaSourceContainer") then
                v72:Destroy()
            end
        end
        for v73, v74 in v70:GetDescendants() do
            if v74:IsA("BasePart") then
                v74.Anchored = true
                v74.CanCollide = false
                v74.CanQuery = false
                v74.CanTouch = false
            end
        end
        if not v70.PrimaryPart then
            v70.PrimaryPart = v70:FindFirstChildWhichIsA("BasePart", true)
        end
        local v75, v76 = v70:GetBoundingBox()
        if v76.Y > 0 then
            pcall(function() -- line 278 | captures: v66, v67, v70, v76, EggRewards, MergeConfig, ModelScaler
                local v77 = MergeConfig.MergedScale(v66, v67)
                ModelScaler.ScaleBy(v70, EggRewards.PlacedScaleFactor(v76, EggRewards.TargetHeight * v77))
            end)
        end
        return v70
    end
    return nil
end

local v78 = {}
local v79 = { __mode = "k" }
local v80 = setmetatable(v78, v79)

local function setModelFade(v81, v82) -- line 290 | captures: v80
    local v83 = v80[v81]
    if not v83 then
        v83 = {}
        for v84, v85 in v81:GetDescendants() do
            if v85:IsA("BasePart") or v85:IsA("Decal") then
                table.insert(v83, v85)
            end
        end
        v80[v81] = v83
    end
    for v86, v87 in v83 do
        v87.LocalTransparencyModifier = v82
    end
end

function v1.Play(v88) -- line 318 | captures: Debris, Players, ReplicatedStorage, TweenService, Workspace, AnimalOverhead, EggColors, EggRewards, MergeConfig, MergeSfx, SpatialSfx, v2, renderFor, lookAtFlat, pinBottomTo, emitDescendants, shakeEgg, eggLook, buildAnimal, setModelFade
    task.spawn(function() -- line 319 | captures: v88, Debris, Players, ReplicatedStorage, TweenService, Workspace, AnimalOverhead, EggColors, EggRewards, MergeConfig, MergeSfx, SpatialSfx, v2, renderFor, lookAtFlat, pinBottomTo, emitDescendants, shakeEgg, eggLook, buildAnimal, setModelFade
        local Egg = v88.Egg
        local v89 = SpatialSfx.IsMe(v88.OwnerUserId)
        local MergeEggVFX_Local = Workspace:FindFirstChild("MergeEggVFX_Local")
        if not MergeEggVFX_Local then
            MergeEggVFX_Local = Instance.new("Folder")
            MergeEggVFX_Local.Name = "MergeEggVFX_Local"
            MergeEggVFX_Local.Parent = Workspace
        end
        for v90, v91 in Egg:GetDescendants() do
            if v91:IsA("BasePart") then
                v91.CanCollide = false
                v91.CanQuery = false
            end
        end
        local v92 = Egg:GetPivot()
        local v93, v94 = Egg:GetBoundingBox()
        local v95 = MergeConfig.EggVfxFolder()
        local v96 = v95 and v95:FindFirstChild("PlacedEggOpen")
        local v97
        if v96 then
            v97 = v96:FindFirstChild("EggExplode")
            v96 = v96:FindFirstChild("Trail")
        else
            v97 = v96
        end
        local v98, v99
        if v97 and v97:IsA("Model") then
            v98 = v97:Clone()
            local v100 = v98:FindFirstChild(v2.RootPartName)
            if v100 and v100:IsA("BasePart") then
                v100.CanCollide = false
                v100.CanQuery = false
                v100.CanTouch = false
            end
            local v101 = if v100 and v100:IsA("BasePart") and v100.Size.Y > 0 then v94.Y / v100.Size.Y else 0
            if v100 and v101 > 0 and v101 == v101 and v101 < (1/0) then
                v98:ScaleTo(v98:GetScale() * v101)
                v98:PivotTo(v93 * v100.CFrame:ToObjectSpace(v98:GetPivot()))
            else
                v98:PivotTo(v92)
            end
            v99 = v98:FindFirstChild(v2.CorePartName)
            if v99 and v99:IsA("BasePart") then
                v99.Anchored = true
                v99.Parent = MergeEggVFX_Local
                Debris:AddItem(v99, 60)
            else
                v99 = nil
            end
            v98.Parent = ReplicatedStorage
        else
            warn((("[MergeEggHatch] ReplicatedStorage.Assets[\"%*\"].PlacedEggOpen.EggExplode missing"):format(MergeConfig.VfxFolderName)))
        end
        task.wait(v2.PrepSeconds)
        local Position = v93.Position
        local v102 = v94.Y * 0.5
        local v103 = Position - Vector3.new(0, v102, 0) + Vector3.new(0, 0.20000000298023224, 0)
        local OwnerUserId = v88.OwnerUserId
        local v104 = Players:GetPlayerByUserId(OwnerUserId)
        local v105 = v104 and v104.Character
        local v106 = v105 and v105.PrimaryPart
        local v107 = if v106 then v106:GetPivot().Position else v103
        local v108 = v92 - v92.Position
        local X = v107.X
        local Y = v103.Y
        local Z = v107.Z
        local v109 = Vector3.new(X, Y, Z)
        local v110
        if (v103 - v109).Magnitude < 0.001 then
            v110 = CFrame.new(v103) * v108
        else
            v110 = CFrame.lookAt(v103, v109)
        end
        shakeEgg(Egg, v92, v89)
        local v111, v112, v113 = eggLook(Egg)
        local v114 = EggColors.GetPalette(v88.Name)
        if v114 then
            v111 = v114[1].Color
        end
        local v115 = Egg:GetPivot()
        Egg:Destroy()
        if v98 then
            v98.Parent = MergeEggVFX_Local
            for v116, v117 in v98:GetDescendants() do
                if v117:IsA("BasePart") and v117.Name ~= v2.RootPartName then
                    v117.Anchored = false
                    v117.CollisionGroup = v2.DebrisCollisionGroup
                end
            end
            local v118 = {}
            if v114 then
                local v119 = {}
                for v120, v121 in v98:GetDescendants() do
                    if v121:IsA("BasePart") and v121.Name ~= v2.RootPartName then
                        table.insert(v119, v121)
                    end
                end
                for v122, v123 in EggColors.Spread(v114, #v119) do
                    v118[v119[v122]] = v123
                end
            end
            local v124 = {}
            for v125, v126 in v98:GetChildren() do
                if v126:IsA("Model") then
                    local v127 = v126.PrimaryPart or v126:FindFirstChildWhichIsA("BasePart")
                    if v127 then
                        local v128, v129 = v126:GetBoundingBox()
                        local Part = Instance.new("Part")
                        Part.Transparency = 1
                        Part.CanCollide = false
                        Part.CanQuery = false
                        Part.CanTouch = false
                        Part.Massless = true
                        Part.CFrame = v128
                        Part.Size = v129
                        local WeldConstraint = Instance.new("WeldConstraint")
                        WeldConstraint.Part0 = Part
                        WeldConstraint.Part1 = v127
                        WeldConstraint.Parent = Part
                        Part.Parent = v126
                        v124[Part] = true
                        if v96 and v96:IsA("Trail") then
                            local Attachment = Instance.new("Attachment")
                            local v130 = v129.Y / 2
                            Attachment.Position = Vector3.new(0, v130, 0)
                            Attachment.Parent = Part
                            local Attachment_2 = Instance.new("Attachment")
                            local v131 = -v129.Y / 2
                            Attachment_2.Position = Vector3.new(0, v131, 0)
                            Attachment_2.Parent = Part
                            local v132 = v96:Clone()
                            v132.Attachment0 = Attachment
                            v132.Attachment1 = Attachment_2
                            v132.Color = ColorSequence.new(v118[v127] or v111)
                            v132.Enabled = true
                            v132.Parent = Attachment
                        end
                    end
                end
            end
            if v99 then
                MergeSfx.Play("EggCrack", v99, { Mine = v89 })
            end
            local ShellMaterialVariant = v2.ShellMaterialVariant
            local v133 = ShellMaterialVariant and game:GetService("MaterialService"):FindFirstChild(ShellMaterialVariant)
            local v134
            if not (v133 and v133:IsA("MaterialVariant")) then
                v134 = ""
            else
                v112, v134 = v133.BaseMaterial, v133.Name
            end
            local v135 = if v99 then v99.Position else v93.Position
            for v136, v137 in v98:GetDescendants() do
                if v137:IsA("BasePart") and v137.Name ~= v2.RootPartName and not v124[v137] then
                    v137.Transparency = v113
                    v137.Color = v118[v137] or v111
                    v137.Material = v112
                    v137.MaterialVariant = v134
                    local v138 = CFrame.new(v135, v137.Position).LookVector * v2.ImpulseOutward
                    local ImpulseUp = v2.ImpulseUp
                    v137:ApplyImpulse((v138 + Vector3.new(0, ImpulseUp, 0)) * v137.AssemblyMass)
                end
            end
            local delay = task.delay
            local ShellLieSeconds = v2.ShellLieSeconds
            local v139 = v98
            delay(ShellLieSeconds, function() -- line 483 | captures: v124, v139, Debris, TweenService, v2
                for v140, v141 in v139:GetDescendants() do
                    if v141:IsA("BasePart") and not v124[v141] and v141.Name ~= v2.RootPartName then
                        TweenService:Create(v141, TweenInfo.new(v2.ShellFadeSeconds), { Transparency = 1 }):Play()
                    end
                end
                Debris:AddItem(v139, v2.ShellFadeSeconds)
            end)
        end
        if v99 then
            local v142 = EggRewards.RarityOf(v88.Name)
            local v143 = v142 and EggRewards.RarityColors[v142] or Color3.new(1, 1, 1)
            for v144, v145 in v99:GetChildren() do
                if v145:IsA("Attachment") then
                    for v146, v147 in v145:GetDescendants() do
                        if v147:IsA("ParticleEmitter") then
                            local new = ColorSequence.new
                            local v148 = if v147.Name == "ColorMe" then v111 else v143
                            v147.Color = new(v148)
                        end
                    end
                    emitDescendants(v145)
                end
            end
        end
        local v149 = MergeConfig.EggVfxFolder()
        local v150 = v149 and v149:FindFirstChild("EggPoof")
        if v150 and v150:IsA("BasePart") then
            local v151 = v150:Clone()
            v151.Anchored = true
            v151.CanCollide = false
            v151.CanQuery = false
            v151.CanTouch = false
            v151.CFrame = v115
            v151.Parent = MergeEggVFX_Local
            emitDescendants(v151)
            Debris:AddItem(v151, 6)
        end
        local v152 = buildAnimal(v88.Name, v88.Kg, v88.Variant)
        if not v152 then
            return
        end
        local v153 = v152:GetScale()
        v152:ScaleTo(v153 * 0.5)
        pinBottomTo(v152, v110)
        v152.Parent = MergeEggVFX_Local
        if v152.PrimaryPart then
            MergeSfx.Play("EggOpen", v152.PrimaryPart, { Mine = v89 })
            MergeSfx.Play("Confetti", v152.PrimaryPart, { Mine = v89 })
            local Play = MergeSfx.Play
            local PrimaryPart = v152.PrimaryPart
            local v154 = { Mine = v89 }
            if v89 then
                v154.VolumeScale = MergeConfig.RevealOwnVolumeScale
            else
                v154.VolumeScale = nil
            end
            Play("Reveal", PrimaryPart, v154)
        end
        local v155 = MergeConfig.MergedSizeMult(v88.Name, v88.Kg)
        local v156 = AnimalOverhead.Attach(v152, {
            CashPerSecond = EggRewards.PlacedCashPerSecond(v88.Name, v155, nil, v88.Kg, v88.Variant),
            Rarity = EggRewards.RarityOf(v88.Name),
            SizeMult = v155,
            Variant = v88.Variant
        })
        local Highlight = Instance.new("Highlight")
        Highlight.FillColor = Color3.new(1, 1, 1)
        Highlight.FillTransparency = 0
        Highlight.OutlineTransparency = 1
        Highlight.Adornee = v152
        Highlight.Parent = v152
        TweenService:Create(Highlight, TweenInfo.new(v2.HighlightFadeSeconds), { FillTransparency = 1 }):Play()
        local v157 = v153 * 0.5
        local AdmireSeconds = v2.AdmireSeconds
        local v158 = v110
        renderFor(AdmireSeconds, function(v159) -- line 576 | captures: v157, v152, v153, v158, v88, Players, v2, pinBottomTo
            if v152.Parent == nil then
                return true
            end
            local v160 = v159 * v2.AdmireSeconds
            local v161 = v160 / v2.GrowSeconds
            local v162 = math.clamp(v161, 0, 1)
            local v163
            if v162 <= 0 then
                v163 = 0
            elseif v162 >= 1 then
                v163 = 1
            else
                local v164 = 2 ^ (v162 * -10)
                local v165 = (v162 * 10 - 0.75) * 2.0943951023931953
                v163 = v164 * math.sin(v165) + 1
            end
            local v166 = v153 * (v163 * 0.5 + 0.5)
            if v166 ~= v157 then
                v157 = v166
                v152:ScaleTo(v166)
            end
            pinBottomTo(v152, v158)
            local v167 = v152:GetPivot()
            local v168 = 6.283185307179586 * v160 * 0.5
            local v169 = math.sin(v168) * v2.BobHeight
            local v170 = v167 + Vector3.new(0, v169, 0)
            local OwnerUserId = v88.OwnerUserId
            local Position = v170.Position
            local v171 = Players:GetPlayerByUserId(OwnerUserId)
            local v172 = v171 and v171.Character
            local v173 = v172 and v172.PrimaryPart
            if v173 then
                Position = v173:GetPivot().Position
            end
            local Position_2 = v170.Position
            local v174 = v170 - v170.Position
            local X = Position.X
            local Y = Position_2.Y
            local Z = Position.Z
            local v175 = Vector3.new(X, Y, Z)
            local v176
            if (Position_2 - v175).Magnitude < 0.001 then
                v176 = CFrame.new(Position_2) * v174
            else
                v176 = CFrame.lookAt(Position_2, v175)
            end
            v152:PivotTo(v170:Lerp(v176, 1 - (1 - v159) * (1 - v159)))
            return nil
        end)
        if v152.Parent == nil then
            return
        end
        if v156 then
            v156.Enabled = false
        end
        local v177 = v152:GetPivot()
        local v178 = v152:GetScale()
        local FlySeconds = v2.FlySeconds
        renderFor(FlySeconds, function(v179) -- line 608 | captures: v152, v177, v178, v88, Players, v2, lookAtFlat, setModelFade
            if v152.Parent == nil then
                return true
            end
            local OwnerUserId = v88.OwnerUserId
            local Position = v177.Position
            local v180 = Players:GetPlayerByUserId(OwnerUserId)
            local v181 = v180 and v180.Character
            local v182 = v181 and v181.PrimaryPart
            if v182 then
                Position = v182:GetPivot().Position
            end
            local Position_2 = v177.Position
            local v183 = (Position_2 + Position) / 2
            local Magnitude = ((Position_2 - Position) * Vector3.new(1, 0, 1)).Magnitude
            local X = v183.X
            local Y = Position_2.Y
            local Y_2 = Position.Y
            local v184 = math.max(Y, Y_2) + Magnitude * 0.5
            local Z = v183.Z
            local v185 = Vector3.new(X, v184, Z)
            local Position_3 = v177.Position
            local v186 = 1 - v179
            local v187 = Position_3 * v186 * v186 + v185 * 2 * v186 * v179 + Position * v179 * v179
            local v188 = (v179 - v2.FlyShrinkStart) / (1 - v2.FlyShrinkStart)
            local v189 = math.clamp(v188, 0, 1)
            local v190 = if v189 <= 0 then 0 else 2 ^ (v189 * 10 - 10)
            if v190 > 0 then
                setModelFade(v152, v190)
                local v191 = v178 * 0.001
                local v192 = v178 * (1 - v190)
                v152:ScaleTo((math.max(v191, v192)))
            end
            v152:PivotTo(lookAtFlat(v187, Position, v177 - v177.Position))
            return nil
        end)
        if v152.Parent then
            v152:Destroy()
        end
        if v89 then
            MergeSfx.Play("Collect")
        end
    end)
end

return v1
