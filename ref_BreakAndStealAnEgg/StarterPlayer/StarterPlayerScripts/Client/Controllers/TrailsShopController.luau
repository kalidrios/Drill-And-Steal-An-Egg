-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local TrailsConfig = require(ReplicatedStorage.Shared.TrailsConfig)
local AffordabilityFX = require(script.Parent.AffordabilityFX)
local RobuxPurchase = require(script.Parent.RobuxPurchase)
local ScrollToChild = require(script.Parent.Parent.Modules.ScrollToChild)
local TutorialShopFocus = require(script.Parent.Parent.Modules.TutorialShopFocus)
local UiFrames = require(script.Parent.UiFrames)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local v2 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local LocalPlayer = Players.LocalPlayer
local v3 = {}

local function fireRemote(v4, v5) -- line 62 | captures: ReplicatedStorage
    local TrailShopRequest = ReplicatedStorage:FindFirstChild("TrailShopRequest")
    if TrailShopRequest and TrailShopRequest:IsA("RemoteEvent") then
        TrailShopRequest:FireServer(v4, v5)
    end
end

local function equippedId() -- line 73 | captures: TrailsConfig, LocalPlayer
    local v6 = LocalPlayer:GetAttribute(TrailsConfig.EquippedAttribute)
    return TrailsConfig.ClampEquipped(v6)
end

local function ownedSet() -- line 78 | captures: TrailsConfig, LocalPlayer
    local v7 = {}
    local v8 = LocalPlayer:GetAttribute(TrailsConfig.EquippedAttribute)
    local v9 = TrailsConfig.ClampEquipped(v8)
    if v9 ~= 0 then
        v7[v9] = true
    end
    local v10 = LocalPlayer:GetAttribute(TrailsConfig.OwnedAttribute)
    if typeof(v10) == "string" then
        for v11 in string.gmatch(v10, "[^,]+") do
            local v12 = tonumber(v11)
            if v12 then
                v7[v12] = true
            end
        end
    end
    return v7
end

local function nextAffordableTrail() -- line 102 | captures: TrailsConfig, LocalPlayer, ownedSet
    local v13 = ownedSet()
    local v14 = 0
    for v15 in v13 do
        if v14 < v15 then
            v14 = v15
        end
    end
    local Cash = LocalPlayer:GetAttribute("Cash")
    if typeof(Cash) == "number" then
        local Id
        for v16, v17 in TrailsConfig.Trails do
            if v14 < v17.Id and not v13[v17.Id] and v17.Price <= Cash and (Id == nil or Id < v17.Id) then
                Id = v17.Id
            end
        end
        return Id
    end
    return nil
end

local function contentRoot(v18) -- line 133
    local Container = v18:FindFirstChild("Container")
    if not (Container and Container:IsA("GuiObject")) then
        return nil
    end
    return Container
end

local v19 = {}

local function refreshCard(v20, v21, v22) -- line 144 | captures: TrailsConfig, LocalPlayer, v3, ownedSet, v19
    local v23 = v3[v20]
    if not v23 then
        return
    end
    local v24 = v19[v23]
    if not v24 or v24.Parent == nil then
        v24 = v23:FindFirstChild("Container")
        if not (v24 and v24:IsA("GuiObject")) then
            v24 = nil
        end
        if v24 then
            v19[v23] = v24
        else
            return
        end
    end
    local v25 = TrailsConfig.Get(v20)
    local v26 = (v21 or ownedSet())[v20] == true
    local v27
    if v22 then
        v27 = v22
    else
        local v28 = LocalPlayer:GetAttribute(TrailsConfig.EquippedAttribute)
        v27 = TrailsConfig.ClampEquipped(v28)
    end
    local v29 = v27 == v20
    local v30 = if v25 == nil then false else v25.DevProductId ~= nil
    local Purchase = v24:FindFirstChild("Purchase")
    if Purchase and Purchase:IsA("GuiButton") then
        Purchase.Visible = not v26
    end
    local Robux = v24:FindFirstChild("Robux")
    if Robux and Robux:IsA("GuiButton") then
        Robux.Visible = not v26 and v30
    end
    local Equip = v24:FindFirstChild("Equip")
    local Title, v31, v32
    if Equip and Equip:IsA("GuiButton") then
        Equip.Visible = v26
        Equip.AutoButtonColor = true
        Title = Equip:FindFirstChild("Title")
        if Title and Title:IsA("TextLabel") then
            if v29 then
                v31 = "Unequip"
            else
                v31 = "Equip"
            end
            v32 = false
        else
            v32 = true
        end
    else
        v32 = true
    end
    if not v32 then
        Title.Text = v31
    end
end

local function buildCard(v33, v34) -- line 185 | captures: ReplicatedStorage, EggRewards, FormatNumber, RarityGradientFX, AffordabilityFX, RobuxPurchase, v3, ownedSet, refreshCard
    local v35 = v33:Clone()
    v35.Name = ("Trail%*"):format(v34.Id)
    v35.LayoutOrder = v34.Id
    v35.Visible = true
    local Container = v35:FindFirstChild("Container")
    if not (Container and Container:IsA("GuiObject")) then
        Container = nil
    end
    if Container then
        local BackgroundGradient = Container:FindFirstChild("BackgroundGradient")
        if BackgroundGradient and BackgroundGradient:IsA("UIGradient") then
            local v36 = Color3.new(1, 1, 1)
            local v37 = (v34.Colors[1] or v36):Lerp(v36, 0.35)
            local v38 = (v34.Colors[2] or v34.Colors[1] or v36):Lerp(v36, 0.175)
            Container.BackgroundColor3 = v36
            BackgroundGradient.Color = ColorSequence.new(v37, v38)
        end
        local Name = Container:FindFirstChild("Name")
        if Name and Name:IsA("TextLabel") then
            Name.Text = v34.Name
        end
        local Rarity = Container:FindFirstChild("Rarity")
        if Rarity and Rarity:IsA("TextLabel") then
            Rarity.Text = v34.Rarity
            if not RarityGradientFX.ApplyToLabel(Rarity, v34.Rarity) then
                local v39 = EggRewards.RarityColors[v34.Rarity]
                if v39 then
                    Rarity.TextColor3 = v39
                end
            end
        end
        local DamageInfo = Container:FindFirstChild("DamageInfo")
        local v40 = DamageInfo and DamageInfo:FindFirstChild("Amount")
        if v40 and v40:IsA("TextLabel") then
            v40.Text = ("x%*"):format((FormatNumber.Short(v34.Multiplier)))
        end
        local TrailsDisplay = Container:FindFirstChild("TrailsDisplay")
        if TrailsDisplay and TrailsDisplay:IsA("ImageLabel") then
            TrailsDisplay.Image = v34.Icon or ""
        end
        local Purchase = Container:FindFirstChild("Purchase")
        local Robux = Container:FindFirstChild("Robux")
        if Purchase and Purchase:IsA("GuiButton") then
            local v41 = Purchase:FindFirstChild("Price") or Purchase:FindFirstChild("Title")
            if v41 and v41:IsA("TextLabel") then
                v41.Text = ("$%*"):format((FormatNumber.Short(v34.Price)))
            end
            AffordabilityFX.Bind(Purchase, function() -- line 249 | captures: v34
                return v34.Price
            end)
            Purchase.Activated:Connect(function() -- line 252 | captures: v34, ReplicatedStorage
                local Id = v34.Id
                local TrailShopRequest = ReplicatedStorage:FindFirstChild("TrailShopRequest")
                if TrailShopRequest and TrailShopRequest:IsA("RemoteEvent") then
                    TrailShopRequest:FireServer("Buy", Id)
                end
            end)
        end
        if Robux and Robux:IsA("GuiButton") then
            if v34.DevProductId then
                local v42 = if Robux:FindFirstChild("Price") then "Price" else "Title"
                RobuxPurchase.Bind(Robux, v34.DevProductId, v42)
            elseif Purchase and Purchase:IsA("GuiButton") then
                Purchase.Position = UDim2.fromScale(0.5, Purchase.Position.Y.Scale)
            end
        end
        local Equip = Container:FindFirstChild("Equip")
        if Equip and Equip:IsA("GuiButton") then
            Equip.Activated:Connect(function() -- line 270 | captures: v34, ReplicatedStorage, ownedSet
                if not ownedSet()[v34.Id] then
                    return
                end
                local Id = v34.Id
                local TrailShopRequest = ReplicatedStorage:FindFirstChild("TrailShopRequest")
                if TrailShopRequest and TrailShopRequest:IsA("RemoteEvent") then
                    TrailShopRequest:FireServer("Equip", Id)
                end
            end)
        end
    end
    v3[v34.Id] = v35
    refreshCard(v34.Id)
    return v35
end

local v43 = {}

local function adopt(v44) -- line 295 | captures: TrailsConfig, ScrollToChild, TutorialShopFocus, UiFrames, v2, LocalPlayer, v3, ownedSet, nextAffordableTrail, v19, refreshCard, buildCard, v43
    local function v45(v46, ...)
        table.insert(v46, ...)
    end

    local function v47(v48, ...)
        table.insert(v48, ...)
    end

    for v49, v50 in v43 do
        v50:Disconnect()
    end
    table.clear(v43)
    table.clear(v3)
    table.clear(v19)
    local v51 = v44:WaitForChild("Frames", 10)
    local v52 = v51 and v51:FindFirstChild("Trails")
    if v52 then
        local ScrollingFrame = v52:FindFirstChild("ScrollingFrame")
        if ScrollingFrame then
            local v53 = ScrollingFrame:FindFirstChild("Template")
            if ScrollingFrame:IsA("ScrollingFrame") and v53 and v53:IsA("Frame") then
                v53.Visible = false
                for v54, v55 in TrailsConfig.Trails do
                    buildCard(v53, v55).Parent = ScrollingFrame
                end
                local v56 = 0
                UiFrames.Observe(v52, function(v57) -- line 329 | captures: v56, v52, ScrollingFrame, ScrollToChild, TutorialShopFocus, UiFrames, v2, v3, nextAffordableTrail
                    v56 += 1
                    local v58 = v56
                    ScrollToChild.Cancel(ScrollingFrame)
                    if v57 then
                        task.delay(0.3, function() -- line 337 | captures: v58, v56, v52, ScrollingFrame, ScrollToChild, TutorialShopFocus, UiFrames, v2, v3, nextAffordableTrail
                            local v59, v60
                            if v58 == v56 and UiFrames.IsOpen(v52) then
                                v59, v60 = TutorialShopFocus.TrailId()
                                if not v59 then
                                    v60 = nextAffordableTrail()
                                end
                            else
                                return
                            end
                            local v61 = v60 and v3[v60]
                            if not v61 or v59 and ScrollToChild.IsInView(ScrollingFrame, v61) then
                                return
                            end
                            ScrollToChild.Tween(ScrollingFrame, v61, v2)
                        end)
                    end
                end)

                local function refreshAll() -- line 355 | captures: TrailsConfig, LocalPlayer, v3, ownedSet, refreshCard
                    local v62 = ownedSet()
                    local v63 = LocalPlayer:GetAttribute(TrailsConfig.EquippedAttribute)
                    local v64 = TrailsConfig.ClampEquipped(v63)
                    for v65 in v3 do
                        refreshCard(v65, v62, v64)
                    end
                end

                v45(v43, LocalPlayer:GetAttributeChangedSignal(TrailsConfig.EquippedAttribute):Connect(refreshAll))
                v47(v43, LocalPlayer:GetAttributeChangedSignal(TrailsConfig.OwnedAttribute):Connect(refreshAll))
            end
        end
    end
end

function v1.Start() -- line 366 | captures: MainGui, adopt
    MainGui.Observe(adopt)
end

return v1
