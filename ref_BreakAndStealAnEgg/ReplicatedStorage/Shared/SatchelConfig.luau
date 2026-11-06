-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    StationTag = "SatchelUpgrade",
    DefaultTier = 1,
    TierAttribute = "SatchelTier",
    CapacityAttribute = "SatchelCapacity",
    Tiers = {
        {
            Name = "Bare Hands",
            Capacity = 1,
            Price = 0,
            Rarity = "Common"
        },
        {
            Name = "Pouch",
            Capacity = 2,
            Price = 60000,
            Rarity = "Common"
        },
        {
            Name = "Satchel",
            Capacity = 3,
            Price = 10000000,
            Rarity = "Uncommon"
        },
        {
            Name = "Big Satchel",
            Capacity = 4,
            Price = 2000000000,
            Rarity = "Rare"
        },
        {
            Name = "Huge Satchel",
            Capacity = 5,
            Price = 400000000000,
            Rarity = "Epic"
        },
        {
            Name = "Titanic Satchel",
            Capacity = 6,
            Price = 12000000000000,
            Rarity = "Legendary"
        }
    }
}

function v1.ClampTier(v2) -- line 48 | captures: v1
    if not (typeof(v2) == "number" and v2 == v2) then
        return v1.DefaultTier
    end
    local v3 = math.floor(v2)
    local v4 = #v1.Tiers
    return (math.clamp(v3, 1, v4))
end

function v1.GetTier(v5) -- line 55 | captures: v1
    return v1.Tiers[v1.ClampTier(v5)]
end

function v1.CapacityFor(v6) -- line 60 | captures: v1
    return v1.GetTier(v6).Capacity
end

function v1.NextTier(v7) -- line 65 | captures: v1
    local v8 = v1.ClampTier(v7) + 1
    local v9 = v1.Tiers[v8]
    if v9 then
        return v8, v9
    end
    return nil, nil
end

return v1
