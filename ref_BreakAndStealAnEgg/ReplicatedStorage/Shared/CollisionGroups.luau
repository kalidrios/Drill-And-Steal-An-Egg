-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    Animals = "Animals",
    Players = "Players"
}

v1.Registered = {
    v1.Animals,
    v1.Players
}
v1.Disabled = {
    {
        v1.Animals,
        v1.Animals
    },
    {
        v1.Animals,
        v1.Players
    },
    {
        v1.Players,
        v1.Players
    }
}
return v1
