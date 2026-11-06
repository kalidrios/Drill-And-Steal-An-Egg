-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local FormatNumber = require(script.Parent.FormatNumber)
local v1 = {
    LuckSpread = 6,
    SizeExponent = 2.5,
    CounterMinSweep = 3,
    Zones = {
        { LuckMult = 1 },
        { LuckMult = 8 },
        { LuckMult = 75 },
        { LuckMult = 1000 },
        { LuckMult = 25000 },
        { LuckMult = 1000000 },
        { LuckMult = 25000000 },
        { LuckMult = 500000000 },
        { LuckMult = 10000000000 },
        { LuckMult = 200000000000 }
    }
}

function v1.ZoneIndexOf(v2) -- line 76 | captures: v1
    local v3 = v2 and v2:GetAttribute("ZoneIndex")
    if typeof(v3) == "number" then
        local v4 = math.floor(v3)
        local v5 = #v1.Zones
        return (math.clamp(v4, 1, v5))
    end
    return 1
end

function v1.Luck(v6, v7, v8) -- line 86 | captures: v1
    local Zones = v1.Zones
    local v9 = v8 or 1
    local v10 = #v1.Zones
    local v11 = Zones[math.clamp(v9, 1, v10)]
    return (1 + ((v6 or 1) - 1) * v1.LuckSpread) * (v7 or 1) ^ v1.SizeExponent * v11.LuckMult
end

function v1.FormatLuck(v12, v13, v14) -- line 94 | captures: v1
    return v1.FormatLuckValue(v1.Luck(v12, v13, v14))
end

function v1.FormatLuckValue(v15) -- line 101 | captures: FormatNumber
    return (("x%* Luck"):format((FormatNumber.Short(v15, 2))))
end

function v1.LuckCountRange(v16, v17, v18, v19) -- line 113 | captures: v1
    local v20 = v1.Luck(v16, v17 * v18, v19)
    local v21 = v1.Luck(v16, v17, v19)
    local v22 = if v21 > 0 then v20 / v21 else v1.CounterMinSweep
    local CounterMinSweep = v1.CounterMinSweep
    local v23 = math.max(v22, CounterMinSweep)
    return v20 / v23, v23
end

return v1
