-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ZoneDisplayInfo = require(script.Parent.ZoneDisplayInfo)
local EggRewards = require(script.Parent.EggRewards)
local v1 = {
    RemoteName = "FuseMachineRequest",
    EggType = "Celestial",
    Requirements = { "Lindworm", "THUNDERBIRD", "CrystalRaptor" },
    RequestCooldown = 0.25
}

function v1.SlotOf(v2) -- line 58 | captures: v1
    if typeof(v2) == "string" then
        return table.find(v1.Requirements, v2)
    end
    return nil
end

function v1.FoundInText(v3) -- line 67 | captures: ZoneDisplayInfo, EggRewards
    local v4 = EggRewards.HomeZoneOf(v3)
    if v4 then
        local v5 = ZoneDisplayInfo[("Zone%*"):format(v4)]
        local v6
        if v5 then
            v6 = v5.Name
        else
            v6 = ("Zone %*"):format(v4)
        end
        return (("Found In [%*]"):format(v6))
    end
    return "Found In [???]"
end

return v1
