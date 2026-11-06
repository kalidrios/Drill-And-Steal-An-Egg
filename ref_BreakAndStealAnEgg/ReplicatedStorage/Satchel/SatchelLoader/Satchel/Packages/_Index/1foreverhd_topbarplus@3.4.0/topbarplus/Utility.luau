-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local LocalPlayer = game:GetService("Players").LocalPlayer

local function createStagger(v2, v3, v4) -- line 13
    local v5 = v2
    local v6 = false
    local v7 = false
    if not v2 or v2 == 0 then
        v5 = 0.01
    end
    local staggeredCallback

    local function staggeredCallback_2(...) -- line 29 | captures: v5, v6, v7, v3, v4, staggeredCallback
        if v6 then
            v7 = true
        else
            local v8 = table.pack(...)
            v6 = true
            v7 = false
            task.spawn(function() -- line 37 | captures: v8, v5, v3, v4
                if v4 then
                    task.wait(v5)
                end
                v3(table.unpack(v8))
            end)
            task.delay(v5, function() -- line 43 | captures: v8, v6, v7, staggeredCallback
                v6 = false
                if v7 then
                    staggeredCallback(table.unpack(v8))
                end
            end)
        end
    end

    staggeredCallback = staggeredCallback_2
    return staggeredCallback_2
end

v1.createStagger = createStagger

local function round(v9) -- line 55
    local v10 = v9 + 0.5
    return (math.floor(v10))
end

v1.round = round

local function reverseTable(v11) -- line 60
    local v12 = #v11 / 2
    local v13 = math.floor(v12)
    for v14 = 1, v13 do
        local v15 = #v11 - v14 + 1
        local v16 = v11[v15]
        local v17 = v11[v14]
        v11[v14] = v16
        v11[v15] = v17
    end
end

v1.reverseTable = reverseTable

function v1.copyTable(v18) -- line 67 | captures: v1
    local v19 = type(v18) == "table"
    assert(v19, "First argument must be a table")
    local v20 = table.create(#v18)
    for v21, v22 in pairs(v18) do
        if type(v22) == "table" then
            v20[v21] = v1.copyTable(v22)
        else
            v20[v21] = v22
        end
    end
    return v20
end

local v23 = {
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0",
    "<",
    ">",
    "?",
    "@",
    "{",
    "}",
    "[",
    "]",
    "!",
    "(",
    ")",
    "=",
    "+",
    "~",
    "#"
}

function v1.generateUID(v24) -- line 82 | captures: v23
    local v25 = v24 or 8
    local v26 = #v23
    local v27 = ""
    for v28 = 1, v25 do
        v27 ..= v23[math.random(1, v26)]
    end
    return v27
end

local v29 = {}

function v1.setVisible(v30, v31, v32) -- line 95 | captures: v29
    local v33 = v29[v30]
    if not v33 then
        v33 = {}
        v29[v30] = v33
        v30.Destroying:Once(function() -- line 104 | captures: v30, v29
            v29[v30] = nil
        end)
    end
    local v34
    if v31 then
        v33[v32] = nil
        v34 = v31
        for v35, v36 in pairs(v33) do
            v34 = false
            break
        end
    else
        v33[v32] = true
        v34 = v31
    end
    v30.Visible = v34
end

local function formatStateName(v37) -- line 123
    return string.upper((string.sub(v37, 1, 1))) .. string.lower((string.sub(v37, 2)))
end

v1.formatStateName = formatStateName

function v1.localPlayerRespawned(v38) -- line 127 | captures: LocalPlayer
    LocalPlayer.CharacterRemoving:Connect(v38)
end

local function getClippedContainer(v39) -- line 137
    local ClippedContainer = v39:FindFirstChild("ClippedContainer")
    if not ClippedContainer then
        ClippedContainer = Instance.new("Folder")
        ClippedContainer.Name = "ClippedContainer"
        ClippedContainer.Parent = v39
    end
    return ClippedContainer
end

v1.getClippedContainer = getClippedContainer

local Janitor = require(script.Parent.Packages.Janitor)
local GuiService = game:GetService("GuiService")

function v1.clipOutside(v40, v41) -- line 151 | captures: v1, Janitor, GuiService
    local v42 = v40.janitor:add(Janitor.new())
    v41.Destroying:Once(function() -- line 153 | captures: v42
        v42:Destroy()
    end)
    v40.janitor:add(v41)
    local Parent = v41.Parent
    local v43 = v42:add(Instance.new("Frame"))
    v43:SetAttribute("IsAClippedClone", true)
    v43.Name = v41.Name
    v43.AnchorPoint = v41.AnchorPoint
    v43.Size = v41.Size
    v43.Position = v41.Position
    v43.BackgroundTransparency = 1
    v43.LayoutOrder = v41.LayoutOrder
    v43.Parent = Parent
    local ObjectValue = Instance.new("ObjectValue")
    ObjectValue.Name = "OriginalInstance"
    ObjectValue.Value = v41
    ObjectValue.Parent = v43
    local v44 = ObjectValue:Clone()
    v41:SetAttribute("HasAClippedClone", true)
    v44.Name = "ClippedClone"
    v44.Value = v43
    v44.Parent = v41
    local ScreenGui
    local iconModule = require(v40.iconModule)
    local container = iconModule.container

    local function updateScreenGui() -- line 183 | captures: ScreenGui, v41, Parent, container, v1
        local ScreenGui_2 = Parent:FindFirstAncestorWhichIsA("ScreenGui")
        if not string.match(ScreenGui_2.Name, "Clipped") then
            ScreenGui_2 = container[ScreenGui_2.Name .. "Clipped"]
        end
        ScreenGui = ScreenGui_2
        v41.AnchorPoint = Vector2.new(0, 0)
        v41.Parent = v1.getClippedContainer(ScreenGui)
    end

    v42:add(v40.alignmentChanged:Connect(updateScreenGui))
    updateScreenGui()
    for v45, v46 in pairs(v41:GetChildren()) do
        if v46:IsA("UIAspectRatioConstraint") then
            v46:Clone().Parent = v43
        end
    end
    local widget = v40.widget
    local v47 = false
    local IgnoreVisibilityUpdater = v41:GetAttribute("IgnoreVisibilityUpdater")

    local function updateVisibility() -- line 205 | captures: v47, v41, widget, IgnoreVisibilityUpdater, v1
        if IgnoreVisibilityUpdater then
            return
        end
        local Visible = widget.Visible
        if v47 then
            Visible = false
        end
        v1.setVisible(v41, Visible, "ClipHandler")
    end

    v42:add(widget:GetPropertyChangedSignal("Visible"):Connect(updateVisibility))
    local joinedFrame, checkIfOutsideParentXBounds

    local function checkIfOutsideParentXBounds_2() -- line 218 | captures: v47, joinedFrame, v40, v41, v42, iconModule, widget, IgnoreVisibilityUpdater, checkIfOutsideParentXBounds, v1
        task.defer(function() -- line 220 | captures: v47, joinedFrame, v40, v41, v42, iconModule, widget, IgnoreVisibilityUpdater, checkIfOutsideParentXBounds, v1
            local UID = v40.UID
            local joinedFrame_2
            if v41:GetAttribute("ClipToJoinedParent") then
                local v48 = UID
                for v49 = 1, 10 do
                    local v50 = iconModule.getIconByUID(v48)
                    local joinedFrame
                    if v50 then
                        joinedFrame = v50.joinedFrame
                        v48 = v50.parentIconUID
                        if joinedFrame then
                            if joinedFrame.Name == "DropdownScroller" then
                                joinedFrame_2 = joinedFrame
                                break
                            end
                        else
                            break
                        end
                    else
                        break
                    end
                    joinedFrame_2 = joinedFrame
                end
            end
            if joinedFrame_2 then
                local AbsolutePosition = v41.AbsolutePosition
                local v51 = v41.AbsoluteSize / 2
                local AbsolutePosition_2 = joinedFrame_2.AbsolutePosition
                local AbsoluteSize = joinedFrame_2.AbsoluteSize
                local v52 = AbsolutePosition + v51
                local v53 = v52.X < AbsolutePosition_2.X
                local X = v52.X
                local v54 = AbsolutePosition_2.X + AbsoluteSize.X < X
                local v55 = v52.Y < AbsolutePosition_2.Y
                local Y = v52.Y
                local v56 = AbsolutePosition_2.Y + AbsoluteSize.Y < Y
                local v57 = v53 or v54 or v55 or v56
                local Visible, v58
                if v57 == v47 then
                    v58 = true
                else
                    v47 = v57
                    if IgnoreVisibilityUpdater then
                        v58 = true
                    else
                        Visible = widget.Visible
                        if v47 then
                            Visible = false
                        end
                        v58 = false
                    end
                end
                if not v58 then
                    v1.setVisible(v41, Visible, "ClipHandler")
                end
                if joinedFrame_2:IsA("ScrollingFrame") and joinedFrame ~= joinedFrame_2 then
                    joinedFrame = joinedFrame_2
                    local v59 = joinedFrame_2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line 265 | captures: checkIfOutsideParentXBounds
                        checkIfOutsideParentXBounds()
                    end)
                    v42:add(v59, "Disconnect", "TrackUtilityScroller-" .. UID)
                end
            else
                v47 = false
                if not IgnoreVisibilityUpdater then
                    local Visible = widget.Visible
                    if v47 then
                        Visible = false
                    end
                    v1.setVisible(v41, Visible, "ClipHandler")
                end
            end
        end)
    end

    checkIfOutsideParentXBounds = checkIfOutsideParentXBounds_2
    local CurrentCamera = workspace.CurrentCamera
    local v60 = v41:GetAttribute("AdditionalOffsetX") or 0

    local function trackProperty(v61) -- line 275 | captures: ScreenGui, v47, joinedFrame, v40, v41, v42, v43, iconModule, widget, IgnoreVisibilityUpdater, checkIfOutsideParentXBounds_2, CurrentCamera, v60, v1, GuiService
        local v62 = "Absolute" .. v61

        local function updateProperty() -- line 277 | captures: v61, v62, ScreenGui, v47, joinedFrame, v40, v41, v42, v43, iconModule, widget, IgnoreVisibilityUpdater, checkIfOutsideParentXBounds_2, CurrentCamera, v60, v1, GuiService
            local v63 = v43[v62]
            local v64 = UDim2.fromOffset(v63.X, v63.Y)
            local v65
            if v61 == "Position" then
                local v66 = CurrentCamera.ViewportSize.X - v41.AbsoluteSize.X - 4
                local Offset = v64.X.Offset
                if Offset < 4 then
                    v66 = 4
                elseif not (v66 < Offset) then
                    v66 = Offset
                end
                local v67 = UDim2.fromOffset(v66, v64.Y.Offset)
                local TopbarInset = GuiService.TopbarInset
                local X = workspace.CurrentCamera.ViewportSize.X
                local X_2 = ScreenGui.AbsoluteSize.X
                local X_3 = ScreenGui.AbsolutePosition.X
                if not iconModule.isOldTopbar then
                    X_3 = X - X_2 - 0
                end
                local v68 = X_3 - v60
                v65 = v67 + UDim2.fromOffset(-v68, TopbarInset.Height)
                task.defer(function() -- line 220 | captures: v47, joinedFrame, v40, v41, v42, iconModule, widget, IgnoreVisibilityUpdater, checkIfOutsideParentXBounds_2, v1
                    local UID = v40.UID
                    local joinedFrame_2
                    if v41:GetAttribute("ClipToJoinedParent") then
                        local v69 = UID
                        for v70 = 1, 10 do
                            local v71 = iconModule.getIconByUID(v69)
                            local joinedFrame
                            if v71 then
                                joinedFrame = v71.joinedFrame
                                v69 = v71.parentIconUID
                                if joinedFrame then
                                    if joinedFrame.Name == "DropdownScroller" then
                                        joinedFrame_2 = joinedFrame
                                        break
                                    end
                                else
                                    break
                                end
                            else
                                break
                            end
                            joinedFrame_2 = joinedFrame
                        end
                    end
                    if joinedFrame_2 then
                        local AbsolutePosition = v41.AbsolutePosition
                        local v72 = v41.AbsoluteSize / 2
                        local AbsolutePosition_2 = joinedFrame_2.AbsolutePosition
                        local AbsoluteSize = joinedFrame_2.AbsoluteSize
                        local v73 = AbsolutePosition + v72
                        local v74 = v73.X < AbsolutePosition_2.X
                        local X = v73.X
                        local v75 = AbsolutePosition_2.X + AbsoluteSize.X < X
                        local v76 = v73.Y < AbsolutePosition_2.Y
                        local Y = v73.Y
                        local v77 = AbsolutePosition_2.Y + AbsoluteSize.Y < Y
                        local v78 = v74 or v75 or v76 or v77
                        local Visible, v79
                        if v78 == v47 then
                            v79 = true
                        else
                            v47 = v78
                            if IgnoreVisibilityUpdater then
                                v79 = true
                            else
                                Visible = widget.Visible
                                if v47 then
                                    Visible = false
                                end
                                v79 = false
                            end
                        end
                        if not v79 then
                            v1.setVisible(v41, Visible, "ClipHandler")
                        end
                        if joinedFrame_2:IsA("ScrollingFrame") and joinedFrame ~= joinedFrame_2 then
                            joinedFrame = joinedFrame_2
                            local v80 = joinedFrame_2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line 265 | captures: checkIfOutsideParentXBounds_2
                                checkIfOutsideParentXBounds_2()
                            end)
                            v42:add(v80, "Disconnect", "TrackUtilityScroller-" .. UID)
                        end
                    else
                        v47 = false
                        if not IgnoreVisibilityUpdater then
                            local Visible = widget.Visible
                            if v47 then
                                Visible = false
                            end
                            v1.setVisible(v41, Visible, "ClipHandler")
                        end
                    end
                end)
            else
                v65 = v64
            end
            v41[v61] = v65
        end

        local v81 = v1.createStagger(0.01, updateProperty)
        v42:add(v43:GetPropertyChangedSignal(v62):Connect(v81))
        local ForceUpdate = v43:GetAttributeChangedSignal("ForceUpdate")
        v42:add(ForceUpdate:Connect(function() -- line 317 | captures: v81
            v81()
        end))
        local v82 = v1.createStagger(0.5, updateProperty, true)
        v42:add(v43:GetPropertyChangedSignal(v62):Connect(v82))
        if v61 == "Position" then
            local AbsoluteSize = ScreenGui:GetPropertyChangedSignal("AbsoluteSize")
            v42:add(AbsoluteSize:Connect(function() -- line 336 | captures: v81
                v81()
            end))
        end
    end

    task.delay(0.1, checkIfOutsideParentXBounds_2)
    task.defer(function() -- line 220 | captures: v47, joinedFrame, v40, v41, v42, iconModule, widget, IgnoreVisibilityUpdater, checkIfOutsideParentXBounds_2, v1
        local UID = v40.UID
        local joinedFrame_2
        if v41:GetAttribute("ClipToJoinedParent") then
            local v83 = UID
            for v84 = 1, 10 do
                local v85 = iconModule.getIconByUID(v83)
                local joinedFrame
                if v85 then
                    joinedFrame = v85.joinedFrame
                    v83 = v85.parentIconUID
                    if joinedFrame then
                        if joinedFrame.Name == "DropdownScroller" then
                            joinedFrame_2 = joinedFrame
                            break
                        end
                    else
                        break
                    end
                else
                    break
                end
                joinedFrame_2 = joinedFrame
            end
        end
        if joinedFrame_2 then
            local AbsolutePosition = v41.AbsolutePosition
            local v86 = v41.AbsoluteSize / 2
            local AbsolutePosition_2 = joinedFrame_2.AbsolutePosition
            local AbsoluteSize = joinedFrame_2.AbsoluteSize
            local v87 = AbsolutePosition + v86
            local v88 = v87.X < AbsolutePosition_2.X
            local X = v87.X
            local v89 = AbsolutePosition_2.X + AbsoluteSize.X < X
            local v90 = v87.Y < AbsolutePosition_2.Y
            local Y = v87.Y
            local v91 = AbsolutePosition_2.Y + AbsoluteSize.Y < Y
            local v92 = v88 or v89 or v90 or v91
            local Visible, v93
            if v92 == v47 then
                v93 = true
            else
                v47 = v92
                if IgnoreVisibilityUpdater then
                    v93 = true
                else
                    Visible = widget.Visible
                    if v47 then
                        Visible = false
                    end
                    v93 = false
                end
            end
            if not v93 then
                v1.setVisible(v41, Visible, "ClipHandler")
            end
            if joinedFrame_2:IsA("ScrollingFrame") and joinedFrame ~= joinedFrame_2 then
                joinedFrame = joinedFrame_2
                local v94 = joinedFrame_2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line 265 | captures: checkIfOutsideParentXBounds_2
                    checkIfOutsideParentXBounds_2()
                end)
                v42:add(v94, "Disconnect", "TrackUtilityScroller-" .. UID)
            end
        else
            v47 = false
            if not IgnoreVisibilityUpdater then
                local Visible = widget.Visible
                if v47 then
                    Visible = false
                end
                v1.setVisible(v41, Visible, "ClipHandler")
            end
        end
    end)
    if not IgnoreVisibilityUpdater then
        local Visible = widget.Visible
        if v47 then
            Visible = false
        end
        v1.setVisible(v41, Visible, "ClipHandler")
    end
    trackProperty("Position")
    v42:add(v41:GetPropertyChangedSignal("Visible"):Connect(function() -- line 348
    end))
    if v41:GetAttribute("TrackCloneSize") then
        trackProperty("Size")
    else
        local AbsoluteSize = v41:GetPropertyChangedSignal("AbsoluteSize")
        v42:add(AbsoluteSize:Connect(function() -- line 358 | captures: v41, v43
            local AbsoluteSize = v41.AbsoluteSize
            v43.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
        end))
    end
    return v43
end

local function joinFeature(v95, v96, v97, v98) -- line 367
    local joinJanitor = v95.joinJanitor
    joinJanitor:clean()
    if v98 then
        v95.parentIconUID = v96.UID
        v95.joinedFrame = v98

        local function updateAlignent() -- line 378 | captures: v95, v96
            local alignment = v96.alignment
            if alignment == "Center" then
                alignment = "Left"
            end
            v95:setAlignment(alignment, true)
        end

        joinJanitor:add(v96.alignmentChanged:Connect(updateAlignent))
        local alignment = v96.alignment
        if alignment == "Center" then
            alignment = "Left"
        end
        v95:setAlignment(alignment, true)
        v95:modifyTheme({ "IconButton", "BackgroundTransparency", 1 }, "JoinModification")
        v95:modifyTheme({ "ClickRegion", "Active", false }, "JoinModification")
        if v96.childModifications then
            task.defer(function() -- line 393 | captures: v95, v96
                v95:modifyTheme(v96.childModifications, v96.childModificationsUID)
            end)
        end
        local ClickRegion = v95:getInstance("ClickRegion")

        local function makeSelectable() -- line 399 | captures: v96, ClickRegion
            ClickRegion.Selectable = v96.isSelected
        end

        joinJanitor:add(v96.toggled:Connect(makeSelectable))
        task.defer(makeSelectable)
        joinJanitor:add(function() -- line 404 | captures: ClickRegion
            ClickRegion.Selectable = true
        end)
        local UID = v95.UID
        table.insert(v97, UID)
        v96:autoDeselect(false)
        v96.childIconsDict[UID] = true
        if not v96.isEnabled then
            v96:setEnabled(true)
        end
        v95.joinedParent:Fire(v96)
        joinJanitor:add(function() -- line 422 | captures: v95, v96, v97, UID
            if not v95.joinedFrame then
                return
            end
            for v99, v100 in pairs(v97) do
                if v100 == UID then
                    table.remove(v97, v99)
                    break
                end
            end
            local v101 = require(v95.iconModule).getIconByUID(v95.parentIconUID)
            if not v101 then
                return
            end
            v95:setAlignment(v95.originalAlignment)
            v95.parentIconUID = false
            v95.joinedFrame = false
            v95:removeModification("JoinModification")
            local childIconsDict = v101.childIconsDict
            childIconsDict[UID] = nil
            local v102 = true
            for v103, v104 in pairs(childIconsDict) do
                v102 = false
                break
            end
            if v102 and not v101.isAnOverflow then
                v101:setEnabled(false)
            end
            local alignment = v96.alignment
            if alignment == "Center" then
                alignment = "Left"
            end
            v95:setAlignment(alignment, true)
        end)
    else
        v95:leave()
    end
end

v1.joinFeature = joinFeature
return v1
