-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SafeZoneQuery = require(ReplicatedStorage.Shared.SafeZoneQuery)
local ClaimFeedback = require(script.Parent.ClaimFeedback)
local LocalCharacter = require(script.Parent.Parent.Modules.LocalCharacter)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = false
local GetRoot = LocalCharacter.GetRoot

local function watchOwnPosition() -- line 60 | captures: v2, RunService, SafeZoneQuery, ClaimFeedback, LocalPlayer, GetRoot
    RunService.Heartbeat:Connect(function() -- line 61 | captures: v2, SafeZoneQuery, ClaimFeedback, LocalPlayer, GetRoot
        if LocalPlayer:GetAttribute("Carrying") == nil then
            v2 = false
        elseif not v2 then
            local v3 = GetRoot()
            if v3 and SafeZoneQuery.IsBankable(LocalPlayer.UserId, v3.Position) then
                v2 = true
                ClaimFeedback.PlayBank()
            end
        end
    end)
end

function v1.Start() -- line 85 | captures: v2, ReplicatedStorage, RunService, SafeZoneQuery, ClaimFeedback, LocalPlayer, GetRoot
    RunService.Heartbeat:Connect(function() -- line 61 | captures: v2, SafeZoneQuery, ClaimFeedback, LocalPlayer, GetRoot
        if LocalPlayer:GetAttribute("Carrying") == nil then
            v2 = false
        elseif not v2 then
            local v4 = GetRoot()
            if v4 and SafeZoneQuery.IsBankable(LocalPlayer.UserId, v4.Position) then
                v2 = true
                ClaimFeedback.PlayBank()
            end
        end
    end)
    local v5 = ReplicatedStorage:WaitForChild("AnimalBankedRemote", 30)
    if not (v5 and v5:IsA("RemoteEvent")) then
        warn("[BankEffectsController] AnimalBankedRemote missing")
    else
        v5.OnClientEvent:Connect(function() -- line 94 | captures: v2, ClaimFeedback
            v2 = true
            ClaimFeedback.PlayBank()
        end)
    end
    LocalPlayer.CharacterAdded:Connect(function() -- line 103 | captures: v2, ClaimFeedback
        v2 = false
        ClaimFeedback.Stop()
    end)
end

return v1
