-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local AutoSwingConfig = require(ReplicatedStorage.Shared.AutoSwingConfig)
local BatToolQuery = require(ReplicatedStorage.Shared.BatToolQuery)
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local EggTargeting = require(ReplicatedStorage.Shared.EggTargeting)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local BatController = require(script.Parent.BatController)
local BatEquipState = require(script.Parent.BatEquipState)
local HellBossController = require(script.Parent.HellBossController)
local PickaxeController = require(script.Parent.PickaxeController)
local PickaxeEquipState = require(script.Parent.PickaxeEquipState)
local LocalPlayer = Players.LocalPlayer
local v1 = TweenInfo.new(AutoSwingConfig.TweenDuration, AutoSwingConfig.TweenEasingStyle, AutoSwingConfig.TweenEasingDirection)
local v2 = EggConfig.HitRange - AutoSwingConfig.RangeMargin
local v3 = math.max(0, v2)
local v4 = EggConfig.HitRange - AutoSwingConfig.StickyRangeMargin
local v5 = math.max(v3, v4)
local v6 = { Changed = Instance.new("BindableEvent") }
local v7 = AutoSwingConfig.DefaultOn
local v8 = 0
local v9 = (-1/0)
local v10, v11, v12
local v13 = {}

function v6.IsOn() -- line 122 | captures: v7
    return v7
end

local v14 = false

local function stateGradients() -- line 132 | captures: v14, ReplicatedStorage, AutoSwingConfig
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local v15 = Assets and Assets:FindFirstChild(AutoSwingConfig.StateGradientsFolder)
    local v16
    if v15 then
        v16 = v15:FindFirstChild("Off")
        v15 = v15:FindFirstChild("On")
    else
        v16 = v15
    end
    if v16 and v16:IsA("UIGradient") and v15 and v15:IsA("UIGradient") then
        return v16, v15
    end
    if not v14 then
        v14 = true
        warn(("[AutoSwingController] ReplicatedStorage.Assets.%*"):format(AutoSwingConfig.StateGradientsFolder) .. " Off/On (UIGradients) not found \226\128\148 button keeps its authored colours")
    end
    return nil, nil
end

local function sampleSequence(v17, v18) -- line 152
    local Keypoints = v17.Keypoints
    if v18 <= Keypoints[1].Time then
        return Keypoints[1].Value
    end
    local v19 = #Keypoints - 1
    for v20 = 1, v19 do
        local v21 = Keypoints[v20 + 1]
        if v18 <= v21.Time then
            local v22 = Keypoints[v20]
            local v23 = v21.Time - v22.Time
            local v24 = if v23 > 0 then (v18 - v22.Time) / v23 else 1
            return v22.Value:Lerp(v21.Value, v24)
        end
    end
    return Keypoints[#Keypoints].Value
end

local function blendStateColors(v25, v26, v27) -- line 174 | captures: sampleSequence
    local function v28(v29, ...)
        table.insert(v29, ...)
    end

    if v27 <= 0 then
        return v25
    end
    if v27 >= 1 then
        return v26
    end
    local v30 = {}
    local v31 = {}
    for v32, v33 in { v25, v26 } do
        for v34, v35 in v33.Keypoints do
            local v36 = v35.Time * 1000 + 0.5
            local v37 = math.floor(v36)
            if not v30[v37] then
                v30[v37] = true
                local Time = v35.Time
                table.insert(v31, Time)
            end
        end
    end
    table.sort(v31)
    local v38 = table.create(#v31)
    for v39, v40 in v31 do
        local v41 = sampleSequence(v25, v40):Lerp(sampleSequence(v26, v40), v27)
        v28(v38, ColorSequenceKeypoint.new(v40, v41))
    end
    return ColorSequence.new(v38)
end

local function batAllowed() -- line 204 | captures: AutoSwingConfig, HellEventConfig, LocalPlayer
    return AutoSwingConfig.BatInHell and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true
end

local function getRoot() -- line 208 | captures: LocalPlayer
    local Character = LocalPlayer.Character
    local v42 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v42 and v42:IsA("BasePart") then
        return v42
    end
    return nil
end

local function equipPickaxe() -- line 218 | captures: AutoSwingConfig, BatToolQuery, HellEventConfig, PickaxeConfig, LocalPlayer
    local Character = LocalPlayer.Character
    local v43 = Character and Character:FindFirstChildOfClass("Humanoid")
    if not v43 or v43.Health <= 0 or Character:FindFirstChildOfClass("Tool") then
        return
    end
    local Backpack, v44, v45
    if LocalPlayer:GetAttribute("Carrying") == nil then
        if Character:GetAttribute("Ragdolled") then
            v45 = true
        else
            Backpack = LocalPlayer:FindFirstChild("Backpack")
            v44 = Backpack and Backpack:FindFirstChild(PickaxeConfig.ToolName)
            v45 = false
        end
    else
        v45 = true
    end
    if v45 then
        return
    end
    if not (v44 and v44:IsA("Tool")) then
        if Backpack and AutoSwingConfig.BatInHell and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
            for v46, v47 in Backpack:GetChildren() do
                if BatToolQuery.IsBatWeapon(v47) then
                    v43:EquipTool(v47)
                    return
                end
            end
        end
    else
        v43:EquipTool(v44)
    end
end

local function pickTarget() -- line 251 | captures: EggTargeting, PickaxeController, LocalPlayer, v3, v5
    local Character = LocalPlayer.Character
    local v48 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (v48 and v48:IsA("BasePart")) then
        v48 = nil
    end
    if v48 then
        return EggTargeting.Pick(v48.Position, v3, PickaxeController.GetLastHitEgg(), v5)
    end
    return nil
end

local function tick() -- line 261 | captures: AutoSwingConfig, EggTargeting, HellEventConfig, BatController, BatEquipState, HellBossController, PickaxeController, LocalPlayer, v3, v5
    if AutoSwingConfig.BatInHell and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true and BatEquipState.IsEquipped() then
        if HellBossController.CanBatHit() then
            BatController.Swing()
        end
    else
        if not PickaxeController.IsWielding() then
            return
        end
        local Character = LocalPlayer.Character
        local v49 = Character and Character:FindFirstChildOfClass("Humanoid")
        local v50, v51
        if v49 then
            if v49.Health <= 0 then
                v51 = true
            else
                local Character = LocalPlayer.Character
                v50 = Character and Character:FindFirstChild("HumanoidRootPart")
                v51 = false
            end
        else
            v51 = true
        end
        if v51 then
            return
        end
        if not (v50 and v50:IsA("BasePart")) then
            v50 = nil
        end
        local v52
        if v50 then
            v52 = EggTargeting.Pick(v50.Position, v3, PickaxeController.GetLastHitEgg(), v5)
        end
        if v52 then
            PickaxeController.Swing(v52)
        end
    end
end

local function setOn(v53) -- line 286 | captures: v7, v8, v10, AutoSwingConfig, v6, equipPickaxe
    if v7 == v53 then
        return
    end
    v7 = v53
    if v53 then
        v8 = AutoSwingConfig.TickInterval
    else
        v8 = 0
    end
    if v53 and AutoSwingConfig.EquipPickaxeOnEnable then
        local v54, v55 = pcall(equipPickaxe)
        if not v54 then
            warn((("[AutoSwingController] equip on enable failed: %*"):format(v55)))
        end
    end
    local v56 = v10
    if v56 then
        local v57, v58 = pcall(v56, true)
        if not v57 then
            warn((("[AutoSwingController] button visual failed: %*"):format(v58)))
        end
    end
    v6.Changed:Fire(v7)
end

function v6.SetOn(v59) -- line 314 | captures: setOn
    setOn(v59 == true)
end

local function setupGui(v60) -- line 321 | captures: v7, v9, v10, v11, v12, TweenService, AutoSwingConfig, HellEventConfig, BatEquipState, PickaxeEquipState, LocalPlayer, v1, v13, stateGradients, blendStateColors, setOn
    local function v61(v62, ...)
        table.insert(v62, ...)
    end

    local function v63(v64, ...)
        table.insert(v64, ...)
    end

    local v65 = v60:WaitForChild(AutoSwingConfig.ButtonName, 10)
    if not (v65 and v65:IsA("GuiButton") and v65 ~= v11 and v65:WaitForChild("UiGradient", 10) and v65.Parent ~= nil and v65 ~= v11) then
        return
    end
    v11 = v65
    local v66 = {}
    for v67, v68 in v65:GetDescendants() do
        if v68:IsA("UIGradient") then
            table.insert(v66, v68)
        end
    end
    local Color, Color_2

    local function refreshStateColors() -- line 367 | captures: Color, Color_2, stateGradients
        local v69, v70 = stateGradients()
        if v69 then
            Color = v69.Color
        else
            Color = nil
        end
        if v70 then
            Color_2 = v70.Color
        else
            Color_2 = nil
        end
    end

    local function applyColors(v71) -- line 373 | captures: Color, Color_2, v66, blendStateColors
        if Color and Color_2 then
            local v72 = blendStateColors(Color, Color_2, v71)
            for v73, v74 in v66 do
                v74.Color = v72
            end
        end
    end

    local NumberValue = Instance.new("NumberValue")
    NumberValue.Name = "AutoSwingColorAlpha"
    NumberValue.Parent = v65
    NumberValue.Changed:Connect(applyColors)
    local v75

    local function applyState(v76) -- line 392 | captures: Color, Color_2, v75, v66, NumberValue, v7, TweenService, v1, stateGradients, blendStateColors
        local v77 = if v7 then 1 else 0
        local v78, v79 = stateGradients()
        if v78 then
            Color = v78.Color
        else
            Color = nil
        end
        if v79 then
            Color_2 = v79.Color
        else
            Color_2 = nil
        end
        if v75 ~= nil then
            v75:Cancel()
            v75 = nil
        end
        if v76 then
            v75 = TweenService:Create(NumberValue, v1, { Value = v77 })
            v75:Play()
        else
            NumberValue.Value = v77
            if Color and Color_2 then
                local v80 = blendStateColors(Color, Color_2, v77)
                for v81, v82 in v66 do
                    v82.Color = v80
                end
            end
        end
    end

    local v83 = if v7 then 1 else 0
    local v84, v85 = stateGradients()
    if v84 then
        Color = v84.Color
    else
        Color = nil
    end
    if v85 then
        Color_2 = v85.Color
    else
        Color_2 = nil
    end
    if v75 ~= nil then
        v75:Cancel()
        v75 = nil
    end
    NumberValue.Value = v83
    if Color and Color_2 then
        local v86 = blendStateColors(Color, Color_2, v83)
        for v87, v88 in v66 do
            v88.Color = v86
        end
    end
    if AutoSwingConfig.ShowOnlyWhileEquipped then
        local function refreshVisible() -- line 421 | captures: v65, v11, AutoSwingConfig, HellEventConfig, BatEquipState, PickaxeEquipState, LocalPlayer
            if v11 ~= v65 then
                return
            end
            local v89 = PickaxeEquipState.IsEquipped()
            if not v89 then
                v89 = AutoSwingConfig.BatInHell
                if v89 then
                    if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
                        v89 = BatEquipState.IsEquipped()
                    else
                        v89 = false
                    end
                end
            end
            v65.Visible = v89
        end

        if v12 then
            v12:Disconnect()
        end
        for v90, v91 in v13 do
            v91:Disconnect()
        end
        table.clear(v13)
        v12 = PickaxeEquipState.Observe(refreshVisible)
        v61(v13, BatEquipState.Observe(refreshVisible))
        v63(v13, LocalPlayer:GetAttributeChangedSignal(HellEventConfig.PlayerAttribute):Connect(refreshVisible))
    else
        v65.Visible = true
    end

    function v10(v92) -- line 445 | captures: v65, applyState, v11
        if v11 == v65 and v65.Parent ~= nil then
            applyState(v92)
        end
    end

    v65.Activated:Connect(function() -- line 451 | captures: v65, v7, v9, v11, AutoSwingConfig, setOn
        if v11 == v65 then
            local v93 = os.clock()
            if not (v93 - v9 < AutoSwingConfig.ToggleDebounce) then
                v9 = v93
                setOn(not v7)
            end
        end
    end)
end

function v6.Start() -- line 467 | captures: v7, v8, RunService, AutoSwingConfig, PickaxeController, LocalPlayer, pickTarget, tick, setupGui
    PickaxeController.SetAutoTargeting(function() -- line 473 | captures: v7, pickTarget
        if v7 then
            return pickTarget()
        end
        return nil
    end)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    PlayerGui.ChildAdded:Connect(function(v94) -- line 485 | captures: setupGui
        if v94.Name == "MainGUI" then
            task.defer(setupGui, v94)
        end
    end)
    local v95 = PlayerGui:WaitForChild("MainGUI", 30)
    if v95 then
        setupGui(v95)
    end
    RunService.Heartbeat:Connect(function(v96) -- line 500 | captures: v7, v8, AutoSwingConfig, tick
        if v7 then
            v8 += v96
            if not (v8 < AutoSwingConfig.TickInterval) then
                v8 = 0
                local v97, v98 = pcall(tick)
                if not v97 then
                    warn((("[AutoSwingController] tick failed: %*"):format(v98)))
                end
            end
        end
    end)
end

return v6
