-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CountingNumber = require(ReplicatedStorage.Shared.CountingNumber)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local PotionConfig = require(ReplicatedStorage.Shared.PotionConfig)
local SpeedBoostConfig = require(ReplicatedStorage.Shared.SpeedBoostConfig)
local SpeedConfig = require(ReplicatedStorage.Shared.SpeedConfig)
local StrokeColors = require(ReplicatedStorage.Shared.StrokeColors)
local TrailsConfig = require(ReplicatedStorage.Shared.TrailsConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local TextBoundsWatch = require(script.Parent.Parent.Modules.TextBoundsWatch)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2 = Random.new()
local v3 = TweenInfo.new(0.37, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.28)
local v6 = TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v7 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local PublicTreadmillConfig = require(ReplicatedStorage.Shared.PublicTreadmillConfig)

local function onPublicTreadmill() -- line 77 | captures: LocalPlayer, PublicTreadmillConfig
    return LocalPlayer:GetAttribute(PublicTreadmillConfig.SlotAttribute) ~= nil
end

local v8, v9, v10, v11, TotalMultiplier, v12

local function positionTag() -- line 105 | captures: v9, v10, TotalMultiplier
    local v13 = v10
    local TotalMultiplier_2 = TotalMultiplier
    local v14 = v9
    local v15
    if v13 and TotalMultiplier_2 and v14 and TotalMultiplier_2.Parent == v14 then
        local UIScale = v14:FindFirstChildOfClass("UIScale")
        if UIScale and UIScale.Scale > 0 then
            v15 = UIScale.Scale
        else
            v15 = 1
        end
    else
        return
    end
    local v16 = (v13.AbsolutePosition.X - v14.AbsolutePosition.X) / v15
    local v17 = v13.TextBounds.X / v15
    local v18 = v13.TextBounds.Y / v15
    local v19 = v13.AbsoluteSize.X / v15
    local TextXAlignment = v13.TextXAlignment
    local v20
    if TextXAlignment == Enum.TextXAlignment.Left then
        v20 = v16 + v17
    elseif TextXAlignment == Enum.TextXAlignment.Center then
        v20 = v16 + (v19 + v17) / 2
    else
        v20 = v16 + v19
    end
    local v21 = v18 * 0.3
    local v22 = math.max(6, v21)
    TotalMultiplier_2.AnchorPoint = Vector2.new(0, v13.AnchorPoint.Y)
    local new = UDim2.new
    local v23 = v20 + v22 + 0.5
    TotalMultiplier_2.Position = new(0, math.floor(v23), v13.Position.Y.Scale, v13.Position.Y.Offset)
end

local function resolveTagLabel(v24, v25) -- line 137 | captures: TotalMultiplier, v12, SpeedBoostConfig, TextBoundsWatch, positionTag
    local function v26(...)
        assert(...)
    end

    if v12 then
        v12()
        v12 = nil
    end
    local TotalMultiplier_2 = v24:FindFirstChild("TotalMultiplier")
    if not (TotalMultiplier_2 and TotalMultiplier_2:IsA("TextLabel")) then
        TotalMultiplier_2 = v25:Clone()
        v26(TotalMultiplier_2:IsA("TextLabel"))
        TotalMultiplier_2.Name = "TotalMultiplier"
        for v27, v28 in TotalMultiplier_2:GetChildren() do
            if v28:IsA("UIGradient") then
                v28:Destroy()
            end
        end
        TotalMultiplier_2.RichText = false
        TotalMultiplier_2.Text = ""
        TotalMultiplier_2.TextXAlignment = Enum.TextXAlignment.Left
        TotalMultiplier_2.TextColor3 = Color3.fromHex(SpeedBoostConfig.HudTag.Color)
        TotalMultiplier_2.Parent = v24
    end
    TotalMultiplier = TotalMultiplier_2
    v12 = TextBoundsWatch.Watch(v25, positionTag)
end

local Sound = Instance.new("Sound")

Sound.Name = "TreadmillPopupPop"
Sound.SoundId = "rbxassetid://72264591133889"
Sound.Volume = 0.4

local function playPopSound() -- line 189 | captures: Debris, SoundService, v2, Sound
    local v29 = Sound:Clone()
    v29.PlaybackSpeed = v2:NextNumber(0.9, 1.1)
    v29.Parent = SoundService
    v29.Ended:Once(function() -- line 193 | captures: v29
        v29:Destroy()
    end)
    local TimeLength = v29.TimeLength
    Debris:AddItem(v29, math.max(TimeLength, 1) + 1)
    v29:Play()
end

local v30
local v31 = 0

local function resolveUI(v32) -- line 218 | captures: v8, v9, v10, v11, MainGui, resolveTagLabel
    local v33 = v32 or MainGui.Wait()
    local v34 = v33:WaitForChild("Currencies", 10)
    local v35 = v34 and v34:WaitForChild("Speed", 10)
    if v35 and v35:IsA("Frame") then
        v8 = v33
        v9 = v35
        v10 = v35:FindFirstChild("Amount")
        if v10 then
            resolveTagLabel(v35, v10)
        end
        local CurrencyGain = v33:FindFirstChild("CurrencyGain")
        if not (CurrencyGain and CurrencyGain:IsA("Frame")) then
            CurrencyGain = nil
        end
        v11 = CurrencyGain
        if v11 then
            v11.Visible = false
        end
        return v10 ~= nil
    end
    warn("[SpeedGainController] Currencies.Speed frame missing")
    return false
end

local function ensureUI() -- line 246 | captures: v9, LocalPlayer, resolveUI
    if not (v9 ~= nil and v9:IsDescendantOf(LocalPlayer)) then
        return (resolveUI())
    end
    return true
end

local function boostTag() -- line 260 | captures: FormatNumber, SpeedBoostConfig, TrailsConfig, LocalPlayer
    local v36 = SpeedBoostConfig.ClampMultiplier(LocalPlayer:GetAttribute(SpeedBoostConfig.AttributeName))
    local v37 = TrailsConfig.MultiplierFor(TrailsConfig.ClampEquipped(LocalPlayer:GetAttribute(TrailsConfig.EquippedAttribute))) * v36
    local HudTag = SpeedBoostConfig.HudTag
    if not (v37 <= 1) or HudTag.ShowWhenUnboosted then
        return (("(x%*)"):format((FormatNumber.Short(v37))))
    end
    return ""
end

local v38 = 0

local function paintAmount() -- line 273 | captures: v10, TotalMultiplier, v38, FormatNumber, PotionConfig, LocalPlayer, boostTag
    if v10 then
        local v39 = v10
        local Short = FormatNumber.Short
        local v40 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
        v39.Text = Short((math.floor(v40)))
    end
    if TotalMultiplier then
        TotalMultiplier.Text = boostTag()
    end
end

local v41 = CountingNumber.new(function(v42) -- line 285 | captures: v10, TotalMultiplier, v38, FormatNumber, PotionConfig, LocalPlayer, boostTag
    v38 = v42
    if v10 then
        local v43 = v10
        local Short = FormatNumber.Short
        local v44 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
        v43.Text = Short((math.floor(v44)))
    end
    if TotalMultiplier then
        TotalMultiplier.Text = boostTag()
    end
end)

local function setAmount(v45) -- line 290 | captures: v41
    v41:Set(v45)
end

local UIScale, v46

local function getPulseScale() -- line 305 | captures: v9, UIScale
    if v9 then
        if UIScale and UIScale.Parent == v9 then
            return UIScale
        end
        local UIScale_2 = v9:FindFirstChildOfClass("UIScale")
        if UIScale_2 then
            UIScale = UIScale_2
            return UIScale_2
        end
        local UIScale_3 = Instance.new("UIScale")
        UIScale_3.Parent = v9
        UIScale = UIScale_3
        return UIScale_3
    end
    return nil
end

local v47

local function pulseAmount(v48) -- line 325 | captures: v9, UIScale, v46, v47, TweenService, v6, v7
    local UIScale_2
    if v9 then
        if not (UIScale and UIScale.Parent == v9) then
            UIScale_2 = v9:FindFirstChildOfClass("UIScale")
            if not UIScale_2 then
                UIScale_2 = Instance.new("UIScale")
                UIScale_2.Parent = v9
            end
            UIScale = UIScale_2
        else
            UIScale_2 = UIScale
        end
    end
    if not UIScale_2 then
        return
    end
    local v49
    if not (v48 and v48 >= 25) then
        if not (v48 and v48 >= 9) then
            v49 = 1
        else
            v49 = 1.07
        end
    else
        v49 = 1.15
    end
    local v50 = v49 * 0.3500000000000001 + 1
    local v51 = math.min(v50, 1.5)
    if v51 <= UIScale_2.Scale then
        if not v46 then
            local v52 = TweenService:Create(UIScale_2, v7, { Scale = 1 })
            v46 = v52
            v52.Completed:Once(function() -- line 344 | captures: v52, v46
                if v46 == v52 then
                    v46 = nil
                end
            end)
            v52:Play()
        end
    else
        if v47 then
            v47:Cancel()
            v47 = nil
        end
        if v46 then
            v46:Cancel()
            v46 = nil
        end
        local v53 = TweenService:Create(UIScale_2, v6, { Scale = v51 })
        v47 = v53
        local Completed = v53.Completed
        local UIScale = UIScale_2
        Completed:Once(function(v54) -- line 366 | captures: v53, UIScale, v46, v47, TweenService, v7
            if not (v54 == Enum.PlaybackState.Completed and v47 == v53) then
                return
            end
            v47 = nil
            local v55 = TweenService:Create(UIScale, v7, { Scale = 1 })
            v46 = v55
            v55.Completed:Once(function() -- line 373 | captures: v55, v46
                if v46 == v55 then
                    v46 = nil
                end
            end)
            v55:Play()
        end)
        v53:Play()
    end
end

local v56

local function getBillboardHolder() -- line 391 | captures: v56, LocalPlayer
    local v57 = v56
    if v57 == nil or v57.Parent == nil then
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local SpeedGainHolder = PlayerGui:FindFirstChild("SpeedGainHolder")
        if not (SpeedGainHolder ~= nil and SpeedGainHolder:IsA("ScreenGui")) then
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "SpeedGainHolder"
            ScreenGui.ResetOnSpawn = false
            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ScreenGui.Parent = PlayerGui
            v56 = ScreenGui
            return ScreenGui
        end
        v56 = SpeedGainHolder
        return SpeedGainHolder
    end
    return v57
end

local function stripButtons(v58) -- line 413
    for v59, v60 in v58:GetDescendants() do
        if v60:IsA("GuiButton") then
            v60:Destroy()
        end
    end
end

local function showHeadPopup(v61) -- line 421 | captures: v9, TweenService, FormatNumber, SpeedConfig, StrokeColors, LocalPlayer, v2, v3, v4, v5, getBillboardHolder, stripButtons
    local function v62(v63, v64, ...)
        return (Vector3.new(v63, v64, ...))
    end

    local Character = LocalPlayer.Character
    local v65 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not v65 then
        return
    end
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "PlusSpeed"
    BillboardGui.Size = UDim2.fromScale(4.5, 1.5)
    BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Adornee = v65
    BillboardGui.Parent = getBillboardHolder()
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromScale(0, 0)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundTransparency = 1
    Frame.Parent = BillboardGui
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0.05, 0)
    UIListLayout.Parent = Frame
    local v66 = v9 and v9:FindFirstChild("Icon")
    local v67
    if not (v66 and v66:IsA("ImageLabel")) then
        v67 = Instance.new("ImageLabel")
        v67.Image = SpeedConfig.PopupIcon
    else
        v67 = v66:Clone()
        stripButtons(v67)
        v67.Visible = true
    end
    v67.Size = UDim2.fromScale(0.3, 0.8)
    v67.BackgroundTransparency = 1
    if not v67:FindFirstChildOfClass("UIAspectRatioConstraint") then
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
        UIAspectRatioConstraint.AspectRatio = 1
        UIAspectRatioConstraint.Parent = v67
    end
    v67.Parent = Frame
    local v68 = v9 and v9:FindFirstChild("Amount")
    local v69
    if not (v68 and v68:IsA("TextLabel")) then
        v69 = Instance.new("TextLabel")
        v69.Font = Enum.Font.GothamBlack
        v69.TextColor3 = SpeedConfig.PopupColor(v61)
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = StrokeColors.Neutral
        UIStroke.Thickness = 2
        UIStroke.Parent = v69
    else
        v69 = v68:Clone()
        v69.Visible = true
    end
    local Short = FormatNumber.Short
    local v70 = v61 + 0.5
    v69.Text = ("+%*"):format((Short((math.floor(v70)))))
    v69.Size = UDim2.fromScale(0.6, 0.9)
    v69.Position = UDim2.fromScale(0, 0)
    v69.AnchorPoint = Vector2.new(0, 0)
    v69.BackgroundTransparency = 1
    v69.TextScaled = true
    v69.Parent = Frame
    local v71 = v62(v2:NextInteger(-3, 3), v2:NextInteger(3, 6), v2:NextInteger(-2, 2))
    local v72 = v71.X * 2
    local v73 = math.clamp(v72, -8, 8)
    if v73 == 0 then
        v73 = v2:NextInteger(-4, 4)
    end
    TweenService:Create(Frame, v3, { Size = UDim2.fromScale(1, 1) }):Play()
    TweenService:Create(BillboardGui, v4, { StudsOffset = v71 }):Play()
    TweenService:Create(Frame, v4, { Rotation = v73 }):Play()
    task.delay(0.55, function() -- line 511 | captures: BillboardGui, Frame, v71, TweenService, v5
        for v74, v75 in Frame:GetDescendants() do
            if v75:IsA("TextLabel") then
                TweenService:Create(v75, v5, { TextTransparency = 1 }):Play()
            elseif v75:IsA("ImageLabel") then
                TweenService:Create(v75, v5, { ImageTransparency = 1 }):Play()
            elseif v75:IsA("UIStroke") then
                TweenService:Create(v75, v5, { Transparency = 1 }):Play()
            end
        end
        TweenService:Create(BillboardGui, v5, { StudsOffset = v71 + Vector3.new(0, -1.2000000476837158, 0) }):Play()
        task.delay(0.33, function() -- line 523 | captures: BillboardGui
            BillboardGui:Destroy()
        end)
    end)
end

local function collectFadeTargets(v76) -- line 538
    local v77 = {}
    for v78, v79 in v76:GetDescendants() do
        if v79:IsA("TextLabel") then
            local v80 = {
                Property = "TextTransparency",
                Instance = v79
            }
            table.insert(v77, v80)
        elseif v79:IsA("ImageLabel") then
            local v81 = {
                Property = "ImageTransparency",
                Instance = v79
            }
            table.insert(v77, v81)
        elseif v79:IsA("UIStroke") then
            local v82 = {
                Property = "Transparency",
                Instance = v79
            }
            table.insert(v77, v82)
        end
    end
    return v77
end

local function setPopupTransparency(v83, v84) -- line 552
    for v85, v86 in v83 do
        v86.Instance[v86.Property] = v84
    end
end

local function quadBezier(v87, v88, v89, v90) -- line 558
    local v91 = 1 - v90
    return v87 * (v91 * v91) + v88 * (v91 * 2 * v90) + v89 * (v90 * v90)
end

local function buildGainTemplate(v92) -- line 570 | captures: v9, stripButtons
    local v93 = v9
    local Frame, v94, v95, v96
    if v93 then
        v94 = v93:FindFirstChild("Icon")
        v95 = v93:FindFirstChild("Amount")
        if v94 and v94:IsA("ImageLabel") and v95 and v95:IsA("TextLabel") then
            Frame = Instance.new("Frame")
            Frame.Name = "CurrencyGain"
            Frame.BackgroundTransparency = 1
            Frame.Visible = false
            local AbsoluteSize = v93.AbsoluteSize
            if AbsoluteSize.X > 1 and AbsoluteSize.Y > 1 then
                local fromOffset = UDim2.fromOffset
                local v97 = AbsoluteSize.X * 1.6
                local v98 = math.ceil(v97)
                local Y = AbsoluteSize.Y
                Frame.Size = fromOffset(v98, (math.ceil(Y)))
            else
                Frame.Size = UDim2.fromOffset(150, 42)
            end
            v96 = false
        else
            v96 = true
        end
    else
        v94 = v93
        v95 = v93
        v96 = true
    end
    if v96 then
        return nil
    end
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0.05, 0)
    UIListLayout.Parent = Frame
    local v99 = v94:Clone()
    stripButtons(v99)
    v99.Visible = true
    v99.Size = UDim2.fromScale(0.25, 0.85)
    v99.BackgroundTransparency = 1
    v99.LayoutOrder = 1
    if not v99:FindFirstChildOfClass("UIAspectRatioConstraint") then
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
        UIAspectRatioConstraint.AspectRatio = 1
        UIAspectRatioConstraint.Parent = v99
    end
    v99.Parent = Frame
    local v100 = v95:Clone()
    v100.Visible = true
    v100.Size = UDim2.fromScale(0.7, 0.95)
    v100.Position = UDim2.fromScale(0, 0)
    v100.AnchorPoint = Vector2.new(0, 0)
    v100.BackgroundTransparency = 1
    v100.TextScaled = true
    v100.LayoutOrder = 2
    v100.Parent = Frame
    Frame.Parent = v92
    return Frame
end

local function showFlyingPopup(v101, v102) -- line 626 | captures: v8, v9, v10, v11, RunService, UserInputService, Workspace, FormatNumber, v2, pulseAmount, collectFadeTargets, buildGainTemplate
    local v103 = v8
    local v104 = v10
    local CurrentCamera = Workspace.CurrentCamera
    local v105 = v11
    local v106
    if v103 and (v105 == nil or v105.Parent == nil) then
        v106 = buildGainTemplate(v103)
        v11 = v106
    else
        v106 = v105
    end
    local v107
    if v103 and v106 and v104 and CurrentCamera then
        v107 = v106:Clone()
        v107.Name = "SpeedGainPopup"
        v107.Visible = true
        v107.AnchorPoint = Vector2.new(0.5, 0.5)
        local Amount = v107:FindFirstChild("Amount")
        if Amount and Amount:IsA("TextLabel") then
            local Short = FormatNumber.Short
            local v108 = v101 + 0.5
            Amount.Text = ("+%* Speed"):format((Short((math.floor(v108)))))
            if not Amount:FindFirstChildOfClass("UIGradient") and v10 then
                local UIGradient = v10:FindFirstChildOfClass("UIGradient")
                if UIGradient then
                    UIGradient:Clone().Parent = Amount
                end
            end
        end
    else
        return false
    end
    local Icon = v107:FindFirstChild("Icon")
    local v109 = v9 and v9:FindFirstChild("Icon")
    if Icon and Icon:IsA("ImageLabel") and v109 and v109:IsA("ImageLabel") then
        Icon.Image = v109.Image
    end
    local UIScale = v107:FindFirstChildOfClass("UIScale")
    local UIScale_2 = UIScale
    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale_2 = UIScale
        UIScale.Parent = v107
    end
    UIScale.Scale = 0.72
    local ViewportSize = CurrentCamera.ViewportSize
    local v110 = Vector2.new(ViewportSize.X * 0.25, ViewportSize.Y)
    local v111 = v104.AbsolutePosition + v104.AbsoluteSize * 0.5
    local X = v111.X
    local v112 = if v110.X <= X then -1 else 1
    local v113 = if UserInputService.TouchEnabled then 0.4 else 1
    local v114 = (v110 + v111) * 0.5 + Vector2.new(v112 * v2:NextNumber(v113 * 90, v113 * 120), -v2:NextNumber(v113 * 100, v113 * 150))
    v107.Position = UDim2.fromOffset(v110.X, v110.Y)
    v107.Parent = v103
    local v115 = collectFadeTargets(v107)
    for v116, v117 in v115 do
        v117.Instance[v117.Property] = 0
    end
    local spawn = task.spawn
    local v118 = v107
    spawn(function() -- line 687 | captures: UIScale_2, v101, v102, v110, v111, v114, v115, v118, RunService, pulseAmount
        local v119 = os.clock()
        local v120 = 0
        local v121 = -1
        while v120 < 1 do
            if v118.Parent == nil then
                break
            end
            local v122 = (os.clock() - v119) / 0.85
            v120 = math.min(v122, 1)
            local v123 = 1 - v120
            local v124 = v110 * (v123 * v123) + v114 * (v123 * 2 * v120) + v111 * (v120 * v120)
            v118.Position = UDim2.fromOffset(v124.X, v124.Y)
            local UIScale = UIScale_2
            local v125 = v120 * 3.141592653589793
            UIScale.Scale = math.sin(v125) * 0.18 + 0.72
            local v126 = (v120 - 0.72) / 0.28
            local v127 = math.clamp(v126, 0, 1)
            if v127 ~= v121 then
                v121 = v127
                for v128, v129 in v115 do
                    v129.Instance[v129.Property] = v127
                    v121 = v127
                end
            end
            RunService.RenderStepped:Wait()
        end
        if v118.Parent == nil then
            return
        end
        if v102 then
            v102()
        end
        pulseAmount(v101)
        v118:Destroy()
    end)
    return true
end

local function readAuthoritativePower() -- line 720 | captures: SpeedConfig, LocalPlayer
    local SpeedPower = LocalPlayer:GetAttribute("SpeedPower")
    if typeof(SpeedPower) == "number" then
        return SpeedPower
    end
    return SpeedConfig.DefaultSpeedPower
end

local function stopSession() -- line 730 | captures: v9, v10, TotalMultiplier, v30, v31, v38, FormatNumber, PotionConfig, SpeedConfig, LocalPlayer, resolveUI, boostTag, v41
    if not v30 then
        return
    end
    v30 = nil
    v31 += 1
    if not (v9 ~= nil and v9:IsDescendantOf(LocalPlayer) or resolveUI()) then
        return
    end
    if v10 then
        local v130 = v10
        local Short = FormatNumber.Short
        local v131 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
        v130.Text = Short((math.floor(v131)))
    end
    if TotalMultiplier then
        TotalMultiplier.Text = boostTag()
    end
    local SpeedPower = LocalPlayer:GetAttribute("SpeedPower")
    if typeof(SpeedPower) ~= "number" then
        SpeedPower = SpeedConfig.DefaultSpeedPower
    end
    v41:Set(SpeedPower)
end

local function isFullyZoomedIn() -- line 748 | captures: Workspace, LocalPlayer
    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v132 = Character and Character:FindFirstChild("Head")
    if CurrentCamera and v132 and v132:IsA("BasePart") then
        return (CurrentCamera.CFrame.Position - v132.Position).Magnitude <= 5
    end
    return false
end

local function startSessionSimulation(v133) -- line 758 | captures: v9, v10, TotalMultiplier, v30, v31, v38, Workspace, FormatNumber, PotionConfig, SpeedConfig, LocalPlayer, PublicTreadmillConfig, playPopSound, resolveUI, boostTag, v41, pulseAmount, showHeadPopup, showFlyingPopup
    if v30 then
        v30 = nil
        v31 += 1
        local v134
        if v9 == nil then
            v134 = resolveUI()
        elseif v9:IsDescendantOf(LocalPlayer) then
            v134 = true
        else
            v134 = resolveUI()
        end
        if v134 then
            if v10 then
                local v135 = v10
                local Short = FormatNumber.Short
                local v136 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
                v135.Text = Short((math.floor(v136)))
            end
            if TotalMultiplier then
                TotalMultiplier.Text = boostTag()
            end
            local SpeedPower = LocalPlayer:GetAttribute("SpeedPower")
            if typeof(SpeedPower) ~= "number" then
                SpeedPower = SpeedConfig.DefaultSpeedPower
            end
            v41:Set(SpeedPower)
        end
    end
    v31 += 1
    local v137 = v31
    local v138 = {
        UnequipSent = false,
        PendingScreen = 0,
        NextHeadAt = 0,
        Multiplier = v133
    }
    local SpeedPower = LocalPlayer:GetAttribute("SpeedPower")
    if typeof(SpeedPower) ~= "number" then
        SpeedPower = SpeedConfig.DefaultSpeedPower
    end
    v138.Power = SpeedPower
    v138.Token = v137
    v138.NextScreenAt = os.clock() + SpeedConfig.GainInterval
    v30 = v138
    if v10 then
        local v139 = v10
        local Short = FormatNumber.Short
        local v140 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
        v139.Text = Short((math.floor(v140)))
    end
    if TotalMultiplier then
        TotalMultiplier.Text = boostTag()
    end
    task.spawn(function() -- line 784 | captures: v137, v138, v9, v30, Workspace, SpeedConfig, LocalPlayer, PublicTreadmillConfig, playPopSound, resolveUI, v41, pulseAmount, showHeadPopup, showFlyingPopup
        while true do
            local v141, v142, v143, v144
            if v30 == v138 and v138.Token == v137 then
                v141 = SpeedConfig.AwardInterval(SpeedConfig.SpeedPowerToProgression(v138.Power))
                task.wait(v141)
                if v30 == v138 and v138.Token == v137 then
                    v142 = SpeedConfig.SpeedPowerPerStepFor(v138.Multiplier)
                    v138.Power += v142
                    if v9 == nil then
                        v143 = resolveUI()
                    elseif v9:IsDescendantOf(LocalPlayer) then
                        v143 = true
                    else
                        v143 = resolveUI()
                    end
                    v144 = false
                else
                    v144 = true
                end
            else
                v144 = true
            end
            if v144 then
                break
            end
            if v143 then
                local CurrentCamera = Workspace.CurrentCamera
                local Character = LocalPlayer.Character
                local v145 = Character and Character:FindFirstChild("Head")
                if CurrentCamera and v145 and v145:IsA("BasePart") and (CurrentCamera.CFrame.Position - v145.Position).Magnitude <= 5 then
                    v138.PendingScreen += v142
                    local v146 = os.clock()
                    if v138.NextScreenAt <= v146 then
                        if v138.PendingScreen > 0 then
                            local PendingScreen = v138.PendingScreen
                            v138.PendingScreen = 0
                            playPopSound()
                            if not showFlyingPopup(PendingScreen, function() -- line 805 | captures: v138, v30, v41
                                    if v30 == v138 then
                                        local Power = v138.Power
                                        v41:Set(Power)
                                    end
                                end) then
                                local Power = v138.Power
                                v41:Set(Power)
                            end
                        end
                        v138.NextScreenAt = v146 + SpeedConfig.GainInterval
                    end
                else
                    v138.PendingScreen = 0
                    v138.NextScreenAt = os.clock() + SpeedConfig.GainInterval
                    local Power = v138.Power
                    v41:Set(Power)
                    local v147 = os.clock()
                    if LocalPlayer:GetAttribute(PublicTreadmillConfig.SlotAttribute) ~= nil then
                        if v138.NextHeadAt <= v147 then
                            v138.NextHeadAt = v147 + 0.2
                            playPopSound()
                            pulseAmount(v142)
                        end
                        local PopupsPerStep = PublicTreadmillConfig.PopupsPerStep
                        local v148 = math.max(PopupsPerStep, 1)
                        local v149 = v148 - 1
                        for v150 = 0, v149 do
                            local delay = task.delay
                            local v151 = v141 * v150 / v148
                            local v152 = v142
                            delay(v151, function() -- line 842 | captures: v152, v138, v30, showHeadPopup
                                if v30 == v138 then
                                    showHeadPopup(v152)
                                end
                            end)
                        end
                    elseif v138.NextHeadAt <= v147 then
                        v138.NextHeadAt = v147 + 0.2
                        playPopSound()
                        pulseAmount(v142)
                        showHeadPopup(v142)
                    end
                end
            end
        end
    end)
end

function v1.Start() -- line 863 | captures: v9, v10, TotalMultiplier, v30, v31, v38, ContentProvider, ReplicatedStorage, UserInputService, Workspace, FormatNumber, PotionConfig, SpeedBoostConfig, SpeedConfig, TrailsConfig, MainGui, LocalPlayer, Sound, resolveUI, boostTag, v41, showFlyingPopup, startSessionSimulation
    task.spawn(function() -- line 866 | captures: ContentProvider, Sound
        pcall(ContentProvider.PreloadAsync, ContentProvider, { Sound })
    end)
    if not resolveUI() then
        return
    end
    local SpeedPower = LocalPlayer:GetAttribute("SpeedPower")
    if typeof(SpeedPower) ~= "number" then
        SpeedPower = SpeedConfig.DefaultSpeedPower
    end
    v41:Snap(SpeedPower)
    MainGui.Observe(function(v153) -- line 881 | captures: v9, v10, TotalMultiplier, v38, FormatNumber, PotionConfig, LocalPlayer, resolveUI, boostTag
        local v154
        if v9 and v9:IsDescendantOf(v153) then
            v154 = true
        elseif resolveUI(v153) then
            if v10 then
                local v155 = v10
                local Short = FormatNumber.Short
                local v156 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
                v155.Text = Short((math.floor(v156)))
            end
            v154 = false
        else
            v154 = true
        end
        if not v154 and TotalMultiplier then
            TotalMultiplier.Text = boostTag()
        end
    end)
    LocalPlayer:GetAttributeChangedSignal("SpeedPower"):Connect(function() -- line 886 | captures: v9, v30, SpeedConfig, LocalPlayer, resolveUI, v41
        if v30 == nil then
            local v157
            if v9 == nil then
                v157 = resolveUI()
            elseif v9:IsDescendantOf(LocalPlayer) then
                v157 = true
            else
                v157 = resolveUI()
            end
            if v157 then
                local SpeedPower = LocalPlayer:GetAttribute("SpeedPower")
                if typeof(SpeedPower) ~= "number" then
                    SpeedPower = SpeedConfig.DefaultSpeedPower
                end
                v41:Set(SpeedPower)
            end
        end
    end)
    LocalPlayer:GetAttributeChangedSignal(SpeedBoostConfig.AttributeName):Connect(function() -- line 892 | captures: v9, v10, TotalMultiplier, v38, FormatNumber, PotionConfig, LocalPlayer, resolveUI, boostTag
        if v9 ~= nil and v9:IsDescendantOf(LocalPlayer) or resolveUI() then
            if v10 then
                local v158 = v10
                local Short = FormatNumber.Short
                local v159 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
                v158.Text = Short((math.floor(v159)))
            end
            if TotalMultiplier then
                TotalMultiplier.Text = boostTag()
            end
        end
    end)
    LocalPlayer:GetAttributeChangedSignal(PotionConfig.EndsAtAttribute("WalkSpeed")):Connect(function() -- line 899 | captures: v9, v10, TotalMultiplier, v38, FormatNumber, PotionConfig, LocalPlayer, resolveUI, boostTag
        if v9 ~= nil and v9:IsDescendantOf(LocalPlayer) or resolveUI() then
            if v10 then
                local v160 = v10
                local Short = FormatNumber.Short
                local v161 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
                v160.Text = Short((math.floor(v161)))
            end
            if TotalMultiplier then
                TotalMultiplier.Text = boostTag()
            end
        end
    end)
    for v162, v163 in {
            PotionConfig.GlobalMultiplierAttribute("WalkSpeed"),
            PotionConfig.GlobalEndsAtAttribute("WalkSpeed")
        } do
        Workspace:GetAttributeChangedSignal(v163):Connect(function() -- line 905 | captures: v9, v10, TotalMultiplier, v38, FormatNumber, PotionConfig, LocalPlayer, resolveUI, boostTag
            if v9 ~= nil and v9:IsDescendantOf(LocalPlayer) or resolveUI() then
                if v10 then
                    local v164 = v10
                    local Short = FormatNumber.Short
                    local v165 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
                    v164.Text = Short((math.floor(v165)))
                end
                if TotalMultiplier then
                    TotalMultiplier.Text = boostTag()
                end
            end
        end)
    end
    LocalPlayer:GetAttributeChangedSignal(TrailsConfig.EquippedAttribute):Connect(function() -- line 912 | captures: v9, v10, TotalMultiplier, v38, FormatNumber, PotionConfig, LocalPlayer, resolveUI, boostTag
        if v9 ~= nil and v9:IsDescendantOf(LocalPlayer) or resolveUI() then
            if v10 then
                local v166 = v10
                local Short = FormatNumber.Short
                local v167 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
                v166.Text = Short((math.floor(v167)))
            end
            if TotalMultiplier then
                TotalMultiplier.Text = boostTag()
            end
        end
    end)
    local v168 = ReplicatedStorage:WaitForChild("TreadmillSessionRemote", 30)
    local v169 = ReplicatedStorage:WaitForChild("SpeedGainRemote", 30)
    if v168 and v168:IsA("RemoteEvent") and v169 and v169:IsA("RemoteEvent") then
        v168.OnClientEvent:Connect(function(v170) -- line 925 | captures: v9, v10, TotalMultiplier, v30, v31, v38, FormatNumber, PotionConfig, SpeedConfig, LocalPlayer, resolveUI, boostTag, v41, startSessionSimulation
            if typeof(v170) == "number" then
                local v171
                if v9 == nil then
                    v171 = resolveUI()
                elseif v9:IsDescendantOf(LocalPlayer) then
                    v171 = true
                else
                    v171 = resolveUI()
                end
                if v171 then
                    startSessionSimulation(v170)
                end
            else
                local v172
                if v30 then
                    v30 = nil
                    v31 += 1
                    if v9 == nil then
                        v172 = resolveUI()
                    elseif v9:IsDescendantOf(LocalPlayer) then
                        v172 = true
                    else
                        v172 = resolveUI()
                    end
                else
                    return
                end
                if v172 then
                    if v10 then
                        local v173 = v10
                        local Short = FormatNumber.Short
                        local v174 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
                        v173.Text = Short((math.floor(v174)))
                    end
                    if TotalMultiplier then
                        TotalMultiplier.Text = boostTag()
                    end
                    local SpeedPower = LocalPlayer:GetAttribute("SpeedPower")
                    if typeof(SpeedPower) ~= "number" then
                        SpeedPower = SpeedConfig.DefaultSpeedPower
                    end
                    v41:Set(SpeedPower)
                end
            end
        end)
        v169.OnClientEvent:Connect(function(v175, v176) -- line 935 | captures: v9, v30, LocalPlayer, resolveUI, v41, showFlyingPopup
            local v177, v178
            if typeof(v175) == "number" then
                if v175 <= 0 then
                    v178 = true
                else
                    if v9 == nil then
                        v177 = resolveUI()
                    elseif v9:IsDescendantOf(LocalPlayer) then
                        v177 = true
                    else
                        v177 = resolveUI()
                    end
                    v178 = false
                end
            else
                v178 = true
            end
            if v178 or not v177 then
                return
            end
            local v179 = v30
            if v179 then
                if typeof(v176) == "number" and v179.Power < v176 then
                    v179.Power = v176
                    v41:Set(v176)
                end
            else
                if typeof(v176) == "number" then
                    v41:Set(v176)
                end
                showFlyingPopup(v175)
            end
        end)
        UserInputService.JumpRequest:Connect(function() -- line 956 | captures: v168, v30
            local v180 = v30
            if v180 and not v180.UnequipSent then
                v180.UnequipSent = true
                v168:FireServer()
            end
        end)
        LocalPlayer.CharacterAdded:Connect(function() -- line 965 | captures: v9, v10, TotalMultiplier, v30, v31, v38, FormatNumber, PotionConfig, SpeedConfig, LocalPlayer, resolveUI, boostTag, v41
            if not v30 then
                return
            end
            v30 = nil
            v31 += 1
            if not (v9 ~= nil and v9:IsDescendantOf(LocalPlayer) or resolveUI()) then
                return
            end
            if v10 then
                local v181 = v10
                local Short = FormatNumber.Short
                local v182 = PotionConfig.SpeedStatFor(LocalPlayer, v38)
                v181.Text = Short((math.floor(v182)))
            end
            if TotalMultiplier then
                TotalMultiplier.Text = boostTag()
            end
            local SpeedPower = LocalPlayer:GetAttribute("SpeedPower")
            if typeof(SpeedPower) ~= "number" then
                SpeedPower = SpeedConfig.DefaultSpeedPower
            end
            v41:Set(SpeedPower)
        end)
    else
        warn("[SpeedGainController] treadmill remotes missing")
    end
end

return v1
