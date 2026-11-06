-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local Spring, snap, to, kick, T, gui, grids, POS_EPS, ROT_EPS, SCALE_EPS, ALPHA_EPS
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

function v1.chainVisible(v4) -- line 54 | captures: gui
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

local function isGridItem(v6) -- line 67 | captures: grids
    for v7, v8 in ipairs(grids) do
        if v6.Parent == v8 then
            return true
        end
    end
    return false
end

function v1.makeActor(v9, v10) -- line 76 | captures: Spring, T, POS_EPS, ROT_EPS, SCALE_EPS, v1, v2, v3
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

function v1.removeActor(v14) -- line 161 | captures: v1, v2, v3
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

local function buildFade(v17) -- line 177 | captures: grids, v2, FADE_PROPS, noFade
    local fI = v17.fI
    local fP = v17.fP
    local fB = v17.fB
    local v18 = 0

    local function add(v19) -- line 181 | captures: v18, fI, fP, fB, FADE_PROPS, noFade
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

    local function walk_2(v24) -- line 197 | captures: add, walk, grids, v2
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

local function writeFade(v33, v34) -- line 216
    local fI = v33.fI
    local fP = v33.fP
    local fB = v33.fB
    local fN = v33.fN
    for v35 = 1, fN do
        local v36 = fB[v35]
        fI[v35][fP[v35]] = v36 + (1 - v36) * v34
    end
end

function v1.writeActor(v37) -- line 225 | captures: ALPHA_EPS, writeFade
    local v38 = v37.ox.x + v37.ix
    local v39 = v37.oy.x + v37.iy
    local v40 = v38 - v37.wx
    local v41 = v39 - v37.wy
    local eP = v37.eP
    if eP < v40 or v40 < -eP or eP < v41 or v41 < -eP then
        v37.wx = v38
        v37.wy = v39
        v37.inst.Position = UDim2.new(v37.hxS + v38, v37.hxO, v37.hyS + v39, v37.hyO)
    end
    local v42 = v37.rot.x + v37.ir
    local hr = v37.hr
    if hr then
        v42 += hr.x
    end
    local v43 = v42 - v37.wr
    local eR = v37.eR
    if eR < v43 or v43 < -eR then
        v37.wr = v42
        v37.inst.Rotation = v37.hRot + v42
    end
    local v44 = v37.sc.x * v37.is
    local hs = v37.hs
    if hs then
        v44 *= hs.x
    end
    if v44 < 0 then
        v44 = 0
    end
    local v45 = v44 - v37.ws
    local eS = v37.eS
    if (eS < v45 or v45 < -eS) and v37.scaleObj then
        v37.ws = v44
        v37.scaleObj.Scale = v37.hScale * v44
    end
    if not (v37.fN > 0) then
        return
    end
    local x = v37.a.x
    if x < 0 then
        x = 0
    elseif x > 1 then
        x = 1
    end
    local v46 = x - v37.wa
    if v46 ~= 0 and (ALPHA_EPS < v46 or v46 < -ALPHA_EPS or x == 0 or x == 1) then
        v37.wa = x
        writeFade(v37, x)
    end
end

local function forceWrite(v47) -- line 281 | captures: writeFade
    local v48 = v47.ox.x + v47.ix
    local v49 = v47.oy.x + v47.iy
    if not (v48 == v47.wx and v49 == v47.wy) then
        v47.wx = v48
        v47.wy = v49
        v47.inst.Position = UDim2.new(v47.hxS + v48, v47.hxO, v47.hyS + v49, v47.hyO)
    end
    local v50 = v47.rot.x + v47.ir + (v47.hr and v47.hr.x or 0)
    if v50 ~= v47.wr then
        v47.wr = v50
        v47.inst.Rotation = v47.hRot + v50
    end
    local v51 = v47.sc.x * v47.is * (v47.hs and v47.hs.x or 1)
    local v52 = math.max(v51, 0)
    if v52 ~= v47.ws and v47.scaleObj then
        v47.ws = v52
        v47.scaleObj.Scale = v47.hScale * v52
    end
    local x = v47.a.x
    local v53 = math.clamp(x, 0, 1)
    if v53 ~= v47.wa then
        v47.wa = v53
        writeFade(v47, v53)
    end
end

v1.forceWrite = forceWrite

function v1.refresh(v54) -- line 309 | captures: T, POS_EPS, ROT_EPS, SCALE_EPS, v1, buildFade
    local Position = v54.inst.Position
    local Scale = Position.X.Scale
    local Offset = Position.X.Offset
    local Scale_2 = Position.Y.Scale
    local Offset_2 = Position.Y.Offset
    v54.hxS = Scale
    v54.hxO = Offset
    v54.hyS = Scale_2
    v54.hyO = Offset_2
    v54.hRot = v54.inst.Rotation
    v54.hScale = v54.scaleObj and v54.scaleObj.Scale or 1
    local Parent = v54.inst.Parent
    local screen = v1.panel.screen
    local AbsoluteSize = v54.eKey ~= screen and v54.inst.AbsoluteSize or Vector2.zero
    if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 and Parent and Parent:IsA("GuiBase2d") then
        v54.eKey = screen
        local WRITE_PX = T.WRITE_PX
        local AbsoluteSize_2 = Parent.AbsoluteSize
        local POS_EPS_2 = POS_EPS
        local X = AbsoluteSize_2.X
        local Y = AbsoluteSize_2.Y
        local v55 = WRITE_PX / math.max(X, Y, 1)
        v54.eP = math.max(POS_EPS_2, v55)
        local ROT_EPS_2 = ROT_EPS
        local v56 = WRITE_PX * 360 / (3.141592653589793 * AbsoluteSize.Magnitude)
        v54.eR = math.max(ROT_EPS_2, v56)
        local SCALE_EPS_2 = SCALE_EPS
        local X_2 = AbsoluteSize.X
        local Y_2 = AbsoluteSize.Y
        local v57 = WRITE_PX / math.max(X_2, Y_2)
        v54.eS = math.max(SCALE_EPS_2, v57)
    end
    if v54.fades then
        buildFade(v54)
    elseif v54.customFade then
        v54.customFade(v54)
    end
end

function v1.park(v58) -- line 339 | captures: snap, forceWrite
    snap(v58.ox, v58.pX)
    snap(v58.oy, v58.pY)
    snap(v58.rot, v58.pR)
    snap(v58.sc, v58.pS)
    snap(v58.a, v58.pA)
    v58.ix = 0
    v58.iy = 0
    v58.ir = 0
    v58.is = 1
    if v58.spinA then
        v58.spinA = 0
    end
    v58.idleAt = (1/0)
    v58.session = true
    forceWrite(v58)
end

function v1.toRest(v59) -- line 354 | captures: snap, forceWrite
    snap(v59.ox, 0)
    snap(v59.oy, 0)
    snap(v59.rot, 0)
    snap(v59.sc, 1)
    snap(v59.a, 0)
    if v59.hs then
        snap(v59.hs, 1)
        snap(v59.hr, 0)
    end
    v59.ix = 0
    v59.iy = 0
    v59.ir = 0
    v59.is = 1
    if v59.spinA then
        v59.spinA = 0
    end
    v59.pend = 0
    v59.idleAt = (1/0)
    v59.live = false
    v59.session = false
    forceWrite(v59)
end

function v1.goIn(v60, v61) -- line 376 | captures: to
    to(v60.ox, 0, v60.inF, v60.inD)
    to(v60.oy, 0, v60.inF, v60.inD)
    to(v60.rot, 0, v60.inF, v60.inD)
    to(v60.sc, 1, v60.inF, v60.inD)
    to(v60.a, 0, v60.aInF, 1)
    v60.idleAt = v61 + v60.idleDelay
    v60.live = true
end

function v1.goOut(v62) -- line 386 | captures: to, kick
    to(v62.ox, v62.pX, v62.outF, v62.outD)
    to(v62.oy, v62.qY or v62.pY, v62.outF, v62.outD)
    to(v62.rot, v62.pR, v62.outF, v62.outD)
    to(v62.sc, v62.qS or v62.pS, v62.outF, v62.outD)
    to(v62.a, v62.pA, v62.aOutF, 1)
    if v62.outKick ~= 0 then
        kick(v62.sc, v62.outKick)
    end
    v62.live = true
end

function v1.define(v63, v64) -- line 402 | captures: T, v1
    if v63 then
        local v65 = v1.makeActor(v63, v64.noScale)
        local park = v64.park
        local v66 = park[1]
        local v67 = park[2]
        local v68 = park[3]
        local v69 = park[4]
        local v70 = park[5]
        v65.pX = v66
        v65.pY = v67
        v65.pR = v68
        v65.pS = v69
        v65.pA = v70
        v65.inAt = v64.inAt
        local v71 = v64.inSpring[1]
        local v72 = v64.inSpring[2]
        v65.inF = v71
        v65.inD = v72
        v65.outAt = v64.outAt
        local v73 = v64.outSpring[1]
        local v74 = v64.outSpring[2]
        v65.outF = v73
        v65.outD = v74
        v65.aInF = v64.alphaIn or T.ALPHA_IN
        v65.aOutF = v64.alphaOut or T.ALPHA_OUT
        v65.outKick = v64.outKick or 0
        v65.fades = v64.fades ~= false
        v65.tabAt = v64.tabAt or 0
        v65.entrance = true
        return v65
    end
    return nil
end

function v1.init(v75) -- line 422 | captures: Spring, snap, to, kick, T, gui, grids, POS_EPS, ROT_EPS, SCALE_EPS, ALPHA_EPS
    Spring = v75.Spring
    local snap_2 = Spring.snap
    local to_2 = Spring.to
    local kick_2 = Spring.kick
    snap = snap_2
    to = to_2
    kick = kick_2
    T = v75.T
    local gui_2 = v75.gui
    local grids_2 = v75.grids
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
end

function v1.clear() -- line 430 | captures: v1, v2, v3, noFade
    table.clear(noFade)
    table.clear(v2)
    table.clear(v3)
    v1.count = 0
end

return v1
