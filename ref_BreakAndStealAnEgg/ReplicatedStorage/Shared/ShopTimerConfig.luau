-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    UpdateInterval = 1,
    Targets = {
        {
            EndedText = "Ended!",
            Path = { "Frames", "Shop", "ScrollingFrame", "EggsPack", "Inner", "Timer" },
            EndsAt = DateTime.fromUniversalTime(2026, 10, 24, 12, 0, 0).UnixTimestamp
        }
    }
}

function v1.Format(v2) -- line 40
    local v3 = math.floor(v2)
    local v4 = math.max(v3, 0)
    local v5 = v4 // 86400
    local v6 = v4 % 86400 // 3600
    local v7 = v4 % 3600 // 60
    local v8 = v4 % 60
    if v5 > 0 then
        return (("%*d %*h %*m %*s"):format(v5, v6, v7, v8))
    end
    if v6 > 0 then
        return (("%*h %*m %*s"):format(v6, v7, v8))
    end
    if v7 > 0 then
        return (("%*m %*s"):format(v7, v8))
    end
    return (("%*s"):format(v8))
end

return v1
