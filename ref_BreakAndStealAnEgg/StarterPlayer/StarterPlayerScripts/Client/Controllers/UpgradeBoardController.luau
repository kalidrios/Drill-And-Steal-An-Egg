-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local PlotUpgradeConfig = require(ReplicatedStorage.Shared.PlotUpgradeConfig)
local TreadmillUnlockConfig = require(ReplicatedStorage.Shared.TreadmillUnlockConfig)
local AffordabilityFX = require(script.Parent.AffordabilityFX)
local OwnBase = require(script.Parent.OwnBase)
local v1 = {}
local LocalPlayer = Players.LocalPlayer

local function setLabel(v2, v3, v4) -- line 43
    local v5 = v2 and v2:FindFirstChild(v3, true)
    if v5 and v5:IsA("TextLabel") then
        v5.Text = v4
    end
end

local function adoptFace(v6, v7, v8) -- line 53 | captures: LocalPlayer
    local v9 = v6:FindFirstChild(v7)
    if not (v9 and v9:IsA("SurfaceGui")) then
        return nil
    end
    local v10 = v9:Clone()
    v10.Name = v8
    v10.ResetOnSpawn = false
    v10.Adornee = v6
    v10.Parent = LocalPlayer:WaitForChild("PlayerGui")
    v9:Destroy()
    return v10
end

local v11 = {}
local v12 = {}

local function clearSetup() -- line 77 | captures: v11, v12
    for v13, v14 in v12 do
        v14:Disconnect()
    end
    table.clear(v12)
    for v15, v16 in v11 do
        v16:Destroy()
    end
    table.clear(v11)
end

local v17 = { "Level", "Title" }

local function setupOwnBoard(v18) -- line 92 | captures: ReplicatedStorage, FormatNumber, PlotUpgradeConfig, TreadmillUnlockConfig, AffordabilityFX, OwnBase, adoptFace, v11, v12, clearSetup, v17
    local function v19(v20, ...)
        table.insert(v20, ...)
    end

    local function v21(v22, ...)
        table.insert(v22, ...)
    end

    clearSetup()
    local v23 = v18:WaitForChild("UpgradeBoard", 10)
    local v24 = v23 and v23:WaitForChild("Board", 10)
    if v24 then
        for v25, v26 in { "SurfaceGui", "TutorialSurface" } do
            local v27 = v24:WaitForChild(v26, 10)
            if v27 then
                for v28, v29 in v17 do
                    v27:WaitForChild(v29, 5)
                end
                local v30 = v27:WaitForChild("Purchase", 5)
                if v30 then
                    v30:WaitForChild("UiGradient", 5)
                    v30:WaitForChild("Price", 5)
                end
            end
        end
        if OwnBase.Get() == v18 then
            local UpgradeBoardGui = adoptFace(v24, "SurfaceGui", "UpgradeBoardGui")
            local UpgradeBoardUnlockGui = adoptFace(v24, "TutorialSurface", "UpgradeBoardUnlockGui")
            if UpgradeBoardGui then
                table.insert(v11, UpgradeBoardGui)
            end
            if UpgradeBoardUnlockGui then
                table.insert(v11, UpgradeBoardUnlockGui)
            end
            if UpgradeBoardGui or UpgradeBoardUnlockGui then
                local function setUpgradeLabel(v31, v32) -- line 143 | captures: UpgradeBoardGui
                    local v33 = UpgradeBoardGui and UpgradeBoardGui:FindFirstChild(v31, true)
                    if v33 and v33:IsA("TextLabel") then
                        v33.Text = v32
                    end
                end

                local v34 = v23 and v23:FindFirstChild("InfoUi", true)

                local function applyFaceVisibility() -- line 151 | captures: v18, UpgradeBoardGui, UpgradeBoardUnlockGui, TreadmillUnlockConfig
                    local v35 = TreadmillUnlockConfig.IsPlotUnlocked(v18)
                    if UpgradeBoardGui then
                        UpgradeBoardGui.Enabled = v35
                    end
                    if UpgradeBoardUnlockGui then
                        UpgradeBoardUnlockGui.Enabled = not v35
                    end
                end

                local function upgradeCost() -- line 163 | captures: v18, PlotUpgradeConfig
                    local v36 = v18:GetAttribute("PlotLevel") or PlotUpgradeConfig.DefaultLevel
                    return PlotUpgradeConfig.UpgradeCost(v36)
                end

                local function refresh() -- line 168 | captures: v18, UpgradeBoardGui, v34, FormatNumber, PlotUpgradeConfig, AffordabilityFX
                    local v37 = v18:GetAttribute("PlotLevel") or PlotUpgradeConfig.DefaultLevel
                    local v38 = v18:GetAttribute("MaxAnimals") or PlotUpgradeConfig.Capacity(v37)
                    local v39 = v18:GetAttribute("AnimalsPlaced") or 0
                    local v40 = v18:GetAttribute("CashPerSecond") or 0
                    local v41 = PlotUpgradeConfig.UpgradeCost(v37)
                    local v42
                    if v41 then
                        v42 = ("Lv. %* > Lv.%*"):format(v37, v37 + 1)
                    else
                        v42 = ("Lv. %* (MAX)"):format(v37)
                    end
                    local v43 = UpgradeBoardGui and UpgradeBoardGui:FindFirstChild("Level", true)
                    if v43 and v43:IsA("TextLabel") then
                        v43.Text = v42
                    end
                    local v44
                    if v41 then
                        v44 = ("$%*"):format((FormatNumber.Short(v41)))
                    else
                        v44 = "MAX"
                    end
                    local v45 = UpgradeBoardGui and UpgradeBoardGui:FindFirstChild("Price", true)
                    if v45 and v45:IsA("TextLabel") then
                        v45.Text = v44
                    end
                    local v46 = ("%*/%*"):format(v39, v38)
                    local v47 = v34 and v34:FindFirstChild("AnimalsEquipped", true)
                    if v47 and v47:IsA("TextLabel") then
                        v47.Text = v46
                    end
                    local v48 = ("$%*/s"):format((FormatNumber.Short(v40)))
                    local v49 = v34 and v34:FindFirstChild("CashPerSecond", true)
                    if v49 and v49:IsA("TextLabel") then
                        v49.Text = v48
                    end
                    AffordabilityFX.Refresh()
                end

                for v50, v51 in { "PlotLevel", "MaxAnimals", "AnimalsPlaced", "CashPerSecond" } do
                    v19(v12, v18:GetAttributeChangedSignal(v51):Connect(refresh))
                end
                local v52 = v18:GetAttributeChangedSignal(TreadmillUnlockConfig.UnlockedAttribute)
                v21(v12, v52:Connect(function() -- line 187 | captures: v18, UpgradeBoardGui, UpgradeBoardUnlockGui, TreadmillUnlockConfig, AffordabilityFX
                    local v53 = TreadmillUnlockConfig.IsPlotUnlocked(v18)
                    if UpgradeBoardGui then
                        UpgradeBoardGui.Enabled = v53
                    end
                    if UpgradeBoardUnlockGui then
                        UpgradeBoardUnlockGui.Enabled = not v53
                    end
                    AffordabilityFX.Refresh()
                end))
                local v54 = TreadmillUnlockConfig.IsPlotUnlocked(v18)
                if UpgradeBoardGui then
                    UpgradeBoardGui.Enabled = v54
                end
                if UpgradeBoardUnlockGui then
                    UpgradeBoardUnlockGui.Enabled = not v54
                end
                refresh()
                if UpgradeBoardUnlockGui then
                    local v55 = "$" .. FormatNumber.Short(TreadmillUnlockConfig.Cost)
                    local v56 = UpgradeBoardUnlockGui:FindFirstChild("Price", true)
                    if v56 and v56:IsA("TextLabel") then
                        v56.Text = v55
                    end
                    local v57 = UpgradeBoardUnlockGui:FindFirstChild("Purchase", true)
                    if v57 and v57:IsA("GuiButton") then
                        AffordabilityFX.Bind(v57, function() -- line 200 | captures: v18, TreadmillUnlockConfig
                            if TreadmillUnlockConfig.IsPlotUnlocked(v18) then
                                return nil
                            end
                            return TreadmillUnlockConfig.Cost
                        end)
                        v57.Activated:Connect(function() -- line 204 | captures: ReplicatedStorage, TreadmillUnlockConfig
                            local v58 = ReplicatedStorage:FindFirstChild(TreadmillUnlockConfig.UnlockRemote)
                            if v58 and v58:IsA("RemoteEvent") then
                                v58:FireServer()
                            end
                        end)
                    end
                end
                local v59 = UpgradeBoardGui and UpgradeBoardGui:FindFirstChild("Purchase", true)
                if v59 and v59:IsA("GuiButton") then
                    AffordabilityFX.Bind(v59, upgradeCost)
                    v59.Activated:Connect(function() -- line 217 | captures: ReplicatedStorage
                        local UpgradePlotRequest = ReplicatedStorage:FindFirstChild("UpgradePlotRequest")
                        if UpgradePlotRequest and UpgradePlotRequest:IsA("RemoteEvent") then
                            UpgradePlotRequest:FireServer()
                        end
                    end)
                end
            end
        end
    end
end

function v1.Start() -- line 226 | captures: Workspace, OwnBase, setupOwnBoard
    local v60 = Workspace:WaitForChild("Plots", 30)
    if v60 then
        OwnBase.Observe(function(v61) -- line 237 | captures: v60, setupOwnBoard
            for v62, v63 in v60:GetChildren() do
                if v63 ~= v61 then
                    local UpgradeBoard = v63:FindFirstChild("UpgradeBoard")
                    if UpgradeBoard then
                        UpgradeBoard:Destroy()
                    end
                end
            end
            setupOwnBoard(v61)
        end)
    end
end

return v1
