-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local PurchaseOverlayConfig = require(ReplicatedStorage.Shared.PurchaseOverlayConfig)
local NotificationController = require(script.Parent.NotificationController)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local ProductPrompt = require(script.Parent.Parent.Modules.ProductPrompt)
local v1 = {}
local v2 = TweenInfo.new(PurchaseOverlayConfig.FadeInDuration, PurchaseOverlayConfig.FadeEasingStyle, PurchaseOverlayConfig.FadeEasingDirection)
local v3 = TweenInfo.new(PurchaseOverlayConfig.FadeOutDuration, PurchaseOverlayConfig.FadeEasingStyle, PurchaseOverlayConfig.FadeEasingDirection)
local v4 = { "PromptGamePassPurchaseFinished", "PromptPurchaseFinished", "PromptBundlePurchaseFinished", "PromptPremiumPurchaseFinished", "PromptSubscriptionPurchaseFinished" }
local LocalPlayer = Players.LocalPlayer
local v5 = {}
local v6 = { __mode = "k" }
local v7 = setmetatable(v5, v6)
local v8 = false
local v9 = 0
local v10, v11, v12

local function resolve() -- line 105 | captures: PurchaseOverlayConfig, LocalPlayer, v7
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v13 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v14 = v13 and v13:FindFirstChild("Frames")
    local v15 = v14 and v14:FindFirstChild(PurchaseOverlayConfig.FrameName)
    local v16
    if v15 and v15:IsA("Frame") then
        v16 = v15:FindFirstChild(PurchaseOverlayConfig.SpinnerName)
        if v16 then
            if not v16:IsA("ImageLabel") then
                v16 = nil
            end
        else
            v16 = nil
        end
    else
        return nil, nil
    end
    if not v7[v15] then
        local v17 = { dim = v15.BackgroundTransparency }
        v17.spinner = v16 and v16.ImageTransparency or nil
        v7[v15] = v17
    end
    return v15, v16
end

local function cancelTweens() -- line 127 | captures: v11, v12
    if v11 then
        v11:Cancel()
        v11 = nil
    end
    if v12 then
        v12:Cancel()
        v12 = nil
    end
end

local function stopSpin() -- line 138 | captures: v10
    if v10 then
        v10:Disconnect()
        v10 = nil
    end
end

local function startSpin(v18) -- line 145 | captures: v10, RunService, PurchaseOverlayConfig
    if v10 then
        v10:Disconnect()
        v10 = nil
    end
    v18.Rotation = 0
    v10 = RunService.RenderStepped:Connect(function(v19) -- line 148 | captures: v18, v10, PurchaseOverlayConfig
        if v18.Parent then
            v18.Rotation = (v18.Rotation + PurchaseOverlayConfig.SpinDegreesPerSecond * v19) % 360
        elseif v10 then
            v10:Disconnect()
            v10 = nil
        end
    end)
end

function v1.Show() -- line 162 | captures: v8, v9, v10, v11, v12, RunService, TweenService, PurchaseOverlayConfig, NotificationController, v1, v2, v7, resolve
    local v20, v21 = resolve()
    if not v20 then
        return
    end
    if v11 then
        v11:Cancel()
        v11 = nil
    end
    if v12 then
        v12:Cancel()
        v12 = nil
    end
    v9 += 1
    local v22 = v9
    v8 = true
    NotificationController.Hold("PurchasePrompt")
    local v23 = v7[v20]
    v20.BackgroundTransparency = 1
    v20.Active = true
    v20.Visible = true
    local v24 = TweenService:Create(v20, v2, { BackgroundTransparency = v23.dim })
    v11 = v24
    v24:Play()
    if v21 then
        if v23.spinner then
            v21.ImageTransparency = 1
            local v25 = TweenService:Create(v21, v2, { ImageTransparency = v23.spinner })
            v12 = v25
            v25:Play()
        end
        if v10 then
            v10:Disconnect()
            v10 = nil
        end
        v21.Rotation = 0
        v10 = RunService.RenderStepped:Connect(function(v26) -- line 148 | captures: v21, v10, PurchaseOverlayConfig
            if v21.Parent then
                v21.Rotation = (v21.Rotation + PurchaseOverlayConfig.SpinDegreesPerSecond * v26) % 360
            elseif v10 then
                v10:Disconnect()
                v10 = nil
            end
        end)
    end
    task.delay(PurchaseOverlayConfig.InputBlockSeconds, function() -- line 195 | captures: v20, v22, v8, v9
        if v9 == v22 and v8 and v20.Parent then
            v20.Active = false
        end
    end)
    task.delay(PurchaseOverlayConfig.MaxVisibleSeconds, function() -- line 202 | captures: v22, v8, v9, PurchaseOverlayConfig, v1
        if v9 == v22 and v8 then
            warn("[PurchaseOverlay] no purchase prompt finished in " .. PurchaseOverlayConfig.MaxVisibleSeconds .. "s \226\128\148 dropping the overlay. Roblox's prompt most likely never " .. "opened (check the console for CoreScript/CorePackages errors).")
            v1.Hide()
        end
    end)
end

function v1.Hide() -- line 216 | captures: v8, v9, v10, v11, v12, TweenService, NotificationController, v3, v7, resolve
    if not v8 then
        return
    end
    v8 = false
    v9 += 1
    task.defer(function() -- line 225 | captures: v8, NotificationController
        if not v8 then
            NotificationController.Release("PurchasePrompt")
        end
    end)
    local v27, v28 = resolve()
    if v11 then
        v11:Cancel()
        v11 = nil
    end
    if v12 then
        v12:Cancel()
        v12 = nil
    end
    if v10 then
        v10:Disconnect()
        v10 = nil
    end
    if not v27 then
        return
    end
    v27.Active = false
    local v29 = v9
    local v30 = TweenService:Create(v27, v3, { BackgroundTransparency = 1 })
    v11 = v30
    v30:Play()
    v30.Completed:Once(function() -- line 244 | captures: v27, v29, v9
        if v9 == v29 then
            v27.Visible = false
        end
    end)
    local v31 = v7[v27]
    if v28 and v31 and v31.spinner then
        local v32 = TweenService:Create(v28, v3, { ImageTransparency = 1 })
        v12 = v32
        v32:Play()
    end
end

function v1.IsVisible() -- line 259 | captures: v8
    return v8
end

local function playPromptSound() -- line 269 | captures: Debris, SoundService, PurchaseOverlayConfig
    local v33 = SoundService:FindFirstChild(PurchaseOverlayConfig.PromptSoundFolder)
    local v34 = v33 and v33:FindFirstChild(PurchaseOverlayConfig.PromptSoundName)
    local v35
    if v34 and v34:IsA("Sound") then
        v35 = v34:Clone()
        if PurchaseOverlayConfig.PromptSoundVolume then
            v35.Volume = PurchaseOverlayConfig.PromptSoundVolume
        end
    else
        return
    end
    v35.Parent = SoundService
    local Ended = v35.Ended
    local v36 = v35
    Ended:Once(function() -- line 281 | captures: v36
        v36:Destroy()
    end)
    local TimeLength = v35.TimeLength
    Debris:AddItem(v35, math.max(TimeLength, 1) + 1)
    v35:Play()
end

local function promptWithOverlay(v37, v38, v39) -- line 292 | captures: v1, playPromptSound
    if typeof(v38) == "number" then
        v1.Show()
        local v40, v41 = pcall(v39)
        if v40 then
            playPromptSound()
        else
            v1.Hide()
            warn((("[PurchaseOverlay] couldn't prompt %* %*: %*"):format(v37, v38, v41)))
        end
        return v40
    end
    return false
end

function v1.PromptProduct(v42) -- line 308 | captures: ProductPrompt, promptWithOverlay
    return (promptWithOverlay("product", v42, function() -- line 309 | captures: v42, ProductPrompt
        ProductPrompt.Prompt(v42)
    end))
end

function v1.PromptGamePass(v43) -- line 315 | captures: MarketplaceService, LocalPlayer, promptWithOverlay
    return (promptWithOverlay("gamepass", v43, function() -- line 316 | captures: v43, MarketplaceService, LocalPlayer
        MarketplaceService:PromptGamePassPurchase(LocalPlayer, v43)
    end))
end

function v1.Start() -- line 321 | captures: MarketplaceService, MainGui, ProductPrompt, v1, v4, resolve
    MainGui.Observe(function() -- line 326 | captures: resolve
        local v44, v45 = resolve()
        if not v44 then
            return
        end
        v44.Visible = false
        v44.Active = false
        if v45 then
            v45.Rotation = 0
        end
    end)
    ProductPrompt.Finished:Connect(function() -- line 337 | captures: v1
        v1.Hide()
    end)
    for v46, v47 in v4 do
        local v48 = v47
        local v49, v50 = pcall(function() -- line 341 | captures: v48, MarketplaceService
            return MarketplaceService[v48]
        end)
        if v49 and typeof(v50) == "RBXScriptSignal" then
            v50:Connect(function() -- line 345 | captures: v1
                v1.Hide()
            end)
        end
    end
end

return v1
