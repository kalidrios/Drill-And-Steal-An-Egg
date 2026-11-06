-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {}

function v1.new() -- line 34 | captures: CollectionService
    local v2 = {
        BOB = 1,
        CLOUD = 2,
        FLAME = 3,
        FLAP = 4,
        SPIN = 5
    }
    local sin = math.sin
    local cos = math.cos
    local T, rng, syncGroups, step, to, kick

    local function setBob(v3, v4, v5, v6, v7) -- line 47
        v3.idle = 1
        v3.iw = 6.283185307179586 / v4
        v3.iph = v7
        v3.ampY = v5
        v3.ampR = v6
        v3.idleDelay = 0.5
        v3.bobRel = false
    end

    v2.setBob = setBob

    function v2.bobFromTag(v8, v9) -- line 60 | captures: v2
        local Period = v9:GetAttribute("Period")
        local AmpY = v9:GetAttribute("AmpY")
        local AmpR = v9:GetAttribute("AmpR")
        local Phase = v9:GetAttribute("Phase")
        local setBob = v2.setBob
        local v10 = if type(Period) == "number" and Period > 0 and Period then Period else 2.8
        if type(AmpY) ~= "number" or not AmpY then
            AmpY = 0.01
        end
        if type(AmpR) ~= "number" or not AmpR then
            AmpR = 0
        end
        if type(Phase) ~= "number" or not Phase then
            Phase = 3.141592653589793
        end
        setBob(v8, v10, AmpY, AmpR, Phase)
        v8.bobRel = true
    end

    local function spinFromTag(v11, v12) -- line 76
        local Speed = v12:GetAttribute("Speed")
        local Breathe = v12:GetAttribute("Breathe")
        local BreathePeriod = v12:GetAttribute("BreathePeriod")
        v11.idle = 5
        if type(Speed) ~= "number" or not Speed then
            Speed = 30
        end
        v11.spinW = Speed
        v11.spinA = 0
        if type(Breathe) ~= "number" or not Breathe then
            Breathe = 0
        end
        v11.ampS = Breathe
        local v13 = if type(BreathePeriod) == "number" and BreathePeriod > 0 and BreathePeriod then BreathePeriod else 3
        v11.iw = 6.283185307179586 / v13
        v11.idleDelay = 0.2
    end

    v2.spinFromTag = spinFromTag

    function v2.applyTags(v14, v15) -- line 88 | captures: T, v2, CollectionService
        if CollectionService:HasTag(v15, T.BOB_TAG) then
            v2.bobFromTag(v14, v15)
        elseif CollectionService:HasTag(v15, T.SPIN_TAG) then
            v2.spinFromTag(v14, v15)
        end
    end

    function v2.defineTagged(v16, v17, v18) -- line 98 | captures: T, v2, CollectionService
        local v19 = {}
        for v20, v21 in ipairs({
                T.BOB_TAG,
                T.SPIN_TAG
            }) do
            for v22, v23 in ipairs(CollectionService:GetTagged(v21)) do
                local v24 = v23.Parent and v23.Parent.Parent
                local v25 = v24 and CollectionService:HasTag(v24, T.STAGGER_TAG)
                if not v19[v23] and not v25 and v23:IsA("GuiObject") and v23:IsDescendantOf(v16.main) then
                    v19[v23] = true
                    local v26 = v16.Actors.map[v23]
                    if not (v26 and v26.entrance) then
                        local v27 = {}
                        v27.park = { 0, 0.02, 0, 0.9, 1 }
                        v27.inAt = T.SHOPTAB_AT
                        v27.inSpring = T.CONTENT_IN
                        v27.outAt = T.CLOSE_OUT_AT
                        v27.outSpring = T.CONTENT_OUT
                        v26 = v17(v18(v23, v27))
                    end
                    v2.applyTags(v26, v23)
                end
            end
        end
    end

    local function idleWeight(v28, v29) -- line 120 | captures: T
        local v30 = (v29 - v28.idleAt) * T.IDLE_RAMP
        if v30 <= 0 then
            return 0
        end
        if v30 >= 1 then
            return 1
        end
        return v30 * v30 * (3 - 2 * v30)
    end

    function v2.update(v31, v32, v33, v34) -- line 131 | captures: T, rng, syncGroups, step, to, kick, sin, cos
        local v35 = (v33 - v31.idleAt) * T.IDLE_RAMP
        local v36
        if v35 <= 0 then
            v36 = 0
        elseif v35 >= 1 then
            v36 = 1
        else
            v36 = v35 * v35 * (3 - 2 * v35)
        end
        if v36 ~= 0 then
            local idle = v31.idle
            if idle == 1 then
                local v37 = (v31.bobRel and v33 - v31.idleAt or v33) * v31.iw + v31.iph
                v31.iy = sin(v37) * v31.ampY * v36
                local v38 = v37 - T.BOB_LAG
                v31.ir = sin(v38) * v31.ampR * v36
            elseif idle == 2 then
                if v31.nextAt <= v33 then
                    v31.nextAt = v33 + rng:NextNumber(T.CLOUD_HOLD_MIN, T.CLOUD_HOLD_MAX)
                    local v39 = rng:NextNumber(0.35, 1) * v31.amp
                    local to_2 = to
                    local wander = v31.wander
                    if v31.wander.t > 0 then
                        v39 = -v39 or v39
                    end
                    to_2(wander, v39)
                end
                step(v31.wander, v32)
                v31.ix = v31.wander.x * v36
            elseif idle == 3 then
                local v40 = v33 * v31.iw + v31.iph
                v31.is = 1 + sin(v40) * T.FLAME_BREATHE * v36
                if v34 and v36 >= 1 and v31.nextAt <= v33 then
                    v31.nextAt = v33 + rng:NextNumber(T.FLARE_MIN, T.FLARE_MAX)
                    kick(v31.sc, rng:NextNumber(T.FLARE_SCALE_MIN, T.FLARE_SCALE_MAX))
                    kick(v31.rot, rng:NextNumber(-T.FLARE_ROT, T.FLARE_ROT))
                    kick(v31.oy, -rng:NextNumber(T.FLARE_LIFT_MIN, T.FLARE_LIFT_MAX))
                    v31.live = true
                end
            elseif idle == 5 then
                local v41 = (v31.spinA + v31.spinW * v36 * v32) % 360
                v31.spinA = v41
                v31.ir = v41
                if v31.ampS ~= 0 then
                    local v42 = (v33 - v31.idleAt) * v31.iw
                    v31.is = 1 + sin(v42) * v31.ampS * v36
                end
            elseif idle == 4 then
                local v43 = syncGroups[v31.sync]
                if v43 then
                    local v44 = v43.t / v43.period * 2 * 3.141592653589793 - T.WING_LIFT_LAG
                    v31.iy = cos(v44) * T.WING_LIFT * v36
                end
            end
        end
    end

    function v2.init(v45) -- line 180 | captures: T, rng, syncGroups, step, to, kick
        local T_2 = v45.T
        local rng_2 = v45.rng
        T = T_2
        rng = rng_2
        syncGroups = v45.syncGroups
        local step_2 = v45.Spring.step
        local to_2 = v45.Spring.to
        local kick_2 = v45.Spring.kick
        step = step_2
        to = to_2
        kick = kick_2
    end

    return v2
end

return v1
