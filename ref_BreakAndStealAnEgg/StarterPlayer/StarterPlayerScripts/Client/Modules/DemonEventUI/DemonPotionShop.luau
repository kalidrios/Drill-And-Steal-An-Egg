-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DemonEventConfig = require(ReplicatedStorage.Shared.DemonEventConfig)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local PotionConfig = require(ReplicatedStorage.Shared.PotionConfig)
local AffordabilityFX = require(script.Parent.Parent.Parent.Controllers.AffordabilityFX)
local v1 = {}
local v2 = { "ShopTab", "ScrollingFrame" }

local function find(v3, v4) -- line 32
    local v5 = v3
    for v6, v7 in v4 do
        v5 = v5 and v5:FindFirstChild(v7)
    end
    return v5
end

local function heroIcon(v8) -- line 42
    local v9
    for v10, v11 in v8:GetChildren() do
        if v11.Name == "ItemIcon" and v11:IsA("ImageLabel") then
            if v11:FindFirstChild("QuantityLabel") then
                return v11
            end
            if v9 then
                local Scale = v11.Size.X.Scale
                if v9.Size.X.Scale < Scale then
                    v9 = v11
                end
            else
                v9 = v11
            end
        end
    end
    return v9
end

local function setText(v12, v13) -- line 57
    if v12 and v12:IsA("TextLabel") then
        v12.Text = v13
    end
end

local function fillCard(v14, v15, v16) -- line 63 | captures: FormatNumber, heroIcon
    local Card = v14:FindFirstChild("Card")
    if not Card then
        return
    end
    local EggName = Card:FindFirstChild("EggName")
    local v17 = ("%* Potion"):format(v16.HoverName)
    if EggName and EggName:IsA("TextLabel") then
        EggName.Text = v17
    end
    local v18 = heroIcon(Card)
    if v18 then
        v18.Image = v16.Icon
        local QuantityLabel = v18:FindFirstChild("QuantityLabel")
        local HoverMultiplier = v16.HoverMultiplier
        if QuantityLabel and QuantityLabel:IsA("TextLabel") then
            QuantityLabel.Text = HoverMultiplier
        end
    end
    for v19, v20 in { "Buy", "PriceHolder", "Price" } do
        Card = Card and Card:FindFirstChild(v20)
    end
    local v21 = FormatNumber.Commas(v15.Price)
    if Card and Card:IsA("TextLabel") then
        Card.Text = v21
    end
end

function v1.fill(v22) -- line 77 | captures: DemonEventConfig, PotionConfig, v2, fillCard
    local v23 = v22:WaitForChild("Main")
    for v24, v25 in v2 do
        v23 = v23 and v23:FindFirstChild(v25)
    end
    if v23 then
        local v26 = v23:FindFirstChild("ShopItem")
        if v26 and v26:IsA("Frame") then
            v26.Visible = false
            for v27, v28 in DemonEventConfig.PotionOffers do
                local v29 = PotionConfig.ById(v28.PotionId)
                if v29 then
                    local v30 = v26:Clone()
                    v30.Name = "Potion_" .. v29.Id
                    v30.LayoutOrder = v27
                    v30:SetAttribute("PotionId", v29.Id)
                    fillCard(v30, v28, v29)
                    v30.Visible = true
                    v30.Parent = v23
                else
                    warn((("[DemonPotionShop] unknown potion \"%*\" in DemonEventConfig.PotionOffers"):format(v28.PotionId)))
                end
            end
            return
        end
    end
    warn((("[DemonPotionShop] missing Main.%*.ShopItem"):format((table.concat(v2, ".")))))
end

function v1.bind(v31) -- line 104 | captures: ReplicatedStorage, DemonEventConfig, AffordabilityFX, v2
    local function v32(v33, ...)
        table.insert(v33, ...)
    end

    local v34 = v31:WaitForChild("Main")
    for v35, v36 in v2 do
        v34 = v34 and v34:FindFirstChild(v36)
    end
    local v37 = {}
    local v38
    if v34 then
        v38 = v34:GetChildren()
    else
        v38 = {}
    end
    for v39, v40 in v38 do
        local v41 = DemonEventConfig.PotionOffer(v40:GetAttribute("PotionId"))
        if v41 then
            local v42 = v40
            local v43 = v40
            for v44, v45 in { "Card", "Buy" } do
                v42 = v42 and v42:FindFirstChild(v45)
                v43 = v42
            end
            if v43 and v43:IsA("GuiButton") then
                local PotionId = v41.PotionId
                local Price = v41.Price
                AffordabilityFX.Bind(v43, function() -- line 117 | captures: Price
                    return Price
                end, DemonEventConfig.BalanceAttribute)
                local Activated = v43.Activated
                v32(v37, Activated:Connect(function() -- line 120 | captures: PotionId, ReplicatedStorage, DemonEventConfig
                    local v46 = ReplicatedStorage:FindFirstChild(DemonEventConfig.RemoteName)
                    if v46 and v46:IsA("RemoteEvent") then
                        v46:FireServer("BuyPotion", PotionId)
                    end
                end))
            end
        end
    end
    return function() -- line 128 | captures: v37
        for v47, v48 in v37 do
            v48:Disconnect()
        end
        table.clear(v37)
    end
end

return v1
