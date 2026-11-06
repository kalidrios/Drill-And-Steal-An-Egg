-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AnimalEggsConfig = require(ReplicatedStorage.Shared.AnimalEggsConfig)
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local CountingNumber = require(ReplicatedStorage.Shared.CountingNumber)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local FloatingIconConfig = require(ReplicatedStorage.Shared.FloatingIconConfig)
local IndexConfig = require(ReplicatedStorage.Shared.IndexConfig)
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local MutationConfig = require(ReplicatedStorage.Shared.MutationConfig)
local RarityNameGradient = require(ReplicatedStorage.Shared.RarityNameGradient)
local WeightTag = require(ReplicatedStorage.Shared.WeightTag)
local OwnBase = require(script.Parent.OwnBase)
local MergeSfx = require(script.Parent.MergeSfx)
local MergeRevealFX = require(script.Parent.MergeRevealFX)
local MergeOutcomeDisplay = require(script.Parent.MergeOutcomeDisplay)
local NewItemController = require(script.Parent.NewItemController)
local UiFrames = require(script.Parent.UiFrames)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local FloatingIconFX = require(script.Parent.Parent.Modules.FloatingIconFX)
local AnimalTileStyle = require(script.Parent.Parent.Modules.AnimalTileStyle)
local v1 = {}
local v2 = {
    {
        Name = "Tube_Left",
        Filled = "rbxassetid://122487515029734",
        Unfilled = "rbxassetid://128802052415346"
    },
    {
        Name = "Tube_Center",
        Filled = "rbxassetid://92798397627127",
        Unfilled = "rbxassetid://78926622205969"
    },
    {
        Name = "Tube_Right",
        Filled = "rbxassetid://136895246004208",
        Unfilled = "rbxassetid://76086504409503"
    }
}
local LocalPlayer = Players.LocalPlayer
local v3 = {}
local v4 = {}
local v5, v6, AnimalFusion, AnimalList, v7, None, v8
local v9 = {}
local v10 = {}
local v11, v12
local v13 = 0
local v14 = 0

local function drawWeight(v15) -- line 131 | captures: v12, v14, WeightTag
    local v16 = v12
    if v16 and v16.Parent then
        v14 = v15
        v16.Text = ("%*KG"):format((WeightTag.FormatKg(v15)))
    end
end

local v17
local v18 = UDim2.fromScale(0.5, 0.5)
local v19
local v20 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function fillBarPositionFor(v21, v22) -- line 156 | captures: v18
    local v23 = 1 - v22 / 3
    return UDim2.new(v18.X.Scale, v18.X.Offset, v23 + v21.AnchorPoint.Y * v21.Size.Y.Scale, 0)
end

local v24 = 0
local v25 = 0
local v26 = 0
local v27 = 0
local v28 = 0
local v29 = false
local v30 = 0

local function setFillLevel(v31) -- line 179 | captures: v17, v18, v24, MergeOutcomeDisplay
    v24 = v31
    MergeOutcomeDisplay.SetLevel(v31 / 3)
    local v32 = v17
    if v32 and v32.Parent then
        local v33 = 1 - v31 / 3
        v32.Position = UDim2.new(v18.X.Scale, v18.X.Offset, v33 + v32.AnchorPoint.Y * v32.Size.Y.Scale, 0)
    end
end

local function stepFill(v34) -- line 189 | captures: v17, v18, v24, v25, v26, v27, v28, v29, MergeOutcomeDisplay
    if not v29 then
        return
    end
    local v35 = v28 - v27
    local v36
    if v35 == 0 then
        v36 = 1
    else
        local v37 = (v34 - v27) / v35
        v36 = math.clamp(v37, 0, 1)
    end
    local v38 = v25 + (v26 - v25) * v36
    v24 = v38
    MergeOutcomeDisplay.SetLevel(v38 / 3)
    local v39 = v17
    if v39 and v39.Parent then
        local v40 = 1 - v38 / 3
        v39.Position = UDim2.new(v18.X.Scale, v18.X.Offset, v40 + v39.AnchorPoint.Y * v39.Size.Y.Scale, 0)
    end
    if v36 >= 1 then
        v29 = false
    end
end

local v41 = CountingNumber.new(function(v42) -- line 201 | captures: v12, v13, v14, WeightTag
    local v43 = v42 - v13
    local v44 = if math.abs(v43) <= 0.5 then v13 else v42
    local v45 = v12
    if v45 and v45.Parent then
        v14 = v44
        v45.Text = ("%*KG"):format((WeightTag.FormatKg(v44)))
    end
end, stepFill)

local function setAnimalImage(v46, v47, v48) -- line 216 | captures: AnimalTileStyle
    local v49 = v48 and v48:GetAttribute("Variant")
    local SetRender = AnimalTileStyle.SetRender
    if typeof(v49) ~= "string" then
        v49 = nil
    end
    SetRender(v46, v47, v49)
end

local function placedFolder() -- line 227 | captures: OwnBase
    local v50 = OwnBase.Get()
    return v50 and v50:FindFirstChild("PlacedAnimals")
end

local function candidateOwned(v51) -- line 235 | captures: OwnBase, LocalPlayer
    if v51:IsA("Tool") then
        local Backpack = LocalPlayer:FindFirstChild("Backpack")
        local Character = LocalPlayer.Character
        local v52 = Backpack == nil
        local v53
        if not v52 then
            v53 = v51:IsDescendantOf(Backpack)
        end
        if v52 or not v53 then
            if Character == nil then
                v53 = false
            else
                v53 = v51:IsDescendantOf(Character)
            end
        end
        return v53
    end
    local v54 = OwnBase.Get()
    local v55 = v54 and v54:FindFirstChild("PlacedAnimals")
    if v55 == nil then
        return false
    end
    return (v51:IsDescendantOf(v55))
end

local function rarityOf(v56) -- line 248 | captures: EggRewards
    local AnimalName = v56:GetAttribute("AnimalName")
    local RarityOf = EggRewards.RarityOf
    if typeof(AnimalName) ~= "string" then
        AnimalName = nil
    end
    local v57 = RarityOf(AnimalName)
    if v57 then
        return v57
    end
    local Rarity = v56:GetAttribute("Rarity")
    if typeof(Rarity) == "string" then
        return Rarity
    end
    return nil
end

local function mergeCandidates() -- line 260 | captures: CollectionService, EggRewards, IndexConfig, OwnBase, candidateOwned
    local function v58(...)
        return (typeof(...))
    end

    local v59 = {}
    for v60, v61 in CollectionService:GetTagged("AnimalTool") do
        if v61:IsA("Tool") and candidateOwned(v61) then
            table.insert(v59, v61)
        end
    end
    local v62 = OwnBase.Get()
    local v63 = v62 and v62:FindFirstChild("PlacedAnimals")
    if v63 then
        for v64, v65 in v63:GetChildren() do
            if v58(v65:GetAttribute("AnimalName")) == "string" then
                table.insert(v59, v65)
            end
        end
    end
    local v66 = {}

    local function rankOf(v67) -- line 278 | captures: v66, EggRewards, IndexConfig
        local v68 = v66[v67]
        if v68 then
            return v68
        end
        local AnimalName = v67:GetAttribute("AnimalName")
        local RarityOf = EggRewards.RarityOf
        if typeof(AnimalName) ~= "string" then
            AnimalName = nil
        end
        local v69 = RarityOf(AnimalName)
        if not v69 then
            v69 = v67:GetAttribute("Rarity")
            if typeof(v69) ~= "string" then
                v69 = nil
            end
        end
        local v70
        if not (v69 and table.find(IndexConfig.RarityOrder, v69)) then
            v70 = 0
        else
            v70 = IndexConfig.RarityIndex(v69)
        end
        v66[v67] = v70
        return v70
    end

    table.sort(v59, function(v71, v72) -- line 291 | captures: v66, EggRewards, IndexConfig
        local function v73(...)
            return (tostring(...))
        end

        local function v74(...)
            return (tostring(...))
        end

        local v75 = v66[v71]
        if not v75 then
            local AnimalName = v71:GetAttribute("AnimalName")
            local RarityOf = EggRewards.RarityOf
            if typeof(AnimalName) ~= "string" then
                AnimalName = nil
            end
            local v76 = RarityOf(AnimalName)
            if not v76 then
                v76 = v71:GetAttribute("Rarity")
                if typeof(v76) ~= "string" then
                    v76 = nil
                end
            end
            if not (v76 and table.find(IndexConfig.RarityOrder, v76)) then
                v75 = 0
            else
                v75 = IndexConfig.RarityIndex(v76)
            end
            v66[v71] = v75
        end
        local v77 = v66[v72]
        if not v77 then
            local AnimalName = v72:GetAttribute("AnimalName")
            local RarityOf = EggRewards.RarityOf
            if typeof(AnimalName) ~= "string" then
                AnimalName = nil
            end
            local v78 = RarityOf(AnimalName)
            if not v78 then
                v78 = v72:GetAttribute("Rarity")
                if typeof(v78) ~= "string" then
                    v78 = nil
                end
            end
            if not (v78 and table.find(IndexConfig.RarityOrder, v78)) then
                v77 = 0
            else
                v77 = IndexConfig.RarityIndex(v78)
            end
            v66[v72] = v77
        end
        if v75 == v77 then
            local v79 = v71:GetAttribute("WeightKg") or 0
            local v80 = v72:GetAttribute("WeightKg") or 0
            if v79 == v80 then
                return v73(v71:GetAttribute("AnimalName")) < v74(v72:GetAttribute("AnimalName"))
            end
            return v80 < v79
        end
        return v77 < v75
    end)
    return v59
end

local function isSlotted(v81) -- line 306 | captures: v3
    for v82, v83 in v3 do
        if v83 == v81 then
            return true
        end
    end
    return false
end

local function requiredAnimalName() -- line 317 | captures: v3
    for v84, v85 in v3 do
        local AnimalName = v85:GetAttribute("AnimalName")
        if typeof(AnimalName) == "string" then
            return AnimalName
        end
    end
    return nil
end

local function paintNameLabel(v86, v87, v88) -- line 335 | captures: EggRewards, MutationConfig, WeightTag
    if v86 and v86:IsA("TextLabel") then
        local AnimalName = v87:GetAttribute("AnimalName")
        if typeof(AnimalName) == "string" then
            local Mutation = v87:GetAttribute("Mutation")
            local v89 = MutationConfig.PrefixName(Mutation, EggRewards.DisplayName(AnimalName))
            if v88 then
                local v90 = v87:GetAttribute("WeightKg") or 0
                v86.RichText = true
                v86.Text = WeightTag.Label(v90, v89)
            else
                v86.Text = v89
            end
        end
    end
end

local function paintWeightLabel(v91, v92) -- line 357 | captures: RarityNameGradient, WeightTag
    if v91 and v91:IsA("TextLabel") then
        v91.Text = ("(%*KG)"):format((WeightTag.FormatKg(v92)))
        RarityNameGradient.Apply(v91, { Base = WeightTag.Color(v92) })
    end
end

local v93 = ColorSequence.new(Color3.fromRGB(140, 140, 140), Color3.fromRGB(255, 255, 255))
local v94 = Color3.fromRGB(255, 255, 255)
local v95 = Color3.fromRGB(0, 0, 0)
local UiGradient, Inner, Outer, v96, Color, Color_2, Color_3, v97

local function cooldownRemaining() -- line 398 | captures: Workspace, MergeConfig, LocalPlayer
    local v98 = LocalPlayer:GetAttribute(MergeConfig.CooldownAttribute)
    if typeof(v98) == "number" then
        return v98 - Workspace:GetServerTimeNow()
    end
    return 0
end

local function formatCooldown(v99) -- line 407
    local v100 = math.ceil(v99)
    local v101 = math.max(v100, 0)
    local v102 = v101 // 60
    local v103 = v101 % 60
    if v102 > 0 then
        return (("%*m %*s"):format(v102, v103))
    end
    return (("%*s"):format(v103))
end

local function styleMergeButton(v104) -- line 416 | captures: UiGradient, Inner, Outer, v96, Color, Color_2, Color_3, v93, v94, v95
    if UiGradient then
        if v104 then
            UiGradient.Color = v93
        elseif Color then
            UiGradient.Color = Color
        end
    end
    if Inner then
        local Inner_2 = Inner
        if v104 then
            Inner_2.Color = v94
        else
            Inner_2.Color = Color_2 or Inner.Color
        end
    end
    if Outer then
        local Outer_2 = Outer
        if v104 then
            Outer_2.Color = v95
        else
            Outer_2.Color = Color_3 or Outer.Color
        end
    end
    if v96 then
        v96.Enabled = not v104
    end
end

local v105

local function selectorInside(v106) -- line 444 | captures: GuiService
    local SelectedObject = GuiService.SelectedObject
    if SelectedObject == nil or v106 == nil then
        return false
    end
    return (SelectedObject:IsDescendantOf(v106))
end

local function isSelectableNow(v107) -- line 453 | captures: LocalPlayer
    if v107.Selectable and v107:IsDescendantOf(LocalPlayer:FindFirstChildOfClass("PlayerGui") or game) then
        local v108 = v107
        while true do
            if v108 then
                if not v108:IsA("GuiObject") or v108.Visible then
                    if v108:IsA("LayerCollector") then
                        return v108.Enabled
                    end
                    v108 = v108.Parent
                    continue
                end
                break
            end
            return false
        end
        return false
    end
    return false
end

local function selectLater(v109) -- line 470 | captures: GuiService, isSelectableNow
    if v109 ~= nil then
        task.defer(function() -- line 474 | captures: v109, GuiService, isSelectableNow
            if v109.Parent and isSelectableNow(v109) then
                GuiService.SelectedObject = v109
            end
        end)
    end
end

local function showFusionView() -- line 481 | captures: v5, v6, AnimalFusion, v7, GuiService, isSelectableNow
    v5 = nil
    local v110 = v6
    local SelectedObject = GuiService.SelectedObject
    local v111
    if SelectedObject == nil or v110 == nil then
        v111 = false
    else
        v111 = SelectedObject:IsDescendantOf(v110)
    end
    if v7 then
        v7.Visible = false
    end
    if not AnimalFusion then
        return
    end
    AnimalFusion.Visible = true
    local v112 = AnimalFusion:FindFirstChild("Merge") or AnimalFusion:FindFirstChild("Add")
    if v111 and v112 and v112:IsA("GuiButton") then
        if v112 == nil then
            return
        end
        task.defer(function() -- line 474 | captures: v112, GuiService, isSelectableNow
            if v112.Parent and isSelectableNow(v112) then
                GuiService.SelectedObject = v112
            end
        end)
    end
end

local function clearSlot(v113) -- line 498 | captures: v105, v3, v4
    local v114 = v4[v113]
    if v114 then
        v114:Disconnect()
        v4[v113] = nil
    end
    v3[v113] = nil
    v105()
end

local function setSlot(v115, v116) -- line 508 | captures: v105, v3, v4, candidateOwned
    local v117 = v4[v115]
    if v117 then
        v117:Disconnect()
        v4[v115] = nil
    end
    v3[v115] = nil
    v105()
    v3[v115] = v116
    local AncestryChanged = v116.AncestryChanged
    v4[v115] = AncestryChanged:Connect(function() -- line 513 | captures: v115, v116, v105, v3, v4, candidateOwned
        if candidateOwned(v116) then
            return
        end
        local v118 = v4[v115]
        if v118 then
            v118:Disconnect()
            v4[v115] = nil
        end
        v3[v115] = nil
        v105()
    end)
    v105()
end

function v105() -- line 523 | captures: v11, v12, v13, v14, v17, v18, v19, v24, v25, v26, v27, v28, v29, v30, TweenService, Workspace, EggRewards, MergeConfig, MutationConfig, WeightTag, MergeOutcomeDisplay, AnimalTileStyle, LocalPlayer, v3, v9, v10, v20, v41, requiredAnimalName, paintWeightLabel
    for v119 = 1, 3 do
        local v120 = v3[v119]
        local v121 = v10[v119]
        if v121 then
            if v120 == nil then
                v121.ImageTransparency = 1
            else
                v121.ImageTransparency = 0
            end
        end
        local v122 = v9[v119]
        if v122 then
            local AddPet = v122:FindFirstChild("AddPet")
            local AnimalAdded = v122:FindFirstChild("AnimalAdded")
            if AddPet and AddPet:IsA("GuiObject") then
                AddPet.Visible = v120 == nil
            end
            if AnimalAdded and AnimalAdded:IsA("GuiObject") then
                AnimalAdded.Visible = v120 ~= nil
                if v120 then
                    local Name = AnimalAdded:FindFirstChild("Name")
                    if Name and Name:IsA("TextLabel") then
                        local AnimalName = v120:GetAttribute("AnimalName")
                        if typeof(AnimalName) == "string" then
                            local Mutation = v120:GetAttribute("Mutation")
                            Name.Text = MutationConfig.PrefixName(Mutation, EggRewards.DisplayName(AnimalName))
                        end
                    end
                    paintWeightLabel(AnimalAdded:FindFirstChild("Weight") or AnimalAdded:FindFirstChild("Rarity"), v120:GetAttribute("WeightKg") or 0)
                    local AnimalName = v120:GetAttribute("AnimalName")
                    if typeof(AnimalName) == "string" then
                        local AnimalDisplay = AnimalAdded:FindFirstChild("AnimalDisplay")
                        local v123 = v120 and v120:GetAttribute("Variant")
                        local SetRender = AnimalTileStyle.SetRender
                        local v124 = if typeof(v123) == "string" then v123 else nil
                        SetRender(AnimalDisplay, AnimalName, v124)
                    end
                end
            end
        end
    end
    local v125 = 0
    local v126 = 0
    for v127, v128 in v3 do
        v125, v126 = v125 + 1, v126 + (v128:GetAttribute("WeightKg") or 0)
    end
    MergeOutcomeDisplay.SetAnimal((requiredAnimalName()))
    if v125 ~= v30 then
        if v125 > 0 then
            MergeOutcomeDisplay.Punch(v125 >= 3)
        end
        v30 = v125
    end
    if v11 then
        local v129 = LocalPlayer:GetAttribute(MergeConfig.CooldownAttribute)
        local v130 = if typeof(v129) == "number" then v129 - Workspace:GetServerTimeNow() else 0
        if v130 > 0 then
            local v131 = v11
            local v132 = math.ceil(v130)
            local v133 = math.max(v132, 0)
            local v134 = v133 // 60
            local v135 = v133 % 60
            if v134 > 0 then
                v131.Text = ("%*m %*s"):format(v134, v135)
            else
                v131.Text = ("%*s"):format(v135)
            end
        else
            local v136 = v11
            if v125 >= 3 then
                v136.Text = "Merge"
            elseif v125 == 2 then
                v136.Text = "1 Pet Left"
            else
                v136.Text = ("%* Pets Left"):format(3 - v125)
            end
        end
    end
    local v137 = v12
    if v137 and v125 > 0 and not v137.Visible then
        v29 = false
        v13 = 0
        v41:Snap(0)
        v137.Visible = true
    end
    local v138 = v17
    if v138 and v19 then
        v19:Cancel()
        v19 = nil
    end
    local v139 = v41:Value()
    local Visible
    if v137 == nil then
        Visible = false
    else
        Visible = v137.Visible
        if Visible then
            local v140 = v126 - v139
            Visible = math.abs(v140) > 0.5
        end
    end
    if Visible then
        v25 = v24
        v26 = v125
        v27 = v139
        v28 = v126
        v29 = true
    else
        v29 = false
        if v138 then
            local v141 = {}
            local v142 = 1 - v125 / 3
            v141.Position = UDim2.new(v18.X.Scale, v18.X.Offset, v142 + v138.AnchorPoint.Y * v138.Size.Y.Scale, 0)
            local v143 = TweenService:Create(v138, v20, v141)
            v19 = v143
            v143:Play()
        end
        v24 = v125
        MergeOutcomeDisplay.TweenLevel(v125 / 3, v20)
    end
    if not (v137 and v137.Visible) then
        return
    end
    v13 = v126
    v41:Set(v126)
    local v144 = v14 - v126
    if math.abs(v144) <= 0.5 then
        local v145 = v12
        if v145 and v145.Parent then
            v14 = v126
            v145.Text = ("%*KG"):format((WeightTag.FormatKg(v126)))
        end
    end
end

local function refreshNoneLabel() -- line 652 | captures: AnimalList, None
    local None_2 = None
    local AnimalList_2 = AnimalList
    if not None_2 or not AnimalList_2 then
        return
    end
    local v146 = false
    for v147, v148 in AnimalList_2:GetChildren() do
        if v148.Name == "Entry" and v148:IsA("GuiObject") and v148.Visible then
            v146 = true
            break
        end
        v146 = false
    end
    None_2.Visible = not v146
end

local v149 = {}

local function paintTileBackground(v150, v151) -- line 679 | captures: AnimalTileStyle
    AnimalTileStyle.PaintBackground(v150, v151)
end

local function buildTile(v152) -- line 683 | captures: v5, v8, v105, EggRewards, FloatingIconConfig, MutationConfig, FloatingIconFX, AnimalTileStyle, v3, v4, candidateOwned, paintWeightLabel, showFusionView, refreshNoneLabel, v149
    local v153 = v8
    if v153 then
        local AnimalName = v152:GetAttribute("AnimalName")
        if typeof(AnimalName) == "string" then
            local v154 = v153:Clone()
            v154.Name = "Entry"
            v154.Visible = true
            local Inner = v154:FindFirstChild("Inner")
            if Inner and Inner:IsA("GuiObject") then
                Inner.Active = true
                Inner.Selectable = true
                for v155, v156 in Inner:GetDescendants() do
                    if v156:IsA("GuiObject") then
                        v156.Active = false
                    end
                end
                local Name = Inner:FindFirstChild("Name")
                if Name and Name:IsA("TextLabel") then
                    local AnimalName = v152:GetAttribute("AnimalName")
                    if typeof(AnimalName) == "string" then
                        local Mutation = v152:GetAttribute("Mutation")
                        Name.Text = MutationConfig.PrefixName(Mutation, EggRewards.DisplayName(AnimalName))
                    end
                end
                paintWeightLabel(Inner:FindFirstChild("Weight"), v152:GetAttribute("WeightKg") or 0)
                local AnimalDisplay = Inner:FindFirstChild("AnimalDisplay")
                local v157 = v152 and v152:GetAttribute("Variant")
                local SetRender = AnimalTileStyle.SetRender
                if typeof(v157) ~= "string" then
                    v157 = nil
                end
                SetRender(AnimalDisplay, AnimalName, v157)
                local AnimalName_2 = v152:GetAttribute("AnimalName")
                local RarityOf = EggRewards.RarityOf
                if typeof(AnimalName_2) ~= "string" then
                    AnimalName_2 = nil
                end
                local v158 = RarityOf(AnimalName_2)
                if not v158 then
                    v158 = v152:GetAttribute("Rarity")
                    if typeof(v158) ~= "string" then
                        v158 = nil
                    end
                end
                AnimalTileStyle.PaintBackground(Inner, v158)
                if AnimalDisplay and AnimalDisplay:IsA("GuiObject") and Inner:IsA("GuiButton") then
                    FloatingIconFX.Attach(AnimalDisplay, FloatingIconConfig.Styles.AnimalTile, Inner)
                end
                if Inner:IsA("GuiButton") then
                    Inner.Activated:Connect(function() -- line 728 | captures: v152, v5, v105, v3, v4, candidateOwned, showFusionView
                        local v159 = v5
                        if v159 ~= nil and candidateOwned(v152) then
                            local v160 = false
                            local v161
                            for v162, v163 in v3 do
                                if v163 == v152 then
                                    v161 = true
                                    v160 = true
                                    break
                                end
                            end
                            if not v160 then
                                v161 = false
                            end
                            if not v161 then
                                local v164 = v4[v159]
                                if v164 then
                                    v164:Disconnect()
                                    v4[v159] = nil
                                end
                                v3[v159] = nil
                                v105()
                                v3[v159] = v152
                                local AncestryChanged = v152.AncestryChanged
                                v4[v159] = AncestryChanged:Connect(function() -- line 513 | captures: v159, v152, v105, v3, v4, candidateOwned
                                    if candidateOwned(v152) then
                                        return
                                    end
                                    local v165 = v4[v159]
                                    if v165 then
                                        v165:Disconnect()
                                        v4[v159] = nil
                                    end
                                    v3[v159] = nil
                                    v105()
                                end)
                                v105()
                            end
                        end
                        showFusionView()
                    end)
                end
            end
            local v166 = v152.AncestryChanged:Connect(function() -- line 743 | captures: v152, v154, candidateOwned, refreshNoneLabel
                if not candidateOwned(v152) and v154.Parent then
                    v154:Destroy()
                    refreshNoneLabel()
                end
            end)
            v149[v152] = v154
            v154.Destroying:Once(function() -- line 750 | captures: v152, v154, v166, v149
                v166:Disconnect()
                if v149[v152] == v154 then
                    v149[v152] = nil
                end
            end)
            return v154
        end
    end
    return nil
end

local function tileInList(v167, v168) -- line 761 | captures: v149, buildTile
    local v169 = v149[v167]
    if v169 and v169.Parent == v168 then
        return v169
    end
    if v169 then
        v169:Destroy()
    end
    local v170 = buildTile(v167)
    if v170 then
        v170.Visible = false
        v170.Parent = v168
    end
    return v170
end

local v171 = 0

local function prewarmTiles() -- line 781 | captures: v6, AnimalList, v171, candidateOwned, mergeCandidates, v149, buildTile
    v171 += 1
    local v172 = v171
    local AnimalList_2 = AnimalList
    if AnimalList_2 then
        task.spawn(function() -- line 788 | captures: v172, AnimalList_2, v6, AnimalList, v171, candidateOwned, mergeCandidates, v149, buildTile
            local v173 = 0
            for v174, v175 in mergeCandidates() do
                if v172 == v171 and AnimalList == AnimalList_2 and v6 and v6.Visible then
                    local v176 = v149[v175]
                    if not (v176 and v176.Parent == AnimalList_2) and candidateOwned(v175) then
                        local v177 = v149[v175]
                        if v177 then
                            if v177.Parent ~= AnimalList_2 then
                                v177:Destroy()
                                local v178 = buildTile(v175)
                                if v178 then
                                    v178.Visible = false
                                    v178.Parent = AnimalList_2
                                end
                            end
                        else
                            local v179 = buildTile(v175)
                            if v179 then
                                v179.Visible = false
                                v179.Parent = AnimalList_2
                            end
                        end
                        v173 += 1
                        if v173 % 10 == 0 then
                            task.wait()
                        end
                    end
                else
                    return
                end
            end
        end)
    end
end

local function openListFor(v180) -- line 809 | captures: v5, v6, AnimalFusion, AnimalList, v7, v171, GuiService, v3, mergeCandidates, requiredAnimalName, isSelectableNow, refreshNoneLabel, v149, buildTile
    local AnimalList_2 = AnimalList
    if not AnimalList_2 then
        return
    end
    v5 = v180
    v171 += 1
    local v181 = requiredAnimalName()
    local v182 = {}
    local v183 = 1
    local v184
    for v185, v186 in mergeCandidates() do
        local v187 = false
        for v188, v189 in v3 do
            if v189 == v186 then
                v187 = true
                break
            end
            v187 = false
        end
        if not v187 and (v181 == nil or v186:GetAttribute("AnimalName") == v181) then
            local v190 = v149[v186]
            if v190 then
                if v190.Parent ~= AnimalList_2 then
                    v190:Destroy()
                    v190 = buildTile(v186)
                    if v190 then
                        v190.Visible = false
                        v190.Parent = AnimalList_2
                    end
                end
            else
                v190 = buildTile(v186)
                if v190 then
                    v190.Visible = false
                    v190.Parent = AnimalList_2
                end
            end
            if v190 then
                v190.LayoutOrder = v183
                v183 += 1
                v190.Visible = true
                v182[v190] = true
                local Inner = v190:FindFirstChild("Inner")
                if v184 == nil and Inner and Inner:IsA("GuiButton") then
                    v184 = Inner
                end
            end
        end
    end
    for v191, v192 in AnimalList_2:GetChildren() do
        if v192.Name == "Entry" and v192:IsA("GuiObject") and not v182[v192] then
            v192.Visible = false
        end
    end
    refreshNoneLabel()
    local v193 = v6
    local SelectedObject = GuiService.SelectedObject
    local v194
    if SelectedObject == nil or v193 == nil then
        v194 = false
    else
        v194 = SelectedObject:IsDescendantOf(v193)
    end
    if AnimalFusion then
        AnimalFusion.Visible = false
    end
    AnimalList_2.CanvasPosition = Vector2.zero
    AnimalList_2.Visible = true
    if v7 then
        v7.Visible = true
    end
    if not v194 then
        return
    end
    local v195 = v6 and v6:FindFirstChild("Close", true)
    if not v184 then
        if not (v195 and v195:IsA("GuiButton")) then
            v184 = nil
        else
            v184 = v195
        end
    end
    if v184 == nil then
        return
    end
    local defer = task.defer
    local v196 = v184
    defer(function() -- line 474 | captures: v196, GuiService, isSelectableNow
        if v196.Parent and isSelectableNow(v196) then
            GuiService.SelectedObject = v196
        end
    end)
end

local function adopt(v197) -- line 870 | captures: v5, v6, AnimalFusion, AnimalList, v7, None, v8, v11, v12, v13, v14, v17, v18, v19, v24, v29, v30, UiGradient, Inner, Outer, v96, Color, Color_2, Color_3, v105, v171, ReplicatedStorage, Workspace, MergeConfig, WeightTag, MergeSfx, MergeOutcomeDisplay, UiFrames, v2, LocalPlayer, v3, v4, v9, v10, v41, candidateOwned, mergeCandidates, v93, v94, v95, showFusionView, v149, buildTile, openListFor
    v6 = nil
    AnimalFusion = nil
    AnimalList = nil
    table.clear(v149)
    v171 += 1
    v7 = nil
    None = nil
    v8 = nil
    table.clear(v9)
    table.clear(v10)
    for v198 in v3 do
        local v199 = v4[v198]
        if v199 then
            v199:Disconnect()
        end
    end
    table.clear(v3)
    table.clear(v4)
    v5 = nil
    v11 = nil
    UiGradient = nil
    Inner = nil
    Outer = nil
    v96 = nil
    Color = nil
    Color_2 = nil
    Color_3 = nil
    v12 = nil
    v17 = nil
    if v19 then
        v19:Cancel()
        v19 = nil
    end
    v29 = false
    v24 = 0
    v30 = 0
    v41:Snap(0)
    local Frames = v197:FindFirstChild("Frames")
    local v200 = Frames and Frames:FindFirstChild("MergeMachine")
    local AnimalFusion_2, ScrollingFrameContainer, AnimalList_2
    if v200 and v200:IsA("GuiObject") then
        AnimalFusion_2 = v200:FindFirstChild("AnimalFusion")
        ScrollingFrameContainer = v200:FindFirstChild("ScrollingFrameContainer")
        AnimalList_2 = ScrollingFrameContainer and ScrollingFrameContainer:FindFirstChild("AnimalList") or v200:FindFirstChild("AnimalList", true)
    else
        return
    end
    local v201 = AnimalList_2 and AnimalList_2:FindFirstChild("Template")
    local v202, v203, v204
    if AnimalFusion_2 then
        v203 = AnimalFusion_2:FindFirstChild("PetsPlacementList")
        if AnimalFusion_2:IsA("GuiObject") and AnimalList_2 and AnimalList_2:IsA("ScrollingFrame") and v201 and v201:IsA("Frame") and v203 then
            v6 = v200
            AnimalFusion = AnimalFusion_2
            AnimalList = AnimalList_2
            if ScrollingFrameContainer and ScrollingFrameContainer:IsA("GuiObject") and AnimalList_2:IsDescendantOf(ScrollingFrameContainer) then
                v202 = ScrollingFrameContainer
            else
                v202 = AnimalList_2
            end
            v204 = false
        else
            v204 = true
        end
    else
        v203 = AnimalFusion_2
        v204 = true
    end
    if v204 then
        return
    end
    v7 = v202
    local None_2 = AnimalList_2:FindFirstChild("None")
    if not (None_2 and None_2:IsA("GuiObject")) then
        None_2 = nil
    end
    None = None_2
    v8 = v201
    v201.Visible = false
    v200.Visible = false
    v200:GetPropertyChangedSignal("Visible"):Connect(function() -- line 950 | captures: v200, v6, AnimalList, v171, candidateOwned, mergeCandidates, v149, buildTile
        if not (v200.Visible and v6 == v200) then
            return
        end
        v171 += 1
        local v205 = v171
        local AnimalList_2 = AnimalList
        if not AnimalList_2 then
            return
        end
        task.spawn(function() -- line 788 | captures: v205, AnimalList_2, v6, AnimalList, v171, candidateOwned, mergeCandidates, v149, buildTile
            local v206 = 0
            for v207, v208 in mergeCandidates() do
                if v205 == v171 and AnimalList == AnimalList_2 and v6 and v6.Visible then
                    local v209 = v149[v208]
                    if not (v209 and v209.Parent == AnimalList_2) and candidateOwned(v208) then
                        local v210 = v149[v208]
                        if v210 then
                            if v210.Parent ~= AnimalList_2 then
                                v210:Destroy()
                                local v211 = buildTile(v208)
                                if v211 then
                                    v211.Visible = false
                                    v211.Parent = AnimalList_2
                                end
                            end
                        else
                            local v212 = buildTile(v208)
                            if v212 then
                                v212.Visible = false
                                v212.Parent = AnimalList_2
                            end
                        end
                        v206 += 1
                        if v206 % 10 == 0 then
                            task.wait()
                        end
                    end
                else
                    return
                end
            end
        end)
    end)
    local Inner_2 = v201:FindFirstChild("Inner")
    if Inner_2 then
        Inner_2:SetAttribute("HoverScale", 1.03)
        Inner_2:SetAttribute("PressScale", 0.95)
    end
    local UIListLayout = AnimalList_2:FindFirstChildOfClass("UIListLayout")
    if UIListLayout then
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.Wraps = true
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    end
    local Title = AnimalList_2:FindFirstChild("Title")
    if Title and Title:IsA("GuiObject") then
        Title.LayoutOrder = -2
    end
    if None then
        None.LayoutOrder = -1
        None.Visible = false
    end
    AnimalList_2.CanvasSize = UDim2.new()
    AnimalList_2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    for v213, v214 in v2 do
        local v215 = AnimalFusion_2:FindFirstChild(v214.Name)
        if v215 and v215:IsA("ImageLabel") then
            v215.Image = v214.Unfilled
            local FilledArt = v215:FindFirstChild("FilledArt")
            if not (FilledArt and FilledArt:IsA("ImageLabel")) then
                FilledArt = Instance.new("ImageLabel")
                FilledArt.Name = "FilledArt"
                FilledArt.BackgroundTransparency = 1
                FilledArt.Size = UDim2.fromScale(1, 1)
                FilledArt.Position = UDim2.fromScale(0, 0)
                FilledArt.ScaleType = v215.ScaleType
                FilledArt.SliceCenter = v215.SliceCenter
                FilledArt.SliceScale = v215.SliceScale
                FilledArt.ZIndex = v215.ZIndex + 1
                FilledArt.Image = v214.Filled
                FilledArt.ImageTransparency = 1
                FilledArt.Parent = v215
            end
            v10[v213] = FilledArt
        end
    end
    local v216 = AnimalFusion_2:FindFirstChild("Merge") or AnimalFusion_2:FindFirstChild("Add")
    local v217 = v216 and v216:FindFirstChild("Title")
    if not (v217 and v217:IsA("TextLabel")) then
        v217 = nil
    end
    v11 = v217
    if v216 then
        local UiGradient_2 = v216:FindFirstChild("UiGradient")
        if UiGradient_2 then
            if not UiGradient_2:IsA("UIGradient") then
                UiGradient_2 = nil
            end
        else
            UiGradient_2 = nil
        end
        UiGradient = UiGradient_2
        if UiGradient then
            Color = UiGradient.Color
        else
            Color = nil
        end
        local Inner_2 = v216:FindFirstChild("Inner")
        if not (Inner_2 and Inner_2:IsA("UIStroke")) then
            Inner_2 = nil
        end
        Inner = Inner_2
        if Inner then
            Color_2 = Inner.Color
        else
            Color_2 = nil
        end
        local Outer_2 = v216:FindFirstChild("Outer")
        if not (Outer_2 and Outer_2:IsA("UIStroke")) then
            Outer = nil
        else
            Outer = Outer_2
        end
        if Outer then
            Color_3 = Outer.Color
        else
            Color_3 = nil
        end
        local v218 = Outer_2 and Outer_2:FindFirstChild("UiGradient")
        if not (v218 and v218:IsA("UIGradient")) then
            v218 = nil
        end
        v96 = v218
    end
    local v219 = LocalPlayer:GetAttribute(MergeConfig.CooldownAttribute)
    local v220 = if typeof(v219) == "number" then v219 - Workspace:GetServerTimeNow() else 0
    local v221 = v220 > 0
    if UiGradient then
        if v221 then
            UiGradient.Color = v93
        elseif Color then
            UiGradient.Color = Color
        end
    end
    if Inner then
        local Inner_2 = Inner
        if v221 then
            Inner_2.Color = v94
        else
            Inner_2.Color = Color_2 or Inner.Color
        end
    end
    if Outer then
        local Outer_2 = Outer
        if v221 then
            Outer_2.Color = v95
        else
            Outer_2.Color = Color_3 or Outer.Color
        end
    end
    if v96 then
        v96.Enabled = not v221
    end
    if v216 and v216:IsA("GuiButton") then
        v216.Activated:Connect(function() -- line 1044 | captures: ReplicatedStorage, Workspace, MergeConfig, MergeSfx, LocalPlayer, v3
            local v222 = LocalPlayer:GetAttribute(MergeConfig.CooldownAttribute)
            local v223 = if typeof(v222) == "number" then v222 - Workspace:GetServerTimeNow() else 0
            if v223 > 0 then
                return
            end
            local v224 = {}
            local v225 = v3[1]
            if v225 == nil then
                return
            end
            v224[1] = v225
            local v226 = v3[2]
            if v226 ~= nil then
                v224[2] = v226
                local v227 = v3[3]
                if v227 ~= nil then
                    v224[3] = v227
                    local v228 = ReplicatedStorage:FindFirstChild(MergeConfig.RemoteName)
                    if v228 and v228:IsA("RemoteEvent") then
                        MergeSfx.Play("Fuse")
                        MergeSfx.Play("Merged")
                        MergeSfx.Play("MergedPower")
                        v228:FireServer("Merge", v224)
                    end
                end
            end
        end)
    end
    local OutCome = AnimalFusion_2:FindFirstChild("OutCome")
    local v229 = OutCome and OutCome:FindFirstChild("Weight")
    if not (v229 and v229:IsA("TextLabel")) then
        v229 = nil
    end
    v12 = v229
    if v12 then
        v12.Visible = false
        v13 = 0
        v41:Snap(0)
        local v230 = v12
        if v230 and v230.Parent then
            v14 = 0
            v230.Text = ("%*KG"):format((WeightTag.FormatKg(0)))
        end
    end
    MergeOutcomeDisplay.Adopt(OutCome)
    local v231 = OutCome and OutCome:FindFirstChild("Fill")
    local v232 = v231 and v231:FindFirstChild("Bar")
    if v232 and v232:IsA("GuiObject") then
        v17 = v232
        v18 = v232.Position
        v232.Position = UDim2.new(v18.X.Scale, v18.X.Offset, 1 + v232.AnchorPoint.Y * v232.Size.Y.Scale, 0)
        v24 = 0
    end
    for v233 = 1, 3 do
        local v234 = v203:FindFirstChild((("Slot_%*"):format(v233)))
        if v234 and v234:IsA("GuiObject") then
            v9[v233] = v234
            local AddPet = v234:FindFirstChild("AddPet")
            local v235 = AddPet and AddPet:FindFirstChild("Add")
            if v235 and v235:IsA("GuiButton") then
                local Activated = v235.Activated
                local v236 = v233
                Activated:Connect(function() -- line 1103 | captures: v236, openListFor
                    openListFor(v236)
                end)
            end
            local AnimalAdded = v234:FindFirstChild("AnimalAdded")
            local v237 = AnimalAdded and AnimalAdded:FindFirstChild("Remove")
            if v237 and v237:IsA("GuiButton") then
                local Activated = v237.Activated
                local v238 = v233
                Activated:Connect(function() -- line 1111 | captures: v238, v105, v3, v4
                    local v239 = v4[v238]
                    if v239 then
                        v239:Disconnect()
                        v4[v238] = nil
                    end
                    v3[v238] = nil
                    v105()
                end)
            end
        end
    end
    local v240 = v200:FindFirstChild("Close", true)
    if v240 and v240:IsA("GuiButton") then
        v240.Activated:Connect(function() -- line 1122 | captures: v200, v7, UiFrames, showFusionView
            local v241 = v7
            if not (v241 and v241.Visible) then
                UiFrames.Close(v200)
            else
                showFusionView()
            end
        end)
    end
    UiFrames.Observe(v200, function(v242) -- line 1134 | captures: v5, v105, showFusionView
        if v242 then
            showFusionView()
            v105()
        else
            v5 = nil
        end
    end)
    showFusionView()
    v105()
end

local function onPromptTriggered() -- line 1151 | captures: v6, UiFrames
    if v6 ~= nil then
        UiFrames.Open(v6)
    end
end

local function bindMachine(v243) -- line 1159 | captures: onPromptTriggered
    local function tryBind(v244) -- line 1160 | captures: onPromptTriggered
        if v244:IsA("ProximityPrompt") then
            v244.Triggered:Connect(onPromptTriggered)
        end
    end

    for v245, v246 in v243:GetDescendants() do
        if v246:IsA("ProximityPrompt") then
            v246.Triggered:Connect(onPromptTriggered)
        end
    end
    v243.DescendantAdded:Connect(tryBind)
end

function v1.Start() -- line 1172 | captures: v6, v11, UiGradient, Inner, Outer, v96, Color, Color_2, Color_3, v97, v105, ContentProvider, ReplicatedStorage, Workspace, AnimalEggsConfig, AnimalRenders, EggRewards, MergeConfig, MergeRevealFX, NewItemController, UiFrames, MainGui, v2, LocalPlayer, v93, v94, v95, adopt, bindMachine
    MainGui.Observe(adopt)
    task.spawn(function() -- line 1178 | captures: ContentProvider, v2
        local v247 = {}
        for v248, v249 in v2 do
            local Filled = v249.Filled
            table.insert(v247, Filled)
            local Unfilled = v249.Unfilled
            table.insert(v247, Unfilled)
        end
        pcall(ContentProvider.PreloadAsync, ContentProvider, v247)
    end)
    task.spawn(function() -- line 1191 | captures: v6, ReplicatedStorage, AnimalEggsConfig, AnimalRenders, EggRewards, MergeConfig, MergeRevealFX, NewItemController, UiFrames
        local v250 = ReplicatedStorage:WaitForChild(MergeConfig.RemoteName, 30)
        if v250 and v250:IsA("RemoteEvent") then
            v250.OnClientEvent:Connect(function(v251, v252, v253, v254) -- line 1196 | captures: v6, AnimalEggsConfig, AnimalRenders, EggRewards, MergeRevealFX, NewItemController, UiFrames
                if v251 == "Merged" and typeof(v252) == "string" then
                    if v6 and UiFrames.IsOpen(v6) then
                        UiFrames.Close(v6)
                    end
                else
                    return
                end
                MergeRevealFX.Play(v252)
                local v255 = AnimalRenders.GetEggImage(v252)
                local v256
                if v255 == "" then
                    v256 = AnimalEggsConfig.CloneEgg(v252)
                    if v256 then
                        AnimalEggsConfig.PrepareForDisplay(v256)
                    end
                end
                local Show = NewItemController.Show
                local v257 = {}
                local v258 = {}
                if v255 == "" then
                    v258.Image = nil
                else
                    v258.Image = v255
                end
                v258.Model = v256
                if v255 ~= "" or v256 then
                    v258.Name = nil
                else
                    v258.Name = v252
                end
                if typeof(v254) == "string" then
                    v258.Variant = v254
                else
                    v258.Variant = nil
                end
                v258.Text = ("%* Egg"):format((EggRewards.DisplayName(v252)))
                v257[1] = v258
                Show(v257)
            end)
        end
    end)
    local v259 = workspace:WaitForChild("EggMachine", 30)
    if v259 then
        bindMachine(v259)
    else
        warn("[MergeMachineController] Workspace.EggMachine not found")
    end
    task.spawn(function() -- line 1245 | captures: v11, UiGradient, Inner, Outer, v96, Color, Color_2, Color_3, v97, v105, Workspace, MergeConfig, LocalPlayer, v93, v94, v95
        while true do
            local v260 = LocalPlayer:GetAttribute(MergeConfig.CooldownAttribute)
            local v261 = if typeof(v260) == "number" then v260 - Workspace:GetServerTimeNow() else 0
            local v262 = v261 > 0
            if v262 ~= v97 then
                v97 = v262
                if UiGradient then
                    if v262 then
                        UiGradient.Color = v93
                    elseif Color then
                        UiGradient.Color = Color
                    end
                end
                if Inner then
                    local Inner_2 = Inner
                    if v262 then
                        Inner_2.Color = v94
                    else
                        Inner_2.Color = Color_2 or Inner.Color
                    end
                end
                if Outer then
                    local Outer_2 = Outer
                    if v262 then
                        Outer_2.Color = v95
                    else
                        Outer_2.Color = Color_3 or Outer.Color
                    end
                end
                if v96 then
                    v96.Enabled = not v262
                end
                v105()
            end
            if v262 and v11 then
                local v263 = v11
                local v264 = math.ceil(v261)
                local v265 = math.max(v264, 0)
                local v266 = v265 // 60
                local v267 = v265 % 60
                if v266 > 0 then
                    v263.Text = ("%*m %*s"):format(v266, v267)
                else
                    v263.Text = ("%*s"):format(v267)
                end
            end
            local wait = task.wait
            local v268 = if v262 then 0.25 else 0.5
            wait(v268)
        end
    end)
end

return v1
