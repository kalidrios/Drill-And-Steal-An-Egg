-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    SoundGroupName = "SFX",
    EmitterNames = { "BodyHitbox", "HumanoidRootPart", "Torso" },
    RollOffMode = Enum.RollOffMode.InverseTapered,
    MinDistanceFraction = 0.25,
    MasterVolume = 1.6,
    MaxVolume = 10,
    Jitter = 0.07,
    Cooldown = 0.85,
    ChaseRoarMin = 4.5,
    ChaseRoarMax = 7,
    ChaseVolumeScale = 0.75,
    CatchVolumeScale = 1,
    ScreenVolumeScale = 0.65,
    ScreenFadeHoldTime = 0.35,
    CueMaxDuration = 2,
    StopFadeTime = 0.12,
    Guards = {
        Zone1 = {
            Boss = "Chicken",
            Cry = "KA KOW!!!!!!",
            Range = 80,
            Gain = 0.85,
            Lock = {
                {
                    Id = 118653062220935,
                    Volume = 1,
                    Speed = 1.05,
                    Jitter = 0.05
                },
                {
                    Id = 77584650945481,
                    Volume = 0.55,
                    Speed = 1.15
                }
            },
            Chase = {
                {
                    Id = 77584650945481,
                    Volume = 0.85,
                    Speed = 1.1,
                    Jitter = 0.1
                }
            },
            Catch = {
                {
                    Id = 77584650945481,
                    Volume = 1,
                    Speed = 0.95
                },
                {
                    Id = 118653062220935,
                    Volume = 0.5,
                    Speed = 1.2
                }
            }
        },
        Zone2 = {
            Boss = "Sphinx",
            Cry = "ROAAAR",
            Range = 80,
            Gain = 1.15,
            Lock = {
                {
                    Id = 9125629454,
                    Volume = 1,
                    Speed = 0.96
                },
                {
                    Id = 9116303194,
                    Volume = 0.5,
                    Speed = 0.9
                }
            },
            Chase = {
                {
                    Id = 9116303194,
                    Volume = 0.9,
                    Speed = 1
                }
            },
            Catch = {
                {
                    Id = 9116302511,
                    Volume = 1,
                    Speed = 1.05
                }
            }
        },
        Zone3 = {
            Boss = "IceYeti",
            Cry = "RAAARGH",
            Range = 80,
            Gain = 1.1,
            Lock = {
                {
                    Id = 8158130299,
                    Volume = 1,
                    Speed = 0.95
                },
                {
                    Id = 9114628620,
                    Volume = 0.5,
                    Speed = 0.8
                },
                {
                    Id = 119977062667102,
                    Volume = 0.4,
                    Speed = 0.8
                }
            },
            Chase = {
                {
                    Id = 8158142002,
                    Volume = 0.85,
                    Speed = 1.05,
                    Jitter = 0.1
                }
            },
            Catch = {
                {
                    Id = 8158142400,
                    Volume = 1,
                    Speed = 1.05
                },
                {
                    Id = 9114628620,
                    Volume = 0.5,
                    Speed = 0.95
                }
            }
        },
        Zone4 = {
            Boss = "EmeraldSerpent",
            Cry = "RRAAAWWK-HSSS",
            Range = 80,
            Gain = 1.1,
            Lock = {
                {
                    Id = 6470855561,
                    Volume = 1,
                    Speed = 0.92
                },
                {
                    Id = 9120043128,
                    Volume = 0.6,
                    Speed = 0.85
                },
                {
                    Id = 9114630281,
                    Volume = 0.55,
                    Speed = 0.8
                }
            },
            Chase = {
                {
                    Id = 9120043128,
                    Volume = 0.9,
                    Speed = 0.9
                },
                {
                    Id = 9114630281,
                    Volume = 0.6,
                    Speed = 0.85
                }
            },
            Catch = {
                {
                    Id = 6470855561,
                    Volume = 1,
                    Speed = 1.05
                },
                {
                    Id = 9120043128,
                    Volume = 0.6,
                    Speed = 1
                }
            }
        },
        Zone5 = {
            Boss = "WoollyMammoth",
            Cry = "BRRUUUHHHRRR",
            Range = 80,
            Gain = 1.25,
            Lock = {
                {
                    Id = 899107946,
                    Volume = 1,
                    Speed = 0.9
                },
                {
                    Id = 9114300941,
                    Volume = 0.6,
                    Speed = 0.85
                },
                {
                    Id = 119977062667102,
                    Volume = 0.55,
                    Speed = 0.7
                }
            },
            Chase = {
                {
                    Id = 9114300941,
                    Volume = 0.85,
                    Speed = 1,
                    Jitter = 0.1
                },
                {
                    Id = 9114628620,
                    Volume = 0.5,
                    Speed = 0.8
                }
            },
            Catch = {
                {
                    Id = 899107946,
                    Volume = 1,
                    Speed = 1.05,
                    MaxDuration = 1.2
                },
                {
                    Id = 119977062667102,
                    Volume = 0.5,
                    Speed = 0.8,
                    MaxDuration = 1.2
                }
            }
        },
        Zone6 = {
            Boss = "RedshellCrab",
            Cry = "SSSKREEE-KLK-KLK",
            Range = 80,
            Gain = 1.15,
            Lock = {
                {
                    Id = 122528865379108,
                    Volume = 1,
                    Speed = 0.95
                },
                {
                    Id = 9113958176,
                    Volume = 0.75,
                    Speed = 1
                },
                {
                    Id = 119977062667102,
                    Volume = 0.4,
                    Speed = 0.8
                }
            },
            Chase = {
                {
                    Id = 9113958176,
                    Volume = 0.9,
                    Speed = 1.05,
                    Jitter = 0.1
                },
                {
                    Id = 9120043128,
                    Volume = 0.5,
                    Speed = 1
                }
            },
            Catch = {
                {
                    Id = 122528865379108,
                    Volume = 1,
                    Speed = 1.1,
                    MaxDuration = 1
                },
                {
                    Id = 9113957594,
                    Volume = 0.85,
                    Speed = 1
                }
            }
        },
        Zone7 = {
            Boss = "MoleTitan",
            Cry = "UUOOAAAAARGH",
            Range = 80,
            Gain = 1.25,
            Lock = {
                {
                    Id = 125517277831362,
                    Volume = 1,
                    Speed = 0.92
                },
                {
                    Id = 9114628818,
                    Volume = 0.55,
                    Speed = 0.78
                },
                {
                    Id = 119977062667102,
                    Volume = 0.55,
                    Speed = 0.72
                }
            },
            Chase = {
                {
                    Id = 78764625363408,
                    Volume = 0.8,
                    Speed = 0.95,
                    Jitter = 0.08
                },
                {
                    Id = 9114628818,
                    Volume = 0.55,
                    Speed = 0.85
                }
            },
            Catch = {
                {
                    Id = 7182253058,
                    Volume = 1,
                    Speed = 1.05,
                    MaxDuration = 1.2
                },
                {
                    Id = 9114628818,
                    Volume = 0.6,
                    Speed = 0.95,
                    MaxDuration = 1.2
                }
            }
        },
        Zone8 = {
            Boss = "Microraptor",
            Cry = "SKREEEEE",
            Range = 80,
            Gain = 1.2,
            Lock = {
                {
                    Id = 135692329023659,
                    Volume = 1,
                    Speed = 1.05
                },
                {
                    Id = 9120043128,
                    Volume = 0.6,
                    Speed = 1.1
                },
                {
                    Id = 9114628620,
                    Volume = 0.45,
                    Speed = 0.9
                },
                {
                    Id = 119977062667102,
                    Volume = 0.4,
                    Speed = 0.8
                }
            },
            Chase = {
                {
                    Id = 9120043128,
                    Volume = 0.9,
                    Speed = 1.05
                },
                {
                    Id = 9114628620,
                    Volume = 0.5,
                    Speed = 0.95
                }
            },
            Catch = {
                {
                    Id = 135692329023659,
                    Volume = 1,
                    Speed = 1.15
                },
                {
                    Id = 9120043128,
                    Volume = 0.6,
                    Speed = 1.1
                }
            }
        },
        Zone9 = {
            Boss = "3Hydra",
            Cry = "RRAAAWR-SKREEE-GRRHHH",
            Range = 80,
            Gain = 1.3,
            Lock = {
                {
                    Id = 7127123554,
                    Volume = 1,
                    Speed = 0.9
                },
                {
                    Id = 7127123420,
                    Volume = 0.6,
                    Speed = 1.15
                },
                {
                    Id = 9113985727,
                    Volume = 0.55,
                    Speed = 0.8
                },
                {
                    Id = 119977062667102,
                    Volume = 0.5,
                    Speed = 0.7
                }
            },
            Chase = {
                {
                    Id = 7127123487,
                    Volume = 0.85,
                    Speed = 1,
                    Jitter = 0.1
                },
                {
                    Id = 71315213217187,
                    Volume = 0.6,
                    Speed = 0.9
                }
            },
            Catch = {
                {
                    Id = 7127123420,
                    Volume = 1,
                    Speed = 1.05,
                    MaxDuration = 1.2
                },
                {
                    Id = 71315213217187,
                    Volume = 0.6,
                    Speed = 1,
                    MaxDuration = 1.2
                },
                {
                    Id = 119977062667102,
                    Volume = 0.45,
                    Speed = 0.8,
                    MaxDuration = 1.2
                }
            }
        },
        Zone10 = {
            Boss = "AlienGuardian",
            Cry = "SKRAAAOOOWWRR",
            Range = 80,
            Gain = 1.3,
            Lock = {
                {
                    Id = 2391093263,
                    Volume = 1,
                    Speed = 0.95
                },
                {
                    Id = 73220705304397,
                    Volume = 0.55,
                    Speed = 1.05
                },
                {
                    Id = 9125842137,
                    Volume = 0.45,
                    Speed = 0.8
                },
                {
                    Id = 119977062667102,
                    Volume = 0.5,
                    Speed = 0.72
                }
            },
            Chase = {
                {
                    Id = 2391093643,
                    Volume = 0.85,
                    Speed = 1,
                    Jitter = 0.1
                },
                {
                    Id = 138798402743181,
                    Volume = 0.5,
                    Speed = 1.05
                }
            },
            Catch = {
                {
                    Id = 944965825,
                    Volume = 1,
                    Speed = 1.05,
                    MaxDuration = 1.2
                },
                {
                    Id = 73220705304397,
                    Volume = 0.6,
                    Speed = 1.15,
                    MaxDuration = 1.2
                },
                {
                    Id = 119977062667102,
                    Volume = 0.45,
                    Speed = 0.8,
                    MaxDuration = 1.2
                }
            }
        }
    },
    Default = {
        Boss = "Unknown",
        Cry = "ROAR",
        Range = 80,
        Gain = 1,
        Lock = {
            {
                Id = 9113980319,
                Volume = 1,
                Speed = 0.95
            },
            {
                Id = 9114628818,
                Volume = 0.5,
                Speed = 0.85
            }
        }
    }
}

function v1.Get(v2) -- line 491 | captures: v1
    return v2 and v1.Guards[v2] or v1.Default
end

function v1.AllAssetIds() -- line 498 | captures: v1
    local v3 = {}
    local v4 = {}

    local function collect(v5) -- line 502 | captures: v3, v4
        if v5 then
            for v6, v7 in v5 do
                if not v4[v7.Id] then
                    v4[v7.Id] = true
                    local v8 = ("rbxassetid://%*"):format(v7.Id)
                    table.insert(v3, v8)
                end
            end
        end
    end

    local function collectVoice(v9) -- line 514 | captures: collect
        collect(v9.Lock)
        collect(v9.Chase)
        collect(v9.Catch)
    end

    for v10, v11 in v1.Guards do
        collect(v11.Lock)
        collect(v11.Chase)
        collect(v11.Catch)
    end
    local Default = v1.Default
    collect(Default.Lock)
    collect(Default.Chase)
    collect(Default.Catch)
    return v3
end

return v1
