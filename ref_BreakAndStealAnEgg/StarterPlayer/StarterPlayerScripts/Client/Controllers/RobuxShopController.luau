-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnalyticsConfig = require(ReplicatedStorage.Shared.AnalyticsConfig)
local EggTypeConfig = require(ReplicatedStorage.Shared.EggTypeConfig)
local PaidRandomItemsConfig = require(ReplicatedStorage.Shared.PaidRandomItemsConfig)
local PotionConfig = require(ReplicatedStorage.Shared.PotionConfig)
local RobuxShopConfig = require(ReplicatedStorage.Shared.RobuxShopConfig)
local GiftPlayerController = require(script.Parent.GiftPlayerController)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local ProductPrompt = require(script.Parent.Parent.Modules.ProductPrompt)
local ShopAnimalInfo = require(script.Parent.Parent.Modules.ShopAnimalInfo)
local SpeedBoostShopCard = require(script.Parent.Parent.Modules.SpeedBoostShopCard)
local NotificationController = require(script.Parent.NotificationController)
local RobuxPurchase = require(script.Parent.RobuxPurchase)
local UiFrames = require(script.Parent.UiFrames)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}

local function isOwned(v3) -- line 71 | captures: LocalPlayer
    if v3.OwnedAttribute == nil then
        return false
    end
    return LocalPlayer:GetAttribute(v3.OwnedAttribute) == true
end

local function showPrice(v4) -- line 78 | captures: RobuxPurchase
    if RobuxPurchase.GetPrice(v4.ProductId) == nil then
        v4.Price.Text = v4.AuthoredText
    end
    RobuxPurchase.StampPrice(v4.Price, v4.ProductId)
end

local function showBought(v5) -- line 88 | captures: RobuxShopConfig, RobuxPurchase
    RobuxPurchase.Unbind(v5.Price)
    v5.Price.Text = RobuxShopConfig.BoughtText
end

local v6 = {}

local function watchOwnership(v7) -- line 104 | captures: RobuxShopConfig, RobuxPurchase, LocalPlayer, v2, v6
    local OwnedAttribute = v7.OwnedAttribute
    if not OwnedAttribute then
        return
    end
    local ProductId = v7.ProductId

    local function apply() -- line 111 | captures: OwnedAttribute, ProductId, RobuxShopConfig, RobuxPurchase, LocalPlayer, v2
        local v8 = v2[ProductId]
        if not (v8 and LocalPlayer:GetAttribute(OwnedAttribute) == true) then
            return
        end
        RobuxPurchase.Unbind(v8.Price)
        v8.Price.Text = RobuxShopConfig.BoughtText
        v8.Button.AutoButtonColor = false
    end

    if not v6[OwnedAttribute] then
        v6[OwnedAttribute] = true
        LocalPlayer:GetAttributeChangedSignal(OwnedAttribute):Connect(apply)
    end
    local v9 = v2[ProductId]
    if not (v9 and LocalPlayer:GetAttribute(OwnedAttribute) == true) then
        return
    end
    RobuxPurchase.Unbind(v9.Price)
    v9.Price.Text = RobuxShopConfig.BoughtText
    v9.Button.AutoButtonColor = false
end

local function wireGift(v10, v11, v12) -- line 133 | captures: GiftPlayerController
    if v10 and v10:IsA("GuiButton") then
        v10.Activated:Connect(function() -- line 137 | captures: v11, v12, GiftPlayerController
            if not (v12 and v12()) then
                GiftPlayerController.Open(v11)
            end
        end)
    end
end

local function bindPurchase(v13, v14, v15, v16, v17) -- line 148 | captures: RobuxShopConfig, RobuxPurchase, LocalPlayer, v2, watchOwnership
    local v18, v19, v20
    if v14 then
        v19 = v14:FindFirstChild("Price")
        if v14:IsA("GuiButton") and v19 and v19:IsA("TextLabel") then
            v18 = {
                ProductId = v15,
                Button = v14,
                Price = v19,
                AuthoredText = v19.Text,
                OwnedAttribute = v16
            }
            v2[v15] = v18
            if RobuxPurchase.GetPrice(v18.ProductId) == nil then
                v18.Price.Text = v18.AuthoredText
            end
            v20 = false
        else
            v20 = true
        end
    else
        v19 = v14
        v20 = true
    end
    if not v20 then
        RobuxPurchase.StampPrice(v18.Price, v18.ProductId)
        watchOwnership(v18)
        local Activated = v14.Activated
        local v21 = v18
        local v22 = v19
        Activated:Connect(function() -- line 173 | captures: v15, v17, v21, v22, RobuxShopConfig, RobuxPurchase, LocalPlayer
            if not (v21.OwnedAttribute ~= nil and LocalPlayer:GetAttribute(v21.OwnedAttribute) == true) and not (v17 and v17()) then
                v22.Text = RobuxShopConfig.PendingText
                if not RobuxPurchase.Prompt(v15) then
                    if RobuxPurchase.GetPrice(v21.ProductId) == nil then
                        v21.Price.Text = v21.AuthoredText
                    end
                    RobuxPurchase.StampPrice(v21.Price, v21.ProductId)
                end
            end
        end)
        return true
    end
    warn((("[RobuxShopController] shop card %* has no Purchase button"):format(v13)))
    return false
end

local function bindCard(v23, v24, v25, v26, v27) -- line 191 | captures: GiftPlayerController, bindPurchase
    local v28 = v23:FindFirstChild(v24, true)
    local v29 = v28 and v28:FindFirstChild("Inner")
    if v29 then
        if v26 then
            local Title = v29:FindFirstChild("Title")
            if Title and Title:IsA("TextLabel") then
                Title.RichText = true
                Title.Text = v26
            end
        end
        local ButtonList = v29:FindFirstChild("ButtonList")
        if bindPurchase(v24, ButtonList and ButtonList:FindFirstChild("Purchase"), v25, v27) then
            local v30 = ButtonList and ButtonList:FindFirstChild("Gift")
            if v30 then
                if not v30:IsA("GuiButton") then
                    return
                end
                local Activated = v30.Activated
                local v31
                Activated:Connect(function() -- line 137 | captures: v25, v31, GiftPlayerController
                    if not (v31 and v31()) then
                        GiftPlayerController.Open(v25)
                    end
                end)
            end
        end
    else
        warn((("[RobuxShopController] shop card %* not found"):format(v24)))
    end
end

local v32 = {}
local v33 = false

local function applyPaidRandomVisibility() -- line 224 | captures: PaidRandomItemsConfig, LocalPlayer, v32
    local v34 = not PaidRandomItemsConfig.IsRestricted(LocalPlayer)
    for v35, v36 in v32 do
        v36.Visible = v34
    end
end

local function eggPackBlocked() -- line 232 | captures: PaidRandomItemsConfig, NotificationController, LocalPlayer
    if PaidRandomItemsConfig.IsRestricted(LocalPlayer) then
        NotificationController.ShowPreset(PaidRandomItemsConfig.Presets.Restricted)
        return true
    end
    return false
end

local function bindEggPack(v37) -- line 245 | captures: v33, EggTypeConfig, PaidRandomItemsConfig, RobuxShopConfig, GiftPlayerController, ShopAnimalInfo, NotificationController, LocalPlayer, bindPurchase, v32, applyPaidRandomVisibility, eggPackBlocked
    local EggPack = RobuxShopConfig.EggPack
    local v38 = v37:FindFirstChild(EggPack.CardName, true)
    local v39 = v38 and v38:FindFirstChild("Inner")
    if v39 then
        table.clear(v32)
        for v40, v41 in {
                v38,
                (v37:FindFirstChild(EggPack.HeaderName, true))
            } do
            if v41 and v41:IsA("GuiObject") then
                table.insert(v32, v41)
            end
        end
        if not v33 then
            v33 = true
            LocalPlayer:GetAttributeChangedSignal(PaidRandomItemsConfig.Attribute):Connect(applyPaidRandomVisibility)
        end
        local v42 = not PaidRandomItemsConfig.IsRestricted(LocalPlayer)
        for v43, v44 in v32 do
            v44.Visible = v42
        end
        local v45 = EggTypeConfig.HatchOdds(EggPack.EggType)
        local v46 = v37:FindFirstAncestorWhichIsA("GuiObject")
        while v46 do
            if v46.Name == "Shop" then
                break
            end
            v46 = v46:FindFirstAncestorWhichIsA("GuiObject")
        end
        local v47 = v46 or v37.Parent
        local AnimalsDisplay = v39:FindFirstChild("AnimalsDisplay")
        if AnimalsDisplay then
            for v48, v49 in EggPack.Tiles do
                local v50 = AnimalsDisplay:FindFirstChild(v48)
                if v50 and v50:IsA("GuiObject") then
                    local Chance = v50:FindFirstChild("Chance")
                    if not (Chance and Chance:IsA("TextLabel")) then
                        Chance = v50:FindFirstChildWhichIsA("TextLabel")
                    end
                    local v51 = v45[v49]
                    if v51 then
                        if Chance then
                            Chance.Text = EggTypeConfig.FormatChance(v51)
                        end
                        local AnimalDisplay = v50:FindFirstChild("AnimalDisplay")
                        local Bind = ShopAnimalInfo.Bind
                        local v52 = if AnimalDisplay and AnimalDisplay:IsA("GuiObject") then { AnimalDisplay } else nil
                        Bind(v50, v49, v47, v52)
                    else
                        warn((("[RobuxShopController] %* (%*) is not in the %* HatchPool \226\128\148 tile hidden"):format(v49, v48, EggPack.EggType)))
                        v50.Visible = false
                    end
                else
                    warn((("[RobuxShopController] %* pets tile %* not found"):format(EggPack.CardName, v48)))
                end
            end
        end
        local ButtonList = v39:FindFirstChild("ButtonList")
        for v53, v54 in EggPack.Packs do
            local v55, v56
            if ButtonList then
                v55 = ButtonList:FindFirstChild(v54.PurchaseButton)
                v56 = ButtonList:FindFirstChild(v54.GiftButton)
            else
                v55 = ButtonList
                v56 = ButtonList
            end
            local v57 = v55 and v55:FindFirstChild("Amount")
            if v57 and v57:IsA("TextLabel") then
                v57.Text = RobuxShopConfig.EggPackAmountText(v54)
            end
            local v58 = RobuxShopConfig.EggPackProductId(v54)
            if v58 then
                if bindPurchase(("%*.%*"):format(EggPack.CardName, v54.PurchaseButton), v55, v58, nil, eggPackBlocked) and v56 and v56:IsA("GuiButton") then
                    v56.Activated:Connect(function() -- line 137 | captures: v58, GiftPlayerController, eggPackBlocked
                        if not (eggPackBlocked and eggPackBlocked()) then
                            GiftPlayerController.Open(v58)
                        end
                    end)
                end
            else
                for v59, v60 in { v55, v56 } do
                    if v60 and v60:IsA("GuiButton") then
                        v60.Activated:Connect(function() -- line 329 | captures: EggPack, NotificationController
                            NotificationController.Show(EggPack.UnavailableText, "Error")
                        end)
                    end
                end
            end
        end
    else
        warn((("[RobuxShopController] shop card %* not found"):format(EggPack.CardName)))
    end
end

function v1.Start() -- line 338 | captures: ReplicatedStorage, AnalyticsConfig, PotionConfig, RobuxShopConfig, MainGui, ProductPrompt, SpeedBoostShopCard, RobuxPurchase, UiFrames, LocalPlayer, v2, bindCard, bindEggPack
    ProductPrompt.Finished:Connect(function(v61, v62) -- line 343 | captures: RobuxShopConfig, RobuxPurchase, LocalPlayer, v2
        if v61 == LocalPlayer.UserId then
            local v63 = v2[v62]
            if v63 then
                if v63.OwnedAttribute ~= nil and LocalPlayer:GetAttribute(v63.OwnedAttribute) == true then
                    RobuxPurchase.Unbind(v63.Price)
                    v63.Price.Text = RobuxShopConfig.BoughtText
                else
                    if RobuxPurchase.GetPrice(v63.ProductId) == nil then
                        v63.Price.Text = v63.AuthoredText
                    end
                    RobuxPurchase.StampPrice(v63.Price, v63.ProductId)
                end
            end
        end
    end)
    MainGui.Observe(function(v64) -- line 361 | captures: ReplicatedStorage, AnalyticsConfig, PotionConfig, RobuxShopConfig, SpeedBoostShopCard, UiFrames, bindCard, bindEggPack
        local Frames = v64:FindFirstChild("Frames")
        local v65 = Frames and Frames:FindFirstChild(RobuxShopConfig.FrameName)
        local v66 = v65 and v65:FindFirstChild("ScrollingFrame")
        if v66 then
            if v65 and v65:IsA("GuiObject") then
                UiFrames.Observe(v65, function(v67) -- line 376 | captures: ReplicatedStorage, AnalyticsConfig
                    if v67 then
                        local v68 = ReplicatedStorage:FindFirstChild(AnalyticsConfig.ShopOpenedRemoteName)
                        if v68 and v68:IsA("RemoteEvent") then
                            v68:FireServer()
                        end
                    end
                end)
            end
            for v69, v70 in RobuxShopConfig.SpeedPacks do
                if v70.CardName then
                    bindCard(v66, v70.CardName, v70.ProductId, RobuxShopConfig.SpeedPackTitle(v70))
                end
            end
            for v71, v72 in RobuxShopConfig.CashPacks do
                bindCard(v66, v72.CardName, v72.ProductId, RobuxShopConfig.CashPackTitle(v72))
            end
            bindCard(v66, RobuxShopConfig.FastSwing.CardName, RobuxShopConfig.FastSwing.ProductId, nil, RobuxShopConfig.FastSwingAttribute)
            bindCard(v66, RobuxShopConfig.DoubleCash.CardName, RobuxShopConfig.DoubleCash.ProductId, nil, RobuxShopConfig.DoubleCashAttribute)
            bindCard(v66, RobuxShopConfig.DoubleGrowth.CardName, RobuxShopConfig.DoubleGrowth.ProductId, nil, RobuxShopConfig.DoubleGrowthAttribute)
            SpeedBoostShopCard.Bind(v66)
            local v73 = v66:FindFirstChild(RobuxShopConfig.FallenTokenSection)
            if v73 then
                for v74, v75 in RobuxShopConfig.FallenTokenPacks do
                    bindCard(v73, v75.CardName, v75.ProductId, RobuxShopConfig.FallenTokenPackTitle(v75))
                end
            else
                warn((("[RobuxShopController] Shop.ScrollingFrame.%* not found"):format(RobuxShopConfig.FallenTokenSection)))
            end
            bindEggPack(v66)
            for v76, v77 in PotionConfig.Potions do
                local CardName = v77.CardName
                local ProductId = v77.ProductId
                if CardName and ProductId then
                    bindCard(v66, CardName, ProductId)
                end
            end
        else
            warn("[RobuxShopController] MainGUI.Frames.Shop.ScrollingFrame not found")
        end
    end)
end

return v1
