-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    GroupId = 187288153,
    RewardSpeed = 10000,
    ModelName = "GroupReward",
    FrameName = "GroupReward",
    AmountName = "Amount",
    AmountText = "+{amount} Speed",
    ClaimButtonName = "Claim",
    ClaimText = "Claim!",
    ClaimedText = "Claimed!",
    DeniedClaimedText = "Already claimed!",
    DeniedGroupText = "Join the group first!",
    DeniedLikeText = "Like and favorite the game!",
    TryAgainText = "Try again in {seconds} seconds!",
    LikeWaitSeconds = 10,
    ClaimDebounce = 1,
    ServerClaimDebounce = 0.6,
    LikeAskDebounce = 2,
    PromptCooldown = 45,
    JoinRefreshWait = 12,
    JoinRefreshInterval = 2,
    RemoteName = "GroupRewardRemote",
    GroupRecheckSeconds = 20,
    HitboxPath = { "CollissionBox", "Hitbox" },
    LockedTint = Color3.fromRGB(140, 140, 140)
}

function v1.CanClaim(v2) -- line 125
    return not v2.Claimed and v2.InGroup and v2.LikeAsked and v2.LikeWait <= 0
end

function v1.TryAgain(v3) -- line 133 | captures: v1
    local TryAgainText = v1.TryAgainText
    local v4 = math.ceil(v3)
    local v5 = math.max(v4, 1)
    return (TryAgainText:gsub("{seconds}", (tostring(v5))))
end

function v1.ClaimDenial(v6) -- line 142 | captures: v1
    if v6.Claimed then
        return v1.DeniedClaimedText
    end
    if v6.InGroup then
        if v6.LikeAsked then
            if v6.LikeWait > 0 then
                return v1.TryAgain(v6.LikeWait)
            end
            return nil
        end
        return v1.DeniedLikeText
    end
    return v1.DeniedGroupText
end

return v1
