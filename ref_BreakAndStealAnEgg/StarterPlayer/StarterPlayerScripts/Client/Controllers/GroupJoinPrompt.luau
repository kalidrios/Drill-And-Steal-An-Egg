-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")
local v1 = {}
local v2 = false

function v1.IsMember(v3) -- line 40 | captures: Players
    if v3 <= 0 then
        return false
    end
    local LocalPlayer = Players.LocalPlayer
    local v4, v5 = pcall(LocalPlayer.IsInGroup, LocalPlayer, v3)
    return v4 and v5 == true
end

function v1.Prompt(v6) -- line 50 | captures: v2, GroupService, v1
    if v6 <= 0 then
        warn("[GroupJoinPrompt] no GroupId configured (GroupRewardConfig.GroupId) \226\128\148 nothing to join")
    elseif not v2 then
        if v1.IsMember(v6) then
            return "Joined"
        end
        v2 = true
        local v7, v8 = pcall(function() -- line 64 | captures: v6, GroupService
            return GroupService:PromptJoinAsync(v6)
        end)
        v2 = false
        if v7 then
            if v8 == Enum.GroupMembershipStatus.Joined or v8 == Enum.GroupMembershipStatus.AlreadyMember then
                return "Joined"
            end
            if v8 == Enum.GroupMembershipStatus.JoinRequestPending then
                return "Pending"
            end
            return "Declined"
        end
        warn((("[GroupJoinPrompt] PromptJoinAsync(%*) failed: %*"):format(v6, v8)))
    end
    return "Unavailable"
end

return v1
