-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LuckyEggConfig = require(ReplicatedStorage.Shared.LuckyEggConfig)
local RranBossConfig = require(ReplicatedStorage.Shared.RranBossConfig)
local VFXScaler = require(ReplicatedStorage.Shared.VFXScaler)
local Modules = script.Parent.Parent.Modules
local BazookaMuzzle = require(Modules.BazookaMuzzle)
local EggLandImpact = require(Modules.EggLandImpact)
local SpatialSfx = require(Modules.SpatialSfx)
local VFXBurst = require(Modules.VFXBurst)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local Flight = LuckyEggConfig.Flight
local v2 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v3 = {}
local v4 = 0

local function now() -- line 85 | captures: Workspace
    return Workspace:GetServerTimeNow()
end

local function shakeNear(v5, v6) -- line 90 | captures: v4, RunService, LocalPlayer
    local Character = LocalPlayer.Character
    local v7
    if Character then
        v7 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    else
        v7 = Character
    end
    if not (v7 and v7:IsA("BasePart") and Character) then
        return
    end
    local Magnitude = (v7.Position - v5).Magnitude
    if Magnitude > 60 then
        return
    end
    v4 += 1
    local v8 = v4
    local v9 = 0.35 * (v6 or 1) * (1 - Magnitude / 60)
    local CameraOffset = Character.CameraOffset
    local v10 = os.clock()
    local v11
    local RenderStepped = RunService.RenderStepped
    local Character_2 = Character
    v11 = RenderStepped:Connect(function() -- line 107 | captures: v11, v8, v9, CameraOffset, v10, Character_2, v4
        local v12 = (os.clock() - v10) / 0.28
        if not (v12 >= 1) and v8 == v4 and Character_2.Parent then
            local v13 = (1 - v12) * v9
            local v14 = (math.random() - 0.5) * 2 * v13
            local v15 = (math.random() - 0.5) * 2 * v13
            Character_2.CameraOffset = CameraOffset + Vector3.new(v14, v15, 0)
        else
            v11:Disconnect()
            if Character_2.Parent and v8 == v4 then
                Character_2.CameraOffset = CameraOffset
            end
        end
    end)
end

local function makeParachute() -- line 127 | captures: ReplicatedStorage, Workspace, LuckyEggConfig
    local v16 = ReplicatedStorage:FindFirstChild(LuckyEggConfig.ParachuteName)
    if not (v16 and v16:IsA("Model")) then
        return nil
    end
    local v17 = v16:Clone()
    for v18, v19 in v17:GetDescendants() do
        if v19:IsA("BasePart") then
            v19.Anchored = true
            v19.CanCollide = false
            v19.CanQuery = false
            v19.CanTouch = false
        end
    end
    v17.Parent = Workspace
    return v17
end

local function placeParachute(v20, v21, v22) -- line 145
    local v23, v24 = v20:GetBoundingBox()
    local v25 = v21 * CFrame.new(0, v22 / 2 + v24.Y / 2, 0)
    if v20.PrimaryPart then
        v20:SetPrimaryPartCFrame(v25)
    else
        v20:PivotTo(v25)
    end
end

local function releaseParachute(v26) -- line 156 | captures: TweenService, v2
    local function v27(v28, v29, ...)
        return (Vector3.new(v28, v29, ...))
    end

    local v30, v31 = v26:GetBoundingBox()
    local v32 = v27(math.random(-6, 6), v31.Y * 2 + 8, math.random(-6, 6))
    local v33 = v26:GetPivot()
    local NumberValue = Instance.new("NumberValue")
    NumberValue.Changed:Connect(function(v34) -- line 161 | captures: v26, v32, v33
        if v26.Parent then
            local v35 = v33 + v32 * v34
            if v26.PrimaryPart then
                v26:SetPrimaryPartCFrame(v35)
            else
                v26:PivotTo(v35)
            end
        end
    end)
    TweenService:Create(NumberValue, v2, { Value = 1 }):Play()
    for v36, v37 in v26:GetDescendants() do
        if v37:IsA("BasePart") or v37:IsA("Decal") or v37:IsA("Texture") then
            TweenService:Create(v37, v2, { Transparency = 1 }):Play()
        end
    end
    task.delay(v2.Time, function() -- line 180 | captures: v26, NumberValue
        NumberValue:Destroy()
        v26:Destroy()
    end)
end

local function bezier(v38, v39, v40, v41, v42) -- line 190
    local v43 = 1 - v42
    return v38 * (v43 * v43 * v43) + v39 * (v43 * 3 * v43 * v42) + v40 * (v43 * 3 * v42 * v42) + v41 * (v42 * v42 * v42)
end

local function arcHandles(v44, v45, v46, v47) -- line 198 | captures: Flight
    local v48 = v45.X - v44.X
    local v49 = v45.Z - v44.Z
    local v50 = Vector3.new(v48, 0, v49)
    local Magnitude = v50.Magnitude
    local v51
    if Magnitude > 0.01 then
        v51 = v50 / Magnitude
    else
        v51 = Vector3.new(0, 0, -1)
    end
    local Y = v44.Y
    local Y_2 = v45.Y
    local v52 = (math.max(Y, Y_2) + v46 - (v44.Y + v45.Y) * 0.125) / 0.75
    local DefaultElevation = Flight.DefaultElevation
    local v53 = math.rad(DefaultElevation)
    if v47 then
        local Y = v47.Unit.Y
        local v54 = math.clamp(Y, 0.35, 0.97)
        v53 = math.asin(v54)
    end
    local v55 = (v52 - v44.Y) / math.tan(v53)
    local v56 = Magnitude * 0.08
    local v57 = Magnitude * 0.45
    local v58 = math.clamp(v55, v56, v57)
    local X = v44.X
    local Z = v44.Z
    local v59 = Vector3.new(X, v52, Z) + v51 * v58
    local X_2 = v45.X
    local Z_2 = v45.Z
    return v59, Vector3.new(X_2, v52, Z_2) - v51 * (Magnitude * Flight.DropIn)
end

local function eggColors(v60) -- line 218 | captures: Flight
    local v61 = {}
    for v62, v63 in v60:GetDescendants() do
        if v63:IsA("BasePart") and v63.Transparency < 0.9 then
            local Color = v63.Color
            local v64 = Color.R * 12
            local v65 = math.floor(v64)
            local v66 = Color.G * 12
            local v67 = math.floor(v66)
            local v68 = Color.B * 12
            local v69 = ("%*,%*,%*"):format(v65, v67, (math.floor(v68)))
            local v70 = v61[v69]
            if not v70 then
                v70 = {
                    Weight = 0,
                    Color = Color
                }
                v61[v69] = v70
            end
            v70.Weight += v63.Size.X * v63.Size.Y * v63.Size.Z
        end
    end
    local v71 = {}
    for v72, v73 in v61 do
        table.insert(v71, v73)
    end
    table.sort(v71, function(v74, v75) -- line 236
        local Weight = v74.Weight
        return v75.Weight < Weight
    end)
    local v76 = v71[1] and v71[1].Color
    if v76 then
        local v77 = #v71
        local Color
        for v78 = 2, v77 do
            Color = v71[v78].Color
            local v79 = Color.R - v76.R
            local v80 = math.abs(v79)
            local v81 = Color.G - v76.G
            local v82 = v80 + math.abs(v81)
            local v83 = Color.B - v76.B
            if v82 + math.abs(v83) > 0.25 then
                break
            end
            Color = nil
        end
        local v84, v85, v86 = v76:ToHSV()
        if not Color then
            local fromHSV = Color3.fromHSV
            local v87 = v85 * 1.15
            Color = fromHSV(v84, math.min(v87, 1), v86 * 0.6)
        end
        return v76, Color
    end
    return Flight.TrailColors[1], Flight.TrailColors[2]
end

local function makeTrail(v88, v89, v90) -- line 260 | captures: ReplicatedStorage, Workspace, VFXScaler, Flight
    local Part = Instance.new("Part")
    Part.Name = "LuckyFlightTrail"
    Part.Size = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224)
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    local v91 = v88 * Flight.TrailWidth
    local Attachment = Instance.new("Attachment")
    local v92 = -v91 / 2
    Attachment.Position = Vector3.new(v92, 0, 0)
    Attachment.Parent = Part
    local Attachment_2 = Instance.new("Attachment")
    local v93 = v91 / 2
    Attachment_2.Position = Vector3.new(v93, 0, 0)
    Attachment_2.Parent = Part
    local Trail = Instance.new("Trail")
    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment_2
    Trail.Lifetime = Flight.TrailLifetime
    Trail.MinLength = 0.05
    Trail.FaceCamera = true
    Trail.LightEmission = 0.6
    Trail.Color = ColorSequence.new(v89, v90)
    Trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    Trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0.15)
    })
    Trail.Parent = Part
    local v94 = v91 * Flight.CoreWidth
    local Attachment_3 = Instance.new("Attachment")
    local v95 = -v94 / 2
    Attachment_3.Position = Vector3.new(v95, 0, 0)
    Attachment_3.Parent = Part
    local Attachment_4 = Instance.new("Attachment")
    local v96 = v94 / 2
    Attachment_4.Position = Vector3.new(v96, 0, 0)
    Attachment_4.Parent = Part
    local Trail_2 = Instance.new("Trail")
    Trail_2.Attachment0 = Attachment_3
    Trail_2.Attachment1 = Attachment_4
    Trail_2.Lifetime = Flight.TrailLifetime * 0.6
    Trail_2.MinLength = 0.05
    Trail_2.FaceCamera = true
    Trail_2.LightEmission = 1
    Trail_2.Color = ColorSequence.new(v89:Lerp(Color3.new(1, 1, 1), 0.65), v89)
    Trail_2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    Trail_2.Parent = Part
    local v97 = {}
    local VFX = ReplicatedStorage:FindFirstChild("VFX")
    local v98 = VFX and VFX:FindFirstChild(Flight.SmokeName)
    if v98 and v98:IsA("Attachment") then
        local v99 = v98:Clone()
        v99.Position = Vector3.new(0, 0, 0)
        for v100, v101 in v99:GetDescendants() do
            if v101:IsA("ParticleEmitter") then
                local v102 = string.find(string.lower(v101.Name), "smoke") ~= nil
                v101.Enabled = v102
                if v102 then
                    VFXScaler.ScaleParticle(v101, v88 / 4)
                    v101.Rate *= Flight.SmokeRate
                    table.insert(v97, v101)
                end
            end
        end
        v99.Parent = Part
    end
    Part.Parent = Workspace
    return Part,
        function() -- release | line 341 | captures: Part, Trail, Trail_2, v97
            Trail.Enabled = false
            Trail_2.Enabled = false
            for v103, v104 in v97 do
                v104.Enabled = false
            end
            task.delay(3, function() -- line 347 | captures: Part
                Part:Destroy()
            end)
        end
end

local function animate(v105) -- line 358 | captures: RunService, Workspace, LuckyEggConfig, RranBossConfig, BazookaMuzzle, EggLandImpact, SpatialSfx, VFXBurst, Flight, v3, shakeNear, makeParachute, placeParachute, releaseParachute, arcHandles, eggColors, makeTrail
    local function v106(v107, ...)
        table.insert(v107, ...)
    end

    if v3[v105] then
        return
    end
    local Model = v105:FindFirstAncestorWhichIsA("Model")
    local LuckyLandCFrame = v105:GetAttribute("LuckyLandCFrame")
    local LuckyLandAt = v105:GetAttribute("LuckyLandAt")
    local LuckyDropTime = v105:GetAttribute("LuckyDropTime")
    local LuckyGround = v105:GetAttribute("LuckyGround")
    local v108 = v105:GetAttribute("LuckyMode") == "Launch"
    local LuckyDropHeight = v105:GetAttribute("LuckyDropHeight")
    local LuckyFrom = v105:GetAttribute("LuckyFrom")
    local LuckyApex = v105:GetAttribute("LuckyApex")
    if not Model or not (typeof(LuckyLandCFrame) == "CFrame") or not (type(LuckyLandAt) == "number") or not (type(LuckyDropTime) == "number") or v105:GetAttribute("LuckyLanded") then
        return
    end
    if v108 then
        if not (typeof(LuckyFrom) == "Vector3" and type(LuckyApex) == "number") then
            return
        end
    elseif type(LuckyDropHeight) ~= "number" then
        return
    end
    local v109 = LuckyLandAt - 0.45
    if not (v109 <= Workspace:GetServerTimeNow()) then
        v3[v105] = true
        if Model.PrimaryPart == nil then
            Model.PrimaryPart = v105
        end
        local CFrame_2 = v105.CFrame
        local v110 = {}
        local v111 = {}
        local v112 = {}

        local function addPart(v113) -- line 408 | captures: CFrame_2, v110, v111, v112
            local function v114(v115, ...)
                table.insert(v115, ...)
            end

            if not v113:IsA("BasePart") or v112[v113] then
                return
            end
            v112[v113] = true
            table.insert(v110, v113)
            v114(v111, CFrame_2:ToObjectSpace(v113.CFrame))
        end

        for v116, v117 in Model:GetDescendants() do
            if v117:IsA("BasePart") and not v112[v117] then
                v112[v117] = true
                table.insert(v110, v117)
                v106(v111, CFrame_2:ToObjectSpace(v117.CFrame))
            end
        end
        local v118 = Model.DescendantAdded:Connect(addPart)
        local v119 = {}

        local function moveTo(v120) -- line 420 | captures: v110, v111, v119, Workspace
            for v121, v122 in v111 do
                v119[v121] = v120 * v122
            end
            Workspace:BulkMoveTo(v110, v119, Enum.BulkMoveMode.FireCFrameChanged)
        end

        local v123 = v109 - (LuckyDropTime - 0.45)
        local Y = v105.Size.Y
        local v124 = LuckyLandCFrame - LuckyLandCFrame.Position
        local v125 = math.random() * 3.141592653589793 * 2
        if typeof(LuckyGround) ~= "Vector3" then
            local Position = LuckyLandCFrame.Position
            local v126 = Y / 2
            LuckyGround = Position - Vector3.new(0, v126, 0)
        end
        local v127
        if v108 then
            v127 = nil
        else
            v127 = makeParachute()
        end
        local v128, v129, v130, v131, v132, v133, v134
        if v108 then
            v128 = LuckyFrom
            local v135 = Workspace:GetServerTimeNow() - v123
            local v136 = v109 - v123
            local v137, v138
            if v135 / math.max(v136, 0.01) < 0.25 then
                local v139 = BazookaMuzzle.Nearest(LuckyFrom, Flight.MuzzleSnap)
                if v139 then
                    v137, v138 = BazookaMuzzle.Get(v139)
                    if v137 then
                        v128 = v137
                    else
                        v137 = LuckyFrom
                        v138 = nil
                    end
                else
                    v137 = LuckyFrom
                end
            else
                v137 = LuckyFrom
            end
            v129, v130 = arcHandles(v137, LuckyLandCFrame.Position, LuckyApex, v138)
            local v140 = LuckyLandCFrame.X - v137.X
            local v141 = LuckyLandCFrame.Z - v137.Z
            local v142 = Vector3.new(v140, 0, v141)
            if v142.Magnitude > 0.01 then
                v131 = v142.Unit:Cross((Vector3.new(0, 1, 0)))
            else
                v131 = Vector3.new(1, 0, 0)
            end
            local v143 = (v109 - v123) * Flight.SpinPerSecond + 0.5
            local v144 = math.floor(v143)
            v132 = math.max(1, v144)
            v133, v134 = makeTrail(Y, eggColors(Model))
            SpatialSfx.Play(RranBossConfig.Sfx.Folder, RranBossConfig.Sfx.EggWhoosh.Name, {
                At = v105,
                Range = RranBossConfig.Sfx.EggWhoosh.Range,
                MinRange = RranBossConfig.Sfx.EggWhoosh.Range * 0.25,
                Volume = RranBossConfig.Sfx.EggWhoosh.Volume
            })
        end

        local function cleanup() -- line 465 | captures: v127, v134, v105, v118, v3
            v3[v105] = nil
            v118:Disconnect()
            if v127 then
                v127:Destroy()
                v127 = nil
            end
            if v134 then
                v134()
                v134 = nil
            end
        end

        local function finish() -- line 478 | captures: v105, Model, LuckyLandCFrame, v110, v111, v118, v119, Workspace, v3
            v3[v105] = nil
            v118:Disconnect()
            if Model.Parent then
                for v145, v146 in v111 do
                    v119[v145] = LuckyLandCFrame * v146
                end
                Workspace:BulkMoveTo(v110, v119, Enum.BulkMoveMode.FireCFrameChanged)
            end
        end

        local function inFlight(v147) -- line 487 | captures: v128, v129, v130, v131, v132, v133, LuckyLandCFrame, LuckyDropHeight, v109, v123, v124, v125, v108
            local v148 = v147 - v123
            local v149 = v109 - v123
            local v150 = v148 / math.max(v149, 0.01)
            local v151 = math.clamp(v150, 0, 1)
            if v108 then
                local v152 = v128
                local v153 = v129
                local v154 = v130
                local Position = LuckyLandCFrame.Position
                local v155 = 1 - v151
                local v156 = v152 * (v155 * v155 * v155) + v153 * (v155 * 3 * v155 * v151) + v154 * (v155 * 3 * v151 * v151) + Position * (v151 * v151 * v151)
                local v157 = v132 * 2 * 3.141592653589793 * (1 - (1 - v151) ^ 1.6)
                if v133 then
                    local v158 = v128
                    local v159 = v129
                    local v160 = v130
                    local Position = LuckyLandCFrame.Position
                    local v161 = v151 + 0.01
                    local v162 = math.min(v161, 1)
                    local v163 = 1 - v162
                    local v164 = v158 * (v163 * v163 * v163) + v159 * (v163 * 3 * v163 * v162) + v160 * (v163 * 3 * v162 * v162) + Position * (v162 * v162 * v162)
                    local v165 = v133
                    if (v164 - v156).Magnitude > 0.001 then
                        v165.CFrame = CFrame.lookAt(v156, v164)
                    else
                        v165.CFrame = CFrame.new(v156)
                    end
                end
                return CFrame.new(v156) * CFrame.fromAxisAngle(v131, v157) * v124
            end
            local v166 = (1 - v151) ^ 1.7
            local v167 = v166 * 0.75 + 0.25
            local v168 = v147 * 0.55 * 2 * 3.141592653589793 + v125
            local v169 = math.sin(v168) * 0.24434609527920614 * v167 * v166 ^ 0.5
            local v170 = v147 * 0.55 * 1.7 * 3.141592653589793 + v125
            local v171 = math.cos(v170) * 0.1466076571675237 * v167 * v166 ^ 0.5
            local v172 = v147 * 1.1 + v125
            local v173 = math.sin(v172) * 4 * v166
            local v174 = v147 * 0.9 + v125
            local v175 = math.cos(v174) * 4 * v166
            local v176 = Vector3.new(v173, 0, v175)
            local v177 = (1 - v151) * 2.443460952792061
            local v178 = LuckyLandCFrame.Position + v176
            local v179 = LuckyDropHeight * v166
            local v180 = v178 + Vector3.new(0, v179, 0)
            return CFrame.new(v180) * CFrame.Angles(v169, v177, v171) * v124
        end

        local v181 = false
        local v182 = 0
        local v183
        local RenderStepped = RunService.RenderStepped
        local LuckyGround_2 = LuckyGround
        v183 = RenderStepped:Connect(function() -- line 523 | captures: v127, v134, v181, v182, v183, v105, Model, LuckyLandCFrame, v109, v110, v111, v118, v119, Y, inFlight, LuckyGround_2, v108, Workspace, LuckyEggConfig, RranBossConfig, EggLandImpact, SpatialSfx, VFXBurst, Flight, v3, shakeNear, placeParachute, releaseParachute
            if not (Model.Parent and v105.Parent) then
                v183:Disconnect()
                v3[v105] = nil
                v118:Disconnect()
                if v127 then
                    v127:Destroy()
                    v127 = nil
                end
                if v134 then
                    v134()
                    v134 = nil
                end
            elseif v105:GetAttribute("LuckyLanded") then
                v183:Disconnect()
                if v127 then
                    releaseParachute(v127)
                    v127 = nil
                end
                v3[v105] = nil
                v118:Disconnect()
                if v127 then
                    v127:Destroy()
                    v127 = nil
                end
                if v134 then
                    v134()
                    v134 = nil
                end
                v3[v105] = nil
                v118:Disconnect()
                if Model.Parent then
                    for v184, v185 in v111 do
                        v119[v184] = LuckyLandCFrame * v185
                    end
                    Workspace:BulkMoveTo(v110, v119, Enum.BulkMoveMode.FireCFrameChanged)
                end
            else
                local v186 = Workspace:GetServerTimeNow()
                if v181 then
                    local v187 = (v186 - v182) / 0.3
                    local v188 = math.clamp(v187, 0, 1)
                    local v189 = -0.12 * Y
                    local v190 = v188 * 3.141592653589793
                    local v191 = v189 * math.sin(v190) * (1 - v188 * 0.35)
                    local v192 = LuckyLandCFrame + Vector3.new(0, v191, 0)
                    for v193, v194 in v111 do
                        v119[v193] = v192 * v194
                    end
                    Workspace:BulkMoveTo(v110, v119, Enum.BulkMoveMode.FireCFrameChanged)
                    if v188 >= 1 then
                        v183:Disconnect()
                        v3[v105] = nil
                        v118:Disconnect()
                        if Model.Parent then
                            for v195, v196 in v111 do
                                v119[v195] = LuckyLandCFrame * v196
                            end
                            Workspace:BulkMoveTo(v110, v119, Enum.BulkMoveMode.FireCFrameChanged)
                        end
                    end
                else
                    local v197 = inFlight(v186)
                    for v198, v199 in v111 do
                        v119[v198] = v197 * v199
                    end
                    Workspace:BulkMoveTo(v110, v119, Enum.BulkMoveMode.FireCFrameChanged)
                    if v127 then
                        placeParachute(v127, v197, Y)
                    end
                    if v109 <= v186 then
                        v181 = true
                        v182 = v186
                        for v200, v201 in v111 do
                            v119[v200] = LuckyLandCFrame * v201
                        end
                        Workspace:BulkMoveTo(v110, v119, Enum.BulkMoveMode.FireCFrameChanged)
                        local Size = v105.Size
                        local Chunks = EggLandImpact.Chunks
                        local X = Size.X
                        local Y_2 = Size.Y
                        local Z = Size.Z
                        Chunks(LuckyGround_2, math.min(X, Y_2, Z), Y)
                        VFXBurst.Play(LuckyEggConfig.LandPuff.Name, CFrame.new(LuckyGround_2), Y * LuckyEggConfig.LandPuff.Scale)
                        local v202 = if v108 then Flight.LandShake else 1
                        shakeNear(LuckyGround_2, v202)
                        if v108 then
                            SpatialSfx.Play(RranBossConfig.Sfx.Folder, RranBossConfig.Sfx.EggLand.Name, {
                                At = LuckyGround_2,
                                Range = RranBossConfig.Sfx.EggLand.Range,
                                MinRange = RranBossConfig.Sfx.EggLand.Range * 0.25,
                                Volume = RranBossConfig.Sfx.EggLand.Volume
                            })
                        end
                        if v127 then
                            releaseParachute(v127)
                            v127 = nil
                        end
                        if v134 then
                            v134()
                            v134 = nil
                        end
                    end
                end
            end
        end)
    end
end

function v1.Start() -- line 589 | captures: CollectionService, LuckyEggConfig, RranBossConfig, animate
    for v203, v204 in {
            LuckyEggConfig.Tag,
            RranBossConfig.AnimalEggs.FlightTag
        } do
        for v205, v206 in CollectionService:GetTagged(v204) do
            if v206:IsA("BasePart") then
                task.spawn(animate, v206)
            end
        end
        CollectionService:GetInstanceAddedSignal(v204):Connect(function(v207) -- line 597 | captures: animate
            if v207:IsA("BasePart") then
                task.defer(animate, v207)
            end
        end)
    end
end

return v1
