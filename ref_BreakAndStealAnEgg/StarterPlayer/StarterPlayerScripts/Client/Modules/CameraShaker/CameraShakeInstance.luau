-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}

v1.__index = v1
v1.CameraShakeState = {
    FadingIn = 0,
    FadingOut = 1,
    Sustained = 2,
    Inactive = 3
}

local v2 = Random.new()

function v1.new(v3, v4, v5, v6) -- line 19 | captures: v1, v2
    local v7 = if v5 == nil then 0 else v5
    local v8 = if v6 == nil then 0 else v6
    local v9 = type(v3) == "number"
    assert(v9, "Magnitude must be a number")
    local v10 = type(v4) == "number"
    assert(v10, "Roughness must be a number")
    local v11 = {
        PositionInfluence = Vector3.new(0, 0, 0),
        RotationInfluence = Vector3.new(0, 0, 0),
        DeleteOnInactive = true,
        roughMod = 1,
        magnMod = 1,
        Magnitude = v3,
        Roughness = v4,
        fadeOutDuration = v8,
        fadeInDuration = v7,
        sustain = v7 > 0
    }
    if v7 > 0 then
        v11.currentFadeTime = 0
    else
        v11.currentFadeTime = 1
    end
    v11.tick = v2:NextNumber(-100, 100)
    return (setmetatable(v11, v1))
end

local function UpdateShake(v12, v13) -- line 48
    local tick = v12.tick
    local currentFadeTime = v12.currentFadeTime
    local v14 = math.noise(tick, 0) * 0.5
    local v15 = math.noise(0, tick) * 0.5
    local v16 = math.noise(tick, tick) * 0.5
    local v17 = Vector3.new(v14, v15, v16)
    if v12.fadeInDuration > 0 and v12.sustain then
        if currentFadeTime < 1 then
            currentFadeTime += v13 / v12.fadeInDuration
        elseif v12.fadeOutDuration > 0 then
            v12.sustain = false
        end
    end
    if not v12.sustain then
        if v12.fadeOutDuration > 0 then
            currentFadeTime -= v13 / v12.fadeOutDuration
        else
            currentFadeTime = 0
        end
    end
    if v12.sustain then
        v12.tick = tick + v13 * v12.Roughness * v12.roughMod
    else
        v12.tick = tick + v13 * v12.Roughness * v12.roughMod * currentFadeTime
    end
    local v18 = math.clamp(currentFadeTime, 0, 1)
    v12.currentFadeTime = v18
    return v17 * v12.Magnitude * v12.magnMod * v18
end

v1.UpdateShake = UpdateShake

local function StartFadeOut(v19, v20) -- line 90
    if v20 == 0 then
        v19.currentFadeTime = 0
    end
    v19.fadeOutDuration = v20
    v19.fadeInDuration = 0
    v19.sustain = false
end

v1.StartFadeOut = StartFadeOut

local function StartFadeIn(v21, v22) -- line 99
    if v22 == 0 then
        v21.currentFadeTime = 1
    end
    v21.fadeInDuration = v22 or v21.fadeInDuration
    v21.fadeOutDuration = 0
    v21.sustain = true
end

v1.StartFadeIn = StartFadeIn

local function GetScaleRoughness(v23) -- line 108
    return v23.roughMod
end

v1.GetScaleRoughness = GetScaleRoughness

local function SetScaleRoughness(v24, v25) -- line 112
    v24.roughMod = v25
end

v1.SetScaleRoughness = SetScaleRoughness

local function GetScaleMagnitude(v26) -- line 116
    return v26.magnMod
end

v1.GetScaleMagnitude = GetScaleMagnitude

local function SetScaleMagnitude(v27, v28) -- line 120
    v27.magnMod = v28
end

v1.SetScaleMagnitude = SetScaleMagnitude

local function GetNormalizedFadeTime(v29) -- line 124
    return v29.currentFadeTime
end

v1.GetNormalizedFadeTime = GetNormalizedFadeTime

local function IsShaking(v30) -- line 128
    if v30.currentFadeTime > 0 then
        return true
    end
    return v30.sustain
end

v1.IsShaking = IsShaking

local function IsFadingOut(v31) -- line 132
    return not v31.sustain and v31.currentFadeTime > 0
end

v1.IsFadingOut = IsFadingOut

local function IsFadingIn(v32) -- line 136
    if v32.currentFadeTime < 1 then
        return v32.sustain and v32.fadeInDuration > 0
    end
    return false
end

v1.IsFadingIn = IsFadingIn

function v1.GetState(v33) -- line 140 | captures: v1
    if v33:IsFadingIn() then
        return v1.CameraShakeState.FadingIn
    end
    if v33:IsFadingOut() then
        return v1.CameraShakeState.FadingOut
    end
    if v33:IsShaking() then
        return v1.CameraShakeState.Sustained
    end
    return v1.CameraShakeState.Inactive
end

return v1
