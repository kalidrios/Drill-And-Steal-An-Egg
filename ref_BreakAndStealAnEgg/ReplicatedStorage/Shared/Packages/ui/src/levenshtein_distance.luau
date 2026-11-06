-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local function new_matrix(v1, v2) -- line 1
    local v3 = {}
    for v4 = 0, v1 do
        v3[v4] = {}
        for v5 = 0, v2 do
            v3[v4][v5] = 0
        end
    end
    return v3
end

local function levenshtein_distance(v6, v7) -- line 12 | captures: new_matrix
    local v8 = string.len(v6)
    local v9 = string.len(v7)
    if v8 == 0 then
        return v9
    end
    if v9 == 0 then
        return v8
    end
    if v6 == v7 then
        return 0
    end
    local v10 = new_matrix(v8, v9)
    for v11 = 1, v8 do
        v10[v11][0] = v11
    end
    for v12 = 1, v9 do
        v10[0][v12] = v12
    end
    for v13 = 1, v8 do
        for v14 = 1, v9 do
            local v15 = if string.byte(v6, v13) == string.byte(v7, v13) then 0 else 2
            local v16 = v10[v13 - 1][v14] + 3
            local v17 = v10[v13][v14 - 1] + 1
            local v18 = v10[v13 - 1][v14 - 1] + v15
            v10[v13][v14] = math.min(v17, v16, v18)
        end
    end
    return v10[v8][v9], v10
end

return levenshtein_distance
