-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local v1 = {}
local LocalPlayer = Players.LocalPlayer

function v1.ShouldShow(v2) -- line 23 | captures: LocalPlayer
    return v2:GetAttribute("OwnerUserId") == LocalPlayer.UserId
end

return v1
