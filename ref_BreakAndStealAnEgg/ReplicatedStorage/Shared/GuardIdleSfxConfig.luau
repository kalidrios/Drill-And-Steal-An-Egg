-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    SoundGroupName = "SFX",
    MasterVolume = 0.6,
    Jitter = 0.06,
    CalmStates = {
        Idle = true,
        Roaming = true,
        Returning = true
    },
    ChirpMaxDuration = 1.6,
    HumFadeTime = 0.6,
    StopFadeTime = 0.1,
    RollOffMode = Enum.RollOffMode.InverseTapered,
    Guards = {
        Zone10 = {
            Boss = "AlienGuardian",
            Range = 70,
            MinDistance = 12,
            ChirpMin = 5,
            ChirpMax = 10,
            Hum = {
                Id = 9125674129,
                Volume = 0.25,
                Speed = 0.9
            },
            Chirps = {
                {
                    Id = 9118493540,
                    Volume = 0.45,
                    Speed = 0.9
                },
                {
                    Id = 9125846068,
                    Volume = 0.4,
                    Speed = 0.85
                },
                {
                    Id = 9119914764,
                    Volume = 0.45,
                    Speed = 0.95
                },
                {
                    Id = 9118484986,
                    Volume = 0.4,
                    Speed = 0.9
                },
                {
                    Id = 9118353779,
                    Volume = 0.3,
                    Speed = 1,
                    MaxDuration = 0.8
                }
            }
        }
    }
}

function v1.Get(v2) -- line 94 | captures: v1
    return v2 and v1.Guards[v2] or nil
end

return v1
