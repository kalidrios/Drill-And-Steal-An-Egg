-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local TreadmillUpgradeConfig = require(ReplicatedStorage.Shared.TreadmillUpgradeConfig)
local AffordabilityFX = require(script.Parent.AffordabilityFX)
local OwnBase = require(script.Parent.OwnBase)
local RobuxPurchase = require(script.Parent.RobuxPurchase)
local v1 = {}
local LocalPlayer = Players.LocalPlayer

local function setLabel(v2, v3, v4) -- line 42
    local v5 = v2 and v2:FindFirstChild(v3, true)
    if v5 and v5:IsA("TextLabel") then
        v5.Text = v4
    end
end

local v6
local v7 = {}

local function collectFaces(v8) -- line 64 | captures: v6, LocalPlayer
    local v9 = {}
    for v10, v11 in v8:GetChildren() do
        if v11:IsA("SurfaceGui") then
            if v11.Name == "SurfaceGui" then
                local v12 = v11:Clone()
                v12.Name = "TreadmillBoardGui"
                v12.ResetOnSpawn = false
                v12.Adornee = v8
                v12.Parent = LocalPlayer:WaitForChild("PlayerGui")
                v11:Destroy()
                v6 = v12
                table.insert(v9, v12)
            else
                table.insert(v9, v11)
            end
        end
    end
    return v9
end

local function clearSetup() -- line 90 | captures: v6, v7
    for v13, v14 in v7 do
        v14:Disconnect()
    end
    table.clear(v7)
    if v6 then
        v6:Destroy()
        v6 = nil
    end
end

local v15 = { "UiGradient", "Outer", "UICorner", "Studs", "Bevel", "Price" }
local v16 = { "Purchase", "Robux", "Level", "Title" }

local function setupOwnBoard(v17) -- line 108 | captures: v6, ReplicatedStorage, FormatNumber, TreadmillUpgradeConfig, AffordabilityFX, OwnBase, RobuxPurchase, v7, collectFaces, v15, v16
    local function v18(v19, ...)
        table.insert(v19, ...)
    end

    local function v20(v21, ...)
        table.insert(v21, ...)
    end

    local function v22(v23, ...)
        table.insert(v23, ...)
    end

    local v24 = v17:WaitForChild("Board", 10)
    if v24 then
        local v25 = v24:WaitForChild("SurfaceGui", 10)
        if v25 then
            for v26, v27 in v16 do
                v25:WaitForChild(v27, 5)
            end
            for v28, v29 in { "Purchase", "Robux" } do
                local v30 = v25:FindFirstChild(v29)
                if v30 then
                    for v31, v32 in v15 do
                        v30:WaitForChild(v32, 5)
                    end
                    local Price = v30:FindFirstChild("Price")
                    if Price then
                        Price:WaitForChild("Outer", 5)
                    end
                end
            end
            if OwnBase.Get() == v17.Parent then
                for v33, v34 in v7 do
                    v34:Disconnect()
                end
                table.clear(v7)
                if v6 then
                    v6:Destroy()
                    v6 = nil
                end
                local v35 = collectFaces(v24)
                if #v35 ~= 0 then
                    local Parent = v17.Parent

                    local function setLabelOnFaces(v36, v37) -- line 168 | captures: v35
                        for v38, v39 in v35 do
                            local v40 = v39 and v39:FindFirstChild(v36, true)
                            if v40 and v40:IsA("TextLabel") then
                                v40.Text = v37
                            end
                        end
                    end

                    local function buttonsNamed(v41) -- line 177 | captures: v35
                        local v42 = {}
                        for v43, v44 in v35 do
                            local v45 = v44:FindFirstChild(v41)
                            if v45 and v45:IsA("GuiButton") then
                                table.insert(v42, v45)
                            end
                        end
                        return v42
                    end

                    local Purchase = buttonsNamed("Purchase")
                    local Robux = buttonsNamed("Robux")
                    local v46 = {}
                    for v47, v48 in Purchase do
                        v46[v48] = v48.Position
                    end

                    local function placePurchaseButtons(v49) -- line 198 | captures: Purchase, v46
                        for v50, v51 in Purchase do
                            local v52 = v46[v51]
                            if v49 then
                                local v53 = 0.5 + (v51.AnchorPoint.X - 0.5) * v51.Size.X.Scale
                                v51.Position = UDim2.new(v53, 0, v52.Y.Scale, v52.Y.Offset)
                            else
                                v51.Position = v52
                            end
                        end
                    end

                    local function currentLevel() -- line 210 | captures: Parent, TreadmillUpgradeConfig
                        return TreadmillUpgradeConfig.ClampLevel(Parent:GetAttribute("TreadmillLevel") or TreadmillUpgradeConfig.DefaultLevel)
                    end

                    local function upgradeCost() -- line 216 | captures: currentLevel, TreadmillUpgradeConfig
                        return TreadmillUpgradeConfig.UpgradeCost(currentLevel())
                    end

                    local function refresh() -- line 220 | captures: v35, Parent, Purchase, Robux, placePurchaseButtons, FormatNumber, TreadmillUpgradeConfig, AffordabilityFX, RobuxPurchase
                        local v54 = TreadmillUpgradeConfig.ClampLevel(Parent:GetAttribute("TreadmillLevel") or TreadmillUpgradeConfig.DefaultLevel)
                        local v55 = TreadmillUpgradeConfig.UpgradeCost(v54)
                        local v56
                        if v55 then
                            v56 = ("Lv. %* > Lv.%*"):format(v54, v54 + 1)
                        else
                            v56 = ("Lv. %* (MAX)"):format(v54)
                        end
                        for v57, v58 in v35 do
                            local v59 = v58 and v58:FindFirstChild("Level", true)
                            if v59 and v59:IsA("TextLabel") then
                                v59.Text = v56
                            end
                        end
                        for v60, v61 in Purchase do
                            local v62
                            if v55 then
                                v62 = ("$%*"):format((FormatNumber.Short(v55)))
                            else
                                v62 = "MAX"
                            end
                            local v63 = v61 and v61:FindFirstChild("Price", true)
                            if v63 and v63:IsA("TextLabel") then
                                v63.Text = v62
                            end
                        end
                        local v64 = TreadmillUpgradeConfig.SkipProductFor(v54)
                        for v65, v66 in Robux do
                            v66.Visible = v64 ~= nil
                            local Price = v66:FindFirstChild("Price")
                            if Price and Price:IsA("TextLabel") then
                                if v64 then
                                    RobuxPurchase.StampPrice(Price, v64)
                                else
                                    RobuxPurchase.Unbind(Price)
                                end
                            end
                        end
                        placePurchaseButtons(v64 == nil)
                        AffordabilityFX.Refresh()
                    end

                    v18(v7, Parent:GetAttributeChangedSignal("TreadmillLevel"):Connect(refresh))
                    refresh()
                    for v67, v68 in Purchase do
                        AffordabilityFX.Bind(v68, upgradeCost)
                        v20(v7, v68.Activated:Connect(function() -- line 258 | captures: ReplicatedStorage
                            local UpgradeTreadmillRequest = ReplicatedStorage:FindFirstChild("UpgradeTreadmillRequest")
                            if UpgradeTreadmillRequest and UpgradeTreadmillRequest:IsA("RemoteEvent") then
                                UpgradeTreadmillRequest:FireServer()
                            end
                        end))
                    end
                    for v69, v70 in Robux do
                        local Activated = v70.Activated
                        v22(v7, Activated:Connect(function() -- line 272 | captures: currentLevel, TreadmillUpgradeConfig, RobuxPurchase
                            local v71 = TreadmillUpgradeConfig.SkipProductFor(currentLevel())
                            if v71 then
                                RobuxPurchase.Prompt(v71)
                            end
                        end))
                    end
                end
            end
        end
    end
end

local v72

local function observeOwnBoard(v73) -- line 290 | captures: v6, v72, v7, setupOwnBoard
    if v72 then
        v72:Disconnect()
    end
    for v74, v75 in v7 do
        v75:Disconnect()
    end
    table.clear(v7)
    if v6 then
        v6:Destroy()
        v6 = nil
    end
    v72 = v73.ChildAdded:Connect(function(v76) -- line 295 | captures: setupOwnBoard
        if v76.Name == "TreadmillBoard" then
            setupOwnBoard(v76)
        end
    end)
    local TreadmillBoard = v73:FindFirstChild("TreadmillBoard")
    if TreadmillBoard then
        setupOwnBoard(TreadmillBoard)
    end
end

local v77 = {}

function v1.Start() -- line 309 | captures: Workspace, OwnBase, observeOwnBoard, v77
    local v78 = Workspace:WaitForChild("Plots", 30)
    if v78 then
        OwnBase.Observe(function(v79) -- line 320 | captures: v78, OwnBase, observeOwnBoard, v77
            for v80, v81 in v78:GetChildren() do
                if v81 ~= v79 then
                    local TreadmillBoard = v81:FindFirstChild("TreadmillBoard")
                    if TreadmillBoard then
                        TreadmillBoard:Destroy()
                    end
                    if not v77[v81] then
                        local ChildAdded = v81.ChildAdded
                        local v82 = v81
                        v77[v81] = ChildAdded:Connect(function(v83) -- line 330 | captures: v82, OwnBase
                            if v83.Name == "TreadmillBoard" and OwnBase.Get() ~= v82 then
                                v83:Destroy()
                            end
                        end)
                    end
                end
            end
            observeOwnBoard(v79)
        end)
    end
end

return v1
