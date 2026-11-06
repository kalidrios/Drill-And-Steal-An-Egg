-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    StateRemote = "PollState",
    VoteRemote = "PollVote",
    Topic = "GlobalPoll",
    Scopes = { "Global", "Server", "Client" },
    DefaultScope = "Global",
    MaxQuestionLength = 80,
    MaxAnswerLength = 24,
    DefaultDuration = 15,
    MinDuration = 5,
    MaxDuration = 300,
    VotesMap = "AdminPollVotes",
    CountsMap = "AdminPollTallies",
    CounterShards = 16,
    TotalReplicas = 8,
    TallyInterval = 2,
    ReadAttempts = 2,
    StaleAfter = 6,
    TakeoverStagger = 0.5,
    FinalGrace = 3,
    FinalWait = 6,
    KeyLifetime = 600,
    PushInterval = 0.25,
    Rig = {
        MaxCCU = 50000000,
        MinShare = 51,
        MaxShare = 99,
        ReadingMaxFraction = 0.4,
        ReadingPower = 4,
        ReadingSkew = 0.4,
        Floor = 0.003,
        Surge = 0.22,
        Jitter = 0.5,
        Step = 0.2,
        Turnout = {
            Min = 0.86,
            Max = 0.96
        },
        DefaultShare = {
            Min = 54,
            Max = 66
        },
        StartDelay = {
            Min = 0.4,
            Max = 0.9
        },
        Reading = {
            Min = 4.5,
            Max = 5.5
        },
        Decay = {
            MaxFraction = 0.17,
            Seconds = {
                Min = 2.5,
                Max = 3.8
            }
        },
        Tail = {
            Share = 0.06,
            MaxFraction = 0.25,
            Seconds = {
                Min = 6,
                Max = 10
            }
        },
        Burst = {
            Chance = 0.08,
            Min = 1.8,
            Max = 3.5,
            Window = 6
        },
        PushInterval = {
            Min = 0.15,
            Max = 0.5
        }
    },
    ZoneLift = 48,
    ResultTime = 4,
    ShowTween = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    HideTween = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    BarTween = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    DimColor = Color3.fromRGB(20, 20, 20),
    DimAmount = 0.8,
    DimTextColor = Color3.fromRGB(110, 110, 110)
}

function v1.ClampDuration(v2) -- line 177 | captures: v1
    if not (type(v2) == "number" and v2 == v2) then
        return v1.DefaultDuration
    end
    local v3 = math.floor(v2)
    local MinDuration = v1.MinDuration
    local MaxDuration = v1.MaxDuration
    return (math.clamp(v3, MinDuration, MaxDuration))
end

return v1
