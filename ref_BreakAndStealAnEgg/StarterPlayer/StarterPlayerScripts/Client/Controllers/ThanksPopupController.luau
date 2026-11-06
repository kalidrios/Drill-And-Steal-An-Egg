-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local function trace(v1) -- line 47 | captures: RunService
    if RunService:IsStudio() then
        print((("[ThanksPopupController] %*"):format(v1)))
    end
end

local PurchaseGrantedConfig = require(ReplicatedStorage.Shared.PurchaseGrantedConfig)
local ThanksPopupConfig = require(ReplicatedStorage.Shared.ThanksPopupConfig)
local UiFramesConfig = require(ReplicatedStorage.Shared.UiFramesConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local ProductPrompt = require(script.Parent.Parent.Modules.ProductPrompt)
local ConfettiController = require(script.Parent.ConfettiController)
local NotificationController = require(script.Parent.NotificationController)
local PurchaseOverlay = require(script.Parent.PurchaseOverlay)
local UiFrames = require(script.Parent.UiFrames)
local v2 = {}
local LocalPlayer = Players.LocalPlayer
local v3
local v4 = 0
local Frame, v5
local v6 = TweenInfo.new(UiFramesConfig.TweenDuration, UiFramesConfig.TweenEasingStyle, UiFramesConfig.TweenEasingDirection)
local v7 = TweenInfo.new(UiFramesConfig.CloseTweenDuration, UiFramesConfig.CloseTweenEasingStyle, UiFramesConfig.CloseTweenEasingDirection)

local function ensureBackdrop(v8) -- line 92 | captures: Frame, ThanksPopupConfig
    if Frame and Frame.Parent then
        return Frame
    end
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "ThanksBackdrop"
    Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame_2.Position = UDim2.fromScale(0.5, 0.5)
    Frame_2.Size = UDim2.fromScale(1, 1)
    Frame_2.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame_2.BackgroundTransparency = 1
    Frame_2.BorderSizePixel = 0
    Frame_2.ZIndex = ThanksPopupConfig.BackdropZIndex
    Frame_2.Visible = false
    Frame_2.Active = false
    Frame_2.Parent = v8.Parent
    Frame = Frame_2
    return Frame_2
end

local function setBackdropVisible(v9, v10) -- line 114 | captures: v5, TweenService, ThanksPopupConfig, v6, v7, ensureBackdrop
    local v11 = ensureBackdrop(v9)
    if v5 then
        v5:Cancel()
        v5 = nil
    end
    if v10 then
        v11.Visible = true
        local v12 = TweenService:Create(v11, v6, { BackgroundTransparency = ThanksPopupConfig.BackdropTransparency })
        v5 = v12
        v12:Play()
    else
        local v13 = TweenService:Create(v11, v7, { BackgroundTransparency = 1 })
        v5 = v13
        v13.Completed:Once(function(v14) -- line 133 | captures: v11
            if v14 == Enum.PlaybackState.Completed then
                v11.Visible = false
            end
        end)
        v13:Play()
    end
end

local v15 = {}
local v16 = {}

local function playPurchaseSound() -- line 155 | captures: Debris, SoundService, ThanksPopupConfig
    local v17 = SoundService:FindFirstChild(ThanksPopupConfig.PurchaseSoundFolder)
    local v18 = v17 and v17:FindFirstChild(ThanksPopupConfig.PurchaseSoundName)
    if v18 and v18:IsA("Sound") then
        local v19 = v18:Clone()
        v19.Volume = ThanksPopupConfig.PurchaseSoundVolume
        v19.Parent = SoundService
        v19.Ended:Once(function() -- line 166 | captures: v19
            v19:Destroy()
        end)
        local TimeLength = v19.TimeLength
        Debris:AddItem(v19, math.max(TimeLength, 1) + 1)
        v19:Play()
    else
        warn((("[ThanksPopupController] purchase sound %* not found"):format(ThanksPopupConfig.PurchaseSoundName)))
    end
end

function v2.Show() -- line 175 | captures: v3, v4, ThanksPopupConfig, UiFrames
    local v20 = v3
    if v20 and v20.Parent then
        if UiFrames.IsOpen(v20) then
            UiFrames.Close(v20, true)
            v4 += 1
            local v21 = v4
            task.delay(ThanksPopupConfig.ReopenDelay, function() -- line 189 | captures: v20, v21, v4, UiFrames
                if v4 == v21 and v20.Parent then
                    UiFrames.OpenOver(v20)
                end
            end)
        else
            v4 += 1
            UiFrames.OpenOver(v20)
        end
    end
end

function v2.Hide() -- line 200 | captures: v3, v4, UiFrames
    v4 += 1
    if v3 then
        UiFrames.Close(v3)
    end
end

local function celebrateProduct() -- line 207 | captures: ConfettiController, PurchaseOverlay, v2, playPurchaseSound
    playPurchaseSound()
    PurchaseOverlay.Hide()
    v2.Show()
    ConfettiController.Burst()
end

local function record(v22, v23) -- line 215
    local function v24(v25, ...)
        table.insert(v25, ...)
    end

    local v26 = v22[v23]
    if not v26 then
        v26 = {}
        v22[v23] = v26
    end
    v24(v26, os.clock())
end

local function consume(v27, v28) -- line 225
    local v29 = v27[v28]
    if v29 then
        local v30 = os.clock()
        local v31 = #v29
        for v32 = v31, 1, -1 do
            if v30 - v29[v32] > 10 then
                table.remove(v29, v32)
            end
        end
        local v33
        if #v29 > 0 then
            table.remove(v29, 1)
            v33 = true
        else
            v33 = false
        end
        if #v29 == 0 then
            v27[v28] = nil
        end
        return v33
    end
    return false
end

function v2.Start() -- line 249 | captures: v3, v4, Frame, MarketplaceService, ReplicatedStorage, RunService, PurchaseGrantedConfig, ThanksPopupConfig, MainGui, ProductPrompt, ConfettiController, NotificationController, PurchaseOverlay, UiFrames, v2, LocalPlayer, setBackdropVisible, v15, v16, playPurchaseSound, consume
    task.spawn(function() -- line 253 | captures: ReplicatedStorage, RunService, PurchaseGrantedConfig, ConfettiController, PurchaseOverlay, v2, v15, v16, playPurchaseSound, consume
        local v34 = ReplicatedStorage:WaitForChild(PurchaseGrantedConfig.RemoteName, 30)
        if not (v34 and v34:IsA("RemoteEvent")) then
            warn("[ThanksPopupController] purchase granted remote missing \226\128\148 products celebrate when the dialog closes")
        else
            v34.OnClientEvent:Connect(function(v35) -- line 259 | captures: RunService, ConfettiController, PurchaseOverlay, v2, v15, v16, playPurchaseSound, consume
                local function v36(v37, ...)
                    table.insert(v37, ...)
                end

                if typeof(v35) == "number" then
                    if consume(v16, v35) then
                        local v38 = ("server grant for %* arrived after the dialog closed (already celebrated)"):format(v35)
                        if RunService:IsStudio() then
                            print((("[ThanksPopupController] %*"):format(v38)))
                        end
                    else
                        local v39 = ("celebrating %* instantly from the server grant"):format(v35)
                        if RunService:IsStudio() then
                            print((("[ThanksPopupController] %*"):format(v39)))
                        end
                        local v40 = v15[v35]
                        if not v40 then
                            v40 = {}
                            v15[v35] = v40
                        end
                        v36(v40, os.clock())
                        playPurchaseSound()
                        PurchaseOverlay.Hide()
                        v2.Show()
                        ConfettiController.Burst()
                    end
                end
            end)
        end
    end)
    ProductPrompt.Finished:Connect(function(v41, v42, v43) -- line 275 | captures: RunService, ConfettiController, PurchaseOverlay, v2, LocalPlayer, v15, v16, playPurchaseSound, consume
        local function v44(v45, ...)
            table.insert(v45, ...)
        end

        if not v43 or not (v41 == LocalPlayer.UserId) or consume(v15, v42) then
            return
        end
        local v46 = ("celebrating %* from the dialog closing (no server grant yet)"):format(v42)
        if RunService:IsStudio() then
            print((("[ThanksPopupController] %*"):format(v46)))
        end
        local v47 = v16[v42]
        if not v47 then
            v47 = {}
            v16[v42] = v47
        end
        v44(v47, os.clock())
        playPurchaseSound()
        PurchaseOverlay.Hide()
        v2.Show()
        ConfettiController.Burst()
    end)
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(v48, v49, v50) -- line 287 | captures: v2, LocalPlayer, playPurchaseSound
        if v50 and v48 == LocalPlayer then
            playPurchaseSound()
            v2.Show()
        end
    end)
    MainGui.Observe(function(v51) -- line 296 | captures: v3, v4, Frame, ThanksPopupConfig, NotificationController, UiFrames, v2, setBackdropVisible
        v4 += 1
        v3 = nil
        Frame = nil
        NotificationController.Release("ThanksPopup")
        local Frames = v51:FindFirstChild("Frames")
        local v52 = Frames and Frames:FindFirstChild(ThanksPopupConfig.FrameName)
        if v52 and v52:IsA("GuiObject") then
            v52.Visible = false
            v52.ZIndex = ThanksPopupConfig.ZIndex
            v3 = v52
            UiFrames.Observe(v52, function(v53) -- line 324 | captures: v52, v4, ThanksPopupConfig, NotificationController, UiFrames, setBackdropVisible
                setBackdropVisible(v52, v53)
                if v53 then
                    NotificationController.Hold("ThanksPopup")
                else
                    local v54 = v4
                    task.delay(ThanksPopupConfig.ReopenDelay, function() -- line 331 | captures: v54, v52, v4, NotificationController, UiFrames
                        if v4 == v54 and not UiFrames.IsOpen(v52) then
                            NotificationController.Release("ThanksPopup")
                        end
                    end)
                end
            end)
            local v55 = v52:FindFirstChild(ThanksPopupConfig.OkButtonName)
            if v55 and v55:IsA("GuiButton") then
                v55.Activated:Connect(v2.Hide)
            end
        else
            warn("[ThanksPopupController] MainGUI.Frames." .. ThanksPopupConfig.FrameName .. " not found")
        end
    end)
end

return v2
