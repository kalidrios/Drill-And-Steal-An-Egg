-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    DefaultLevel = 1,
    MaxLevel = 9,
    BaseCapacity = 8,
    CapacityPerLevel = 1,
    ModelsFolderName = "PlotUpgrades",
    ModelPrefix = "PlotUpgrade_",
    Costs = { 10000, 1000000, 45000000, 1700000000, 60000000000, 2200000000000, 50000000000000, 150000000000000 }
}

function v1.ClampLevel(v2) -- line 40 | captures: v1
    if not (typeof(v2) == "number" and v2 == v2) then
        return v1.DefaultLevel
    end
    local v3 = math.floor(v2)
    local MaxLevel = v1.MaxLevel
    return (math.clamp(v3, 1, MaxLevel))
end

function v1.Capacity(v4) -- line 48 | captures: v1
    local v5 = v1.ClampLevel(v4)
    return v1.BaseCapacity + (v5 - 1) * v1.CapacityPerLevel
end

function v1.UpgradeCost(v6) -- line 54 | captures: v1
    local v7 = v1.ClampLevel(v6)
    if v1.MaxLevel <= v7 then
        return nil
    end
    return v1.Costs[v7]
end

function v1.ModelForLevel(v8) -- line 64 | captures: v1
    local v9 = v1.ClampLevel(v8)
    if v9 <= 1 then
        return nil
    end
    return v1.ModelPrefix .. v9 - 1
end

return v1
