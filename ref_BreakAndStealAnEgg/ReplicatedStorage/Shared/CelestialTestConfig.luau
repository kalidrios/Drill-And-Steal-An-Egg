-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    Animals = { "CelestialAxolotl", "CelestialFrog", "CelestialLamb", "CelestialSpiritFox", "CelestialGorilla" },
    MaxGiveEach = 25,
    KgMultMin = 0.5,
    KgMultMax = 8
}
local v2 = Random.new()

function v1.RollKgMult() -- line 40 | captures: v1, v2
    local KgMultMin = v1.KgMultMin
    local v3 = math.log(KgMultMin)
    local KgMultMax = v1.KgMultMax
    local v4 = math.log(KgMultMax)
    local v5 = v2:NextNumber(v3, v4)
    return (math.exp(v5))
end

function v1.IsCelestial(v6) -- line 47 | captures: v1
    return table.find(v1.Animals, v6) ~= nil
end

return v1
