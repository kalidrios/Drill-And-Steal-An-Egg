-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local MutationConfig = require(ReplicatedStorage.Shared.MutationConfig)
local RarityNameGradient = require(ReplicatedStorage.Shared.RarityNameGradient)
local PlotUpgradeConfig = require(ReplicatedStorage.Shared.PlotUpgradeConfig)
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local ChaseState = require(ReplicatedStorage.Shared.ChaseState)
local AffordabilityFX = require(script.Parent.AffordabilityFX)
local OwnBase = require(script.Parent.OwnBase)
local UiFrames = require(script.Parent.UiFrames)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}

local function fireRemote(v3, v4) -- line 51 | captures: ReplicatedStorage
    local PetsInventoryRemote = ReplicatedStorage:FindFirstChild("PetsInventoryRemote")
    if PetsInventoryRemote and PetsInventoryRemote:IsA("RemoteEvent") then
        PetsInventoryRemote:FireServer(v3, v4)
    end
end

local function placedValue(v5) -- line 62 | captures: EggRewards
    local AnimalName = v5:GetAttribute("AnimalName")
    local v6 = v5:GetAttribute("SizeMult") or 1
    local Mutation = v5:GetAttribute("Mutation")
    local WeightKg = v5:GetAttribute("WeightKg")
    local Variant = v5:GetAttribute("Variant")
    if typeof(AnimalName) == "string" then
        return EggRewards.PlacedCashPerSecond(AnimalName, v6, Mutation, WeightKg, Variant)
    end
    return 0
end

local function buildRow(v7, v8) -- line 76 | captures: ReplicatedStorage, EggRewards, FormatNumber, MutationConfig, RarityNameGradient, AnimalRenders, placedValue
    local AnimalName = v8:GetAttribute("AnimalName")
    if typeof(AnimalName) == "string" then
        local v9 = v7:Clone()
        v9.Name = "Entry"
        v9.Visible = true
        local Container = v9:FindFirstChild("Container")
        if Container then
            local Name = Container:FindFirstChild("Name")
            if Name and Name:IsA("TextLabel") then
                local Mutation = v8:GetAttribute("Mutation")
                local v10 = MutationConfig.Get(Mutation)
                Name.Text = MutationConfig.PrefixName(Mutation, EggRewards.DisplayName(AnimalName))
                local Apply = RarityNameGradient.Apply
                local v11 = { Rarity = EggRewards.RarityOf(AnimalName) }
                if v10 then
                    v11.Base = v10.Color
                else
                    v11.Base = nil
                end
                Apply(Name, v11)
            end
            local CPS = Container:FindFirstChild("CPS")
            if CPS and CPS:IsA("TextLabel") then
                CPS.Text = ("($%*/s)"):format((FormatNumber.Short(placedValue(v8))))
            end
            local AnimalDisplay = Container:FindFirstChild("AnimalDisplay")
            if AnimalDisplay and AnimalDisplay:IsA("ImageLabel") then
                AnimalRenders.Apply(AnimalDisplay, AnimalName, (v8:GetAttribute("Variant")))
            end
            local Unequip = Container:FindFirstChild("Unequip")
            if Unequip and Unequip:IsA("GuiButton") then
                Unequip.Activated:Connect(function() -- line 120 | captures: v8, ReplicatedStorage
                    local PetsInventoryRemote = ReplicatedStorage:FindFirstChild("PetsInventoryRemote")
                    if PetsInventoryRemote and PetsInventoryRemote:IsA("RemoteEvent") then
                        PetsInventoryRemote:FireServer("Unequip", v8)
                    end
                end)
            end
        end
        return v9
    end
    return nil
end

local function rowHeightFor(v12) -- line 129
    local v13 = v12.AbsoluteWindowSize.Y * 0.33
    local v14 = math.floor(v13)
    return (math.max(v14, 1))
end

local function resortRows() -- line 135 | captures: v2, placedValue
    local v15 = {}
    local v16 = {}
    for v17 in v2 do
        table.insert(v15, v17)
        v16[v17] = placedValue(v17)
    end
    table.sort(v15, function(v18, v19) -- line 143 | captures: v16
        local v20 = v16[v18]
        return v16[v19] < v20
    end)
    for v21, v22 in v15 do
        v2[v22].LayoutOrder = v21
    end
end

local function addRow(v23, v24, v25) -- line 151 | captures: v2, buildRow
    if not v2[v25] then
        local v26 = buildRow(v24, v25)
        if v26 then
            local new = UDim2.new
            local v27 = v23.AbsoluteWindowSize.Y * 0.33
            local v28 = math.floor(v27)
            v26.Size = new(1, 0, 0, (math.max(v28, 1)))
            v26.Parent = v23
            v2[v25] = v26
        end
    end
end

local function removeRow(v29) -- line 163 | captures: v2
    local v30 = v2[v29]
    if v30 then
        v2[v29] = nil
        v30:Destroy()
    end
end

local v31 = {}

local function dropBaseConnections() -- line 189 | captures: v31
    for v32, v33 in v31 do
        v33:Disconnect()
    end
    table.clear(v31)
end

local function clearRows() -- line 197 | captures: v2
    local v34 = {}
    for v35 in v2 do
        table.insert(v34, v35)
    end
    for v36, v37 in v34 do
        local v38 = v2[v37]
        if v38 then
            v2[v37] = nil
            v38:Destroy()
        end
    end
end

local v39, v40, bindBase, v41
local v42 = 0

local function adopt(v43) -- line 221 | captures: v39, v40, bindBase, v41, v42, ReplicatedStorage, FormatNumber, PlotUpgradeConfig, ChaseState, AffordabilityFX, UiFrames, LocalPlayer, v2, buildRow, resortRows, v31, clearRows
    v42 += 1
    local v44 = v42
    bindBase = nil
    for v45, v46 in v31 do
        v46:Disconnect()
    end
    table.clear(v31)
    clearRows()
    v39 = nil
    v40 = nil
    local v47 = v43:WaitForChild("RightHUD", 10)
    local v48 = v43:WaitForChild("Frames", 10)
    local v49 = v47 and v47:FindFirstChild("Pets")
    local v50 = v48 and v48:FindFirstChild("PetsInventory")
    local v51, v52
    if v49 and v50 and v44 == v42 then
        v51 = v50:FindFirstChild("ScrollingFrame", true)
        v52 = v51 and v51:FindFirstChild("Template")
    else
        return
    end
    if v51 and v51:IsA("ScrollingFrame") and v52 and v52:IsA("Frame") then
        v52.Visible = false
        v39 = v47
        v40 = v50
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Name = "RowsLayout"
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 0)
        UIListLayout.Parent = v51
        v51.CanvasSize = UDim2.new()
        v51.AutomaticCanvasSize = Enum.AutomaticSize.Y
        UiFrames.Observe(v50, function(v53) -- line 266 | captures: v47, ChaseState, LocalPlayer
            if not ChaseState.IsActive(LocalPlayer) then
                v47.Visible = not v53
            end
        end)
        local AbsoluteWindowSize = v51:GetPropertyChangedSignal("AbsoluteWindowSize")
        local v54 = v51
        AbsoluteWindowSize:Connect(function() -- line 277 | captures: v54, v2
            local v55 = v54.AbsoluteWindowSize.Y * 0.33
            local v56 = math.floor(v55)
            local v57 = math.max(v56, 1)
            for v58, v59 in v2 do
                v59.Size = UDim2.new(1, 0, 0, v57)
            end
        end)
        if v49:IsA("GuiButton") then
            v49.Activated:Connect(function() -- line 285 | captures: v50, UiFrames
                UiFrames.Open(v50)
            end)
        end
    else
        return
    end
    v47.Visible = not v50.Visible
    local v60 = v50:FindFirstChild("Equip Best")
    if v60 and v60:IsA("GuiButton") then
        v60.Activated:Connect(function() -- line 300 | captures: ReplicatedStorage
            local PetsInventoryRemote = ReplicatedStorage:FindFirstChild("PetsInventoryRemote")
            if PetsInventoryRemote and PetsInventoryRemote:IsA("RemoteEvent") then
                PetsInventoryRemote:FireServer("EquipBest", nil)
            end
        end)
    end
    local TopBar = v50:FindFirstChild("TopBar")
    local v61 = TopBar and TopBar:FindFirstChild("PurchaseMoreEquipped")
    if v61 and v61:IsA("GuiButton") then
        v61.Activated:Connect(function() -- line 308 | captures: ReplicatedStorage
            local UpgradePlotRequest = ReplicatedStorage:FindFirstChild("UpgradePlotRequest")
            if UpgradePlotRequest and UpgradePlotRequest:IsA("RemoteEvent") then
                UpgradePlotRequest:FireServer()
            end
        end)
    end
    local v62 = v51
    local v63 = v52

    local function bindBase_2(v64) -- line 320 | captures: TopBar, v61, v62, v63, FormatNumber, PlotUpgradeConfig, AffordabilityFX, v2, buildRow, resortRows, v31, clearRows
        local function v65(v66, ...)
            table.insert(v66, ...)
        end

        for v67, v68 in v31 do
            v68:Disconnect()
        end
        table.clear(v31)
        clearRows()
        local v69 = TopBar and TopBar:FindFirstChild("Title")
        local v70 = v61 and v61:FindFirstChild("Title")

        local function refreshTopBar() -- line 329 | captures: v64, v70, v69, FormatNumber, PlotUpgradeConfig, AffordabilityFX
            local v71 = v64:GetAttribute("AnimalsPlaced") or 0
            local v72 = v64:GetAttribute("PlotLevel") or PlotUpgradeConfig.DefaultLevel
            local v73 = v64:GetAttribute("MaxAnimals") or PlotUpgradeConfig.Capacity(v72)
            if v69 and v69:IsA("TextLabel") then
                v69.Text = ("%*/%* Active"):format(v71, v73)
            end
            if v70 and v70:IsA("TextLabel") then
                local v74 = PlotUpgradeConfig.UpgradeCost(v72)
                local v75
                if v74 then
                    v75 = ("+1 Equip [%*$]"):format((FormatNumber.Short(v74)))
                else
                    v75 = "MAX"
                end
                v70.Text = v75
            end
            AffordabilityFX.Refresh()
        end

        if v61 and v61:IsA("GuiButton") then
            AffordabilityFX.Bind(v61, function() -- line 346 | captures: v64, PlotUpgradeConfig
                local v76 = v64:GetAttribute("PlotLevel") or PlotUpgradeConfig.DefaultLevel
                return PlotUpgradeConfig.UpgradeCost(v76)
            end)
        end
        for v77, v78 in { "AnimalsPlaced", "MaxAnimals", "PlotLevel" } do
            v65(v31, v64:GetAttributeChangedSignal(v78):Connect(refreshTopBar))
        end
        refreshTopBar()

        local function hookPlacedFolder(v79) -- line 359 | captures: v62, v63, v2, buildRow, resortRows, v31
            local function v80(v81, ...)
                table.insert(v81, ...)
            end

            local function v82(v83, ...)
                table.insert(v83, ...)
            end

            v80(v31, v79.ChildAdded:Connect(function(v84) -- line 360 | captures: v62, v63, v2, buildRow, resortRows
                if not v2[v84] then
                    local v85 = buildRow(v63, v84)
                    if v85 then
                        local new = UDim2.new
                        local v86 = v62.AbsoluteWindowSize.Y * 0.33
                        local v87 = math.floor(v86)
                        v85.Size = new(1, 0, 0, (math.max(v87, 1)))
                        v85.Parent = v62
                        v2[v84] = v85
                    end
                end
                resortRows()
            end))
            v82(v31, v79.ChildRemoved:Connect(function(v88) -- line 364 | captures: v2
                local v89 = v2[v88]
                if v89 then
                    v2[v88] = nil
                    v89:Destroy()
                end
            end))
            for v90, v91 in v79:GetChildren() do
                if not v2[v91] then
                    local v92 = buildRow(v63, v91)
                    if v92 then
                        local new = UDim2.new
                        local v93 = v62.AbsoluteWindowSize.Y * 0.33
                        local v94 = math.floor(v93)
                        v92.Size = new(1, 0, 0, (math.max(v94, 1)))
                        v92.Parent = v62
                        v2[v91] = v92
                    end
                end
            end
            resortRows()
        end

        local PlacedAnimals = v64:FindFirstChild("PlacedAnimals")
        if PlacedAnimals then
            hookPlacedFolder(PlacedAnimals)
        else
            local v95
            v95 = v64.ChildAdded:Connect(function(v96) -- line 379 | captures: v95, hookPlacedFolder
                if v96.Name == "PlacedAnimals" then
                    v95:Disconnect()
                    hookPlacedFolder(v96)
                end
            end)
            local v97 = v95
            table.insert(v31, v97)
        end
    end

    bindBase = bindBase_2
    if v41 then
        bindBase_2(v41)
    end
end

function v1.Start() -- line 395 | captures: v39, v40, bindBase, v41, ChaseState, OwnBase, UiFrames, MainGui, LocalPlayer, adopt
    OwnBase.Observe(function(v98) -- line 399 | captures: bindBase, v41
        v41 = v98
        local bindBase_2 = bindBase
        if bindBase_2 then
            bindBase_2(v98)
        end
    end)
    ChaseState.Observe(LocalPlayer, function(v99) -- line 410 | captures: v39, v40, ChaseState, UiFrames, LocalPlayer
        if not v99 then
            task.defer(function() -- line 412 | captures: v39, v40, ChaseState, UiFrames, LocalPlayer
                local v100 = v39
                local v101 = v40
                if v100 and v101 and not ChaseState.IsActive(LocalPlayer) then
                    v100.Visible = not UiFrames.IsOpen(v101)
                end
            end)
        end
    end)
    MainGui.Observe(adopt)
end

return v1
