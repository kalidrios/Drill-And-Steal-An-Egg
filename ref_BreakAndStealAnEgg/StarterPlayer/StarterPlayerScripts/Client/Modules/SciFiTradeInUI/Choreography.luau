-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local T, rng, gui, define, refresh, park, chainVisible, Rows, openItems

v1.staticActors = {}
v1.panel = nil
v1.impactDelay = nil

local staticActors = v1.staticActors
local v2 = {}

v1.entranceList = v2

local function add(v3) -- line 44 | captures: staticActors
    if v3 then
        table.insert(staticActors, v3)
    end
    return v3
end

local function sideOf(v4) -- line 51
    if v4.Position.X.Scale < 0.5 then
        return -1
    end
    return 1
end

local function defineAll(v5) -- line 55 | captures: T, rng, define, v1, staticActors, add
    local Actors = v5.Actors
    local Idle = v5.Idle
    local main = v5.main
    local v6 = Actors.makeActor(main)
    local PANEL_FROM_Y = T.PANEL_FROM_Y
    local PANEL_FROM_SCALE = T.PANEL_FROM_SCALE
    v6.pX = 0
    v6.pY = PANEL_FROM_Y
    v6.pR = 0
    v6.pS = PANEL_FROM_SCALE
    v6.pA = 1
    local PANEL_AT = T.PANEL_AT
    local v7 = T.PANEL_IN[1]
    local v8 = T.PANEL_IN[2]
    v6.inAt = PANEL_AT
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
    v6.fades = true
    if v6 then
        table.insert(staticActors, v6)
    end
    v1.panel = v6
    Actors.panel = v6
    local decor = v5.decor
    table.sort(decor, function(v11, v12) -- line 80
        local v13 = v11.Position.X.Scale - 0.5
        local v14 = math.abs(v13)
        local v15 = v12.Position.X.Scale - 0.5
        local v16 = math.abs(v15)
        if v11.Name == v12.Name then
            return v11.Position.X.Scale < v12.Position.X.Scale
        end
        return v16 < v14
    end)
    local v17 = {}
    local v18 = 0
    for v19, v20 in ipairs(decor) do
        if not v17[v20.Name] then
            v17[v20.Name] = v18
            v18 += 1
        end
        local v21 = if v20.Position.X.Scale < 0.5 then -1 else 1
        local v22 = define(v20, {
            alphaIn = 8,
            park = {
                -v21 * 0.02,
                0.05,
                -v21 * T.DECOR_PARK_ROT,
                0,
                1
            },
            inAt = T.DECOR_AT + v17[v20.Name] * T.DECOR_STEP,
            inSpring = T.DECOR_IN,
            outAt = T.DECOR_OUT_AT,
            outSpring = T.RIG_OUT
        })
        if v22 then
            table.insert(staticActors, v22)
        end
        if v20.Name ~= "BlackHole" then
            Idle.setBob(v22, rng:NextNumber(T.DECOR_BOB[1], T.DECOR_BOB[2]), T.DECOR_BOB_Y, T.DECOR_BOB_R * v21, rng:NextNumber(0, 6.283185307179586))
        end
    end
    local v23 = define(v5.Header, {
        park = { 0, -0.04, 0, 1, 1 },
        inAt = T.HEADER_AT,
        inSpring = T.CONTENT_IN,
        outAt = T.CONTENT_OUT_AT,
        outSpring = T.CONTENT_OUT
    })
    if v23 then
        table.insert(staticActors, v23)
    end
    if v5.Title then
        local v24 = define(v5.Title, {
            alphaIn = 8,
            park = {
                0,
                -0.04,
                -8,
                T.TITLE_FROM_SCALE,
                1
            },
            inAt = T.TITLE_AT,
            inSpring = T.TITLE_IN,
            outAt = T.TITLE_OUT_AT,
            outSpring = T.CONTENT_OUT
        })
        if v24 then
            table.insert(staticActors, v24)
        end
        v1.impactDelay = T.TITLE_AT + T.IMPACT_AFTER
    end
    table.sort(v5.inputs, function(v25, v26) -- line 123
        return v25.Position.X.Scale < v26.Position.X.Scale
    end)
    for v27, v28 in ipairs(v5.inputs) do
        local v29 = define(v28, {
            park = {
                0,
                0.08,
                (v27 - 2) * 6,
                0.5,
                1
            },
            inAt = T.INPUT_AT + (v27 - 1) * T.INPUT_STEP,
            inSpring = T.INPUT_IN,
            outAt = T.CONTENT_OUT_AT + (#v5.inputs - v27) * 0.015,
            outSpring = T.CONTENT_OUT
        })
        if v29 then
            table.insert(staticActors, v29)
        end
    end
    for v30, v31 in ipairs(v5.bars) do
        local v32 = define(v31, {
            park = { 0, 0.04, 0, 0.6, 1 },
            inAt = T.BARS_AT + (v30 - 1) * 0.03,
            inSpring = T.CONTENT_IN,
            outAt = T.CONTENT_OUT_AT,
            outSpring = T.CONTENT_OUT
        })
        if v32 then
            table.insert(staticActors, v32)
        end
    end
    local v33 = define(v5.EnergyBall, {
        alphaIn = 8,
        park = { 0, 0, 0, 0, 1 },
        inAt = T.OUTPUT_AT - 0.04,
        inSpring = T.DECOR_IN,
        outAt = T.CONTENT_OUT_AT,
        outSpring = T.RIG_OUT
    })
    if v33 then
        table.insert(staticActors, v33)
    end
    local v34 = define(v5.Output, {
        park = { 0, 0.03, 10, 0.3, 1 },
        inAt = T.OUTPUT_AT,
        inSpring = T.TITLE_IN,
        outAt = T.CONTENT_OUT_AT,
        outSpring = T.CONTENT_OUT
    })
    if v34 then
        table.insert(staticActors, v34)
    end
    local v35 = define(v5.Sacrifice, {
        park = { 0, 0.02, 0, 0.5, 1 },
        inAt = T.SACRIFICE_AT,
        inSpring = T.BUY_IN,
        outAt = T.CLOSE_OUT_AT,
        outSpring = T.CONTENT_OUT
    })
    if v35 then
        table.insert(staticActors, v35)
    end
    local v36 = define(v5.Chances, {
        park = { -0.06, 0, 0, 0.94, 1 },
        inAt = T.CHANCES_AT,
        inSpring = T.CONTENT_IN,
        outAt = T.CONTENT_OUT_AT,
        outSpring = T.CONTENT_OUT
    })
    if v36 then
        table.insert(staticActors, v36)
    end
    local v37 = define(v5.ChancesTitle, {
        alphaIn = 8,
        park = { 0, -0.02, 6, 1.5, 1 },
        inAt = T.CHANCES_TITLE_AT,
        inSpring = T.TITLE_IN,
        outAt = T.TITLE_OUT_AT,
        outSpring = T.CONTENT_OUT
    })
    if v37 then
        table.insert(staticActors, v37)
    end
    local v38 = define(v5.CloseButton, {
        park = { 0, 0, -120, 0, 1 },
        inAt = T.CLOSE_AT,
        inSpring = T.CONTENT_IN,
        outAt = T.CLOSE_OUT_AT,
        outSpring = T.CONTENT_OUT
    })
    if v38 then
        table.insert(staticActors, v38)
    end
    Idle.defineTagged(v5, add, define)
end

function v1.prepareOpen(v39) -- line 187 | captures: T, gui, refresh, park, chainVisible, Rows, openItems, v1, staticActors, v2
    table.clear(v2)
    v1.panel.screen = gui.AbsoluteSize
    Rows.collect()
    for v40, v41 in ipairs(staticActors) do
        if chainVisible(v41.inst) then
            refresh(v41)
            table.insert(v2, v41)
        end
    end
    for v42, v43 in ipairs(openItems) do
        refresh(v43)
        table.insert(v2, v43)
    end
    for v44, v45 in ipairs(v2) do
        park(v45)
        v45.pend = 1
        v45.pendAt = v39 + v45.inAt * T.TIME_SCALE
    end
end

function v1.reopen(v46) -- line 211 | captures: T, v2
    for v47, v48 in ipairs(v2) do
        v48.pend = 1
        v48.pendAt = v46 + v48.inAt * T.TIME_SCALE * T.REOPEN_DELAY
    end
end

function v1.queueClose(v49) -- line 218 | captures: T, refresh, chainVisible, staticActors, v2
    for v50, v51 in ipairs(staticActors) do
        if not v51.session and chainVisible(v51.inst) then
            refresh(v51)
            v51.session = true
            table.insert(v2, v51)
        end
    end
    for v52, v53 in ipairs(v2) do
        v53.pend = 2
        v53.pendAt = v49 + v53.outAt * T.TIME_SCALE
    end
end

function v1.clearOpen() -- line 232 | captures: openItems, v2
    table.clear(v2)
    table.clear(openItems)
end

function v1.dropActor(v54) -- line 237 | captures: Rows, v2
    local v55 = table.find(v2, v54)
    if v55 then
        table.remove(v2, v55)
    end
    Rows.forgetActor(v54)
end

function v1.clear() -- line 245 | captures: Rows, staticActors, v2
    table.clear(v2)
    table.clear(staticActors)
    Rows.clear()
end

function v1.init(v56) -- line 251 | captures: T, rng, gui, define, refresh, park, chainVisible, Rows, openItems, defineAll
    local T_2 = v56.T
    local rng_2 = v56.rng
    local gui_2 = v56.gui
    T = T_2
    rng = rng_2
    gui = gui_2
    local define_2 = v56.Actors.define
    local refresh_2 = v56.Actors.refresh
    local park_2 = v56.Actors.park
    define = define_2
    refresh = refresh_2
    park = park_2
    chainVisible = v56.Actors.chainVisible
    Rows = v56.Rows
    openItems = Rows.openItems
    defineAll(v56)
end

return v1
