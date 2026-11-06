-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    EventId = "8851788773407719989",
    PromptStartTime = DateTime.fromUniversalTime(2026, 10, 4, 14, 0, 0).UnixTimestamp,
    PromptRemote = "EventRsvpPrompt",
    Topic = "EventRsvpPrompt"
}

function v1.IsUnlocked(v2) -- line 27 | captures: v1
    return v1.PromptStartTime <= v2
end

return v1
