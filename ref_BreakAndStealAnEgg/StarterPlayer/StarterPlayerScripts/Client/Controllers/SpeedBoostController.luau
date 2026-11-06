-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpeedBoostConfig = require(ReplicatedStorage.Shared.SpeedBoostConfig)
local RobuxPurchase = require(script.Parent.RobuxPurchase)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = { "LeftHUD", "SpeedDevproduct" }
local v3

local function currentMultiplier() -- line 41 | captures: SpeedBoostConfig, LocalPlayer
    return SpeedBoostConfig.ClampMultiplier(LocalPlayer:GetAttribute(SpeedBoostConfig.AttributeName))
end

local function findLabel(v4, v5) -- line 45
    local v6 = v4:FindFirstChild(v5)
    if not (v6 and v6:IsA("TextLabel")) then
        return nil
    end
    return v6
end

local function refresh() -- line 53 | captures: v3, SpeedBoostConfig, RobuxPurchase, currentMultiplier
    local v7 = v3
    local Title
    if v7 and v7.Parent then
        Title = v7:FindFirstChild("Title")
        if Title then
            if not Title:IsA("TextLabel") then
                Title = nil
            end
        else
            Title = nil
        end
    else
        return
    end
    local Price = v7:FindFirstChild("Price")
    if not (Price and Price:IsA("TextLabel")) then
        Price = nil
    end
    local v8 = SpeedBoostConfig.NextTier(currentMultiplier())
    if v8 then
        if Title then
            Title.Text = ("x%* Speed"):format(v8.Multiplier)
        end
        if Price then
            Price.RichText = false
            Price.Text = "ONLY "
            RobuxPurchase.StampPrice(Price, v8.DevProductId, "ONLY ")
        end
    else
        local v9 = SpeedBoostConfig.Tiers[#SpeedBoostConfig.Tiers]
        if Title then
            Title.Text = ("x%* Speed"):format(v9.Multiplier)
        end
        if Price then
            RobuxPurchase.Unbind(Price)
            Price.RichText = false
            Price.Text = "MAXED"
        end
    end
end

local function bind(v10) -- line 92 | captures: v3, SpeedBoostConfig, RobuxPurchase, v2, currentMultiplier, refresh
    local v11 = v10
    for v12, v13 in v2 do
        v11 = v11 and v11:FindFirstChild(v13)
    end
    if not (v11 and v11:IsA("GuiButton")) then
        warn((("[SpeedBoostController] missing MainGUI.%*"):format((table.concat(v2, ".")))))
    else
        v3 = v11
        v11.Activated:Connect(function() -- line 104 | captures: SpeedBoostConfig, RobuxPurchase, currentMultiplier
            local v14 = SpeedBoostConfig.NextTier(currentMultiplier())
            if v14 then
                RobuxPurchase.Prompt(v14.DevProductId)
            end
        end)
        refresh()
    end
end

function v1.Start() -- line 114 | captures: v3, SpeedBoostConfig, LocalPlayer, refresh, bind
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    LocalPlayer:GetAttributeChangedSignal(SpeedBoostConfig.AttributeName):Connect(refresh)
    PlayerGui.ChildAdded:Connect(function(v15) -- line 119 | captures: bind
        if v15.Name == "MainGUI" and v15:IsA("ScreenGui") then
            bind(v15)
        end
    end)
    local v16 = PlayerGui:WaitForChild("MainGUI", 30)
    if v16 and v3 == nil then
        bind(v16)
    end
end

return v1
