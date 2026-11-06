-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    BOB = 1,
    CLOUD = 2,
    FLAME = 3,
    FLAP = 4,
    SPIN = 5
}
local CollectionService = game:GetService("CollectionService")
local sin = math.sin
local cos = math.cos
local T, rng, syncGroups, step, to, kick

local function setBob(v2, v3, v4, v5, v6) -- line 38
    v2.idle = 1
    v2.iw = 6.283185307179586 / v3
    v2.iph = v6
    v2.ampY = v4
    v2.ampR = v5
    v2.idleDelay = 0.5
    v2.bobRel = false
end

v1.setBob = setBob

function v1.bobFromTag(v7, v8) -- line 51 | captures: v1
    local Period = v8:GetAttribute("Period")
    local AmpY = v8:GetAttribute("AmpY")
    local AmpR = v8:GetAttribute("AmpR")
    local Phase = v8:GetAttribute("Phase")
    local setBob = v1.setBob
    local v9 = if type(Period) == "number" and Period > 0 and Period then Period else 2.8
    if type(AmpY) ~= "number" or not AmpY then
        AmpY = 0.01
    end
    if type(AmpR) ~= "number" or not AmpR then
        AmpR = 0
    end
    if type(Phase) ~= "number" or not Phase then
        Phase = 3.141592653589793
    end
    setBob(v7, v9, AmpY, AmpR, Phase)
    v7.bobRel = true
end

local function spinFromTag(v10, v11) -- line 67
    local Speed = v11:GetAttribute("Speed")
    local Breathe = v11:GetAttribute("Breathe")
    local BreathePeriod = v11:GetAttribute("BreathePeriod")
    v10.idle = 5
    if type(Speed) ~= "number" or not Speed then
        Speed = 30
    end
    v10.spinW = Speed
    v10.spinA = 0
    if type(Breathe) ~= "number" or not Breathe then
        Breathe = 0
    end
    v10.ampS = Breathe
    local v12 = if type(BreathePeriod) == "number" and BreathePeriod > 0 and BreathePeriod then BreathePeriod else 3
    v10.iw = 6.283185307179586 / v12
    v10.idleDelay = 0.2
end

v1.spinFromTag = spinFromTag

function v1.applyTags(v13, v14) -- line 79 | captures: T, v1, CollectionService
    if CollectionService:HasTag(v14, T.BOB_TAG) then
        v1.bobFromTag(v13, v14)
    elseif CollectionService:HasTag(v14, T.SPIN_TAG) then
        v1.spinFromTag(v13, v14)
    end
end

function v1.defineTagged(v15, v16, v17) -- line 89 | captures: T, v1, CollectionService
    local v18 = {}
    for v19, v20 in ipairs({
            T.BOB_TAG,
            T.SPIN_TAG
        }) do
        for v21, v22 in ipairs(CollectionService:GetTagged(v20)) do
            local Parent = v22.Parent
            local v23
            while true do
                if Parent then
                    if Parent == v15.main then
                        v23 = false
                        break
                    end
                    if CollectionService:HasTag(Parent, T.STAGGER_TAG) then
                        v23 = true
                        break
                    end
                    Parent = Parent.Parent
                    continue
                end
                v23 = false
                break
            end
            if not v18[v22] and not v23 and v22:IsA("GuiObject") and v22:IsDescendantOf(v15.main) then
                v18[v22] = true
                local v24 = v15.Actors.map[v22]
                if not (v24 and v24.entrance) then
                    local v25 = {}
                    v25.park = { 0, 0.02, 0, 0.9, 1 }
                    v25.inAt = T.SHOPTAB_AT or T.CLOSE_AT
                    v25.inSpring = T.CONTENT_IN
                    v25.outAt = T.CLOSE_OUT_AT
                    v25.outSpring = T.CONTENT_OUT
                    v24 = v16(v17(v22, v25))
                end
                v1.applyTags(v24, v22)
            end
        end
    end
end

local function idleWeight(v26, v27) -- line 119 | captures: T
    local v28 = (v27 - v26.idleAt) * T.IDLE_RAMP
    if v28 <= 0 then
        return 0
    end
    if v28 >= 1 then
        return 1
    end
    return v28 * v28 * (3 - 2 * v28)
end

function v1.update(v29, v30, v31, v32) -- line 130 | captures: T, rng, syncGroups, step, to, kick, sin, cos
    local v33 = (v31 - v29.idleAt) * T.IDLE_RAMP
    local v34
    if v33 <= 0 then
        v34 = 0
    elseif v33 >= 1 then
        v34 = 1
    else
        v34 = v33 * v33 * (3 - 2 * v33)
    end
    if v34 ~= 0 then
        local idle = v29.idle
        if idle == 1 then
            local v35 = (v29.bobRel and v31 - v29.idleAt or v31) * v29.iw + v29.iph
            v29.iy = sin(v35) * v29.ampY * v34
            local v36 = v35 - T.BOB_LAG
            v29.ir = sin(v36) * v29.ampR * v34
        elseif idle == 2 then
            if v29.nextAt <= v31 then
                v29.nextAt = v31 + rng:NextNumber(T.CLOUD_HOLD_MIN, T.CLOUD_HOLD_MAX)
                local v37 = rng:NextNumber(0.35, 1) * v29.amp
                local to_2 = to
                local wander = v29.wander
                if v29.wander.t > 0 then
                    v37 = -v37 or v37
                end
                to_2(wander, v37)
            end
            step(v29.wander, v30)
            v29.ix = v29.wander.x * v34
        elseif idle == 3 then
            local v38 = v31 * v29.iw + v29.iph
            v29.is = 1 + sin(v38) * T.FLAME_BREATHE * v34
            if v32 and v34 >= 1 and v29.nextAt <= v31 then
                v29.nextAt = v31 + rng:NextNumber(T.FLARE_MIN, T.FLARE_MAX)
                kick(v29.sc, rng:NextNumber(T.FLARE_SCALE_MIN, T.FLARE_SCALE_MAX))
                kick(v29.rot, rng:NextNumber(-T.FLARE_ROT, T.FLARE_ROT))
                kick(v29.oy, -rng:NextNumber(T.FLARE_LIFT_MIN, T.FLARE_LIFT_MAX))
                v29.live = true
            end
        elseif idle == 5 then
            local v39 = (v29.spinA + v29.spinW * v34 * v30) % 360
            v29.spinA = v39
            v29.ir = v39
            if v29.ampS ~= 0 then
                local v40 = (v31 - v29.idleAt) * v29.iw
                v29.is = 1 + sin(v40) * v29.ampS * v34
            end
        elseif idle == 4 then
            local v41 = syncGroups[v29.sync]
            if v41 then
                local v42 = v41.t / v41.period * 2 * 3.141592653589793 - T.WING_LIFT_LAG
                v29.iy = cos(v42) * T.WING_LIFT * v34
            end
        end
    end
end

function v1.init(v43) -- line 179 | captures: T, rng, syncGroups, step, to, kick
    local T_2 = v43.T
    local rng_2 = v43.rng
    T = T_2
    rng = rng_2
    syncGroups = v43.syncGroups
    local step_2 = v43.Spring.step
    local to_2 = v43.Spring.to
    local kick_2 = v43.Spring.kick
    step = step_2
    to = to_2
    kick = kick_2
end

return v1
