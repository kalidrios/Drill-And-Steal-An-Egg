-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    new = function() -- new | line 45
        local v1 = {}
        local T, rng, gui, define, refresh, park, toRest, chainVisible, ShopCards, openCards, EggItems, openItems
        v1.staticActors = {}
        v1.panel = nil
        v1.impactDelay = nil
        local staticActors = v1.staticActors
        local v2 = {}
        v1.entranceList = v2

        local function add(v3) -- line 58 | captures: staticActors
            if v3 then
                table.insert(staticActors, v3)
            end
            return v3
        end

        local function sideOf(v4) -- line 65
            if v4.Position.X.Scale < 0.5 then
                return -1
            end
            return 1
        end

        local function defineAll(v5) -- line 71 | captures: T, rng, define, EggItems, v1, staticActors, add
            local Actors = v5.Actors
            local Idle = v5.Idle
            local Spring = v5.Spring
            local BG = v5.BG
            local setBob = Idle.setBob
            local v6 = Actors.makeActor(v5.main)
            local PANEL_FROM_Y = T.PANEL_FROM_Y
            local PANEL_FROM_SCALE = T.PANEL_FROM_SCALE
            v6.pX = 0
            v6.pY = PANEL_FROM_Y
            v6.pR = 0
            v6.pS = PANEL_FROM_SCALE
            v6.pA = 1
            local v7 = T.PANEL_IN[1]
            local v8 = T.PANEL_IN[2]
            v6.inAt = 0
            v6.inF = v7
            v6.inD = v8
            local PANEL_OUT_AT = T.PANEL_OUT_AT
            local v9 = T.PANEL_OUT[1]
            local v10 = T.PANEL_OUT[2]
            v6.outAt = PANEL_OUT_AT
            v6.outF = v9
            v6.outD = v10
            local PANEL_ALPHA_IN = T.PANEL_ALPHA_IN
            local PANEL_ALPHA_OUT = T.PANEL_ALPHA_OUT
            v6.aInF = PANEL_ALPHA_IN
            v6.aOutF = PANEL_ALPHA_OUT
            v6.outKick = T.PANEL_OUT_KICK
            local PANEL_OUT_Y = T.PANEL_OUT_Y
            local PANEL_OUT_SCALE = T.PANEL_OUT_SCALE
            v6.qY = PANEL_OUT_Y
            v6.qS = PANEL_OUT_SCALE
            v6.entrance = true
            v6.fades = false
            local FADE_PROPS = Actors.FADE_PROPS

            local function buildPanelFade() -- line 89 | captures: BG, v6, FADE_PROPS
                v6.fN = 0
                local v11 = FADE_PROPS[BG.ClassName]
                for v12, v13 in ipairs(v11) do
                    local v14 = BG[v13]
                    if v14 < 1 then
                        v6.fN += 1
                        local fI = v6.fI
                        local fN = v6.fN
                        local fP = v6.fP
                        local fN_2 = v6.fN
                        local fB = v6.fB
                        local fN_3 = v6.fN
                        fI[fN] = BG
                        fP[fN_2] = v13
                        fB[fN_3] = v14
                    end
                end
                for v15, v16 in ipairs(BG:GetDescendants()) do
                    local v17 = FADE_PROPS[v16.ClassName]
                    if v17 then
                        for v18, v19 in ipairs(v17) do
                            local v20 = v16[v19]
                            if v20 < 1 then
                                v6.fN += 1
                                local fI = v6.fI
                                local fN = v6.fN
                                local fP = v6.fP
                                local fN_2 = v6.fN
                                local fB = v6.fB
                                local fN_3 = v6.fN
                                fI[fN] = v16
                                fP[fN_2] = v19
                                fB[fN_3] = v20
                            end
                        end
                    end
                end
            end

            v6.buildPanelFade = buildPanelFade
            buildPanelFade()
            if v6 then
                table.insert(staticActors, v6)
            end
            v1.panel = v6
            Actors.panel = v6
            for v21, v22 in ipairs(v5.wings) do
                local v23 = if v22.Position.X.Scale < 0.5 then -1 else 1
                local v24 = define(v22, {
                    park = {
                        -v23 * T.WING_PARK_X,
                        0.04,
                        -v23 * 28,
                        0.5,
                        1
                    },
                    inAt = T.WING_AT,
                    inSpring = T.WING_IN,
                    outAt = T.WING_OUT_AT,
                    outSpring = T.RIG_OUT,
                    alphaOut = T.WING_ALPHA_OUT
                })
                if v24 then
                    table.insert(staticActors, v24)
                end
                v24.idle = Idle.FLAP
                v24.sync = v22:GetAttribute("SpriteSync")
                v24.idleDelay = 0.3
            end
            for v25, v26 in ipairs(v5.gates) do
                local v27 = if v26.Position.X.Scale < 0.5 then -1 else 1
                local v28 = define(v26, {
                    park = {
                        -v27 * 0.03,
                        0.14,
                        -v27 * 18,
                        0.7,
                        1
                    },
                    inAt = T.GATE_AT,
                    inSpring = T.GATE_IN,
                    outAt = T.GATE_OUT_AT,
                    outSpring = T.RIG_OUT
                })
                if v28 then
                    table.insert(staticActors, v28)
                end
                setBob(v28, rng:NextNumber(2.4, 3), 0.01, rng:NextNumber(3, 4.5) * v27, rng:NextNumber(0, 6.283185307179586))
            end
            for v29, v30 in ipairs(v5.tridents) do
                local v31 = if v30.Position.X.Scale < 0.5 then -1 else 1
                local v32 = define(v30, {
                    park = {
                        -v31 * 0.1,
                        0.08,
                        -v31 * 40,
                        0.6,
                        1
                    },
                    inAt = T.TRIDENT_AT,
                    inSpring = T.TRIDENT_IN,
                    outAt = T.TRIDENT_OUT_AT,
                    outSpring = T.RIG_OUT
                })
                if v32 then
                    table.insert(staticActors, v32)
                end
                setBob(v32, rng:NextNumber(1.9, 2.4), 0.016, rng:NextNumber(5, 7) * v31, rng:NextNumber(0, 6.283185307179586))
            end
            for v33, v34 in ipairs(v5.clouds) do
                local v35 = if v34.Position.X.Scale < 0.5 then -1 else 1
                local v36 = v34.ZIndex < BG.ZIndex
                local define_2 = define
                local v37 = {}
                v37.park = v36 and
                {
                    -v35 * 0.05,
                    0.06,
                    0,
                    0.5,
                    1
                } or
                {
                    v35 * 0.1,
                    0.03,
                    0,
                    0.6,
                    1
                }
                v37.inAt = v36 and T.CLOUD_BACK_AT or T.CLOUD_FRONT_AT
                v37.inSpring = T.CLOUD_IN
                v37.outAt = T.CLOUD_OUT_AT
                v37.outSpring = T.RIG_OUT
                local v38 = define_2(v34, v37)
                if v38 then
                    table.insert(staticActors, v38)
                end
                v38.idle = Idle.CLOUD
                v38.amp = rng:NextNumber(T.CLOUD_AMP_MIN, T.CLOUD_AMP_MAX)
                v38.wander = Spring.new(0, rng:NextNumber(T.CLOUD_F_MIN, T.CLOUD_F_MAX), 1)
                v38.nextAt = 0
                v38.idleDelay = 0.3
            end
            local flames = v5.flames
            table.sort(flames, function(v39, v40) -- line 179
                local v41 = v39.Position.X.Scale - 0.5
                local v42 = math.abs(v41)
                local v43 = v40.Position.X.Scale - 0.5
                return v42 < math.abs(v43)
            end)
            for v44, v45 in ipairs(flames) do
                local v46 = define(v45, {
                    alphaIn = 8,
                    park = { 0, 0.05, 0, 0, 1 },
                    inAt = T.FLAME_AT + (v44 - 1) * T.FLAME_STEP,
                    inSpring = T.FLAME_IN,
                    outAt = T.FLAME_OUT_AT + (#flames - v44) * T.FLAME_OUT_STEP,
                    outSpring = T.FLAME_OUT
                })
                if v46 then
                    table.insert(staticActors, v46)
                end
                v46.idle = Idle.FLAME
                v46.iw = 6.283185307179586 / rng:NextNumber(0.7, 1.1)
                v46.iph = rng:NextNumber(0, 6.283185307179586)
                v46.nextAt = 0
                v46.idleDelay = 0.6
                v46.rerollRot = T.FLAME_PARK_ROT
            end
            local v47 = define(v5.ShopTab, {
                park = { 0, 0.03, 0, 1, 1 },
                inAt = T.SHOPTAB_AT,
                inSpring = T.CONTENT_IN,
                outAt = T.SHOPTAB_OUT_AT,
                outSpring = T.CONTENT_OUT
            })
            if v47 then
                table.insert(staticActors, v47)
            end
            local EggTab = v5.EggTab
            local v48 = define(EggTab, {
                park = { 0, 0.03, 0, 1, 1 },
                inAt = T.SHOPTAB_AT,
                inSpring = T.CONTENT_IN,
                outAt = T.SHOPTAB_OUT_AT,
                outSpring = T.CONTENT_OUT
            })
            if v48 then
                table.insert(staticActors, v48)
            end
            if EggTab then
                EggItems.defineTab(EggTab, add)
            end
            for v49, v50 in ipairs(v5.Tabs.buttons) do
                local define_2 = define
                local v51 = {}
                local v52 = {}
                local v53 = if v49 % 2 == 1 then -20 else 20
                v52[1] = 0
                v52[2] = 0
                v52[3] = v53
                v52[4] = 0.4
                v52[5] = 1
                v51.park = v52
                v51.inAt = T.TAB_AT + (v49 - 1) * T.TAB_STEP
                v51.inSpring = T.TAB_IN
                v51.outAt = T.CLOSE_OUT_AT
                v51.outSpring = T.CONTENT_OUT
                local v54 = define_2(v50, v51)
                if v54 then
                    table.insert(staticActors, v54)
                end
            end
            local titles = v5.titles
            table.sort(titles, function(v55, v56) -- line 229
                return v55.Position.X.Scale < v56.Position.X.Scale
            end)
            for v57, v58 in ipairs(titles) do
                local v59 = if v57 % 2 == 1 then -10 else 10
                local v60 = define(v58, {
                    alphaIn = 8,
                    park = {
                        0,
                        -0.04,
                        v59,
                        T.TITLE_FROM_SCALE,
                        1
                    },
                    inAt = T.TITLE_AT + (v57 - 1) * T.TITLE_STEP,
                    inSpring = T.TITLE_IN,
                    outAt = T.TITLE_OUT_AT,
                    outSpring = T.CONTENT_OUT
                })
                if v60 then
                    table.insert(staticActors, v60)
                end
            end
            if #titles > 0 then
                local TITLE_AT = T.TITLE_AT
                local v61 = #titles - 1
                v1.impactDelay = TITLE_AT + math.max(v61, 0) * T.TITLE_STEP + T.IMPACT_AFTER
            end
            local v62 = define(v5.CurrencyHolder, {
                park = { -0.08, 0, 0, 0.8, 1 },
                inAt = T.CURRENCY_AT,
                inSpring = T.CONTENT_IN,
                outAt = T.CURRENCY_OUT_AT,
                outSpring = T.CONTENT_OUT
            })
            if v62 then
                table.insert(staticActors, v62)
            end
            local v63 = define(v5.CloseButton, {
                park = { 0, 0, -120, 0, 1 },
                inAt = T.CLOSE_AT,
                inSpring = T.CONTENT_IN,
                outAt = T.CLOSE_OUT_AT,
                outSpring = T.CONTENT_OUT
            })
            if v63 then
                table.insert(staticActors, v63)
            end
            local v64 = define(v5.Detail, {
                park = { 0, 0.03, 45, 0, 1 },
                inAt = T.DETAIL_AT,
                inSpring = { 3, 0.45 },
                outAt = T.DETAIL_OUT_AT,
                outSpring = T.CONTENT_OUT
            })
            if v64 then
                table.insert(staticActors, v64)
                setBob(v64, 2.6, 0.006, 0, 0)
            end
            Idle.defineTagged(v5, add, define)
        end

        function v1.prepareOpen(v65) -- line 278 | captures: T, rng, gui, refresh, park, chainVisible, ShopCards, openCards, EggItems, openItems, v1, staticActors, v2
            table.clear(v2)
            local panel = v1.panel
            panel.screen = gui.AbsoluteSize
            panel.buildPanelFade()
            for v66, v67 in ipairs(staticActors) do
                if chainVisible(v67.inst) then
                    refresh(v67)
                    if v67.rerollRot then
                        v67.pR = rng:NextNumber(-v67.rerollRot, v67.rerollRot)
                    end
                    table.insert(v2, v67)
                end
            end
            ShopCards.collect()
            for v68, v69 in ipairs(openCards) do
                refresh(v69)
                table.insert(v2, v69)
            end
            EggItems.collect()
            for v70, v71 in ipairs(openItems) do
                refresh(v71)
                table.insert(v2, v71)
            end
            for v72, v73 in ipairs(v2) do
                park(v73)
                v73.pend = 1
                v73.pendAt = v65 + v73.inAt * T.TIME_SCALE
            end
        end

        function v1.reopen(v74) -- line 311 | captures: T, v2
            for v75, v76 in ipairs(v2) do
                v76.pend = 1
                v76.pendAt = v74 + v76.inAt * T.TIME_SCALE * T.REOPEN_DELAY
            end
        end

        function v1.queueClose(v77) -- line 318 | captures: T, refresh, chainVisible, staticActors, v2
            for v78, v79 in ipairs(staticActors) do
                if not v79.session and chainVisible(v79.inst) then
                    refresh(v79)
                    v79.session = true
                    table.insert(v2, v79)
                end
            end
            for v80, v81 in ipairs(v2) do
                v81.pend = 2
                v81.pendAt = v77 + v81.outAt * T.TIME_SCALE
            end
        end

        function v1.clearOpen() -- line 335 | captures: openCards, openItems, v2
            table.clear(v2)
            table.clear(openCards)
            table.clear(openItems)
        end

        function v1.dropActor(v82) -- line 342 | captures: ShopCards, EggItems, v2
            local v83 = table.find(v2, v82)
            if v83 then
                table.remove(v2, v83)
            end
            ShopCards.forgetActor(v82)
            EggItems.forgetActor(v82)
        end

        function v1.clear() -- line 351 | captures: ShopCards, EggItems, v2
            table.clear(v2)
            ShopCards.clear()
            EggItems.clear()
        end

        function v1.init(v84) -- line 357 | captures: T, rng, gui, define, refresh, park, toRest, chainVisible, ShopCards, openCards, EggItems, openItems, defineAll
            local T_2 = v84.T
            local rng_2 = v84.rng
            local gui_2 = v84.gui
            T = T_2
            rng = rng_2
            gui = gui_2
            local define_2 = v84.Actors.define
            local refresh_2 = v84.Actors.refresh
            local park_2 = v84.Actors.park
            local toRest_2 = v84.Actors.toRest
            define = define_2
            refresh = refresh_2
            park = park_2
            toRest = toRest_2
            chainVisible = v84.Actors.chainVisible
            ShopCards = v84.ShopCards
            openCards = ShopCards.openCards
            EggItems = v84.EggItems
            openItems = EggItems.openItems
            defineAll(v84)
        end

        return v1
    end
}
