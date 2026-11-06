-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ZoneAnimalsConfig = require(script.Parent.ZoneAnimalsConfig)
local v1 = {
    ClaimClaimedText = "Claimed",
    LockedName = "???",
    LockedImageTransparency = 0.5,
    LockedGradientDarken = 0.55,
    RarityOrder = {
        "Common",
        "Uncommon",
        "Rare",
        "Epic",
        "Legendary",
        "Mythic",
        "Divine",
        "Cosmic",
        "Secret",
        "Celestial",
        "Inferno",
        "Void",
        "Omega"
    },
    TileFraming = {
        fill = 0.62,
        nudgeUp = -0.04
    },
    InfoFraming = { fill = 0.8 },
    SelectedStrokeColor = Color3.new(1, 1, 1),
    ReadyStrokeColor = Color3.fromRGB(60, 255, 60),
    ClaimReadyGradient = ColorSequence.new(Color3.fromRGB(51, 213, 78), Color3.fromRGB(195, 255, 0)),
    LockedImageColor = Color3.fromRGB(0, 0, 0)
}

function v1.RarityIndex(v2) -- line 84 | captures: v1
    return table.find(v1.RarityOrder, v2) or #v1.RarityOrder + 1
end

local function roundSig2(v3) -- line 95
    if v3 <= 0 then
        return 0
    end
    local v4 = math.log10(v3)
    local v5 = 10 ^ (math.floor(v4) - 1)
    local v6 = v3 / v5 + 0.5
    return math.floor(v6) * v5
end

local function effectiveGate(v7, v8) -- line 110 | captures: ZoneAnimalsConfig
    local IndexRewards = ZoneAnimalsConfig.IndexRewards
    local v9 = 0
    for v10 = v8, 1, -1 do
        local v11 = v7[v10] and v7[v10].RequiredPower
        if v11 and v11 > 0 then
            return v11 * IndexRewards.SpeedFinalZoneStep ^ v9
        end
        v9 += 1
    end
    return 0
end

local function zoneSpeedBudget(v12) -- line 123 | captures: ZoneAnimalsConfig, effectiveGate
    local IndexRewards = ZoneAnimalsConfig.IndexRewards
    local Zones = require(script.Parent.ZonesConfig).Zones
    local v13
    if Zones[v12 + 1] then
        v13 = effectiveGate(Zones, v12 + 1)
    else
        v13 = effectiveGate(Zones, v12) * IndexRewards.SpeedFinalZoneStep
    end
    return v13 * IndexRewards.SpeedZoneShare
end

local v14 = false
local v15 = {}
local v16 = {}
local v17 = {}
local v18 = {}

local function median(v19) -- line 142
    table.sort(v19)
    local v20 = #v19 / 2
    return v19[math.ceil(v20)]
end

local function buildPoolMaps() -- line 147 | captures: v14, ZoneAnimalsConfig, effectiveGate, v15, v16, v17, v18
    if v14 then
        return
    end
    v14 = true
    local EggRewards = require(script.Parent.EggRewards)
    local IndexRewards = ZoneAnimalsConfig.IndexRewards
    local SpeedRankGrowth = IndexRewards.SpeedRankGrowth
    local v21 = {}
    local v22 = {}
    for v23, v24 in EggRewards.Pool do
        v15[v24.Name] = v24.Cash
        local SpeedMin = IndexRewards.SpeedMin
        if v24.Zone and v24.ZoneRank and v24.ZoneCount then
            local v25 = (SpeedRankGrowth ^ v24.ZoneCount - 1) / (SpeedRankGrowth - 1)
            local v26 = SpeedRankGrowth ^ (v24.ZoneRank - 1) / v25
            local SpeedMin_2 = IndexRewards.SpeedMin
            local Zone = v24.Zone
            local IndexRewards_2 = ZoneAnimalsConfig.IndexRewards
            local Zones = require(script.Parent.ZonesConfig).Zones
            local v27
            if Zones[Zone + 1] then
                v27 = effectiveGate(Zones, Zone + 1)
            else
                v27 = effectiveGate(Zones, Zone) * IndexRewards_2.SpeedFinalZoneStep
            end
            local v28 = v27 * IndexRewards_2.SpeedZoneShare * v26
            local v29
            if v28 <= 0 then
                v29 = 0
            else
                local v30 = math.log10(v28)
                local v31 = 10 ^ (math.floor(v30) - 1)
                local v32 = v28 / v31 + 0.5
                v29 = math.floor(v32) * v31
            end
            SpeedMin = math.max(SpeedMin_2, v29)
        end
        v16[v24.Name] = SpeedMin
        v21[v24.Rarity] = v21[v24.Rarity] or {}
        local v33 = v21[v24.Rarity]
        local Cash = v24.Cash
        table.insert(v33, Cash)
        v22[v24.Rarity] = v22[v24.Rarity] or {}
        local v34 = v22[v24.Rarity]
        table.insert(v34, SpeedMin)
    end
    for v35, v36 in v21 do
        table.sort(v36)
        local v37 = #v36 / 2
        v17[v35] = v36[math.ceil(v37)]
    end
    for v38, v39 in v22 do
        table.sort(v39)
        local v40 = #v39 / 2
        v18[v38] = v39[math.ceil(v40)]
    end
end

function v1.Reward(v41, v42) -- line 192 | captures: ZoneAnimalsConfig, v15, v16, v17, v18, buildPoolMaps
    buildPoolMaps()
    local IndexRewards = ZoneAnimalsConfig.IndexRewards
    local v43, v44
    if v42 then
        v43 = v15[v42] or v17[v41] or 0
        v44 = v16[v42] or v18[v41] or IndexRewards.SpeedMin
    else
        v43 = v17[v41] or 0
        v44 = v18[v41] or IndexRewards.SpeedMin
    end
    return {
        Cash = v43 * IndexRewards.CashMult,
        Speed = v44
    }
end

return v1
