-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local BackpackUiConfig = require(ReplicatedStorage.Shared.BackpackUiConfig)
local FloatingIconConfig = require(ReplicatedStorage.Shared.FloatingIconConfig)
local GamepadConfig = require(ReplicatedStorage.Shared.GamepadConfig)
local HellLoadout = require(ReplicatedStorage.Shared.HellLoadout)
local IndexConfig = require(ReplicatedStorage.Shared.IndexConfig)
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local BackpackAnimalInfo = require(script.Parent.Parent.Modules.BackpackAnimalInfo)
local BackpackFeedback = require(script.Parent.Parent.Modules.BackpackFeedback)
local BackpackGui = require(script.Parent.Parent.Modules.BackpackGui)
local BackpackHover = require(script.Parent.Parent.Modules.BackpackHover)
local BackpackSlotVisuals = require(script.Parent.Parent.Modules.BackpackSlotVisuals)
local FloatingIconFX = require(script.Parent.Parent.Modules.FloatingIconFX)
local v1 = {}
local v2 = Enum.ContextActionPriority.High.Value + 10
local v3 = {}

v3[Enum.UserInputType.MouseButton1] = true
v3[Enum.UserInputType.MouseButton2] = true
v3[Enum.UserInputType.MouseButton3] = true
v3[Enum.UserInputType.MouseMovement] = true
v3[Enum.UserInputType.MouseWheel] = true

local LocalPlayer = Players.LocalPlayer
local v4, v5, v6, v7, v8, v9, v10, v11, Title, InventoryCapacity
local v12 = {}
local v13 = BackpackUiConfig.HotbarSlotsFull
local v14 = {}
local v15 = {}
local v16 = {}
local v17 = 0
local v18 = {}
local v19 = false
local v20 = false
local v21 = BackpackUiConfig.DefaultCategory
local v22 = {}
local v23 = true
local v24, v25, v26
local v27 = {}
local v28 = {}
local v29 = 0
local v30
local v31 = 0
local v32, v33, v34, v35
local v36 = {}
local v37 = {}
local v38 = false
local v39

local function isLocked(v40) -- line 176 | captures: BackpackSlotVisuals
    if v40 == nil then
        return false
    end
    return (BackpackSlotVisuals.IsLocked(v40))
end

local function isEquipped(v41) -- line 180 | captures: v24
    if v41 == nil or v24 == nil then
        return false
    end
    return v41.Parent == v24
end

local function unequipAll() -- line 184 | captures: v25
    if v25 then
        v25:UnequipTools()
    end
end

local function equip(v42) -- line 190 | captures: v25, HellLoadout, LocalPlayer
    if HellLoadout.CanEquip(LocalPlayer, v42) and v25 and v25.Health > 0 then
        v25:EquipTool(v42)
    end
end

local function categoryOf(v43) -- line 200 | captures: CollectionService, BackpackUiConfig
    for v44, v45 in BackpackUiConfig.Categories do
        if v45.MatchTag and CollectionService:HasTag(v43, v45.MatchTag) then
            return v44
        end
    end
    return BackpackUiConfig.DefaultCategory
end

local function toVector2(v46) -- line 211
    return Vector2.new(v46.X, v46.Y)
end

local function pointIn(v47, v48, v49) -- line 215
    local v50 = v49 or 0
    local AbsolutePosition = v47.AbsolutePosition
    local AbsoluteSize = v47.AbsoluteSize
    local X = v48.X
    if AbsolutePosition.X - v50 <= X and v48.X <= AbsolutePosition.X + AbsoluteSize.X + v50 then
        local Y = v48.Y
        if AbsolutePosition.Y - v50 <= Y then
            return v48.Y <= AbsolutePosition.Y + AbsoluteSize.Y + v50
        end
    end
    return false
end

local function isLive(v51) -- line 224
    return v51.Frame.Parent ~= nil
end

local function iconCall(v52, ...) -- line 228 | captures: v33
    if v33 then
        local v53 = v33[v52]
        if type(v53) == "function" then
            pcall(v33[v52], v33, ...)
        end
    end
end

local function chatFocused() -- line 234 | captures: TextChatService
    local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
    if ChatInputBarConfiguration == nil then
        return false
    end
    return ChatInputBarConfiguration.IsFocused
end

local function guiActive() -- line 240 | captures: v4
    if v4 == nil then
        return false
    end
    return v4.Enabled
end

local function refreshLabels() -- line 248 | captures: Title, InventoryCapacity, v21, CollectionService, BackpackUiConfig, v12, v16
    local v54 = BackpackUiConfig.Categories[v21]
    if not v54 then
        return
    end
    if Title then
        Title.Text = v54.Title
    end
    if InventoryCapacity then
        InventoryCapacity.Visible = not v54.HideCount
        local v55 = 0
        for v56 in v16 do
            if CollectionService:HasTag(v56, v54.CountTag) then
                v55 += 1
            end
        end
        local InventoryCapacity_2 = InventoryCapacity
        if v54.Capacity then
            InventoryCapacity_2.Text = ("%*: %*/%*"):format(v54.CountLabel, v55, v54.Capacity)
        else
            InventoryCapacity_2.Text = ("%*: %*"):format(v54.CountLabel, v55)
        end
    end
    for v57, v58 in v12 do
        local v59 = v58:FindFirstChild(BackpackUiConfig.SelectedStrokeName)
        if v59 and v59:IsA("UIStroke") then
            v59.Enabled = v57 == v21
        end
    end
end

local function notifyChanged() -- line 276 | captures: v38, v37, refreshLabels
    if not v38 then
        v38 = true
        task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
            v38 = false
            refreshLabels()
            for v60, v61 in v37 do
                task.spawn(v61)
            end
        end)
    end
end

local function decorate(v62) -- line 294 | captures: v35
    if v35 then
        v35(v62.Tool, v62.Parts)
    end
end

local function updateEquipView(v63) -- line 300 | captures: v24, BackpackSlotVisuals
    local SetEquipped = BackpackSlotVisuals.SetEquipped
    local Parts = v63.Parts
    local Tool = v63.Tool
    local v64 = if Tool == nil or v24 == nil then false else Tool.Parent == v24
    SetEquipped(Parts, v64)
end

local function setLockedTints(v65) -- line 306 | captures: BackpackFeedback, BackpackSlotVisuals, v14
    for v66, v67 in v14 do
        local SetLockedTint = BackpackFeedback.SetLockedTint
        local Button = v67.Button
        local v68
        if v65 then
            local Tool = v67.Tool
            if Tool == nil then
                v68 = false
            else
                v68 = BackpackSlotVisuals.IsLocked(Tool)
            end
        else
            v68 = v65
        end
        SetLockedTint(Button, v68)
    end
end

local function setSwapMark(v69) -- line 312 | captures: v30, BackpackSlotVisuals, setLockedTints
    if v30 then
        BackpackSlotVisuals.SetSwapMark(v30.Parts, false)
    end
    v30 = v69
    if v69 then
        BackpackSlotVisuals.SetSwapMark(v69.Parts, true)
    end
    setLockedTints(v69 ~= nil)
end

local function disconnectTool(v70) -- line 323
    for v71, v72 in v70.ToolConns do
        v72:Disconnect()
    end
    table.clear(v70.ToolConns)
end

local function fill(v73, v74) -- line 330 | captures: v24, v35, v38, v39, BackpackAnimalInfo, BackpackSlotVisuals, v16, v37, refreshLabels
    local function v75(v76, ...)
        table.insert(v76, ...)
    end

    local function v77(v78, ...)
        table.insert(v78, ...)
    end

    local function v79(v80, ...)
        table.insert(v80, ...)
    end

    for v81, v82 in v73.ToolConns do
        v82:Disconnect()
    end
    table.clear(v73.ToolConns)
    v73.Tool = v74
    v16[v74] = v73
    BackpackSlotVisuals.Render(v73.Parts, v74)

    local function rerender() -- line 336 | captures: v73, v74, v38, BackpackAnimalInfo, BackpackSlotVisuals, v37, refreshLabels
        if v73.Tool ~= v74 then
            return
        end
        BackpackSlotVisuals.Render(v73.Parts, v74)
        BackpackAnimalInfo.Refresh(v74)
        if v38 then
            return
        end
        v38 = true
        task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
            v38 = false
            refreshLabels()
            for v83, v84 in v37 do
                task.spawn(v84)
            end
        end)
    end

    v75(v73.ToolConns, v74.Changed:Connect(function(v85) -- line 343 | captures: v73, v74, v38, BackpackAnimalInfo, BackpackSlotVisuals, v37, refreshLabels
        if v85 ~= "Name" and v85 ~= "TextureId" and v85 ~= "ToolTip" then
            return
        end
        if v73.Tool ~= v74 then
            return
        end
        BackpackSlotVisuals.Render(v73.Parts, v74)
        BackpackAnimalInfo.Refresh(v74)
        if v38 then
            return
        end
        v38 = true
        task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
            v38 = false
            refreshLabels()
            for v86, v87 in v37 do
                task.spawn(v87)
            end
        end)
    end))
    v77(v73.ToolConns, v74.AttributeChanged:Connect(rerender))
    if not v73.IsHotbar then
        v79(v73.ToolConns, v74.AttributeChanged:Connect(v39))
    end
    local SetEquipped = BackpackSlotVisuals.SetEquipped
    local Parts = v73.Parts
    local Tool = v73.Tool
    local v88 = if Tool == nil or v24 == nil then false else Tool.Parent == v24
    SetEquipped(Parts, v88)
    if v35 then
        v35(v73.Tool, v73.Parts)
    end
end

local function clear(v89) -- line 357 | captures: v24, v30, v35, BackpackAnimalInfo, BackpackFeedback, BackpackSlotVisuals, v14, v16
    local Tool = v89.Tool
    if not Tool then
        return
    end
    for v90, v91 in v89.ToolConns do
        v91:Disconnect()
    end
    table.clear(v89.ToolConns)
    if v16[Tool] == v89 then
        v16[Tool] = nil
    end
    v89.Tool = nil
    BackpackAnimalInfo.Hide(Tool)
    BackpackSlotVisuals.Render(v89.Parts, nil)
    local SetEquipped = BackpackSlotVisuals.SetEquipped
    local Parts = v89.Parts
    local Tool_2 = v89.Tool
    local v92 = if Tool_2 == nil or v24 == nil then false else Tool_2.Parent == v24
    SetEquipped(Parts, v92)
    if v30 == v89 then
        if v30 then
            BackpackSlotVisuals.SetSwapMark(v30.Parts, false)
        end
        v30 = nil
        for v93, v94 in v14 do
            BackpackFeedback.SetLockedTint(v94.Button, false)
        end
    end
    if v35 then
        v35(v89.Tool, v89.Parts)
    end
end

local function refreshHotbar() -- line 380 | captures: v20, v23, v14
    for v95, v96 in v14 do
        local Frame = v96.Frame
        if v96.Tool == nil then
            Frame.Visible = v20
        else
            Frame.Visible = true
        end
        if v96.Parts.Number then
            v96.Parts.Number.Visible = v23 and v96.Parts.Number.Text ~= ""
        end
    end
end

local v97 = {}

function v97.Rarity(v98) -- line 393 | captures: IndexConfig, BackpackSlotVisuals
    local v99 = BackpackSlotVisuals.RarityOf(v98)
    if not (v99 and table.find(IndexConfig.RarityOrder, v99)) then
        return 0
    end
    return (IndexConfig.RarityIndex(v99))
end

local function Kg(v100) -- line 397
    local WeightKg = v100:GetAttribute("WeightKg")
    if not (typeof(WeightKg) == "number" and WeightKg == WeightKg) then
        return 0
    end
    return WeightKg
end

v97.Kg = Kg

local v101 = {
    WeightKg = true,
    Rarity = true,
    AnimalName = true
}

local function refreshInventory() -- line 410 | captures: v21, BackpackUiConfig, BackpackSlotVisuals, v15, v22, categoryOf, v97
    local v102 = (BackpackUiConfig.Categories[v21] or {}).SortBy or {}
    local v103 = {}
    for v104, v105 in v15 do
        local Tool = v105.Tool
        local v106 = if Tool == nil then false else categoryOf(Tool) == v21
        local v107
        if v106 and Tool and #v22 > 0 then
            v107 = BackpackSlotVisuals.SearchHits(Tool, v22)
            v106 = v107 > 0
        else
            v107 = 0
        end
        v105.Frame.Visible = v106
        if v106 and Tool then
            local v108 = table.create(#v102)
            for v109, v110 in v102 do
                local v111 = v97[v110]
                if v111 then
                    v108[v109] = v111(Tool)
                else
                    v108[v109] = 0
                end
            end
            local v112 = { v105, v107, v108 }
            table.insert(v103, v112)
        end
    end
    table.sort(v103, function(v113, v114) -- line 434
        if v113[2] == v114[2] then
            local v115 = v113[3]
            local v116 = v114[3]
            local v117 = #v115
            for v118 = 1, v117 do
                if v115[v118] ~= v116[v118] then
                    local v119 = v115[v118]
                    return v116[v118] < v119
                end
            end
            return v113[1].Index < v114[1].Index
        end
        local v120 = v113[2]
        return v114[2] < v120
    end)
    for v121, v122 in v103 do
        v122[1].Frame.LayoutOrder = v121
    end
end

local function refreshAll() -- line 451 | captures: v38, v37, refreshLabels, refreshHotbar, refreshInventory
    refreshHotbar()
    refreshInventory()
    if not v38 then
        v38 = true
        task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
            v38 = false
            refreshLabels()
            for v123, v124 in v37 do
                task.spawn(v124)
            end
        end)
    end
end

local v125 = false

function v39(v126) -- line 459 | captures: v125, v101, refreshInventory
    if v101[v126] and not v125 then
        v125 = true
        task.defer(function() -- line 464 | captures: v125, refreshInventory
            v125 = false
            refreshInventory()
        end)
    end
end

local v127 = false

local function refreshAllSoon() -- line 475 | captures: v38, v127, v37, refreshLabels, refreshHotbar, refreshInventory
    if not v127 then
        v127 = true
        task.defer(function() -- line 480 | captures: v38, v127, v37, refreshLabels, refreshHotbar, refreshInventory
            v127 = false
            refreshHotbar()
            refreshInventory()
            if not v38 then
                v38 = true
                task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
                    v38 = false
                    refreshLabels()
                    for v128, v129 in v37 do
                        task.spawn(v129)
                    end
                end)
            end
        end)
    end
end

local v130, v131
local v132 = {}

local function pcSlotStroke(v133) -- line 499 | captures: StarterGui, BackpackUiConfig, v132
    local v134 = v132[v133]
    if v134 == nil then
        local v135 = StarterGui:FindFirstChild(BackpackUiConfig.GuiName)
        local v136
        if v135 then
            if v133 then
                local v137 = v135:FindFirstChild(BackpackUiConfig.HotbarName, true)
                local v138 = v137 and v137:FindFirstChild(BackpackUiConfig.TemplateName)
                v136 = v138 and v138:FindFirstChild(BackpackUiConfig.SelectedStrokeName)
            else
                local v139 = v135:FindFirstChild(BackpackUiConfig.InventoryName, true)
                local v140 = v139 and v139:FindFirstChild("ScrollingFrame")
                local v141 = v140 and v140:FindFirstChild(BackpackUiConfig.TemplateName)
                local v142 = v141 and v141:FindFirstChild("Container")
                v136 = v142 and v142:FindFirstChild(BackpackUiConfig.SelectedStrokeName)
            end
        end
        if not (v136 and v136:IsA("UIStroke")) then
            v136 = nil
        end
        v132[v133] = v136 or false
        return v136
    end
    return v134 or nil
end

local function newSlot(v143, v144, v145, v146) -- line 524 | captures: v9, v10, v20, v130, v131, BackpackUiConfig, BackpackAnimalInfo, BackpackHover, BackpackSlotVisuals, pcSlotStroke
    local v147 = BackpackSlotVisuals.Collect(v145, v146)
    if v9 then
        BackpackSlotVisuals.AdoptSellOverlay(v147, v9)
    end
    BackpackSlotVisuals.AdoptStrokes(v147, v10, (pcSlotStroke(v143)))
    BackpackSlotVisuals.SetSellSelected(v147, false)
    BackpackSlotVisuals.Render(v147, nil)
    BackpackSlotVisuals.AttachImageFX(v147)
    local InfoList = v146:FindFirstChild("InfoList")
    if InfoList and InfoList:IsA("GuiObject") then
        if v143 then
            InfoList.Visible = BackpackUiConfig.HotbarShowInfo
        else
            InfoList.Visible = BackpackUiConfig.InventoryShowInfo
        end
    end
    local v148 = {
        Tool = nil,
        IsHotbar = v143,
        Index = v144,
        Frame = v145,
        Button = v146,
        Parts = v147,
        ToolConns = {}
    }
    BackpackHover.Attach(v146)
    if not v143 then
        v146.MouseEnter:Connect(function() -- line 555 | captures: v148, v20, BackpackAnimalInfo
            if v20 then
                BackpackAnimalInfo.Show(v148.Tool)
            end
        end)
        v146.MouseLeave:Connect(function() -- line 560 | captures: v148, BackpackAnimalInfo
            BackpackAnimalInfo.Hide(v148.Tool)
        end)
    end
    v146.InputBegan:Connect(function(v149) -- line 564 | captures: v148, v130
        v130(v148, v149)
    end)
    v146.Activated:Connect(function(v150) -- line 567 | captures: v148, v131
        v131(v148, v150)
    end)
    return v148
end

local function makeHotbarSlot(v151) -- line 573 | captures: v5, v8, newSlot
    local v152 = v8:Clone()
    v152.Name = tostring(v151)
    v152.LayoutOrder = v151
    v152.Visible = false
    local v153 = newSlot(true, v151, v152, v152)
    local Number = v153.Parts.Number
    if Number then
        if v151 < 10 then
            Number.Text = tostring(v151)
        elseif v151 == 10 then
            Number.Text = "0"
        else
            Number.Text = ""
        end
    end
    v152.Parent = v5
    return v153
end

local function makeInventorySlot() -- line 596 | captures: v7, v9, v17, v15, newSlot
    v17 += 1
    local v154 = v9:Clone()
    v154.Name = "Slot"
    v154.LayoutOrder = v17
    v154.Visible = false
    local Container = v154:FindFirstChild("Container")
    local v155 = Container and Container:IsA("GuiButton")
    assert(v155, "[BackpackController] Inventory Template.Container must be a button")
    local v156 = newSlot(false, v17, v154, Container)
    v154.Parent = v7
    table.insert(v15, v156)
    return v156
end

local function deleteInventorySlot(v157) -- line 610 | captures: v30, BackpackFeedback, BackpackSlotVisuals, v14, v15, clear
    clear(v157)
    local v158 = table.find(v15, v157)
    if v158 then
        table.remove(v15, v158)
    end
    if v30 == v157 then
        if v30 then
            BackpackSlotVisuals.SetSwapMark(v30.Parts, false)
        end
        v30 = nil
        for v159, v160 in v14 do
            BackpackFeedback.SetLockedTint(v160.Button, false)
        end
    end
    v157.Frame:Destroy()
end

local function lowestEmptyHotbar() -- line 622 | captures: v14
    for v161, v162 in v14 do
        if not v162.Tool then
            return v162
        end
    end
    return nil
end

local function selectSlot(v163) -- line 635 | captures: v24, v25, v26, HellLoadout, LocalPlayer
    local Tool = v163.Tool
    if Tool then
        if Tool ~= nil and v24 ~= nil and Tool.Parent == v24 then
            if v25 then
                v25:UnequipTools()
            end
        elseif v26 and Tool.Parent == v26 and HellLoadout.CanEquip(LocalPlayer, Tool) and v25 and v25.Health > 0 then
            v25:EquipTool(Tool)
        end
    end
end

local function moveToInventory(v164) -- line 647 | captures: v24, v25, v38, BackpackSlotVisuals, v37, refreshLabels, fill, clear, refreshHotbar, refreshInventory, makeInventorySlot
    local Tool = v164.Tool
    if not v164.IsHotbar or not Tool or Tool ~= nil and BackpackSlotVisuals.IsLocked(Tool) then
        return
    end
    clear(v164)
    local v165 = makeInventorySlot()
    fill(v165, Tool)
    local v166 = if Tool == nil or v24 == nil then false else Tool.Parent == v24
    if v166 and v25 then
        v25:UnequipTools()
    end
    refreshHotbar()
    refreshInventory()
    if not v38 then
        v38 = true
        task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
            v38 = false
            refreshLabels()
            for v167, v168 in v37 do
                task.spawn(v168)
            end
        end)
    end
end

local function swap(v169, v170) -- line 663 | captures: v24, v25, v38, BackpackSlotVisuals, v37, refreshLabels, fill, clear, refreshHotbar, refreshInventory, deleteInventorySlot
    if v169 == v170 then
        return
    end
    local Tool = v169.Tool
    local Tool_2 = v170.Tool
    if Tool ~= nil and BackpackSlotVisuals.IsLocked(Tool) or Tool_2 ~= nil and BackpackSlotVisuals.IsLocked(Tool_2) then
        return
    end
    clear(v169)
    clear(v170)
    if Tool_2 then
        fill(v169, Tool_2)
    end
    if Tool then
        fill(v170, Tool)
    end
    for v171, v172 in { v169, v170 } do
        if not v172.IsHotbar then
            if v172.Tool then
                local Tool = v172.Tool
                if Tool ~= nil and v24 ~= nil and Tool.Parent == v24 and v25 then
                    v25:UnequipTools()
                end
            else
                deleteInventorySlot(v172)
            end
        end
    end
    refreshHotbar()
    refreshInventory()
    if not v38 then
        v38 = true
        task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
            v38 = false
            refreshLabels()
            for v173, v174 in v37 do
                task.spawn(v174)
            end
        end)
    end
end

local v175

local function onToolAdded(v176) -- line 697 | captures: v24, v25, v38, v127, v175, BackpackUiConfig, BackpackSlotVisuals, v14, v16, v37, refreshLabels, fill, clear, refreshHotbar, refreshInventory, makeInventorySlot
    if v176:IsA("Tool") then
        local v177 = v16[v176]
        if v177 then
            local SetEquipped = BackpackSlotVisuals.SetEquipped
            local Parts = v177.Parts
            local Tool = v177.Tool
            local v178 = if Tool == nil or v24 == nil then false else Tool.Parent == v24
            SetEquipped(Parts, v178)
            if not v38 then
                v38 = true
                task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
                    v38 = false
                    refreshLabels()
                    for v179, v180 in v37 do
                        task.spawn(v180)
                    end
                end)
            end
        else
            local v181 = BackpackUiConfig.RestoredGoToInventory and v176:GetAttribute(BackpackUiConfig.RestoredAttribute) == true
            if v176 ~= nil and BackpackSlotVisuals.IsLocked(v176) then
                local v182
                for v183, v184 in v14 do
                    local Tool = v184.Tool
                    if not (Tool ~= nil and BackpackSlotVisuals.IsLocked(Tool)) then
                        v182 = v184
                        break
                    end
                    v182 = nil
                end
                if v182 then
                    local Tool = v182.Tool
                    clear(v182)
                    fill(v182, v176)
                    if Tool then
                        local v185 = false
                        local v186
                        for v187, v188 in v14 do
                            if not v188.Tool then
                                v186 = v188
                                v185 = true
                                break
                            end
                        end
                        if not v185 then
                            v186 = nil
                        end
                        fill(v186 or makeInventorySlot(), Tool)
                    end
                else
                    fill(makeInventorySlot(), v176)
                end
                v175()
            else
                local v189
                if v181 then
                else
                    local v190 = false
                    for v191, v192 in v14 do
                        if not v192.Tool then
                            v189 = v192
                            v190 = true
                            break
                        end
                    end
                    if not v190 then
                        v189 = nil
                    end
                end
                fill(v189 or makeInventorySlot(), v176)
            end
            if not v127 then
                v127 = true
                task.defer(function() -- line 480 | captures: v38, v127, v37, refreshLabels, refreshHotbar, refreshInventory
                    v127 = false
                    refreshHotbar()
                    refreshInventory()
                    if not v38 then
                        v38 = true
                        task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
                            v38 = false
                            refreshLabels()
                            for v193, v194 in v37 do
                                task.spawn(v194)
                            end
                        end)
                    end
                end)
            end
        end
    elseif v176:IsA("Humanoid") and v176.Parent == v24 then
        v25 = v176
    end
end

local function lockRank(v195) -- line 750 | captures: PickaxeConfig
    if v195.Name == PickaxeConfig.ToolName then
        return 1
    end
    return 2
end

function v175() -- line 754 | captures: PickaxeConfig, BackpackSlotVisuals, v14, v16, fill, clear
    local v196 = {}
    for v197, v198 in v14 do
        local Tool = v198.Tool
        if Tool and Tool ~= nil and BackpackSlotVisuals.IsLocked(Tool) then
            table.insert(v196, Tool)
        end
    end
    table.sort(v196, function(v199, v200) -- line 762 | captures: PickaxeConfig
        local v201 = if v199.Name == PickaxeConfig.ToolName then 1 else 2
        local v202 = if v200.Name == PickaxeConfig.ToolName then 1 else 2
        return v201 < v202
    end)
    for v203, v204 in v196 do
        local v205 = v14[v203]
        local v206 = v16[v204]
        if v205 and v206 and v206 ~= v205 then
            local Tool = v205.Tool
            clear(v206)
            clear(v205)
            fill(v205, v204)
            if Tool then
                fill(v206, Tool)
            end
        end
    end
end

local function compactLocked() -- line 784 | captures: BackpackSlotVisuals, v14, fill, clear
    for v207, v208 in v14 do
        local Tool = v208.Tool
        if not (Tool ~= nil and BackpackSlotVisuals.IsLocked(Tool)) then
            local v209 = v207 + 1
            local v210 = #v14
            for v211 = v209, v210 do
                local v212 = v14[v211]
                local Tool = v212.Tool
                if Tool and Tool ~= nil and BackpackSlotVisuals.IsLocked(Tool) then
                    local Tool_2 = v208.Tool
                    clear(v212)
                    if Tool_2 then
                        clear(v208)
                    end
                    fill(v208, Tool)
                    if Tool_2 then
                        fill(v212, Tool_2)
                    end
                    break
                end
            end
        end
    end
end

local function onToolRemoved(v213) -- line 808 | captures: v24, v26, v38, v127, v175, BackpackSlotVisuals, v16, v37, refreshLabels, clear, refreshHotbar, refreshInventory, deleteInventorySlot, compactLocked
    if not v213:IsA("Tool") then
        return
    end
    local Parent = v213.Parent
    if not (Parent == nil or Parent ~= v24 and Parent ~= v26) then
        return
    end
    local v214 = v16[v213]
    if v214 then
        if v214.IsHotbar then
            clear(v214)
            if v213 ~= nil and BackpackSlotVisuals.IsLocked(v213) then
                compactLocked()
                v175()
            end
        else
            deleteInventorySlot(v214)
        end
        if not v127 then
            v127 = true
            task.defer(function() -- line 480 | captures: v38, v127, v37, refreshLabels, refreshHotbar, refreshInventory
                v127 = false
                refreshHotbar()
                refreshInventory()
                if not v38 then
                    v38 = true
                    task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
                        v38 = false
                        refreshLabels()
                        for v215, v216 in v37 do
                            task.spawn(v216)
                        end
                    end)
                end
            end)
        end
    end
end

local function pruneLostTools() -- line 834 | captures: v24, v26, v38, v127, v16, v37, refreshLabels, clear, refreshHotbar, refreshInventory, deleteInventorySlot
    local v217 = false
    for v218, v219 in v16 do
        local Parent = v218.Parent
        if Parent == nil or not (Parent == v24 or Parent == v26) then
            if v219.IsHotbar then
                clear(v219)
            else
                deleteInventorySlot(v219)
            end
            v217 = true
        end
    end
    if not v217 then
        return
    end
    if v127 then
        return
    end
    v127 = true
    task.defer(function() -- line 480 | captures: v38, v127, v37, refreshLabels, refreshHotbar, refreshInventory
        v127 = false
        refreshHotbar()
        refreshInventory()
        if not v38 then
            v38 = true
            task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
                v38 = false
                refreshLabels()
                for v220, v221 in v37 do
                    task.spawn(v221)
                end
            end)
        end
    end)
end

local function hookBackpack(v222) -- line 852 | captures: v26, v28, onToolAdded, onToolRemoved, pruneLostTools
    local function v223(v224, ...)
        table.insert(v224, ...)
    end

    local function v225(v226, ...)
        table.insert(v226, ...)
    end

    if v26 == v222 then
        return
    end
    for v227, v228 in v28 do
        v228:Disconnect()
    end
    table.clear(v28)
    v26 = v222
    v223(v28, v222.ChildAdded:Connect(onToolAdded))
    v225(v28, v222.ChildRemoved:Connect(onToolRemoved))
    pruneLostTools()
    for v229, v230 in v222:GetChildren() do
        onToolAdded(v230)
    end
end

local function hookCharacter(v231) -- line 869 | captures: v24, v25, v26, v29, v38, LocalPlayer, v14, v15, v27, v37, refreshLabels, clear, refreshHotbar, refreshInventory, deleteInventorySlot, onToolAdded, onToolRemoved, hookBackpack
    local function v232(v233, ...)
        table.insert(v233, ...)
    end

    local function v234(v235, ...)
        table.insert(v235, ...)
    end

    v29 += 1
    local v236 = v29
    for v237, v238 in v14 do
        clear(v238)
    end
    local v239 = #v15
    for v240 = v239, 1, -1 do
        deleteInventorySlot(v15[v240])
    end
    for v241, v242 in v27 do
        v242:Disconnect()
    end
    table.clear(v27)
    v24 = v231
    v25 = v231:FindFirstChildOfClass("Humanoid")
    v232(v27, v231.ChildAdded:Connect(onToolAdded))
    v234(v27, v231.ChildRemoved:Connect(onToolRemoved))
    for v243, v244 in v231:GetChildren() do
        onToolAdded(v244)
    end
    v26 = nil
    local v245 = LocalPlayer:FindFirstChildOfClass("Backpack") or LocalPlayer:WaitForChild("Backpack")
    if v236 ~= v29 then
        return
    end
    if v245 and v245:IsA("Backpack") then
        hookBackpack(v245)
    end
    refreshHotbar()
    refreshInventory()
    if not v38 then
        v38 = true
        task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
            v38 = false
            refreshLabels()
            for v246, v247 in v37 do
                task.spawn(v247)
            end
        end)
    end
end

local function canDrag(v248) -- line 910 | captures: v4, v20, v34, BackpackSlotVisuals
    local v249, v250
    if v34 then
        v250 = true
    elseif v248.Tool then
        if v4 == nil then
            v249 = false
        else
            v249 = v4.Enabled
        end
        v250 = false
    else
        v250 = true
    end
    if not v250 and v249 then
        local Tool = v248.Tool
        if not (Tool ~= nil and BackpackSlotVisuals.IsLocked(Tool)) then
            return v20
        end
    end
    return false
end

local v251 = Vector2.zero

local function measureGhostOrigin(v252) -- line 926 | captures: v251
    v252.Position = UDim2.fromOffset(0, 0)
    v251 = v252.AbsolutePosition + v252.AbsoluteSize / 2
end

local function moveGhost(v253, v254) -- line 932 | captures: v251
    v253.Position = UDim2.fromOffset(v254.X - v251.X, v254.Y - v251.Y)
end

local function beginDrag(v255, v256) -- line 936 | captures: v4, v7, v30, v251, BackpackFeedback, BackpackHover, BackpackSlotVisuals, v14, iconCall
    v255.dragging = true
    if v30 then
        BackpackSlotVisuals.SetSwapMark(v30.Parts, false)
    end
    v30 = nil
    for v257, v258 in v14 do
        BackpackFeedback.SetLockedTint(v258.Button, false)
    end
    local Button = v255.slot.Button
    local v259 = Button:Clone()
    v259.Name = "DragGhost"
    v259.AnchorPoint = Vector2.new(0.5, 0.5)
    v259.Size = UDim2.fromOffset(Button.AbsoluteSize.X, Button.AbsoluteSize.Y)
    v259.ZIndex = 100
    v259.Active = false
    v259.Selectable = false
    v259.Visible = true
    BackpackHover.Reset(v259)
    BackpackSlotVisuals.ResetCopy(v255.slot.Parts, v259)
    v259.Parent = v4
    v259.Position = UDim2.fromOffset(0, 0)
    v251 = v259.AbsolutePosition + v259.AbsoluteSize / 2
    v259.Position = UDim2.fromOffset(v256.X - v251.X, v256.Y - v251.Y)
    v255.ghost = v259
    if v7 then
        v7.ScrollingEnabled = false
    end
    for v260, v261 in v14 do
        local SetLockedTint = BackpackFeedback.SetLockedTint
        local Button = v261.Button
        local Tool = v261.Tool
        local v262
        if Tool == nil then
            v262 = false
        else
            v262 = BackpackSlotVisuals.IsLocked(Tool)
        end
        SetLockedTint(Button, v262)
    end
    iconCall("lock")
end

local function endDragVisuals(v263) -- line 961 | captures: v7, BackpackFeedback, v14, iconCall
    if v263.ghost then
        v263.ghost:Destroy()
        v263.ghost = nil
    end
    if v7 then
        v7.ScrollingEnabled = true
    end
    for v264, v265 in v14 do
        BackpackFeedback.SetLockedTint(v265.Button, false)
    end
    iconCall("unlock")
end

local function hotbarContains(v266) -- line 973 | captures: BackpackUiConfig, v14
    for v267, v268 in v14 do
        if v268.Frame.Visible then
            local Frame = v268.Frame
            local v269 = BackpackUiConfig.HotbarDropMargin or 0
            local AbsolutePosition = Frame.AbsolutePosition
            local AbsoluteSize = Frame.AbsoluteSize
            local X = v266.X
            local v270
            if AbsolutePosition.X - v269 <= X and v266.X <= AbsolutePosition.X + AbsoluteSize.X + v269 then
                local Y = v266.Y
                if AbsolutePosition.Y - v269 <= Y then
                    v270 = v266.Y <= AbsolutePosition.Y + AbsoluteSize.Y + v269
                else
                    v270 = false
                end
            else
                v270 = false
            end
            if v270 then
                return true
            end
        end
    end
    return false
end

local function closestHotbarSlot(v271) -- line 982 | captures: v14
    local v272
    local v273 = (1/0)
    for v274, v275 in v14 do
        if v275.Frame.Visible then
            local Magnitude = (v275.Frame.AbsolutePosition + v275.Frame.AbsoluteSize / 2 - v271).Magnitude
            if Magnitude < v273 then
                v272 = v275
                v273 = Magnitude
            end
        end
    end
    return v272
end

local function drop(v276, v277) -- line 998 | captures: v6, v20, BackpackFeedback, BackpackSlotVisuals, moveToInventory, swap, hotbarContains, closestHotbarSlot
    if v276.Tool and v276.Frame.Parent ~= nil then
        if v6 and v20 then
            local v278 = v6
            local AbsolutePosition = v278.AbsolutePosition
            local AbsoluteSize = v278.AbsoluteSize
            local X = v277.X
            local v279
            if AbsolutePosition.X - 0 <= X and v277.X <= AbsolutePosition.X + AbsoluteSize.X + 0 then
                local Y = v277.Y
                if AbsolutePosition.Y - 0 <= Y then
                    v279 = v277.Y <= AbsolutePosition.Y + AbsoluteSize.Y + 0
                else
                    v279 = false
                end
            else
                v279 = false
            end
            if v279 then
                if v276.IsHotbar then
                    moveToInventory(v276)
                end
                return
            end
        end
        if hotbarContains(v277) then
            local v280 = closestHotbarSlot(v277)
            local v281, v282
            if v280 then
                if v280 == v276 then
                    v282 = true
                else
                    local Tool = v280.Tool
                    if Tool == nil then
                        v281 = false
                    else
                        v281 = BackpackSlotVisuals.IsLocked(Tool)
                    end
                    v282 = false
                end
            else
                v282 = true
            end
            if not v282 then
                if v281 then
                    BackpackFeedback.Shake(v280.Button)
                else
                    swap(v276, v280)
                end
            end
        elseif v276.IsHotbar then
            moveToInventory(v276)
        end
    end
end

local function cancelPress() -- line 1020 | captures: v7, v32, BackpackFeedback, v14, iconCall
    local v283 = v32
    v32 = nil
    if not (v283 and v283.dragging) then
        return
    end
    if v283.ghost then
        v283.ghost:Destroy()
        v283.ghost = nil
    end
    if v7 then
        v7.ScrollingEnabled = true
    end
    for v284, v285 in v14 do
        BackpackFeedback.SetLockedTint(v285.Button, false)
    end
    iconCall("unlock")
end

local function clickSlot(v286) -- line 1033 | captures: v4, v24, v25, v26, v34, HellLoadout, LocalPlayer
    local Tool = v286.Tool
    if Tool and v4 ~= nil and v4.Enabled and not (v34 and v34(Tool)) then
        local Tool = v286.Tool
        if Tool then
            if Tool ~= nil and v24 ~= nil and Tool.Parent == v24 then
                if v25 then
                    v25:UnequipTools()
                end
            elseif v26 and Tool.Parent == v26 and HellLoadout.CanEquip(LocalPlayer, Tool) and v25 and v25.Health > 0 then
                v25:EquipTool(Tool)
            end
        end
    end
end

local function gamepadSendToHotbar(v287) -- line 1046 | captures: GuiService, BackpackFeedback, v14, swap
    local v288 = false
    local v289
    for v290, v291 in v14 do
        if not v291.Tool then
            v289 = v291
            v288 = true
            break
        end
    end
    if not v288 then
        v289 = nil
    end
    local v292, v293
    if v289 and v287.Tool then
        if v287.IsHotbar then
            v293 = true
        else
            swap(v287, v289)
            v292 = v289.Frame.Parent ~= nil
            v293 = false
        end
    else
        v293 = true
    end
    if not v293 then
        if v292 then
            GuiService.SelectedObject = v289.Button
        end
    else
        BackpackFeedback.Shake(v287.Button)
    end
end

local function gamepadPick(v294) -- line 1061 | captures: v30, v31, GuiService, UserInputService, BackpackUiConfig, GamepadConfig, BackpackFeedback, BackpackSlotVisuals, v14, setLockedTints, swap
    local v295 = v30
    if v295 then
        if v30 then
            BackpackSlotVisuals.SetSwapMark(v30.Parts, false)
        end
        v30 = nil
        for v296, v297 in v14 do
            BackpackFeedback.SetLockedTint(v297.Button, false)
        end
        if v295 == v294 then
            if not v294.IsHotbar and GamepadConfig.IsGamepadInput(UserInputService:GetLastInputType()) and os.clock() - v31 <= BackpackUiConfig.GamepadDoubleTapTime then
                local v298 = false
                local v299
                for v300, v301 in v14 do
                    if not v301.Tool then
                        v299 = v301
                        v298 = true
                        break
                    end
                end
                if not v298 then
                    v299 = nil
                end
                if v299 and v294.Tool and not v294.IsHotbar then
                    swap(v294, v299)
                    if v299.Frame.Parent ~= nil then
                        GuiService.SelectedObject = v299.Button
                    end
                else
                    BackpackFeedback.Shake(v294.Button)
                end
            end
        elseif v295.Frame.Parent ~= nil then
            local Tool = v294.Tool
            if Tool ~= nil and BackpackSlotVisuals.IsLocked(Tool) then
                BackpackFeedback.Shake(v294.Button)
            else
                swap(v295, v294)
                local SelectedObject = GuiService.SelectedObject
                if SelectedObject == nil or SelectedObject.Parent == nil then
                    local Button
                    if v294.Frame.Parent ~= nil then
                        Button = v294.Button
                    elseif v295.Frame.Parent ~= nil then
                        Button = v295.Button
                    end
                    GuiService.SelectedObject = Button
                end
            end
        end
    else
        local Tool = v294.Tool
        if Tool ~= nil and BackpackSlotVisuals.IsLocked(Tool) then
            BackpackFeedback.Shake(v294.Button)
        elseif v294.Tool then
            if v30 then
                BackpackSlotVisuals.SetSwapMark(v30.Parts, false)
            end
            v30 = v294
            if v294 then
                BackpackSlotVisuals.SetSwapMark(v294.Parts, true)
            end
            setLockedTints(v294 ~= nil)
            v31 = os.clock()
        end
    end
end

local function denyLockedDrag(v302) -- line 1101 | captures: v20, v34, BackpackFeedback, BackpackSlotVisuals
    local slot = v302.slot
    local v303, v304
    if v302.denied then
        v304 = true
    elseif v20 then
        if v34 then
            v304 = true
        else
            local Tool = slot.Tool
            if Tool == nil then
                v303 = false
            else
                v303 = BackpackSlotVisuals.IsLocked(Tool)
            end
            v304 = false
        end
    else
        v304 = true
    end
    if not v304 and v303 then
        v302.denied = true
        BackpackFeedback.Shake(slot.Button)
        return true
    end
    return false
end

function v130(v305, v306) -- line 1111 | captures: v4, v7, v20, v32, v34, BackpackUiConfig, BackpackFeedback, BackpackSlotVisuals, toVector2, beginDrag
    if not v32 and v306.UserInputState == Enum.UserInputState.Begin then
        local UserInputType = v306.UserInputType
        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
            local v307 = {
                dragging = false,
                scrolled = false,
                denied = false,
                hoverLocked = nil,
                ghost = nil,
                slot = v305,
                input = v306
            }
            local Position = v306.Position
            v307.start = Vector2.new(Position.X, Position.Y)
            local v308 = if UserInputType == Enum.UserInputType.Touch and not v305.IsHotbar and v7 then v7.CanvasPosition else nil
            v307.canvasStart = v308
            v32 = v307
            if UserInputType == Enum.UserInputType.Touch then
                task.delay(BackpackUiConfig.TouchHoldTime, function() -- line 1137 | captures: v305, v307, v4, v20, v32, v34, BackpackFeedback, BackpackSlotVisuals, toVector2, beginDrag
                    local v309, v310
                    if v32 == v307 then
                        if v307.dragging or v307.scrolled then
                            v310 = true
                        else
                            if v34 then
                                v309 = false
                            elseif v305.Tool then
                                if v4 == nil then
                                    v309 = false
                                elseif v4.Enabled then
                                    local Tool = v305.Tool
                                    if Tool == nil then
                                        v309 = v20
                                    elseif BackpackSlotVisuals.IsLocked(Tool) then
                                        v309 = false
                                    else
                                        v309 = v20
                                    end
                                else
                                    v309 = false
                                end
                            else
                                v309 = false
                            end
                            v310 = false
                        end
                    else
                        v310 = true
                    end
                    if v310 then
                        return
                    end
                    if v309 then
                        beginDrag(v307, toVector2(v307.input.Position))
                    else
                        local slot = v307.slot
                        local v311, v312
                        if v307.denied then
                            v312 = true
                        elseif v20 then
                            if v34 then
                                v312 = true
                            else
                                local Tool = slot.Tool
                                if Tool == nil then
                                    v311 = false
                                else
                                    v311 = BackpackSlotVisuals.IsLocked(Tool)
                                end
                                v312 = false
                            end
                        else
                            v312 = true
                        end
                        if not v312 and v311 then
                            v307.denied = true
                            BackpackFeedback.Shake(slot.Button)
                        end
                    end
                end)
            end
        end
    end
end

function v131(v313, v314) -- line 1149 | captures: v4, v20, v24, v25, v26, v34, HellLoadout, LocalPlayer, gamepadPick
    if v314 and (v314.UserInputType == Enum.UserInputType.MouseButton1 or v314.UserInputType == Enum.UserInputType.Touch) then
        return
    end
    if not (v4 ~= nil and v4.Enabled) then
        return
    end
    local Tool = v313.Tool
    if v34 and Tool and v34(Tool) then
        return
    end
    if v20 then
        gamepadPick(v313)
    elseif Tool then
        local Tool = v313.Tool
        local v315
        if Tool then
            if Tool == nil or v24 == nil then
                v315 = false
            else
                v315 = Tool.Parent == v24
            end
        else
            return
        end
        if v315 then
            if v25 then
                v25:UnequipTools()
            end
        elseif v26 and Tool.Parent == v26 and HellLoadout.CanEquip(LocalPlayer, Tool) and v25 and v25.Health > 0 then
            v25:EquipTool(Tool)
        end
    end
end

local function touchWouldScroll(v316, v317) -- line 1173 | captures: v7
    if not v316.IsHotbar and v7 and v7.ScrollingEnabled then
        local AbsoluteWindowSize = v7.AbsoluteWindowSize
        local AbsoluteCanvasSize = v7.AbsoluteCanvasSize
        local X = v317.X
        local v318 = math.abs(X)
        local Y = v317.Y
        if math.abs(Y) < v318 then
            local X = AbsoluteCanvasSize.X
            return AbsoluteWindowSize.X + 1 < X
        end
        local Y_2 = AbsoluteCanvasSize.Y
        return AbsoluteWindowSize.Y + 1 < Y_2
    end
    return false
end

local function touchMoved(v319, v320) -- line 1187 | captures: v4, v6, v7, v20, v34, BackpackUiConfig, BackpackFeedback, BackpackSlotVisuals, beginDrag
    if v319.denied then
        return
    end
    if v319.scrolled then
        if v6 then
            local v321 = v6
            local AbsolutePosition = v321.AbsolutePosition
            local AbsoluteSize = v321.AbsoluteSize
            local X = v320.X
            local v322
            if AbsolutePosition.X - 0 <= X and v320.X <= AbsolutePosition.X + AbsoluteSize.X + 0 then
                local Y = v320.Y
                if AbsolutePosition.Y - 0 <= Y then
                    v322 = v320.Y <= AbsolutePosition.Y + AbsoluteSize.Y + 0
                else
                    v322 = false
                end
            else
                v322 = false
            end
            if not v322 then
                local slot = v319.slot
                local v323
                if v34 then
                    v323 = false
                elseif slot.Tool then
                    if v4 == nil then
                        v323 = false
                    elseif v4.Enabled then
                        local Tool = slot.Tool
                        if Tool == nil then
                            v323 = v20
                        elseif BackpackSlotVisuals.IsLocked(Tool) then
                            v323 = false
                        else
                            v323 = v20
                        end
                    else
                        v323 = false
                    end
                else
                    v323 = false
                end
                if v323 then
                    if v7 and v319.canvasStart then
                        v7.CanvasPosition = v319.canvasStart
                    end
                    v319.scrolled = false
                    beginDrag(v319, v320)
                end
            end
        end
    else
        local v324 = v320 - v319.start
        if v324.Magnitude < BackpackUiConfig.TouchDragSlop then
            return
        end
        local v325
        if not v319.slot.IsHotbar and v7 and v7.ScrollingEnabled then
            local AbsoluteWindowSize = v7.AbsoluteWindowSize
            local AbsoluteCanvasSize = v7.AbsoluteCanvasSize
            local X = v324.X
            local v326 = math.abs(X)
            local Y = v324.Y
            if math.abs(Y) < v326 then
                local X = AbsoluteCanvasSize.X
                v325 = AbsoluteWindowSize.X + 1 < X
            else
                local Y = AbsoluteCanvasSize.Y
                v325 = AbsoluteWindowSize.Y + 1 < Y
            end
        else
            v325 = false
        end
        if v325 then
            v319.scrolled = true
        else
            local slot = v319.slot
            local v327
            if v34 then
                v327 = false
            elseif slot.Tool then
                if v4 == nil then
                    v327 = false
                elseif v4.Enabled then
                    local Tool = slot.Tool
                    local v328
                    if Tool == nil then
                        v328 = false
                    else
                        v328 = BackpackSlotVisuals.IsLocked(Tool)
                    end
                    v327 = not v328
                else
                    v327 = false
                end
            else
                v327 = false
            end
            if v327 and v20 then
                beginDrag(v319, v320)
            else
                local slot = v319.slot
                local v329
                if v319.denied then
                    v329 = false
                elseif v20 then
                    if v34 then
                        v329 = false
                    else
                        local Tool = slot.Tool
                        local v330
                        if Tool == nil then
                            v330 = false
                        else
                            v330 = BackpackSlotVisuals.IsLocked(Tool)
                        end
                        v329 = not not v330
                    end
                else
                    v329 = false
                end
                if v329 then
                    v319.denied = true
                    BackpackFeedback.Shake(slot.Button)
                else
                    v319.scrolled = true
                end
            end
        end
    end
end

local function onInputChanged(v331) -- line 1216 | captures: v4, v20, v32, v34, v251, BackpackUiConfig, BackpackFeedback, BackpackSlotVisuals, v14, beginDrag, touchMoved
    local v332 = v32
    if not v332 then
        return
    end
    local UserInputType = v332.input.UserInputType
    local v333 = if UserInputType == Enum.UserInputType.MouseButton1 then v331.UserInputType == Enum.UserInputType.MouseMovement else v331 == v332.input
    if not v333 then
        return
    end
    local Position = v331.Position
    local v334 = Vector2.new(Position.X, Position.Y)
    if v332.dragging then
        if v332.ghost then
            v332.ghost.Position = UDim2.fromOffset(v334.X - v251.X, v334.Y - v251.Y)
        end
        local v335
        for v336, v337 in v14 do
            if v337.Frame.Visible then
                local Tool = v337.Tool
                if Tool ~= nil and BackpackSlotVisuals.IsLocked(Tool) then
                    local Frame = v337.Frame
                    local AbsolutePosition = Frame.AbsolutePosition
                    local AbsoluteSize = Frame.AbsoluteSize
                    local X = v334.X
                    local v338
                    if AbsolutePosition.X - 0 <= X and v334.X <= AbsolutePosition.X + AbsoluteSize.X + 0 then
                        local Y = v334.Y
                        if AbsolutePosition.Y - 0 <= Y then
                            v338 = v334.Y <= AbsolutePosition.Y + AbsoluteSize.Y + 0
                        else
                            v338 = false
                        end
                    else
                        v338 = false
                    end
                    if v338 then
                        v335 = v337
                        break
                    end
                end
            end
            v335 = nil
        end
        if v335 ~= v332.hoverLocked then
            v332.hoverLocked = v335
            if v335 then
                BackpackFeedback.Shake(v335.Button)
            end
        end
    elseif UserInputType == Enum.UserInputType.Touch then
        touchMoved(v332, v334)
    elseif not ((v334 - v332.start).Magnitude < BackpackUiConfig.DragThreshold) then
        local slot = v332.slot
        local v339
        if v34 then
            v339 = false
        elseif slot.Tool then
            if v4 == nil then
                v339 = false
            elseif v4.Enabled then
                local Tool = slot.Tool
                local v340
                if Tool == nil then
                    v340 = false
                else
                    v340 = BackpackSlotVisuals.IsLocked(Tool)
                end
                v339 = not v340
            else
                v339 = false
            end
        else
            v339 = false
        end
        if v339 and v20 then
            beginDrag(v332, v334)
        else
            local slot = v332.slot
            local v341, v342
            if v332.denied then
                v342 = true
            elseif v20 then
                if v34 then
                    v342 = true
                else
                    local Tool = slot.Tool
                    if Tool == nil then
                        v341 = false
                    else
                        v341 = BackpackSlotVisuals.IsLocked(Tool)
                    end
                    v342 = false
                end
            else
                v342 = true
            end
            if not v342 and v341 then
                v332.denied = true
                BackpackFeedback.Shake(slot.Button)
            end
        end
    end
end

local function onInputEnded(v343) -- line 1265 | captures: v4, v7, v24, v25, v26, v32, v34, HellLoadout, BackpackFeedback, LocalPlayer, v14, iconCall, drop
    local v344 = v32
    if v344 then
        local v345 = if v344.input.UserInputType == Enum.UserInputType.MouseButton1 then v343.UserInputType == Enum.UserInputType.MouseButton1 else v343 == v344.input
        if v345 then
            v32 = nil
            local Position = v343.Position
            local v346 = Vector2.new(Position.X, Position.Y)
            if v344.dragging then
                if v344.ghost then
                    v344.ghost:Destroy()
                    v344.ghost = nil
                end
                if v7 then
                    v7.ScrollingEnabled = true
                end
                for v347, v348 in v14 do
                    BackpackFeedback.SetLockedTint(v348.Button, false)
                end
                iconCall("unlock")
                drop(v344.slot, v346)
            elseif not (v344.scrolled or v344.denied) and v344.slot.Frame.Parent ~= nil then
                local Button = v344.slot.Button
                local AbsolutePosition = Button.AbsolutePosition
                local AbsoluteSize = Button.AbsoluteSize
                local X = v346.X
                local v349
                if AbsolutePosition.X - 0 <= X and v346.X <= AbsolutePosition.X + AbsoluteSize.X + 0 then
                    local Y = v346.Y
                    if AbsolutePosition.Y - 0 <= Y then
                        v349 = v346.Y <= AbsolutePosition.Y + AbsoluteSize.Y + 0
                    else
                        v349 = false
                    end
                else
                    v349 = false
                end
                local slot, Tool, v350, v351
                if v349 then
                    slot = v344.slot
                    Tool = slot.Tool
                    if Tool then
                        if v4 == nil then
                            v350 = false
                        else
                            v350 = v4.Enabled
                        end
                        v351 = false
                    else
                        v351 = true
                    end
                else
                    v351 = true
                end
                if not v351 and v350 and not (v34 and v34(Tool)) then
                    local Tool = slot.Tool
                    local v352
                    if Tool then
                        if Tool == nil or v24 == nil then
                            v352 = false
                        else
                            v352 = Tool.Parent == v24
                        end
                    else
                        return
                    end
                    if v352 then
                        if v25 then
                            v25:UnequipTools()
                        end
                    elseif v26 and Tool.Parent == v26 and HellLoadout.CanEquip(LocalPlayer, Tool) and v25 and v25.Health > 0 then
                        v25:EquipTool(Tool)
                    end
                end
            end
        end
    end
end

local function applySearch(v353) -- line 1297 | captures: v7, v22, refreshInventory
    table.clear(v22)
    for v354 in string.gmatch(string.lower(v353), "%S+") do
        table.insert(v22, v354)
    end
    refreshInventory()
    if v7 then
        v7.CanvasPosition = Vector2.zero
    end
end

local function resetSearch() -- line 1308 | captures: v11, v22, applySearch
    if not v11 or v11.Text == "" then
        if #v22 > 0 then
            applySearch("")
        end
    else
        v11.Text = ""
    end
end

local function setCategory(v355) -- line 1316 | captures: v7, v21, v30, v38, BackpackUiConfig, BackpackFeedback, BackpackSlotVisuals, v14, v37, refreshLabels, refreshInventory
    local v356
    if BackpackUiConfig.Categories[v355] then
        if v355 == v21 then
            v356 = true
        else
            v21 = v355
            if v30 then
                BackpackSlotVisuals.SetSwapMark(v30.Parts, false)
            end
            v356 = false
        end
    else
        v356 = true
    end
    if v356 then
        return
    end
    v30 = nil
    for v357, v358 in v14 do
        BackpackFeedback.SetLockedTint(v358.Button, false)
    end
    refreshInventory()
    if v7 then
        v7.CanvasPosition = Vector2.zero
    end
    if not v38 then
        v38 = true
        task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
            v38 = false
            refreshLabels()
            for v359, v360 in v37 do
                task.spawn(v360)
            end
        end)
    end
end

local function clearSelectionInside() -- line 1333 | captures: v4, GuiService
    local SelectedObject = GuiService.SelectedObject
    if SelectedObject and v4 and SelectedObject:IsDescendantOf(v4) then
        GuiService.SelectedObject = nil
    end
end

local function onGamepadClose(v361, v362) -- line 1340 | captures: v30, BackpackFeedback, BackpackSlotVisuals, v1, v14
    if v362 == Enum.UserInputState.Begin then
        if v30 then
            BackpackSlotVisuals.SetSwapMark(v30.Parts, false)
            v30 = nil
            for v363, v364 in v14 do
                BackpackFeedback.SetLockedTint(v364.Button, false)
            end
        else
            v1.SetOpen(false)
        end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

local function onGamepadRemove(v365, v366) -- line 1352 | captures: GuiService, BackpackFeedback, BackpackSlotVisuals, v14, moveToInventory
    if v366 == Enum.UserInputState.Begin then
        local SelectedObject = GuiService.SelectedObject
        for v367, v368 in v14 do
            if v368.Button == SelectedObject and v368.Tool then
                local Tool = v368.Tool
                if Tool ~= nil and BackpackSlotVisuals.IsLocked(Tool) then
                    BackpackFeedback.Shake(v368.Button)
                else
                    moveToInventory(v368)
                end
                return Enum.ContextActionResult.Sink
            end
        end
    end
    return Enum.ContextActionResult.Pass
end

local function setOpenInternal(v369) -- line 1370 | captures: v4, v6, v7, v11, v19, v20, v30, v32, v33, v38, ContextActionService, GuiService, UserInputService, GamepadConfig, BackpackAnimalInfo, BackpackFeedback, BackpackSlotVisuals, v2, v14, v22, v36, v37, iconCall, refreshLabels, refreshHotbar, refreshInventory, applySearch, onGamepadClose, onGamepadRemove
    if v19 and v369 ~= v20 then
        if v369 and not (v4 ~= nil and v4.Enabled) then
            return
        end
        if not (v32 and v32.dragging) then
            local v370 = v32
            v32 = nil
            if v370 and v370.dragging then
                if v370.ghost then
                    v370.ghost:Destroy()
                    v370.ghost = nil
                end
                if v7 then
                    v7.ScrollingEnabled = true
                end
                for v371, v372 in v14 do
                    BackpackFeedback.SetLockedTint(v372.Button, false)
                end
                iconCall("unlock")
            end
            v20 = v369
            if v6 then
                v6.Visible = v369
            end
            if v369 then
                ContextActionService:BindActionAtPriority("BackpackCloseInventory", onGamepadClose, false, v2, Enum.KeyCode.ButtonB)
                ContextActionService:BindActionAtPriority("BackpackRemoveSlot", onGamepadRemove, false, v2, Enum.KeyCode.ButtonX)
            else
                ContextActionService:UnbindAction("BackpackCloseInventory")
                ContextActionService:UnbindAction("BackpackRemoveSlot")
                if v30 then
                    BackpackSlotVisuals.SetSwapMark(v30.Parts, false)
                end
                v30 = nil
                for v373, v374 in v14 do
                    BackpackFeedback.SetLockedTint(v374.Button, false)
                end
                if not v11 or v11.Text == "" then
                    if #v22 > 0 then
                        applySearch("")
                    end
                else
                    v11.Text = ""
                end
                local SelectedObject = GuiService.SelectedObject
                if SelectedObject and v4 and SelectedObject:IsDescendantOf(v4) then
                    GuiService.SelectedObject = nil
                end
                BackpackAnimalInfo.Hide()
            end
            refreshHotbar()
            refreshInventory()
            if not v38 then
                v38 = true
                task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
                    v38 = false
                    refreshLabels()
                    for v375, v376 in v37 do
                        task.spawn(v376)
                    end
                end)
            end
            if v369 and GamepadConfig.IsGamepadInput(UserInputService:GetLastInputType()) then
                for v377, v378 in v14 do
                    if v378.Frame.Visible then
                        GuiService.SelectedObject = v378.Button
                        break
                    end
                end
            end
            local iconCall_2, v379, v380
            if v33 then
                if v33.isSelected == v369 then
                    v380 = true
                else
                    iconCall_2 = iconCall
                    if v369 then
                        v379 = "select"
                    else
                        v379 = "deselect"
                    end
                    v380 = false
                end
            else
                v380 = true
            end
            if not v380 then
                iconCall_2(v379)
            end
            for v381, v382 in v36 do
                task.spawn(v382, v369)
            end
        end
    end
end

local function refreshIconEnabled() -- line 1418 | captures: v4, GuiService, iconCall
    local v383 = if v4 == nil then false else v4.Enabled
    iconCall("setEnabled", v383 and not GuiService.MenuIsOpen)
end

local function refreshNumbers() -- line 1426 | captures: v23, UserInputService, GamepadConfig, v3, refreshHotbar
    local v384 = UserInputService:GetLastInputType()
    local v385 = if v384 == Enum.UserInputType.Keyboard then true else v3[v384] == true
    local v386
    if v384 == Enum.UserInputType.Touch then
        v386 = true
    else
        v386 = GamepadConfig.IsGamepadInput(v384)
    end
    if v385 then
        v23 = true
    elseif v386 then
        v23 = false
    end
    refreshHotbar()
end

local function onInputBegan(v387, v388) -- line 1438 | captures: v4, v11, v20, v24, v25, v26, v32, v33, GuiService, TextChatService, UserInputService, BackpackUiConfig, HellLoadout, BackpackSlotVisuals, v1, LocalPlayer, v14, v18, v22, applySearch
    if v387.UserInputType == Enum.UserInputType.Keyboard then
        if v387.KeyCode ~= Enum.KeyCode.Escape or not v388 then
            local v389, v390
            if v4 ~= nil and v4.Enabled then
                if GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() then
                    v390 = true
                else
                    local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
                    if ChatInputBarConfiguration == nil then
                        v389 = false
                    else
                        v389 = ChatInputBarConfiguration.IsFocused
                    end
                    v390 = false
                end
            else
                v390 = true
            end
            if not v390 and not v389 then
                local v391 = v18[v387.KeyCode.Value]
                local v392 = false
                local v393 = false
                local v394 = false
                local v395 = false
                local v396 = false
                local v397 = false
                if v391 then
                    v392 = true
                else
                    v397 = true
                end
                local v398
                if v392 then
                    v398 = v14[v391]
                    if v398 then
                        v393 = true
                    else
                        v397 = false
                    end
                end
                v392 = false
                if v393 then
                    if v398.Tool then
                        v392 = true
                    else
                        v397 = false
                    end
                end
                v393 = false
                local Tool
                if v392 then
                    Tool = v398.Tool
                    if Tool then
                        v393 = true
                    else
                        v394 = true
                    end
                end
                v392 = false
                local v399
                if v393 then
                    if Tool == nil then
                        v399 = false
                        v395 = true
                    else
                        v392 = true
                    end
                end
                v393 = false
                if v392 then
                    if v24 == nil then
                        v399 = false
                        v395 = true
                    else
                        v393 = true
                    end
                end
                v392 = false
                if v393 then
                    if Tool.Parent == v24 then
                        v396 = true
                    else
                        v392 = true
                    end
                end
                if v392 then
                    v399 = false
                    v395 = true
                end
                v392 = false
                if v396 then
                    v399 = true
                    v395 = true
                end
                v396 = false
                if v395 then
                    if v399 then
                        v392 = true
                    else
                        v396 = true
                    end
                end
                v395 = false
                if v396 then
                    if v26 then
                        v395 = true
                    else
                        v394 = true
                    end
                end
                v396 = false
                if v395 then
                    if Tool.Parent == v26 then
                        v396 = true
                    else
                        v394 = true
                    end
                end
                v395 = false
                if v396 then
                    if HellLoadout.CanEquip(LocalPlayer, Tool) then
                        v395 = true
                    else
                        v394 = true
                    end
                end
                v396 = false
                if v395 then
                    if v25 then
                        v396 = true
                    else
                        v394 = true
                    end
                end
                v395 = false
                if v396 then
                    if v25.Health > 0 then
                        v395 = true
                    else
                        v394 = true
                    end
                end
                if v395 then
                    v25:EquipTool(Tool)
                    v394 = true
                end
                v395 = false
                if v392 then
                    if v25 then
                        v395 = true
                    else
                        v394 = true
                    end
                end
                if v395 then
                    v25:UnequipTools()
                    v394 = true
                end
                if v394 then
                    BackpackSlotVisuals.Pulse(v398.Parts)
                    v397 = false
                end
                if v397 and v387.KeyCode == BackpackUiConfig.ToggleKey and not v33 then
                    v1.SetOpen(not v20)
                end
            end
        elseif not v11 or v11.Text == "" then
            if #v22 > 0 then
                applySearch("")
            end
        else
            v11.Text = ""
        end
    else
        local v400
        if v388 then
            v400 = true
        elseif v20 then
            if v32 then
                v400 = true
            else
                local UserInputType = v387.UserInputType
                if UserInputType == Enum.UserInputType.MouseButton1 then
                    v400 = false
                else
                    v400 = UserInputType ~= Enum.UserInputType.Touch
                end
            end
        else
            v400 = true
        end
        if not v400 then
            v1.SetOpen(false)
        end
    end
end

local function findTopbarPlus() -- line 1478 | captures: ReplicatedStorage, BackpackUiConfig
    local v401 = ReplicatedStorage
    for v402, v403 in BackpackUiConfig.TopbarPlusPath do
        v401 = v401 and v401:FindFirstChild(v403)
    end
    if not (v401 and v401:IsA("ModuleScript")) then
        return nil
    end
    return v401
end

local function createIcon() -- line 1489 | captures: v20, v33, BackpackUiConfig, iconCall, setOpenInternal, findTopbarPlus
    local v404 = findTopbarPlus()
    if v404 then
        local v405, v406 = pcall(function() -- line 1495 | captures: v404, BackpackUiConfig
            local v407 = require(v404)
            local Icon = BackpackUiConfig.Icon
            return v407.new():setName(Icon.Name):setImage(Icon.ImageOpen, "Selected"):setImage(Icon.ImageClosed, "Deselected"):setImageScale(1):setCaption(Icon.Caption):bindToggleKey(BackpackUiConfig.ToggleKey):autoDeselect(false):setOrder(Icon.Order)
        end)
        if v405 then
            v33 = v406
            v33.toggled:Connect(function(v408) -- line 1513 | captures: v20, v33, iconCall, setOpenInternal
                setOpenInternal(v408)
                if v408 ~= v20 then
                    task.defer(function() -- line 1517 | captures: v20, v33, iconCall
                        if v33.isSelected ~= v20 then
                            local v409 = if v20 then "select" else "deselect"
                            iconCall(v409)
                        end
                    end)
                end
            end)
        else
            warn((("[BackpackController] couldn't create the topbar icon: %*"):format(v406)))
        end
    else
        warn("[BackpackController] TopbarPlus not found \226\128\148 inventory opens with the toggle key only")
    end
end

local function waitForDescendant(v410, v411, v412) -- line 1532
    local v413 = os.clock() + v412
    local v414 = v410:FindFirstChild(v411, true)
    while not v414 do
        if os.clock() < v413 then
            task.wait(0.1)
            v414 = v410:FindFirstChild(v411, true)
            continue
        end
        break
    end
    return v414
end

local function findUi(v415) -- line 1542 | captures: v4, v5, v6, v7, v8, v9, v10, v11, Title, InventoryCapacity, v21, v30, v38, BackpackUiConfig, FloatingIconConfig, BackpackAnimalInfo, BackpackFeedback, BackpackHover, BackpackSlotVisuals, FloatingIconFX, v12, v14, v37, refreshLabels, refreshInventory, applySearch, waitForDescendant
    local v416 = waitForDescendant(v415, BackpackUiConfig.HotbarName, 30)
    local v417 = waitForDescendant(v415, BackpackUiConfig.InventoryName, 30)
    if v416 and v417 and v416:IsA("GuiObject") and v417:IsA("GuiObject") then
        local v418 = v416:WaitForChild(BackpackUiConfig.TemplateName, 30)
        local v419 = v417:WaitForChild("ScrollingFrame", 30)
        local v420 = v419 and v419:WaitForChild(BackpackUiConfig.TemplateName, 30)
        if not (v418 and v418:IsA("GuiButton")) then
            warn("[BackpackController] BottomHUD.Template (TextButton) not found")
        else
            if v419 and v419:IsA("ScrollingFrame") and v420 and v420:IsA("GuiObject") then
                v4 = v415
                v5 = v416
                v6 = v417
                v7 = v419
                v8 = v418
                v9 = v420
                for v421, v422 in { v416, v419 } do
                    for v423, v424 in v422:GetChildren() do
                        if v424.Name == BackpackUiConfig.TemplateName and v424:IsA("GuiObject") then
                            v424.Visible = false
                        end
                    end
                end
                for v425, v426 in v419:GetChildren() do
                    if v426:IsA("UIPadding") then
                        v426:Destroy()
                    end
                end
                local SideBarList = v417:FindFirstChild("SideBarList")
                for v427, v428 in BackpackUiConfig.Categories do
                    local v429 = SideBarList and SideBarList:FindFirstChild(v428.Button)
                    if v429 and v429:IsA("GuiButton") then
                        v12[v427] = v429
                        BackpackHover.Attach(v429)
                        local Icon = v429:FindFirstChild("Icon")
                        if Icon and Icon:IsA("GuiObject") then
                            FloatingIconFX.Attach(Icon, FloatingIconConfig.Styles.AnimalTile, v429)
                        end
                        local Activated = v429.Activated
                        local v430 = v427
                        Activated:Connect(function() -- line 1598 | captures: v430, v7, v21, v30, v38, BackpackUiConfig, BackpackFeedback, BackpackSlotVisuals, v14, v37, refreshLabels, refreshInventory
                            if not BackpackUiConfig.Categories[v430] then
                                return
                            end
                            if v430 == v21 then
                                return
                            end
                            v21 = v430
                            if v30 then
                                BackpackSlotVisuals.SetSwapMark(v30.Parts, false)
                            end
                            v30 = nil
                            for v431, v432 in v14 do
                                BackpackFeedback.SetLockedTint(v432.Button, false)
                            end
                            refreshInventory()
                            if v7 then
                                v7.CanvasPosition = Vector2.zero
                            end
                            if v38 then
                                return
                            end
                            v38 = true
                            task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
                                v38 = false
                                refreshLabels()
                                for v433, v434 in v37 do
                                    task.spawn(v434)
                                end
                            end)
                        end)
                        local v435 = v429:FindFirstChild(BackpackUiConfig.SelectedStrokeName)
                        if not v10 and v435 and v435:IsA("UIStroke") then
                            v10 = v435
                        end
                    end
                end
                local Title_2 = v417:FindFirstChild("Title")
                if not (Title_2 and Title_2:IsA("TextLabel")) then
                    Title_2 = nil
                end
                Title = Title_2
                local InventoryCapacity_2 = v417:FindFirstChild("InventoryCapacity")
                if not (InventoryCapacity_2 and InventoryCapacity_2:IsA("TextLabel")) then
                    InventoryCapacity_2 = nil
                end
                InventoryCapacity = InventoryCapacity_2
                local Search = v417:FindFirstChild("Search")
                local v436 = Search and Search:FindFirstChildWhichIsA("TextBox")
                if v436 then
                    v11 = v436
                    v436.ClearTextOnFocus = false
                    v436.Text = ""
                    v436:GetPropertyChangedSignal("Text"):Connect(function() -- line 1619 | captures: v436, applySearch
                        applySearch(v436.Text)
                    end)
                end
                BackpackAnimalInfo.Init(v415)
                v417.Active = true
                local CashSellValue = v417:FindFirstChild("CashSellValue")
                if CashSellValue and CashSellValue:IsA("GuiObject") then
                    CashSellValue.Active = true
                end
                v417.Visible = false
                return true
            end
            warn("[BackpackController] Inventory.ScrollingFrame.Template not found")
        end
        return false
    end
    warn("[BackpackController] Scatchel UI is missing BottomHUD / Inventory")
    return false
end

local function buildHotbar() -- line 1636 | captures: v13, BackpackUiConfig, BackpackGui, v14, v18, makeHotbarSlot
    if BackpackGui.IsMobile() then
        v13 = BackpackUiConfig.HotbarSlotsMini
    else
        v13 = BackpackUiConfig.HotbarSlotsFull
    end
    local v437 = v13
    for v438 = 1, v437 do
        v14[v438] = makeHotbarSlot(v438)
        if v438 < 10 then
            v18[Enum.KeyCode.Zero.Value + v438] = v438
        elseif v438 == 10 then
            v18[Enum.KeyCode.Zero.Value] = v438
        end
    end
end

function v1.IsOpen() -- line 1655 | captures: v20
    return v20
end

function v1.SetOpen(v439) -- line 1659 | captures: setOpenInternal
    setOpenInternal(v439)
end

function v1.Toggle() -- line 1663 | captures: v20, setOpenInternal
    setOpenInternal(not v20)
end

function v1.ObserveOpen(v440) -- line 1668 | captures: v36
    table.insert(v36, v440)
end

function v1.ObserveChanged(v441) -- line 1673 | captures: v37
    table.insert(v37, v441)
end

function v1.SetClickInterceptor(v442) -- line 1679 | captures: v7, v30, v32, v34, BackpackFeedback, BackpackSlotVisuals, v14, iconCall
    v34 = v442
    if not v442 then
        return
    end
    local v443 = v32
    v32 = nil
    if v443 and v443.dragging then
        if v443.ghost then
            v443.ghost:Destroy()
            v443.ghost = nil
        end
        if v7 then
            v7.ScrollingEnabled = true
        end
        for v444, v445 in v14 do
            BackpackFeedback.SetLockedTint(v445.Button, false)
        end
        iconCall("unlock")
    end
    if v30 then
        BackpackSlotVisuals.SetSwapMark(v30.Parts, false)
    end
    v30 = nil
    for v446, v447 in v14 do
        BackpackFeedback.SetLockedTint(v447.Button, false)
    end
end

function v1.SetSlotDecorator(v448) -- line 1688 | captures: v35, v1
    v35 = v448
    v1.RefreshDecorations()
end

function v1.RefreshDecorations() -- line 1693 | captures: v35, v14, v15
    for v449, v450 in v14 do
        if v35 then
            v35(v450.Tool, v450.Parts)
        end
    end
    for v451, v452 in v15 do
        if v35 then
            v35(v452.Tool, v452.Parts)
        end
    end
end

function v1.UnequipIfHeld(v453) -- line 1703 | captures: v24, v25
    if v453 ~= nil and v24 ~= nil and v453.Parent == v24 and v25 then
        v25:UnequipTools()
    end
end

function v1.HasTool(v454) -- line 1710 | captures: v16
    return v16[v454] ~= nil
end

function v1.GetHotbarTools() -- line 1715 | captures: v14
    local v455 = {}
    for v456, v457 in v14 do
        if v457.Tool then
            local Tool = v457.Tool
            table.insert(v455, Tool)
        end
    end
    return v455
end

function v1.FindHotbarSlot(v458, v459) -- line 1727 | captures: v4, v14
    local v460 = #v14
    local v461, v462
    if v459 then
        v461 = #v14
        v460 = 1
        v462 = -1
    else
        v461 = 1
        v462 = 1
    end
    for v463 = v461, v460, v462 do
        local v464 = v14[v463]
        if v464.Tool and v464.Frame.Visible then
            local v465 = if v4 == nil then false else v4.Enabled
            if v465 and v458(v464.Tool) then
                return v464.Button
            end
        end
    end
    return nil
end

function v1.IsReady() -- line 1741 | captures: v19
    return v19
end

function v1.GetInventoryFrame() -- line 1745 | captures: v6
    return v6
end

function v1.GetHotbarFrame() -- line 1750 | captures: v5
    return v5
end

function v1.Start() -- line 1754 | captures: v4, v7, v19, v24, v32, v38, GuiService, StarterGui, UserInputService, BackpackFeedback, BackpackGui, LocalPlayer, v14, v37, iconCall, refreshLabels, refreshHotbar, refreshInventory, hookBackpack, hookCharacter, cancelPress, onInputChanged, onInputEnded, setOpenInternal, refreshIconEnabled, refreshNumbers, onInputBegan, createIcon, findUi, buildHotbar
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local v466 = BackpackGui.UnusedName()

    local function dropUnused(v467) -- line 1762 | captures: v466
        if v467.Name == v466 and v467:IsA("ScreenGui") then
            v467:Destroy()
        end
    end

    for v468, v469 in PlayerGui:GetChildren() do
        if v469.Name == v466 and v469:IsA("ScreenGui") then
            v469:Destroy()
        end
    end
    PlayerGui.ChildAdded:Connect(dropUnused)
    local v470 = PlayerGui:WaitForChild(BackpackGui.Name())
    if not v470:IsA("ScreenGui") then
        return
    end
    v470.ResetOnSpawn = false
    v470.Enabled = true
    if not findUi(v470) then
        return
    end
    pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Backpack, false)
    buildHotbar()
    v19 = true
    createIcon()
    local v471 = if v4 == nil then false else v4.Enabled
    iconCall("setEnabled", v471 and not GuiService.MenuIsOpen)
    v470:GetPropertyChangedSignal("Enabled"):Connect(function() -- line 1797 | captures: v470, v4, v7, v32, GuiService, BackpackFeedback, v14, iconCall, setOpenInternal
        if not v470.Enabled then
            local v472 = v32
            v32 = nil
            if v472 and v472.dragging then
                if v472.ghost then
                    v472.ghost:Destroy()
                    v472.ghost = nil
                end
                if v7 then
                    v7.ScrollingEnabled = true
                end
                for v473, v474 in v14 do
                    BackpackFeedback.SetLockedTint(v474.Button, false)
                end
                iconCall("unlock")
            end
            setOpenInternal(false)
        end
        local v475 = if v4 == nil then false else v4.Enabled
        iconCall("setEnabled", v475 and not GuiService.MenuIsOpen)
    end)
    GuiService.MenuOpened:Connect(refreshIconEnabled)
    GuiService.MenuClosed:Connect(refreshIconEnabled)
    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
    UserInputService.InputEnded:Connect(onInputEnded)
    UserInputService.WindowFocusReleased:Connect(cancelPress)
    UserInputService.LastInputTypeChanged:Connect(refreshNumbers)
    refreshNumbers()
    LocalPlayer.ChildAdded:Connect(function(v476) -- line 1814 | captures: v24, hookBackpack
        if v476:IsA("Backpack") and v24 then
            hookBackpack(v476)
        end
    end)
    LocalPlayer.CharacterAdded:Connect(hookCharacter)
    if LocalPlayer.Character then
        task.spawn(hookCharacter, LocalPlayer.Character)
    end
    refreshHotbar()
    refreshInventory()
    if not v38 then
        v38 = true
        task.defer(function() -- line 281 | captures: v38, v37, refreshLabels
            v38 = false
            refreshLabels()
            for v477, v478 in v37 do
                task.spawn(v478)
            end
        end)
    end
end

return v1
