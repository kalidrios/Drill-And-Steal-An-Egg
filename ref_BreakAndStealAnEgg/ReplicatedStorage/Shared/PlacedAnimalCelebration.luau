-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Workspace = game:GetService("Workspace")
local AnimalBubble = require(script.Parent.AnimalBubble)
local PlacedAnimalBounds = require(script.Parent.PlacedAnimalBounds)
local v1 = {
    StampAttribute = "PlacedCelebrateAt",
    FreshWindow = 8
}
local v2 = {
    StartDelay = 0,
    StartJitter = 0.12,
    Duration = 3.4,
    DurationJitter = 0.7,
    SpeedMultiplier = 1.6,
    MaxAnimSpeedMultiplier = 1.35,
    RadiusFrac = 0.17,
    MinRadius = 1.3,
    MaxRadius = 4,
    RadiusFootprintMult = 0.9,
    RadiusJitter = 0.35,
    MaxAngularSpeed = 2.2,
    SpeedJitter = 0.22,
    RampTime = 0.3,
    HopPeriod = 0.52,
    HopAirFraction = 0.85,
    HopHeightFrac = 0.55,
    MinHopHeight = 1.2,
    MaxHopHeight = 5,
    HopPeriodJitter = 0.2,
    HopHeightJitter = 0.25,
    Bubble = {
        PopTime = 0.25,
        DisplayTime = 2.4,
        FadeTime = 0.35
    }
}

v1.Config = v2
v1.Emojis = {
    "\240\159\152\132",
    "\240\159\165\179",
    "\240\159\142\137",
    "\240\159\164\169",
    "\240\159\152\129",
    "\240\159\146\150",
    "\226\156\168",
    "\240\159\153\140",
    "\226\157\164\239\184\143",
    "\240\159\152\187",
    "\240\159\144\190",
    "\240\159\140\159"
}

local function rollJitter(v3, v4) -- line 167
    return v3:NextNumber(1 - v4, v4 + 1)
end

function v1.Emoji(v5) -- line 171 | captures: v1
    local Emojis = v1.Emojis
    local v6
    if v5 then
        v6 = v5:NextInteger(1, #Emojis)
    else
        v6 = math.random(1, #Emojis)
    end
    return Emojis[v6]
end

function v1.IsFresh(v7) -- line 180 | captures: Workspace, v1
    local v8 = v7:GetAttribute(v1.StampAttribute)
    if typeof(v8) == "number" then
        local v9 = Workspace:GetServerTimeNow() - v8
        if v9 <= v1.FreshWindow then
            return -v1.FreshWindow <= v9
        end
        return false
    end
    return false
end

function v1.Begin(v10, v11, v12, v13, v14, v15, v16, v17) -- line 192 | captures: AnimalBubble, PlacedAnimalBounds, v1, v2
    local v18 = v16 or Random.new()
    local v19 = v17 or v12
    local v20, v21 = PlacedAnimalBounds.HalfExtents(v11, v19)
    local v22 = math.min(v20, v21)
    local MinRadius = v2.MinRadius
    local v23 = v12 * v2.RadiusFootprintMult
    local v24 = math.max(MinRadius, v23)
    local MaxRadius = v2.MaxRadius
    local v25 = math.max(MaxRadius, v24)
    local v26 = v22 * v2.RadiusFrac
    local RadiusJitter = v2.RadiusJitter
    local v27 = v26 * v18:NextNumber(1 - RadiusJitter, RadiusJitter + 1)
    local v28 = math.clamp(v27, v24, v25)
    local v29 = math.min(v28, v22)
    local v30 = math.max(v29, 0.5)
    local v31 = PlacedAnimalBounds.Clamp(v11, v19 + v30, v13)
    local v32 = v13.X - v31.X
    local v33 = v13.Z - v31.Z
    local v34
    if v32 * v32 + v33 * v33 > 0.25 then
        v34 = math.atan2(v33, v32)
    else
        local v35 = -math.cos(v14)
        local v36 = -math.sin(v14)
        v34 = math.atan2(v35, v36)
    end
    local v37 = math.max(v15, 1) * v2.SpeedMultiplier / v30
    local MaxAngularSpeed = v2.MaxAngularSpeed
    local SpeedJitter = v2.SpeedJitter
    local v38 = MaxAngularSpeed * v18:NextNumber(1 - SpeedJitter, SpeedJitter + 1)
    local v39 = math.min(v37, v38)
    local v40 = v39 * v30
    local v41 = v12 * v2.HopHeightFrac
    local HopHeightJitter = v2.HopHeightJitter
    local v42 = v41 * v18:NextNumber(1 - HopHeightJitter, HopHeightJitter + 1)
    local MinHopHeight = v2.MinHopHeight
    local MaxHopHeight = v2.MaxHopHeight
    local v43 = math.clamp(v42, MinHopHeight, MaxHopHeight)
    local HopPeriod = v2.HopPeriod
    local HopPeriodJitter = v2.HopPeriodJitter
    local v44 = HopPeriod * v18:NextNumber(1 - HopPeriodJitter, HopPeriodJitter + 1)
    local v45 = v18:NextNumber(v2.HopAirFraction, 1)
    local v46 = (v2.Duration + v18:NextNumber(-v2.DurationJitter, v2.DurationJitter)) / v44 + v45
    local v47 = v44 * (math.ceil(v46) - v45)
    local v48 = {
        Elapsed = 0,
        Published = 0,
        Model = v10,
        CenterX = v31.X,
        CenterZ = v31.Z,
        StartX = v13.X,
        StartZ = v13.Z,
        LastX = v13.X,
        LastZ = v13.Z,
        Radius = v30,
        StartAngle = v34
    }
    if v18:NextNumber() < 0.5 then
        v48.Direction = -1
    else
        v48.Direction = 1
    end
    v48.Speed = v40
    local v49 = math.max(v15, 1) * v2.MaxAnimSpeedMultiplier
    v48.AnimSpeed = math.min(v40, v49)
    v48.Omega = v39
    v48.HopHeight = v43
    v48.HopPeriod = v44
    v48.HopPhase = v45
    v48.Delay = v2.StartDelay + v18:NextNumber(0, v2.StartJitter)
    v48.Duration = v47
    v48.Yaw = v14
    local Show = AnimalBubble.Show
    local v50 = v1.Emoji(v18)
    local v51 = {
        AppearDelay = v48.Delay,
        PopTime = v2.Bubble.PopTime
    }
    local v52 = v48.Duration - v2.Bubble.PopTime
    v51.DisplayTime = math.max(v52, 1)
    v51.FadeTime = v2.Bubble.FadeTime
    Show(v10, v50, v51)
    return v48
end

function v1.Step(v53, v54) -- line 311 | captures: v2
    v53.Elapsed += v54
    local v55 = v53.Elapsed - v53.Delay
    if v55 <= 0 then
        return v53.StartX, 0, v53.StartZ, v53.Yaw, 0, false
    end
    local v56 = v53.Duration <= v55
    local Duration = v53.Duration
    local v57 = math.min(v55, Duration)
    local v58 = v53.StartAngle + v53.Direction * v53.Omega * v57
    local v59 = v53.CenterX + math.cos(v58) * v53.Radius
    local v60 = v53.CenterZ + math.sin(v58) * v53.Radius
    local v61 = v57 / v2.RampTime
    local v62 = math.clamp(v61, 0, 1)
    local v63 = v62 * v62 * (3 - v62 * 2)
    local v64 = v53.StartX + (v59 - v53.StartX) * v63
    local v65 = v53.StartZ + (v60 - v53.StartZ) * v63
    local v66 = (v57 / v53.HopPeriod + v53.HopPhase) % 1
    local v67
    if v66 < v2.HopAirFraction then
        local v68 = v66 / v2.HopAirFraction
        v67 = v53.HopHeight * 4 * v68 * (1 - v68)
    else
        v67 = 0
    end
    local v69 = v64 - v53.LastX
    local v70 = v65 - v53.LastZ
    if v69 * v69 + v70 * v70 > 0.0001 then
        local v71 = -v69
        local v72 = -v70
        v53.Yaw = math.atan2(v71, v72)
    end
    v53.LastX = v64
    v53.LastZ = v65
    local Yaw = v53.Yaw
    local v73 = if v56 then 0 else v53.AnimSpeed
    return v64, v67, v65, Yaw, v73, v56
end

return v1
