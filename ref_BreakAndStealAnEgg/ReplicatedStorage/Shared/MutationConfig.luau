-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    Enabled = false,
    Attribute = "Mutation",
    Mutations = {
        {
            Name = "Rainbow",
            OneIn = 2000,
            CashMult = 25,
            Color = Color3.fromRGB(255, 120, 255)
        },
        {
            Name = "Radioactive",
            OneIn = 750,
            CashMult = 12,
            Color = Color3.fromRGB(120, 255, 90)
        },
        {
            Name = "Diamond",
            OneIn = 300,
            CashMult = 6,
            RequiresVariant = "Diamond",
            Color = Color3.fromRGB(130, 220, 255)
        },
        {
            Name = "Golden",
            OneIn = 100,
            CashMult = 3.5,
            RequiresVariant = "Gold",
            Color = Color3.fromRGB(255, 196, 54)
        },
        {
            Name = "Shiny",
            OneIn = 30,
            CashMult = 2,
            Color = Color3.fromRGB(210, 240, 255)
        }
    }
}

function v1.Get(v2) -- line 57 | captures: v1
    if v1.Enabled and v2 then
        for v3, v4 in v1.Mutations do
            if v4.Name == v2 then
                return v4
            end
        end
    end
    return nil
end

function v1.CashMult(v5) -- line 70 | captures: v1
    local v6 = v1.Get(v5)
    return v6 and v6.CashMult or 1
end

function v1.Roll(v7, v8) -- line 80 | captures: v1
    if v1.Enabled then
        for v9, v10 in v1.Mutations do
            if (v10.RequiresVariant == nil or v10.RequiresVariant == v8) and v7:NextInteger(1, v10.OneIn) == 1 then
                return v10.Name
            end
        end
    end
    return nil
end

function v1.PrefixName(v11, v12) -- line 96 | captures: v1
    if v1.Get(v11) then
        return (("%* %*"):format(v11, v12))
    end
    return v12
end

return v1
