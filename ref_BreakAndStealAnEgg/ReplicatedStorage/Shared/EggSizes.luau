-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local EggConfig = require(script.Parent.EggConfig)

local function buildCurve(v1) -- line 54
    local v2 = 1 - v1.BigChance
    local v3 = v1.TailExponent or 1
    local v4 = (1 / (v1.MaxOneIn * v1.BigChance)) ^ (1 / (v1.MaxMult - 1) ^ v3)
    local v5 = v1.MinMult < 1
    local v6
    if v5 then
        local v7 = 1 / (v1.MinOneIn * v2)
        local v8 = math.log(v7)
        local MinMult = v1.MinMult
        v6 = v8 / math.log(MinMult)
    else
        v6 = 0
    end
    local v9 = v4 < 1
    assert(v9, "[EggSizes] MaxOneIn * BigChance must be > 1 so bigger rolls are rarer")
    local v10 = not v5 or v6 > 0
    assert(v10, "[EggSizes] MinOneIn * (1 - BigChance) must be > 1 so smaller rolls are rarer")
    local v11 = 10 ^ v1.Decimals

    local function bendFor(v12) -- line 88 | captures: v1
        local LuckBend = v1.LuckBend
        if LuckBend and v12 and not (v12 <= 1) then
            return 1 + math.log(v12) * LuckBend
        end
        return 1
    end

    local v13 = {}

    function v13.ChanceAtLeast(v14, v15) -- line 100 | captures: v1, v3, v4, v13
        if v14 < 1 then
            return 1 - v13.ChanceAtMost(v14, v15)
        end
        local BigChance = v1.BigChance
        local v16 = v14 - 1
        local LuckBend = v1.LuckBend
        local v17 = if LuckBend and v15 and not (v15 <= 1) then 1 + math.log(v15) * LuckBend else 1
        return BigChance * v4 ^ (v16 / v17) ^ v3
    end

    local v18 = v6

    function v13.ChanceAtMost(v19, v20) -- line 112 | captures: v1, v2, v5, v13, v18
        if v19 >= 1 then
            return 1 - v13.ChanceAtLeast(v19, v20)
        end
        if not v5 or v19 < v1.MinMult then
            return 0
        end
        return v2 * v19 ^ v18
    end

    function v13.OneIn(v21, v22) -- line 123 | captures: v13
        local v23
        if v21 >= 1 then
            v23 = v13.ChanceAtLeast(v21, v22)
        else
            v23 = v13.ChanceAtMost(v21, v22)
        end
        if v23 <= 0 then
            return (1/0)
        end
        local v24 = 1 / v23 + 0.5
        local v25 = math.floor(v24)
        return (math.max(v25, 1))
    end

    function v13.Roll(v26, v27) -- line 132 | captures: v1, v3, v4, v5, v11, v18
        local v28 = v26:NextNumber()
        local v29
        if v26:NextNumber() < v1.BigChance then
            local LuckBend = v1.LuckBend
            local v30
            if LuckBend and v27 then
                if v27 <= 1 then
                    v30 = 1
                else
                    v30 = 1 + math.log(v27) * LuckBend
                end
            else
                v30 = 1
            end
            v29 = 1 + v30 * (math.log(v28) / math.log(v4)) ^ (1 / v3)
        elseif v5 then
            local v31 = v28 ^ (1 / v18)
            local MinMult = v1.MinMult
            v29 = math.max(v31, MinMult)
        else
            v29 = 1
        end
        local v32 = v29 * v11 + 0.5
        return math.floor(v32) / v11
    end

    return v13
end

local v33 = {
    Spawn = buildCurve(EggConfig.Size.Spawn),
    Hatch = buildCurve(EggConfig.Size.Hatch)
}
local v34 = {}

local function withMaxMult(v35, v36) -- line 179
    if not v36 or v36 == v35.MaxMult then
        return v35
    end
    local v37 = table.clone(v35)
    v37.MaxMult = v36
    return v37
end

function v33.ForZone(v38) -- line 188 | captures: EggConfig, buildCurve, v33, v34
    local v39 = if v38 then (EggConfig.Size.ZoneCaps or {})[v38] else nil
    if v39 then
        local v40 = v34[v38]
        if v40 then
            return v40
        end
        local v41 = {}
        local Spawn = EggConfig.Size.Spawn
        local SpawnMax = v39.SpawnMax
        if SpawnMax and SpawnMax ~= Spawn.MaxMult then
            Spawn = table.clone(Spawn)
            Spawn.MaxMult = SpawnMax
        end
        v41.Spawn = buildCurve(Spawn)
        local Hatch = EggConfig.Size.Hatch
        local HatchMax = v39.HatchMax
        if HatchMax and HatchMax ~= Hatch.MaxMult then
            Hatch = table.clone(Hatch)
            Hatch.MaxMult = HatchMax
        end
        v41.Hatch = buildCurve(Hatch)
        v34[v38] = v41
        return v41
    end
    return v33
end

function v33.AnimalWeightLuck(v42, v43) -- line 210 | captures: EggConfig
    local AnimalWeightLuck = EggConfig.Size.AnimalWeightLuck
    if AnimalWeightLuck and v42 and v43 and not (v42 <= 0) and not (v43 <= 0) then
        local v44 = (v42 / v43) ^ (AnimalWeightLuck.Exponent or 1)
        local v45 = AnimalWeightLuck.MaxLuck or (1/0)
        return (math.clamp(v44, 1, v45))
    end
    return 1
end

local function bracketChance(v46, v47) -- line 222 | captures: EggConfig
    local v48 = if v47 then (EggConfig.Size.ZoneBracketMults or {})[v47] else nil
    local v49 = v48 and v48[v46.Label]
    if v49 then
        return v46.Chance * v49
    end
    return v46.Chance
end

function v33.BracketForChance(v50, v51) -- line 237 | captures: EggConfig
    for v52, v53 in EggConfig.Size.Brackets do
        local v54 = if v51 then (EggConfig.Size.ZoneBracketMults or {})[v51] else nil
        local v55 = v54 and v54[v53.Label]
        local v56 = if v55 then v53.Chance * v55 else v53.Chance
        if v50 <= v56 then
            return v53.Label
        end
    end
    return ""
end

function v33.Bracket(v57, v58) -- line 247 | captures: v33
    return v33.BracketForChance(v33.ForZone(v58).Hatch.ChanceAtLeast(v57), v58)
end

function v33.MinHatchForChance(v59, v60) -- line 258 | captures: EggConfig
    for v61, v62 in EggConfig.Size.Brackets do
        local v63 = if v60 then (EggConfig.Size.ZoneBracketMults or {})[v60] else nil
        local v64 = v63 and v63[v62.Label]
        local v65 = if v64 then v62.Chance * v64 else v62.Chance
        if v59 <= v65 then
            return v62.MinHatchMult or 1
        end
    end
    return 1
end

return v33
