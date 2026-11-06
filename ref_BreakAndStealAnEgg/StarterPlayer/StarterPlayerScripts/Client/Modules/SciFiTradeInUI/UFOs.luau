-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local Rigs, T, rng, Spring
local sin = math.sin
local v2, v3, v4, v5, v6, v7
local v8 = false
local v9 = -1
local v10 = false
local v11 = 0
local v12 = false
local v13 = 0

local function newState(v14, v15, v16, v17) -- line 47 | captures: rng
    return {
        mode = 0,
        t = 0,
        k = 1,
        fx = 0,
        fy = 0,
        tx = 0,
        ty = 0,
        cx = 0,
        cy = 0,
        dur = 1,
        px = 0,
        py = 0,
        depth = 1,
        R = v14,
        path = v15,
        seg = v16,
        scale = v17,
        ph = rng:NextNumber(0, 6.283185307179586),
        bw = 6.283185307179586 / rng:NextNumber(1.8, 2.6)
    }
end

local function pathPoint(v18, v19) -- line 67
    local v20 = #v18.path
    return v18.path[(v19 - 1) % v20 + 1]
end

local function startFlight(v21, v22, v23, v24, v25, v26, v27) -- line 72
    v21.mode = v22
    v21.t = 0
    local x = v21.R.x
    local y = v21.R.y
    v21.fx = x
    v21.fy = y
    v21.tx = v23
    v21.ty = v24
    local v28 = v26 or (v21.R.x + v23) * 0.5
    local v29 = v27 or (v21.R.y + v24) * 0.5
    v21.cx = v28
    v21.cy = v29
    v21.dur = v25
end

local function setLayer(v30, v31) -- line 81 | captures: T
    v30.R.z = v31 == "B" and T.Z_BACK or T.Z_FRONT
    v30.back = v31 == "B"
end

local function move(v32, v33, v34) -- line 87 | captures: Rigs, T, v5, v6, v12, sin
    local R = v32.R
    local mode = v32.mode
    if mode == 0 then
        return
    end
    v32.t += v33
    local v35, v36
    if mode == 1 or mode == 3 then
        local v37 = v32.t / v32.dur
        if v37 >= 1 then
            v37 = 1
        end
        local v38 = mode == 1 and 1 - (1 - v37) ^ 3 or Rigs.smooth(v37)
        local v39 = 1 - v38
        v35 = v39 * v39 * v32.fx + 2 * v39 * v38 * v32.cx + v38 * v38 * v32.tx
        v36 = v39 * v39 * v32.fy + 2 * v39 * v38 * v32.cy + v38 * v38 * v32.ty
        if v37 >= 1 then
            if not (mode == 1 and v32 == v5) then
                if v12 and v32 == v6 then
                    v32.mode = 5
                else
                    v32.mode = 4
                    v32.k = 1
                    v32.t = 0
                    local v40 = #v32.path
                    local v41 = v32.path[1 % v40 + 1][3]
                    v32.R.z = v41 == "B" and T.Z_BACK or T.Z_FRONT
                    v32.back = v41 == "B"
                end
            else
                v32.mode = 2
            end
        end
    elseif mode == 2 or mode == 5 then
        v35, v36 = v32.tx, v32.ty
    else
        local v42 = v32.seg * (v12 and T.UFO_SEG_LOW or 1)
        if v42 <= v32.t then
            v32.t -= v42
            v32.k = v32.k % #v32.path + 1
            local v43 = v32.k + 1
            local v44 = #v32.path
            local v45 = v32.path[(v43 - 1) % v44 + 1][3]
            v32.R.z = v45 == "B" and T.Z_BACK or T.Z_FRONT
            v32.back = v45 == "B"
        end
        local v46 = Rigs.smooth(v32.t / v42)
        local v47 = v32.k - 1
        local v48 = #v32.path
        local v49 = v32.path[(v47 - 1) % v48 + 1]
        local k = v32.k
        local v50 = #v32.path
        local v51 = v32.path[(k - 1) % v50 + 1]
        local v52 = v32.k + 1
        local v53 = #v32.path
        local v54 = v32.path[(v52 - 1) % v53 + 1]
        local v55 = v32.k + 2
        local v56 = #v32.path
        local v57 = v32.path[(v55 - 1) % v56 + 1]
        v35, v36 = Rigs.catmull(v49[1], v51[1], v54[1], v57[1], v46), Rigs.catmull(v49[2], v51[2], v54[2], v57[2], v46)
    end
    local v58 = v34 * v32.bw + v32.ph
    local v59 = v33 > 0 and (v35 - v32.px) / v33 or 0
    v32.px = v35
    v32.py = v36
    R.x = v35
    R.y = v36 + sin(v58) * T.UFO_BOB_Y
    local v60 = v59 * T.UFO_BANK
    local v61 = math.clamp(v60, -14, 14)
    local v62 = v58 - 0.9
    R.r = v61 + sin(v62) * T.UFO_BOB_R
    local UFO_BACK_SCALE = v32.back and T.UFO_BACK_SCALE or 1
    local depth = v32.depth
    local v63 = UFO_BACK_SCALE - v32.depth
    local v64 = v33 * 3
    v32.depth = depth + v63 * math.min(1, v64)
    R.s = v32.scale * v32.depth
end

local function fade(v65, v66) -- line 144 | captures: T, v11
    local v67 = v11
    local v68 = v66 / T.UFO_OUT
    if v65.a < v67 then
        local v69 = v65.a + v68
        v65.a = math.min(v67, v69)
    elseif v67 < v65.a then
        local v70 = v65.a - v68
        v65.a = math.max(v67, v70)
    end
end

local function stepUfo(v71, v72, v73, v74, v75) -- line 154 | captures: Rigs, T, v11, move
    local v76
    if v71 then
        if v71.mode == 0 then
            v76 = true
        else
            move(v71, v72, v73)
            local R = v71.R
            local v77 = v11
            local v78 = v72 / T.UFO_OUT
            if R.a < v77 then
                local v79 = R.a + v78
                R.a = math.min(v77, v79)
            elseif v77 < R.a then
                local v80 = R.a - v78
                R.a = math.max(v77, v80)
            end
            v76 = false
        end
    else
        v76 = true
    end
    if not v76 and not (v75 and (v71.mode == 4 or v71.mode == 5)) then
        Rigs.write(v71.R, v74)
    end
end

function v1.prepareOpen(v81, v82) -- line 165 | captures: Rigs, T, Spring, v2, v3, v4, v5, v6, v7, v8, v10, v11, newState
    if not v2 then
        return
    end
    v10 = true
    v11 = 0
    v5 = newState(v2, T.UFO_BIG_PATH, T.UFO_SEG, T.UFO_SCALE)
    local v83 = v2
    local v84 = v2
    local v85 = T.UFO_SWOOP_FROM[1]
    local v86 = T.UFO_SWOOP_FROM[2]
    v83.x = v85
    v84.y = v86
    local v87 = v2
    local v88 = v2
    local v89 = v2
    local v90 = v2
    local UFO_SCALE = T.UFO_SCALE
    v87.a = 0
    v88.r = 0
    v89.s = UFO_SCALE
    v90.vis = true
    local v91 = v5
    v91.R.z = T.Z_FRONT
    v91.back = false
    local v92 = v5
    local v93 = T.UFO_HOVER[1]
    local v94 = T.UFO_HOVER[2]
    local v95 = T.UFO_SWOOP * T.TIME_SCALE
    local v96 = T.UFO_SWOOP_FROM[1] + 0.2
    local v97 = T.UFO_HOVER[2] - 0.25
    v92.mode = 1
    v92.t = 0
    local x = v92.R.x
    local y = v92.R.y
    v92.fx = x
    v92.fy = y
    v92.tx = v93
    v92.ty = v94
    local v98 = v96 or (v92.R.x + v93) * 0.5
    local v99 = v97 or (v92.R.y + v94) * 0.5
    v92.cx = v98
    v92.cy = v99
    v92.dur = v95
    v5.at = v81
    if v3 then
        v6 = newState(v3, T.UFO_SMALL_PATH, T.UFO_SMALL_SEG, T.UFO_SMALL_SCALE)
        local v100 = v3
        local v101 = v3
        local v102 = T.UFO_SMALL_FROM[1]
        local v103 = T.UFO_SMALL_FROM[2]
        v100.x = v102
        v101.y = v103
        local v104 = v3
        local v105 = v3
        local v106 = v3
        local v107 = v3
        local UFO_SMALL_SCALE = T.UFO_SMALL_SCALE
        v104.a = 1
        v105.r = 0
        v106.s = UFO_SMALL_SCALE
        v107.vis = true
        local v108 = v6
        v108.R.z = T.Z_FRONT
        v108.back = false
        v6.startAt = v81 + T.UFO_SMALL_AT * T.TIME_SCALE
    end
    if v4 then
        v4.vis = false
        v4.z = T.Z_FRONT
        v4.inst.AnchorPoint = Vector2.new(0.5, 0)
        v4.inst.ScaleType = Enum.ScaleType.Stretch
        v4.touched = true
        Spring.snap(v7, 0)
        v4.beamAt = v81 + T.BEAM_AT * T.TIME_SCALE
        v4.holdAt = v81 + T.BEAM_HOLD * T.TIME_SCALE
        v5.leaveAt = v81 + T.UFO_LEAVE_AT * T.TIME_SCALE
        v8 = false
        Rigs.write(v4, v82)
    end
    Rigs.write(v2, v82)
    if v3 then
        Rigs.write(v3, v82)
    end
end

function v1.onClose() -- line 204 | captures: v4, v8, v11
    v11 = 1
    if not (v4 and v4.vis) then
        return
    end
    v4.vis = false
    v8 = false
    local v109 = v4
    local v110 = v4
    v109.beamAt = (1/0)
    v110.holdAt = (1/0)
end

function v1.onReopen() -- line 213 | captures: v11
    v11 = 0
end

function v1.step(v111, v112, v113) -- line 217 | captures: Rigs, T, rng, Spring, v2, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v1, stepUfo
    if not v10 then
        return
    end
    v13 = 1 - v13
    if v6 and v6.mode == 0 and v6.startAt <= v112 then
        local v114 = T.UFO_SMALL_PATH[1]
        local v115 = v6
        local v116 = v114[1]
        local v117 = v114[2]
        local v118 = T.UFO_SMALL_IN * T.TIME_SCALE
        local v119 = v114[1] + 0.25
        local v120 = v114[2] + 0.55
        v115.mode = 1
        v115.t = 0
        local x = v115.R.x
        local y = v115.R.y
        v115.fx = x
        v115.fy = y
        v115.tx = v116
        v115.ty = v117
        local v121 = v119 or (v115.R.x + v116) * 0.5
        local v122 = v120 or (v115.R.y + v117) * 0.5
        v115.cx = v121
        v115.cy = v122
        v115.dur = v118
    end
    if v5.mode == 2 and (v5.leaveAt or 0) <= v112 then
        local v123 = T.UFO_BIG_PATH[1]
        local v124 = v5
        local v125 = v123[1]
        local v126 = v123[2]
        local v127 = T.UFO_LEAVE * T.TIME_SCALE
        local v128 = v123[1] + 0.1
        local v129 = T.UFO_HOVER[2] - 0.05
        v124.mode = 3
        v124.t = 0
        local x = v124.R.x
        local y = v124.R.y
        v124.fx = x
        v124.fy = y
        v124.tx = v125
        v124.ty = v126
        local v130 = v128 or (v124.R.x + v125) * 0.5
        local v131 = v129 or (v124.R.y + v126) * 0.5
        v124.cx = v130
        v124.cy = v131
        v124.dur = v127
    end
    if v4 then
        if not v8 and v4.beamAt <= v112 then
            v8 = true
            v4.beamAt = (1/0)
            v4.vis = true
            Spring.to(v7, 1, T.BEAM_GROW[1], T.BEAM_GROW[2])
            if v1.onBeam then
                v1.onBeam()
            end
        end
        if v8 and v4.holdAt <= v112 then
            v4.holdAt = (1/0)
            Spring.to(v7, 0, T.BEAM_RETRACT[1], T.BEAM_RETRACT[2])
        end
        if v8 then
            local v132 = Spring.step(v7, v111)
            local x = v7.x
            local v133 = math.max(x, 0)
            if v132 and v7.t == 0 then
                v8 = false
                v4.vis = false
            end
            v4.x = v2.x
            v4.y = v2.y + T.BEAM_DROP
            v4.sw = T.BEAM_SIZE[1]
            v4.sh = T.BEAM_SIZE[2] * v133
            v4.r = 0
            local v134 = v112 * 20
            local v135 = math.floor(v134)
            if v135 ~= v9 then
                v9 = v135
                v4.a = T.BEAM_ALPHA + rng:NextNumber(0, 0.12)
            end
            local v136 = v4
            local v137 = v11
            local v138 = 0 / T.UFO_OUT
            if v136.a < v137 then
                local v139 = v136.a + v138
                v136.a = math.min(v137, v139)
            elseif v137 < v136.a then
                local v140 = v136.a - v138
                v136.a = math.max(v137, v140)
            end
            Rigs.write(v4, v113)
        elseif v4.vis == false and v4.wvis then
            Rigs.write(v4, v113)
        end
    end
    local v141 = v12 and v13 == 1
    stepUfo(v5, v111, v112, v113, v141)
    stepUfo(v6, v111, v112, v113, v141)
end

function v1.toRest() -- line 278 | captures: Rigs, Spring, v2, v3, v4, v7, v8, v10
    v10 = false
    v8 = false
    Rigs.toRest(v2)
    Rigs.toRest(v3)
    Rigs.toRest(v4)
    if v7 then
        Spring.snap(v7, 0)
    end
end

function v1.setLow(v142) -- line 289 | captures: v12
    v12 = v142
end

function v1.init(v143) -- line 293 | captures: Rigs, T, rng, Spring, v2, v3, v4, v5, v6, v7, v10, v12, v1
    local T_2 = v143.T
    local rng_2 = v143.rng
    local Spring_2 = v143.Spring
    T = T_2
    rng = rng_2
    Spring = Spring_2
    Rigs = v143.Rigs
    v2 = Rigs.new(v143.UFOBig)
    v3 = Rigs.new(v143.UFOSmall)
    v4 = Rigs.new(v143.AbductionBeam)
    v7 = Spring.new(0, T.BEAM_GROW[1], T.BEAM_GROW[2])
    v12 = v143.touchOnly
    v10 = false
    v5 = nil
    v6 = nil
    for v144, v145 in ipairs({
            v143.UFOBig,
            v143.UFOSmall,
            v143.AbductionBeam
        }) do
        v143.Actors.noFade[v145] = true
    end
    local v146 = v2
    local v147 = v3
    local v148 = v4
    v1.big = v146
    v1.small = v147
    v1.beam = v148
end

return v1
