-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local FloatingIconConfig = require(ReplicatedStorage.Shared.FloatingIconConfig)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local IndexConfig = require(ReplicatedStorage.Shared.IndexConfig)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local HudBadge = require(script.Parent.HudBadge)
local NewItemController = require(script.Parent.NewItemController)
local RewardIcons = require(script.Parent.Parent.Modules.RewardIcons)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local FloatingIconFX = require(script.Parent.Parent.Modules.FloatingIconFX)
local IndexBatRewards = require(script.Parent.Parent.Modules.IndexBatRewards)
local v1 = {}
local v2 = {}

v2[1] = "rbxassetid://89750102043329"
v2[2] = "rbxassetid://122596877044306"
v2[3] = "rbxassetid://82461916001799"
v2[4] = "rbxassetid://134391427539806"
v2[5] = "rbxassetid://79547649063979"
v2[6] = "rbxassetid://121407674677343"
v2[7] = "rbxassetid://84654045184869"
v2[8] = "rbxassetid://116329469317993"
v2[9] = "rbxassetid://74114270377905"
v2[10] = "rbxassetid://94053122110355"

local v3 = {}
local v4 = {}
local v5 = {}
local v6 = {}
local v7, v8, v9

local function fireRemote(v10, v11) -- line 127 | captures: v9
    if v9 then
        v9:FireServer(v10, v11)
    end
end

local function showClaimPopup(v12) -- line 137 | captures: FormatNumber, NewItemController, RewardIcons
    local v13 = {}
    local v14 = RewardIcons.Cash()
    local v15 = RewardIcons.Speed()
    if v14 then
        local v16 = {
            Icon = v14,
            Count = v12.Cash,
            Text = ("$%*"):format((FormatNumber.Short(v12.Cash)))
        }
        table.insert(v13, v16)
    end
    if v15 then
        local v17 = {
            Icon = v15,
            Count = v12.Speed,
            Text = ("+%*"):format((FormatNumber.Short(v12.Speed)))
        }
        table.insert(v13, v17)
    end
    if #v13 > 0 then
        NewItemController.Show(v13)
    end
end

local function setBarFill(v18, v19) -- line 167
    if not v18 then
        return
    end
    v18.AnchorPoint = Vector2.new(0, 0.5)
    v18.Position = UDim2.fromScale(0, 0.5)
    v18.Size = UDim2.fromScale(math.clamp(v19, 0, 1), 1)
end

local function lengthenSection(v20, v21, v22, v23) -- line 183
    local Scale = v22.Size.X.Scale
    local Scale_2 = v22.Size.Y.Scale
    if Scale <= 0 or Scale_2 <= 0 then
        return 1
    end
    local v24 = 1 / Scale
    local v25 = math.floor(v24)
    local v26 = math.max(v25, 1)
    local v27 = 1 / Scale_2
    local v28 = math.floor(v27)
    local v29 = math.max(v28, 1)
    local v30 = v23 / v26
    local v31 = math.ceil(v30) - v29
    if v31 <= 0 then
        return 1
    end
    local Scale_3 = v21.Size.Y.Scale
    local v32 = v31 * Scale_2 * Scale_3
    local v33 = 1 + v32
    local v34 = v21.Position.Y.Scale + (1 - v21.AnchorPoint.Y) * Scale_3 - Scale_2 * Scale_3 / 2

    local function remap(v35) -- line 202 | captures: v32, v33, v34
        local v36 = if v34 <= v35 then v35 + v32 else v35
        return v36 / v33
    end

    for v37, v38 in v20:GetChildren() do
        if v38:IsA("GuiObject") then
            local Size = v38.Size
            local Position = v38.Position
            local Y = v38.AnchorPoint.Y
            local v39 = Position.Y.Scale - Y * Size.Y.Scale
            local v40 = if v34 <= v39 then v39 + v32 else v39
            local v41 = v40 / v33
            local v42 = v39 + Size.Y.Scale
            if v34 <= v42 then
                v42 += v32
            end
            local v43 = v42 / v33 - v41
            v38.Size = UDim2.new(Size.X, UDim.new(v43, Size.Y.Offset))
            v38.Position = UDim2.new(Position.X, UDim.new(v41 + Y * v43, Position.Y.Offset))
        end
    end
    v22.Size = UDim2.new(v22.Size.X, UDim.new(Scale_2 * Scale_3 / (Scale_3 + v32), 0))
    return v33
end

local function findRenderImage(v44) -- line 223
    local v45 = v44 and (v44:FindFirstChild("AnimalDisplay") or v44:FindFirstChild("ViewportFrame"))
    if not (v45 and v45:IsA("ImageLabel")) then
        return nil
    end
    return v45
end

local function topLayer(v46) -- line 230
    local Inner = v46:FindFirstChild("Inner")
    if not (Inner and Inner:IsA("ImageLabel")) then
        return v46
    end
    return Inner
end

local function applyRender(v47, v48) -- line 237 | captures: AnimalRenders
    if v47 then
        AnimalRenders.Apply(v47, v48)
        for v49, v50 in v47:GetDescendants() do
            if v50:IsA("ImageLabel") then
                AnimalRenders.Apply(v50, v48)
            end
        end
    end
end

local function setTileImage(v51) -- line 249 | captures: applyRender
    local Container = v51.Container
    Container = Container and (Container:FindFirstChild("AnimalDisplay") or Container:FindFirstChild("ViewportFrame"))
    if not (Container and Container:IsA("ImageLabel")) then
        Container = nil
    end
    applyRender(Container, v51.Name)
end

local function applyTileStroke(v52) -- line 256 | captures: v6, v7, v8, IndexConfig
    local Outer = v52.Container:FindFirstChild("Outer")
    if Outer and Outer:IsA("UIStroke") then
        if v7 == v52 then
            Outer.Color = IndexConfig.SelectedStrokeColor
        elseif v6[v52.Name] == "Ready" then
            Outer.Color = IndexConfig.ReadyStrokeColor
        elseif v8 then
            Outer.Color = v8
        end
    end
end

local function applyTileState(v53) -- line 272 | captures: v6, v7, v8, EggRewards, IndexConfig, RarityGradientFX
    local v54 = v6[v53.Name] ~= nil
    v53.Unlocked = v54
    local Container = v53.Container
    local v55 = EggRewards.DisplayName(v53.Name)
    local Name = Container:FindFirstChild("Name")
    if Name and Name:IsA("TextLabel") then
        if v54 then
            Name.Text = v55
        else
            Name.Text = IndexConfig.LockedName
        end
        local v56 = not v54 and IndexConfig.LockedGradientDarken or 0
        Name.TextColor3 = Color3.new(1, 1, 1):Lerp(Color3.new(0, 0, 0), v56)
    end
    local UIGradient = Container:FindFirstChild("UIGradient")
    if UIGradient and UIGradient:IsA("UIGradient") then
        local LockedGradientDarken
        if v54 then
        else
            LockedGradientDarken = IndexConfig.LockedGradientDarken
        end
        local Attach = RarityGradientFX.Attach
        local v57 = if EggRewards.RarityGradients[v53.Rarity] then v53.Rarity else "Common"
        local v58
        if not (LockedGradientDarken and LockedGradientDarken > 0) then
        else
            v58 = {
                Target = Color3.new(0, 0, 0),
                Alpha = LockedGradientDarken
            }
        end
        Attach(UIGradient, v57, v58)
    end
    Container = Container and (Container:FindFirstChild("AnimalDisplay") or Container:FindFirstChild("ViewportFrame"))
    if not (Container and Container:IsA("ImageLabel")) then
        Container = nil
    end
    if Container then
        local Inner = Container:FindFirstChild("Inner")
        if Inner then
            if not Inner:IsA("ImageLabel") then
                Inner = Container
            end
        else
            Inner = Container
        end
        if v54 then
            Inner.ImageColor3 = Color3.new(1, 1, 1)
            Inner.ImageTransparency = 0
        else
            Inner.ImageColor3 = IndexConfig.LockedImageColor
            Inner.ImageTransparency = IndexConfig.LockedImageTransparency
        end
        if Inner ~= Container then
            local BackTransparency = v53.BackTransparency
            if not v54 then
                BackTransparency = 1 - (1 - BackTransparency) * (1 - IndexConfig.LockedImageTransparency)
            end
            Container.ImageTransparency = BackTransparency
        end
    end
    local Outer = v53.Container:FindFirstChild("Outer")
    if Outer and Outer:IsA("UIStroke") then
        if v7 == v53 then
            Outer.Color = IndexConfig.SelectedStrokeColor
        elseif v6[v53.Name] == "Ready" then
            Outer.Color = IndexConfig.ReadyStrokeColor
        elseif v8 then
            Outer.Color = v8
        end
    end
end

local function sortWorstToBest(v59) -- line 329 | captures: IndexConfig
    table.sort(v59, function(v60, v61) -- line 330 | captures: IndexConfig
        local v62 = IndexConfig.RarityIndex(v60.Rarity)
        local v63 = IndexConfig.RarityIndex(v61.Rarity)
        if v62 == v63 then
            if (v60.Cash or 0) == (v61.Cash or 0) then
                return v60.Name < v61.Name
            end
            return (v60.Cash or 0) < (v61.Cash or 0)
        end
        return v62 < v63
    end)
end

local function zonedPool() -- line 344 | captures: EggRewards, IndexConfig
    local v64 = {}
    for v65, v66 in EggRewards.Pool do
        if not v66.IndexHidden then
            local v67 = v66.Zone or "Extras"
            local v68 = v64[v67]
            if not v68 then
                v68 = {}
                v64[v67] = v68
            end
            table.insert(v68, v66)
        end
    end
    local v69 = {}
    for v70 in v64 do
        if typeof(v70) == "number" then
            table.insert(v69, v70)
        end
    end
    table.sort(v69)
    local v71 = {}
    for v72, v73 in v69 do
        local v74 = v64[v73]
        table.sort(v74, function(v75, v76) -- line 330 | captures: IndexConfig
            local v77 = IndexConfig.RarityIndex(v75.Rarity)
            local v78 = IndexConfig.RarityIndex(v76.Rarity)
            if v77 == v78 then
                if (v75.Cash or 0) == (v76.Cash or 0) then
                    return v75.Name < v76.Name
                end
                return (v75.Cash or 0) < (v76.Cash or 0)
            end
            return v77 < v78
        end)
        local v79 = {
            Key = v73,
            Entries = v64[v73]
        }
        table.insert(v71, v79)
    end
    local Extras = v64.Extras
    if Extras then
        table.sort(Extras, function(v80, v81) -- line 330 | captures: IndexConfig
            local v82 = IndexConfig.RarityIndex(v80.Rarity)
            local v83 = IndexConfig.RarityIndex(v81.Rarity)
            if v82 == v83 then
                if (v80.Cash or 0) == (v81.Cash or 0) then
                    return v80.Name < v81.Name
                end
                return (v80.Cash or 0) < (v81.Cash or 0)
            end
            return v82 < v83
        end)
        local v84 = {
            Key = "Extras",
            Entries = Extras
        }
        table.insert(v71, v84)
    end
    return v71
end

local v85
local v86 = 0

local function adopt(v87) -- line 394 | captures: v6, v7, v8, v9, v85, v86, ReplicatedStorage, EggRewards, FloatingIconConfig, FormatNumber, IndexConfig, RarityGradientFX, HudBadge, FloatingIconFX, IndexBatRewards, v2, v3, v4, v5, showClaimPopup, lengthenSection, applyRender, applyTileState, zonedPool
    v86 += 1
    local v88 = v86
    if v85 then
        v85:Disconnect()
        v85 = nil
    end
    table.clear(v3)
    table.clear(v4)
    table.clear(v5)
    v7 = nil
    IndexBatRewards.Reset()
    local v89 = v87:WaitForChild("Frames", 10)
    local v90 = v89 and v89:FindFirstChild("Index")
    local v91
    if v90 and v88 == v86 then
        v91 = v87 and v87:FindFirstChild("LeftHUD")
    else
        return
    end
    local v92 = v91 and v91:FindFirstChild("Index")
    local v93 = HudBadge.Attach(v92 and v92:FindFirstChild("Notification"))

    local function refreshBadge() -- line 419 | captures: v93, v6, v4
        if not v93 then
            return
        end
        local v94 = 0
        for v95, v96 in v6 do
            if v96 == "Ready" and v4[v95] then
                v94 += 1
            end
        end
        v93.SetCount(v94)
    end

    local IndexList = v90:FindFirstChild("IndexList")
    local ScrollingFrame = IndexList and IndexList:FindFirstChild("ScrollingFrame") or v90:FindFirstChild("ScrollingFrame")
    if not (ScrollingFrame and ScrollingFrame:IsA("ScrollingFrame")) then
        return
    end
    local v97, v98
    for v99, v100 in ScrollingFrame:GetChildren() do
        if v100.Name == "Zone" and v100:IsA("Frame") then
            if v98 then
                v100:Destroy()
            else
                v97 = v100
                v98 = v100
            end
        end
    end
    if not v98 then
        return
    end
    v98.Visible = false
    local AnimalList = v98:FindFirstChild("AnimalList")
    local v101
    if AnimalList then
        local v102
        for v103, v104 in AnimalList:GetChildren() do
            if v104.Name == "Template" and v104:IsA("Frame") then
                if v102 then
                    v104:Destroy()
                else
                    v102 = v104
                end
            end
            v101 = v102
        end
    end
    if v101 then
        v101.Visible = false
        local UIListLayout = ScrollingFrame:FindFirstChildOfClass("UIListLayout")
        if UIListLayout then
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.FillDirection = Enum.FillDirection.Vertical
        end
        ScrollingFrame.CanvasSize = UDim2.new()
        ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local AnimalInfo = v90:FindFirstChild("AnimalInfo")
        local v105, v106, v107, v108
        if AnimalInfo then
            v108 = AnimalInfo:FindFirstChild("Name")
            v107 = AnimalInfo:FindFirstChild("Rarity")
            v106 = AnimalInfo:FindFirstChild("Earnings")
            v105 = AnimalInfo:FindFirstChild("AnimalDisplay") or AnimalInfo:FindFirstChild("ViewportFrame")
        else
            v108 = AnimalInfo
            v107 = AnimalInfo
            v106 = AnimalInfo
            v105 = AnimalInfo
        end
        if not (v105 and v105:IsA("ImageLabel")) then
            v105 = nil
        end
        local v109 = AnimalInfo and AnimalInfo:FindFirstChild("UIGradient")
        local Reward = v90:FindFirstChild("Reward")
        local v110 = Reward and Reward:FindFirstChild("List")
        local v111 = v110 and v110:FindFirstChild("Speed")
        local v112 = v111 and v111:FindFirstChild("Amount")
        local v113 = v110 and v110:FindFirstChild("Cash")
        local v114 = v113 and v113:FindFirstChild("Amount")
        local v115 = Reward and Reward:FindFirstChild("Claim")
        local v116 = v115 and v115:FindFirstChild("Title")
        local v117 = if not (v116 and v116:IsA("TextLabel")) then "Claim!" else v116.Text
        local v118 = v115 and v115:FindFirstChild("UiGradient")
        local Color
        if not (v118 and v118:IsA("UIGradient")) then
        else
            Color = v118.Color
        end
        local v119 = v101:FindFirstChild("Inner") and v101:FindFirstChild("Inner"):FindFirstChild("Outer")
        if not (v119 and v119:IsA("UIStroke")) then
            v8 = Color3.new(0, 0, 0)
        else
            v8 = v119.Color
        end
        local v120 = v108
        local v121 = v107
        local v122 = v106
        local v123 = v105
        local v124 = v117
        local Color_2 = Color

        local function refreshInfoPanels() -- line 528 | captures: v116, v118, v120, v121, v122, v123, v124, Color_2, v114, v112, v109, v6, v7, EggRewards, FormatNumber, IndexConfig, RarityGradientFX
            local v125 = v7
            if not v125 then
                return
            end
            local v126 = v6[v125.Name]
            local v127 = v126 ~= nil
            if v120 and v120:IsA("TextLabel") then
                local v128
                if v127 then
                    v128 = EggRewards.DisplayName(v125.Name)
                else
                    v128 = IndexConfig.LockedName
                end
                v120.Text = v128
                local v129 = not v127 and IndexConfig.LockedGradientDarken or 0
                v120.TextColor3 = Color3.new(1, 1, 1):Lerp(Color3.new(0, 0, 0), v129)
            end
            if v109 and v109:IsA("UIGradient") then
                local LockedGradientDarken
                if v127 then
                else
                    LockedGradientDarken = IndexConfig.LockedGradientDarken
                end
                local Attach = RarityGradientFX.Attach
                local v130 = if EggRewards.RarityGradients[v125.Rarity] then v125.Rarity else "Common"
                local v131
                if not (LockedGradientDarken and LockedGradientDarken > 0) then
                else
                    v131 = {
                        Target = Color3.new(0, 0, 0),
                        Alpha = LockedGradientDarken
                    }
                end
                Attach(v109, v130, v131)
            end
            if v121 and v121:IsA("TextLabel") then
                v121.Text = v125.Rarity
                if not RarityGradientFX.ApplyToLabel(v121, v125.Rarity) then
                    local v132 = EggRewards.RarityColors[v125.Rarity]
                    if v132 then
                        v121.TextColor3 = v132
                    end
                end
            end
            if v122 and v122:IsA("TextLabel") then
                local v133
                if v127 then
                    v133 = ("$%*/s"):format((FormatNumber.Short(EggRewards.CashPerSecond(v125.Name))))
                else
                    v133 = IndexConfig.LockedName
                end
                v122.Text = v133
            end
            if v123 then
                local v134 = v123
                local Inner = v123:FindFirstChild("Inner")
                if Inner and Inner:IsA("ImageLabel") then
                    v134 = Inner
                end
                if v127 then
                    v134.ImageColor3 = Color3.new(1, 1, 1)
                    v134.ImageTransparency = 0
                else
                    v134.ImageColor3 = IndexConfig.LockedImageColor
                    v134.ImageTransparency = IndexConfig.LockedImageTransparency
                end
            end
            local v135 = IndexConfig.Reward(v125.Rarity, v125.Name)
            if v112 and v112:IsA("TextLabel") then
                v112.Text = ("+%*"):format((FormatNumber.Short(v135.Speed)))
            end
            if v114 and v114:IsA("TextLabel") then
                v114.Text = ("$%*"):format((FormatNumber.Short(v135.Cash)))
            end
            if v116 and v116:IsA("TextLabel") then
                local v136 = if v126 == "Claimed" then IndexConfig.ClaimClaimedText else v124
                v116.Text = v136
            end
            if v118 and v118:IsA("UIGradient") and Color_2 then
                local v137 = if v126 == "Ready" then IndexConfig.ClaimReadyGradient else Color_2
                v118.Color = v137
            end
        end

        local function setInfoImage(v138) -- line 604 | captures: v123, applyRender
            applyRender(v123, v138.Name)
        end

        local function selectTile(v139) -- line 608 | captures: refreshInfoPanels, v123, v6, v7, v8, IndexConfig, applyRender
            if v7 == v139 then
                return
            end
            local v140 = v7
            v7 = v139
            if v140 then
                local Outer = v140.Container:FindFirstChild("Outer")
                if Outer and Outer:IsA("UIStroke") then
                    if v7 == v140 then
                        Outer.Color = IndexConfig.SelectedStrokeColor
                    elseif v6[v140.Name] == "Ready" then
                        Outer.Color = IndexConfig.ReadyStrokeColor
                    elseif v8 then
                        Outer.Color = v8
                    end
                end
            end
            local Outer = v139.Container:FindFirstChild("Outer")
            if Outer and Outer:IsA("UIStroke") then
                if v7 == v139 then
                    Outer.Color = IndexConfig.SelectedStrokeColor
                elseif v6[v139.Name] == "Ready" then
                    Outer.Color = IndexConfig.ReadyStrokeColor
                elseif v8 then
                    Outer.Color = v8
                end
            end
            applyRender(v123, v139.Name)
            refreshInfoPanels()
        end

        if v115 and v115:IsA("GuiButton") then
            v115.Activated:Connect(function() -- line 627 | captures: v6, v7, v9
                local v141 = v7
                if v141 and v6[v141.Name] == "Ready" then
                    local Name = v141.Name
                    if v9 then
                        v9:FireServer("Claim", Name)
                    end
                end
            end)
        end

        local function buildZones() -- line 639 | captures: v97, ScrollingFrame, refreshInfoPanels, v123, v6, v7, v8, FloatingIconConfig, IndexConfig, FloatingIconFX, IndexBatRewards, v2, v3, v4, v5, lengthenSection, applyRender, applyTileState, zonedPool
            for v142, v143 in zonedPool() do
                local v144 = v97:Clone()
                local Key = v143.Key
                if typeof(Key) == "number" then
                    v144.Name = ("Zone%*"):format(v143.Key)
                else
                    v144.Name = "Extras"
                end
                v144.LayoutOrder = v142
                v144.Visible = true
                local ZoneImage = v144:FindFirstChild("ZoneImage")
                local Key_2 = v143.Key
                local v145 = if typeof(Key_2) == "number" then v2[v143.Key] else nil
                if v145 and ZoneImage and ZoneImage:IsA("ImageLabel") then
                    ZoneImage.Image = v145
                end
                local AnimalList = v144:FindFirstChild("AnimalList")
                local v146, v147
                if AnimalList then
                    v147 = AnimalList:FindFirstChild("Template")
                    v146 = AnimalList:FindFirstChildOfClass("UIListLayout")
                else
                    v147 = AnimalList
                    v146 = AnimalList
                end
                if v146 then
                    v146.SortOrder = Enum.SortOrder.LayoutOrder
                end
                local CompletionBar = v144:FindFirstChild("CompletionBar")
                IndexBatRewards.AttachSection(v144, v143.Key)
                local v148
                if CompletionBar then
                    v148 = CompletionBar:FindFirstChild("Amount")
                    CompletionBar = CompletionBar:FindFirstChild("BarConstraint")
                else
                    v148 = CompletionBar
                end
                local v149 = CompletionBar and CompletionBar:FindFirstChild("Bar")
                local v150 = {
                    HeightScale = 1,
                    Key = v143.Key,
                    Frame = v144,
                    Tiles = {}
                }
                if not (v148 and v148:IsA("TextLabel")) then
                    v148 = nil
                end
                v150.Amount = v148
                if not (v149 and v149:IsA("GuiObject")) then
                    v149 = nil
                end
                v150.Bar = v149
                if v147 and v147:IsA("Frame") then
                    if AnimalList and AnimalList:IsA("GuiObject") then
                        v150.HeightScale = lengthenSection(v144, AnimalList, v147, #v143.Entries)
                        if v150.HeightScale > 1 and ZoneImage and ZoneImage:IsA("ImageLabel") then
                            ZoneImage.ScaleType = Enum.ScaleType.Crop
                        end
                    end
                    for v151, v152 in v143.Entries do
                        local v153 = v147:Clone()
                        v153.Name = v152.Name
                        v153.LayoutOrder = v151
                        v153.Visible = true
                        local Inner = v153:FindFirstChild("Inner")
                        if Inner and Inner:IsA("TextButton") then
                            local v154 = Inner:FindFirstChild("AnimalDisplay") or Inner:FindFirstChild("ViewportFrame")
                            if not (v154 and v154:IsA("ImageLabel")) then
                                v154 = nil
                            end
                            local v155 = {
                                Unlocked = false,
                                Frame = v153,
                                Container = Inner,
                                Name = v152.Name,
                                Rarity = v152.Rarity
                            }
                            local v156 = if v154 then v154.ImageTransparency else 0
                            v155.BackTransparency = v156
                            local Container = v155.Container
                            Container = Container and (Container:FindFirstChild("AnimalDisplay") or Container:FindFirstChild("ViewportFrame"))
                            if not (Container and Container:IsA("ImageLabel")) then
                                Container = nil
                            end
                            applyRender(Container, v155.Name)
                            if v154 and v154:FindFirstChild("Inner") then
                                FloatingIconFX.Attach(v154, FloatingIconConfig.Styles.AnimalTile, Inner)
                            end
                            Inner.Activated:Connect(function() -- line 717 | captures: v155, refreshInfoPanels, v123, v6, v7, v8, IndexConfig, applyRender
                                if v7 == v155 then
                                    return
                                end
                                local v157 = v7
                                v7 = v155
                                if v157 then
                                    local Outer = v157.Container:FindFirstChild("Outer")
                                    if Outer and Outer:IsA("UIStroke") then
                                        if v7 == v157 then
                                            Outer.Color = IndexConfig.SelectedStrokeColor
                                        elseif v6[v157.Name] == "Ready" then
                                            Outer.Color = IndexConfig.ReadyStrokeColor
                                        elseif v8 then
                                            Outer.Color = v8
                                        end
                                    end
                                end
                                local Outer = v155.Container:FindFirstChild("Outer")
                                if Outer and Outer:IsA("UIStroke") then
                                    if v7 == v155 then
                                        Outer.Color = IndexConfig.SelectedStrokeColor
                                    elseif v6[v155.Name] == "Ready" then
                                        Outer.Color = IndexConfig.ReadyStrokeColor
                                    elseif v8 then
                                        Outer.Color = v8
                                    end
                                end
                                applyRender(v123, v155.Name)
                                refreshInfoPanels()
                            end)
                            applyTileState(v155)
                            v153.Parent = AnimalList
                            table.insert(v3, v155)
                            local Tiles = v150.Tiles
                            table.insert(Tiles, v155)
                            v4[v152.Name] = v155
                        else
                            v153:Destroy()
                        end
                    end
                    v147:Destroy()
                end
                v144.Parent = ScrollingFrame
                table.insert(v5, v150)
            end
        end

        local Scale = v97.Size.X.Scale
        local Scale_2 = v97.Size.Y.Scale
        local UiFrameScale

        local function zoneSize() -- line 749 | captures: ScrollingFrame, Scale, Scale_2
            local AbsoluteWindowSize = ScrollingFrame.AbsoluteWindowSize
            local fromOffset = UDim2.fromOffset
            local v158 = AbsoluteWindowSize.X * Scale
            local v159 = math.floor(v158)
            local v160 = math.max(v159, 1)
            local v161 = AbsoluteWindowSize.Y * Scale_2
            local v162 = math.floor(v161)
            return fromOffset(v160, (math.max(v162, 1)))
        end

        local v163

        local function refitZones() -- line 757 | captures: UiFrameScale, v163, v90, ScrollingFrame, Scale, Scale_2, v5
            if UiFrameScale == nil then
                local UiFrameScale_2 = v90:FindFirstChild("UiFrameScale")
                if UiFrameScale_2 and UiFrameScale_2:IsA("UIScale") then
                    UiFrameScale = UiFrameScale_2
                end
            end
            if UiFrameScale ~= nil and UiFrameScale.Scale ~= 1 then
                return
            end
            local AbsoluteWindowSize = ScrollingFrame.AbsoluteWindowSize
            local fromOffset = UDim2.fromOffset
            local v164 = AbsoluteWindowSize.X * Scale
            local v165 = math.floor(v164)
            local v166 = math.max(v165, 1)
            local v167 = AbsoluteWindowSize.Y * Scale_2
            local v168 = math.floor(v167)
            local v169 = fromOffset(v166, (math.max(v168, 1)))
            if v169 ~= v163 then
                v163 = v169
                for v170, v171 in v5 do
                    local Frame = v171.Frame
                    if v171.HeightScale > 1 then
                        local fromOffset = UDim2.fromOffset
                        local Offset = v169.X.Offset
                        local v172 = v169.Y.Offset * v171.HeightScale
                        Frame.Size = fromOffset(Offset, (math.floor(v172)))
                    else
                        Frame.Size = v169
                    end
                end
            end
        end

        buildZones()
        refitZones()
        ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(refitZones)
        local v173, v174
        if v3[1] then
            v173 = v3[1]
            if v7 == v173 then
                v174 = true
            else
                local v175 = v7
                v7 = v173
                if v175 then
                    local Outer = v175.Container:FindFirstChild("Outer")
                    if Outer and Outer:IsA("UIStroke") then
                        if v7 == v175 then
                            Outer.Color = IndexConfig.SelectedStrokeColor
                        elseif v6[v175.Name] == "Ready" then
                            Outer.Color = IndexConfig.ReadyStrokeColor
                        elseif v8 then
                            Outer.Color = v8
                        end
                    end
                end
                v174 = false
            end
        else
            v174 = true
        end
        if not v174 then
            local Outer = v173.Container:FindFirstChild("Outer")
            if Outer and Outer:IsA("UIStroke") then
                if v7 == v173 then
                    Outer.Color = IndexConfig.SelectedStrokeColor
                elseif v6[v173.Name] == "Ready" then
                    Outer.Color = IndexConfig.ReadyStrokeColor
                elseif v8 then
                    Outer.Color = v8
                end
            end
            applyRender(v105, v173.Name)
            refreshInfoPanels()
        end
        local CompletionBar = v90:FindFirstChild("CompletionBar")
        local v176, v177
        if CompletionBar then
            v177 = CompletionBar:FindFirstChild("Amount")
            v176 = CompletionBar:FindFirstChild("BarConstraint")
        else
            v177 = CompletionBar
            v176 = CompletionBar
        end
        local v178 = v176 and v176:FindFirstChild("Bar")
        local v179 = CompletionBar and CompletionBar:FindFirstChild("Claim")
        local v180 = v177

        local function refreshCompletion() -- line 799 | captures: v180, v179, v178, v6, IndexBatRewards, v3, v5
            local v181 = 0
            local v182 = 0
            for v183, v184 in v5 do
                local v185 = 0
                for v186, v187 in v184.Tiles do
                    local v188 = v6[v187.Name]
                    if v188 ~= nil then
                        v185 += 1
                    end
                    if v188 == "Ready" then
                        v182 += 1
                    end
                end
                v181 += v185
                if v184.Amount then
                    v184.Amount.Text = ("%*/%*"):format(v185, #v184.Tiles)
                end
                local Bar = v184.Bar
                local v189 = if #v184.Tiles > 0 then v185 / #v184.Tiles else 0
                if Bar then
                    Bar.AnchorPoint = Vector2.new(0, 0.5)
                    Bar.Position = UDim2.fromScale(0, 0.5)
                    Bar.Size = UDim2.fromScale(math.clamp(v189, 0, 1), 1)
                end
            end
            if v180 and v180:IsA("TextLabel") then
                local v190
                if v182 > 0 then
                    v190 = ("Claim!(%*)"):format(v182)
                else
                    v190 = ("Unlocked: %*/%*"):format(v181, #v3)
                end
                v180.Text = v190
            end
            if v178 and v178:IsA("GuiObject") then
                local v191 = if #v3 > 0 then v181 / #v3 else 0
                if v178 then
                    v178.AnchorPoint = Vector2.new(0, 0.5)
                    v178.Position = UDim2.fromScale(0, 0.5)
                    v178.Size = UDim2.fromScale(math.clamp(v191, 0, 1), 1)
                end
            end
            if v179 and v179:IsA("GuiButton") then
                local v192 = v182 > 0
                v179.Visible = v192
            end
            IndexBatRewards.Refresh(v6)
        end

        refreshCompletion()
        if v179 and v179:IsA("GuiButton") then
            v179.Activated:Connect(function() -- line 838 | captures: v9
                if v9 then
                    v9:FireServer("ClaimAll", nil)
                end
            end)
        end
        local v193 = ReplicatedStorage:WaitForChild("IndexRemote", 30)
        if v88 == v86 and v193 and v193:IsA("RemoteEvent") then
            v9 = v193
            v85 = v193.OnClientEvent:Connect(function(v194, v195) -- line 859 | captures: v93, refreshInfoPanels, refreshCompletion, v6, IndexConfig, v3, v4, showClaimPopup, applyTileState
                if not (v194 == "State" and typeof(v195) == "table") then
                    return
                end
                local v196 = v6
                v6 = v195
                for v197, v198 in v3 do
                    applyTileState(v198)
                end
                refreshCompletion()
                if v93 then
                    local v199 = 0
                    for v200, v201 in v6 do
                        if v201 == "Ready" and v4[v200] then
                            v199 += 1
                        end
                    end
                    v93.SetCount(v199)
                end
                refreshInfoPanels()
                local v202 = {
                    Cash = 0,
                    Speed = 0
                }
                for v203, v204 in v195 do
                    if v204 == "Claimed" and v196[v203] == "Ready" then
                        local v205 = v4[v203]
                        if v205 then
                            local v206 = IndexConfig.Reward(v205.Rarity, v205.Name)
                            v202.Cash += v206.Cash
                            v202.Speed += v206.Speed
                        end
                    end
                end
                if v202.Cash > 0 or v202.Speed > 0 then
                    showClaimPopup(v202)
                end
            end)
            if v9 then
                v9:FireServer("Get", nil)
            end
        end
    end
end

function v1.Start() -- line 896 | captures: MainGui, adopt
    MainGui.Observe(adopt)
end

return v1
