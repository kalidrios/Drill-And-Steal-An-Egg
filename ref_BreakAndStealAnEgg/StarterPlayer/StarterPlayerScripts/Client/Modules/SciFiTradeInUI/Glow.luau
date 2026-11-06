-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {}
local v2, T, main, chainVisible, map
local v3 = {}
local v4 = {}
local v5 = {}
local v6 = {}
local v7 = {}
local v8 = {}
local v9 = {}
local v10 = {}
local v11 = 0
local cos = math.cos

local function ownerOf(v12) -- line 27 | captures: main, map
    local Parent = v12.Parent
    local v13
    while true do
        if Parent then
            if Parent == main then
                return nil
            end
            v13 = map[Parent]
            if not (v13 and v13.entrance) then
                Parent = Parent.Parent
                continue
            end
            break
        end
        return nil
    end
    return v13
end

local function num(v14, v15, v16) -- line 39
    local v17 = v14:GetAttribute(v15)
    if type(v17) ~= "number" or not v17 then
        v17 = v16
    end
    return v17
end

function v1.start() -- line 44 | captures: T, main, map, v11, CollectionService, v3, v4, v5, v6, v7, v8, v9, v10
    v11 = 0
    for v18, v19 in ipairs(CollectionService:GetTagged(T.GLOW_TAG)) do
        if v19:IsA("UIShadow") and v19:IsDescendantOf(main) and v19.Parent:IsA("GuiObject") then
            v11 += 1
            local v20 = v11
            local v21 = v11
            local Parent = v19.Parent
            v3[v20] = v19
            v4[v21] = Parent
            v5[v11] = v19.Transparency
            local v22 = v11
            local Period = v19:GetAttribute("Period")
            local v23 = type(Period) == "number" and Period or 2.6
            v6[v22] = 6.283185307179586 / math.max(v23, 0.2)
            local v24 = v11
            local Min = v19:GetAttribute("Min")
            v7[v24] = type(Min) == "number" and Min or 0
            local v25 = v11
            local Max = v19:GetAttribute("Max")
            v8[v25] = type(Max) == "number" and Max or 0.9
            local v26 = v11
            local Parent_2 = v19.Parent
            local v27
            while true do
                if Parent_2 then
                    if Parent_2 == main then
                        v27 = nil
                        break
                    end
                    local v28 = map[Parent_2]
                    if v28 and v28.entrance then
                        v27 = v28
                        break
                    end
                    Parent_2 = Parent_2.Parent
                    continue
                end
                v27 = nil
                break
            end
            v9[v26] = v27
            v10[v11] = -1
        end
    end
end

function v1.stop() -- line 60 | captures: v11, v3, v4, v5, v9
    local v29 = v11
    for v30 = 1, v29 do
        v3[v30].Transparency = v5[v30]
        v3[v30] = nil
        v4[v30] = nil
        v9[v30] = nil
    end
    v11 = 0
end

local v31 = 0

function v1.step(v32, v33) -- line 70 | captures: T, chainVisible, v11, v31, v3, v4, v6, v7, v8, v9, v10, cos
    if v11 ~= 0 then
        v31 += v32
        if not (v31 < 1 / T.GLOW_HZ) then
            v31 = 0
            local v34 = v11
            for v35 = 1, v34 do
                if chainVisible(v4[v35]) then
                    local v36 = v33 * v6[v35]
                    local v37 = 0.5 - cos(v36) * 0.5
                    local v38 = v37 * v37 * (3 - v37 * 2)
                    local v39 = v7[v35] + (v8[v35] - v7[v35]) * v38
                    local v40 = v9[v35]
                    if v40 then
                        local x = v40.a.x
                        if x < 0 then
                            x = 0
                        elseif x > 1 then
                            x = 1
                        end
                        v39 += (1 - v39) * x
                    end
                    local v41 = v39 - v10[v35]
                    if v41 > 0.004 or v41 < -0.004 then
                        v10[v35] = v39
                        v3[v35].Transparency = v39
                    end
                end
            end
        end
    end
end

function v1.init(v42) -- line 107 | captures: v2, T, main, chainVisible, map, CollectionService
    v2 = v42
    local T_2 = v2.T
    local main_2 = v2.main
    T = T_2
    main = main_2
    local chainVisible_2 = v2.Actors.chainVisible
    local map_2 = v2.Actors.map
    chainVisible = chainVisible_2
    map = map_2
    for v43, v44 in ipairs(CollectionService:GetTagged(T.GLOW_TAG)) do
        v2.Actors.noFade[v44] = true
    end
end

return v1
