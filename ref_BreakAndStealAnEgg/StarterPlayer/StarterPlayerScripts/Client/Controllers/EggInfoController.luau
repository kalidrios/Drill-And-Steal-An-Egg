-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local EggDespawnClock = require(ReplicatedStorage.Shared.EggDespawnClock)
local EggInfoUi = require(ReplicatedStorage.Shared.EggInfoUi)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local EggLocalHits = require(script.Parent.EggLocalHits)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function resyncDelay() -- line 45 | captures: EggLocalHits
    return EggLocalHits.ConfirmWindow() + 0.2
end

local v3 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In)

local function fullBarGrace() -- line 67 | captures: EggLocalHits
    local v4 = EggLocalHits.ConfirmWindow() + 0.2 + 0.8
    return (math.max(2, v4))
end

local v5 = {}
local v6 = {}

local function setupEgg(v7) -- line 85 | captures: RunService, TweenService, Workspace, EggDespawnClock, EggInfoUi, FormatNumber, EggLocalHits, LocalPlayer, v2, v3, v5, v6
    if not v7:IsA("BasePart") or v7:GetAttribute("_InfoHooked") then
        return
    end
    v7:SetAttribute("_InfoHooked", true)
    task.spawn(function() -- line 96 | captures: v7, RunService, TweenService, Workspace, EggDespawnClock, EggInfoUi, FormatNumber, EggLocalHits, LocalPlayer, v2, v3, v5, v6
        local v8 = EggInfoUi.WaitFor(v7, 10)
        local v9, v10, v11, updateHealth, v12, v13, v14, v15, getHpRefs, hideHpBar, updateEnabled, v16
        if v8 and v7.Parent then
            local v17, v18, Bar

            function getHpRefs() -- line 123 | captures: v17, v18, Bar, v8
                local v19 = v17
                if v19 and v19.hpBar.Parent and v19.bar ~= nil and v19.bar.Parent and v19.hpAmount ~= nil and v19.hpAmount.Parent then
                    return v19
                end
                local v20 = v8:FindFirstChild("HpBar", true)
                local _HpScale
                if v20 and v20:IsA("GuiObject") then
                    _HpScale = v20:FindFirstChild("_HpScale")
                    if _HpScale then
                        if not _HpScale:IsA("UIScale") then
                            _HpScale = Instance.new("UIScale")
                            _HpScale.Name = "_HpScale"
                            _HpScale.Parent = v20
                        end
                    else
                        _HpScale = Instance.new("UIScale")
                        _HpScale.Name = "_HpScale"
                        _HpScale.Parent = v20
                    end
                else
                    return nil
                end
                local Parent = v20.Parent
                if not (Parent and Parent:IsA("GuiObject")) then
                    Parent = nil
                end
                if v18 ~= v20 then
                    v18 = v20
                    v20.Visible = false
                    if Parent then
                        Parent.Visible = false
                    end
                    v20.ClipsDescendants = true
                end
                local Bar_2 = v20:FindFirstChild("Bar")
                if Bar_2 and Bar_2:IsA("GuiObject") and Bar ~= Bar_2 then
                    Bar = Bar_2
                    Bar_2.AnchorPoint = Vector2.new(0, 0.5)
                    Bar_2.Position = UDim2.fromScale(0, 0.5)
                end
                local HpAmount = v20:FindFirstChild("HpAmount")
                local v21 = {
                    hpBar = v20,
                    row = Parent
                }
                if not (Bar_2 and Bar_2:IsA("GuiObject")) then
                    Bar_2 = nil
                end
                v21.bar = Bar_2
                if not (HpAmount and HpAmount:IsA("TextLabel")) then
                    HpAmount = nil
                end
                v21.hpAmount = HpAmount
                v21.scale = _HpScale
                v17 = v21
                return v17
            end

            task.spawn(function() -- line 204 | captures: v8, v7, Workspace, EggDespawnClock, EggInfoUi, LocalPlayer
                local v22, v23
                while true do
                    local v24 = false
                    local v25 = false
                    local v26 = false
                    local v27 = false
                    local v28 = false
                    if v7.Parent then
                        v24 = true
                    else
                        v28 = true
                    end
                    if v24 then
                        if v8.Parent then
                            v25 = true
                        else
                            v28 = true
                        end
                    end
                    v24 = false
                    if v25 then
                        if v22 then
                            v24 = true
                        else
                            v26 = true
                        end
                    end
                    v25 = false
                    if v24 then
                        if v22.Parent then
                            v25 = true
                        else
                            v26 = true
                        end
                    end
                    v24 = false
                    if v25 then
                        if v23 then
                            v24 = true
                        else
                            v26 = true
                        end
                    end
                    v25 = false
                    local v29, v30
                    if v24 then
                        if v23.Parent then
                            v29 = v22
                            v30 = v23
                            v25 = true
                        else
                            v26 = true
                        end
                    end
                    v24 = false
                    local Timer
                    if v26 then
                        Timer = v8:FindFirstChild("Timer")
                        if Timer then
                            v24 = true
                        else
                            v27 = true
                        end
                    end
                    v26 = false
                    if v24 then
                        if Timer:IsA("GuiObject") then
                            v26 = true
                        else
                            v27 = true
                        end
                    end
                    v24 = false
                    local Timer_2
                    if v27 then
                        v24 = true
                    end
                    v27 = false
                    if v26 then
                        Timer_2 = Timer
                        v24 = true
                    end
                    v26 = false
                    local v31
                    if v24 then
                        if Timer_2 then
                            v26 = true
                        else
                            v31 = Timer_2
                            v27 = true
                        end
                    end
                    v24 = false
                    if v26 then
                        v31 = Timer_2:FindFirstChild("TimeLeft", true)
                        v27 = true
                    end
                    v26 = false
                    if v27 then
                        if v31 then
                            v26 = true
                        else
                            v24 = true
                        end
                    end
                    v27 = false
                    if v26 then
                        if v31:IsA("TextLabel") then
                            v27 = true
                        else
                            v24 = true
                        end
                    end
                    v26 = false
                    local v32
                    if v24 then
                        v26 = true
                    end
                    v24 = false
                    if v27 then
                        v32 = v31
                        v26 = true
                    end
                    v27 = false
                    if v26 then
                        if Timer_2 then
                            v29 = Timer_2
                            v30 = v32
                            v25 = true
                        else
                            v27 = true
                        end
                    end
                    v26 = false
                    local v33, v34
                    if v27 then
                        task.wait(0.5)
                        v33 = Timer_2
                        v34 = v32
                        v28 = false
                    end
                    v27 = false
                    local DespawnAt, v35
                    if v25 then
                        DespawnAt = v7:GetAttribute("DespawnAt")
                        local Hatching = v7:GetAttribute("Hatching")
                        if Hatching then
                            v35 = Hatching
                            v26 = true
                        else
                            v27 = true
                        end
                    end
                    v25 = false
                    if v27 then
                        local Broken = v7:GetAttribute("Broken")
                        if Broken then
                            v35 = Broken
                            v26 = true
                        else
                            v25 = true
                        end
                    end
                    v27 = false
                    if v25 then
                        v35 = v7:GetAttribute("Despawning")
                        v26 = true
                    end
                    v25 = false
                    if v26 then
                        if DespawnAt then
                            v27 = true
                        else
                            v25 = true
                        end
                    end
                    v26 = false
                    if v25 then
                        if v29.Visible then
                            v26 = true
                        else
                            v24 = true
                        end
                    end
                    v25 = false
                    if v26 then
                        if v35 then
                            v24 = true
                        else
                            v25 = true
                        end
                    end
                    v26 = false
                    if v25 then
                        v29.Visible = false
                        v24 = true
                    end
                    v25 = false
                    if v24 then
                        task.wait(1)
                        v33 = v29
                        v34 = v30
                        v28 = false
                    end
                    v24 = false
                    local v36
                    if v27 then
                        local v37 = DespawnAt - Workspace:GetServerTimeNow()
                        v36 = math.max(v37, 0)
                        if v35 then
                            v24 = true
                        else
                            v25 = true
                        end
                    end
                    v27 = false
                    if v25 then
                        if v8.PlayerToHideFrom == LocalPlayer then
                            v24 = true
                        else
                            v27 = true
                        end
                    end
                    v25 = false
                    if v27 then
                        if v30 then
                            v25 = true
                        else
                            v26 = true
                        end
                    end
                    if v25 then
                        v30.Text = EggInfoUi.FormatTimer(v36)
                        v26 = true
                    end
                    v25 = false
                    if v26 then
                        if v29.Visible then
                            v24 = true
                        else
                            v25 = true
                        end
                    end
                    if v25 then
                        v29.Visible = true
                        v24 = true
                    end
                    v25 = false
                    if v24 then
                        if v36 <= 0 then
                            v28 = true
                        else
                            v25 = true
                        end
                    end
                    if v25 then
                        task.wait(EggDespawnClock.TickDelay(v36, EggDespawnClock.IsSlowed(v7)))
                        v33 = v29
                        v34 = v30
                        v28 = false
                    end
                    if v28 then
                        break
                    end
                    v22 = v33
                    v23 = v34
                end
            end)
            v9 = nil
            local getHpRefs_2 = getHpRefs

            local function showHpBar() -- line 264 | captures: v9, getHpRefs_2
                local v38 = getHpRefs_2()
                if not v38 then
                    return
                end
                if v9 then
                    local v39 = v9
                    v9 = nil
                    v39:Cancel()
                end
                v38.scale.Scale = 1
                v38.hpBar.Visible = true
                if v38.row then
                    v38.row.Visible = true
                end
            end

            function hideHpBar(v40) -- line 289 | captures: v9, getHpRefs_2, TweenService, v3
                local v41 = getHpRefs_2()
                if v41 then
                    if v40 then
                        if v9 then
                            local v42 = v9
                            v9 = nil
                            v42:Cancel()
                        end
                        v41.hpBar.Visible = false
                        if v41.row then
                            v41.row.Visible = false
                        end
                        v41.scale.Scale = 1
                    elseif v41.hpBar.Visible and not v9 then
                        local hpBar = v41.hpBar
                        local row = v41.row
                        local scale = v41.scale
                        local v43 = TweenService:Create(scale, v3, { Scale = 0 })
                        v9 = v43
                        v43.Completed:Once(function() -- line 317 | captures: hpBar, row, scale, v43, v9
                            if v9 ~= v43 then
                                return
                            end
                            v9 = nil
                            hpBar.Visible = false
                            if row then
                                row.Visible = false
                            end
                            scale.Scale = 1
                        end)
                        v43:Play()
                    end
                end
            end

            v10 = false
            v11 = nil

            function updateEnabled() -- line 342 | captures: v10, v8, v7
                if v10 then
                    return
                end
                local v44 = not v7:GetAttribute("Broken") and not v7:GetAttribute("Hatching") and not v7:GetAttribute("Despawning")
                v8.Enabled = v44
            end

            local hideHpBar_2 = hideHpBar

            local function playOneShotDrain(v45) -- line 355 | captures: v9, v10, updateHealth, v8, getHpRefs_2, hideHpBar_2, v7, RunService, FormatNumber
                local v46 = getHpRefs_2()
                if not v46 then
                    return
                end
                v10 = true
                v8.Enabled = true
                local v47 = getHpRefs_2()
                if v47 then
                    if v9 then
                        local v48 = v9
                        v9 = nil
                        v48:Cancel()
                    end
                    v47.scale.Scale = 1
                    v47.hpBar.Visible = true
                    if v47.row then
                        v47.row.Visible = true
                    end
                end
                task.spawn(function() -- line 364 | captures: v45, v46, v10, updateHealth, v8, hideHpBar_2, v7, RunService, FormatNumber
                    local v49 = FormatNumber.Short((math.floor(v45)))
                    local v50 = os.clock()
                    while true do
                        local v51, v52
                        if v46.hpBar.Parent and v7.Parent then
                            local v53 = (os.clock() - v50) / 0.55
                            v51 = math.clamp(v53, 0, 1)
                            local v54 = 1 - (1 - v51) ^ 2
                            v52 = v45 * (1 - v54)
                            if v46.bar then
                                v46.bar.Position = UDim2.fromScale(-v54, 0.5)
                            end
                        else
                            break
                        end
                        if v46.hpAmount then
                            v46.hpAmount.Text = ("%*/%* HP"):format(FormatNumber.Short((math.floor(v52))), v49)
                        end
                        if v51 >= 1 then
                            break
                        end
                        RunService.RenderStepped:Wait()
                    end
                    task.wait(0.2)
                    if v46.hpBar.Parent then
                        hideHpBar_2()
                    end
                    v10 = false
                    if not v10 then
                        local v55 = not v7:GetAttribute("Broken") and not v7:GetAttribute("Hatching") and not v7:GetAttribute("Despawning")
                        v8.Enabled = v55
                    end
                    if updateHealth then
                        updateHealth()
                    end
                end)
            end

            v12 = nil
            v13 = false
            v14 = 0
            v15 = false
            v16 = v7:GetAttribute("Titanic") == true
        else
            return
        end
        local getHpRefs_2 = getHpRefs
        local hideHpBar_2 = hideHpBar
        local v56 = v16
        local updateHealth_2

        local function updateHealth_3() -- line 425 | captures: v9, v10, v11, updateHealth, v12, v13, v14, v15, v8, getHpRefs_2, hideHpBar_2, v56, updateHealth_2, v7, RunService, TweenService, FormatNumber, EggLocalHits, LocalPlayer, v2, v5, v6
            local v57 = getHpRefs_2()
            if not v57 or v10 then
                return
            end
            local v58 = EggLocalHits.GetDisplayHealth(v7)
            local v59 = v7:GetAttribute("Health") or 0
            local v60 = v7:GetAttribute("MaxHealth") or 1
            local v61 = v58 / v60
            local v62 = math.clamp(v61, 0, 1)
            local v63 = v11
            v11 = v58
            if v63 ~= nil and v58 < v63 then
                v14 = os.clock()
            end
            if v58 <= 0 and v63 ~= nil and v60 <= v63 then
                local v64 = getHpRefs_2()
                if v64 then
                    v10 = true
                    v8.Enabled = true
                    local v65 = getHpRefs_2()
                    if v65 then
                        if v9 then
                            local v66 = v9
                            v9 = nil
                            v66:Cancel()
                        end
                        v65.scale.Scale = 1
                        v65.hpBar.Visible = true
                        if v65.row then
                            v65.row.Visible = true
                        end
                    end
                    task.spawn(function() -- line 364 | captures: v60, v64, v10, updateHealth, v8, hideHpBar_2, v7, RunService, FormatNumber
                        local v67 = FormatNumber.Short((math.floor(v60)))
                        local v68 = os.clock()
                        while true do
                            local v69, v70
                            if v64.hpBar.Parent and v7.Parent then
                                local v71 = (os.clock() - v68) / 0.55
                                v69 = math.clamp(v71, 0, 1)
                                local v72 = 1 - (1 - v69) ^ 2
                                v70 = v60 * (1 - v72)
                                if v64.bar then
                                    v64.bar.Position = UDim2.fromScale(-v72, 0.5)
                                end
                            else
                                break
                            end
                            if v64.hpAmount then
                                v64.hpAmount.Text = ("%*/%* HP"):format(FormatNumber.Short((math.floor(v70))), v67)
                            end
                            if v69 >= 1 then
                                break
                            end
                            RunService.RenderStepped:Wait()
                        end
                        task.wait(0.2)
                        if v64.hpBar.Parent then
                            hideHpBar_2()
                        end
                        v10 = false
                        if not v10 then
                            local v73 = not v7:GetAttribute("Broken") and not v7:GetAttribute("Hatching") and not v7:GetAttribute("Despawning")
                            v8.Enabled = v73
                        end
                        if updateHealth then
                            updateHealth()
                        end
                    end)
                end
            else
                local v74 = v8.PlayerToHideFrom == LocalPlayer
                local v75
                if v57.bar then
                    if v74 then
                        v75 = true
                    else
                        if v12 then
                            v12:Cancel()
                        end
                        v75 = false
                    end
                else
                    v75 = true
                end
                if not v75 then
                    v12 = TweenService:Create(v57.bar, v2, { Position = UDim2.fromScale(v62 - 1, 0.5) })
                    v12:Play()
                end
                if v57.hpAmount and not v74 then
                    v57.hpAmount.Text = ("%*/%* HP"):format(FormatNumber.Short((math.floor(v58))), (FormatNumber.Short((math.floor(v60)))))
                end
                if v7:GetAttribute("Hatching") or v7:GetAttribute("Broken") then
                    local v76 = getHpRefs_2()
                    if v76 then
                        if v9 then
                            local v77 = v9
                            v9 = nil
                            v77:Cancel()
                        end
                        v76.hpBar.Visible = false
                        if v76.row then
                            v76.row.Visible = false
                        end
                        v76.scale.Scale = 1
                    end
                elseif v59 <= 0 then
                    hideHpBar_2()
                elseif v56 then
                    local v78 = getHpRefs_2()
                    if v78 then
                        if v9 then
                            local v79 = v9
                            v9 = nil
                            v79:Cancel()
                        end
                    else
                        return
                    end
                    v78.scale.Scale = 1
                    v78.hpBar.Visible = true
                    if v78.row then
                        v78.row.Visible = true
                    end
                elseif v58 < v60 then
                    local v80 = v14
                    local v81 = v6[v7] or 0
                    local v82 = math.max(v80, v81)
                    local v83 = os.clock() - v82
                    if v82 > 0 and v83 < 6 then
                        local v84 = getHpRefs_2()
                        if v84 then
                            if v9 then
                                local v85 = v9
                                v9 = nil
                                v85:Cancel()
                            end
                            v84.scale.Scale = 1
                            v84.hpBar.Visible = true
                            if v84.row then
                                v84.row.Visible = true
                            end
                        end
                    else
                        hideHpBar_2()
                        return
                    end
                    if not v15 then
                        v15 = true
                        task.delay(6 - v83 + 0.05, function() -- line 502 | captures: v15, updateHealth_2, v7, v5
                            v15 = false
                            if v7.Parent and v5[v7] then
                                updateHealth_2()
                            end
                        end)
                    end
                else
                    local v86 = v6[v7]
                    local v87 = EggLocalHits.ConfirmWindow() + 0.2 + 0.8
                    local v88 = math.max(2, v87)
                    if v86 and os.clock() - v86 < v88 then
                        local v89 = getHpRefs_2()
                        if v89 then
                            if v9 then
                                local v90 = v9
                                v9 = nil
                                v90:Cancel()
                            end
                            v89.scale.Scale = 1
                            v89.hpBar.Visible = true
                            if v89.row then
                                v89.row.Visible = true
                            end
                        end
                        if not v13 then
                            v13 = true
                            task.delay(v88, function() -- line 526 | captures: v13, updateHealth_2, v7, v5
                                v13 = false
                                if v7.Parent and v5[v7] then
                                    updateHealth_2()
                                end
                            end)
                        end
                    else
                        hideHpBar_2()
                    end
                end
            end
        end

        updateHealth_2 = updateHealth_3
        updateHealth = updateHealth_3
        task.spawn(function() -- line 546 | captures: v8, updateHealth_3, getHpRefs_2, v7
            local v91 = os.clock() + 10
            while true do
                if os.clock() < v91 and v8.Parent and v7.Parent then
                    local v92 = getHpRefs_2()
                    if v92 and v92.bar and v92.hpAmount then
                        break
                    end
                    task.wait(0.2)
                    continue
                end
                return
            end
            updateHealth_3()
        end)
        v7:GetAttributeChangedSignal("Health"):Connect(updateHealth_3)
        v7:GetAttributeChangedSignal("MaxHealth"):Connect(updateHealth_3)
        v7:GetAttributeChangedSignal("Broken"):Connect(function() -- line 563 | captures: v10, v8, updateHealth_3, v7
            if not v10 then
                local v93 = not v7:GetAttribute("Broken") and not v7:GetAttribute("Hatching") and not v7:GetAttribute("Despawning")
                v8.Enabled = v93
            end
            updateHealth_3()
        end)
        v7:GetAttributeChangedSignal("Hatching"):Connect(function() -- line 567 | captures: v10, v8, updateHealth_3, v7
            if not v10 then
                local v94 = not v7:GetAttribute("Broken") and not v7:GetAttribute("Hatching") and not v7:GetAttribute("Despawning")
                v8.Enabled = v94
            end
            updateHealth_3()
        end)
        v7:GetAttributeChangedSignal("Despawning"):Connect(updateEnabled)
        updateHealth_3()
        if not v10 then
            local v95 = not v7:GetAttribute("Broken") and not v7:GetAttribute("Hatching") and not v7:GetAttribute("Despawning")
            v8.Enabled = v95
        end
        v5[v7] = updateHealth_3
        v7.Destroying:Connect(function() -- line 576 | captures: v7, v5, v6
            v5[v7] = nil
            v6[v7] = nil
        end)
    end)
end

function v1.Start() -- line 583 | captures: CollectionService, EggLocalHits, v5, v6, setupEgg
    for v96, v97 in CollectionService:GetTagged("BreakableEgg") do
        setupEgg(v97)
    end
    CollectionService:GetInstanceAddedSignal("BreakableEgg"):Connect(setupEgg)
    EggLocalHits.OnHit(function(v98) -- line 591 | captures: EggLocalHits, v5, v6
        local v99 = v5[v98]
        if not v99 then
            return
        end
        v6[v98] = os.clock()
        v99()
        task.delay(EggLocalHits.ConfirmWindow() + 0.2, function() -- line 596 | captures: v98, v5
            local v100 = v5[v98]
            if v100 then
                v100()
            end
        end)
    end)
    EggLocalHits.OnReject(function(v101) -- line 609 | captures: v5
        local v102 = v5[v101]
        if v102 then
            v102()
        end
    end)
    EggLocalHits.OnConfirm(function(v103) -- line 618 | captures: v5
        local v104 = v5[v103]
        if v104 then
            v104()
        end
    end)
end

return v1
