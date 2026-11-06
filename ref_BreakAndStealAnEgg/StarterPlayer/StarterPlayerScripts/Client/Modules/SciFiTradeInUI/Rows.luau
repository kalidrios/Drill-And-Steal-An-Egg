-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {}
local T, rng, gui, chainVisible, define, FADE_PROPS, noFade, Idle

v1.openItems = {}
v1.cache = {}

local openItems = v1.openItems
local cache = v1.cache

local function chromeFade(v2) -- line 32 | captures: FADE_PROPS, noFade
    local fI = v2.fI
    local fP = v2.fP
    local fB = v2.fB
    local art = v2.art
    local v3 = 0

    local function add(v4) -- line 36 | captures: v3, fI, fP, fB, FADE_PROPS, noFade
        local v5 = FADE_PROPS[v4.ClassName]
        if v5 and not noFade[v4] then
            for v6, v7 in ipairs(v5) do
                local v8 = v4[v7]
                if v8 < 1 then
                    v3 += 1
                    local v9 = v3
                    local v10 = v3
                    local v11 = v3
                    fI[v9] = v4
                    fP[v10] = v7
                    fB[v11] = v8
                end
            end
        end
    end

    local walk

    local function walk_2(v12) -- line 48 | captures: art, add, walk
        add(v12)
        for v13, v14 in ipairs(v12:GetChildren()) do
            if v14:IsA("GuiObject") then
                if v14.Visible and not art[v14] then
                    walk(v14)
                end
            else
                walk(v14)
            end
        end
    end

    walk = walk_2
    walk_2(v2.inst)
    local v15 = v3 + 1
    local fN = v2.fN
    for v16 = v15, fN do
        fI[v16] = nil
        fP[v16] = nil
        fB[v16] = nil
    end
    v2.fN = v3
end

local function rowParts(v17) -- line 63 | captures: T, define, Idle, CollectionService, cache, chromeFade
    local v18 = cache[v17]
    if v18 == nil then
        local v19 = define(v17, {
            inAt = 0,
            outAt = 0,
            fades = false,
            noScale = true,
            park = { 0, 0, 0, 1, 1 },
            inSpring = T.ROW_IN,
            outSpring = T.ROW_OUT
        })
        v19.art = {}
        v19.customFade = chromeFade
        v19.item = v17
        local v20 = {}
        for v21, v22 in ipairs(v17:GetChildren()) do
            if v22:IsA("GuiObject") and v22.Visible then
                if T.ROW_ART[v22.Name] then
                    v19.art[v22] = true
                    local v23 = define(v22, {
                        inAt = 0,
                        outAt = 0,
                        park = {
                            0,
                            0,
                            0,
                            T.ROW_ART_FROM,
                            1
                        },
                        inSpring = T.ICON_IN,
                        outSpring = T.ROW_OUT
                    })
                    v23.item = v17
                    v23.layer = "art"
                    table.insert(v20, v23)
                    for v24, v25 in ipairs(v22:GetDescendants()) do
                        if v25:IsA("GuiObject") and (CollectionService:HasTag(v25, T.SPIN_TAG) or CollectionService:HasTag(v25, T.BOB_TAG)) then
                            local define_2 = define
                            local v26 = {
                                inAt = 0,
                                outAt = 0
                            }
                            v26.park = { 0, 0, 0, 0.6, 1 }
                            v26.inSpring = T.ICON_IN
                            v26.outSpring = T.ROW_OUT
                            local v27 = define_2(v25, v26)
                            v27.item = v17
                            v27.layer = "art"
                            Idle.applyTags(v27, v25)
                            table.insert(v20, v27)
                        end
                    end
                elseif v22:IsA("TextLabel") then
                    v19.art[v22] = true
                    local v28 = define(v22, {
                        inAt = 0,
                        outAt = 0,
                        noScale = true,
                        park = {
                            T.ROW_TEXT_X,
                            0,
                            0,
                            1,
                            1
                        },
                        inSpring = T.ROW_IN,
                        outSpring = T.ROW_OUT
                    })
                    v28.item = v17
                    v28.layer = "text"
                    table.insert(v20, v28)
                end
            end
        end
        local v29 = {
            chrome = v19,
            layers = v20
        }
        cache[v17] = v29
        return v29
    end
    return v18
end

v1.rowParts = rowParts

local function sortRows(v30, v31) -- line 122
    if v30.LayoutOrder == v31.LayoutOrder then
        return v30.Name < v31.Name
    end
    return v30.LayoutOrder < v31.LayoutOrder
end

local v32 = {}

function v1.rows(v33) -- line 132 | captures: T, gui, chainVisible, CollectionService, sortRows
    table.clear(v33)
    for v34, v35 in ipairs(CollectionService:GetTagged(T.STAGGER_TAG)) do
        if v35:IsDescendantOf(gui) and chainVisible(v35) then
            local v36 = #v33 + 1
            for v37, v38 in ipairs(v35:GetChildren()) do
                if v38:IsA("GuiObject") and v38.Visible then
                    table.insert(v33, v38)
                end
            end
            if v36 < #v33 then
                local v39 = table.move(v33, v36, #v33, 1, {})
                table.sort(v39, sortRows)
                table.move(v39, 1, #v39, v36, v33)
            end
        end
    end
    return v33
end

function v1.collect() -- line 153 | captures: T, rng, v1, openItems, rowParts, v32
    table.clear(openItems)
    for v40, v41 in ipairs(v1.rows(v32)) do
        local v42 = rowParts(v41)
        local v43 = T.ROW_AT + (v40 - 1) * T.ROW_STEP
        v42.chrome.inAt = v43
        local chrome = v42.chrome
        table.insert(openItems, chrome)
        for v44, v45 in ipairs(v42.layers) do
            if v45.layer == "art" then
                v45.inAt = v43 + T.ROW_ART_AFTER
                v45.pR = rng:NextNumber(-T.ROW_ART_ROT, T.ROW_ART_ROT)
            else
                v45.inAt = v43 + T.ROW_TEXT_AFTER + (v44 - 1) * 0.012
            end
            table.insert(openItems, v45)
        end
    end
    table.clear(v32)
    local v46 = #openItems
    for v47, v48 in ipairs(openItems) do
        v48.outAt = (v46 - v47) * T.ROW_OUT_STEP
    end
end

function v1.forgetItemOf(v49, v50) -- line 179 | captures: cache
    local Parent = v49.Parent
    while true do
        if Parent then
            if Parent == v50 then
                return
            end
            if cache[Parent] == nil then
                Parent = Parent.Parent
                continue
            end
            break
        end
        return
    end
    cache[Parent] = nil
end

function v1.forgetActor(v51) -- line 190 | captures: openItems, cache
    local v52 = table.find(openItems, v51)
    if v52 then
        table.remove(openItems, v52)
    end
    if v51.item then
        cache[v51.item] = nil
    end
end

function v1.forgetItem(v53) -- line 200 | captures: cache
    if cache[v53] ~= nil then
        cache[v53] = nil
    end
end

function v1.clear() -- line 206 | captures: openItems, cache
    table.clear(cache)
    table.clear(openItems)
end

function v1.init(v54) -- line 211 | captures: T, rng, gui, chainVisible, define, FADE_PROPS, noFade, Idle
    local T_2 = v54.T
    local rng_2 = v54.rng
    local gui_2 = v54.gui
    T = T_2
    rng = rng_2
    gui = gui_2
    local chainVisible_2 = v54.Actors.chainVisible
    local define_2 = v54.Actors.define
    chainVisible = chainVisible_2
    define = define_2
    local FADE_PROPS_2 = v54.Actors.FADE_PROPS
    local noFade_2 = v54.Actors.noFade
    FADE_PROPS = FADE_PROPS_2
    noFade = noFade_2
    Idle = v54.Idle
end

return v1
