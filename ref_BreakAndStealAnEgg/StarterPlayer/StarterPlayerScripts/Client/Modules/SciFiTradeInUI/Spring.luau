-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local exp = math.exp
local cos = math.cos
local sin = math.sin
local sqrt = math.sqrt

function v1.new(v2, v3, v4) -- line 43
    return {
        v = 0,
        rest = true,
        x = v2,
        t = v2,
        f = v3,
        d = v4
    }
end

function v1.step(v5, v6) -- line 48 | captures: exp, cos, sin, sqrt
    if v5.rest then
        return true
    end
    local v7 = v5.f * 6.283185307179586
    local d = v5.d
    local t = v5.t
    local v8 = v5.x - t
    local v = v5.v
    local v9, v10
    if d >= 1 then
        local v11 = -v7 * v6
        local v12 = exp(v11)
        local v13 = v + v7 * v8
        v9, v10 = (v8 + v13 * v6) * v12, (v - v13 * v7 * v6) * v12
    else
        local v14 = 1 - d * d
        local v15 = v7 * sqrt(v14)
        local v16 = -d * v7 * v6
        local v17 = exp(v16)
        local v18 = v15 * v6
        local v19 = cos(v18)
        local v20 = v15 * v6
        local v21 = sin(v20)
        local v22 = (v + d * v7 * v8) / v15
        v9, v10 = v17 * (v8 * v19 + v22 * v21), v17 * (v * v19 - (d * v7 * v22 + v15 * v8) * v21)
    end
    if v9 < 0.0001 and v9 > -0.0001 and v10 < 0.001 and v10 > -0.001 then
        v5.x = t
        v5.v = 0
        v5.rest = true
        return true
    end
    v5.x = v9 + t
    v5.v = v10
    return false
end

function v1.to(v23, v24, v25, v26) -- line 88
    v23.t = v24
    if v25 then
        v23.f = v25
    end
    if v26 then
        v23.d = v26
    end
    v23.rest = false
end

function v1.snap(v27, v28) -- line 100
    v27.x = v28
    v27.t = v28
    v27.v = 0
    v27.rest = true
end

function v1.kick(v29, v30) -- line 108
    v29.v += v30
    v29.rest = false
end

return v1
