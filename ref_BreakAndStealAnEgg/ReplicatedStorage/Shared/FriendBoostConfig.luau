-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    AttributeName = "FriendBoostPercent",
    PercentPerFriend = 10,
    TagColor = "#00FF44"
}

function v1.Multiplier(v2) -- line 28
    if typeof(v2) == "number" and v2 == v2 and not (v2 <= 0) then
        return 1 + v2 / 100
    end
    return 1
end

return v1
