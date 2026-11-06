-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    EquippedAttribute = "EquippedTrail",
    OwnedAttribute = "OwnedTrails",
    DefaultMultiplier = 1,
    FolderName = "Trails",
    Trails = {
        {
            Id = 1,
            Name = "White Trail",
            ModelName = "Gray_Trail",
            Rarity = "Common",
            Multiplier = 2,
            Price = 500,
            DevProductId = 3714147430,
            Icon = "rbxassetid://113308886520258",
            Colors = {
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(185, 185, 195)
            }
        },
        {
            Id = 2,
            Name = "Blue Trail",
            ModelName = "Blue_Trail",
            Rarity = "Rare",
            Multiplier = 4,
            Price = 7500,
            DevProductId = 3714147451,
            Icon = "rbxassetid://70782082472965",
            Colors = {
                Color3.fromRGB(110, 170, 255),
                Color3.fromRGB(0, 60, 255)
            }
        },
        {
            Id = 3,
            Name = "Green Trail",
            ModelName = "Green_Trail",
            Rarity = "Uncommon",
            Multiplier = 8,
            Price = 100000,
            DevProductId = 3714147473,
            Icon = "rbxassetid://125670927750511",
            Colors = {
                Color3.fromRGB(150, 255, 140),
                Color3.fromRGB(0, 200, 20)
            }
        },
        {
            Id = 4,
            Name = "Purple Trail",
            ModelName = "Purple_Trail",
            Rarity = "Epic",
            Multiplier = 16,
            Price = 1250000,
            DevProductId = 3714147489,
            Icon = "rbxassetid://103823952124472",
            Colors = {
                Color3.fromRGB(205, 130, 255),
                Color3.fromRGB(130, 30, 200)
            }
        },
        {
            Id = 5,
            Name = "Red Trail",
            ModelName = "Red_Trail",
            Rarity = "Legendary",
            Multiplier = 40,
            Price = 17500000,
            DevProductId = 3714147504,
            Icon = "rbxassetid://102765655625297",
            Colors = {
                Color3.fromRGB(235, 80, 80),
                Color3.fromRGB(151, 0, 0)
            }
        },
        {
            Id = 6,
            Name = "Golden Trail",
            ModelName = "Golden_Trail",
            Rarity = "Legendary",
            Multiplier = 100,
            Price = 250000000,
            DevProductId = 3714147529,
            Icon = "rbxassetid://92532152307618",
            Colors = {
                Color3.fromRGB(255, 214, 110),
                Color3.fromRGB(218, 133, 65)
            }
        },
        {
            Id = 7,
            Name = "Rainbow Trail",
            ModelName = "Rainbow_Trail",
            Rarity = "Mythic",
            Multiplier = 250,
            Price = 3500000000,
            DevProductId = 3714147550,
            Icon = "rbxassetid://77190151325861",
            Colors = {
                Color3.fromRGB(255, 96, 120),
                Color3.fromRGB(156, 117, 255)
            }
        },
        {
            Id = 8,
            Name = "Galactic Trail",
            ModelName = "Galaxy_Trail",
            Rarity = "Cosmic",
            Multiplier = 600,
            Price = 45000000000,
            DevProductId = 3714147575,
            Icon = "rbxassetid://76694816815751",
            Colors = {
                Color3.fromRGB(120, 90, 255),
                Color3.fromRGB(170, 0, 170)
            }
        },
        {
            Id = 9,
            Name = "Secret Trail",
            ModelName = "Secret_Trail",
            Rarity = "Secret",
            Multiplier = 1500,
            Price = 600000000000,
            DevProductId = 3714147628,
            Icon = "rbxassetid://98543574502750",
            Colors = {
                Color3.fromRGB(95, 95, 105),
                Color3.fromRGB(20, 20, 25)
            }
        },
        {
            Id = 10,
            Name = "Laser Trail",
            ModelName = "Laser_Trail",
            Rarity = "Celestial",
            Multiplier = 4000,
            Price = 8000000000000,
            DevProductId = 3714147674,
            Icon = "rbxassetid://110493903459840",
            Colors = {
                Color3.fromRGB(255, 120, 120),
                Color3.fromRGB(255, 0, 0)
            }
        },
        {
            Id = 11,
            Name = "Moonlight Trail",
            ModelName = "Moonlight_Trail",
            Rarity = "Celestial",
            Multiplier = 10000,
            Price = 100000000000000,
            DevProductId = 3714147688,
            Icon = "rbxassetid://100460924685514",
            Colors = {
                Color3.fromRGB(205, 225, 255),
                Color3.fromRGB(110, 150, 230)
            }
        }
    }
}
local v2 = {}
for v3, v4 in v1.Trails do
    v2[v4.Id] = v4
end

function v1.Get(v5) -- line 112 | captures: v2
    if typeof(v5) == "number" then
        return v2[v5]
    end
    return nil
end

function v1.ClampEquipped(v6) -- line 120 | captures: v2
    if not (typeof(v6) == "number" and v6 == v6) then
        return 0
    end
    local v7 = math.floor(v6)
    if v2[v7] == nil then
        return 0
    end
    return v7
end

function v1.BestAffordable(v8) -- line 136 | captures: v1
    local v9
    for v10, v11 in v1.Trails do
        if v11.Price <= v8 then
            if v9 == nil then
                v9 = v11
            else
                local Price = v11.Price
                if v9.Price < Price then
                    v9 = v11
                end
            end
        end
    end
    return v9
end

function v1.MultiplierFor(v12) -- line 147 | captures: v1
    local v13 = v1.Get(v12)
    if v13 then
        return v13.Multiplier
    end
    return v1.DefaultMultiplier
end

return v1
