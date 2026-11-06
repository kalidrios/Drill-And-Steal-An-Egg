-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {}
local v2, T, rng, main, chainVisible
local v3 = {}
local v4 = {}
local v5 = {}
local v6 = {}
local v7 = {}
local v8 = {}
local v9 = {}
local v10 = 0
local v11 = 0
local v12 = 0
local v13 = 2
local v14 = 1
local sin = math.sin
local v15 = Vector2.new(-1.25, 0)

local function groupOf(v16) -- line 32 | captures: main
    local v17 = v16
    while v17 do
        if v17.Parent == main then
            break
        end
        v17 = v17.Parent
    end
    return v17
end

local function rest(v18) -- line 40 | captures: v3, v4, v15
    v3[v18].BackgroundTransparency = 1
    v4[v18].Offset = v15
end

function v1.start() -- line 45 | captures: v2, T, main, v10, v11, v12, v13, v14, CollectionService, v3, v4, v5, v6, v7, v8, v9
    local v19 = v2.touchOnly or v2.lowEnd
    v13 = v19 and T.SHIMMER_CAP_LOW or T.SHIMMER_CAP
    v14 = v19 and T.SHIMMER_DUR_LOW or T.SHIMMER_DUR
    local SPRITE_VIS_EVERY = T.SPRITE_VIS_EVERY
    v10 = 0
    v11 = 0
    v12 = SPRITE_VIS_EVERY
    local v20 = {}
    for v21, v22 in ipairs(CollectionService:GetTagged(T.SHIMMER_TAG)) do
        local GuiObject = v22:IsA("GuiObject") and v22:IsDescendantOf(main) and v22:FindFirstChildOfClass("UIGradient")
        if GuiObject then
            v10 += 1
            local v23 = v10
            local v24 = v10
            local v25 = v10
            local v26 = v10
            local v27 = v10
            local v28 = v10
            v3[v23] = v22
            v4[v24] = GuiObject
            v5[v25] = false
            v6[v26] = -1
            v7[v27] = (1/0)
            v9[v28] = 0
            local v29 = v22
            while v29 do
                if v29.Parent == main then
                    break
                end
                v29 = v29.Parent
            end
            v20[v29] = v20[v29] or {}
            local v30 = v20[v29]
            local v31 = v10
            table.insert(v30, v31)
        end
    end
    for v32, v33 in pairs(v20) do
        table.sort(v33, function(v34, v35) -- line 63 | captures: v3
            local AbsolutePosition = v3[v34].AbsolutePosition
            local AbsolutePosition_2 = v3[v35].AbsolutePosition
            local v36 = AbsolutePosition.Y - AbsolutePosition_2.Y
            if math.abs(v36) > 8 then
                return AbsolutePosition.Y < AbsolutePosition_2.Y
            end
            return AbsolutePosition.X < AbsolutePosition_2.X
        end)
        for v37, v38 in ipairs(v33) do
            v8[v38] = v37 - 1
        end
    end
end

function v1.stop() -- line 76 | captures: v10, v11, v3, v4, v6, v9, v15
    local v39 = v10
    for v40 = 1, v39 do
        if v6[v40] >= 0 or not (v9[v40] == 0) then
            v3[v40].BackgroundTransparency = 1
            v4[v40].Offset = v15
        end
        v3[v40] = nil
        v4[v40] = nil
    end
    v10 = 0
    v11 = 0
end

function v1.step(v41, v42) -- line 86 | captures: T, rng, chainVisible, v10, v11, v12, v13, v14, v3, v4, v5, v6, v7, v8, v9, sin, v15
    if v10 == 0 then
        return
    end
    v12 += v41
    local v43 = v12
    if T.SPRITE_VIS_EVERY <= v43 then
        v12 = 0
        local v44 = v10
        for v45 = 1, v44 do
            local v46 = chainVisible(v3[v45])
            if not v46 or v5[v45] then
                if not v46 and v5[v45] and v6[v45] >= 0 then
                    v6[v45] = -1
                    v11 -= 1
                    v9[v45] = 0
                    v3[v45].BackgroundTransparency = 1
                    v4[v45].Offset = v15
                end
            else
                v7[v45] = v42 + T.SHIMMER_FIRST + v8[v45] * T.SHIMMER_STAGGER
            end
            v5[v45] = v46
        end
    end
    local v47 = v10
    for v48 = 1, v47 do
        local v49 = v6[v48]
        if v49 >= 0 then
            local v50 = v49 + v41
            local v51 = v50 / v14
            if v51 >= 1 then
                v6[v48] = -1
                v11 -= 1
                v9[v48] = 0
                v3[v48].BackgroundTransparency = 1
                v4[v48].Offset = v15
                v7[v48] = v42 + rng:NextNumber(T.SHIMMER_GAP[1], T.SHIMMER_GAP[2])
            else
                v6[v48] = v50
                local v52 = v51 * v51 * v51 * (v51 * (v51 * 6 - 15) + 10)
                local SHIMMER_REACH = T.SHIMMER_REACH
                local v53 = -SHIMMER_REACH + 2 * SHIMMER_REACH * v52
                local v54 = 3.141592653589793 * v51
                local v55 = sin(v54)
                local v56 = v55 * v55
                local v57 = 1 - T.SHIMMER_PEAK * v56
                if v53 - v9[v48] > 0.004 or v53 - v9[v48] < -0.004 then
                    v9[v48] = v53
                    v4[v48].Offset = Vector2.new(v53, 0)
                    v3[v48].BackgroundTransparency = v57
                end
            end
        elseif v5[v48] and v11 < v13 and v7[v48] <= v42 then
            v6[v48] = 0
            v11 += 1
        end
    end
end

function v1.active() -- line 140 | captures: v11
    return v11
end

function v1.count() -- line 143 | captures: v10
    return v10
end

function v1.init(v58) -- line 147 | captures: v2, T, rng, main, chainVisible, CollectionService
    v2 = v58
    local T_2 = v2.T
    local rng_2 = v2.rng
    local main_2 = v2.main
    T = T_2
    rng = rng_2
    main = main_2
    chainVisible = v2.Actors.chainVisible
    for v59, v60 in ipairs(CollectionService:GetTagged(T.SHIMMER_TAG)) do
        v2.Actors.noFade[v60] = true
    end
end

return v1
