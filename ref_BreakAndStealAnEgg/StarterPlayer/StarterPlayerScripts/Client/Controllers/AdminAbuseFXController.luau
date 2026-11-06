-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AdminAbuseConfig = require(ReplicatedStorage.Shared.AdminAbuseConfig)
local CameraFovController = require(script.Parent.CameraFovController)
local Transition = AdminAbuseConfig.Transition
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local NumberValue = Instance.new("NumberValue")

NumberValue.Name = "AdminAbuseFXAlpha"
NumberValue.Value = 0

local v2, Frame
local v3 = 0
local v4 = {}
local v5 = {}
local v6 = {}
local v7, v8

local function isEventActive() -- line 69 | captures: Workspace, AdminAbuseConfig
    return Workspace:GetAttribute(AdminAbuseConfig.StartedAtAttribute) ~= nil
end

local function setAdminSky(v9) -- line 77 | captures: v7, Lighting, Transition, v5, v6
    if v9 then
        if v7 == nil or v7.Parent == nil then
            local v10 = Lighting:FindFirstChild(Transition.SkiesFolderName)
            local v11 = v10 and v10:FindFirstChild(Transition.SkyName)
            if v11 ~= nil and v11:IsA("Sky") then
                for v12, v13 in Lighting:GetChildren() do
                    if v13:IsA("Sky") then
                        v13.Parent = nil
                        table.insert(v5, v13)
                    end
                end
                local v14 = v11:Clone()
                if Transition.HideSun then
                    v14.SunAngularSize = 0
                    for v15, v16 in Lighting:GetChildren() do
                        if v16:IsA("SunRaysEffect") and v16.Enabled then
                            v16.Enabled = false
                            table.insert(v6, v16)
                        end
                    end
                end
                v14.Parent = Lighting
                v7 = v14
            else
                warn((("[AdminAbuseFXController] Lighting.%*.%* (Sky) not found"):format(Transition.SkiesFolderName, Transition.SkyName)))
            end
        end
    else
        if v7 ~= nil then
            v7:Destroy()
            v7 = nil
        end
        for v17, v18 in v5 do
            v18.Parent = Lighting
        end
        table.clear(v5)
        for v19, v20 in v6 do
            v20.Enabled = true
        end
        table.clear(v6)
    end
end

local function setAdminVfx(v21) -- line 127 | captures: v8, ReplicatedStorage, Workspace, Transition
    if v21 then
        if v8 == nil or v8.Parent == nil then
            local v22 = ReplicatedStorage:FindFirstChild(Transition.VFXFolderName)
            local v23 = v22 and v22:FindFirstChild(Transition.VFXName)
            if v23 == nil then
                warn((("[AdminAbuseFXController] ReplicatedStorage.%*.%* not found"):format(Transition.VFXFolderName, Transition.VFXName)))
            else
                local v24 = v23:Clone()
                for v25, v26 in v24:GetDescendants() do
                    if v26:IsA("BasePart") then
                        v26.Anchored = true
                        v26.CanCollide = false
                        v26.CanQuery = false
                        v26.CanTouch = false
                    end
                end
                v24.Parent = Workspace
                v8 = v24
            end
        end
    elseif v8 ~= nil then
        v8:Destroy()
        v8 = nil
    end
end

local function setAdminEnvironment(v27) -- line 157 | captures: setAdminSky, setAdminVfx
    setAdminSky(v27)
    setAdminVfx(v27)
end

local function getBlur() -- line 166 | captures: v2, Lighting
    local v28 = v2
    if v28 == nil or v28.Parent == nil then
        local BlurEffect = Instance.new("BlurEffect")
        BlurEffect.Name = "AdminAbuseBlur"
        BlurEffect.Size = 0
        BlurEffect.Enabled = false
        BlurEffect.Parent = Lighting
        v2 = BlurEffect
        return BlurEffect
    end
    return v28
end

local function applyFx() -- line 180 | captures: v2, Lighting, CameraFovController, Transition, NumberValue
    local Value = NumberValue.Value
    local v29 = v2
    if v29 == nil or v29.Parent == nil then
        v29 = Instance.new("BlurEffect")
        v29.Name = "AdminAbuseBlur"
        v29.Size = 0
        v29.Enabled = false
        v29.Parent = Lighting
        v2 = v29
    end
    v29.Size = Transition.BlurSize * Value
    v29.Enabled = Value > 0.001
    if Value <= 0.001 then
        CameraFovController.Clear("AdminAbuse")
    else
        CameraFovController.Set("AdminAbuse", Transition.FovIncrease * Value)
    end
end

local function getHolder() -- line 197 | captures: Transition, LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local AdminAbuseFXHolder = PlayerGui:FindFirstChild("AdminAbuseFXHolder")
    if AdminAbuseFXHolder ~= nil and AdminAbuseFXHolder:IsA("ScreenGui") then
        return AdminAbuseFXHolder
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AdminAbuseFXHolder"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = Transition.DisplayOrder
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    return ScreenGui
end

local function getOverlay() -- line 216 | captures: Frame, Transition, getHolder
    local Frame_2 = Frame
    if Frame_2 == nil or Frame_2.Parent == nil then
        local Frame_2 = Instance.new("Frame")
        Frame_2.Name = "WhiteOverlay"
        Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame_2.Position = UDim2.fromScale(0.5, 0.5)
        Frame_2.Size = UDim2.fromScale(Transition.OverlayScale, Transition.OverlayScale)
        Frame_2.BackgroundColor3 = Transition.OverlayColor
        Frame_2.BackgroundTransparency = 1
        Frame_2.BorderSizePixel = 0
        Frame_2.Visible = false
        Frame_2.Parent = getHolder()
        Frame = Frame_2
        return Frame_2
    end
    return Frame_2
end

local function cancelTweens() -- line 241 | captures: v4
    for v30, v31 in v4 do
        v31:Cancel()
    end
    table.clear(v4)
end

local function startTween(v32, v33, v34) -- line 248 | captures: TweenService, v4
    local v35 = TweenService:Create(v32, v33, v34)
    table.insert(v4, v35)
    v35:Play()
    return v35
end

local function waitTween(v36, v37, v38) -- line 256 | captures: TweenService, v4
    local v39 = TweenService:Create(v36, v37, v38)
    table.insert(v4, v39)
    v39:Play()
    if v39.PlaybackState == Enum.PlaybackState.Completed then
        return true
    end
    return v39.Completed:Wait() == Enum.PlaybackState.Completed
end

local function playTransition() -- line 264 | captures: v3, TweenService, Workspace, AdminAbuseConfig, Transition, NumberValue, v4, setAdminSky, setAdminVfx, getOverlay
    for v40, v41 in v4 do
        v41:Cancel()
    end
    table.clear(v4)
    v3 += 1
    local v42 = v3
    task.spawn(function() -- line 269 | captures: v42, v3, TweenService, Workspace, AdminAbuseConfig, Transition, NumberValue, v4, setAdminSky, setAdminVfx, getOverlay
        local v43 = getOverlay()
        v43.Visible = true
        local v44 = TweenInfo.new(Transition.EffectInTime, Transition.EffectEasingStyle, Enum.EasingDirection.Out)
        local v45 = { Value = 1 }
        local v46 = TweenService:Create(NumberValue, v44, v45)
        table.insert(v4, v46)
        v46:Play()
        local v47 = TweenInfo.new(Transition.FadeInTime, Transition.FadeInEasingStyle, Transition.FadeInEasingDirection)
        local v48 = { BackgroundTransparency = 0 }
        local v49 = TweenService:Create(v43, v47, v48)
        table.insert(v4, v49)
        v49:Play()
        local v50
        if (v49.PlaybackState == Enum.PlaybackState.Completed or v49.Completed:Wait() == Enum.PlaybackState.Completed) and v42 == v3 then
            v50 = Workspace:GetAttribute(AdminAbuseConfig.StartedAtAttribute) ~= nil
        else
            return
        end
        setAdminSky(v50)
        setAdminVfx(v50)
        task.wait(Transition.HoldTime)
        if v42 ~= v3 then
            return
        end
        local v51 = TweenInfo.new(Transition.EffectOutTime, Transition.EffectEasingStyle, Enum.EasingDirection.InOut)
        local v52 = { Value = 0 }
        local v53 = TweenService:Create(NumberValue, v51, v52)
        table.insert(v4, v53)
        v53:Play()
        local v54 = TweenInfo.new(Transition.FadeOutTime, Transition.FadeOutEasingStyle, Transition.FadeOutEasingDirection)
        local v55 = { BackgroundTransparency = 1 }
        local v56 = TweenService:Create(v43, v54, v55)
        table.insert(v4, v56)
        v56:Play()
        local v57 = if v56.PlaybackState == Enum.PlaybackState.Completed then true else v56.Completed:Wait() == Enum.PlaybackState.Completed
        if v57 and v42 == v3 then
            v43.Visible = false
        end
    end)
end

function v1.Start() -- line 312 | captures: Frame, v3, v7, v8, Lighting, TweenService, Workspace, AdminAbuseConfig, Transition, NumberValue, v4, v5, v6, setAdminSky, setAdminVfx, applyFx, getOverlay
    NumberValue.Changed:Connect(applyFx)
    local v58
    if Workspace:GetAttribute(AdminAbuseConfig.StartedAtAttribute) == nil then
        v58 = false
    else
        v58 = true
        setAdminSky(true)
        setAdminVfx(true)
    end
    Workspace:GetAttributeChangedSignal(AdminAbuseConfig.StartedAtAttribute):Connect(function() -- line 321 | captures: v58, Frame, v3, v7, v8, Lighting, TweenService, Workspace, AdminAbuseConfig, Transition, NumberValue, v4, v5, v6, setAdminSky, setAdminVfx, getOverlay
        local v59 = Workspace:GetAttribute(AdminAbuseConfig.StartedAtAttribute) ~= nil
        if v59 ~= v58 then
            v58 = v59
            if v59 or Transition.PlayOnEnd then
                for v60, v61 in v4 do
                    v61:Cancel()
                end
                table.clear(v4)
                v3 += 1
                local v62 = v3
                task.spawn(function() -- line 269 | captures: v62, v3, TweenService, Workspace, AdminAbuseConfig, Transition, NumberValue, v4, setAdminSky, setAdminVfx, getOverlay
                    local v63 = getOverlay()
                    v63.Visible = true
                    local v64 = TweenInfo.new(Transition.EffectInTime, Transition.EffectEasingStyle, Enum.EasingDirection.Out)
                    local v65 = { Value = 1 }
                    local v66 = TweenService:Create(NumberValue, v64, v65)
                    table.insert(v4, v66)
                    v66:Play()
                    local v67 = TweenInfo.new(Transition.FadeInTime, Transition.FadeInEasingStyle, Transition.FadeInEasingDirection)
                    local v68 = { BackgroundTransparency = 0 }
                    local v69 = TweenService:Create(v63, v67, v68)
                    table.insert(v4, v69)
                    v69:Play()
                    local v70
                    if (v69.PlaybackState == Enum.PlaybackState.Completed or v69.Completed:Wait() == Enum.PlaybackState.Completed) and v62 == v3 then
                        v70 = Workspace:GetAttribute(AdminAbuseConfig.StartedAtAttribute) ~= nil
                    else
                        return
                    end
                    setAdminSky(v70)
                    setAdminVfx(v70)
                    task.wait(Transition.HoldTime)
                    if v62 ~= v3 then
                        return
                    end
                    local v71 = TweenInfo.new(Transition.EffectOutTime, Transition.EffectEasingStyle, Enum.EasingDirection.InOut)
                    local v72 = { Value = 0 }
                    local v73 = TweenService:Create(NumberValue, v71, v72)
                    table.insert(v4, v73)
                    v73:Play()
                    local v74 = TweenInfo.new(Transition.FadeOutTime, Transition.FadeOutEasingStyle, Transition.FadeOutEasingDirection)
                    local v75 = { BackgroundTransparency = 1 }
                    local v76 = TweenService:Create(v63, v74, v75)
                    table.insert(v4, v76)
                    v76:Play()
                    local v77 = if v76.PlaybackState == Enum.PlaybackState.Completed then true else v76.Completed:Wait() == Enum.PlaybackState.Completed
                    if v77 and v62 == v3 then
                        v63.Visible = false
                    end
                end)
            else
                for v78, v79 in v4 do
                    v79:Cancel()
                end
                table.clear(v4)
                v3 += 1
                if v7 ~= nil then
                    v7:Destroy()
                    v7 = nil
                end
                for v80, v81 in v5 do
                    v81.Parent = Lighting
                end
                table.clear(v5)
                for v82, v83 in v6 do
                    v83.Enabled = true
                end
                table.clear(v6)
                if v8 ~= nil then
                    v8:Destroy()
                    v8 = nil
                end
                NumberValue.Value = 0
                if Frame ~= nil then
                    Frame.Visible = false
                    Frame.BackgroundTransparency = 1
                end
            end
        end
    end)
end

return v1
