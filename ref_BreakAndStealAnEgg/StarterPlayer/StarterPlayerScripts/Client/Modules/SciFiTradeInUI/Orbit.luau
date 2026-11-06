-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local Rigs, T, rng
local sin = math.sin
local cos = math.cos
local rad = math.rad
local deg = math.deg
local atan2 = math.atan2
local sqrt = math.sqrt
local v2 = {}
local v3 = false
local v4 = 0
local v5 = false
local v6 = 0.6993006993006994
local v7, v8, v9, v10

local function orbit(v11, v12) -- line 40 | captures: v6, v7, v8, sin, cos
    local v13 = v11.rx * cos(v12)
    local v14 = v11.ry * sin(v12)
    return v7 + (v13 * v11.ct - v14 * v11.st) * v6, v8 + (v13 * v11.st + v14 * v11.ct)
end

local function orbitVel(v15, v16) -- line 45 | captures: v6, sin, cos
    local v17 = -v15.rx * sin(v16) * v15.w
    local v18 = v15.ry * cos(v16) * v15.w
    return (v17 * v15.ct - v18 * v15.st) * v6, v17 * v15.st + v18 * v15.ct
end

function v1.prepareOpen(v19, v20) -- line 50 | captures: Rigs, T, rng, v3, v4, v6, v7, v8, sin, cos, sqrt, v2
    if #v2 == 0 then
        return
    end
    v3 = true
    v4 = 0
    local v21 = rng:NextNumber(0, 6.283185307179586)
    for v22, v23 in ipairs(v2) do
        local rig = v23.rig
        v23.theta0 = v21 + v23.phase
        v23.startAt = v19 + (T.SAT_AT + v23.delay) * T.TIME_SCALE
        local v24 = T.SAT_FLY * T.TIME_SCALE
        v23.flyEnd = v23.startAt + v24
        local theta0 = v23.theta0
        local v25 = v23.rx * cos(theta0)
        local v26 = v23.ry * sin(theta0)
        local v27 = v7 + (v25 * v23.ct - v26 * v23.st) * v6
        local v28 = v8 + (v25 * v23.st + v26 * v23.ct)
        v23.ex = v27
        v23.ey = v28
        local theta0_2 = v23.theta0
        local v29 = -v23.rx * sin(theta0_2) * v23.w
        local v30 = v23.ry * cos(theta0_2) * v23.w
        local v31 = (v29 * v23.ct - v30 * v23.st) * v6
        local v32 = v29 * v23.st + v30 * v23.ct
        local v33 = v31 * v24
        local v34 = v32 * v24
        v23.m1x = v33
        v23.m1y = v34
        local v35 = (v23.ex - v7) / v6
        local v36 = v23.ey - v8
        local v37 = v35 * v35 + v36 * v36
        local v38 = sqrt(v37)
        if v38 < 0.001 then
            v35 = 1
            v36 = 0
            v38 = 1
        end
        local v39 = v35 / v38
        local v40 = v36 / v38
        local SAT_FROM = T.SAT_FROM
        v23.fx = v23.ex + (v39 * SAT_FROM - v32 * 0.3) * v6
        v23.fy = v23.ey + v40 * SAT_FROM + v31 * 0.3
        local v41 = v23.ex - v23.fx
        local v42 = v23.ey - v23.fy
        local v43 = (v41 * 0.766044443118978 - v42 * 0.6427876096865393) * 1.1
        local v44 = (v41 * 0.6427876096865393 + v42 * 0.766044443118978) * 1.1
        v23.m0x = v43
        v23.m0y = v44
        v23.flying = true
        v23.parity = 0
        local fx = v23.fx
        local fy = v23.fy
        rig.x = fx
        rig.y = fy
        rig.a = 1
        rig.vis = true
        rig.s = T.SAT_SCALE * v23.scale
        Rigs.write(rig, v20)
    end
end

function v1.onClose() -- line 92 | captures: v4
    v4 = 1
end

function v1.onReopen() -- line 96 | captures: v4
    v4 = 0
end

local function aimAt(v45, v46) -- line 100 | captures: T, v6, v9, v10, deg, atan2
    local v47 = v10 - v46
    local v48 = (v9 - v45) / v6
    local v49 = atan2(v47, v48)
    return deg(v49) - T.SAT_TIP
end

function v1.step(v50, v51, v52) -- line 105 | captures: Rigs, T, v3, v4, v5, v6, v7, v8, v9, v10, sin, cos, deg, atan2, v2
    if v3 then
        for v53, v54 in ipairs(v2) do
            if v54.startAt <= v51 then
                local rig = v54.rig
                v54.parity = 1 - v54.parity
                local v55, v56, v57
                if v51 < v54.flyEnd then
                    local v58 = (v51 - v54.startAt) / (v54.flyEnd - v54.startAt)
                    v56 = Rigs.hermite(v54.fx, v54.m0x, v54.ex, v54.m1x, v58)
                    v57 = Rigs.hermite(v54.fy, v54.m0y, v54.ey, v54.m1y, v58)
                    local theta0 = v54.theta0
                    v55 = sin(theta0)
                else
                    v54.flying = false
                    local v59 = v54.theta0 + (v51 - v54.flyEnd) * v54.w
                    local v60 = v54.rx * cos(v59)
                    local v61 = v54.ry * sin(v59)
                    v56, v57, v55 = v7 + (v60 * v54.ct - v61 * v54.st) * v6, v8 + (v60 * v54.st + v61 * v54.ct), sin(v59)
                end
                if v55 >= 0 then
                    rig.z = T.Z_FRONT
                else
                    rig.z = T.Z_BACK
                end
                local v62 = (v55 + 1) * 0.5
                rig.s = T.SAT_SCALE * v54.scale * (T.SAT_BACK_SCALE + (1 - T.SAT_BACK_SCALE) * v62)
                rig.x = v56
                rig.y = v57
                local v63 = v10 - v57
                local v64 = (v9 - v56) / v6
                local v65 = atan2(v63, v64)
                rig.r = deg(v65) - T.SAT_TIP
                local v66 = v4
                local v67 = if v66 == 1 then T.SAT_OUT else 0.25
                local v68 = v50 / v67
                if rig.a < v66 then
                    local v69 = rig.a + v68
                    rig.a = math.min(v66, v69)
                elseif v66 < rig.a then
                    local v70 = rig.a - v68
                    rig.a = math.max(v66, v70)
                end
                if v5 then
                    if v54.flying then
                        Rigs.write(rig, v52)
                    elseif v54.parity == 1 then
                        if rig.a ~= 0 then
                            Rigs.write(rig, v52)
                        end
                    else
                        Rigs.write(rig, v52)
                    end
                else
                    Rigs.write(rig, v52)
                end
            end
        end
    end
end

function v1.toRest() -- line 146 | captures: Rigs, v3, v2
    v3 = false
    for v71, v72 in ipairs(v2) do
        v72.flying = false
        Rigs.toRest(v72.rig)
    end
end

function v1.setLow(v73) -- line 154 | captures: v5
    v5 = v73
end

function v1.init(v74) -- line 158 | captures: Rigs, T, rng, v3, v5, v6, v7, v8, v9, v10, v1, sin, cos, rad, v2
    local T_2 = v74.T
    local rng_2 = v74.rng
    local Rigs_2 = v74.Rigs
    T = T_2
    rng = rng_2
    Rigs = Rigs_2
    local UIAspectRatioConstraint = v74.main:FindFirstChildOfClass("UIAspectRatioConstraint")
    if UIAspectRatioConstraint then
        v6 = 1 / UIAspectRatioConstraint.AspectRatio
    end
    local v75 = T.ORBIT_CENTRE[1]
    local v76 = T.ORBIT_CENTRE[2]
    v7 = v75
    v8 = v76
    local v77 = T.ORBIT_AIM[1]
    local v78 = T.ORBIT_AIM[2]
    v9 = v77
    v10 = v78
    v5 = v74.touchOnly
    v3 = false
    table.clear(v2)
    for v79, v80 in ipairs(T.SATELLITES or { { Name = "Sattelite" } }) do
        local v81 = v74.main:FindFirstChild(v80.Name)
        if v81 then
            v74.Actors.noFade[v81] = true
            local v82 = T.ORBIT_TILT + (v80.Tilt or 0)
            local v83 = {
                parity = 0,
                startAt = (1/0),
                flyEnd = 0,
                rig = Rigs.new(v81),
                inst = v81,
                scale = v80.Scale or 1,
                rx = T.ORBIT_R[1] * (v80.R or 1),
                ry = T.ORBIT_R[2] * (v80.R or 1)
            }
            local v84 = rad(v82)
            v83.ct = cos(v84)
            local v85 = rad(v82)
            v83.st = sin(v85)
            v83.w = 6.283185307179586 / (T.ORBIT_PERIOD * (v80.Period or 1))
            v83.phase = v80.PhaseOffset or 0
            v83.delay = v80.Delay or 0
            table.insert(v2, v83)
        end
    end
    v1.sats = v2
    v1.sat = v2[1] and v2[1].rig
end

return v1
