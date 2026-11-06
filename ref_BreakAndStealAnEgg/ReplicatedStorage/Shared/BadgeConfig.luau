-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    Badges = {
        Welcome = {
            Id = 1522513800439524,
            DisplayName = "Welcome",
            AwardOnJoin = true
        }
    },
    JoinDelaySeconds = 1,
    RetryDelays = { 2, 5, 10, 20, 30, 60 },
    Notify = false,
    NotifyText = function(v1) -- NotifyText | line 51
        return "Badge earned: {" .. v1.DisplayName .. "}!"
    end
}
