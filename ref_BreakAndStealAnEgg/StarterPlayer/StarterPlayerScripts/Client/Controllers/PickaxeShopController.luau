-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
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
    local PickaxeShopRequest = ReplicatedStorage:FindFirstChild("PickaxeShopRequest")
    if PickaxeShopRequest and PickaxeShopRequest:IsA("RemoteEvent") then
        PickaxeShopRequest:FireServer(v4, v5)
    end
end

local function equippedTier() -- line 73 | captures: PickaxeConfig, LocalPlayer
    local PickaxeTier = LocalPlayer:GetAttribute("PickaxeTier")
    if typeof(PickaxeTier) == "number" then
        return PickaxeTier
    end
    return PickaxeConfig.DefaultTier
end

local function ownedSet() -- line 78 | captures: PickaxeConfig, LocalPlayer
    local v6 = {}
    v6[PickaxeConfig.DefaultTier] = true
    local PickaxeTier = LocalPlayer:GetAttribute("PickaxeTier")
    if typeof(PickaxeTier) ~= "number" then
        PickaxeTier = PickaxeConfig.DefaultTier
    end
    v6[PickaxeTier] = true
    local OwnedPickaxes = LocalPlayer:GetAttribute("OwnedPickaxes")
    if typeof(OwnedPickaxes) == "string" then
        for v7 in string.gmatch(OwnedPickaxes, "[^,]+") do
            local v8 = tonumber(v7)
            if v8 then
                v6[v8] = true
            end
        end
    end
    return v6
end

local function nextAffordableTier() -- line 97 | captures: PickaxeConfig, LocalPlayer, ownedSet
    local v9 = ownedSet()
    local v10 = PickaxeConfig.DefaultTier
    for v11 in v9 do
        if v10 < v11 then
            v10 = v11
        end
    end
    local Cash = LocalPlayer:GetAttribute("Cash")
    if typeof(Cash) == "number" then
        local v12
        for v13, v14 in PickaxeConfig.Tiers do
            if v10 < v13 and not v9[v13] and (v14.Price or 0) <= Cash and (v12 == nil or v12 < v13) then
                v12 = v13
            end
        end
        return v12
    end
    return nil
end

local function applyIcon(v15, v16) -- line 131 | captures: ReplicatedStorage, PickaxeConfig
    local v17 = PickaxeConfig.GetIcon(v16)
    if v17 == "" then
        task.spawn(function() -- line 137 | captures: v15, v16, ReplicatedStorage, PickaxeConfig
            local v18 = ReplicatedStorage:WaitForChild(PickaxeConfig.TemplatesFolderName, 30)
            if v18 then
                v18:WaitForChild(PickaxeConfig.GetTier(v16).Template, 10)
            end
            if v15.Parent ~= nil then
                v15.Image = PickaxeConfig.GetIcon(v16)
            end
        end)
    else
        v15.Image = v17
    end
end

local function contentRoot(v19) -- line 158
    local Container = v19:FindFirstChild("Container")
    if not (Container and Container:IsA("GuiObject")) then
        local v20 = v19:FindFirstChild("Inner", true)
        if not (v20 and v20:IsA("Frame")) then
            return nil
        end
        return v20
    end
    local Inner = Container:FindFirstChild("Inner")
    if not (Inner and Inner:IsA("Frame")) then
        return Container
    end
    return Inner
end

local function applyRarityGradient(v21, v22) -- line 176 | captures: EggRewards, RarityGradientFX
    if v22 and EggRewards.RarityGradients[v22] then
        local BackgroundGradient = v21:FindFirstChild("BackgroundGradient")
        if BackgroundGradient and BackgroundGradient:IsA("UIGradient") then
            v21.BackgroundColor3 = Color3.new(1, 1, 1)
            RarityGradientFX.Attach(BackgroundGradient, v22, {
                Alpha = 0.35,
                Target = Color3.new(1, 1, 1)
            })
        end
    else
        return
    end
    local Parent = v21.Parent
    if Parent and Parent:IsA("GuiObject") and Parent.Name == "Container" then
        local BackgroundGradient = Parent:FindFirstChild("BackgroundGradient")
        if BackgroundGradient and BackgroundGradient:IsA("UIGradient") then
            Parent.BackgroundColor3 = Color3.new(1, 1, 1)
            RarityGradientFX.Attach(BackgroundGradient, v22, {
                Alpha = 0.5,
                Target = Color3.new(0, 0, 0)
            })
        end
    end
end

local v23 = {}

local function refreshCard(v24, v25, v26) -- line 208 | captures: PickaxeConfig, LocalPlayer, v3, ownedSet, contentRoot, v23
    local v27 = v3[v24]
    if not v27 then
        return
    end
    local v28 = v23[v27]
    if not v28 or v28.Parent == nil then
        v28 = contentRoot(v27)
        if v28 then
            v23[v27] = v28
        else
            return
        end
    end
    local v29 = (v25 or ownedSet())[v24] == true
    local PickaxeTier
    if v26 then
        PickaxeTier = v26
    else
        PickaxeTier = LocalPlayer:GetAttribute("PickaxeTier")
        if typeof(PickaxeTier) ~= "number" then
            PickaxeTier = PickaxeConfig.DefaultTier
        end
    end
    local v30 = PickaxeTier == v24
    local v31 = PickaxeConfig.GetProductId(v24) ~= nil
    local Purchase = v28:FindFirstChild("Purchase")
    if Purchase and Purchase:IsA("GuiButton") then
        Purchase.Visible = not v29
    end
    local Robux = v28:FindFirstChild("Robux")
    if Robux and Robux:IsA("GuiButton") then
        Robux.Visible = not v29 and v31
    end
    local Equip = v28:FindFirstChild("Equip")
    local Title, v32, v33
    if Equip and Equip:IsA("GuiButton") then
        Equip.Visible = v29
        Equip.AutoButtonColor = not v30
        Title = Equip:FindFirstChild("Title")
        if Title and Title:IsA("TextLabel") then
            if v30 then
                v32 = "Equipped"
            else
                v32 = "Equip"
            end
            v33 = false
        else
            v33 = true
        end
    else
        v33 = true
    end
    if not v33 then
        Title.Text = v32
    end
    local Unequip = v28:FindFirstChild("Unequip")
    if Unequip and Unequip:IsA("GuiObject") then
        Unequip.Visible = false
    end
end

local function buildCard(v34, v35) -- line 250 | captures: ReplicatedStorage, EggRewards, FormatNumber, PickaxeConfig, RarityGradientFX, AffordabilityFX, RobuxPurchase, LocalPlayer, v3, ownedSet, contentRoot, applyRarityGradient, refreshCard
    local v36 = PickaxeConfig.GetTier(v35)
    local v37 = v34:Clone()
    v37.Name = ("Tier%*"):format(v35)
    v37.LayoutOrder = v35
    v37.Visible = true
    local v38 = contentRoot(v37)
    if v38 then
        applyRarityGradient(v38, v36.Rarity)
        local PickaxeDisplay = v38:FindFirstChild("PickaxeDisplay")
        local v39 = if PickaxeDisplay and PickaxeDisplay:IsA("GuiObject") then PickaxeDisplay.ZIndex else 2
        for v40, v41 in v38:GetChildren() do
            if v41:IsA("TextLabel") or v41:IsA("GuiButton") or v41:IsA("Frame") and v41.Name == "DamageInfo" then
                v41.ZIndex = v39 + 1
            end
        end
        local Name = v38:FindFirstChild("Name")
        local Rarity = v38:FindFirstChild("Rarity")
        if Name and Name:IsA("TextLabel") then
            Name.Text = v36.Name
        end
        local v42, v43
        if Rarity and Rarity:IsA("TextLabel") then
            Rarity.Text = v36.Rarity or ""
            if RarityGradientFX.ApplyToLabel(Rarity, v36.Rarity) then
                v43 = true
            else
                v42 = v36.Rarity and EggRewards.RarityColors[v36.Rarity]
                v43 = false
            end
        else
            v43 = true
        end
        if not v43 and v42 then
            Rarity.TextColor3 = v42
        end
        if not (Name and Name:IsA("TextLabel")) then
            for v44, v45 in v38:GetChildren() do
                if v45:IsA("TextLabel") and v45.Name == "Title" then
                    if v45.Position.X.Scale < 0.4 then
                        v45.Text = v36.Rarity or ""
                        if not RarityGradientFX.ApplyToLabel(v45, v36.Rarity) then
                            local v46 = v36.Rarity and EggRewards.RarityColors[v36.Rarity]
                            if v46 then
                                v45.TextColor3 = v46
                            end
                        end
                    else
                        v45.Text = v36.Name
                    end
                end
            end
        end
        local DamageInfo = v38:FindFirstChild("DamageInfo")
        local v47
        if DamageInfo then
            v47 = DamageInfo:FindFirstChild("Amount")
        else
            v47 = v38:FindFirstChild("Damage")
        end
        if v47 and v47:IsA("TextLabel") then
            v47.Text = FormatNumber.Short(v36.Damage)
        end
        local PickaxeDisplay_2 = v38:FindFirstChild("PickaxeDisplay")
        if PickaxeDisplay_2 and PickaxeDisplay_2:IsA("ImageLabel") then
            local v48 = PickaxeConfig.GetIcon(v35)
            if v48 == "" then
                task.spawn(function() -- line 137 | captures: v35, PickaxeDisplay_2, ReplicatedStorage, PickaxeConfig
                    local v49 = ReplicatedStorage:WaitForChild(PickaxeConfig.TemplatesFolderName, 30)
                    if v49 then
                        v49:WaitForChild(PickaxeConfig.GetTier(v35).Template, 10)
                    end
                    if PickaxeDisplay_2.Parent ~= nil then
                        PickaxeDisplay_2.Image = PickaxeConfig.GetIcon(v35)
                    end
                end)
            else
                PickaxeDisplay_2.Image = v48
            end
        end
        local Purchase = v38:FindFirstChild("Purchase")
        local Robux = v38:FindFirstChild("Robux")
        if Purchase and Purchase:IsA("GuiButton") then
            local v50 = Purchase:FindFirstChild("Price") or Purchase:FindFirstChild("Title")
            if v50 and v50:IsA("TextLabel") then
                v50.Text = ("$%*"):format((FormatNumber.Short(PickaxeConfig.GetPrice(v35))))
            end
            AffordabilityFX.Bind(Purchase, function() -- line 346 | captures: v35, PickaxeConfig
                return PickaxeConfig.GetPrice(v35)
            end)
            Purchase.Activated:Connect(function() -- line 349 | captures: v35, ReplicatedStorage
                local PickaxeShopRequest = ReplicatedStorage:FindFirstChild("PickaxeShopRequest")
                if PickaxeShopRequest and PickaxeShopRequest:IsA("RemoteEvent") then
                    PickaxeShopRequest:FireServer("Buy", v35)
                end
            end)
        end
        if Robux and Robux:IsA("GuiButton") then
            if v36.DevProductId then
                local v51 = if Robux:FindFirstChild("Price") then "Price" else "Title"
                RobuxPurchase.Bind(Robux, v36.DevProductId, v51)
            elseif Purchase and Purchase:IsA("GuiButton") then
                Purchase.Position = UDim2.fromScale(0.5, Purchase.Position.Y.Scale)
            end
        end
        local Equip = v38:FindFirstChild("Equip")
        if Equip and Equip:IsA("GuiButton") then
            Equip.Activated:Connect(function() -- line 369 | captures: v35, ReplicatedStorage, PickaxeConfig, LocalPlayer, ownedSet
                if not ownedSet()[v35] then
                    return
                end
                local PickaxeTier = LocalPlayer:GetAttribute("PickaxeTier")
                if typeof(PickaxeTier) ~= "number" then
                    PickaxeTier = PickaxeConfig.DefaultTier
                end
                if PickaxeTier ~= v35 then
                    local PickaxeShopRequest = ReplicatedStorage:FindFirstChild("PickaxeShopRequest")
                    if PickaxeShopRequest and PickaxeShopRequest:IsA("RemoteEvent") then
                        PickaxeShopRequest:FireServer("Equip", v35)
                    end
                end
            end)
        end
    end
    v3[v35] = v37
    refreshCard(v35)
    return v37
end

local v52 = {}

local function adopt(v53) -- line 392 | captures: PickaxeConfig, ScrollToChild, TutorialShopFocus, UiFrames, v2, LocalPlayer, v3, ownedSet, nextAffordableTier, v23, refreshCard, buildCard, v52
    local function v54(v55, ...)
        table.insert(v55, ...)
    end

    local function v56(v57, ...)
        table.insert(v57, ...)
    end

    for v58, v59 in v52 do
        v59:Disconnect()
    end
    table.clear(v52)
    table.clear(v3)
    table.clear(v23)
    local v60 = v53:WaitForChild("Frames", 10)
    local v61 = v60 and v60:FindFirstChild("Pickaxes")
    if v61 then
        local ScrollingFrame = v61:FindFirstChild("ScrollingFrame")
        if ScrollingFrame then
            local v62 = ScrollingFrame:FindFirstChild("Template")
            if ScrollingFrame:IsA("ScrollingFrame") and v62 and v62:IsA("Frame") then
                v62.Visible = false
                ScrollingFrame.ScrollingEnabled = true
                for v63 in PickaxeConfig.Tiers do
                    buildCard(v62, v63).Parent = ScrollingFrame
                end
                local v64 = 0
                UiFrames.Observe(v61, function(v65) -- line 431 | captures: v64, v61, ScrollingFrame, ScrollToChild, TutorialShopFocus, UiFrames, v2, v3, nextAffordableTier
                    v64 += 1
                    local v66 = v64
                    ScrollToChild.Cancel(ScrollingFrame)
                    if v65 then
                        task.delay(0.3, function() -- line 439 | captures: v66, v64, v61, ScrollingFrame, ScrollToChild, TutorialShopFocus, UiFrames, v2, v3, nextAffordableTier
                            local v67, v68
                            if v66 == v64 and UiFrames.IsOpen(v61) then
                                v67, v68 = TutorialShopFocus.PickaxeTier()
                                if not v67 then
                                    v68 = nextAffordableTier()
                                end
                            else
                                return
                            end
                            local v69 = v68 and v3[v68]
                            if not v69 or v67 and ScrollToChild.IsInView(ScrollingFrame, v69) then
                                return
                            end
                            ScrollToChild.Tween(ScrollingFrame, v69, v2)
                        end)
                    end
                end)

                local function refreshAll() -- line 457 | captures: PickaxeConfig, LocalPlayer, v3, ownedSet, refreshCard
                    local v70 = ownedSet()
                    local PickaxeTier = LocalPlayer:GetAttribute("PickaxeTier")
                    if typeof(PickaxeTier) ~= "number" then
                        PickaxeTier = PickaxeConfig.DefaultTier
                    end
                    for v71 in v3 do
                        refreshCard(v71, v70, PickaxeTier)
                    end
                end

                v54(v52, LocalPlayer:GetAttributeChangedSignal("PickaxeTier"):Connect(refreshAll))
                v56(v52, LocalPlayer:GetAttributeChangedSignal("OwnedPickaxes"):Connect(refreshAll))
            end
        end
    end
end

function v1.Start() -- line 468 | captures: MainGui, adopt
    MainGui.Observe(adopt)
end

return v1
