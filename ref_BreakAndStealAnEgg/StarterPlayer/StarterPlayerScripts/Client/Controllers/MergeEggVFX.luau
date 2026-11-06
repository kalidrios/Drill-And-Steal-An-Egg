-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AnimalEggsConfig = require(ReplicatedStorage.Shared.AnimalEggsConfig)
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local EggTypeConfig = require(ReplicatedStorage.Shared.EggTypeConfig)
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local MergeSfx = require(script.Parent.MergeSfx)
local SpatialSfx = require(script.Parent.Parent.Modules.SpatialSfx)
local LocalModelHider = require(script.Parent.Parent.Modules.LocalModelHider)
local EggPlaceBurst = require(script.Parent.Parent.Modules.EggPlaceBurst)
local EggLandImpact = require(script.Parent.Parent.Modules.EggLandImpact)
local EggGrowthBoostText = require(script.Parent.Parent.Modules.EggGrowthBoostText)
local RarityNameGradient = require(ReplicatedStorage.Shared.RarityNameGradient)
local v1 = {}
local v2 = {
    ReadyVolume = 2,
    CullDistance = 120,
    BillboardName = "EggHatchingUi",
    BillboardMaxDistance = 50,
    BillboardReferenceHeight = 3.2,
    BillboardMaxMult = 12,
    BillboardPopSeconds = 0.25,
    Place = {
        DropHeightMult = 2,
        DropSeconds = 0.2,
        ImpactFraction = 0.1,
        BillboardAt = 0.3,
        Length = 0.5,
        ChunkCountMin = 6,
        ChunkCountMax = 10,
        ChunkStagger = 0.015,
        ChunkUpSeconds = 0.2,
        ChunkLandSeconds = 0.12,
        ChunkSettleSeconds = 0.08,
        ChunkFadeDelay = 0.15,
        ChunkFadeSeconds = 0.5,
        DecalFadeInSeconds = 0.25,
        DecalLingerMin = 7,
        DecalLingerMax = 11,
        DecalFadeOutSeconds = 1,
        RingSeconds = 0.3,
        MudColor = Color3.fromRGB(101, 67, 33),
        ChunkColors = {
            Color3.fromRGB(101, 67, 33),
            Color3.fromRGB(92, 60, 28),
            Color3.fromRGB(110, 75, 40),
            Color3.fromRGB(85, 55, 25)
        }
    },
    Grow = {
        HopEveryMin = 27,
        HopEveryMax = 65,
        HopSeconds = 0.55,
        HopHeightFrac = 0.25,
        HopWobbleDegrees = 4,
        HopWobbleCycles = 4
    },
    Skip = {
        Seconds = 1.2,
        SpinDegrees = 1080,
        WobbleDegrees = 35
    },
    Ready = {
        PulseEveryMin = 5,
        PulseEveryMax = 10,
        WiggleSeconds = 0.25,
        WiggleDegrees = 3,
        WiggleCycles = 3,
        SwellSeconds = 0.6,
        SwellScale = 1.2,
        FlashPeakFill = 0.1,
        SettleSeconds = 0.2
    },
    ReadyTextColor = Color3.fromRGB(85, 255, 110)
}

v1.Config = v2

local v3 = Random.new()
local Folder

local function getVfxFolder() -- line 140 | captures: Folder, Workspace
    if Folder and Folder.Parent then
        return Folder
    end
    local Folder_2 = Instance.new("Folder")
    Folder_2.Name = "MergeEggVFX_Local"
    Folder_2.Parent = Workspace
    Folder = Folder_2
    return Folder_2
end

local function quadOut(v4) -- line 151
    return 1 - (1 - v4) * (1 - v4)
end

local function bounceOut(v5) -- line 155
    if v5 < 0.36363636363636365 then
        return v5 * 7.5625 * v5
    end
    if v5 < 0.7272727272727273 then
        local v6 = v5 - 0.5454545454545454
        return v6 * 7.5625 * v6 + 0.75
    end
    if v5 < 0.9090909090909091 then
        local v7 = v5 - 0.8181818181818182
        return v7 * 7.5625 * v7 + 0.9375
    end
    local v8 = v5 - 0.9545454545454546
    return v8 * 7.5625 * v8 + 0.984375
end

local function elasticOut(v9) -- line 170
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

local function vfxAsset(v12) -- line 182 | captures: MergeConfig
    local v13 = MergeConfig.EggVfxFolder()
    return v13 and v13:FindFirstChild(v12)
end

local v14 = {}

v14.__index = v14

function v1.Attach(v15) -- line 210 | captures: AnimalEggsConfig, EggConfig, EggTypeConfig, v2, v3, v14
    local PrimaryPart = v15.PrimaryPart
    if PrimaryPart then
        local v16 = {}
        local v17 = setmetatable(v16, v14)
        v17.model = v15
        v17.primary = PrimaryPart
        v17.Phase = "Idle"
        v17.phaseStart = os.clock()
        v17.token = 0
        v17.destroyed = false
        v17.impactDone = false
        v17.lastScale = (0/0)
        v17.lastHeight = (0/0)
        v17.lastYaw = (0/0)
        v17.lastPitch = (0/0)
        v17.lastRoll = (0/0)
        v17.popStart = (-1/0)
        v17.baseScale = v15:GetScale()
        v17.baseRotation = v15:GetPivot().Rotation
        local v18, v19 = v15:GetBoundingBox()
        v17.groundY = v18.Position.Y - v19.Y / 2
        v17.eggFrame = AnimalEggsConfig.GetFrameAttachment(v15)
        local Position = AnimalEggsConfig.GetEggFrame(v15).Position
        local X = Position.X
        local groundY = v17.groundY
        local Z = Position.Z
        v17.baseCenter = Vector3.new(X, groundY, Z)
        v17.eggHeight = v19.Y
        local X_2 = PrimaryPart.Size.X
        local Y = PrimaryPart.Size.Y
        local Z_2 = PrimaryPart.Size.Z
        local v20 = math.min(X_2, Y, Z_2)
        v17.dirtScale = math.max(v20, 0.1)
        v17.hopStart = (-1/0)
        v17.nextHopAt = os.clock() + v3:NextNumber(v2.Grow.HopEveryMin, v2.Grow.HopEveryMax)
        v17.pulseStart = (-1/0)
        v17.nextPulseAt = 0
        v17.wiggleStart = (-1/0)
        v17.wiggleDirection = 0
        v17.nextWiggleAt = os.clock() + v3:NextNumber(EggConfig.Idle.MinDelay, EggConfig.Idle.MaxDelay)
        local v21 = EggTypeConfig.Get(v15:GetAttribute(EggTypeConfig.Attribute))
        if v21 and v21.IdleAnimationId then
            v17.nextHopAt = (1/0)
            v17.nextWiggleAt = (1/0)
        end
        if not (v21 and v21.GroundSink) then
            v17.groundSink = 0
        else
            v17.groundSink = v21.GroundSink
        end
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "ReadyEggPulseHighlight"
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.FillColor = Color3.new(1, 1, 1)
        Highlight.FillTransparency = 1
        Highlight.OutlineTransparency = 1
        Highlight.Enabled = false
        Highlight.Parent = v15
        v17.highlight = Highlight
        v17:_buildBillboard()
        return v17
    end
    return nil
end

function v14._buildBillboard(v22) -- line 290 | captures: ReplicatedStorage, EggRewards, EggTypeConfig, RarityNameGradient, v2
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local v23 = Assets and Assets:FindFirstChild("BillboardGui")
    local v24 = v23 and v23:FindFirstChild(v2.BillboardName)
    if v24 and v24:IsA("BillboardGui") then
        local v25 = v24:Clone()
        v22.billboardSize = v25.Size
        v25.Adornee = v22.eggFrame or v22.primary
        v25.AlwaysOnTop = true
        v25.MaxDistance = v2.BillboardMaxDistance
        v25.Enabled = false
        v25.Parent = v22.model
        for v26, v27 in v25:GetDescendants() do
            if v27:IsA("TextLabel") then
                v27.TextScaled = true
            end
        end
        local AnimalName = v22.model:GetAttribute("AnimalName")
        local Egg = v25:FindFirstChild("Egg")
        if Egg and Egg:IsA("TextLabel") and typeof(AnimalName) == "string" then
            local v28 = v22.model:GetAttribute(EggTypeConfig.Attribute)
            local v29 = EggTypeConfig.Get(v28)
            Egg.Text = EggTypeConfig.DisplayName(v28, AnimalName)
            local Apply = RarityNameGradient.Apply
            local v30 = {}
            if v29 and v29.Rarity then
                v30.Rarity = v29.Rarity
            else
                v30.Rarity = EggRewards.RarityOf(AnimalName)
            end
            Apply(Egg, v30)
        end
        v22.billboard = v25
        local Timer = v25:FindFirstChild("Timer")
        if not (Timer and Timer:IsA("TextLabel")) then
            Timer = nil
        end
        v22.timerLabel = Timer
        v22:SetTimerVisible(false)
    else
        warn((("[MergeEggVFX] ReplicatedStorage.Assets.BillboardGui.%* missing"):format(v2.BillboardName)))
    end
end

local function SetTimerVisible(v31, v32) -- line 342
    local timerLabel = v31.timerLabel
    if timerLabel and timerLabel.Visible ~= v32 then
        timerLabel.Visible = v32
        v31.lastTimerKey = nil
    end
end

v14.SetTimerVisible = SetTimerVisible

local function _popBillboard(v33) -- line 350
    if v33.billboard then
        v33.billboard.Enabled = true
        v33.popStart = os.clock()
    end
end

v14._popBillboard = _popBillboard

function v14._sizeBillboard(v34, v35) -- line 359 | captures: v2
    local billboard = v34.billboard
    local v36
    if billboard and billboard.Enabled then
        v36 = v34.currentHeight or v34.eggHeight
    else
        return
    end
    local v37 = v35 - v34.popStart < v2.BillboardPopSeconds
    if not v37 and v36 == v34.lastBillboardHeight then
        return
    end
    if not v37 then
        v34.lastBillboardHeight = v36
    else
        v34.lastBillboardHeight = nil
    end
    local v38 = v36 / v2.BillboardReferenceHeight
    local BillboardMaxMult = v2.BillboardMaxMult
    local v39 = math.clamp(v38, 1, BillboardMaxMult)
    local v40 = (v35 - v34.popStart) / v2.BillboardPopSeconds
    local v41 = math.clamp(v40, 0, 1)
    if v41 < 1 then
        local v42 = v41 - 1
        v39 *= (v42 * 2.70158 * v42 * v42 + 1 + v42 * 1.70158 * v42) * 0.95 + 0.05
    end
    local billboardSize = v34.billboardSize
    local v43 = UDim2.new(billboardSize.X.Scale * v39, billboardSize.X.Offset * v39, billboardSize.Y.Scale * v39, billboardSize.Y.Offset * v39)
    if billboard.Size ~= v43 then
        billboard.Size = v43
    end
end

local function _enterPhase(v44, v45) -- line 385
    v44.Phase = v45
    v44.phaseStart = os.clock()
    v44.token += 1
    return v44.token
end

v14._enterPhase = _enterPhase

local function _after(v46, v47, v48, v49) -- line 392
    task.delay(v48, function() -- line 393 | captures: v46, v47, v49
        if not v46.destroyed and v46.token == v47 then
            v49()
        end
    end)
end

v14._after = _after

function v14.BeginPlace(v50) -- line 404 | captures: v2
    local Place = v50:_enterPhase("Place")
    v50.impactDone = false
    local BillboardAt = v2.Place.BillboardAt
    v50:_after(Place, BillboardAt, function() -- line 407 | captures: v50
        v50:_popBillboard()
    end)
    local Length = v2.Place.Length
    v50:_after(Place, Length, function() -- line 410 | captures: v50
        v50:BeginGrowing()
    end)
end

function v14._isMine(v51) -- line 417 | captures: SpatialSfx
    return SpatialSfx.IsMe(v51.model:GetAttribute("OwnerUserId"))
end

function v14._placeImpact(v52) -- line 421 | captures: Folder, Workspace, MergeSfx, LocalModelHider, EggPlaceBurst, EggLandImpact, v3
    if v52.impactDone then
        return
    end
    v52.impactDone = true
    local Folder_2
    if not (Folder and Folder.Parent) then
        Folder_2 = Instance.new("Folder")
        Folder_2.Name = "MergeEggVFX_Local"
        Folder_2.Parent = Workspace
        Folder = Folder_2
    else
        Folder_2 = Folder
    end
    MergeSfx.Play("EggLand", v52.primary, {
        PlaybackSpeed = 1 + v3:NextNumber(-0.1, 0.1),
        Mine = v52:_isMine()
    })
    EggLandImpact.Dirt(Folder_2, v52.baseCenter, v52.dirtScale)
    if not LocalModelHider.IsHidden(v52.model) then
        EggPlaceBurst.Play(v52.baseCenter, v52.currentHeight or v52.eggHeight)
    end
end

local function BeginGrowing(v53) -- line 438
    v53:_enterPhase("Growing")
    if v53.billboard and not v53.billboard.Enabled then
        v53.billboard.Enabled = true
    end
end

v14.BeginGrowing = BeginGrowing

function v14.PlayReadySound(v54) -- line 447 | captures: MergeSfx, v2
    MergeSfx.Play("Ready", v54.primary, {
        Volume = v2.ReadyVolume,
        Mine = v54:_isMine()
    })
end

function v14.BeginSkip(v55) -- line 452 | captures: Debris, Workspace, MergeConfig, MergeSfx, v2
    local Skip = v55:_enterPhase("Skip")
    MergeSfx.Play("SkipSpin", v55.primary, { Mine = v55:_isMine() })
    local v56 = MergeConfig.EggVfxFolder()
    local v57 = v56 and v56:FindFirstChild("SkipEggEffect")
    local v58 = v57 and v57:FindFirstChild("Attachment")
    if v58 and v58:IsA("Attachment") then
        local v59 = v58:Clone()
        v59.Parent = Workspace.Terrain
        v59.WorldCFrame = v55.model:GetPivot() * CFrame.Angles(0, 0, 3.141592653589793)
        for v60, v61 in v59:GetDescendants() do
            if v61:IsA("ParticleEmitter") then
                v61.Enabled = true
            end
        end
        task.delay(v2.Skip.Seconds, function() -- line 466 | captures: v59, Debris
            for v62, v63 in v59:GetDescendants() do
                if v63:IsA("ParticleEmitter") then
                    v63.Enabled = false
                end
            end
            Debris:AddItem(v59, 5)
        end)
    end
    local Seconds = v2.Skip.Seconds
    v55:_after(Skip, Seconds, function() -- line 475 | captures: v55
        v55:BeginReady()
    end)
end

function v14.BeginReady(v64, v65) -- line 480 | captures: v2, v3
    v64:_enterPhase("Ready")
    v64.nextPulseAt = os.clock() + v3:NextNumber(v2.Ready.PulseEveryMin, v2.Ready.PulseEveryMax)
    if v65 and v64.billboard then
        v64.billboard.Enabled = true
    end
end

function v14.Update(v66, v67, v68, v69, v70) -- line 492 | captures: EggConfig, MergeConfig, LocalModelHider, EggGrowthBoostText, v2, v3
    if v66.destroyed then
        return
    end
    local v71 = v67 - v66.phaseStart
    local Phase = v66.Phase
    local v72, v73, v74, v75, v76, v77
    if Phase == "Place" then
        local Place = v2.Place
        local v78 = v71 / Place.DropSeconds
        local v79 = math.clamp(v78, 0, 1)
        local v80 = v66.eggHeight * Place.DropHeightMult
        local v81
        if v79 < 0.36363636363636365 then
            v81 = v79 * 7.5625 * v79
        elseif v79 < 0.7272727272727273 then
            local v82 = v79 - 0.5454545454545454
            v81 = v82 * 7.5625 * v82 + 0.75
        elseif v79 < 0.9090909090909091 then
            local v83 = v79 - 0.8181818181818182
            v81 = v83 * 7.5625 * v83 + 0.9375
        else
            local v84 = v79 - 0.9545454545454546
            v81 = v84 * 7.5625 * v84 + 0.984375
        end
        v72 = v80 * (1 - v81)
        if not v66.impactDone and v72 <= v66.eggHeight * Place.ImpactFraction then
            v66:_placeImpact()
        end
        v74 = 1
        v75 = 0
        v76 = 0
        v77 = 0
        v73 = 1
    elseif Phase == "Growing" then
        local Grow = v2.Grow
        local v85 = v67 - v66.wiggleStart < EggConfig.Idle.WiggleTime
        if v70 and not v85 and v66.nextHopAt <= v67 then
            local v86 = v67 - v66.hopStart
            if Grow.HopSeconds < v86 then
                v66.hopStart = v67
                v66.nextHopAt = v67 + v3:NextNumber(Grow.HopEveryMin, Grow.HopEveryMax)
            end
        end
        local v87 = (v67 - v66.hopStart) / Grow.HopSeconds
        local v88 = if v87 >= 0 then v87 < 1 else false
        local Idle = EggConfig.Idle
        if v70 and not v88 and v66.nextWiggleAt <= v67 then
            v66.wiggleStart = v67
            v66.wiggleDirection = v3:NextNumber(0, 6.283185307179586)
            v66.nextWiggleAt = v67 + Idle.WiggleTime + v3:NextNumber(Idle.MinDelay, Idle.MaxDelay)
        end
        local v89 = v67 - v66.wiggleStart
        local v90, v91
        if v89 >= 0 and v89 < Idle.WiggleTime then
            local WiggleAngle = Idle.WiggleAngle
            local v92 = math.rad(WiggleAngle)
            local v93 = 6.283185307179586 * Idle.WiggleRate * v89
            local v94 = v92 * math.sin(v93) * (1 - v89 / Idle.WiggleTime)
            local wiggleDirection = v66.wiggleDirection
            v90 = math.cos(wiggleDirection) * v94
            local wiggleDirection_2 = v66.wiggleDirection
            v91 = math.sin(wiggleDirection_2) * v94
        else
            v90 = 0
            v91 = 0
        end
        if v88 then
            local v95
            if v87 < 0.5 then
                local v96 = v87 * 2
                v95 = 1 - (1 - v96) * (1 - v96)
            else
                local v97 = (v87 - 0.5) * 2
                local v98
                if v97 < 0.36363636363636365 then
                    v98 = v97 * 7.5625 * v97
                elseif v97 < 0.7272727272727273 then
                    local v99 = v97 - 0.5454545454545454
                    v98 = v99 * 7.5625 * v99 + 0.75
                elseif v97 < 0.9090909090909091 then
                    local v100 = v97 - 0.8181818181818182
                    v98 = v100 * 7.5625 * v100 + 0.9375
                else
                    local v101 = v97 - 0.9545454545454546
                    v98 = v101 * 7.5625 * v101 + 0.984375
                end
                v95 = 1 - v98
            end
            v72 = (v66.currentHeight or v66.eggHeight) * Grow.HopHeightFrac * v95
            local v102 = v87 * 3.141592653589793 * 2 * Grow.HopWobbleCycles
            local v103 = math.sin(v102)
            local HopWobbleDegrees = Grow.HopWobbleDegrees
            v74, v75, v76, v77, v73 = 1, 0, v90, v103 * math.rad(HopWobbleDegrees) * (1 - (1 - (1 - v87) * (1 - v87))), 1
        else
            v74 = 1
            v72 = 0
            v75 = 0
            v76 = v90
            v77 = v91
            v73 = 1
        end
    elseif Phase == "Skip" then
        local Skip = v2.Skip
        local v104 = v71 / Skip.Seconds
        local v105 = math.clamp(v104, 0, 1)
        local v106 = 1 - (1 - v105) * (1 - v105)
        local v107 = v106 * Skip.SpinDegrees
        v75 = math.rad(v107)
        local v108 = Skip.SpinDegrees * v106
        local v109 = math.sin(v108) * Skip.WobbleDegrees * (1 - v106)
        v74, v72, v76, v77, v73 = 1, 0, 0, math.rad(v109), 1
    elseif Phase == "Ready" then
        local Ready = v2.Ready
        local v110 = Ready.WiggleSeconds + Ready.SwellSeconds + Ready.SettleSeconds
        if v70 and v66.nextPulseAt <= v67 and v110 < v67 - v66.pulseStart then
            v66.pulseStart = v67
            v66.nextPulseAt = v67 + v3:NextNumber(Ready.PulseEveryMin, Ready.PulseEveryMax)
        end
        local v111 = v67 - v66.pulseStart
        if not (v111 >= 0 and v111 < Ready.WiggleSeconds) then
            if Ready.WiggleSeconds <= v111 and v111 < Ready.WiggleSeconds + Ready.SwellSeconds then
                local v112 = (v111 - Ready.WiggleSeconds) / Ready.SwellSeconds
                local v113 = Ready.SwellScale - 1
                local v114
                if v112 <= 0 then
                    v114 = 0
                elseif v112 >= 1 then
                    v114 = 1
                else
                    local v115 = 2 ^ (v112 * -10)
                    local v116 = (v112 * 10 - 0.75) * 2.0943951023931953
                    v114 = v115 * math.sin(v116) + 1
                end
                v74 = 1 + v113 * v114
                local v117 = v112 * 3.141592653589793
                v72, v75, v76, v77, v73 = 0, 0, 0, 0, 1 - math.sin(v117) * (1 - Ready.FlashPeakFill)
            elseif Ready.WiggleSeconds + Ready.SwellSeconds <= v111 and v111 < v110 then
                local v118 = (v111 - Ready.WiggleSeconds - Ready.SwellSeconds) / Ready.SettleSeconds
                v74 = Ready.SwellScale + (1 - Ready.SwellScale) * (1 - (1 - v118) * (1 - v118))
                v72 = 0
                v75 = 0
                v76 = 0
                v77 = 0
                v73 = 1
            else
                v74 = 1
                v72 = 0
                v75 = 0
                v76 = 0
                v77 = 0
                v73 = 1
            end
        else
            local v119 = v111 / Ready.WiggleSeconds
            local v120 = v119 * 3.141592653589793 * 2 * Ready.WiggleCycles
            local v121 = math.sin(v120)
            local WiggleDegrees = Ready.WiggleDegrees
            v74, v72, v75, v76, v77, v73 = 1, 0, 0, 0, v121 * math.rad(WiggleDegrees) * (1 - (1 - (1 - v119) * (1 - v119))), 1
        end
    else
        v74 = 1
        v72 = 0
        v75 = 0
        v76 = 0
        v77 = 0
        v73 = 1
    end
    local highlight = v66.highlight
    local v122 = if v73 < 1 then not LocalModelHider.IsHidden(v66.model) else false
    if highlight.Enabled ~= v122 then
        if v122 then
            highlight.Adornee = v66.model
        else
            highlight.Adornee = nil
        end
        highlight.Enabled = v122
    end
    if v122 and highlight.FillTransparency ~= v73 then
        highlight.FillTransparency = v73
    end
    local v123 = v68 / 0.01 + 0.5
    local v124 = math.floor(v123) * 0.01
    local v125 = v66.baseScale * v124 * v74
    local v126
    if v66.lastScale == v66.lastScale then
        local v127 = v125 - v66.lastScale
        v126 = math.abs(v127) > 0.0001
    else
        v126 = true
    end
    local v128
    if v126 then
        v128 = false
    else
        local v129 = v72 - v66.lastHeight
        if math.abs(v129) > 0.001 then
            v128 = false
        else
            local v130 = v75 - v66.lastYaw
            if math.abs(v130) > 0.0001 then
                v128 = false
            else
                local v131 = v76 - v66.lastPitch
                if math.abs(v131) > 0.0001 then
                    v128 = false
                else
                    local v132 = v77 - v66.lastRoll
                    v128 = not (math.abs(v132) > 0.0001)
                end
            end
        end
    end
    if not v128 then
        v66.lastScale = v125
        v66.lastHeight = v72
        v66.lastYaw = v75
        v66.lastPitch = v76
        v66.lastRoll = v77
        if v126 then
            v66.model:ScaleTo(v125)
        end
        local v133 = v66.model:GetPivot()
        v66.model:PivotTo(CFrame.new(v133.Position) * v66.baseRotation * CFrame.Angles(0, v75, 0) * CFrame.fromOrientation(v76, 0, v77))
        local v134, v135 = v66.model:GetBoundingBox()
        v66.currentHeight = v135.Y
        local v136 = v134.Position.Y - v135.Y / 2
        local v137 = v66.groundY + v72 - v66.groundSink * v135.Y - v136
        local v138 = Vector3.new(0, 0, 0)
        if v66.eggFrame then
            local WorldPosition = v66.eggFrame.WorldPosition
            local v139 = v66.baseCenter.X - WorldPosition.X
            local v140 = v66.baseCenter.Z - WorldPosition.Z
            v138 = Vector3.new(v139, 0, v140)
        end
        local v141 = v138 + Vector3.new(0, v137, 0)
        if v141.Magnitude > 0.001 then
            v66.model:PivotTo(v66.model:GetPivot() + v141)
        end
    end
    v66:_sizeBillboard(v67)
    local timerLabel = v66.timerLabel
    if not (timerLabel and timerLabel.Visible) then
        return
    end
    local v142 = if Phase == "Ready" or Phase == "Skip" then true else v69 <= 0
    local v143
    if v142 then
        v143 = -1
    else
        v143 = math.ceil(v69)
    end
    if v143 == v66.lastTimerKey then
        return
    end
    v66.lastTimerKey = v143
    local v144
    if v142 then
        v144 = "Ready!"
    else
        v144 = EggGrowthBoostText.Decorate(timerLabel, v66.model, MergeConfig.FormatDuration(v69))
    end
    if timerLabel.Text ~= v144 then
        timerLabel.Text = v144
        if v142 then
            timerLabel.TextColor3 = v2.ReadyTextColor
        else
            timerLabel.TextColor3 = Color3.new(1, 1, 1)
        end
    end
end

local function Destroy(v145) -- line 655
    if v145.destroyed then
        return
    end
    v145.destroyed = true
    v145.token += 1
    for v146, v147 in {
            v145.highlight,
            v145.billboard
        } do
        if v147 then
            v147:Destroy()
        end
    end
end

v14.Destroy = Destroy
return v1
