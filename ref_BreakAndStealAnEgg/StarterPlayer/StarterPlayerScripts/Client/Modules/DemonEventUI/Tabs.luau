-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {}

function v1.new() -- line 38 | captures: CollectionService
    local v2 = {}
    local v3, T, rng, v4, map, staticActors, entranceList, refresh, park, toRest, chainVisible, ShopCards, EggItems, step, to, snap, kick
    local v5 = {}
    local v6 = {}
    v2.buttons = {}
    v2.current = nil
    local Color, Rotation, Color_2, Rotation_2
    local v7 = 0.55
    local v8 = {}

    local function dimOf(v9) -- line 55
        for v10, v11 in ipairs(v9:GetChildren()) do
            if v11:IsA("Frame") and v11.Size == UDim2.fromScale(1, 1) and v11.BackgroundTransparency < 1 then
                return v11
            end
        end
        return nil
    end

    local function setLook(v12, v13, v14) -- line 64 | captures: to, snap, Color, Rotation, Color_2, Rotation_2, v7
        local grad = v12.grad
        if grad then
            local v15, v16
            if v13 then
                v15 = Color or Color_2
                v16 = Rotation or Rotation_2
            else
                v15 = Color_2
                v16 = Rotation_2
            end
            if v15 then
                grad.Color = v15
            end
            if v16 and grad.Rotation ~= v16 then
                grad.Rotation = v16
            end
        end
        local v17 = if v13 then 1 else v7
        if v14 then
            snap(v12.ov, v17)
        else
            to(v12.ov, v17)
        end
        v12.dirty = true
    end

    local function writeDim(v18, v19) -- line 85 | captures: v7
        if not v18.dim then
            return
        end
        local v20
        if v19 then
            local x = v19.a.x
            if x < 0 then
                x = 0
            elseif x > 1 then
                x = 1
            end
            v18.la = v19.a.x
            v20 = x
        else
            v20 = 0
        end
        local v21 = 1 - (1 - v18.ov.x) * (1 - v20)
        local v22 = v21 - v18.wt
        if v22 ~= 0 and (v22 > 0.004 or v22 < -0.004 or v21 == 1 or v21 == v7) then
            v18.wt = v21
            v18.dim.BackgroundTransparency = v21
        end
    end

    local v23 = {}
    local v24 = {}

    local function under(v25, v26) -- line 113
        if v25 == v26 then
            return true
        end
        return (v25:IsDescendantOf(v26))
    end

    local function gather(v27, v28) -- line 117 | captures: v23
        for v29, v30 in ipairs(v27) do
            v30.tabDelay = v30[v28]
            table.insert(v23, v30)
        end
    end

    local function tabIn(v31, v32) -- line 126 | captures: T, staticActors, entranceList, refresh, park, chainVisible, ShopCards, EggItems, v23, v24
        table.clear(v23)
        for v33, v34 in ipairs(staticActors) do
            local inst = v34.inst
            if (inst == v31 or inst:IsDescendantOf(v31)) and chainVisible(v34.inst) then
                v34.tabDelay = v34.tabAt
                table.insert(v23, v34)
            end
        end
        ShopCards.collect(v31, T.TAB_CARD_AT, v24)
        for v35, v36 in ipairs(v24) do
            v36.tabDelay = v36.inAt
            table.insert(v23, v36)
        end
        EggItems.collect(v31, T.TAB_CARD_AT, v24)
        for v37, v38 in ipairs(v24) do
            v38.tabDelay = v38.inAt
            table.insert(v23, v38)
        end
        table.clear(v24)
        for v39, v40 in ipairs(v23) do
            if not v40.session then
                refresh(v40)
            end
        end
        for v41, v42 in ipairs(v23) do
            local v43 = (T.TAB_IN_DELAY + (v42.tabDelay or 0)) * T.TIME_SCALE
            if v42.session then
                if not table.find(entranceList, v42) then
                    local entranceList_2 = entranceList
                    table.insert(entranceList_2, v42)
                end
                v42.pend = 1
                v42.pendAt = v32 + v43 * T.REOPEN_DELAY
            else
                park(v42)
                local entranceList_2 = entranceList
                table.insert(entranceList_2, v42)
                v42.pend = 1
                v42.pendAt = v32 + v43
            end
        end
        table.clear(v23)
    end

    local function tabOut(v44, v45) -- line 169 | captures: entranceList
        for v46, v47 in ipairs(entranceList) do
            local inst = v47.inst
            if inst == v44 or inst:IsDescendantOf(v44) then
                v47.pend = 2
                v47.pendAt = v45
            end
        end
    end

    local function tabRest(v48) -- line 180 | captures: entranceList, toRest
        local v49 = #entranceList
        for v50 = v49, 1, -1 do
            local v51 = entranceList[v50]
            local inst = v51.inst
            if inst == v48 or inst:IsDescendantOf(v48) then
                toRest(v51)
                table.remove(entranceList, v50)
            end
        end
    end

    local function finishHide(v52) -- line 190 | captures: v2, tabRest
        v52.hideAt = nil
        if v52 ~= v2.current and v52.content then
            tabRest(v52.content)
            v52.content.Visible = false
        end
    end

    function v2.step(v53, v54) -- line 199 | captures: map, step, v2, v5, writeDim, tabRest
        local v55 = #v5
        for v56 = 1, v55 do
            local v57 = v5[v56]
            local ov = v57.ov
            local v58 = not ov.rest
            if v58 then
                step(ov, v53)
            end
            local v59 = map[v57.button]
            if v57.dim and (v58 or v57.dirty or v59 and v59.a.x ~= v57.la) then
                v57.dirty = false
                writeDim(v57, v59)
            end
            local hideAt = v57.hideAt
            if hideAt and hideAt <= v54 then
                v57.hideAt = nil
                if v57 ~= v2.current and v57.content then
                    tabRest(v57.content)
                    v57.content.Visible = false
                end
            end
        end
    end

    function v2.select(v60) -- line 219 | captures: v3, T, rng, map, kick, v2, v5, setLook, tabIn, tabOut, tabRest
        if v60 == v2.current or v3.closing then
            return
        end
        local current = v2.current
        v2.current = v60
        local v61 = v3.isOpen and v3.running
        for v62, v63 in ipairs(v5) do
            setLook(v63, v63 == v60, not v61)
        end
        if v61 then
            local clock = v3.clock
            local v64 = map[v60.button]
            if v64 and v64.session then
                kick(v64.sc, T.TAB_POP_KICK)
                local kick_2 = kick
                local rot = v64.rot
                local v65 = if rng:NextNumber() < 0.5 then -1 else 1
                kick_2(rot, v65 * T.TAB_POP_TILT)
                v64.live = true
            end
            if current and current.content then
                tabOut(current.content, clock)
                current.hideAt = clock + T.TAB_HIDE_AFTER * T.TIME_SCALE
            end
            if v60.content then
                v60.hideAt = nil
                v60.content.Visible = true
                tabIn(v60.content, clock)
            end
        else
            for v66, v67 in ipairs(v5) do
                v67.hideAt = nil
                if v67.content then
                    if v67 ~= v60 then
                        tabRest(v67.content)
                    end
                    v67.content.Visible = v67 == v60
                end
            end
        end
    end

    function v2.selectName(v68) -- line 262 | captures: v2, v6
        local v69 = v6[v68]
        if v69 then
            v2.select(v69)
        end
    end

    function v2.reset() -- line 270 | captures: T, snap, Color, Rotation, Color_2, Rotation_2, v7, v2, v5, v6
        local v70 = v6[T.TAB_DEFAULT] or v5[1]
        v2.current = v70
        for v71, v72 in ipairs(v5) do
            v72.hideAt = nil
            local v73 = v72 == v70
            local grad = v72.grad
            if grad then
                local v74, v75
                if v73 then
                    v74 = Color or Color_2
                    v75 = Rotation or Rotation_2
                else
                    v74 = Color_2
                    v75 = Rotation_2
                end
                if v74 then
                    grad.Color = v74
                end
                if v75 and grad.Rotation ~= v75 then
                    grad.Rotation = v75
                end
            end
            local v76 = if v73 then 1 else v7
            snap(v72.ov, v76)
            v72.dirty = true
            if v72.content then
                v72.content.Visible = v72 == v70
            end
        end
    end

    function v2.onClosed() -- line 284 | captures: map, snap, v2, v5, writeDim
        for v77, v78 in ipairs(v5) do
            v78.hideAt = nil
            if v78.dim then
                snap(v78.ov, v78.ov.t)
                writeDim(v78, map[v78.button])
            end
            if v78 ~= v2.current and v78.content then
                v78.content.Visible = false
            end
        end
    end

    function v2.check() -- line 298 | captures: v2, v5
        local v79 = 0
        for v80, v81 in ipairs(v5) do
            if v81.content and v81.content.Visible then
                v79 += 1
                if v81 ~= v2.current then
                    return false, "wrong tab shown: " .. v81.name
                end
            end
        end
        return v79 == 1, v2.current and v2.current.name or "none"
    end

    function v2.init(v82) -- line 311 | captures: v3, T, rng, map, step, to, snap, kick, Color, Rotation, Color_2, Rotation_2, v7, v2, v5, v6, v8, dimOf, CollectionService
        local function v83(...)
            return (type(...))
        end

        local function v84(v85, ...)
            table.insert(v85, ...)
        end

        v3 = v82
        local T_2 = v3.T
        local rng_2 = v3.rng
        T = T_2
        rng = rng_2
        local Spring = v3.Spring
        local step_2 = Spring.step
        local to_2 = Spring.to
        local snap_2 = Spring.snap
        local kick_2 = Spring.kick
        step = step_2
        to = to_2
        snap = snap_2
        kick = kick_2
        map = v3.Actors.map
        local noFade = v3.Actors.noFade
        local main = v3.main
        local buttons = v2.buttons
        for v86, v87 in ipairs(CollectionService:GetTagged(T.TAB_TAG)) do
            if v87:IsA("GuiButton") and v87:IsDescendantOf(main) and v83(v87:GetAttribute("Tab")) == "string" then
                table.insert(buttons, v87)
            end
        end
        table.sort(buttons, function(v88, v89) -- line 327
            local LayoutOrder = v88.Parent:IsA("GuiObject") and v88.Parent.LayoutOrder or v88.LayoutOrder
            local LayoutOrder_2 = v89.Parent:IsA("GuiObject") and v89.Parent.LayoutOrder or v89.LayoutOrder
            if LayoutOrder == LayoutOrder_2 then
                return v88.Name < v89.Name
            end
            return LayoutOrder < LayoutOrder_2
        end)
        local v90
        for v91, v92 in ipairs(buttons) do
            local UIGradient = v92:FindFirstChildOfClass("UIGradient")
            local v93 = dimOf(v92)
            if v93 then
                if not v90 then
                    v7 = v93.BackgroundTransparency
                    if UIGradient then
                        local Color = UIGradient.Color
                        local Rotation = UIGradient.Rotation
                        Color_2 = Color
                        Rotation_2 = Rotation
                    end
                    v90 = v93
                end
            elseif not Color and UIGradient then
                local Color_2 = UIGradient.Color
                local Rotation_2 = UIGradient.Rotation
                Color = Color_2
                Rotation = Rotation_2
            end
        end
        for v94, v95 in ipairs(buttons) do
            local Tab = v95:GetAttribute("Tab")
            local v96 = dimOf(v95)
            if not v96 and v90 then
                v96 = v90:Clone()
                v96.Name = "Dim"
                v96.BackgroundTransparency = 1
                v96.Parent = v95
            end
            if v96 then
                noFade[v96] = true
            end
            local v97 = main:FindFirstChild(Tab .. "Tab")
            local v98 = {
                la = 0,
                dirty = false,
                hideAt = nil,
                button = v95,
                name = Tab
            }
            if not (v97 and v97:IsA("GuiObject")) then
                v97 = nil
            end
            v98.content = v97
            v98.grad = v95:FindFirstChildOfClass("UIGradient")
            v98.dim = v96
            v98.ov = Spring.new(1, T.TAB_DIM[1], T.TAB_DIM[2])
            v98.wt = v96 and v96.BackgroundTransparency or 1
            table.insert(v5, v98)
            v6[Tab] = v98
            local Activated = v95.Activated
            v84(v8, Activated:Connect(function() -- line 379 | captures: v98, v2
                v2.select(v98)
            end))
        end
    end

    function v2.bind(v99) -- line 386 | captures: v3, v4, staticActors, entranceList, refresh, park, toRest, chainVisible, ShopCards, EggItems, v7, v2, v5
        v4 = v99
        local staticActors_2 = v99.staticActors
        local entranceList_2 = v99.entranceList
        staticActors = staticActors_2
        entranceList = entranceList_2
        local Actors = v3.Actors
        local refresh_2 = Actors.refresh
        local park_2 = Actors.park
        local toRest_2 = Actors.toRest
        local chainVisible_2 = Actors.chainVisible
        refresh = refresh_2
        park = park_2
        toRest = toRest_2
        chainVisible = chainVisible_2
        local ShopCards_2 = v3.ShopCards
        local EggItems_2 = v3.EggItems
        ShopCards = ShopCards_2
        EggItems = EggItems_2
        v2.reset()
        for v100, v101 in ipairs(v5) do
            if v101.dim then
                local v102 = 1 - (1 - v101.ov.x) * (1 - 0)
                local v103 = v102 - v101.wt
                if v103 ~= 0 and (v103 > 0.004 or v103 < -0.004 or v102 == 1 or v102 == v7) then
                    v101.wt = v102
                    v101.dim.BackgroundTransparency = v102
                end
            end
        end
    end

    function v2.destroy() -- line 398 | captures: v8
        for v104, v105 in ipairs(v8) do
            v105:Disconnect()
        end
        table.clear(v8)
    end

    return v2
end

return v1
