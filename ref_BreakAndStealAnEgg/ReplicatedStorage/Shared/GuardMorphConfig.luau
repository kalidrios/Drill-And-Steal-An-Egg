-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    Guards = {
        {
            Key = "chicken",
            ZoneId = "Zone1",
            DisplayName = "Chicken",
            Aliases = { "chick" }
        },
        {
            Key = "sphinx",
            ZoneId = "Zone2",
            DisplayName = "Sphinx",
            Aliases = {}
        },
        {
            Key = "yeti",
            ZoneId = "Zone3",
            DisplayName = "Ice Yeti",
            Aliases = { "iceyeti" }
        },
        {
            Key = "serpent",
            ZoneId = "Zone4",
            DisplayName = "Emerald Serpent",
            Aliases = { "emeraldserpent", "snake" }
        },
        {
            Key = "mammoth",
            ZoneId = "Zone5",
            DisplayName = "Woolly Mammoth",
            Aliases = { "woollymammoth" }
        },
        {
            Key = "crab",
            ZoneId = "Zone6",
            DisplayName = "Redshell Crab",
            Aliases = { "redshellcrab" }
        },
        {
            Key = "mole",
            ZoneId = "Zone7",
            DisplayName = "Mole Titan",
            Aliases = { "moletitan", "titan" }
        },
        {
            Key = "griffin",
            ZoneId = "Zone8",
            DisplayName = "Griffin",
            Aliases = { "gryphon" }
        },
        {
            Key = "hydra",
            ZoneId = "Zone9",
            DisplayName = "3-Headed Hydra",
            Aliases = { "3hydra" }
        },
        {
            Key = "alien",
            ZoneId = "Zone10",
            DisplayName = "Alien Guardian",
            Aliases = { "alienguardian", "guardian", "planetx" }
        }
    },
    Tag = "GuardMorph",
    PlayerAttribute = "GuardMorph",
    CharacterAttribute = "GuardMorph",
    OwnerAttribute = "MorphOwnerUserId",
    ZoneAttribute = "MorphZoneId",
    HeadAttribute = "MorphHeadOffset",
    SizeAttribute = "MorphSize",
    RemoteName = "GuardMorphRemote",
    FolderName = "GuardMorphs",
    WeldName = "GuardMorphWeld",
    HeadHeightFraction = 0.85,
    HeadForwardFraction = 0.8,
    ClipRateAtFullSpeed = 3,
    MinWalkSpeed = 40,
    JumpHeight = 14,
    TurnResponsiveness = 6,
    AnimateDelay = 0.5,
    TouchInterval = 0.05,
    TouchPadding = 1.5,
    HitCooldown = 2,
    DropCarriedOnHit = true,
    FlingOtherMorphs = false,
    RoarKey = Enum.KeyCode.R,
    RoarGamepadKey = Enum.KeyCode.ButtonY,
    RoarCooldown = 2.5,
    RoarShakeRadius = 120,
    CameraSubjectHeight = 1.5,
    ZoomPerSize = 1.1,
    MinZoom = 20,
    MaxZoom = 110,
    Shakes = {
        Victim = { 7, 12, 0.05, 0.9 },
        HitOwner = { 2.5, 10, 0.05, 0.4 },
        Roar = { 4, 8, 0.1, 1.2 },
        Landing = { 3, 12, 0.02, 0.45 }
    },
    LandingMinFallSpeed = 35
}

local function normalize(v2) -- line 141
    return (string.gsub(string.lower(v2), "[%s%-_]", ""))
end

function v1.Resolve(v3) -- line 147 | captures: v1
    if v3 ~= nil and v3 ~= "" then
        local v4 = string.gsub(string.lower(v3), "[%s%-_]", "")
        for v5, v6 in v1.Guards do
            if v4 == v6.Key then
                return v6
            end
            local ZoneId = v6.ZoneId
            if v4 == string.gsub(string.lower(ZoneId), "[%s%-_]", "") then
                return v6
            end
            if v4 == tostring(v5) then
                return v6
            end
            for v7, v8 in v6.Aliases do
                if v4 == v8 then
                    return v6
                end
            end
        end
        for v9, v10 in v1.Guards do
            local Key = v10.Key
            local v11 = #v4
            if string.sub(Key, 1, v11) == v4 then
                return v10
            end
            for v12, v13 in v10.Aliases do
                local v14 = #v4
                if string.sub(v13, 1, v14) == v4 then
                    return v10
                end
            end
        end
    end
    return nil
end

function v1.Keys() -- line 177 | captures: v1
    local v15 = {}
    for v16, v17 in v1.Guards do
        local Key = v17.Key
        table.insert(v15, Key)
    end
    return v15
end

return v1
