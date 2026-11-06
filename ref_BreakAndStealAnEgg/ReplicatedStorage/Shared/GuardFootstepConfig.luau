-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    SoundGroupName = "SFX",
    MasterVolume = 0.6,
    Jitter = 0.06,
    MinStepGap = 0.18,
    StepMaxDuration = 0.6,
    StopFadeTime = 0.08,
    RollOffMode = Enum.RollOffMode.InverseTapered,
    WalkKeywords = { "walk", "run", "swim" },
    Guards = {
        Zone10 = {
            Boss = "AlienGuardian",
            Range = 70,
            MinDistance = 12,
            StrideLength = 12,
            MinSpeed = 2,
            Layers = {
                {
                    Id = 9118243695,
                    Volume = 0.7,
                    Speed = 0.9
                },
                {
                    Id = 9118240078,
                    Volume = 0.35,
                    Speed = 0.8,
                    MaxDuration = 0.45
                },
                {
                    Id = 9118353503,
                    Volume = 0.18,
                    Speed = 1.1,
                    MaxDuration = 0.35,
                    EveryOther = true
                }
            }
        }
    }
}

function v1.Get(v2) -- line 88 | captures: v1
    return v2 and v1.Guards[v2] or nil
end

return v1
