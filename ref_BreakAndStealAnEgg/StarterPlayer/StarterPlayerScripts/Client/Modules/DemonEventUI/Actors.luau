-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    new = function() -- new | line 32
        local v1 = {}
        local Spring, snap, to, kick, T, gui, grids, POS_EPS, ROT_EPS, SCALE_EPS, ALPHA_EPS, LAYER_EPS
        local v2 = {}
        local v3 = {}
        v1.map = v2
        v1.list = v3
        v1.count = 0
        v1.noFade = {}
        v1.FADE_PROPS = {
            ImageLabel = { "ImageTransparency", "BackgroundTransparency" },
            ImageButton = { "ImageTransparency", "BackgroundTransparency" },
            TextLabel = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" },
            TextButton = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" },
            TextBox = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" },
            Frame = { "BackgroundTransparency" },
            CanvasGroup = { "GroupTransparency", "BackgroundTransparency" },
            ScrollingFrame = { "ScrollBarImageTransparency", "BackgroundTransparency" },
            ViewportFrame = { "ImageTransparency", "BackgroundTransparency" },
            UIStroke = { "Transparency" },
            UIShadow = { "Transparency" }
        }
        local FADE_PROPS = v1.FADE_PROPS

        function v1.chainVisible(v4) -- line 67 | captures: gui
            local v5 = v4
            while v5 do
                if v5 == gui then
                    break
                end
                if not v5:IsA("GuiObject") or v5.Visible then
                    v5 = v5.Parent
                    continue
                end
                return false
            end
            return v5 == gui
        end

        local noFade = v1.noFade

        local function isGridItem(v6) -- line 80 | captures: grids
            for v7, v8 in ipairs(grids) do
                if v6.Parent == v8 then
                    return true
                end
            end
            return false
        end

        function v1.makeActor(v9, v10) -- line 89 | captures: Spring, T, POS_EPS, ROT_EPS, SCALE_EPS, v1, v2, v3
            local v11 = v2[v9]
            if v11 then
                return v11
            end
            local UIScale = v9:FindFirstChildOfClass("UIScale")
            if not (UIScale or v10) then
                UIScale = Instance.new("UIScale")
                UIScale.Name = T.SCALE_NAME
                UIScale.Parent = v9
            end
            local Position = v9.Position
            local v12 = {
                inst = v9,
                layer = nil,
                lRest = nil,
                ld = nil,
                wd = 1,
                scaleObj = UIScale,
                hxS = Position.X.Scale,
                hxO = Position.X.Offset,
                hyS = Position.Y.Scale,
                hyO = Position.Y.Offset,
                hRot = v9.Rotation
            }
            v12.hScale = UIScale and UIScale.Scale or 1
            v12.ox = Spring.new(0, 3, 1)
            v12.oy = Spring.new(0, 3, 1)
            v12.rot = Spring.new(0, 3, 1)
            v12.sc = Spring.new(1, 3, 1)
            v12.a = Spring.new(0, T.ALPHA_IN, 1)
            v12.hs = nil
            v12.hr = nil
            v12.ix = 0
            v12.iy = 0
            v12.ir = 0
            v12.is = 1
            v12.wx = 0
            v12.wy = 0
            v12.wr = 0
            v12.ws = 1
            v12.wa = 0
            v12.eP = POS_EPS
            v12.eR = ROT_EPS
            v12.eS = SCALE_EPS
            v12.fades = false
            v12.fI = {}
            v12.fP = {}
            v12.fB = {}
            v12.fN = 0
            v12.pX = 0
            v12.pY = 0
            v12.pR = 0
            v12.pS = 1
            v12.pA = 0
            v12.inAt = 0
            v12.inF = 3
            v12.inD = 0.6
            v12.aInF = T.ALPHA_IN
            v12.outAt = 0
            v12.outF = 4
            v12.outD = 1
            v12.aOutF = T.ALPHA_OUT
            v12.outKick = 0
            v12.pend = 0
            v12.pendAt = 0
            v12.idle = 0
            v12.idleAt = (1/0)
            v12.idleDelay = 0.35
            v12.live = false
            v12.session = false
            v12.index = 0
            local v13 = v1.count + 1
            v1.count = v13
            v3[v13] = v12
            v12.index = v13
            v2[v9] = v12
            return v12
        end

        function v1.removeActor(v14) -- line 179 | captures: v1, v2, v3
            local v15 = v2[v14]
            if not v15 then
                return
            end
            v2[v14] = nil
            local count = v1.count
            local v16 = v3[count]
            v3[v15.index] = v16
            v16.index = v15.index
            v3[count] = nil
            v1.count = count - 1
        end

        local function buildFade(v17) -- line 195 | captures: grids, v2, FADE_PROPS, noFade
            local fI = v17.fI
            local fP = v17.fP
            local fB = v17.fB
            local v18 = 0

            local function add(v19) -- line 199 | captures: v18, fI, fP, fB, FADE_PROPS, noFade
                local v20 = FADE_PROPS[v19.ClassName]
                if v20 and not noFade[v19] then
                    for v21, v22 in ipairs(v20) do
                        local v23 = v19[v22]
                        if v23 < 1 then
                            v18 += 1
                            fI[v18] = v19
                            fP[v18] = v22
                            fB[v18] = v23
                        end
                    end
                end
            end

            local walk

            local function walk_2(v24) -- line 215 | captures: add, walk, grids, v2
                add(v24)
                for v25, v26 in ipairs(v24:GetChildren()) do
                    local v27 = v2[v26]
                    if v26:IsA("GuiObject") then
                        if v26.Visible then
                            local v28 = false
                            for v29, v30 in ipairs(grids) do
                                if v26.Parent == v30 then
                                    v28 = true
                                    break
                                end
                                v28 = false
                            end
                            if not v28 then
                                if v27 then
                                    if not v27.entrance then
                                        walk(v26)
                                    end
                                else
                                    walk(v26)
                                end
                            end
                        end
                    else
                        walk(v26)
                    end
                end
            end

            walk = walk_2
            walk_2(v17.inst)
            local v31 = v18 + 1
            local fN = v17.fN
            for v32 = v31, fN do
                fI[v32] = nil
                fP[v32] = nil
                fB[v32] = nil
            end
            v17.fN = v18
        end

        local function writeLayer(v33, v34) -- line 236
            v33.wd = v34
            local lRest = v33.lRest
            if v34 == 1 then
                v33.layer.Position = lRest
            else
                local X = lRest.X
                local Y = lRest.Y
                v33.layer.Position = UDim2.new(0.5 + (X.Scale - 0.5) * v34, X.Offset * v34, 0.5 + (Y.Scale - 0.5) * v34, Y.Offset * v34)
            end
        end

        local function setLayer(v35, v36) -- line 249
            if v35.layer == v36 then
                return
            end
            v35.layer = v36
            v35.lRest = v36 and v36.Position or nil
            v35.wd = 1
        end

        v1.setLayer = setLayer

        local function writeFade(v37, v38) -- line 258
            local fI = v37.fI
            local fP = v37.fP
            local fB = v37.fB
            local fN = v37.fN
            for v39 = 1, fN do
                local v40 = fB[v39]
                fI[v39][fP[v39]] = v40 + (1 - v40) * v38
            end
        end

        function v1.writeActor(v41) -- line 267 | captures: ALPHA_EPS, LAYER_EPS, writeFade
            local v42 = v41.ox.x + v41.ix
            local v43 = v41.oy.x + v41.iy
            local v44 = v42 - v41.wx
            local v45 = v43 - v41.wy
            local eP = v41.eP
            if eP < v44 or v44 < -eP or eP < v45 or v45 < -eP then
                v41.wx = v42
                v41.wy = v43
                v41.inst.Position = UDim2.new(v41.hxS + v42, v41.hxO, v41.hyS + v43, v41.hyO)
            end
            local v46 = v41.rot.x + v41.ir
            local hr = v41.hr
            if hr then
                v46 += hr.x
            end
            local v47 = v46 - v41.wr
            local eR = v41.eR
            if eR < v47 or v47 < -eR then
                v41.wr = v46
                v41.inst.Rotation = v41.hRot + v46
            end
            local v48 = v41.sc.x * v41.is
            local hs = v41.hs
            if hs then
                v48 *= hs.x
            end
            if v48 < 0 then
                v48 = 0
            end
            local v49 = v48 - v41.ws
            local eS = v41.eS
            if (eS < v49 or v49 < -eS) and v41.scaleObj then
                v41.ws = v48
                v41.scaleObj.Scale = v41.hScale * v48
            end
            local ld = v41.ld
            local v50
            if ld then
                local v51 = ld.x - v41.wd
                if LAYER_EPS < v51 then
                    v50 = false
                else
                    v50 = not (v51 < -LAYER_EPS)
                end
            else
                v50 = true
            end
            if not v50 then
                local x = ld.x
                v41.wd = x
                local lRest = v41.lRest
                if x == 1 then
                    v41.layer.Position = lRest
                else
                    local X = lRest.X
                    local Y = lRest.Y
                    v41.layer.Position = UDim2.new(0.5 + (X.Scale - 0.5) * x, X.Offset * x, 0.5 + (Y.Scale - 0.5) * x, Y.Offset * x)
                end
            end
            if not (v41.fN > 0) then
                return
            end
            local x = v41.a.x
            if x < 0 then
                x = 0
            elseif x > 1 then
                x = 1
            end
            local v52 = x - v41.wa
            if v52 ~= 0 and (ALPHA_EPS < v52 or v52 < -ALPHA_EPS or x == 0 or x == 1) then
                v41.wa = x
                writeFade(v41, x)
            end
        end

        local function forceWrite(v53) -- line 331 | captures: writeFade
            local v54 = v53.ox.x + v53.ix
            local v55 = v53.oy.x + v53.iy
            if not (v54 == v53.wx and v55 == v53.wy) then
                v53.wx = v54
                v53.wy = v55
                v53.inst.Position = UDim2.new(v53.hxS + v54, v53.hxO, v53.hyS + v55, v53.hyO)
            end
            local v56 = v53.rot.x + v53.ir + (v53.hr and v53.hr.x or 0)
            if v56 ~= v53.wr then
                v53.wr = v56
                v53.inst.Rotation = v53.hRot + v56
            end
            local v57 = v53.sc.x * v53.is * (v53.hs and v53.hs.x or 1)
            local v58 = math.max(v57, 0)
            if v58 ~= v53.ws and v53.scaleObj then
                v53.ws = v58
                v53.scaleObj.Scale = v53.hScale * v58
            end
            if v53.ld and v53.ld.x ~= v53.wd then
                local x = v53.ld.x
                v53.wd = x
                local lRest = v53.lRest
                if x == 1 then
                    v53.layer.Position = lRest
                else
                    local X = lRest.X
                    local Y = lRest.Y
                    v53.layer.Position = UDim2.new(0.5 + (X.Scale - 0.5) * x, X.Offset * x, 0.5 + (Y.Scale - 0.5) * x, Y.Offset * x)
                end
            end
            local x = v53.a.x
            local v59 = math.clamp(x, 0, 1)
            if v59 ~= v53.wa then
                v53.wa = v59
                writeFade(v53, v59)
            end
        end

        v1.forceWrite = forceWrite

        function v1.refresh(v60) -- line 362 | captures: T, POS_EPS, ROT_EPS, SCALE_EPS, v1, buildFade
            local Position = v60.inst.Position
            local Scale = Position.X.Scale
            local Offset = Position.X.Offset
            local Scale_2 = Position.Y.Scale
            local Offset_2 = Position.Y.Offset
            v60.hxS = Scale
            v60.hxO = Offset
            v60.hyS = Scale_2
            v60.hyO = Offset_2
            v60.hRot = v60.inst.Rotation
            v60.hScale = v60.scaleObj and v60.scaleObj.Scale or 1
            if v60.layer then
                v60.lRest = v60.layer.Position
            end
            local Parent = v60.inst.Parent
            local screen = v1.panel.screen
            local AbsoluteSize = v60.eKey ~= screen and v60.inst.AbsoluteSize or Vector2.zero
            if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
                local X = AbsoluteSize.X
                local Y = AbsoluteSize.Y
                local v61 = math.max(X, Y)
                if T.MIN_READ_PX <= v61 and Parent and Parent:IsA("GuiBase2d") then
                    v60.eKey = screen
                    local WRITE_PX = T.WRITE_PX
                    local AbsoluteSize_2 = Parent.AbsoluteSize
                    local POS_EPS_2 = POS_EPS
                    local X = AbsoluteSize_2.X
                    local Y = AbsoluteSize_2.Y
                    local v62 = WRITE_PX / math.max(X, Y, 1)
                    v60.eP = math.max(POS_EPS_2, v62)
                    local ROT_EPS_2 = ROT_EPS
                    local v63 = WRITE_PX * 360 / (3.141592653589793 * AbsoluteSize.Magnitude)
                    v60.eR = math.max(ROT_EPS_2, v63)
                    local SCALE_EPS_2 = SCALE_EPS
                    local X_2 = AbsoluteSize.X
                    local Y_2 = AbsoluteSize.Y
                    local v64 = WRITE_PX / math.max(X_2, Y_2)
                    v60.eS = math.max(SCALE_EPS_2, v64)
                end
            end
            if v60.fades then
                buildFade(v60)
            elseif v60.customFade then
                v60.customFade(v60)
            end
        end

        function v1.park(v65) -- line 398 | captures: snap, forceWrite
            snap(v65.ox, v65.pX)
            snap(v65.oy, v65.pY)
            snap(v65.rot, v65.pR)
            snap(v65.sc, v65.pS)
            snap(v65.a, v65.pA)
            v65.ix = 0
            v65.iy = 0
            v65.ir = 0
            v65.is = 1
            if v65.ld then
                snap(v65.ld, 1)
            end
            if v65.spinA then
                v65.spinA = 0
            end
            v65.idleAt = (1/0)
            v65.session = true
            forceWrite(v65)
        end

        function v1.toRest(v66) -- line 416 | captures: snap, forceWrite
            snap(v66.ox, 0)
            snap(v66.oy, 0)
            snap(v66.rot, 0)
            snap(v66.sc, 1)
            snap(v66.a, 0)
            if v66.hs then
                snap(v66.hs, 1)
                snap(v66.hr, 0)
            end
            if v66.ld then
                snap(v66.ld, 1)
            end
            v66.ix = 0
            v66.iy = 0
            v66.ir = 0
            v66.is = 1
            if v66.spinA then
                v66.spinA = 0
            end
            v66.pend = 0
            v66.idleAt = (1/0)
            v66.live = false
            v66.session = false
            forceWrite(v66)
        end

        function v1.goIn(v67, v68) -- line 441 | captures: to
            to(v67.ox, 0, v67.inF, v67.inD)
            to(v67.oy, 0, v67.inF, v67.inD)
            to(v67.rot, 0, v67.inF, v67.inD)
            to(v67.sc, 1, v67.inF, v67.inD)
            to(v67.a, 0, v67.aInF, 1)
            v67.idleAt = v68 + v67.idleDelay
            v67.live = true
        end

        function v1.goOut(v69) -- line 451 | captures: to, kick
            to(v69.ox, v69.pX, v69.outF, v69.outD)
            to(v69.oy, v69.qY or v69.pY, v69.outF, v69.outD)
            to(v69.rot, v69.pR, v69.outF, v69.outD)
            to(v69.sc, v69.qS or v69.pS, v69.outF, v69.outD)
            to(v69.a, v69.pA, v69.aOutF, 1)
            if v69.outKick ~= 0 then
                kick(v69.sc, v69.outKick)
            end
            v69.live = true
        end

        function v1.define(v70, v71) -- line 467 | captures: T, v1
            if v70 then
                local v72 = v1.makeActor(v70, v71.noScale)
                local park = v71.park
                local v73 = park[1]
                local v74 = park[2]
                local v75 = park[3]
                local v76 = park[4]
                local v77 = park[5]
                v72.pX = v73
                v72.pY = v74
                v72.pR = v75
                v72.pS = v76
                v72.pA = v77
                v72.inAt = v71.inAt
                local v78 = v71.inSpring[1]
                local v79 = v71.inSpring[2]
                v72.inF = v78
                v72.inD = v79
                v72.outAt = v71.outAt
                local v80 = v71.outSpring[1]
                local v81 = v71.outSpring[2]
                v72.outF = v80
                v72.outD = v81
                v72.aInF = v71.alphaIn or T.ALPHA_IN
                v72.aOutF = v71.alphaOut or T.ALPHA_OUT
                v72.outKick = v71.outKick or 0
                v72.fades = v71.fades ~= false
                v72.tabAt = v71.tabAt or 0
                v72.entrance = true
                return v72
            end
            return nil
        end

        function v1.init(v82) -- line 487 | captures: Spring, snap, to, kick, T, gui, grids, POS_EPS, ROT_EPS, SCALE_EPS, ALPHA_EPS, LAYER_EPS
            Spring = v82.Spring
            local snap_2 = Spring.snap
            local to_2 = Spring.to
            local kick_2 = Spring.kick
            snap = snap_2
            to = to_2
            kick = kick_2
            T = v82.T
            local gui_2 = v82.gui
            local grids_2 = v82.grids
            gui = gui_2
            grids = grids_2
            local POS_EPS_2 = T.POS_EPS
            local ROT_EPS_2 = T.ROT_EPS
            local SCALE_EPS_2 = T.SCALE_EPS
            local ALPHA_EPS_2 = T.ALPHA_EPS
            POS_EPS = POS_EPS_2
            ROT_EPS = ROT_EPS_2
            SCALE_EPS = SCALE_EPS_2
            ALPHA_EPS = ALPHA_EPS_2
            LAYER_EPS = T.LAYER_EPS
        end

        function v1.clear() -- line 496 | captures: v1, v2, v3, noFade
            table.clear(noFade)
            table.clear(v2)
            table.clear(v3)
            v1.count = 0
        end

        return v1
    end
}
