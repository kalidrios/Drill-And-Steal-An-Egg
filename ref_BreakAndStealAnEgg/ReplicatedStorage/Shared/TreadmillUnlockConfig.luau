-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    UnlockedAttribute = "TreadmillUnlocked",
    UnlockRemote = "UnlockTreadmillRequest",
    Cost = 100
}

function v1.IsPlotUnlocked(v2) -- line 37 | captures: v1
    if v2 == nil then
        return false
    end
    return v2:GetAttribute(v1.UnlockedAttribute) == true
end

return v1
