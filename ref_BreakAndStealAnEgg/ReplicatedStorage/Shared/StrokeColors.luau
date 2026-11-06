-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = Color3.new(1, 1, 1)
local v2 = Color3.new(0, 0, 0)
local v3 = {
    InnerBrighten = 0.6,
    OuterDarken = 0.6,
    Neutral = Color3.fromRGB(22, 26, 33)
}

local function luminance(v4) -- line 37
    return 0.299 * v4.R + 0.587 * v4.G + 0.114 * v4.B
end

local function brightest(v5) -- line 41
    local v6 = v5[1]
    local v7 = #v5
    for v8 = 2, v7 do
        local v9 = v5[v8]
        local v10 = 0.299 * v9.R + 0.587 * v9.G + 0.114 * v9.B
        if 0.299 * v6.R + 0.587 * v6.G + 0.114 * v6.B < v10 then
            v6 = v5[v8]
        end
    end
    return v6
end

function v3.Inner(...) -- line 52 | captures: v1, v3, brightest
    return brightest({ ... }):Lerp(v1, v3.InnerBrighten)
end

function v3.InnerFromSequence(v11) -- line 56 | captures: v3
    local v12 = {}
    for v13, v14 in v11.Keypoints do
        local Value = v14.Value
        table.insert(v12, Value)
    end
    return v3.Inner(table.unpack(v12))
end

function v3.Outer(v15, v16) -- line 65 | captures: v2, v3
    return v15:Lerp(v2, v16 or v3.OuterDarken)
end

return v3
