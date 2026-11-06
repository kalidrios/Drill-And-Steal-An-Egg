-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    ToolName = "Pickaxe",
    TemplatesFolderName = "Pickaxes",
    DefaultTier = 1,
    DisplayFolderName = "PickaxeDisplays",
    SwingCooldown = 0.5,
    Tiers = {
        {
            Name = "Wooden Pickaxe",
            Template = "1: Wooden Pickaxe",
            Rarity = "Common",
            Damage = 1,
            Price = 0,
            DevProductId = 3712394657
        },
        {
            Name = "Stone Pickaxe",
            Template = "2: Stone Pickaxe",
            Rarity = "Common",
            Damage = 4,
            Price = 80,
            DevProductId = 3712394693
        },
        {
            Name = "Iron Pickaxe",
            Template = "3: Iron Pickaxe",
            Rarity = "Uncommon",
            Damage = 15,
            Price = 800,
            DevProductId = 3712394722
        },
        {
            Name = "Golden Pickaxe",
            Template = "4: Golden Pickaxe",
            Rarity = "Uncommon",
            Damage = 60,
            Price = 20000,
            DevProductId = 3712394822
        },
        {
            Name = "Diamond Pickaxe",
            Template = "5: Diamond Pickaxe",
            Rarity = "Rare",
            Damage = 250,
            Price = 160000,
            DevProductId = 3712394867
        },
        {
            Name = "Strawberry Pickaxe",
            Template = "6: Strawberry Pickaxe",
            Rarity = "Rare",
            Damage = 1000,
            Price = 1200000,
            DevProductId = 3712394907
        },
        {
            Name = "Cactus Pickaxe",
            Template = "7: Cactus Pickaxe",
            Rarity = "Epic",
            Damage = 4000,
            Price = 6000000,
            DevProductId = 3712394966
        },
        {
            Name = "Lightning Pickaxe",
            Template = "8: Lightning Pickaxe",
            Rarity = "Legendary",
            Damage = 15000,
            Price = 40000000,
            DevProductId = 3712395029
        },
        {
            Name = "Candy Pickaxe",
            Template = "9: Candy Pickaxe",
            Rarity = "Mythic",
            Damage = 60000,
            Price = 400000000,
            DevProductId = 3712395053
        },
        {
            Name = "Rainbow Pickaxe",
            Template = "10: Rainbow Pickaxe",
            Rarity = "Mythic",
            Damage = 250000,
            Price = 2800000000,
            DevProductId = 3712395085
        },
        {
            Name = "Crystal Pickaxe",
            Template = "11: Crystal Pickaxe",
            Rarity = "Divine",
            Damage = 1000000,
            Price = 20000000000,
            DevProductId = 3712803837
        },
        {
            Name = "Demon Pickaxe",
            Template = "12: Demon Pickaxe",
            Rarity = "Divine",
            Damage = 4000000,
            Price = 120000000000,
            DevProductId = 3712803918
        },
        {
            Name = "Hacker Pickaxe",
            Template = "13: Hacker Pickaxe",
            Rarity = "Cosmic",
            Damage = 15000000,
            Price = 1200000000000,
            DevProductId = 3712803943
        },
        {
            Name = "Ufo Pickaxe",
            Template = "14: Ufo Pickaxe",
            Rarity = "Cosmic",
            Damage = 60000000,
            Price = 12000000000000,
            DevProductId = 3712803963
        },
        {
            Name = "Secret Pickaxe",
            Template = "15: Secret Pickaxe",
            Rarity = "Secret",
            Damage = 250000000,
            Price = 80000000000000,
            DevProductId = 3712803986
        },
        {
            Name = "Cool Pickaxe",
            Template = "16: Cool Pickaxe",
            Rarity = "Secret",
            Damage = 1000000000,
            Price = 600000000000000,
            DevProductId = 3713309298
        },
        {
            Name = "Galaxy Pickaxe",
            Template = "17: Galaxy Pickaxe",
            Rarity = "Celestial",
            Damage = 5000000000,
            Price = 4000000000000000,
            DevProductId = 3713309328
        },
        {
            Name = "Celestial Pickaxe",
            Template = "18: Celestial Pickaxe",
            Rarity = "Celestial",
            Damage = 25000000000,
            Price = 20000000000000000,
            DevProductId = 3713309347
        },
        {
            Name = "Sci Fi Pickaxe",
            Template = "19: Sci Fi Pickaxe",
            Rarity = "Void",
            Damage = 75000000000,
            Price = 75000000000000000,
            DevProductId = 3717812196
        },
        {
            Name = "Enchanted Pickaxe",
            Template = "20: Enchanted Pickaxe",
            Rarity = "Omega",
            Damage = 250000000000,
            Price = 200000000000000000,
            DevProductId = 3717812231
        }
    },
    Hitbox = {
        Padding = 0.75,
        SweepDuration = 0.45,
        WhiffAssistFacingDot = 0
    }
}

function v1.ClampTier(v2) -- line 122 | captures: v1
    if not (typeof(v2) == "number" and v2 == v2) then
        return v1.DefaultTier
    end
    local v3 = math.floor(v2)
    local v4 = #v1.Tiers
    return (math.clamp(v3, 1, v4))
end

function v1.GetTier(v5) -- line 129 | captures: v1
    return v1.Tiers[v1.ClampTier(v5)]
end

function v1.GetDamage(v6) -- line 134 | captures: v1
    return v1.GetTier(v6).Damage
end

function v1.GetPrice(v7) -- line 139 | captures: v1
    return v1.GetTier(v7).Price or 0
end

function v1.GetProductId(v8) -- line 145 | captures: v1
    return v1.GetTier(v8).DevProductId
end

function v1.GetIcon(v9) -- line 153 | captures: v1
    local v10 = v1.GetTier(v9)
    local Icon = v10.Icon
    if typeof(Icon) ~= "string" or v10.Icon == "" then
        local v11 = game:GetService("ReplicatedStorage"):FindFirstChild(v1.TemplatesFolderName)
        local v12 = v11 and v11:FindFirstChild(v10.Template)
        if v12 and v12:IsA("Tool") then
            return v12.TextureId
        end
        return ""
    end
    return v10.Icon
end

function v1.TierForProduct(v13) -- line 164 | captures: v1
    for v14, v15 in v1.Tiers do
        if v15.DevProductId == v13 then
            return v14
        end
    end
    return nil
end

return v1
