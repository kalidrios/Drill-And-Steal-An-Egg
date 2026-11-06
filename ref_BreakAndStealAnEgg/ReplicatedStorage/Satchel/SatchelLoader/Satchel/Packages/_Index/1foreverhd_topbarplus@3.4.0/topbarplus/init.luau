-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
require(script.Types)
local script_2 = script
local Reference = require(script_2.Reference)
local v1 = Reference.getObject()
local v2 = v1 and v1.Value

if v2 and v2 ~= script_2 then
    return require(v2)
end

if not v1 then
    Reference.addToReplicatedStorage()
end
local GoodSignal = require(script_2.Packages.GoodSignal)
local Janitor = require(script_2.Packages.Janitor)
local Utility = require(script_2.Utility)
local Themes = require(script_2.Features.Themes)
local Gamepad = require(script_2.Features.Gamepad)
local Overflow = require(script_2.Features.Overflow)
local v3 = {}

v3.__index = v3

local LocalPlayer = Players.LocalPlayer
local Themes_2 = script_2.Features.Themes
local v4 = {}
local v5 = GoodSignal.new()
local Elements = script_2.Elements
local v6 = 0
local v7 = {
    mobile = Enum.PreferredInput.Touch,
    desktop = Enum.PreferredInput.KeyboardAndMouse,
    console = Enum.PreferredInput.Gamepad
}

v3.baseDisplayOrderChanged = GoodSignal.new()
v3.baseDisplayOrder = 10
v3.baseTheme = require(Themes_2.Default)
v3.isOldTopbar = false
v3.iconsDictionary = v4
v3.insetHeightChanged = GoodSignal.new()
v3.container = require(Elements.Container)(v3)
v3.topbarEnabled = true
v3.iconAdded = GoodSignal.new()
v3.iconRemoved = GoodSignal.new()
v3.iconChanged = GoodSignal.new()

function v3.getIcons() -- line 110 | captures: v3
    return v3.iconsDictionary
end

function v3.getIconByUID(v8) -- line 114 | captures: v3
    return v3.iconsDictionary[v8] or nil
end

function v3.getIcon(v9) -- line 122 | captures: v3, v4
    local v10 = v3.getIconByUID(v9)
    if v10 then
        return v10
    end
    for v11, v12 in pairs(v4) do
        if v12.name == v9 then
            return v12
        end
    end
    return nil
end

function v3.setTopbarEnabled(v13, v14) -- line 135 | captures: v3
    local v15 = if typeof(v13) == "boolean" then v13 else v3.topbarEnabled
    if not v14 then
        v3.topbarEnabled = v15
    end
    for v16, v17 in pairs(v3.container) do
        v17.Enabled = v15
    end
end

function v3.modifyBaseTheme(v18) -- line 147 | captures: Themes, v3, v4
    local v19 = Themes.getModifications(v18)
    for v20, v21 in pairs(v19) do
        for v22, v23 in pairs(v3.baseTheme) do
            Themes.merge(v23, v21)
        end
    end
    for v24, v25 in pairs(v4) do
        v25:setTheme(v3.baseTheme)
    end
end

function v3.setDisplayOrder(v26) -- line 159 | captures: v3
    v3.baseDisplayOrder = v26
    v3.baseDisplayOrderChanged:Fire(v26)
end

task.defer(Gamepad.start, v3)
task.defer(Overflow.start, v3)
task.defer(function() -- line 169 | captures: script_2, v3, LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    for v27, v28 in pairs(v3.container) do
        v28.Parent = PlayerGui
    end
    require(script_2.Attribute)
end)

function v3.new() -- line 180 | captures: v6, UserInputService, StarterGui, script_2, GoodSignal, Janitor, Utility, v3, v4, v5, Elements, v7
    local v29 = {}
    setmetatable(v29, v3)
    local v30 = Janitor.new()
    v29.janitor = v30
    v29.themesJanitor = v30:add(Janitor.new())
    v29.singleClickJanitor = v30:add(Janitor.new())
    v29.captionJanitor = v30:add(Janitor.new())
    v29.joinJanitor = v30:add(Janitor.new())
    v29.menuJanitor = v30:add(Janitor.new())
    v29.dropdownJanitor = v30:add(Janitor.new())
    local v31 = Utility.generateUID()
    v4[v31] = v29
    v30:add(function() -- line 197 | captures: v31, v4
        v4[v31] = nil
    end)
    v29.selected = v30:add(GoodSignal.new())
    v29.deselected = v30:add(GoodSignal.new())
    v29.toggled = v30:add(GoodSignal.new())
    v29.viewingStarted = v30:add(GoodSignal.new())
    v29.viewingEnded = v30:add(GoodSignal.new())
    v29.stateChanged = v30:add(GoodSignal.new())
    v29.notified = v30:add(GoodSignal.new())
    v29.noticeStarted = v30:add(GoodSignal.new())
    v29.noticeChanged = v30:add(GoodSignal.new())
    v29.endNotices = v30:add(GoodSignal.new())
    v29.toggleKeyAdded = v30:add(GoodSignal.new())
    v29.fakeToggleKeyChanged = v30:add(GoodSignal.new())
    v29.alignmentChanged = v30:add(GoodSignal.new())
    v29.updateSize = v30:add(GoodSignal.new())
    v29.resizingComplete = v30:add(GoodSignal.new())
    v29.joinedParent = v30:add(GoodSignal.new())
    v29.menuSet = v30:add(GoodSignal.new())
    v29.dropdownSet = v30:add(GoodSignal.new())
    v29.updateMenu = v30:add(GoodSignal.new())
    v29.startMenuUpdate = v30:add(GoodSignal.new())
    v29.childThemeModified = v30:add(GoodSignal.new())
    v29.indicatorSet = v30:add(GoodSignal.new())
    v29.dropdownChildAdded = v30:add(GoodSignal.new())
    v29.menuChildAdded = v30:add(GoodSignal.new())
    v29.iconModule = script_2
    v29.UID = v31
    v29.isEnabled = true
    v29.enabled = v29.isEnabled
    v29.isSelected = false
    v29.isViewing = false
    v29.joinedFrame = false
    v29.parentIconUID = false
    v29.deselectWhenOtherIconSelected = true
    v29.totalNotices = 0
    v29.activeState = "Deselected"
    v29.alignment = ""
    v29.originalAlignment = ""
    v29.appliedTheme = {}
    v29.appearance = {}
    v29.cachedInstances = {}
    v29.cachedNamesToInstances = {}
    v29.cachedCollectives = {}
    v29.bindedToggleKeys = {}
    v29.customBehaviours = {}
    v29.toggleItems = {}
    v29.bindedEvents = {}
    v29.notices = {}
    v29.menuIcons = {}
    v29.dropdownIcons = {}
    v29.childIconsDict = {}
    v29.creationTime = os.clock()
    v29.widget = v30:add(require(Elements.Widget)(v29, v3))
    v29:setAlignment()
    v6 += 1
    local v32 = v6 * 0.01 + 1
    v29:setOrder(v32, "deselected")
    v29:setOrder(v32, "selected")
    v29:setTheme(v3.baseTheme)
    local ClickRegion = v29:getInstance("ClickRegion")
    local v33 = false
    local v34 = 0

    local function handleToggle() -- line 277 | captures: v34, v29
        if not v29.locked then
            local v35 = tick()
            if not (v35 - v34 < 0.1) then
                v34 = v35
                if v29.isSelected then
                    v29:deselect("User", v29)
                else
                    v29:select("User", v29)
                end
            end
        end
    end

    ClickRegion.MouseButton1Click:Connect(function() -- line 296 | captures: v33, v34, v29
        v33 = true
        if not v29.locked then
            local v36 = tick()
            if not (v36 - v34 < 0.1) then
                v34 = v36
                if v29.isSelected then
                    v29:deselect("User", v29)
                else
                    v29:select("User", v29)
                end
            end
        end
    end)
    ClickRegion.TouchTap:Connect(function() -- line 301 | captures: v33, v34, v29
        if v33 then
            return
        end
        if v29.locked then
            return
        end
        local v37 = tick()
        if v37 - v34 < 0.1 then
            return
        end
        v34 = v37
        if v29.isSelected then
            v29:deselect("User", v29)
        else
            v29:select("User", v29)
        end
    end)
    v30:add(UserInputService.InputBegan:Connect(function(v38, v39) -- line 314 | captures: v34, v29
        if v29.locked or not v29.bindedToggleKeys[v38.KeyCode] or v39 then
            return
        end
        if v29.locked then
            return
        end
        local v40 = tick()
        if v40 - v34 < 0.1 then
            return
        end
        v34 = v40
        if v29.isSelected then
            v29:deselect("User", v29)
        else
            v29:select("User", v29)
        end
    end))

    local function viewingStarted(v41) -- line 326 | captures: v29
        if v29.locked then
            return
        end
        v29.isViewing = true
        v29.viewingStarted:Fire(true)
        if not v41 then
            v29:setState("Viewing", "User", v29)
        end
    end

    local function viewingEnded() -- line 336 | captures: v29
        if v29.locked then
            return
        end
        v29.isViewing = false
        v29.viewingEnded:Fire(true)
        v29:setState(nil, "User", v29)
    end

    v29.joinedParent:Connect(function() -- line 344 | captures: v29
        if not v29.isViewing then
            return
        end
        if v29.locked then
            return
        end
        v29.isViewing = false
        v29.viewingEnded:Fire(true)
        v29:setState(nil, "User", v29)
    end)
    ClickRegion.MouseEnter:Connect(function() -- line 349 | captures: v29, UserInputService, v7
        local v42 = UserInputService.PreferredInput ~= v7.desktop
        if v29.locked then
            return
        end
        v29.isViewing = true
        v29.viewingStarted:Fire(true)
        if not v42 then
            v29:setState("Viewing", "User", v29)
        end
    end)
    local v43 = 0
    v30:add(UserInputService.TouchEnded:Connect(viewingEnded))
    ClickRegion.MouseLeave:Connect(viewingEnded)
    ClickRegion.SelectionGained:Connect(viewingStarted)
    ClickRegion.SelectionLost:Connect(viewingEnded)
    ClickRegion.MouseButton1Down:Connect(function() -- line 358 | captures: v43, v29, UserInputService, v7
        if v29.locked or not (UserInputService.PreferredInput == v7.mobile) then
            return
        end
        v43 += 1
        local v44 = v43
        task.delay(0.2, function() -- line 362 | captures: v44, v43, v29
            if v44 ~= v43 then
                return
            end
            if v29.locked then
                return
            end
            v29.isViewing = true
            v29.viewingStarted:Fire(true)
            v29:setState("Viewing", "User", v29)
        end)
    end)
    ClickRegion.MouseButton1Up:Connect(function() -- line 369 | captures: v43
        v43 += 1
    end)
    local IconOverlay = v29:getInstance("IconOverlay")
    v29.viewingStarted:Connect(function() -- line 375 | captures: v29, IconOverlay
        IconOverlay.Visible = not v29.overlayDisabled
    end)
    v29.viewingEnded:Connect(function() -- line 378 | captures: IconOverlay
        IconOverlay.Visible = false
    end)
    v30:add(v5:Connect(function(v45) -- line 383 | captures: v29
        if v45 ~= v29 and v29.deselectWhenOtherIconSelected and v45.deselectWhenOtherIconSelected then
            v29:deselect("AutoDeselect", v45)
        end
    end))
    local s = debug.info(2, "s")
    local v46 = string.split(s, ".")
    local game_2 = game
    local v47 = game_2
    local v48
    for v49, v50 in pairs(v46) do
        v47 = v47:FindFirstChild(v50)
        if v47 then
            if v47:IsA("ScreenGui") then
                v48 = v47
            end
        else
            game_2 = v47
            break
        end
        game_2 = v47
    end
    if game_2 and v48 and v48.ResetOnSpawn == true then
        v29.originsScreenGui = v48
        Utility.localPlayerRespawned(function() -- line 409 | captures: v29
            v29:destroy()
        end)
    end
    v29.toggled:Connect(function(v51) -- line 415 | captures: v29, v3
        v29.noticeChanged:Fire(v29.totalNotices)
        for v52, v53 in pairs(v29.childIconsDict) do
            local v54 = v3.getIconByUID(v52)
            v54.noticeChanged:Fire(v54.totalNotices)
            if not v51 and v54.isSelected then
                for v55, v56 in pairs(v54.childIconsDict) do
                    v54:deselect("HideParentFeature", v29)
                end
            end
        end
    end)
    v29.selected:Connect(function() -- line 438 | captures: v29, StarterGui
        if #v29.dropdownIcons > 0 then
            if StarterGui:GetCore("ChatActive") and v29.alignment ~= "Right" then
                v29.chatWasPreviouslyActive = true
                StarterGui:SetCore("ChatActive", false)
            end
            if StarterGui:GetCoreGuiEnabled("PlayerList") and v29.alignment ~= "Left" then
                v29.playerlistWasPreviouslyActive = true
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
            end
        end
    end)
    v29.deselected:Connect(function() -- line 451 | captures: v29, StarterGui
        if v29.chatWasPreviouslyActive then
            v29.chatWasPreviouslyActive = nil
            StarterGui:SetCore("ChatActive", true)
        end
        if v29.playerlistWasPreviouslyActive then
            v29.playerlistWasPreviouslyActive = nil
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
        end
    end)
    task.delay(0.1, function() -- line 465 | captures: v29
        if v29.activeState == "Deselected" then
            v29.stateChanged:Fire("Deselected")
            v29:refresh()
        end
    end)
    v3.iconAdded:Fire(v29)
    return v29
end

local function setName(v57, v58) -- line 481
    v57.widget.Name = v58
    v57.name = v58
    return v57
end

v3.setName = setName

function v3.setState(v59, v60, v61, v62) -- line 487 | captures: Utility, v5
    local v63
    if v60 then
        v63 = v60
    elseif v59.isSelected then
        v63 = "Selected"
    else
        v63 = "Deselected"
    end
    local v64 = Utility.formatStateName(v63)
    if v59.activeState == v64 then
        return
    end
    local isSelected = v59.isSelected
    v59.activeState = v64
    if v64 == "Deselected" then
        v59.isSelected = false
        if isSelected then
            v59.toggled:Fire(false, v61, v62)
            v59.deselected:Fire(v61, v62)
        end
        v59:_setToggleItemsVisible(false, v61, v62)
    elseif v64 == "Selected" then
        v59.isSelected = true
        if not isSelected then
            v59.toggled:Fire(true, v61, v62)
            v59.selected:Fire(v61, v62)
            v5:Fire(v59, v61, v62)
        end
        v59:_setToggleItemsVisible(true, v61, v62)
    end
    v59.stateChanged:Fire(v64, v61, v62)
end

function v3.getInstance(v65, v66) -- line 520 | captures: Themes
    local v67 = v65.cachedNamesToInstances[v66]
    if v67 then
        return v67
    end

    local function cacheInstance(v68, v69) -- line 528 | captures: v65
        if v65.cachedInstances[v69] then
            return
        end
        local Collective = v69:GetAttribute("Collective")
        local v70 = Collective and v65.cachedCollectives[Collective]
        if v70 then
            table.insert(v70, v69)
        end
        v65.cachedNamesToInstances[v68] = v69
        v65.cachedInstances[v69] = true
        v69.Destroying:Once(function() -- line 538 | captures: v68, v69, v65
            v65.cachedNamesToInstances[v68] = nil
            v65.cachedInstances[v69] = nil
        end)
    end

    local widget = v65.widget
    cacheInstance("Widget", widget)
    if v66 == "Widget" then
        return widget
    end
    local v71, scanChildren

    local function scanChildren_2(v72) -- line 551 | captures: v71, v65, v66, cacheInstance, scanChildren, Themes
        for v73, v74 in pairs(v72:GetChildren()) do
            local WidgetUID = v74:GetAttribute("WidgetUID")
            if WidgetUID then
                if WidgetUID == v65.UID then
                    local v75 = Themes.getRealInstance(v74) or v74
                    scanChildren(v75)
                    if v75:IsA("GuiBase") or v75:IsA("UIBase") or v75:IsA("ValueBase") then
                        local Name = v75.Name
                        cacheInstance(Name, v75)
                        if Name == v66 then
                            v71 = v75
                        end
                    end
                end
            else
                local v76 = Themes.getRealInstance(v74) or v74
                scanChildren(v76)
                if v76:IsA("GuiBase") or v76:IsA("UIBase") or v76:IsA("ValueBase") then
                    local Name = v76.Name
                    cacheInstance(Name, v76)
                    if Name == v66 then
                        v71 = v76
                    end
                end
            end
        end
    end

    scanChildren = scanChildren_2
    scanChildren_2(widget)
    return v71
end

local function getCollective(v77, v78) -- line 580
    local v79 = v77.cachedCollectives[v78]
    if v79 then
        return v79
    end
    local v80 = {}
    for v81, v82 in pairs(v77.cachedInstances) do
        if v81:GetAttribute("Collective") == v78 then
            table.insert(v80, v81)
        end
    end
    v77.cachedCollectives[v78] = v80
    return v80
end

v3.getCollective = getCollective

local function getInstanceOrCollective(v83, v84) -- line 601
    local v85 = {}
    local v86 = v83:getInstance(v84)
    if v86 then
        table.insert(v85, v86)
    end
    if #v85 == 0 then
        v85 = v83:getCollective(v84)
    end
    return v85
end

v3.getInstanceOrCollective = getInstanceOrCollective

local function getStateGroup(v87, v88) -- line 615
    local v89 = v88 or v87.activeState
    local v90 = v87.appearance[v89]
    if not v90 then
        v90 = {}
        v87.appearance[v89] = v90
    end
    return v90
end

v3.getStateGroup = getStateGroup

function v3.refreshAppearance(v91, v92, v93) -- line 625 | captures: Themes
    Themes.refresh(v91, v92, v93)
    return v91
end

local function refresh(v94) -- line 630
    v94:refreshAppearance(v94.widget)
    v94.updateSize:Fire()
    return v94
end

v3.refresh = refresh

function v3.updateParent(v95) -- line 636 | captures: v3
    local v96 = v3.getIconByUID(v95.parentIconUID)
    if v96 then
        v96.updateSize:Fire()
    end
end

local function setBehaviour(v97, v98, v99, v100, v101) -- line 643
    local v102 = v98 .. "-" .. v99
    v97.customBehaviours[v102] = v100
    if v101 then
        local v103 = v97:getInstanceOrCollective(v98)
        for v104, v105 in pairs(v103) do
            v97:refreshAppearance(v105, v99)
        end
    end
end

v3.setBehaviour = setBehaviour

function v3.modifyTheme(v106, v107, v108) -- line 656 | captures: Themes
    return v106, (Themes.modify(v106, v107, v108))
end

function v3.modifyChildTheme(v109, v110, v111) -- line 661 | captures: v3
    v109.childModifications = v110
    v109.childModificationsUID = v111
    for v112, v113 in pairs(v109.childIconsDict) do
        v3.getIconByUID(v112):modifyTheme(v110, v111)
    end
    v109.childThemeModified:Fire()
    return v109
end

function v3.removeModification(v114, v115) -- line 674 | captures: Themes
    Themes.remove(v114, v115)
    return v114
end

function v3.removeModificationWith(v116, v117, v118, v119) -- line 679 | captures: Themes
    Themes.removeWith(v116, v117, v118, v119)
    return v116
end

function v3.setTheme(v120, v121) -- line 684 | captures: Themes
    Themes.set(v120, v121)
    return v120
end

local function setEnabled(v122, v123) -- line 689
    v122.isEnabled = v123
    v122.enabled = v122.isEnabled
    v122.widget.Visible = v123
    v122:updateParent()
    return v122
end

v3.setEnabled = setEnabled

local function select(v124, v125, v126) -- line 697
    v124:setState("Selected", v125, v126)
    return v124
end

v3.select = select

local function deselect(v127, v128, v129) -- line 702
    v127:setState("Deselected", v128, v129)
    return v127
end

v3.deselect = deselect

function v3.notify(v130, v131, v132) -- line 707 | captures: v3, Elements
    if not v130.notice then
        v130.notice = require(Elements.Notice)(v130, v3)
    end
    v130.noticeStarted:Fire(v131, v132)
    return v130
end

local function clearNotices(v133) -- line 721
    v133.endNotices:Fire()
    return v133
end

v3.clearNotices = clearNotices

local function disableOverlay(v134, v135) -- line 726
    v134.overlayDisabled = v135
    return v134
end

v3.disableOverlay = disableOverlay
v3.disableStateOverlay = v3.disableOverlay

function v3.setImage(v136, v137, v138) -- line 732 | captures: ContentProvider
    v136:modifyTheme({ "IconImage", "Image", v137, v138 })
    task.spawn(function() -- line 736 | captures: v137, ContentProvider
        local v139
        if tonumber(v137) then
            v139 = ("rbxassetid://%*"):format(v137)
        else
            v139 = v137
        end
        if ContentProvider:GetAssetFetchStatus(v139) ~= Enum.AssetFetchStatus.Success then
            pcall(ContentProvider.PreloadAsync, ContentProvider, { v139 })
        end
    end)
    return v136
end

local function setLabel(v140, v141, v142) -- line 748
    v140:modifyTheme({ "IconLabel", "Text", v141, v142 })
    return v140
end

v3.setLabel = setLabel

local function setOrder(v143, v144, v145) -- line 753
    local v146 = v144 * 100
    v143:modifyTheme({ "IconSpot", "LayoutOrder", v146, v145 })
    v143:modifyTheme({ "Widget", "LayoutOrder", v146, v145 })
    return v143
end

v3.setOrder = setOrder

local function setCornerRadius(v147, v148, v149) -- line 762
    v147:modifyTheme({ "IconCorners", "CornerRadius", v148, v149 })
    return v147
end

v3.setCornerRadius = setCornerRadius

function v3.align(v150, v151, v152) -- line 767 | captures: v3
    local v153 = tostring(v151):lower()
    if v153 == "mid" or v153 == "centre" then
        v153 = "center"
    end
    if not (v153 == "left" or v153 == "center" or v153 == "right") then
        v153 = "left"
    end
    local TopbarCentered = v153 == "center" and v3.container.TopbarCentered or v3.container.TopbarStandard
    local Holders = TopbarCentered.Holders
    local v154 = string.upper((string.sub(v153, 1, 1))) .. string.sub(v153, 2)
    if not v152 then
        v150.originalAlignment = v154
    end
    local joinedFrame = v150.joinedFrame
    local v155 = Holders[v154]
    v150.screenGui = TopbarCentered
    v150.alignmentHolder = v155
    if not v150.isDestroyed then
        v150.widget.Parent = joinedFrame or v155
    end
    v150.alignment = v154
    v150.alignmentChanged:Fire(v154)
    v3.iconChanged:Fire(v150)
    return v150
end

v3.setAlignment = v3.align

local function setLeft(v156) -- line 796
    v156:setAlignment("Left")
    return v156
end

v3.setLeft = setLeft

local function setMid(v157) -- line 801
    v157:setAlignment("Center")
    return v157
end

v3.setMid = setMid

local function setRight(v158) -- line 806
    v158:setAlignment("Right")
    return v158
end

v3.setRight = setRight

local function setWidth(v159, v160, v161) -- line 811
    v159:modifyTheme({ "Widget", "DesiredWidth", v160, v161 })
    return v159
end

v3.setWidth = setWidth

local function setImageScale(v162, v163, v164) -- line 819
    v162:modifyTheme({ "IconImageScale", "Value", v163, v164 })
    return v162
end

v3.setImageScale = setImageScale

local function setImageRatio(v165, v166, v167) -- line 824
    v165:modifyTheme({ "IconImageRatio", "AspectRatio", v166, v167 })
    return v165
end

v3.setImageRatio = setImageRatio

local function setTextSize(v168, v169, v170) -- line 829
    v168:modifyTheme({ "IconLabel", "TextSize", v169, v170 })
    return v168
end

v3.setTextSize = setTextSize

local function setTextFont(v171, v172, v173, v174, v175) -- line 834
    local v176 = v173 or Enum.FontWeight.Regular
    local v177 = v174 or Enum.FontStyle.Normal
    local v178 = typeof(v172)
    local v179
    if v178 == "number" then
        v179 = Font.fromId(v172, v176, v177)
    elseif v178 == "EnumItem" then
        v179 = Font.fromEnum(v172)
    elseif v178 == "string" then
        if v172:match("rbxasset") then
        else
            v179 = Font.fromName(v172, v176, v177)
        end
    end
    v171:modifyTheme({
        "IconLabel",
        "FontFace",
        v179 or Font.new(v172, v176, v177),
        v175
    })
    return v171
end

v3.setTextFont = setTextFont

local function setTextColor(v180, v181, v182) -- line 855
    local v183, v184
    if v181 == nil or v181 == "" then
        v184 = false
    elseif type(v181) == "userdata" and typeof(v181) == "Color3" then
        v183 = v181
        v184 = true
    else
        v184 = false
    end
    if not v184 then
        if v181 ~= nil and v181 ~= "" then
            warn("setTextColor item must be a Color3 value! Changed the color to white.")
        end
        v183 = Color3.fromRGB(255, 255, 255)
    end
    v180:modifyTheme({ "IconLabel", "TextColor3", v183, v182 })
    return v180
end

v3.setTextColor = setTextColor

local function bindToggleItem(v185, v186) -- line 867
    if not v186:IsA("GuiObject") and not v186:IsA("LayerCollector") then
        error("Toggle item must be a GuiObject or LayerCollector!")
    end
    v185.toggleItems[v186] = true
    v185:_updateSelectionInstances()
    return v185
end

v3.bindToggleItem = bindToggleItem

local function unbindToggleItem(v187, v188) -- line 876
    v187.toggleItems[v188] = nil
    v187:_updateSelectionInstances()
    return v187
end

v3.unbindToggleItem = unbindToggleItem

local function _updateSelectionInstances(v189) -- line 882
    for v190, v191 in pairs(v189.toggleItems) do
        local v192 = {}
        for v193, v194 in pairs(v190:GetDescendants()) do
            if (v194:IsA("TextButton") or v194:IsA("ImageButton")) and v194.Active then
                table.insert(v192, v194)
            end
        end
        v189.toggleItems[v190] = v192
    end
end

v3._updateSelectionInstances = _updateSelectionInstances

local function _setToggleItemsVisible(v195, v196, v197, v198) -- line 896
    for v199, v200 in pairs(v195.toggleItems) do
        if v198 then
            if v198 == v195 or v198.toggleItems[v199] == nil then
                local v201 = if v199:IsA("LayerCollector") then "Enabled" else "Visible"
                v199[v201] = v196
            end
        else
            local v202 = if v199:IsA("LayerCollector") then "Enabled" else "Visible"
            v199[v202] = v196
        end
    end
end

v3._setToggleItemsVisible = _setToggleItemsVisible

local function bindEvent(v203, v204, v205) -- line 908
    local v206 = v203[v204]
    local v207
    if v206 then
        if typeof(v206) == "table" then
            v207 = v206.Connect
        else
            v207 = false
        end
    else
        v207 = v206
    end
    assert(v207, "argument[1] must be a valid topbarplus icon event name!")
    local v208 = typeof(v205) == "function"
    assert(v208, "argument[2] must be a function!")
    v203.bindedEvents[v204] = v206:Connect(function(...) -- line 912 | captures: v203, v205
        v205(v203, ...)
    end)
    return v203
end

v3.bindEvent = bindEvent

local function unbindEvent(v209, v210) -- line 918
    local v211 = v209.bindedEvents[v210]
    if v211 then
        v211:Disconnect()
        v209.bindedEvents[v210] = nil
    end
    return v209
end

v3.unbindEvent = unbindEvent

local function bindToggleKey(v212, v213) -- line 927
    local v214 = typeof(v213) == "EnumItem"
    assert(v214, "argument[1] must be a KeyCode EnumItem!")
    v212.bindedToggleKeys[v213] = true
    v212.toggleKeyAdded:Fire(v213)
    v212:setCaption("_hotkey_")
    return v212
end

v3.bindToggleKey = bindToggleKey

local function unbindToggleKey(v215, v216) -- line 935
    local v217 = typeof(v216) == "EnumItem"
    assert(v217, "argument[1] must be a KeyCode EnumItem!")
    v215.bindedToggleKeys[v216] = nil
    return v215
end

v3.unbindToggleKey = unbindToggleKey

local function call(v218, v219, ...) -- line 941
    local v220 = table.pack(...)
    task.spawn(function() -- line 943 | captures: v218, v219, v220
        v219(v218, table.unpack(v220))
    end)
    return v218
end

v3.call = call

local function addToJanitor(v221, v222, v223, v224) -- line 949
    v221.janitor:add(v222, v223, v224)
    return v221
end

v3.addToJanitor = addToJanitor

local function lock(v225) -- line 954
    v225:getInstance("ClickRegion").Visible = false
    v225.locked = true
    return v225
end

v3.lock = lock

local function unlock(v226) -- line 962
    v226:getInstance("ClickRegion").Visible = true
    v226.locked = false
    return v226
end

v3.unlock = unlock

local function debounce(v227, v228) -- line 969
    v227:lock()
    task.wait(v228)
    v227:unlock()
    return v227
end

v3.debounce = debounce

local function autoDeselect(v229, v230) -- line 976
    if v230 == nil then
        v229.deselectWhenOtherIconSelected = true
    else
        v229.deselectWhenOtherIconSelected = v230
    end
    return v229
end

v3.autoDeselect = autoDeselect

local function oneClick(v231, v232) -- line 986
    local singleClickJanitor = v231.singleClickJanitor
    singleClickJanitor:clean()
    if v232 or v232 == nil then
        singleClickJanitor:add(v231.selected:Connect(function() -- line 992 | captures: v231
            v231:deselect("OneClick", v231)
        end))
    end
    v231.oneClickEnabled = true
    return v231
end

v3.oneClick = oneClick

function v3.setCaption(v233, v234) -- line 1000 | captures: Elements
    if not (v234 == "_hotkey_" and v233.captionText) then
        local captionJanitor = v233.captionJanitor
        v233.captionJanitor:clean()
        if not v234 or v234 == "" then
            v233.caption = nil
            v233.captionText = nil
        else
            local v235 = captionJanitor:add(require(Elements.Caption)(v233))
            v235:SetAttribute("CaptionText", v234)
            v233.caption = v235
            v233.captionText = v234
        end
    end
    return v233
end

local function setCaptionHint(v236, v237) -- line 1018
    local v238 = typeof(v237) == "EnumItem"
    assert(v238, "argument[1] must be a KeyCode EnumItem!")
    v236.fakeToggleKey = v237
    v236.fakeToggleKeyChanged:Fire(v237)
    v236:setCaption("_hotkey_")
    return v236
end

v3.setCaptionHint = setCaptionHint

local function leave(v239) -- line 1026
    v239.joinJanitor:clean()
    return v239
end

v3.leave = leave

function v3.joinMenu(v240, v241) -- line 1032 | captures: Utility
    Utility.joinFeature(v240, v241, v241.menuIcons, v241:getInstance("Menu"))
    v241.menuChildAdded:Fire(v240)
    return v240
end

local function setMenu(v242, v243) -- line 1038
    v242.menuSet:Fire(v243)
    return v242
end

v3.setMenu = setMenu

local function setFixedMenu(v244, v245) -- line 1043
    v244:freezeMenu(v245)
    v244:setMenu(v245)
end

v3.setFixedMenu = setFixedMenu
v3.setFrozenMenu = v3.setFixedMenu

local function freezeMenu(v246) -- line 1049
    v246:select("FrozenMenu", v246)
    v246:bindEvent("deselected", function(v247) -- line 1053 | captures: v246
        v247:select("FrozenMenu", v246)
    end)
    v246:modifyTheme({ "IconSpot", "Visible", false })
end

v3.freezeMenu = freezeMenu

function v3.joinDropdown(v248, v249) -- line 1059 | captures: Utility
    v249:getDropdown()
    Utility.joinFeature(v248, v249, v249.dropdownIcons, v249:getInstance("DropdownScroller"))
    v249.dropdownChildAdded:Fire(v248)
    return v248
end

function v3.getDropdown(v250) -- line 1066 | captures: Elements
    local dropdown = v250.dropdown
    if not dropdown then
        dropdown = require(Elements.Dropdown)(v250)
        v250.dropdown = dropdown
        v250:clipOutside(dropdown)
    end
    return dropdown
end

local function setDropdown(v251, v252) -- line 1076
    v251:getDropdown()
    v251.dropdownSet:Fire(v252)
    return v251
end

v3.setDropdown = setDropdown

function v3.clipOutside(v253, v254) -- line 1082 | captures: Utility
    local v255 = Utility.clipOutside(v253, v254)
    v253:refreshAppearance(v254)
    return v253, v255
end

function v3.setIndicator(v256, v257) -- line 1093 | captures: v3, Elements
    if not v256.indicator then
        v256.indicator = v256.janitor:add(require(Elements.Indicator)(v256, v3))
    end
    v256.indicatorSet:Fire(v257)
end

local function convertLabelToNumberSpinner(v258, v259, v260) -- line 1105
    task.defer(function() -- line 1106 | captures: v258, v259, v260
        local IconLabel = v258:getInstance("IconLabel")
        IconLabel.Transparency = 1
        v259.Parent = IconLabel.Parent
        v259.Size = UDim2.fromScale(1, 1)
        v259.AnchorPoint = Vector2.new(0.5, 0.5)
        v259.Position = UDim2.new(0.5, 0, 0.5, 0)
        v259.TextXAlignment = Enum.TextXAlignment.Center
        v259.ClipsDescendants = false
        local v261 = { "FontFace", "BorderSizePixel", "BorderColor3", "Rotation", "TextStrokeTransparency", "TextStrokeColor3", "TextStrokeTransparency", "TextColor3" }
        for v262, v263 in ipairs(v261) do
            v259[v263] = IconLabel[v263]
            local v264 = IconLabel:GetPropertyChangedSignal(v263)
            local v265 = v263
            v258:addToJanitor(v264:Connect(function() -- line 1129 | captures: IconLabel, v265, v259
                v259[v265] = IconLabel[v265]
            end))
        end

        local function getSpinnerSizeAndDigitCount() -- line 1136 | captures: v259
            local v266 = 0
            local v267 = 0
            for v268, v269 in v259.Frame:GetChildren() do
                local v270 = string.lower(v269.Name)
                if v270 == "digit" or (v270 == "prefix" or v270 == "suffix" or v270 == "comma") and v269.Text ~= "" then
                    v266 += v269.AbsoluteSize.X
                    v267 += 1
                end
            end
            return v266, v267
        end

        local function getLabelParentContainerXSize() -- line 1154 | captures: IconLabel, v259
            local Parent = IconLabel.Parent
            local v271 = Parent and Parent.Parent
            if v271 == nil then
                return 0
            end
            if v271.IconImage.Visible == true then
                return v259.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X
            end
            return v271.AbsoluteSize.X
        end

        local function getNumberSpinnerXSize() -- line 1166 | captures: v259
            return v259.Frame.AbsoluteSize.X
        end

        local function adjustSize() -- line 1170 | captures: IconLabel, getSpinnerSizeAndDigitCount, v258, v259
            local v272, v273 = getSpinnerSizeAndDigitCount()
            if v273 < 18 then
                v258:setLabel(v259.Value)
            end
            local X = v259.Frame.AbsoluteSize.X
            while v272 < X do
                if v258.isDestroyed ~= true then
                    task.wait(0.05)
                    if not (v273 > 0 and v273 < 8) then
                        v259.TextSize += 1
                        X = v259.Frame.AbsoluteSize.X
                        v272, v273 = getSpinnerSizeAndDigitCount()
                        continue
                    end
                    v259.TextSize = IconLabel.TextSize
                end
                break
            end
            local Parent = IconLabel.Parent
            local v274 = Parent and Parent.Parent
            local v275
            if v274 == nil then
                v275 = 0
            elseif v274.IconImage.Visible == true then
                v275 = v259.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X
            else
                v275 = v274.AbsoluteSize.X
            end
            while true do
                if v275 < v272 then
                    if v258.isDestroyed == true then
                        return
                    end
                    task.wait(0.05)
                    if v273 < 8 and v273 > 0 then
                        break
                    end
                    v259.TextSize -= 1
                    local Parent = IconLabel.Parent
                    Parent = Parent and Parent.Parent
                    if Parent == nil then
                        v275 = 0
                    elseif Parent.IconImage.Visible == true then
                        v275 = v259.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X
                    else
                        v275 = Parent.AbsoluteSize.X
                    end
                    v272, v273 = getSpinnerSizeAndDigitCount()
                    continue
                end
                return
            end
            v259.TextSize = IconLabel.TextSize
        end

        v258:addToJanitor(v259.Frame.ChildAdded:Connect(adjustSize))
        v258:addToJanitor(v259.Frame.ChildRemoved:Connect(adjustSize))
        local iconAdded = v258.iconAdded
        v258:addToJanitor(iconAdded:Connect(function() -- line 1208 | captures: adjustSize
            task.wait(1)
            adjustSize()
        end))
        v258:updateParent()
        v259.Name = "LabelSpinner"
        v259.Prefix = "$"
        v259.Commas = true
        v259.Decimals = 0
        v259.Duration = 0.25
        v259.Value = 10
        task.wait(0.2)
        if typeof(v260) == "function" then
            v260()
        end
    end)
    return v258
end

v3.convertLabelToNumberSpinner = convertLabelToNumberSpinner

function v3.destroy(v276) -- line 1235 | captures: v3
    if v276.isDestroyed then
        return
    end
    v276:clearNotices()
    if v276.parentIconUID then
        v276:leave()
    end
    v276.isDestroyed = true
    v276.janitor:clean()
    v3.iconRemoved:Fire(v276)
end

v3.Destroy = v3.destroy
return v3
