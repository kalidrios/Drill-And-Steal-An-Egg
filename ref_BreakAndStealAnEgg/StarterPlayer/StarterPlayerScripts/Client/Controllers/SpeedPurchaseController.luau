-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local PotionConfig = require(ReplicatedStorage.Shared.PotionConfig)
local SpeedConfig = require(ReplicatedStorage.Shared.SpeedConfig)
local SpeedPurchaseConfig = require(ReplicatedStorage.Shared.SpeedPurchaseConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local RobuxPurchase = require(script.Parent.RobuxPurchase)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local SpeedPurchase, Amount, SpeedPurchasePulse, TextColor3, v2, v3
local v4 = 0
local v5
local v6 = {}

local function cancelSlide() -- line 94 | captures: v5
    if v5 then
        v5:Cancel()
        v5 = nil
    end
end

local function stopPulse() -- line 101 | captures: Amount, SpeedPurchasePulse, TextColor3, v6
    for v7, v8 in v6 do
        v8:Cancel()
    end
    table.clear(v6)
    if SpeedPurchasePulse then
        SpeedPurchasePulse.Scale = 1
    end
    if Amount and TextColor3 then
        Amount.TextColor3 = TextColor3
    end
end

local function startPulse() -- line 117 | captures: Amount, SpeedPurchasePulse, TextColor3, TweenService, SpeedPurchaseConfig, v6
    local Amount_2 = Amount
    local SpeedPurchasePulse_2 = SpeedPurchasePulse
    if not Amount_2 or not SpeedPurchasePulse_2 then
        return
    end
    for v9, v10 in v6 do
        v10:Cancel()
    end
    table.clear(v6)
    if SpeedPurchasePulse then
        SpeedPurchasePulse.Scale = 1
    end
    if Amount and TextColor3 then
        Amount.TextColor3 = TextColor3
    end
    local v11 = TweenInfo.new(SpeedPurchaseConfig.PulsePeriod, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, -1, true)
    local v12 = TweenService:Create(SpeedPurchasePulse_2, v11, { Scale = SpeedPurchaseConfig.PulseScale })
    local v13 = TweenService:Create(Amount_2, v11, { TextColor3 = SpeedPurchaseConfig.PulseColor })
    table.insert(v6, v12)
    table.insert(v6, v13)
    v12:Play()
    v13:Play()
end

local function hiddenPositionFrom(v14) -- line 142 | captures: SpeedPurchaseConfig
    return UDim2.new(v14.X.Scale, v14.X.Offset, SpeedPurchaseConfig.HiddenYScale, 0)
end

local function hide() -- line 148 | captures: SpeedPurchase, Amount, SpeedPurchasePulse, TextColor3, v2, v3, v4, v5, TweenService, SpeedPurchaseConfig, v6
    local SpeedPurchase_2 = SpeedPurchase
    local v15 = v2
    local v16
    if SpeedPurchase_2 and SpeedPurchase_2.Parent and v15 and SpeedPurchase_2.Visible then
        v4 += 1
        v16 = v4
        if v5 then
            v5:Cancel()
            v5 = nil
        end
    else
        return
    end
    local SlideOut = SpeedPurchaseConfig.SlideOut
    local v17 = TweenService:Create(SpeedPurchase_2, TweenInfo.new(SlideOut.Time, SlideOut.Style, SlideOut.Direction), { Position = UDim2.new(v15.X.Scale, v15.X.Offset, SpeedPurchaseConfig.HiddenYScale, 0) })
    v5 = v17
    local Completed = v17.Completed
    local v18 = v16
    Completed:Connect(function() -- line 166 | captures: SpeedPurchase_2, v15, v18, Amount, SpeedPurchasePulse, TextColor3, v3, v4, v6
        if v4 ~= v18 then
            return
        end
        v3 = nil
        for v19, v20 in v6 do
            v20:Cancel()
        end
        table.clear(v6)
        if SpeedPurchasePulse then
            SpeedPurchasePulse.Scale = 1
        end
        if Amount and TextColor3 then
            Amount.TextColor3 = TextColor3
        end
        SpeedPurchase_2.Visible = false
        SpeedPurchase_2.Position = v15
    end)
    v17:Play()
end

local function show(v21) -- line 181 | captures: SpeedPurchase, Amount, v2, v3, v4, v5, TweenService, FormatNumber, SpeedPurchaseConfig, startPulse, hide
    local SpeedPurchase_2 = SpeedPurchase
    local Amount_2 = Amount
    local v22
    if SpeedPurchase_2 and SpeedPurchase_2.Parent and Amount_2 then
        v4 += 1
        v22 = v4
        v3 = v21
        Amount_2.Text = ("+%* Speed"):format((FormatNumber.Short(v21.Amount)))
        v2 = v2 or SpeedPurchase_2.Position
    else
        return
    end
    local v23 = v2
    if v5 then
        v5:Cancel()
        v5 = nil
    end
    if not SpeedPurchase_2.Visible then
        SpeedPurchase_2.Position = UDim2.new(v23.X.Scale, v23.X.Offset, SpeedPurchaseConfig.HiddenYScale, 0)
        SpeedPurchase_2.Visible = true
        startPulse()
    end
    local SlideIn = SpeedPurchaseConfig.SlideIn
    local v24 = TweenService:Create(SpeedPurchase_2, TweenInfo.new(SlideIn.Time, SlideIn.Style, SlideIn.Direction), { Position = v23 })
    v5 = v24
    v24:Play()
    local delay = task.delay
    local ShowSeconds = SpeedPurchaseConfig.ShowSeconds
    local v25 = v22
    delay(ShowSeconds, function() -- line 215 | captures: v25, v4, hide
        if v4 == v25 then
            hide()
        end
    end)
end

local function onLocalPlayerCaught(v26) -- line 226 | captures: PotionConfig, SpeedConfig, SpeedPurchaseConfig, LocalPlayer, show
    if LocalPlayer:GetAttribute("TutorialActive") then
        return
    end
    local v27 = v26:GetAttribute(SpeedPurchaseConfig.CaughtRequiredPowerAttribute)
    local v28, v29
    if typeof(v27) == "number" then
        if v27 <= 0 then
            v29 = true
        else
            v28 = LocalPlayer:GetAttribute("SpeedPower") or SpeedConfig.DefaultSpeedPower
            v29 = false
        end
    else
        v29 = true
    end
    if v29 then
        return
    end
    local v30 = PotionConfig.SpeedStatFor(LocalPlayer, 1)
    if not (v27 <= v28 * v30) then
        show(SpeedPurchaseConfig.PackFor(v28, v27 / v30))
    end
end

local v31 = {}
local v32 = {}

local function trackGuard(v33) -- line 261 | captures: LocalPlayer, onLocalPlayerCaught, v31, v32
    if not v33:IsA("Model") or v31[v33] then
        return
    end
    v32[v33] = v33:GetAttribute("CatchPulse") or 0
    local CatchPulse = v33:GetAttributeChangedSignal("CatchPulse")
    v31[v33] = CatchPulse:Connect(function() -- line 270 | captures: v33, LocalPlayer, onLocalPlayerCaught, v32
        local v34 = v33:GetAttribute("CatchPulse") or 0
        if v34 ~= v32[v33] then
            v32[v33] = v34
            if v33:GetAttribute("CaughtUserId") == LocalPlayer.UserId then
                onLocalPlayerCaught(v33)
            end
        end
    end)
end

local function untrackGuard(v35) -- line 285 | captures: v31, v32
    if not v35:IsA("Model") then
        return
    end
    local v36 = v31[v35]
    if v36 then
        v36:Disconnect()
    end
    v31[v35] = nil
    v32[v35] = nil
end

local function bind(v37) -- line 301 | captures: SpeedPurchase, Amount, SpeedPurchasePulse, TextColor3, v2, v3, v4, v5, RobuxPurchase, v6, hide
    local SpeedPurchase_2 = v37:FindFirstChild("SpeedPurchase")
    if not (SpeedPurchase_2 and SpeedPurchase_2:IsA("GuiButton")) then
        warn("[SpeedPurchaseController] missing MainGUI.SpeedPurchase")
    else
        local Amount_2 = SpeedPurchase_2:FindFirstChild("Amount")
        if Amount_2 and Amount_2:IsA("TextLabel") then
            v4 += 1
            if v5 then
                v5:Cancel()
                v5 = nil
            end
            for v38, v39 in v6 do
                v39:Cancel()
            end
            table.clear(v6)
            v3 = nil
            v2 = nil
            SpeedPurchase = SpeedPurchase_2
            Amount = Amount_2
            TextColor3 = Amount_2.TextColor3
            local SpeedPurchasePulse_2 = Amount_2:FindFirstChild("SpeedPurchasePulse")
            if not (SpeedPurchasePulse_2 and SpeedPurchasePulse_2:IsA("UIScale")) then
                SpeedPurchasePulse_2 = Instance.new("UIScale")
                SpeedPurchasePulse_2.Name = "SpeedPurchasePulse"
                SpeedPurchasePulse_2.Parent = Amount_2
            end
            SpeedPurchasePulse = SpeedPurchasePulse_2
            SpeedPurchase_2.Visible = false
            SpeedPurchase_2.Activated:Connect(function() -- line 342 | captures: v3, RobuxPurchase, hide
                local v40 = v3
                if v40 then
                    RobuxPurchase.Prompt(v40.ProductId)
                    hide()
                end
            end)
        else
            warn("[SpeedPurchaseController] missing MainGUI.SpeedPurchase.Amount")
        end
    end
end

function v1.Start() -- line 351 | captures: CollectionService, MainGui, LocalPlayer, hide, trackGuard, untrackGuard, bind
    MainGui.Observe(bind)
    LocalPlayer:GetAttributeChangedSignal("Carrying"):Connect(function() -- line 359 | captures: LocalPlayer, hide
        if LocalPlayer:GetAttribute("Carrying") ~= nil then
            hide()
        end
    end)
    for v41, v42 in CollectionService:GetTagged("ZoneGuard") do
        trackGuard(v42)
    end
    CollectionService:GetInstanceAddedSignal("ZoneGuard"):Connect(trackGuard)
    CollectionService:GetInstanceRemovedSignal("ZoneGuard"):Connect(untrackGuard)
end

return v1
