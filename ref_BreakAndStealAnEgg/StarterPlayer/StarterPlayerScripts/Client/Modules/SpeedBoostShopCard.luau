-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RobuxShopConfig = require(ReplicatedStorage.Shared.RobuxShopConfig)
local SpeedBoostConfig = require(ReplicatedStorage.Shared.SpeedBoostConfig)
local ProductPrompt = require(script.Parent.ProductPrompt)
local GiftPlayerController = require(script.Parent.Parent.Controllers.GiftPlayerController)
local RobuxPurchase = require(script.Parent.Parent.Controllers.RobuxPurchase)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local ShopCard = SpeedBoostConfig.ShopCard
local v2
local v3 = false

local function findLabel(v4, v5) -- line 50
    local v6 = v4 and v4:FindFirstChild(v5)
    if v6 and v6:IsA("TextLabel") then
        return v6
    end
    return nil
end

local function refresh() -- line 55 | captures: v2, SpeedBoostConfig, RobuxPurchase, LocalPlayer, ShopCard
    local v7 = v2
    local v8
    if v7 and v7.Price.Parent then
        local v9 = SpeedBoostConfig.MultiplierOf(LocalPlayer)
        v8 = SpeedBoostConfig.NextTier(v9)
        if v7.Before then
            v7.Before.Text = SpeedBoostConfig.Text(v9)
        end
    else
        return
    end
    if v7.After then
        local After = v7.After
        if v8 then
            After.Text = SpeedBoostConfig.Text(v8.Multiplier)
        else
            After.Text = ShopCard.MaxText
        end
    end
    local Price = v7.Price
    if v8 then
        if not v7.Pending then
            if RobuxPurchase.GetPrice(v8.DevProductId) == nil then
                Price.Text = v7.AuthoredText
            end
            RobuxPurchase.StampPrice(Price, v8.DevProductId)
        end
    else
        v7.Pending = false
        RobuxPurchase.Unbind(Price)
        Price.RichText = false
        Price.Text = ShopCard.MaxedPriceText
    end
end

local function giftTierFor(v10) -- line 91 | captures: SpeedBoostConfig
    local v11 = SpeedBoostConfig.NextTier(SpeedBoostConfig.MultiplierOf(v10))
    if v11 then
        return v11.DevProductId, nil
    end
    return nil, SpeedBoostConfig.MaxedGiftText(v10.DisplayName)
end

local function connectOnce() -- line 99 | captures: v2, v3, SpeedBoostConfig, ProductPrompt, LocalPlayer, refresh
    if v3 then
        return
    end
    v3 = true
    LocalPlayer:GetAttributeChangedSignal(SpeedBoostConfig.AttributeName):Connect(refresh)
    ProductPrompt.Finished:Connect(function(v12, v13) -- line 108 | captures: v2, SpeedBoostConfig, LocalPlayer, refresh
        local v14 = v2
        if not (v12 == LocalPlayer.UserId and v14 and SpeedBoostConfig.TierForProduct(v13)) then
            return
        end
        v14.Pending = false
        refresh()
    end)
end

function v1.Bind(v15) -- line 120 | captures: v2, v3, RobuxShopConfig, SpeedBoostConfig, ProductPrompt, GiftPlayerController, RobuxPurchase, LocalPlayer, ShopCard, refresh, giftTierFor
    if not v3 then
        v3 = true
        LocalPlayer:GetAttributeChangedSignal(SpeedBoostConfig.AttributeName):Connect(refresh)
        ProductPrompt.Finished:Connect(function(v16, v17) -- line 108 | captures: v2, SpeedBoostConfig, LocalPlayer, refresh
            local v18 = v2
            if not (v16 == LocalPlayer.UserId and v18 and SpeedBoostConfig.TierForProduct(v17)) then
                return
            end
            v18.Pending = false
            refresh()
        end)
    end
    local v19 = v15:FindFirstChild(ShopCard.CardName, true)
    local v20 = v19 and v19:FindFirstChild("Inner")
    local v21
    if v20 then
        v21 = v20:FindFirstChild("Amount")
        v20 = v20:FindFirstChild("ButtonList")
    else
        v21 = v20
    end
    local v22
    if v20 then
        v22 = v20:FindFirstChild("Purchase")
        v20 = v20:FindFirstChild("Gift")
    else
        v22 = v20
    end
    local v23 = v22 and v22:FindFirstChild("Price")
    if not (v23 and v23:IsA("TextLabel")) then
        v23 = nil
    end
    if v22 and v22:IsA("GuiButton") and v23 then
        local v24 = { Pending = false }
        local v25 = v21 and v21:FindFirstChild("Before")
        if not (v25 and v25:IsA("TextLabel")) then
            v25 = nil
        end
        v24.Before = v25
        local v26 = v21 and v21:FindFirstChild("After")
        if not (v26 and v26:IsA("TextLabel")) then
            v26 = nil
        end
        v24.After = v26
        v24.Price = v23
        v24.AuthoredText = v23.Text
        v2 = v24
        local Activated = v22.Activated
        local v27 = v23
        Activated:Connect(function() -- line 145 | captures: v24, v27, RobuxShopConfig, SpeedBoostConfig, RobuxPurchase, LocalPlayer, refresh
            local v28 = SpeedBoostConfig.NextTier(SpeedBoostConfig.MultiplierOf(LocalPlayer))
            if v28 and not v24.Pending then
                v24.Pending = true
                v27.RichText = false
                v27.Text = RobuxShopConfig.PendingText
                if not RobuxPurchase.Prompt(v28.DevProductId) then
                    v24.Pending = false
                    refresh()
                end
            end
        end)
        if v20 and v20:IsA("GuiButton") then
            v20.Activated:Connect(function() -- line 161 | captures: SpeedBoostConfig, GiftPlayerController, giftTierFor
                GiftPlayerController.Open(SpeedBoostConfig.Tiers[1].DevProductId, giftTierFor)
            end)
        end
        refresh()
    else
        warn((("[SpeedBoostShopCard] shop card %* (Inner.ButtonList.Purchase.Price) not found"):format(ShopCard.CardName)))
        v2 = nil
    end
end

return v1
