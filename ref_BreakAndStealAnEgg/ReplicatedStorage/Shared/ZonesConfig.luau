-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RagdollPhysics = require(script.Parent.RagdollPhysics)
local EggRewards = require(script.Parent.EggRewards)
local v1 = {
    BuildFolderName = "Build",
    ZoneBuildsName = "ZoneBuilds",
    ZoneHitboxesName = "ZoneHitboxes",
    PlotsFolderName = "Plots",
    PlotSafePartName = "Hitbox",
    EggName = "Egg",
    SafeZoneName = "SafeZone",
    PlotCull = {
        FromZone = 7,
        GapGrace = 2,
        CheckInterval = 0.2
    },
    Guard = {
        Enabled = true,
        FlatRadius = 20,
        SpeedRampPerRadius = 3,
        MaxSpeedMultiplier = 12,
        MaxAbsoluteSpeed = 400,
        FarBoostRadius = 70,
        FarBoostMultiplier = 2,
        TractionMinSpeed = 4,
        OutrunSpeedFactor = 0.85,
        CatchSpeedFactor = 1.2,
        GateSpeedFactor = 1,
        EscapeSecureRatio = 1.2,
        CloseCallRatio = 0.6,
        CatchGrowthPerDecade = 2.2,
        MaxCatchSpeedFactor = 4,
        OutrunShrinkPerDecade = 0.8,
        MinOutrunSpeedFactor = 0.4,
        SizeRequirement = {
            FreeRanks = 4,
            MaxRarityMult = 2,
            WeightFreeSizeMult = 4,
            WeightMaxSizeMult = 10,
            MaxWeightMult = 1.35
        },
        CatchDistance = 2,
        HitboxShrink = Vector3.new(0.6000000238418579, 1, 0.800000011920929),
        ShowHitboxes = false,
        WindUpMin = 0.6,
        WindUpMax = 0.8,
        WindUpTurnSpeed = 6,
        WindUpZoneMargin = 6,
        HomeArrivalDistance = 4,
        ReturnHomeSpeedMultiplier = 3,
        RoamSpeedFraction = 0.25,
        RoamSpeedMin = 8,
        RoamIdleMin = 1.5,
        RoamIdleMax = 4.5,
        RoamMargin = 10,
        RoamArriveDistance = 4,
        Recovery = {
            StuckMoveStuds = 1.5,
            StuckSeconds = 0.6,
            JumpCooldown = 1,
            PathRetrySeconds = 1,
            PathFollowSeconds = 2,
            WaypointReach = 3,
            HopStuds = 3,
            HardStuckSeconds = 4,
            ReturnTimeoutExtra = 6,
            FallResetDepth = 60,
            TippedUpDot = 0.5,
            OwnershipCheckSeconds = 1,
            AgentRadius = 2,
            AgentHeight = 5
        },
        RagdollDuration = 3,
        RagdollSettleTime = 2.25,
        FlingDistanceDefault = 13,
        FlingDistanceVariance = 0.08,
        FlingAngleWobble = 12,
        FlingLaunchAngle = 25,
        FlingTimeScale = 1.2,
        FlingSpeedMultiplier = 1,
        FlingMinGravityScale = 0.85,
        FlingTumbleSpin = 9,
        FlingLandingInset = 25,
        FlingMinDistance = 7
    },
    Zones = {
        {
            Id = "Zone1",
            Guard = "Chicken",
            Rarity = "Common",
            GuardSpeed = 30,
            RequiredPower = 5,
            FlingDistance = 12,
            GuardFlatRadius = 200,
            Icon = "rbxassetid://84488003116697"
        },
        {
            Id = "Zone2",
            Guard = "SPHINX",
            Rarity = "Uncommon",
            GuardSpeed = 34,
            RequiredPower = 1000,
            FlingDistance = 18,
            Icon = "rbxassetid://95024755729764"
        },
        {
            Id = "Zone3",
            Guard = "IceYeti",
            Rarity = "Rare",
            GuardSpeed = 38,
            RequiredPower = 50000,
            FlingDistance = 27,
            Icon = "rbxassetid://92384932429761"
        },
        {
            Id = "Zone4",
            Guard = "EmeraldSerpent",
            Rarity = "Epic",
            GuardSpeed = 42,
            RequiredPower = 750000,
            FlingDistance = 37,
            Icon = "rbxassetid://137472407126291"
        },
        {
            Id = "Zone5",
            Guard = "WoollyMammoth",
            Rarity = "Legendary",
            GuardSpeed = 46,
            RequiredPower = 12000000,
            FlingDistance = 48,
            Icon = "rbxassetid://132311376055712"
        },
        {
            Id = "Zone6",
            Guard = "RedshellCrab",
            Rarity = "Mythic",
            GuardSpeed = 50,
            RequiredPower = 150000000,
            FlingDistance = 60,
            Icon = "rbxassetid://106771678532901"
        },
        {
            Id = "Zone7",
            Guard = "MoleTitan",
            Rarity = "Divine",
            GuardSpeed = 55,
            RequiredPower = 1000000000,
            FlingDistance = 72,
            Icon = "rbxassetid://107461492429147"
        },
        {
            Id = "Zone8",
            Guard = "Griffin",
            Rarity = "Cosmic",
            GuardSpeed = 60,
            RequiredPower = 5000000000,
            FlingDistance = 85,
            GuardYawOffset = 180,
            Icon = "rbxassetid://133828248392058"
        },
        {
            Id = "Zone9",
            Guard = "3Hydra",
            Rarity = "Secret",
            GuardSpeed = 65,
            RequiredPower = 25000000000,
            FlingDistance = 100,
            GuardYawOffset = 180,
            Icon = "rbxassetid://117831248018841"
        },
        {
            Id = "Zone10",
            Guard = "AlienGuardian",
            Rarity = "Celestial",
            GuardSpeed = 70,
            RequiredPower = 100000000000,
            FlingDistance = 115
        }
    }
}

function v1.SizeRequirementMult(v2, v3) -- line 398 | captures: EggRewards, v1
    local SizeRequirement = v1.Guard.SizeRequirement
    if SizeRequirement then
        local v4, v5 = EggRewards.ZoneRankOf(v2)
        local v6
        if v4 and v5 and SizeRequirement.FreeRanks < v5 and SizeRequirement.FreeRanks < v4 then
            local v7 = (v4 - SizeRequirement.FreeRanks) / (v5 - SizeRequirement.FreeRanks)
            v6 = 1 + (SizeRequirement.MaxRarityMult - 1) * v7
        else
            v6 = 1
        end
        local v8 = SizeRequirement.WeightMaxSizeMult - SizeRequirement.WeightFreeSizeMult
        local v9
        if v3 and SizeRequirement.WeightFreeSizeMult < v3 and v8 > 0 then
            local v10 = (v3 - SizeRequirement.WeightFreeSizeMult) / v8
            local v11 = math.clamp(v10, 0, 1)
            v9 = 1 + (SizeRequirement.MaxWeightMult - 1) * v11
        else
            v9 = 1
        end
        return v6 * v9
    end
    return 1
end

function v1.GuardChaseFactor(v12, v13) -- line 433 | captures: v1
    local Guard = v1.Guard
    local v14 = v13 or 0
    if v14 <= 0 then
        return Guard.OutrunSpeedFactor
    end
    local v15 = v12 or 0
    local v16 = math.max(v15, 1) / v14
    if v16 >= 1 then
        local EscapeSecureRatio = Guard.EscapeSecureRatio
        if v16 < EscapeSecureRatio then
            local v17 = math.log(v16) / math.log(EscapeSecureRatio)
            return Guard.GateSpeedFactor + (Guard.OutrunSpeedFactor - Guard.GateSpeedFactor) * v17
        end
        local v18 = v16 / EscapeSecureRatio
        local v19 = math.log10(v18)
        local v20 = Guard.OutrunSpeedFactor * Guard.OutrunShrinkPerDecade ^ v19
        local MinOutrunSpeedFactor = Guard.MinOutrunSpeedFactor
        return (math.max(v20, MinOutrunSpeedFactor))
    end
    local v21 = 1 / v16
    local v22 = math.log10(v21)
    local v23 = Guard.CatchSpeedFactor * Guard.CatchGrowthPerDecade ^ v22
    local MaxCatchSpeedFactor = Guard.MaxCatchSpeedFactor
    local v24 = math.min(v23, MaxCatchSpeedFactor)
    local CloseCallRatio = Guard.CloseCallRatio
    if CloseCallRatio < v16 then
        local v25 = v16 / CloseCallRatio
        local v26 = math.log(v25)
        local v27 = 1 / CloseCallRatio
        local v28 = v26 / math.log(v27)
        v24 += (Guard.GateSpeedFactor - v24) * v28
    end
    return v24
end

function v1.GuardFling(v29, v30, v31, v32) -- line 508 | captures: RagdollPhysics, v1
    local Guard = v1.Guard
    local v33 = v30 or Random.new()
    local v34 = v29 and v1.Get(v29)
    local v35 = (v34 and v34.FlingDistance or Guard.FlingDistanceDefault) * (1 + v33:NextNumber(0, Guard.FlingDistanceVariance))
    local v36 = Guard.FlingSpeedMultiplier or 1
    local v37 = v35 * (v36 * v36)
    if v31 ~= nil then
        local v38 = math.min(v37, v31)
        local FlingMinDistance = Guard.FlingMinDistance
        v37 = math.max(v38, FlingMinDistance)
    end
    local Gravity = workspace.Gravity
    local v39, v40, v41 = RagdollPhysics.ShapeLaunch(v37, Gravity, Guard.FlingLaunchAngle, Guard.FlingTimeScale, Guard.FlingMinGravityScale)
    local FlingAngleWobble = Guard.FlingAngleWobble
    local v42 = math.rad(FlingAngleWobble)
    local v43 = v33:NextNumber(-v42, v42)
    local v44 = Vector3.new(1, 0, 0)
    local v45 = v32 or v44
    local v46 = math.cos(v43)
    local v47 = math.sin(v43)
    local v48 = (v45.X * v46 - v45.Z * v47) * v39
    local v49 = (v45.X * v47 + v45.Z * v46) * v39
    local v50 = Vector3.new(v48, v40, v49)
    local v51 = RagdollPhysics.FlightTime(v40, Gravity, v41)
    local RagdollDuration = Guard.RagdollDuration
    local v52 = v51 + Guard.RagdollSettleTime
    return v50, math.max(RagdollDuration, v52), v41, v51
end

function v1.IndexOf(v53) -- line 564 | captures: v1
    for v54, v55 in v1.Zones do
        if v55.Id == v53 then
            return v54
        end
    end
    return nil
end

function v1.Get(v56) -- line 573 | captures: v1
    for v57, v58 in v1.Zones do
        if v58.Id == v56 then
            return v58
        end
    end
    return nil
end

return v1
