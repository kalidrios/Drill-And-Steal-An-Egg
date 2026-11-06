-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ChaseState = require(ReplicatedStorage.Shared.ChaseState)
local ThanksPopupConfig = require(ReplicatedStorage.Shared.ThanksPopupConfig)
local TutorialConfig = require(ReplicatedStorage.Shared.TutorialConfig)
local ZonesConfig = require(ReplicatedStorage.Shared.ZonesConfig)
local ZoneHitboxLookup = require(ReplicatedStorage.Shared.ZoneHitboxLookup)
local ZoneDisplayInfo = require(ReplicatedStorage.Shared.ZoneDisplayInfo)
local RecommendedSpeedPopup = require(script.Parent.Parent.Modules.RecommendedSpeedPopup)
local LocalCharacter = require(script.Parent.Parent.Modules.LocalCharacter)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local MessagesLift = require(script.Parent.Parent.Modules.MessagesLift)
local PreloadController = require(script.Parent.PreloadController)
local UiFrames = require(script.Parent.UiFrames)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = UDim2.new(0.5, 0, -0.3, 0)
local v5 = UDim2.fromScale(0.5, 0.5)
local v6 = UDim2.fromScale(0.5, -0.4)
local v7
local v8 = 0
local v9, v10, v11, v12, v13

local function getMainGui() -- line 101 | captures: LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    return PlayerGui and PlayerGui:FindFirstChild("MainGUI")
end

local function isThanksPopupOpen() -- line 108 | captures: ThanksPopupConfig, UiFrames, LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v14 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v15 = v14 and v14:FindFirstChild("Frames")
    local v16 = v15 and v15:FindFirstChild(ThanksPopupConfig.FrameName)
    if v16 == nil then
        return false
    end
    return v16:IsA("GuiObject") and UiFrames.IsOpen(v16)
end

local function isSpeedPurchaseVisible() -- line 117 | captures: LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v17 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v18 = v17 and v17:FindFirstChild("SpeedPurchase")
    if v18 == nil then
        return false
    end
    return v18:IsA("GuiObject") and v18.Visible
end

local function getMessagesFrame() -- line 123 | captures: LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v19 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v20 = v19 and v19:FindFirstChild("Messages")
    if not (v20 and v20:IsA("Frame")) then
        return nil
    end
    return v20
end

local function ensureMessage() -- line 134 | captures: v11, v12, v13, MessagesLift, LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v21 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v22 = v21 and v21:FindFirstChild("Messages")
    if not (v22 and v22:IsA("Frame")) then
        v22 = nil
    end
    if v22 then
        if v22 ~= v11 then
            v11 = v22
            v12 = MessagesLift.Rest(v22)
            v13 = nil
        end
        if v13 and v13.Parent == v22 then
            return v13
        end
        local Message = v22:FindFirstChild("Message")
        if not (Message and Message:IsA("CanvasGroup")) then
            return nil
        end
        local v23 = Message:Clone()
        v23.Name = "ActiveMessage"
        v23.Visible = false
        v23.Parent = v22
        v13 = v23
        return v23
    end
    return nil
end

local function getZoneBossIcon(v24) -- line 168 | captures: ZonesConfig
    local v25 = ZonesConfig.Get(v24)
    local v26 = v25 and v25.Icon
    if v26 and v26 ~= "" then
        return v26
    end
    return nil
end

local function setMessageContent(v27, v28, v29) -- line 174 | captures: ZonesConfig
    local Texts = v27:FindFirstChild("Texts")
    local v30
    if Texts then
        v30 = Texts:FindFirstChild("Main")
        Texts = Texts:FindFirstChild("Icon")
    else
        v30 = Texts
    end
    if v30 and v30:IsA("TextLabel") then
        v30.Text = v29.Name
        local ZoneGradient = v30:FindFirstChild("ZoneGradient")
        if ZoneGradient then
            if not ZoneGradient:IsA("UIGradient") then
                ZoneGradient = Instance.new("UIGradient")
                ZoneGradient.Name = "ZoneGradient"
                ZoneGradient.Rotation = 90
                ZoneGradient.Parent = v30
            end
        else
            ZoneGradient = Instance.new("UIGradient")
            ZoneGradient.Name = "ZoneGradient"
            ZoneGradient.Rotation = 90
            ZoneGradient.Parent = v30
        end
        ZoneGradient.Color = v29.Gradient
    end
    if not (Texts and Texts:IsA("ImageLabel")) then
        return
    end
    local v31 = ZonesConfig.Get(v28)
    local v32 = v31 and v31.Icon
    if not v32 or v32 == "" then
        v32 = nil
    end
    Texts.Image = v32 or ""
    Texts.Visible = v32 ~= nil
end

local function cancelActiveTween() -- line 201 | captures: v9
    if v9 then
        v9:Cancel()
        v9 = nil
    end
end

local v33 = false
local v34, v35

local function restAt(v36) -- line 218 | captures: v12, MessagesLift
    local v37 = v12
    if v37 then
        return (MessagesLift.Lifted(v37, v36))
    end
    return nil
end

local function effectiveRest() -- line 223 | captures: v12, MessagesLift
    local v38 = MessagesLift.Get()
    local v39 = v12
    if v39 then
        return (MessagesLift.Lifted(v39, v38))
    end
    return nil
end

local function slideTo(v40, v41) -- line 229 | captures: v12, v33, v34, v35, TweenService, MessagesLift
    local v42 = MessagesLift.Target()
    local v43 = v12
    local v44
    if v43 then
        v44 = MessagesLift.Lifted(v43, v42)
    end
    if not v44 then
        return
    end
    if v35 then
        v35:Cancel()
        v35 = nil
    end
    local v45 = TweenService:Create(v40, v41, { Position = v44 })
    v34 = v45
    v33 = true
    v45.Completed:Once(function(v46) -- line 241 | captures: v45, v33, v34
        if v34 == v45 and v46 == Enum.PlaybackState.Completed then
            v33 = false
            v34 = nil
        end
    end)
    v45:Play()
end

local function showMessage(v47, v48) -- line 252 | captures: v8, v9, v11, v12, v33, TweenService, RecommendedSpeedPopup, MessagesLift, v2, v3, v4, v5, v6, ensureMessage, setMessageContent, slideTo
    local v49 = ensureMessage()
    local v50 = v11
    local v51
    if v49 and v50 and v12 then
        v8 += 1
        v51 = v8
        if v9 then
            v9:Cancel()
            v9 = nil
        end
    else
        return
    end
    setMessageContent(v49, v47, v48)
    v33 = true
    v49.Position = v5
    v49.GroupTransparency = 0
    v50.Position = v4
    v49.Visible = true
    RecommendedSpeedPopup.Show(v50, v47)
    MessagesLift.Refresh()
    slideTo(v50, v2)
    local delay = task.delay
    local v52 = v51
    delay(2, function() -- line 279 | captures: v49, v52, v8, v9, TweenService, RecommendedSpeedPopup, MessagesLift, v3, v5, v6
        if v8 == v52 and v49.Parent then
            if v9 then
                v9:Cancel()
                v9 = nil
            end
        else
            return
        end
        local v53 = TweenService:Create(v49, v3, {
            GroupTransparency = 1,
            Position = v6
        })
        v9 = v53
        v53:Play()
        RecommendedSpeedPopup.Hide(v3)
        task.delay(v3.Time, function() -- line 294 | captures: v49, v52, v8, RecommendedSpeedPopup, MessagesLift, v5
            if v8 ~= v52 then
                return
            end
            if v49.Parent then
                v49.Visible = false
                v49.Position = v5
                v49.GroupTransparency = 0
            end
            RecommendedSpeedPopup.HideNow()
            MessagesLift.Refresh()
        end)
    end)
end

local function hideMessageNow() -- line 314 | captures: v8, v9, v11, v12, v13, v33, v34, RecommendedSpeedPopup, MessagesLift, v5
    v8 += 1
    if v9 then
        v9:Cancel()
        v9 = nil
    end
    local v54 = v13
    if v54 and v54.Parent then
        v54.Visible = false
        v54.Position = v5
        v54.GroupTransparency = 0
    end
    RecommendedSpeedPopup.HideNow()
    v33 = false
    if v34 then
        v34:Cancel()
        v34 = nil
    end
    MessagesLift.Refresh()
    local v55 = MessagesLift.Target()
    local v56 = v12
    local v57
    if v56 then
        v57 = MessagesLift.Lifted(v56, v55)
    end
    if v11 and v57 then
        v11.Position = v57
    end
end

local function onZoneEntered(v58) -- line 337 | captures: v10, ChaseState, TutorialConfig, ZonesConfig, ZoneDisplayInfo, LocalPlayer, isThanksPopupOpen, showMessage
    if not ChaseState.IsActive(LocalPlayer) and not LocalPlayer:GetAttribute(TutorialConfig.ActiveAttribute) then
        if isThanksPopupOpen() then
            v10 = v58
        else
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
            local v59 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
            local v60 = v59 and v59:FindFirstChild("SpeedPurchase")
            if v60 ~= nil and v60:IsA("GuiObject") and v60.Visible then
                v10 = v58
            else
                v10 = nil
                if v58 ~= ZonesConfig.SafeZoneName then
                    local v61 = ZoneDisplayInfo[v58]
                    if v61 then
                        showMessage(v58, v61)
                    elseif ZonesConfig.Get(v58) then
                        showMessage(v58, {
                            Name = v58:gsub("Zone", "Zone "),
                            Gradient = ColorSequence.new(Color3.new(1, 1, 1))
                        })
                    end
                end
            end
        end
    end
end

v1.ZoneInfo = ZoneDisplayInfo

function v1.Start() -- line 391 | captures: v7, v10, v11, v12, v13, v33, v35, RunService, TweenService, ChaseState, ThanksPopupConfig, ZonesConfig, ZoneHitboxLookup, LocalCharacter, MainGui, MessagesLift, PreloadController, UiFrames, LocalPlayer, v2, isThanksPopupOpen, slideTo, hideMessageNow, onZoneEntered
    MainGui.Observe(function(v62) -- line 394 | captures: v11, v12, v13, v33, MessagesLift
        local Messages = v62:FindFirstChild("Messages")
        local v63, v64
        if Messages and Messages:IsA("Frame") then
            if Messages == v11 then
                v64 = true
            else
                v11 = Messages
                v12 = MessagesLift.Rest(Messages)
                v13 = nil
                v33 = false
                MessagesLift.Watch(Messages)
                local v65 = MessagesLift.Get()
                local v66 = v12
                if v66 then
                    v63 = MessagesLift.Lifted(v66, v65)
                end
                v64 = false
            end
        else
            v64 = true
        end
        if not v64 and v63 then
            Messages.Position = v63
        end
    end)
    MessagesLift.TargetChanged:Connect(function() -- line 411 | captures: v11, v12, v33, v35, TweenService, MessagesLift, v2, slideTo
        local v67 = v11
        if v67 and v67.Parent then
            if v33 then
                slideTo(v67, v2)
            else
                local v68 = MessagesLift.Target()
                local v69 = v12
                local v70
                if v69 then
                    v70 = MessagesLift.Lifted(v69, v68)
                end
                if v70 then
                    if v35 then
                        v35:Cancel()
                    end
                    v35 = TweenService:Create(v67, MessagesLift.TweenInfo, { Position = v70 })
                    v35:Play()
                end
            end
        end
    end)
    ChaseState.Observe(LocalPlayer, function(v71) -- line 433 | captures: hideMessageNow
        if v71 then
            hideMessageNow()
        end
    end)
    UiFrames.ObserveAny(function(v72, v73) -- line 444 | captures: v7, v10, v13, ThanksPopupConfig, isThanksPopupOpen, hideMessageNow, onZoneEntered
        if v72.Name == ThanksPopupConfig.FrameName then
            if v73 then
                local v74 = v13
                if v74 and v74.Parent and v74.Visible then
                    v10 = v7
                    hideMessageNow()
                end
            else
                task.delay(ThanksPopupConfig.ReopenDelay, function() -- line 458 | captures: v7, v10, isThanksPopupOpen, onZoneEntered
                    if isThanksPopupOpen() then
                        return
                    end
                    local v75 = v10
                    v10 = nil
                    if v75 and v75 == v7 then
                        onZoneEntered(v75)
                    end
                end)
            end
        end
    end)
    MainGui.Observe(function(v76) -- line 474 | captures: v7, v10, v13, hideMessageNow, onZoneEntered
        local SpeedPurchase = v76:FindFirstChild("SpeedPurchase")
        if SpeedPurchase and SpeedPurchase:IsA("GuiObject") then
            SpeedPurchase:GetPropertyChangedSignal("Visible"):Connect(function() -- line 480 | captures: SpeedPurchase, v7, v10, v13, hideMessageNow, onZoneEntered
                if SpeedPurchase.Visible then
                    local v77 = v13
                    if v77 and v77.Parent and v77.Visible then
                        v10 = v7
                        hideMessageNow()
                    end
                else
                    local v78 = v10
                    v10 = nil
                    if v78 and v78 == v7 then
                        onZoneEntered(v78)
                    end
                end
            end)
        end
    end)
    RunService.Heartbeat:Connect(function() -- line 503 | captures: v7, ZonesConfig, ZoneHitboxLookup, LocalCharacter, PreloadController, onZoneEntered
        local v79 = LocalCharacter.GetPosition()
        if v79 then
            local v80 = ZoneHitboxLookup.GetZoneAt(v79)
            if v80 ~= v7 then
                v7 = v80
                if v80 then
                    PreloadController.WarmZone(ZonesConfig.IndexOf(v80))
                    onZoneEntered(v80)
                end
            end
        else
            v7 = nil
        end
    end)
end

return v1
