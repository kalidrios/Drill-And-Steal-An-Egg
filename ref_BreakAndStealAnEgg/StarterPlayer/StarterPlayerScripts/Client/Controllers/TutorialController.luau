-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local AnimalOverhead = require(ReplicatedStorage.Shared.AnimalOverhead)
local CountingNumber = require(ReplicatedStorage.Shared.CountingNumber)
local EggRarity = require(ReplicatedStorage.Shared.EggRarity)
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local TrailsConfig = require(ReplicatedStorage.Shared.TrailsConfig)
local TutorialConfig = require(ReplicatedStorage.Shared.TutorialConfig)
local SafeZoneQuery = require(ReplicatedStorage.Shared.SafeZoneQuery)
local EggLocalHits = require(script.Parent.EggLocalHits)
local TutorialArrow = require(script.Parent.TutorialArrow)
local TutorialScreenArrow = require(script.Parent.TutorialScreenArrow)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local BackpackController = require(script.Parent.BackpackController)
local TutorialUiArrow = require(script.Parent.TutorialUiArrow)
local UiFrames = require(script.Parent.UiFrames)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function hotbarToolCount() -- line 127 | captures: LocalPlayer
    local v3 = 0
    for v4, v5 in {
            LocalPlayer:FindFirstChildOfClass("Backpack"),
            LocalPlayer.Character
        } do
        if v5 then
            local v6 = v3
            for v7, v8 in v5:GetChildren() do
                if v8:IsA("Tool") then
                    v6 += 1
                end
                v3 = v6
            end
        end
    end
    return v3
end

local function pickaxeSlotOffset() -- line 147 | captures: hotbarToolCount
    local v9 = hotbarToolCount() - 1
    local v10 = math.max(v9, 0) * 66 / 2
    return -math.floor(v10)
end

local function lastSlotOffset() -- line 154 | captures: hotbarToolCount
    local v11 = hotbarToolCount() - 1
    local v12 = math.max(v11, 0) * 66 / 2
    return (math.floor(v12))
end

local v13 = 0
local v14, v15

local function getMainGui() -- line 165 | captures: LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v16 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if v16 and v16:IsA("ScreenGui") then
        return v16
    end
    return nil
end

local function getMessagesFrame() -- line 174 | captures: LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v17 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if not (v17 and v17:IsA("ScreenGui")) then
        v17 = nil
    end
    local v18 = v17 and v17:FindFirstChild("Messages")
    if v18 and v18:IsA("Frame") then
        return v18
    end
    return nil
end

local function ensureMessage() -- line 210 | captures: v14, v15, LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v19 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if not (v19 and v19:IsA("ScreenGui")) then
        v19 = nil
    end
    local v20 = v19 and v19:FindFirstChild("Messages")
    if not (v20 and v20:IsA("Frame")) then
        v20 = nil
    end
    if v20 then
        if v20 ~= v14 then
            v14 = v20
            v15 = nil
        end
        if v15 and v15.Parent == v20 then
            return v15
        end
        local Message = v20:FindFirstChild("Message")
        local v21, Texts, v22
        if Message and Message:IsA("CanvasGroup") then
            v21 = Message:Clone()
            v21.Name = "TutorialMessage"
            v21.Visible = false
            v21.GroupTransparency = 0
            v21.Size = UDim2.new(1.6, 0, v21.Size.Y.Scale, v21.Size.Y.Offset)
            Texts = v21:FindFirstChild("Texts")
            v22 = Texts and Texts:FindFirstChild("Icon")
        else
            return nil
        end
        if v22 and v22:IsA("ImageLabel") then
            v22.Visible = false
        end
        local v23 = Texts and Texts:FindFirstChild("Main")
        if v23 and v23:IsA("TextLabel") then
            v23.TextWrapped = false
            v23.RichText = true
            v23.AutomaticSize = Enum.AutomaticSize.None
            v23.Size = UDim2.new(1, 0, v23.Size.Y.Scale, v23.Size.Y.Offset)
            v23.TextScaled = true
            local UITextSizeConstraint = v23:FindFirstChildOfClass("UITextSizeConstraint")
            if UITextSizeConstraint then
                UITextSizeConstraint:Destroy()
            end
        end
        v21.Parent = v20
        v15 = v21
        return v21
    end
    return nil
end

local v24, v25

local function cancelHideTween() -- line 280 | captures: v25
    if v25 then
        v25:Cancel()
        v25 = nil
    end
end

local function showText(v26) -- line 287 | captures: v13, v24, v25, TutorialConfig, ensureMessage
    local v27 = ensureMessage()
    if not v27 then
        return
    end
    if v25 then
        v25:Cancel()
        v25 = nil
    end
    v13 += 1
    local v28 = v13
    local Texts = v27:FindFirstChild("Texts")
    local v29 = Texts and Texts:FindFirstChild("Main")
    if v29 and v29:IsA("TextLabel") then
        if v24 == v26 and v27.Visible and v29.Text == v26 then
            v29.MaxVisibleGraphemes = -1
        else
            v24 = v26
            v29.Text = v26
            v29.MaxVisibleGraphemes = 0
            v27.GroupTransparency = 0
            v27.Visible = true
            local v30 = string.gsub(v26, "<[^<>]->", "")
            local v31 = utf8.len(v30) or #v30
            task.spawn(function() -- line 322 | captures: v27, v28, v29, v31, v13, TutorialConfig
                for v32 = 1, v31 do
                    if not (v13 == v28 and v27.Parent) then
                        return
                    end
                    v29.MaxVisibleGraphemes = v32
                    task.wait(TutorialConfig.TypewriterInterval)
                end
            end)
        end
    end
end

local function hideMessage() -- line 333 | captures: v13, v15, v24, v25, TweenService, v2
    v24 = nil
    v13 += 1
    local v33 = v13
    local v34 = v15
    if v34 and v34.Parent and v34.Visible then
        if v25 then
            v25:Cancel()
            v25 = nil
        end
    else
        return
    end
    v25 = TweenService:Create(v34, v2, { GroupTransparency = 1 })
    v25:Play()
    task.delay(v2.Time, function() -- line 347 | captures: v33, v34, v13, v15
        if v13 == v33 and v34.Parent then
            v34:Destroy()
            if v15 == v34 then
                v15 = nil
            end
        end
    end)
end

local function earnedCashNow() -- line 366 | captures: TutorialConfig, LocalPlayer
    local v35 = LocalPlayer:GetAttribute(TutorialConfig.EarnBaselineAttribute)
    if typeof(v35) ~= "number" then
        v35 = 0
    end
    local Cash = LocalPlayer:GetAttribute("Cash")
    if typeof(Cash) ~= "number" then
        Cash = 0
    end
    local v36 = Cash - v35
    local v37 = math.floor(v36)
    local EarnCashTarget = TutorialConfig.EarnCashTarget
    return (math.clamp(v37, 0, EarnCashTarget))
end

local function heldCash() -- line 380 | captures: LocalPlayer
    local Cash = LocalPlayer:GetAttribute("Cash")
    if typeof(Cash) == "number" then
        local v38 = math.floor(Cash)
        return (math.max(v38, 0))
    end
    return 0
end

local function cheapestTrailPrice() -- line 387 | captures: TrailsConfig
    local v39 = (1/0)
    for v40, v41 in TrailsConfig.Trails do
        local Price = v41.Price
        v39 = math.min(v39, Price)
    end
    if v39 == (1/0) then
        return 0
    end
    return v39
end

local function cashProgressFor(v42) -- line 403 | captures: TrailsConfig, TutorialConfig, LocalPlayer, earnedCashNow
    if v42 == "EarnCash" then
        return {
            Format = TutorialConfig.EarnCashTextFormat,
            Target = TutorialConfig.EarnCashTarget,
            Current = earnedCashNow
        }
    end
    local v43 = TutorialConfig.SaveUpTextFormats[v42]
    if v43 then
        local v44 = (1/0)
        for v45, v46 in TrailsConfig.Trails do
            local Price = v46.Price
            v44 = math.min(v44, Price)
        end
        if v44 == (1/0) then
            v44 = 0
        end
        local v47 = {
            Format = v43,
            Target = v44
        }
        local v48 = v44

        function v47.Current() -- line 415 | captures: v48, LocalPlayer
            local Cash = LocalPlayer:GetAttribute("Cash")
            local v49
            if typeof(Cash) == "number" then
                local v50 = math.floor(Cash)
                v49 = math.max(v50, 0)
            else
                v49 = 0
            end
            return (math.min(v49, v48))
        end

        v47.FullText = TutorialConfig.TextFor("BuyTrail")
        return v47
    end
    return nil
end

local v51

local function formatProgressText(v52, v53) -- line 425
    local v54 = v53 + 0.5
    local v55 = math.floor(v54)
    local Target = v52.Target
    local v56 = math.clamp(v55, 0, Target)
    if v52.FullText and v52.Target > 0 and v52.Target <= v56 then
        return v52.FullText
    end
    return string.format(v52.Format, v56, v52.Target)
end

local v57, v58

local function applyEarnCashCount(v59) -- line 444 | captures: v13, v15, v51
    local v60 = v15
    local v61 = v60 and v60:FindFirstChild("Texts")
    local v62 = v61 and v61:FindFirstChild("Main")
    if not (v60 and v60.Visible and v62 and v62:IsA("TextLabel")) then
        return
    end
    local v63 = v51
    if not v63 then
        return
    end
    v13 += 1
    local v64 = v59 + 0.5
    local v65 = math.floor(v64)
    local Target = v63.Target
    local v66 = math.clamp(v65, 0, Target)
    if v63.FullText and v63.Target > 0 and v63.Target <= v66 then
        v62.Text = v63.FullText
    else
        v62.Text = string.format(v63.Format, v66, v63.Target)
    end
    v62.MaxVisibleGraphemes = -1
end

local function hotbarPlacement(v67) -- line 466 | captures: LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v68 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if not (v68 and v68:IsA("ScreenGui")) then
        v68 = nil
    end
    if v68 then
        local AbsolutePosition = v68.AbsolutePosition
        local AbsoluteSize = v68.AbsoluteSize
        return {
            pointUp = false,
            x = AbsolutePosition.X + AbsoluteSize.X / 2 + v67,
            y = AbsolutePosition.Y + AbsoluteSize.Y - 82
        }
    end
    return nil
end

local function toolSlotPlacement(v69, v70, v71) -- line 483 | captures: BackpackController, hotbarPlacement
    local v72 = BackpackController.FindHotbarSlot(v69, v70)
    if v72 then
        local AbsolutePosition = v72.AbsolutePosition
        local AbsoluteSize = v72.AbsoluteSize
        return {
            pointUp = false,
            x = AbsolutePosition.X + AbsoluteSize.X / 2,
            y = AbsolutePosition.Y
        }
    end
    return (hotbarPlacement(v71()))
end

local function isPickaxeTool(v73) -- line 500 | captures: PickaxeConfig
    return v73.Name == PickaxeConfig.ToolName
end

local function underButtonPlacement(v74) -- line 506
    if v74 then
        return {
            pointUp = true,
            x = v74.AbsolutePosition.X + v74.AbsoluteSize.X / 2,
            y = v74.AbsolutePosition.Y + v74.AbsoluteSize.Y
        }
    end
    return nil
end

local function getRoot() -- line 533 | captures: LocalPlayer
    local Character = LocalPlayer.Character
    local v75 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v75 and v75:IsA("BasePart") then
        return v75
    end
    return nil
end

local v76
local v77 = 0
local v78, Highlight

local function setHighlightedEgg(v79) -- line 573 | captures: Highlight
    local v80 = v79 and v79:FindFirstAncestorOfClass("Model")
    if not (v80 and v80.PrimaryPart == v79) then
        v80 = v79
    end
    if Highlight and (Highlight.Adornee ~= v80 or Highlight.Parent == nil) then
        Highlight:Destroy()
        Highlight = nil
    end
    if not v80 or Highlight then
        return
    end
    local Highlight_2 = Instance.new("Highlight")
    Highlight_2.Name = "TutorialEggHighlight"
    Highlight_2.FillColor = Color3.fromRGB(255, 255, 0)
    Highlight_2.FillTransparency = 1
    Highlight_2.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight_2.OutlineTransparency = 0
    Highlight_2.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight_2.Adornee = v80
    Highlight_2.Parent = v80
    Highlight = Highlight_2
end

local function eggIsLive(v81) -- line 599
    if v81 == nil or v81.Parent == nil then
        return false
    end
    return not v81:GetAttribute("Broken") and not v81:GetAttribute("Hatching")
end

local function isBasicEgg(v82) -- line 613 | captures: EggRarity, TutorialConfig
    return EggRarity.IsPlainStarterEgg(v82, TutorialConfig.StrongEggMinTier)
end

local function isMyFirstEgg(v83) -- line 619 | captures: TutorialConfig, LocalPlayer
    return v83:GetAttribute(TutorialConfig.FirstEggAttribute) == LocalPlayer.UserId
end

local function isStrongerEgg(v84) -- line 625 | captures: EggRarity, TutorialConfig
    return EggRarity.IsStrongerEgg(v84:GetAttribute("EggType"), TutorialConfig.StrongEggMinTier)
end

local function eggIsFresh(v85) -- line 631
    local Health = v85:GetAttribute("Health")
    local MaxHealth = v85:GetAttribute("MaxHealth")
    if typeof(Health) == "number" and typeof(MaxHealth) == "number" then
        return MaxHealth <= Health
    end
    return false
end

local function findEggTarget(v86, v87, v88) -- line 639 | captures: v76, v77, v78, CollectionService, LocalPlayer, setHighlightedEgg
    local Character = LocalPlayer.Character
    local v89 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (v89 and v89:IsA("BasePart")) then
        v89 = nil
    end
    if v89 then
        local v90 = v78
        local v91 = if v90 == nil or v90.Parent == nil then false else not v90:GetAttribute("Broken") and not v90:GetAttribute("Hatching")
        if v91 and (not v86 or v86(v78)) then
            setHighlightedEgg(v78)
            return v78.Position
        end
        v78 = nil
        local v92 = os.clock()
        local v93 = v76
        local v94 = if v93 == nil or v93.Parent == nil then false else not v93:GetAttribute("Broken") and not v93:GetAttribute("Hatching")
        v94 = v94 and (not v86 or v86(v76))
        if v92 - v77 >= 0.25 or not v94 then
            v77 = v92
            local v95
            local v96 = false
            local v97 = false
            local v98 = (1/0)
            for v99, v100 in CollectionService:GetTagged("BreakableEgg") do
                if v100:IsA("BasePart") and not (v100 == nil or v100.Parent == nil) and not v100:GetAttribute("Broken") and not v100:GetAttribute("Hatching") then
                    if v86 then
                        if v86(v100) then
                            local v101
                            if v88 == nil then
                                v101 = false
                            else
                                v101 = v88(v100)
                            end
                            local Health = v100:GetAttribute("Health")
                            local MaxHealth = v100:GetAttribute("MaxHealth")
                            local v102 = if typeof(Health) == "number" and typeof(MaxHealth) == "number" then not not (MaxHealth <= Health) else false
                            local Magnitude = (v100.Position - v89.Position).Magnitude
                            local v103
                            if v101 == v97 then
                                if v87 then
                                    if v102 then
                                        v103 = not v96
                                        if not v103 then
                                            if v102 == v96 then
                                                v103 = not not (Magnitude < v98)
                                            else
                                                v103 = false
                                            end
                                        end
                                    elseif v102 == v96 then
                                        v103 = not not (Magnitude < v98)
                                    else
                                        v103 = false
                                    end
                                else
                                    v103 = not not (Magnitude < v98)
                                end
                            else
                                v103 = v101
                            end
                            if v103 then
                                v95 = v100
                                v96 = v102
                                v97 = v101
                                v98 = Magnitude
                            end
                        end
                    else
                        local v104
                        if v88 == nil then
                            v104 = false
                        else
                            v104 = v88(v100)
                        end
                        local Health = v100:GetAttribute("Health")
                        local MaxHealth = v100:GetAttribute("MaxHealth")
                        local v105 = if typeof(Health) == "number" and typeof(MaxHealth) == "number" then not not (MaxHealth <= Health) else false
                        local Magnitude = (v100.Position - v89.Position).Magnitude
                        local v106
                        if v104 == v97 then
                            if v87 then
                                if v105 then
                                    v106 = not v96
                                    if not v106 then
                                        if v105 == v96 then
                                            v106 = not not (Magnitude < v98)
                                        else
                                            v106 = false
                                        end
                                    end
                                elseif v105 == v96 then
                                    v106 = not not (Magnitude < v98)
                                else
                                    v106 = false
                                end
                            else
                                v106 = not not (Magnitude < v98)
                            end
                        else
                            v106 = v104
                        end
                        if v106 then
                            v95 = v100
                            v96 = v105
                            v97 = v104
                            v98 = Magnitude
                        end
                    end
                end
            end
            v76 = v95
        end
        setHighlightedEgg(v76)
        if v76 then
            return v76.Position
        end
    end
    return nil
end

local function nearestEggTarget() -- line 693 | captures: isBasicEgg, isMyFirstEgg, findEggTarget
    return (findEggTarget(isBasicEgg, false, isMyFirstEgg))
end

local function strongerEggTarget() -- line 697 | captures: isStrongerEgg, findEggTarget
    return (findEggTarget(isStrongerEgg, true))
end

local v107
local v108 = 0

local function nearestPickupTarget() -- line 708 | captures: v107, v108, CollectionService, TutorialConfig, LocalPlayer
    local Character = LocalPlayer.Character
    local v109 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (v109 and v109:IsA("BasePart")) then
        v109 = nil
    end
    if v109 then
        local v110 = os.clock()
        local v111
        if v107 == nil then
            v111 = false
        else
            v111 = TutorialConfig.IsStealTarget(v107, LocalPlayer.UserId)
        end
        if v110 - v108 >= 0.25 or not v111 then
            v108 = v110
            local v112
            local v113 = (1/0)
            local v114
            for v115, v116 in CollectionService:GetTagged("AnimalPickup") do
                if TutorialConfig.IsStealTarget(v116, LocalPlayer.UserId) then
                    if v116:GetAttribute(TutorialConfig.ReservedAttribute) == LocalPlayer.UserId then
                        v114 = v116
                        break
                    end
                    local Magnitude = (v116:GetPivot().Position - v109.Position).Magnitude
                    if Magnitude < v113 then
                        v112 = v116
                        v113 = Magnitude
                    end
                end
                v114 = v112
            end
            v107 = v114
        end
        if not (v107 and TutorialConfig.IsStealTarget(v107, LocalPlayer.UserId)) then
            return nil
        end
        return v107:GetPivot().Position
    end
    return nil
end

local v117
local v118 = 0
local v119 = false
local v120 = false

local function reservedPickupTarget() -- line 760 | captures: v117, v118, v119, v120, CollectionService, TutorialConfig, LocalPlayer, showText, hideMessage
    local v121 = os.clock()
    local v122 = v117
    local v123 = if v122 == nil or v122.Parent == nil then false else v122:GetAttribute(TutorialConfig.ReservedAttribute) == LocalPlayer.UserId
    local Character, v124
    if v121 - v118 >= 0.25 then
        v118 = v121
        Character = LocalPlayer.Character
        Character = Character and Character:FindFirstChild("HumanoidRootPart")
        v124 = false
    elseif v123 then
        v124 = true
    else
        v118 = v121
        Character = LocalPlayer.Character
        Character = Character and Character:FindFirstChild("HumanoidRootPart")
        v124 = false
    end
    if not v124 then
        if not (Character and Character:IsA("BasePart")) then
            Character = nil
        end
        local v125
        local v126 = (1/0)
        for v127, v128 in CollectionService:GetTagged("AnimalPickup") do
            if v128:IsA("Model") and v128.Parent and v128:GetAttribute(TutorialConfig.ReservedAttribute) == LocalPlayer.UserId then
                local v129 = if Character then (v128:GetPivot().Position - Character.Position).Magnitude else 0
                if v129 < v126 then
                    v125 = v128
                    v126 = v129
                end
            end
        end
        v117 = v125
    end
    local v130 = v117
    if v130 then
        v119 = true
        if v120 then
            v120 = false
            showText(TutorialConfig.TextFor("CollectStrongerAnimal") or "")
        end
    elseif v119 then
        v119 = false
        v120 = true
        hideMessage()
    end
    if not (v130 and v130.Parent) then
        return nil
    end
    return v130:GetPivot().Position
end

local function getOwnPlot() -- line 805 | captures: LocalPlayer
    local Plots = workspace:FindFirstChild("Plots")
    if Plots then
        for v131, v132 in Plots:GetChildren() do
            if v132:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                return v132
            end
        end
    end
    return nil
end

local function getOwnPenHitbox() -- line 818 | captures: getOwnPlot
    local v133 = getOwnPlot()
    local v134 = v133 and v133:FindFirstChild("Hitbox")
    if v134 and v134:IsA("BasePart") then
        return v134
    end
    return nil
end

local function getTutorialMarker(v135) -- line 827 | captures: getOwnPlot
    local v136 = getOwnPlot()
    local v137 = v136 and v136:FindFirstChild("Tutorial")
    local v138 = v137 and v137:FindFirstChild(v135)
    if not (v138 and v138:IsA("Attachment")) then
        return nil
    end
    return v138.WorldPosition
end

local function upgradeBoardTarget() -- line 839 | captures: TutorialConfig, getOwnPlot
    local v139 = getOwnPlot()
    local v140 = v139 and v139:FindFirstChild("UpgradeBoard")
    local v141 = v140 and v140:FindFirstChild("Board")
    if not (v141 and v141:IsA("BasePart")) then
        return nil
    end
    local v142 = v141:FindFirstChild(TutorialConfig.UpgradeBoardMarker)
    if not (v142 and v142:IsA("Attachment")) then
        return v141.Position
    end
    return v142.WorldPosition
end

local v143
local v144 = 0

local function treadmillTarget() -- line 859 | captures: v143, v144, getOwnPlot
    local v145 = os.clock()
    if v145 - v144 >= 0.25 or not v143 or not v143.Parent then
        v144 = v145
        v143 = nil
        local v146 = getOwnPlot()
        if v146 then
            for v147, v148 in v146:GetChildren() do
                if v148:IsA("Model") and string.find(v148.Name, "Treadmill") and v148.Name ~= "TreadmillBoard" then
                    local Hitbox = v148:FindFirstChild("Hitbox")
                    if Hitbox and Hitbox:IsA("BasePart") then
                        v143 = v148
                        break
                    end
                end
            end
        end
    end
    if not (v143 and v143.Parent) then
        return nil
    end
    return v143:GetPivot().Position
end

local function markerTarget(v149) -- line 884
    local v150 = workspace
    for v151, v152 in v149 do
        v150 = v150 and v150:FindFirstChild(v152)
    end
    if not (v150 and v150:IsA("BasePart")) then
        return nil
    end
    return v150.Position
end

local function pickaxeShopTarget() -- line 896 | captures: TutorialConfig, markerTarget
    return (markerTarget(TutorialConfig.PickaxeShopMarker))
end

local function openShopWindow(v153) -- line 906 | captures: UiFrames, LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v154 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if not (v154 and v154:IsA("ScreenGui")) then
        v154 = nil
    end
    local v155 = v154 and v154:FindFirstChild("Frames")
    local v156 = v155 and v155:FindFirstChild(v153)
    if v156 and v156:IsA("GuiObject") and v156.Visible and UiFrames.IsOpen(v156) then
        return v156
    end
    return nil
end

local function openPickaxeWindow() -- line 916 | captures: openShopWindow
    return (openShopWindow("Pickaxes"))
end

local function pickaxeShopClosedTarget() -- line 924 | captures: TutorialConfig, markerTarget, openShopWindow
    if openShopWindow("Pickaxes") then
        return nil
    end
    return (markerTarget(TutorialConfig.PickaxeShopMarker))
end

local v157 = {}
local v158 = { __mode = "k" }
local v159 = setmetatable(v157, v158)
UiFrames.ObserveAny(function(v160, v161) -- line 939 | captures: v159
    if not v161 then
        v159[v160] = nil
    end
end)

local function cachedShopButton(v162, v163, v164) -- line 949 | captures: v159
    local v165 = v159[v162]
    if not v165 then
        v165 = {}
        v159[v162] = v165
    end
    local v166 = v165[v163]
    if v166 and v166.Parent == nil then
        v165[v163] = nil
        v166 = nil
    end
    if not v166 then
        v166 = v164()
        if v166 then
            v165[v163] = v166
        end
    end
    if not (v166 and v166.Visible) then
        return nil
    end
    return v166
end

local function pickaxePurchaseButton() -- line 972 | captures: TutorialConfig, openShopWindow, cachedShopButton
    local Pickaxes = openShopWindow("Pickaxes")
    if Pickaxes then
        return (cachedShopButton(Pickaxes, "Purchase", function() -- line 977 | captures: Pickaxes, TutorialConfig
            local v167 = Pickaxes:FindFirstChild(("Tier%*"):format(TutorialConfig.ShopPickaxeTier), true)
            local v168 = v167 and v167:FindFirstChild("Purchase", true)
            if v168 and v168:IsA("GuiButton") and v168.Visible then
                return v168
            end
            return nil
        end))
    end
    return nil
end

local function trailsShopClosedTarget() -- line 990 | captures: TutorialConfig, markerTarget, openShopWindow
    if openShopWindow("Trails") then
        return nil
    end
    return (markerTarget(TutorialConfig.TrailsShopMarker))
end

local function trailPurchaseButton() -- line 1001 | captures: TrailsConfig, LocalPlayer, openShopWindow, cachedShopButton
    local Trails = openShopWindow("Trails")
    if Trails then
        local Cash = LocalPlayer:GetAttribute("Cash")
        local BestAffordable = TrailsConfig.BestAffordable
        if typeof(Cash) ~= "number" then
            Cash = 0
        end
        local v169 = BestAffordable(Cash)
        if v169 then
            local v170 = ("Trail%*"):format(v169.Id)
            return (cachedShopButton(Trails, v170, function() -- line 1013 | captures: Trails, v169
                local v171 = Trails:FindFirstChild(("Trail%*"):format(v169.Id), true)
                local v172 = v171 and v171:FindFirstChild("Purchase", true)
                if v172 and v172:IsA("GuiButton") and v172.Visible then
                    return v172
                end
                return nil
            end))
        end
    end
    return nil
end

local function findVisibleClose(v173) -- line 1030
    for v174, v175 in v173:GetDescendants() do
        if v175.Name == "Close" and v175:IsA("GuiButton") and v175.Visible then
            return v175
        end
    end
    return nil
end

local function pickaxeCloseButton() -- line 1039 | captures: openShopWindow, cachedShopButton, findVisibleClose
    local Pickaxes = openShopWindow("Pickaxes")
    if Pickaxes then
        return (cachedShopButton(Pickaxes, "Close", function() -- line 1044 | captures: Pickaxes, findVisibleClose
            local TopBar = Pickaxes:FindFirstChild("TopBar")
            return TopBar and findVisibleClose(TopBar) or findVisibleClose(Pickaxes)
        end))
    end
    return nil
end

local function strongerEggAfterShopTarget() -- line 1055 | captures: Highlight, isStrongerEgg, findEggTarget, openShopWindow, cachedShopButton, findVisibleClose
    local Pickaxes = openShopWindow("Pickaxes")
    if Pickaxes and
        cachedShopButton(Pickaxes, "Close", function() -- line 1044 | captures: Pickaxes, findVisibleClose
            local TopBar = Pickaxes:FindFirstChild("TopBar")
            return TopBar and findVisibleClose(TopBar) or findVisibleClose(Pickaxes)
        end) then
        if Highlight and (Highlight.Adornee ~= nil or Highlight.Parent == nil) then
            Highlight:Destroy()
            Highlight = nil
        end
        return nil
    end
    return (findEggTarget(isStrongerEgg, true))
end

local function closestPointInPart(v176, v177) -- line 1083
    local v178 = v176.CFrame:PointToObjectSpace(v177)
    local v179 = v176.Size * 0.5
    local v180 = v179.X - 4
    local v181 = math.max(v180, 0)
    local v182 = v179.Z - 4
    local v183 = math.max(v182, 0)
    local CFrame = v176.CFrame
    local X = v178.X
    local v184 = -v181
    local v185 = math.clamp(X, v184, v181)
    local Y = v178.Y
    local Z = v178.Z
    local v186 = -v183
    local v187 = math.clamp(Z, v186, v183)
    return CFrame:PointToWorldSpace((Vector3.new(v185, Y, v187)))
end

local function considerEscapePart(v188, v189, v190, v191) -- line 1098 | captures: closestPointInPart
    if v188 and v188.Parent then
        local v192 = closestPointInPart(v188, v189)
        local X = v192.X
        local Z = v192.Z
        local v193 = Vector3.new(X, 0, Z)
        local X_2 = v189.X
        local Z_2 = v189.Z
        local Magnitude = (v193 - Vector3.new(X_2, 0, Z_2)).Magnitude
        if Magnitude < v191 then
            return v192, Magnitude
        end
    end
    return v190, v191
end

local function escapeTarget() -- line 1115 | captures: SafeZoneQuery, LocalPlayer, closestPointInPart
    local Character = LocalPlayer.Character
    local v194 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (v194 and v194:IsA("BasePart")) then
        v194 = nil
    end
    if v194 then
        local Position = v194.Position
        if SafeZoneQuery.IsBankable(LocalPlayer.UserId, Position) then
            return nil
        end
        local v195
        local v196 = (1/0)
        for v197, v198 in SafeZoneQuery.GetSafeParts() do
            if v198 and v198.Parent then
                local v199 = closestPointInPart(v198, Position)
                local X = v199.X
                local Z = v199.Z
                local v200 = Vector3.new(X, 0, Z)
                local X_2 = Position.X
                local Z_2 = Position.Z
                local Magnitude = (v200 - Vector3.new(X_2, 0, Z_2)).Magnitude
                if Magnitude < v196 then
                    v195 = v199
                    v196 = Magnitude
                end
            end
        end
        local v201 = SafeZoneQuery.GetOwnedPlotHitbox(LocalPlayer.UserId)
        if v201 and v201.Parent then
            local v202 = closestPointInPart(v201, Position)
            local X = v202.X
            local Z = v202.Z
            local v203 = Vector3.new(X, 0, Z)
            local X_2 = Position.X
            local Z_2 = Position.Z
            local Magnitude = (v203 - Vector3.new(X_2, 0, Z_2)).Magnitude
            if Magnitude < v196 then
                v195 = v202
                v196 = Magnitude
            end
        end
        if not v195 or v196 < 1.5 then
            return nil
        end
        return v195
    end
    return nil
end

local function penTarget() -- line 1144 | captures: LocalPlayer, getOwnPlot
    local v204 = getOwnPlot()
    local v205 = v204 and v204:FindFirstChild("Tutorial")
    local v206 = v205 and v205:FindFirstChild("Go To Base")
    local WorldPosition
    if not (v206 and v206:IsA("Attachment")) then
    else
        WorldPosition = v206.WorldPosition
    end
    if WorldPosition then
        return WorldPosition
    end
    local v207 = getOwnPlot()
    local v208 = v207 and v207:FindFirstChild("Hitbox")
    if not (v208 and v208:IsA("BasePart")) then
        v208 = nil
    end
    local Character = LocalPlayer.Character
    local v209 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (v209 and v209:IsA("BasePart")) then
        v209 = nil
    end
    if not v208 or not v209 then
        return nil
    end
    local v210 = v208.CFrame:PointToObjectSpace(v209.Position)
    local v211 = v208.Size.X / 2 - 2
    local v212 = math.max(v211, 0)
    local v213 = v208.Size.Z / 2 - 2
    local v214 = math.max(v213, 0)
    local CFrame = v208.CFrame
    local X = v210.X
    local v215 = -v212
    local v216 = math.clamp(X, v215, v212)
    local Z = v210.Z
    local v217 = -v214
    local v218 = math.clamp(Z, v217, v214)
    return CFrame:PointToWorldSpace((Vector3.new(v216, 0.5, v218)))
end

local v219 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, -1, true, 0.25)
local Part, v220

local function removeClickIndicator() -- line 1180 | captures: Part, v220
    if v220 then
        v220:Cancel()
        v220 = nil
    end
    if Part then
        Part:Destroy()
        Part = nil
    end
end

local function ensureClickIndicator() -- line 1195 | captures: Part, v220, ReplicatedStorage, TweenService, getOwnPlot, v219
    if Part and Part.Parent then
        return
    end
    if v220 then
        v220:Cancel()
        v220 = nil
    end
    if Part then
        Part:Destroy()
        Part = nil
    end
    local Click = ReplicatedStorage:FindFirstChild("Click")
    local v221 = getOwnPlot()
    local v222 = v221 and v221:FindFirstChild("Hitbox")
    if not (v222 and v222:IsA("BasePart")) then
        v222 = nil
    end
    local v223 = getOwnPlot()
    local v224 = v223 and v223:FindFirstChild("Tutorial")
    local v225 = v224 and v224:FindFirstChild("PlaceAnimal")
    local WorldPosition
    if not (v225 and v225:IsA("Attachment")) then
    else
        WorldPosition = v225.WorldPosition
    end
    local v226 = WorldPosition or v222 and v222.Position + Vector3.new(0, 2, 0)
    if not (Click and Click:IsA("BillboardGui") and v226) then
        return
    end
    local Part_2 = Instance.new("Part")
    Part_2.Name = "TutorialClickAnchor"
    Part_2.Size = Vector3.new(0.5, 0.5, 0.5)
    Part_2.Transparency = 1
    Part_2.Anchored = true
    Part_2.CanCollide = false
    Part_2.CanQuery = false
    Part_2.CanTouch = false
    Part_2.Position = v226
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Part_2
    local v227 = Click:Clone()
    v227.Adornee = Attachment
    v227.Enabled = true
    v227.Parent = Part_2
    Part_2.Parent = workspace
    Part = Part_2
    local v228 = v227:FindFirstChildWhichIsA("ImageLabel", true)
    if v228 then
        v228.AnchorPoint = Vector2.new(0.5, 0.5)
        v228.Position = UDim2.fromScale(0.5, 0.5)
        local v229 = TweenService:Create(v228, v219, {
            Rotation = -20,
            Size = UDim2.fromScale(0.7, 0.7)
        })
        v229:Play()
        v220 = v229
    end
end

local function isAnimalTool(v230) -- line 1252 | captures: CollectionService
    return CollectionService:HasTag(v230, "AnimalTool")
end

local function hasEquippedAnimalTool() -- line 1256 | captures: CollectionService, LocalPlayer
    local Character = LocalPlayer.Character
    if Character then
        for v231, v232 in Character:GetChildren() do
            if v232:IsA("Tool") and CollectionService:HasTag(v232, "AnimalTool") then
                return true
            end
        end
    end
    return false
end

local function updateClickIndicator() -- line 1274 | captures: ensureClickIndicator
    ensureClickIndicator()
end

local function showGuidance(v233, v234) -- line 1283 | captures: TutorialArrow, TutorialScreenArrow
    TutorialArrow.Show(v233)
    TutorialScreenArrow.Show(v233, v234)
end

local function shopHoverAt(v235) -- line 1292 | captures: TutorialConfig, markerTarget
    return function(v236) -- line 1293 | captures: v235, TutorialConfig, markerTarget
        local v237 = markerTarget(v235)
        if v237 then
            return v237, 0
        end
        local ShopHoverHeight = TutorialConfig.ScreenArrow.ShopHoverHeight
        return v236 + Vector3.new(0, ShopHoverHeight, 0), 0
    end
end

local PickaxeShopArrowMarker = TutorialConfig.PickaxeShopArrowMarker

local function v238(v239) -- line 1293 | captures: TutorialConfig, markerTarget, PickaxeShopArrowMarker
    local v240 = markerTarget(PickaxeShopArrowMarker)
    if v240 then
        return v240, 0
    end
    local ShopHoverHeight = TutorialConfig.ScreenArrow.ShopHoverHeight
    return v239 + Vector3.new(0, ShopHoverHeight, 0), 0
end

local TrailsShopArrowMarker = TutorialConfig.TrailsShopArrowMarker

local function v241(v242) -- line 1293 | captures: TutorialConfig, markerTarget, TrailsShopArrowMarker
    local v243 = markerTarget(TrailsShopArrowMarker)
    if v243 then
        return v243, 0
    end
    local ShopHoverHeight = TutorialConfig.ScreenArrow.ShopHoverHeight
    return v242 + Vector3.new(0, ShopHoverHeight, 0), 0
end

local function isDrawn(v244, v245) -- line 1306
    local v246 = v244
    while v246 do
        if v246 == v245 then
            break
        end
        if not v246:IsA("GuiObject") or v246.Visible then
            v246 = v246.Parent
            continue
        end
        return false
    end
    if v244:IsA("TextLabel") then
        if v244.Text == "" then
            return false
        end
        return v244.TextTransparency < 1
    end
    if v244:IsA("ImageLabel") then
        if v244.Image == "" then
            return false
        end
        return v244.ImageTransparency < 1
    end
    return false
end

local v247, v248
local v249 = {}

local function invalidateOverheadObjects() -- line 1331 | captures: v248
    v248 = nil
end

local function billboardGuiObjects(v250) -- line 1335 | captures: v247, v248, v249, invalidateOverheadObjects
    local function v251(v252, ...)
        table.insert(v252, ...)
    end

    local function v253(v254, ...)
        table.insert(v254, ...)
    end

    if v250 ~= v247 then
        for v255, v256 in v249 do
            v256:Disconnect()
        end
        table.clear(v249)
        v247 = v250
        v248 = nil
        v251(v249, v250.DescendantAdded:Connect(invalidateOverheadObjects))
        v253(v249, v250.DescendantRemoving:Connect(invalidateOverheadObjects))
    end
    local v257 = v248
    if not v257 then
        v257 = {}
        for v258, v259 in v250:GetDescendants() do
            if v259:IsA("GuiObject") then
                table.insert(v257, v259)
            end
        end
        v248 = v257
    end
    return v257
end

local function visibleTopFraction(v260) -- line 1363 | captures: isDrawn, billboardGuiObjects
    local Y = v260.AbsolutePosition.Y
    local Y_2 = v260.AbsoluteSize.Y
    if Y_2 <= 0 then
        return 0
    end
    local v261 = (1/0)
    for v262, v263 in billboardGuiObjects(v260) do
        if isDrawn(v263, v260) then
            local v264 = v263.AbsolutePosition.Y - Y
            v261 = math.min(v261, v264)
        end
    end
    if v261 == (1/0) then
        return 0
    end
    local v265 = v261 / Y_2
    return (math.clamp(v265, 0, 1))
end

local function overheadHover(v266, v267) -- line 1383 | captures: AnimalOverhead, TutorialConfig, visibleTopFraction
    local v268 = v266 and (v266.PrimaryPart or v266:FindFirstChildWhichIsA("BasePart", true))
    local v269 = v268 and v268:FindFirstChild(AnimalOverhead.AttachmentName)
    local v270
    if not (v269 and v269:IsA("Attachment")) then
    else
        v270 = v269:FindFirstChildWhichIsA("BillboardGui")
    end
    if v269 and v270 and v270.Enabled then
        local v271 = 1 - visibleTopFraction(v270)
        local v272 = v270.Size.Y.Scale * v271 + v270.StudsOffset.Y + v270.StudsOffsetWorldSpace.Y + TutorialConfig.ScreenArrow.OverheadClearance
        return v269.WorldPosition + Vector3.new(0, v272, 0), v270.Size.Y.Offset * v271
    end
    local HoverHeight = TutorialConfig.ScreenArrow.HoverHeight
    return v267 + Vector3.new(0, HoverHeight, 0), 0
end

local function nearestPickupHover(v273) -- line 1400 | captures: v107, overheadHover
    return overheadHover(v107, v273)
end

local function reservedPickupHover(v274) -- line 1404 | captures: v117, overheadHover
    return overheadHover(v117, v274)
end

local function hideGuidance() -- line 1408 | captures: TutorialArrow, TutorialScreenArrow
    TutorialArrow.Hide()
    TutorialScreenArrow.Hide()
end

local v275
local v276 = 0
local v277 = false

local function applyStage() -- line 1421 | captures: v51, v57, v58, v76, Highlight, v117, v119, v120, Part, v220, v275, v276, v277, CountingNumber, TutorialConfig, TutorialArrow, TutorialScreenArrow, TutorialUiArrow, LocalPlayer, pickaxeSlotOffset, lastSlotOffset, showText, hideMessage, cashProgressFor, applyEarnCashCount, toolSlotPlacement, isPickaxeTool, nearestEggTarget, nearestPickupTarget, reservedPickupTarget, upgradeBoardTarget, treadmillTarget, openShopWindow, pickaxeShopClosedTarget, cachedShopButton, trailsShopClosedTarget, trailPurchaseButton, findVisibleClose, strongerEggAfterShopTarget, escapeTarget, penTarget, ensureClickIndicator, isAnimalTool, hasEquippedAnimalTool, v238, v241, nearestPickupHover, reservedPickupHover
    local v278 = LocalPlayer:GetAttribute(TutorialConfig.StageAttribute)
    v275 = v278
    v276 += 1
    v277 = false
    if v57 then
        v57:Disconnect()
        v57 = nil
    end
    if v58 then
        v58:Destroy()
        v58 = nil
    end
    v51 = nil
    if v278 ~= "BreakEgg" and not (v278 == "BreakStrongerEgg" or not Highlight or Highlight.Adornee == nil and Highlight.Parent ~= nil) then
        Highlight:Destroy()
        Highlight = nil
    end
    if v278 == "BreakEgg" then
        v76 = nil
        TutorialArrow.Show(nearestEggTarget)
        TutorialScreenArrow.Show(nearestEggTarget, nil)
    elseif v278 == "StealAnimal" then
        TutorialArrow.Show(nearestPickupTarget)
        TutorialScreenArrow.Show(nearestPickupTarget, nearestPickupHover)
    elseif v278 == "Escape" or v278 == "EscapeStronger" then
        TutorialArrow.Show(escapeTarget)
        TutorialScreenArrow.Show(escapeTarget, nil)
    elseif v278 == "GoToPen" or v278 == "GoToPenStronger" then
        TutorialArrow.Show(penTarget)
        TutorialScreenArrow.Show(penTarget, nil)
    elseif v278 == "UpgradePen" then
        TutorialArrow.Show(upgradeBoardTarget)
        TutorialScreenArrow.Show(upgradeBoardTarget, nil)
    elseif v278 == "UseTreadmill" then
        TutorialArrow.Show(treadmillTarget)
        TutorialScreenArrow.Show(treadmillTarget, nil)
    elseif v278 == "BuyPickaxe" then
        TutorialArrow.Show(pickaxeShopClosedTarget)
        TutorialScreenArrow.Show(pickaxeShopClosedTarget, v238)
    elseif v278 == "BreakStrongerEgg" then
        v76 = nil
        TutorialArrow.Show(strongerEggAfterShopTarget)
        TutorialScreenArrow.Show(strongerEggAfterShopTarget, nil)
    elseif not (v278 == "CollectStrongerAnimal" and LocalPlayer:GetAttribute(TutorialConfig.AwaitRevealAttribute)) then
        if v278 == "CollectStrongerAnimal" then
            v117 = nil
            v119 = false
            v120 = false
            TutorialArrow.Show(reservedPickupTarget)
            TutorialScreenArrow.Show(reservedPickupTarget, reservedPickupHover)
        elseif v278 == "BuyTrail" then
            TutorialArrow.Show(trailsShopClosedTarget)
            TutorialScreenArrow.Show(trailsShopClosedTarget, v241)
        else
            TutorialArrow.Hide()
            TutorialScreenArrow.Hide()
        end
    else
        TutorialArrow.Hide()
        TutorialScreenArrow.Hide()
    end
    if v278 == "PlaceAnimal" or v278 == "PlaceAnimalStronger" then
        ensureClickIndicator()
    else
        if v220 then
            v220:Cancel()
            v220 = nil
        end
        if Part then
            Part:Destroy()
            Part = nil
        end
    end
    local v279
    if v278 == "EquipPickaxe" then
        function v279() -- line 1496 | captures: pickaxeSlotOffset, toolSlotPlacement, isPickaxeTool
            return (toolSlotPlacement(isPickaxeTool, false, pickaxeSlotOffset))
        end
    elseif v278 == "PlaceAnimal" or v278 == "PlaceAnimalStronger" then
        function v279() -- line 1503 | captures: lastSlotOffset, toolSlotPlacement, isAnimalTool, hasEquippedAnimalTool
            if hasEquippedAnimalTool() then
                return nil
            end
            return (toolSlotPlacement(isAnimalTool, true, lastSlotOffset))
        end
    elseif v278 == "BuyPickaxe" then
        function v279() -- line 1513 | captures: TutorialConfig, openShopWindow, cachedShopButton
            local Pickaxes = openShopWindow("Pickaxes")
            local v280
            if Pickaxes then
                v280 = cachedShopButton(Pickaxes, "Purchase", function() -- line 977 | captures: Pickaxes, TutorialConfig
                    local v281 = Pickaxes:FindFirstChild(("Tier%*"):format(TutorialConfig.ShopPickaxeTier), true)
                    local v282 = v281 and v281:FindFirstChild("Purchase", true)
                    if v282 and v282:IsA("GuiButton") and v282.Visible then
                        return v282
                    end
                    return nil
                end)
            end
            if v280 then
                return {
                    pointUp = true,
                    x = v280.AbsolutePosition.X + v280.AbsoluteSize.X / 2,
                    y = v280.AbsolutePosition.Y + v280.AbsoluteSize.Y
                }
            end
            return nil
        end
    elseif v278 == "EquipNewPickaxe" then
        local Pickaxes = openShopWindow("Pickaxes")
        local v283
        if Pickaxes then
            v283 = cachedShopButton(Pickaxes, "Close", function() -- line 1044 | captures: Pickaxes, findVisibleClose
                local TopBar = Pickaxes:FindFirstChild("TopBar")
                return TopBar and findVisibleClose(TopBar) or findVisibleClose(Pickaxes)
            end)
        end
        local v284 = v283 ~= nil

        function v279() -- line 1525 | captures: v284, TutorialConfig, pickaxeSlotOffset, showText, toolSlotPlacement, isPickaxeTool, openShopWindow, cachedShopButton, findVisibleClose
            local Pickaxes = openShopWindow("Pickaxes")
            local v285
            if Pickaxes then
                v285 = cachedShopButton(Pickaxes, "Close", function() -- line 1044 | captures: Pickaxes, findVisibleClose
                    local TopBar = Pickaxes:FindFirstChild("TopBar")
                    return TopBar and findVisibleClose(TopBar) or findVisibleClose(Pickaxes)
                end)
            end
            if v285 ~= nil ~= v284 then
                v284 = v285 ~= nil
                local v286
                if v284 then
                    v286 = TutorialConfig.CloseShopText
                else
                    v286 = TutorialConfig.TextFor("EquipNewPickaxe")
                end
                showText(v286 or "")
            end
            if v285 then
                return {
                    pointUp = true,
                    x = v285.AbsolutePosition.X + v285.AbsoluteSize.X / 2,
                    y = v285.AbsolutePosition.Y + v285.AbsoluteSize.Y
                }
            end
            return (toolSlotPlacement(isPickaxeTool, false, pickaxeSlotOffset))
        end
    elseif v278 == "BreakStrongerEgg" then
        function v279() -- line 1541 | captures: openShopWindow, cachedShopButton, findVisibleClose
            local Pickaxes = openShopWindow("Pickaxes")
            local v287
            if Pickaxes then
                v287 = cachedShopButton(Pickaxes, "Close", function() -- line 1044 | captures: Pickaxes, findVisibleClose
                    local TopBar = Pickaxes:FindFirstChild("TopBar")
                    return TopBar and findVisibleClose(TopBar) or findVisibleClose(Pickaxes)
                end)
            end
            if v287 then
                return {
                    pointUp = true,
                    x = v287.AbsolutePosition.X + v287.AbsoluteSize.X / 2,
                    y = v287.AbsolutePosition.Y + v287.AbsoluteSize.Y
                }
            end
            return nil
        end
    elseif v278 == "BuyTrail" then
        function v279() -- line 1548 | captures: trailPurchaseButton
            local v288 = trailPurchaseButton()
            if v288 then
                return {
                    pointUp = true,
                    x = v288.AbsolutePosition.X + v288.AbsoluteSize.X / 2,
                    y = v288.AbsolutePosition.Y + v288.AbsoluteSize.Y
                }
            end
            return nil
        end
    end
    if v279 then
        TutorialUiArrow.Show(v279)
    else
        TutorialUiArrow.Hide()
    end
    if typeof(v278) == "string" and v278 ~= TutorialConfig.PausedStage then
        local v289 = TutorialConfig.TextFor(v278)
        if v278 == "EquipNewPickaxe" then
            local Pickaxes = openShopWindow("Pickaxes")
            if Pickaxes and
                cachedShopButton(Pickaxes, "Close", function() -- line 1044 | captures: Pickaxes, findVisibleClose
                    local TopBar = Pickaxes:FindFirstChild("TopBar")
                    return TopBar and findVisibleClose(TopBar) or findVisibleClose(Pickaxes)
                end) then
                v289 = TutorialConfig.CloseShopText
            end
        end
        if v278 == "CollectStrongerAnimal" and LocalPlayer:GetAttribute(TutorialConfig.AwaitRevealAttribute) then
            v289 = ""
        end
        local v290 = cashProgressFor(v278)
        local v291
        if v290 then
            v51 = v290
            local v292 = v290.Current() + 0.5
            local v293 = math.floor(v292)
            local Target = v290.Target
            local v294 = math.clamp(v293, 0, Target)
            local v295
            if v290.FullText and v290.Target > 0 and v290.Target <= v294 then
                v295 = v290.FullText
            else
                v295 = string.format(v290.Format, v294, v290.Target)
            end
            local v296 = CountingNumber.new(applyEarnCashCount)
            v296:Snap(v290.Current())
            v58 = v296
            v57 = LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(function() -- line 1592 | captures: v290, v296
                v296:Set(v290.Current())
            end)
            v291 = v295
        else
            v291 = v289
        end
        if v291 == "" then
            hideMessage()
        elseif v291 then
            showText(v291)
        end
    else
        hideMessage()
    end
end

local function onStageChanged() -- line 1606 | captures: v51, v57, v58, v275, v276, v277, TutorialConfig, LocalPlayer, applyStage
    if v277 then
        return
    end
    local v297 = v51
    local v298 = v58
    local v299 = LocalPlayer:GetAttribute(TutorialConfig.StageAttribute)
    local v300
    if v297 and v298 then
        if v297.FullText or v299 == v275 or v299 == TutorialConfig.PausedStage then
            v300 = true
        else
            if v57 then
                v57:Disconnect()
                v57 = nil
            end
            v300 = false
        end
    else
        v300 = true
    end
    if not v300 then
        v298:Snap(v297.Target)
        v277 = true
        local v301 = v276
        task.delay(TutorialConfig.ProgressCompleteHold, function() -- line 1631 | captures: v301, v276, applyStage
            if v301 == v276 then
                applyStage()
            end
        end)
    else
        applyStage()
    end
end

function v1.Start() -- line 1638 | captures: v78, TutorialConfig, EggLocalHits, MainGui, LocalPlayer, applyStage, onStageChanged
    LocalPlayer:GetAttributeChangedSignal(TutorialConfig.StageAttribute):Connect(onStageChanged)
    LocalPlayer:GetAttributeChangedSignal(TutorialConfig.AwaitRevealAttribute):Connect(applyStage)
    EggLocalHits.OnHit(function(v302) -- line 1644 | captures: v78
        v78 = v302
    end)
    MainGui.Observe(function(v303) -- line 1656 | captures: applyStage
        v303:WaitForChild("Messages", 30)
        applyStage()
    end)
    applyStage()
end

return v1
