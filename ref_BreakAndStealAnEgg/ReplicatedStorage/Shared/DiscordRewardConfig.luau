-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    Animal = "SABER_TOOTHED_TIGER",
    RewardName = "Sabertooth Egg",
    VerifyTitleName = "Title",
    VerifyText = "Verify",
    ClaimedText = "Claimed!",
    DeniedClaimedText = "Already claimed!",
    DeniedEmptyText = "Type your Roblox @Username first!",
    JoinAskText = "Join our Community server through the game page, then press Verify again!",
    TryAgainText = "Try again in {seconds} seconds!",
    SuccessText = "You got a {name}!",
    JoinWaitSeconds = 30,
    PressDebounce = 1,
    ServerPressDebounce = 0.6,
    AskDebounce = 2,
    RemoteName = "DiscordRewardRemote",
    CardPath = { "Frames", "Shop", "ScrollingFrame", "CommunityReward", "Inner" },
    TextBoxPath = { "UserNameVerify", "TextBox" },
    VerifyButtonPath = { "ButtonList", "Verify" },
    LockedTint = Color3.fromRGB(140, 140, 140)
}

function v1.CleanName(v2) -- line 88
    return (string.gsub(string.gsub(v2, "%s", ""), "^@+", ""))
end

function v1.TryAgain(v3) -- line 92 | captures: v1
    local TryAgainText = v1.TryAgainText
    local v4 = math.ceil(v3)
    local v5 = math.max(v4, 1)
    return (TryAgainText:gsub("{seconds}", (tostring(v5))))
end

function v1.InputDenial(v6, v7) -- line 99 | captures: v1
    if v6.Claimed then
        return v1.DeniedClaimedText
    end
    if v1.CleanName(v7) == "" then
        return v1.DeniedEmptyText
    end
    return nil
end

function v1.LadderDenial(v8) -- line 111 | captures: v1
    if v8.Asked then
        if v8.Wait > 0 then
            return v1.TryAgain(v8.Wait)
        end
        return nil
    end
    return v1.JoinAskText
end

return v1
