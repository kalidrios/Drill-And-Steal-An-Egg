-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Workspace = game:GetService("Workspace")
local v1 = {
    ReadyAtAttribute = "ReadyAtServerTime",
    RateAttribute = "GrowthRate",
    BoostEndsAtAttribute = "GrowthBoostEndsAt",
    BaseRateAttribute = "GrowthBaseRate"
}

local function boostLeft(v2, v3, v4) -- line 37
    if v3 and not (v3 <= 1) and v4 then
        local v5 = v4 - v2
        return (math.max(v5, 0))
    end
    return 0
end

local function baseOf(v6) -- line 44
    if not (v6 and v6 > 1) then
        return 1
    end
    return v6
end

local function PredictReadyAt(v7, v8, v9, v10, v11) -- line 50
    local v12
    if v9 and not (v9 <= 1) and v10 then
        local v13 = v10 - v7
        v12 = math.max(v13, 0)
    else
        v12 = 0
    end
    local v14 = v9 or 1
    local v15 = if not (v11 and v11 > 1) then 1 else v11
    if v12 <= 0 then
        return v7 + v8 / v15
    end
    if v8 <= v12 * v14 then
        return v7 + v8 / v14
    end
    return v7 + v12 + (v8 - v12 * v14) / v15
end

v1.PredictReadyAt = PredictReadyAt

local function RemainingAt(v16, v17, v18, v19, v20) -- line 64
    local v21 = v17 - v16
    local v22 = math.max(v21, 0)
    local v23
    if v18 and not (v18 <= 1) and v19 then
        local v24 = v19 - v16
        v23 = math.max(v24, 0)
    else
        v23 = 0
    end
    local v25 = v18 or 1
    local v26 = if not (v20 and v20 > 1) then 1 else v20
    if v23 <= 0 then
        return v22 * v26
    end
    if v22 <= v23 then
        return v22 * v25
    end
    return v23 * v25 + (v22 - v23) * v26
end

v1.RemainingAt = RemainingAt

local function numberAttribute(v27, v28) -- line 78
    local v29 = v27:GetAttribute(v28)
    if typeof(v29) == "number" then
        return v29
    end
    return nil
end

function v1.RateOf(v30) -- line 85 | captures: Workspace, v1
    local v31 = v30:GetAttribute(v1.RateAttribute)
    if typeof(v31) ~= "number" then
        v31 = nil
    end
    local v32 = v30:GetAttribute(v1.BoostEndsAtAttribute)
    if typeof(v32) ~= "number" then
        v32 = nil
    end
    if v31 and v31 > 1 and v32 and Workspace:GetServerTimeNow() < v32 then
        return v31
    end
    local v33 = v30:GetAttribute(v1.BaseRateAttribute)
    if typeof(v33) ~= "number" then
        v33 = nil
    end
    if not (v33 and v33 > 1) then
        return 1
    end
    return v33
end

function v1.RemainingOf(v34) -- line 95 | captures: Workspace, v1
    local v35 = v34:GetAttribute(v1.ReadyAtAttribute)
    if typeof(v35) ~= "number" then
        v35 = nil
    end
    if v35 then
        local RemainingAt = v1.RemainingAt
        local v36 = Workspace:GetServerTimeNow()
        local v37 = v34:GetAttribute(v1.RateAttribute)
        if typeof(v37) ~= "number" then
            v37 = nil
        end
        local v38 = v34:GetAttribute(v1.BoostEndsAtAttribute)
        if typeof(v38) ~= "number" then
            v38 = nil
        end
        local v39 = v34:GetAttribute(v1.BaseRateAttribute)
        if typeof(v39) ~= "number" then
            v39 = nil
        end
        return RemainingAt(v36, v35, v37, v38, v39)
    end
    return 0
end

return v1
