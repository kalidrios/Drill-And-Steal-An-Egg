-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local ShieldModel = require(ReplicatedStorage.Shared.ShieldModel)
local Modules = script.Parent.Parent.Modules
local LightningBolt = require(Modules.LightningBolt)
local SfxBudget = require(Modules.SfxBudget)
local SpatialSfx = require(Modules.SpatialSfx)
local HellPortalController = require(script.Parent.HellPortalController)
local v1 = {}
local PortalCharge = HellEventConfig.PortalCharge
local Portal = HellEventConfig.Portal
local v2 = {}
local v3 = 0
local Folder

local function effects() -- line 72 | captures: Folder, Workspace
    if Folder and Folder.Parent then
        return Folder
    end
    local Folder_2 = Instance.new("Folder")
    Folder_2.Name = "HellPortalChargeFX"
    Folder_2.Parent = Workspace
    Folder = Folder_2
    return Folder_2
end

local function lerp(v4, v5, v6) -- line 83
    return v4 + (v5 - v4) * v6
end

local function adoptGroup(v7) -- line 93 | captures: HellBossConfig, SpatialSfx
    local v8, v9
    if v7 then
        if v7.SoundGroup then
            v9 = true
        else
            local v10 = SpatialSfx.Find(HellBossConfig.Sfx.Folder, HellBossConfig.Sfx.Slam.Name)
            v8 = v10 and v10.SoundGroup or nil
            v9 = false
        end
    else
        v9 = true
    end
    if not v9 then
        v7.SoundGroup = v8
    end
end

local function playSfx(v11, v12) -- line 100 | captures: HellBossConfig, SpatialSfx
    local v13 = SpatialSfx.Play(v11.Folder, v11.Name, {
        At = v12,
        Range = v11.Range,
        MinRange = v11.MinRange,
        RollOffMode = Enum.RollOffMode.Linear,
        Volume = v11.Volume
    })
    local v14, v15
    if v13 then
        if v13.SoundGroup then
            v15 = true
        else
            local v16 = SpatialSfx.Find(HellBossConfig.Sfx.Folder, HellBossConfig.Sfx.Slam.Name)
            v14 = v16 and v16.SoundGroup or nil
            v15 = false
        end
    else
        v15 = true
    end
    if not v15 then
        v13.SoundGroup = v14
    end
end

local function findPylon(v17) -- line 114 | captures: Workspace
    local v18 = Workspace
    for v19, v20 in v17 do
        v18 = v18 and v18:WaitForChild(v20, 15)
    end
    if v18 and v18:IsA("Model") then
        return v18
    end
    warn((("[HellPortalChargeController] pylon Workspace.%* not found"):format((table.concat(v17, ".")))))
    return nil
end

local function capture(v21) -- line 126 | captures: ShieldModel, PortalCharge
    local v22 = {
        model = v21,
        orb = v21:GetPivot().Position,
        shield = ShieldModel.Capture(v21),
        emitters = {},
        beams = {},
        neon = {},
        tweens = {}
    }
    local v23 = v21:FindFirstChild(PortalCharge.Orb, true)
    if not (v23 and v23:IsA("BasePart")) then
        local v24, v25 = v21:GetBoundingBox()
        local Position = v24.Position
        local v26 = v25.Y / 2
        v22.orb = Position + Vector3.new(0, v26, 0)
    else
        v22.orb = v23.Position
    end
    for v27, v28 in v21:GetDescendants() do
        if v28:IsA("ParticleEmitter") then
            local emitters = v22.emitters
            table.insert(emitters, v28)
        elseif v28:IsA("Beam") then
            local beams = v22.beams
            table.insert(beams, v28)
        elseif v28:IsA("BasePart") and v28.Material == Enum.Material.Neon then
            local neon = v22.neon
            local v29 = {
                part = v28,
                color = v28.Color
            }
            table.insert(neon, v29)
        end
    end
    return v22
end

local function cancelTweens(v30) -- line 157
    for v31, v32 in v30.tweens do
        v32:Cancel()
    end
    table.clear(v30.tweens)
    if v30.stopFade then
        v30.stopFade()
        v30.stopFade = nil
    end
end

local function setPower(v33, v34) -- line 175 | captures: TweenService, ShieldModel, PortalCharge, v2, cancelTweens
    for v35, v36 in v2 do
        cancelTweens(v36)
        if v33 then
            ShieldModel.SetPowered(v36.shield, true)
            for v37, v38 in v36.emitters do
                v38.Color = ColorSequence.new(PortalCharge.Color)
                v38.Enabled = true
            end
            for v39, v40 in v36.neon do
                if v34 > 0 then
                    local v41 = TweenService:Create(v40.part, TweenInfo.new(v34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Color = PortalCharge.Color })
                    local tweens = v36.tweens
                    table.insert(tweens, v41)
                    v41:Play()
                else
                    v40.part.Color = PortalCharge.Color
                end
            end
        else
            v36.stopFade = ShieldModel.FadeOff(v36.shield, v34)
        end
        for v42, v43 in v36.beams do
            v43.Enabled = false
        end
    end
end

local function chargeStartedAt() -- line 208 | captures: Workspace, HellEventConfig
    local v44 = Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute)
    if type(v44) == "number" then
        return v44
    end
    return nil
end

local function runCharge(v45) -- line 213 | captures: v3, Folder, RunService, Workspace, HellEventConfig, ShieldModel, LightningBolt, SfxBudget, SpatialSfx, HellPortalController, PortalCharge, Portal, v2, playSfx, cancelTweens, setPower
    v3 += 1
    local v46 = v3
    local Duration = PortalCharge.Duration
    local v47 = math.max(Duration, 0.1)

    local function progress() -- line 217 | captures: v45, v47, Workspace
        local v48 = (Workspace:GetServerTimeNow() - v45) / v47
        return (math.clamp(v48, 0, 1))
    end

    local v49 = (Workspace:GetServerTimeNow() - v45) / v47
    if math.clamp(v49, 0, 1) >= 1 or #v2 == 0 then
        return
    end
    setPower(true, PortalCharge.PowerUpTime)
    local v50 = Vector3.new(0, 0, 0)
    for v51, v52 in v2 do
        v50 += v52.orb
    end
    local v53 = v50 / #v2
    local Charge = PortalCharge.Sfx.Charge
    local PlayLooped = SpatialSfx.PlayLooped
    local Folder_2 = Charge.Folder
    local Name = Charge.Name
    local v54 = {
        At = v53,
        Range = Charge.Range,
        MinRange = Charge.MinRange,
        RollOffMode = Enum.RollOffMode.Linear,
        Volume = Charge.Volume
    }
    local v55 = Charge.FadeOut or 0
    local v56 = PortalCharge.WindDown or 0
    v54.FadeOut = math.max(v55, v56)
    local v57 = PlayLooped(Folder_2, Name, v54)
    local v58 = if PortalCharge.WallBolts == false then false else HellPortalController.GetTargetPoint(v53, 0) ~= nil
    local v59 = {}
    local v60 = {}
    local v61 = {}
    for v62, v63 in v2 do
        if v58 then
            v59[v62] = HellPortalController.GetTargetPoint(v63.orb, 0.1) or v63.orb
            local Arc = LightningBolt.Arc
            local orb = v63.orb
            local v64 = v62

            local function v65() -- line 255 | captures: v59, v64
                return v59[v64]
            end

            local Arc_2 = PortalCharge.Bolts.Arc
            local Folder_2
            if Folder and Folder.Parent then
                Folder_2 = Folder
            else
                Folder_2 = Instance.new("Folder")
                Folder_2.Name = "HellPortalChargeFX"
                Folder_2.Parent = Workspace
                Folder = Folder_2
            end
            v60[v62] = Arc(orb, v65, Arc_2, Folder_2)
            v60[v62]:SetWidth(PortalCharge.ArcWidth.Start)
            v61[v62] = os.clock() + (v62 - 1) * 0.12
        else
            break
        end
    end
    local spawn = task.spawn
    local v66 = v58
    spawn(function() -- line 262 | captures: v45, v46, v47, v53, v57, v59, v60, v61, v66, v3, Folder, RunService, Workspace, HellEventConfig, ShieldModel, LightningBolt, SfxBudget, HellPortalController, PortalCharge, Portal, v2, playSfx, cancelTweens
        while true do
            local v67
            if v46 == v3 then
                v67 = Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute)
                if type(v67) ~= "number" then
                    v67 = nil
                end
            else
                break
            end
            local v68, v69, v70, v71
            if v67 == v45 then
                local v72 = (Workspace:GetServerTimeNow() - v45) / v47
                v68 = math.clamp(v72, 0, 1)
                if v68 >= 1 then
                    v71 = true
                else
                    v69 = os.clock()
                    local Start = PortalCharge.ArcWidth.Start
                    v70 = Start + (PortalCharge.ArcWidth.End - Start) * v68
                    if not v66 then
                        local Kick = HellPortalController.Kick
                        local StartShare = Portal.StartShare
                        Kick(StartShare + (PortalCharge.EndShare - StartShare) * v68)
                    end
                    v71 = false
                end
            else
                v71 = true
            end
            if v71 then
                break
            end
            for v73, v74 in v2 do
                if v66 then
                    v60[v73]:SetWidth(v70)
                    if v61[v73] <= v69 then
                        local Start = PortalCharge.StrikeEvery.Start
                        local v75 = Start + (PortalCharge.StrikeEvery.End - Start) * v68
                        v61[v73] = v69 + v75 * (0.8 + math.random() * 0.4)
                        local v76 = HellPortalController.GetTargetPoint(v74.orb, PortalCharge.TargetSpread)
                        if v76 then
                            v59[v73] = v76
                            local Strike = LightningBolt.Strike
                            local orb = v74.orb
                            local Strike_2 = PortalCharge.Bolts.Strike
                            local Folder_2
                            if Folder and Folder.Parent then
                                Folder_2 = Folder
                            else
                                Folder_2 = Instance.new("Folder")
                                Folder_2.Name = "HellPortalChargeFX"
                                Folder_2.Parent = Workspace
                                Folder = Folder_2
                            end
                            Strike(orb, v76, Strike_2, Folder_2)
                            local StartShare = Portal.StartShare
                            local v77 = StartShare + (PortalCharge.EndShare - StartShare) * v68
                            task.delay(PortalCharge.Bolts.Strike.Leader or 0, HellPortalController.Kick, v77)
                            if SfxBudget.Ready("PortalChargeZap", PortalCharge.Sfx.Zap.Every) then
                                playSfx(PortalCharge.Sfx.Zap, v76)
                            end
                        end
                    end
                else
                    break
                end
            end
            RunService.Heartbeat:Wait()
        end

        local function stopArcs() -- line 298 | captures: v60
            for v78, v79 in v60 do
                v79:Stop(0.3)
            end
        end

        if v46 == v3 then
            local v80 = (Workspace:GetServerTimeNow() - v45) / v47
            if math.clamp(v80, 0, 1) >= 0.95 or Workspace:GetAttribute(HellEventConfig.JoinableAttribute) == true then
                for v81, v82 in v2 do
                    local v83 = v66 and HellPortalController.GetTargetPoint(v82.orb, 0)
                    if v83 then
                        local Strike = LightningBolt.Strike
                        local orb = v82.orb
                        local Final = PortalCharge.Bolts.Final
                        local Folder_2
                        if Folder and Folder.Parent then
                            Folder_2 = Folder
                        else
                            Folder_2 = Instance.new("Folder")
                            Folder_2.Name = "HellPortalChargeFX"
                            Folder_2.Parent = Workspace
                            Folder = Folder_2
                        end
                        Strike(orb, v83, Final, Folder_2)
                    end
                end
                playSfx(PortalCharge.Sfx.Final, v53)
                HellPortalController.Kick(PortalCharge.EndShare)
                v57()
                local v84 = PortalCharge.WindDown or 0
                local v85 = os.clock()
                local Strike = PortalCharge.Bolts.Strike
                while v46 == v3 and v84 > 0 do
                    local v86 = (os.clock() - v85) / v84
                    if v86 >= 1 then
                        break
                    end
                    local v87 = 1 - v86
                    local v88 = os.clock()
                    for v89, v90 in v2 do
                        if v66 then
                            local v91 = v60[v89]
                            local v92 = PortalCharge.ArcWidth.End * v87
                            v91:SetWidth((math.max(v92, 0.05)))
                            if v61[v89] <= v88 then
                                local End = PortalCharge.StrikeEvery.End
                                local v93 = End + ((PortalCharge.StrikeEvery.WindDown or PortalCharge.StrikeEvery.Start) - End) * v86
                                v61[v89] = v88 + v93 * (0.8 + math.random() * 0.4)
                                if math.random() < v87 then
                                    local v94 = HellPortalController.GetTargetPoint(v90.orb, PortalCharge.TargetSpread)
                                    if v94 then
                                        v59[v89] = v94
                                        local v95 = ((PortalCharge.StrikeShrink or 0.3) - 1) * v86 + 1
                                        local v96 = table.clone(Strike)
                                        v96.Width = (Strike.Width or 1) * v95
                                        v96.GlowWidth = (Strike.GlowWidth or 3) * v95
                                        v96.OuterWidth = (Strike.OuterWidth or 8) * v95
                                        local Strike_2 = LightningBolt.Strike
                                        local orb = v90.orb
                                        local Folder_2
                                        if Folder and Folder.Parent then
                                            Folder_2 = Folder
                                        else
                                            Folder_2 = Instance.new("Folder")
                                            Folder_2.Name = "HellPortalChargeFX"
                                            Folder_2.Parent = Workspace
                                            Folder = Folder_2
                                        end
                                        Strike_2(orb, v94, v96, Folder_2)
                                    end
                                end
                            end
                        else
                            break
                        end
                    end
                    RunService.Heartbeat:Wait()
                end
            else
                v57()
            end
            for v97, v98 in v60 do
                v98:Stop(0.3)
            end
            if v46 == v3 then
                local PowerDownTime = PortalCharge.PowerDownTime
                for v99, v100 in v2 do
                    cancelTweens(v100)
                    v100.stopFade = ShieldModel.FadeOff(v100.shield, PowerDownTime)
                    for v101, v102 in v100.beams do
                        v102.Enabled = false
                    end
                end
            end
        else
            for v103, v104 in v60 do
                v104:Stop(0.3)
            end
            v57()
        end
    end)
end

local function onChargeChanged() -- line 370 | captures: Workspace, HellEventConfig, runCharge
    local v105 = Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute)
    if type(v105) ~= "number" then
        v105 = nil
    end
    if v105 then
        runCharge(v105)
    end
end

function v1.Start() -- line 378 | captures: Workspace, HellEventConfig, ShieldModel, PortalCharge, v2, findPylon, capture, cancelTweens, runCharge, onChargeChanged
    if not PortalCharge then
        return
    end
    for v106, v107 in PortalCharge.Pylons do
        local v108 = findPylon(v107)
        if v108 then
            local v109 = capture(v108)
            table.insert(v2, v109)
        end
    end
    for v110, v111 in v2 do
        cancelTweens(v111)
        v111.stopFade = ShieldModel.FadeOff(v111.shield, 0)
        for v112, v113 in v111.beams do
            v113.Enabled = false
        end
    end
    Workspace:GetAttributeChangedSignal(HellEventConfig.PortalChargeAttribute):Connect(onChargeChanged)
    local v114 = Workspace:GetAttribute(HellEventConfig.PortalChargeAttribute)
    if type(v114) ~= "number" then
        v114 = nil
    end
    if v114 then
        runCharge(v114)
    end
end

return v1
