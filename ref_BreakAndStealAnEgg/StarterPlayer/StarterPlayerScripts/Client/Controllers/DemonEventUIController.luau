-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local DemonEventUIConfig = require(ReplicatedStorage.Shared.DemonEventUIConfig)
local DemonEventConfig = require(ReplicatedStorage.Shared.DemonEventConfig)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local RobuxShopConfig = require(ReplicatedStorage.Shared.RobuxShopConfig)
local ShopSpeedFocusConfig = require(ReplicatedStorage.Shared.ShopSpeedFocusConfig)
local Session = require(script.Parent.Parent.Modules.DemonEventUI.Session)
local DemonEventShop = require(script.Parent.Parent.Modules.DemonEventUI.DemonEventShop)
local DemonEggOdds = require(script.Parent.Parent.Modules.DemonEventUI.DemonEggOdds)
local DemonPotionShop = require(script.Parent.Parent.Modules.DemonEventUI.DemonPotionShop)
local AnimalInfo = require(script.Parent.Parent.Modules.DemonEventUI.AnimalInfo)
local NewItemController = require(script.Parent.NewItemController)
local NotificationController = require(script.Parent.NotificationController)
local ShopSpeedFocusController = require(script.Parent.ShopSpeedFocusController)
local UiFrames = require(script.Parent.UiFrames)
local v1 = {}
local v2
local v3 = {}

local function notify(v4) -- line 70 | captures: v3
    for v5, v6 in v3 do
        task.spawn(v6, v4)
    end
end

local function onOpenChanged(v7) -- line 79 | captures: NotificationController, UiFrames, v3
    local v8 = v7:GetAttribute("Open") == true
    if v8 then
        local v9 = UiFrames.GetOpen()
        if v9 then
            UiFrames.Close(v9)
        end
        UiFrames.PlayOpenSound()
        NotificationController.Raise(v7)
    else
        NotificationController.Lower(v7)
    end
    for v10, v11 in v3 do
        task.spawn(v11, v8)
    end
end

local function bindBuyMore(v12) -- line 98 | captures: DemonEventUIConfig, RobuxShopConfig, ShopSpeedFocusConfig, ShopSpeedFocusController, v1
    local v13 = v12
    for v14, v15 in DemonEventUIConfig.BUY_MORE_PATH do
        v13 = v13 and v13:FindFirstChild(v15)
    end
    if v13 and v13:IsA("GuiButton") then
        return v13.Activated:Connect(function() -- line 107 | captures: RobuxShopConfig, ShopSpeedFocusConfig, ShopSpeedFocusController, v1
            v1.Close()
            ShopSpeedFocusController.OpenOnSection(RobuxShopConfig.FallenTokenHeader, { RobuxShopConfig.FallenTokenSection }, ShopSpeedFocusConfig.FallenTokensScrollTweenInfo)
        end)
    end
    warn((("[DemonEventUIController] missing DemonEventUI.%*"):format((table.concat(DemonEventUIConfig.BUY_MORE_PATH, ".")))))
    return nil
end

local function bind(v16) -- line 117 | captures: v2, Session, DemonEventShop, DemonEggOdds, DemonPotionShop, AnimalInfo, NotificationController, v3, onOpenChanged, bindBuyMore
    if not (v16.Name == "DemonEventUI" and v16:IsA("ScreenGui")) then
        return
    end
    if v2 and v2.Gui == v16 and v2.IsAlive() then
        return
    end
    local v17, v18 = pcall(DemonEggOdds.fill, v16)
    if not v17 then
        warn((("[DemonEventUIController] egg odds row failed: %*"):format(v18)))
    end
    local v19, v20 = pcall(DemonPotionShop.fill, v16)
    if not v19 then
        warn((("[DemonEventUIController] potion cards failed: %*"):format(v20)))
    end
    local v21, v22 = pcall(Session.new, v16)
    if v21 then
        v2 = v22
        local v23, v24 = pcall(DemonEventShop.bind, v16)
        if not v23 then
            warn((("[DemonEventUIController] shop wiring failed: %*"):format(v24)))
        end
        local v25, v26 = pcall(DemonPotionShop.bind, v16)
        if not v25 then
            warn((("[DemonEventUIController] potion shop wiring failed: %*"):format(v26)))
        end
        local v27, v28 = pcall(AnimalInfo.bind, v16)
        if not v27 then
            warn((("[DemonEventUIController] animal info bar failed: %*"):format(v28)))
        end
        local v29 = v16:GetAttributeChangedSignal("Open"):Connect(function() -- line 155 | captures: v16, onOpenChanged
            onOpenChanged(v16)
        end)
        local v30 = bindBuyMore(v16)
        v16.Destroying:Once(function() -- line 159 | captures: v16, v22, v23, v24, v25, v26, v27, v28, v29, v30, v2, NotificationController, v3
            v29:Disconnect()
            if v30 then
                v30:Disconnect()
            end
            if v23 then
                v24()
            end
            if v25 then
                v26()
            end
            if v27 then
                v28()
            end
            if v2 == v22 then
                v2 = nil
            end
            NotificationController.Lower(v16)
            for v31, v32 in v3 do
                task.spawn(v32, false)
            end
        end)
    else
        warn((("[DemonEventUIController] failed to bind %*: %*"):format(v16:GetFullName(), v22)))
    end
end

local function getSession() -- line 181 | captures: v2
    if not (v2 and v2.IsAlive()) then
        return nil
    end
    return v2
end

function v1.Open() -- line 188 | captures: v2
    local v33
    if not (v2 and v2.IsAlive()) then
    else
        v33 = v2
    end
    if v33 then
        v33.SetOpen(true)
    end
end

function v1.Close() -- line 195 | captures: v2
    local v34
    if not (v2 and v2.IsAlive()) then
    else
        v34 = v2
    end
    if v34 then
        v34.SetOpen(false)
    end
end

function v1.Toggle() -- line 202 | captures: v2
    local v35
    if not (v2 and v2.IsAlive()) then
    else
        v35 = v2
    end
    if v35 then
        v35.SetOpen(not v35.IsOpen())
    end
end

function v1.IsOpen() -- line 209 | captures: v2
    local v36
    if not (v2 and v2.IsAlive()) then
    else
        v36 = v2
    end
    if v36 == nil then
        return false
    end
    return (v36.IsOpen())
end

function v1.GetGui() -- line 214 | captures: v2
    local v37
    if not (v2 and v2.IsAlive()) then
    else
        v37 = v2
    end
    return v37 and v37.Gui or nil
end

function v1.Observe(v38) -- line 220 | captures: v3
    table.insert(v3, v38)
end

local v39 = {}
local v40

local function isFurnaceUnlocked() -- line 242 | captures: Players, DemonEventConfig
    local LocalPlayer = Players.LocalPlayer
    if LocalPlayer:GetAttribute(DemonEventConfig.FurnaceUnlockedAttribute) == true then
        return true
    end
    local v41 = LocalPlayer:GetAttribute(DemonEventConfig.SpeedPowerAttribute)
    if typeof(v41) == "number" then
        return DemonEventConfig.RequiredSpeedPower <= v41
    end
    return false
end

local function removeLock() -- line 252 | captures: v40, DemonEventUIConfig
    local v42 = v40 and v40:FindFirstChild(DemonEventUIConfig.LOCK_NAME)
    if v42 then
        v42:Destroy()
    end
end

local function refreshPrompt(v43) -- line 259 | captures: Players, DemonEventConfig, FormatNumber
    v43.HoldDuration = 0
    local LocalPlayer = Players.LocalPlayer
    local v44
    if LocalPlayer:GetAttribute(DemonEventConfig.FurnaceUnlockedAttribute) == true then
        v44 = true
    else
        local v45 = LocalPlayer:GetAttribute(DemonEventConfig.SpeedPowerAttribute)
        if typeof(v45) == "number" then
            v44 = DemonEventConfig.RequiredSpeedPower <= v45
        else
            v44 = false
        end
    end
    if v44 then
        v43.ActionText = DemonEventConfig.FurnaceUnlockedActionText
        v43.ObjectText = DemonEventConfig.FurnacePromptObjectText
    else
        v43.ActionText = DemonEventConfig.FurnaceLockedActionText
        v43.ObjectText = ("%* Speed Required"):format((FormatNumber.Short(DemonEventConfig.RequiredSpeedPower)))
    end
end

local function refreshFurnace() -- line 270 | captures: v40, Players, DemonEventUIConfig, DemonEventConfig, FormatNumber, v39
    local LocalPlayer = Players.LocalPlayer
    local v46
    if LocalPlayer:GetAttribute(DemonEventConfig.FurnaceUnlockedAttribute) == true then
        v46 = true
    else
        local v47 = LocalPlayer:GetAttribute(DemonEventConfig.SpeedPowerAttribute)
        if typeof(v47) == "number" then
            v46 = DemonEventConfig.RequiredSpeedPower <= v47
        else
            v46 = false
        end
    end
    if v46 then
        local v48 = v40 and v40:FindFirstChild(DemonEventUIConfig.LOCK_NAME)
        if v48 then
            v48:Destroy()
        end
    end
    for v49 in v39 do
        v49.HoldDuration = 0
        local LocalPlayer = Players.LocalPlayer
        local v50
        if LocalPlayer:GetAttribute(DemonEventConfig.FurnaceUnlockedAttribute) == true then
            v50 = true
        else
            local v51 = LocalPlayer:GetAttribute(DemonEventConfig.SpeedPowerAttribute)
            if typeof(v51) == "number" then
                v50 = DemonEventConfig.RequiredSpeedPower <= v51
            else
                v50 = false
            end
        end
        if v50 then
            v49.ActionText = DemonEventConfig.FurnaceUnlockedActionText
            v49.ObjectText = DemonEventConfig.FurnacePromptObjectText
        else
            v49.ActionText = DemonEventConfig.FurnaceLockedActionText
            v49.ObjectText = ("%* Speed Required"):format((FormatNumber.Short(DemonEventConfig.RequiredSpeedPower)))
        end
    end
end

local function bindPrompt(v52) -- line 279 | captures: Players, DemonEventConfig, FormatNumber, v1, v39
    if not v52:IsA("ProximityPrompt") or v39[v52] then
        return
    end
    v39[v52] = v52.Triggered:Connect(function() -- line 287 | captures: Players, DemonEventConfig, v1
        local LocalPlayer = Players.LocalPlayer
        local v53
        if LocalPlayer:GetAttribute(DemonEventConfig.FurnaceUnlockedAttribute) == true then
            v53 = true
        else
            local v54 = LocalPlayer:GetAttribute(DemonEventConfig.SpeedPowerAttribute)
            if typeof(v54) == "number" then
                v53 = DemonEventConfig.RequiredSpeedPower <= v54
            else
                v53 = false
            end
        end
        if v53 then
            v1.Open()
        end
    end)
    v52.HoldDuration = 0
    local LocalPlayer = Players.LocalPlayer
    local v55
    if LocalPlayer:GetAttribute(DemonEventConfig.FurnaceUnlockedAttribute) == true then
        v55 = true
    else
        local v56 = LocalPlayer:GetAttribute(DemonEventConfig.SpeedPowerAttribute)
        if typeof(v56) == "number" then
            v55 = DemonEventConfig.RequiredSpeedPower <= v56
        else
            v55 = false
        end
    end
    if v55 then
        v52.ActionText = DemonEventConfig.FurnaceUnlockedActionText
        v52.ObjectText = DemonEventConfig.FurnacePromptObjectText
    else
        v52.ActionText = DemonEventConfig.FurnaceLockedActionText
        v52.ObjectText = ("%* Speed Required"):format((FormatNumber.Short(DemonEventConfig.RequiredSpeedPower)))
    end
    local v57
    v57 = v52.AncestryChanged:Connect(function() -- line 295 | captures: v57, v52, v39
        if v52:IsDescendantOf(game) then
            return
        end
        v57:Disconnect()
        local v58 = v39[v52]
        if v58 then
            v58:Disconnect()
            v39[v52] = nil
        end
    end)
end

local function bindShop(v59) -- line 310 | captures: v40, Players, DemonEventUIConfig, DemonEventConfig, removeLock, bindPrompt
    if v59.Name ~= DemonEventUIConfig.SHOP_PART_NAME then
        return
    end
    v40 = v59
    local LocalPlayer = Players.LocalPlayer
    local v60
    if LocalPlayer:GetAttribute(DemonEventConfig.FurnaceUnlockedAttribute) == true then
        v60 = true
    else
        local v61 = LocalPlayer:GetAttribute(DemonEventConfig.SpeedPowerAttribute)
        if typeof(v61) == "number" then
            v60 = DemonEventConfig.RequiredSpeedPower <= v61
        else
            v60 = false
        end
    end
    if v60 then
        local v62 = v40 and v40:FindFirstChild(DemonEventUIConfig.LOCK_NAME)
        if v62 then
            v62:Destroy()
        end
    end
    bindPrompt(v59)
    for v63, v64 in v59:GetDescendants() do
        bindPrompt(v64)
    end
    v59.DescendantAdded:Connect(function(v65) -- line 322 | captures: v59, Players, DemonEventUIConfig, DemonEventConfig, removeLock, bindPrompt
        bindPrompt(v65)
        if not (v65.Name == DemonEventUIConfig.LOCK_NAME and v65.Parent == v59) then
            return
        end
        local LocalPlayer = Players.LocalPlayer
        local v66
        if LocalPlayer:GetAttribute(DemonEventConfig.FurnaceUnlockedAttribute) == true then
            v66 = true
        else
            local v67 = LocalPlayer:GetAttribute(DemonEventConfig.SpeedPowerAttribute)
            if typeof(v67) == "number" then
                v66 = DemonEventConfig.RequiredSpeedPower <= v67
            else
                v66 = false
            end
        end
        if v66 then
            task.defer(removeLock)
        end
    end)
end

function v1.Start() -- line 331 | captures: Players, ReplicatedStorage, Workspace, DemonEventConfig, FormatNumber, NewItemController, UiFrames, v1, bind, refreshFurnace, bindShop
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    PlayerGui.ChildAdded:Connect(bind)
    local DemonEventUI = PlayerGui:FindFirstChild("DemonEventUI")
    if DemonEventUI then
        bind(DemonEventUI)
    end
    UiFrames.ObserveAny(function(v68, v69) -- line 341 | captures: v1
        if v69 then
            v1.Close()
        end
    end)
    Players.LocalPlayer:GetAttributeChangedSignal(DemonEventConfig.FurnaceUnlockedAttribute):Connect(refreshFurnace)
    Players.LocalPlayer:GetAttributeChangedSignal(DemonEventConfig.SpeedPowerAttribute):Connect(refreshFurnace)
    Workspace.ChildAdded:Connect(bindShop)
    for v70, v71 in Workspace:GetChildren() do
        bindShop(v71)
    end
    task.spawn(function() -- line 357 | captures: ReplicatedStorage, DemonEventConfig, FormatNumber, NewItemController
        local v72 = ReplicatedStorage:WaitForChild(DemonEventConfig.RemoteName)
        if v72:IsA("RemoteEvent") then
            v72.OnClientEvent:Connect(function(v73, v74) -- line 362 | captures: DemonEventConfig, FormatNumber, NewItemController
                if v73 == "Rewarded" and typeof(v74) == "number" and not (v74 <= 0) then
                    NewItemController.Show({
                        {
                            Icon = DemonEventConfig.TokenIcon,
                            Count = v74,
                            Text = ("+%*"):format((FormatNumber.Short(v74)))
                        }
                    })
                end
            end)
        end
    end)
end

return v1
