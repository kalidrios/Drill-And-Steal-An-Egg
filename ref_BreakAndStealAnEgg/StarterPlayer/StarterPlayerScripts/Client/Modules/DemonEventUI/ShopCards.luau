-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    new = function() -- new | line 28
        local v1 = {}
        local T, rng, grids, chainVisible, define
        v1.openCards = {}
        v1.cardCache = {}
        local openCards = v1.openCards
        local cardCache = v1.cardCache

        local function isSpacer(v2) -- line 37
            if v2.BackgroundTransparency < 1 or v2:IsA("ImageLabel") or v2:IsA("ImageButton") then
                return false
            end
            return v2:FindFirstChildWhichIsA("GuiObject", true) == nil
        end

        local v3 = Vector2.new(0.5, 0.5)

        local function cardParts(v4) -- line 47 | captures: T, define, cardCache, v3
            local v5 = cardCache[v4]
            if v5 == nil then
                local Card = v4:FindFirstChild("Card")
                if not (Card and Card:IsA("GuiObject")) then
                    Card = nil
                    for v6, v7 in ipairs(v4:GetChildren()) do
                        if v7:IsA("GuiObject") and v7.AnchorPoint == v3 then
                            Card = v7
                            break
                        end
                        Card = nil
                    end
                end
                if Card then
                    local v8
                    local v9 = -1
                    local v10
                    for v11, v12 in ipairs(Card:GetChildren()) do
                        if v12:IsA("GuiObject") then
                            if v12.Name == "ItemIcon" and v9 < v12.Size.X.Scale then
                                v8, v9 = v12, v12.Size.X.Scale
                            elseif v12.Name == "Buy" then
                                v10 = v12
                            end
                        end
                    end
                    local v13 = {
                        card = define(Card, {
                            inAt = 0,
                            outAt = 0,
                            fades = false,
                            park = {
                                0,
                                T.CARD_PARK_Y,
                                0,
                                0,
                                0
                            },
                            inSpring = T.CARD_IN,
                            outSpring = T.CARD_OUT
                        })
                    }
                    v13.icon = v8 and
                    define(v8, {
                        inAt = 0,
                        outAt = 0,
                        fades = false,
                        park = {
                            0,
                            0,
                            0,
                            T.ICON_FROM,
                            0
                        },
                        inSpring = T.ICON_IN,
                        outSpring = T.CARD_OUT
                    }) or
                    nil
                    v13.buy = v10 and
                    define(v10, {
                        inAt = 0,
                        outAt = 0,
                        fades = false,
                        park = {
                            0,
                            0,
                            0,
                            T.BUY_FROM,
                            0
                        },
                        inSpring = T.BUY_IN,
                        outSpring = T.CARD_OUT
                    }) or
                    nil
                    v13.card.item = v4
                    if v13.icon then
                        v13.icon.item = v4
                    end
                    if v13.buy then
                        v13.buy.item = v4
                    end
                    cardCache[v4] = v13
                    return v13
                end
                cardCache[v4] = false
                return false
            end
            return v5
        end

        v1.cardParts = cardParts
        local v14 = {}

        local function sortItems(v15, v16) -- line 117 | captures: v14
            if v15.LayoutOrder == v16.LayoutOrder then
                return (v14[v15] or 0) < (v14[v16] or 0)
            end
            return v15.LayoutOrder < v16.LayoutOrder
        end

        function v1.collect(v17, v18, v19) -- line 127 | captures: T, rng, grids, chainVisible, openCards, cardParts, v14, sortItems
            local v20 = v19 or openCards
            local v21 = v18 or T.CARD_AT
            table.clear(v20)
            local v22 = 0
            for v23, v24 in ipairs(grids) do
                if (v17 == nil or v24:IsDescendantOf(v17)) and chainVisible(v24) then
                    if v24:IsA("ScrollingFrame") then
                        v24.CanvasPosition = Vector2.zero
                    end
                    local v25 = {}
                    for v26, v27 in ipairs(v24:GetChildren()) do
                        if v27:IsA("GuiObject") and v27.Visible and not (not (v27.BackgroundTransparency < 1) and not v27:IsA("ImageLabel") and not v27:IsA("ImageButton") and v27:FindFirstChildWhichIsA("GuiObject", true) == nil) then
                            v14[v27] = v26
                            table.insert(v25, v27)
                        end
                    end
                    table.sort(v25, sortItems)
                    table.clear(v14)
                    local v28 = v22
                    for v29, v30 in ipairs(v25) do
                        local v31 = cardParts(v30)
                        if v31 then
                            local CARD_STEP_CAP = T.CARD_STEP_CAP
                            local v32 = v21 + math.min(v28, CARD_STEP_CAP) * T.CARD_STEP
                            v28 += 1
                            local card = v31.card
                            card.inAt = v32
                            card.pR = rng:NextNumber(-T.CARD_PARK_ROT, T.CARD_PARK_ROT)
                            table.insert(v20, card)
                            if v31.icon then
                                v31.icon.inAt = v32 + T.ICON_AFTER
                                v31.icon.pR = rng:NextNumber(-15, 15)
                                local icon = v31.icon
                                table.insert(v20, icon)
                            end
                            if v31.buy then
                                v31.buy.inAt = v32 + T.BUY_AFTER
                                local buy = v31.buy
                                table.insert(v20, buy)
                            end
                        end
                        v22 = v28
                    end
                end
            end
            local v33 = #v20
            for v34, v35 in ipairs(v20) do
                v35.outAt = (v33 - v34) * T.CARD_OUT_STEP * 0.5
            end
        end

        function v1.forgetCardOf(v36, v37) -- line 184 | captures: cardCache
            local Parent = v36.Parent
            while true do
                if Parent then
                    if Parent == v37 then
                        return
                    end
                    if cardCache[Parent] == nil then
                        Parent = Parent.Parent
                        continue
                    end
                    break
                end
                return
            end
            cardCache[Parent] = nil
        end

        function v1.forgetActor(v38) -- line 196 | captures: openCards, cardCache
            local v39 = table.find(openCards, v38)
            if v39 then
                table.remove(openCards, v39)
            end
            if v38.item then
                cardCache[v38.item] = nil
            end
        end

        function v1.forgetItem(v40) -- line 207 | captures: cardCache
            if cardCache[v40] ~= nil then
                cardCache[v40] = nil
            end
        end

        function v1.clear() -- line 213 | captures: openCards, cardCache
            table.clear(cardCache)
            table.clear(openCards)
        end

        function v1.init(v41) -- line 218 | captures: T, rng, grids, chainVisible, define
            local T_2 = v41.T
            local rng_2 = v41.rng
            local grids_2 = v41.grids
            T = T_2
            rng = rng_2
            grids = grids_2
            local chainVisible_2 = v41.Actors.chainVisible
            local define_2 = v41.Actors.define
            chainVisible = chainVisible_2
            define = define_2
        end

        return v1
    end
}
