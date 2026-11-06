-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {}

function v1.new() -- line 39 | captures: CollectionService
    local v2 = {}
    local T, rng, gui, chainVisible, define, setLayer, FADE_PROPS, noFade, Idle
    v2.openItems = {}
    v2.cache = {}
    local openItems = v2.openItems
    local cache = v2.cache
    local v3 = Vector2.new(0.5, 0.5)

    local function topLayerOf(v4) -- line 51 | captures: T, v3
        if v4:IsA("ImageLabel") or v4:IsA("ImageButton") then
            local v5 = v4:FindFirstChild(T.LAYER_NAME)
            if not (not v5 or not v5:IsA("ImageLabel") and not v5:IsA("ImageButton")) and v5.AnchorPoint == v3 then
                return v5
            end
        end
        return nil
    end

    local function isArt(v6) -- line 62 | captures: v3, topLayerOf
        if v6:IsA("GuiObject") and not v6:IsA("TextLabel") and not v6:IsA("TextButton") then
            if v6.AnchorPoint == v3 then
                if topLayerOf(v6) then
                    return true
                end
                local Position = v6.Position
                if Position.X.Scale == 0.5 and Position.Y.Scale == 0.5 and Position.X.Offset == 0 then
                    return Position.Y.Offset == 0
                end
                return false
            end
            return false
        end
        return false
    end

    local function draws(v7) -- line 76
        if v7.Visible then
            if (v7:IsA("ImageLabel") or v7:IsA("ImageButton")) and v7.ImageTransparency >= 1 and v7.BackgroundTransparency >= 1 then
                return v7:FindFirstChildWhichIsA("GuiObject") ~= nil
            end
            return true
        end
        return false
    end

    local function chromeFade(v8) -- line 87 | captures: FADE_PROPS, noFade
        local fI = v8.fI
        local fP = v8.fP
        local fB = v8.fB
        local art = v8.art
        local v9 = 0

        local function add(v10) -- line 91 | captures: v9, fI, fP, fB, FADE_PROPS, noFade
            local v11 = FADE_PROPS[v10.ClassName]
            if v11 and not noFade[v10] then
                for v12, v13 in ipairs(v11) do
                    local v14 = v10[v13]
                    if v14 < 1 then
                        v9 += 1
                        local v15 = v9
                        local v16 = v9
                        local v17 = v9
                        fI[v15] = v10
                        fP[v16] = v13
                        fB[v17] = v14
                    end
                end
            end
        end

        local walk

        local function walk_2(v18) -- line 103 | captures: art, add, walk
            add(v18)
            for v19, v20 in ipairs(v18:GetChildren()) do
                if v20:IsA("GuiObject") then
                    if v20.Visible and not art[v20] then
                        walk(v20)
                    end
                else
                    walk(v20)
                end
            end
        end

        walk = walk_2
        walk_2(v8.inst)
        local v21 = v9 + 1
        local fN = v8.fN
        for v22 = v21, fN do
            fI[v22] = nil
            fP[v22] = nil
            fB[v22] = nil
        end
        v8.fN = v9
    end

    local function itemParts(v23) -- line 118 | captures: T, define, setLayer, Idle, cache, topLayerOf, isArt, chromeFade
        local v24 = cache[v23]
        if v24 == nil then
            local v25 = define(v23, {
                inAt = 0,
                outAt = 0,
                fades = false,
                noScale = true,
                park = { 0, 0, 0, 1, 1 },
                inSpring = T.CARD_IN,
                outSpring = T.CARD_OUT
            })
            v25.art = {}
            v25.customFade = chromeFade
            v25.item = v23
            local v26 = {}
            for v27, v28 in ipairs(v23:GetChildren()) do
                if isArt(v28) then
                    v25.art[v28] = true
                    if v28.Visible and (not (v28:IsA("ImageLabel") or v28:IsA("ImageButton")) or not (v28.ImageTransparency >= 1) or not (v28.BackgroundTransparency >= 1) or v28:FindFirstChildWhichIsA("GuiObject") ~= nil) then
                        local v29 = define(v28, {
                            inAt = 0,
                            outAt = 0,
                            park = {
                                0,
                                0,
                                0,
                                T.EGG_ART_FROM,
                                1
                            },
                            inSpring = T.ICON_IN,
                            outSpring = T.CARD_OUT
                        })
                        v29.item = v23
                        setLayer(v29, (topLayerOf(v28)))
                        Idle.applyTags(v29, v28)
                        table.insert(v26, v29)
                    end
                end
            end
            local v30 = {
                chrome = v25,
                art = v26
            }
            cache[v23] = v30
            return v30
        end
        return v24
    end

    v2.itemParts = itemParts

    local function sortItems(v31, v32) -- line 156
        if v31.LayoutOrder == v32.LayoutOrder then
            return v31.Name < v32.Name
        end
        return v31.LayoutOrder < v32.LayoutOrder
    end

    function v2.rows(v33, v34) -- line 164 | captures: T, gui, chainVisible, sortItems, CollectionService
        table.clear(v34)
        for v35, v36 in ipairs(CollectionService:GetTagged(T.STAGGER_TAG)) do
            if v36:IsDescendantOf(gui) and (v33 == nil or v36:IsDescendantOf(v33)) and chainVisible(v36) then
                local v37 = #v34 + 1
                for v38, v39 in ipairs(v36:GetChildren()) do
                    if v39:IsA("GuiObject") and v39.Visible then
                        table.insert(v34, v39)
                    end
                end
                if v37 < #v34 then
                    local v40 = table.move(v34, v37, #v34, 1, {})
                    table.sort(v40, sortItems)
                    table.move(v40, 1, #v40, v37, v34)
                end
            end
        end
        return v34
    end

    local v41 = {}

    function v2.collect(v42, v43, v44) -- line 189 | captures: T, rng, v2, openItems, itemParts, v41
        local v45 = v44 or openItems
        local v46 = v43 or T.EGG_ITEM_AT
        table.clear(v45)
        for v47, v48 in ipairs(v2.rows(v42, v41)) do
            local v49 = itemParts(v48)
            local v50 = v46 + (v47 - 1) * T.EGG_ITEM_STEP
            v49.chrome.inAt = v50
            local chrome = v49.chrome
            table.insert(v45, chrome)
            for v51, v52 in ipairs(v49.art) do
                v52.inAt = v50 + T.EGG_ART_AFTER + (v51 - 1) * 0.03
                v52.pR = rng:NextNumber(-T.EGG_ART_ROT, T.EGG_ART_ROT)
                table.insert(v45, v52)
            end
        end
        table.clear(v41)
        local v53 = #v45
        for v54, v55 in ipairs(v45) do
            v55.outAt = (v53 - v54) * T.CARD_OUT_STEP * 0.5
        end
    end

    function v2.defineTab(v56, v57) -- line 213 | captures: T, define
        v57(define(v56:FindFirstChild("BGDecor"), {
            tabAt = 0.02,
            park = { 0, 0.02, 0, 0.92, 1 },
            inAt = T.EGG_DECOR_AT,
            inSpring = T.CONTENT_IN,
            outAt = T.SHOPTAB_OUT_AT,
            outSpring = T.CONTENT_OUT
        }))
        v57(define(v56:FindFirstChild("EggIcon"), {
            tabAt = 0.08,
            park = {
                -0.03,
                0.05,
                -14,
                T.EGG_ICON_FROM,
                1
            },
            inAt = T.EGG_ICON_AT,
            inSpring = T.TITLE_IN,
            outAt = T.TITLE_OUT_AT,
            outSpring = T.CONTENT_OUT
        }))
        local v58 = {}
        for v59, v60 in ipairs(v56:GetChildren()) do
            if v60:IsA("TextLabel") then
                table.insert(v58, v60)
            end
        end
        table.sort(v58, function(v61, v62) -- line 231
            if v61.Position.Y.Scale == v62.Position.Y.Scale then
                return v61.Position.X.Scale < v62.Position.X.Scale
            end
            return v61.Position.Y.Scale < v62.Position.Y.Scale
        end)
        for v63, v64 in ipairs(v58) do
            local define_2 = define
            local v65 = { alphaIn = 8 }
            local v66 = {}
            local v67 = if v63 % 2 == 1 then -8 else 8
            local EGG_TITLE_FROM = T.EGG_TITLE_FROM
            v66[1] = 0
            v66[2] = -0.03
            v66[3] = v67
            v66[4] = EGG_TITLE_FROM
            v66[5] = 1
            v65.park = v66
            v65.inAt = T.EGG_TITLE_AT + (v63 - 1) * T.EGG_TITLE_STEP
            v65.inSpring = T.TITLE_IN
            v65.tabAt = 0.1 + (v63 - 1) * 0.06
            v65.outAt = T.TITLE_OUT_AT
            v65.outSpring = T.CONTENT_OUT
            v57(define_2(v64, v65))
        end
        v57(define(v56:FindFirstChild("Buy"), {
            tabAt = 0.3,
            park = {
                0,
                0,
                0,
                T.BUY_FROM,
                1
            },
            inAt = T.EGG_BUY_AT,
            inSpring = T.BUY_IN,
            outAt = T.CLOSE_OUT_AT,
            outSpring = T.CONTENT_OUT
        }))
    end

    function v2.layerOwner(v68) -- line 255 | captures: T, topLayerOf, isArt, CollectionService
        local Parent = v68.Parent
        local v69 = Parent and Parent.Parent
        local v70 = v69 and v69.Parent
        if v68.Name == T.LAYER_NAME and v70 and CollectionService:HasTag(v70, T.STAGGER_TAG) then
            if v69:IsA("GuiObject") and isArt(Parent) and topLayerOf(Parent) == v68 then
                return Parent
            end
            return nil
        end
        return nil
    end

    function v2.forgetItemOf(v71, v72) -- line 269 | captures: cache
        local Parent = v71.Parent
        while true do
            if Parent then
                if Parent == v72 then
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

    function v2.forgetActor(v73) -- line 280 | captures: openItems, cache
        local v74 = table.find(openItems, v73)
        if v74 then
            table.remove(openItems, v74)
        end
        if v73.item then
            cache[v73.item] = nil
        end
    end

    function v2.forgetItem(v75) -- line 290 | captures: cache
        if cache[v75] ~= nil then
            cache[v75] = nil
        end
    end

    function v2.clear() -- line 296 | captures: openItems, cache
        table.clear(cache)
        table.clear(openItems)
    end

    function v2.init(v76) -- line 301 | captures: T, rng, gui, chainVisible, define, setLayer, FADE_PROPS, noFade, Idle
        local T_2 = v76.T
        local rng_2 = v76.rng
        local gui_2 = v76.gui
        T = T_2
        rng = rng_2
        gui = gui_2
        local chainVisible_2 = v76.Actors.chainVisible
        local define_2 = v76.Actors.define
        local setLayer_2 = v76.Actors.setLayer
        chainVisible = chainVisible_2
        define = define_2
        setLayer = setLayer_2
        local FADE_PROPS_2 = v76.Actors.FADE_PROPS
        local noFade_2 = v76.Actors.noFade
        FADE_PROPS = FADE_PROPS_2
        noFade = noFade_2
        Idle = v76.Idle
    end

    return v2
end

return v1
