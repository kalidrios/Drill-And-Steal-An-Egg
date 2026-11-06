-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local EventRsvpConfig = require(ReplicatedStorage.Shared.EventRsvpConfig)
local SafeZoneQuery = require(ReplicatedStorage.Shared.SafeZoneQuery)
local EventId = EventRsvpConfig.EventId
local PromptStartTime = EventRsvpConfig.PromptStartTime
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2 = false
local v3 = false

local function getEventPhase() -- line 69 | captures: SocialService, EventId
    local v4, v5 = pcall(function() -- line 70 | captures: SocialService, EventId
        return SocialService:GetExperienceEventAsync(EventId)
    end)
    if not v4 or v5 == nil then
        return nil
    end
    if v5.HasStarted or v5.HasEnded then
        return "live"
    end
    return "upcoming"
end

local function alreadyRsvpd() -- line 82 | captures: SocialService, EventId
    local v6, v7 = pcall(function() -- line 83 | captures: SocialService, EventId
        return SocialService:GetEventRsvpStatusAsync(EventId)
    end)
    return v6 and v7 == Enum.RsvpStatus.Going
end

local function isInSafeZone() -- line 89 | captures: SafeZoneQuery, LocalPlayer
    local Character = LocalPlayer.Character
    local v8 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v8 and v8:IsA("BasePart") then
        return SafeZoneQuery.IsBankable(LocalPlayer.UserId, v8.Position)
    end
    return false
end

local function waitForPromptStartTime() -- line 98 | captures: PromptStartTime
    while true do
        local v9 = PromptStartTime - workspace:GetServerTimeNow()
        if v9 <= 0 then
            break
        end
        task.wait((math.min(v9, 30)))
    end
end

local function tryPrompt(v10) -- line 111 | captures: v2, v3, SocialService, EventRsvpConfig, SafeZoneQuery, EventId, LocalPlayer
    if v2 then
        return
    end
    v2 = true
    if v10 or EventRsvpConfig.IsUnlocked(workspace:GetServerTimeNow()) then
        local v11, v12 = pcall(function() -- line 70 | captures: SocialService, EventId
            return SocialService:GetExperienceEventAsync(EventId)
        end)
        local v13
        if not v11 or v12 == nil then
        elseif v12.HasStarted or v12.HasEnded then
            v13 = "live"
        else
            v13 = "upcoming"
        end
        if v13 == "upcoming" then
            local v14, v15 = pcall(function() -- line 83 | captures: SocialService, EventId
                return SocialService:GetEventRsvpStatusAsync(EventId)
            end)
            if not (v14 and v15 == Enum.RsvpStatus.Going) then
                local v16 = os.clock() + 60
                while true do
                    local Character = LocalPlayer.Character
                    local v17 = Character and Character:FindFirstChild("HumanoidRootPart")
                    if v17 and v17:IsA("BasePart") and SafeZoneQuery.IsBankable(LocalPlayer.UserId, v17.Position) then
                        v3 = true
                        pcall(function() -- line 145 | captures: SocialService, EventId
                            SocialService:PromptRsvpToEventAsync(EventId)
                        end)
                        v2 = false
                        return
                    end
                    task.wait(1)
                    local v18, v19
                    if v16 <= os.clock() then
                        local v20, v21 = pcall(function() -- line 70 | captures: SocialService, EventId
                            return SocialService:GetExperienceEventAsync(EventId)
                        end)
                        if v20 then
                            if v21 == nil or v21.HasStarted or v21.HasEnded then
                                v19 = true
                            else
                                v18 = os.clock() + 60
                                v19 = false
                            end
                        else
                            v19 = true
                        end
                    else
                        v18 = v16
                        v19 = false
                    end
                    if v19 then
                        break
                    end
                    v16 = v18
                end
                v2 = false
                return
            end
        end
    end
    v2 = false
end

function v1.Start() -- line 151 | captures: v3, ReplicatedStorage, EventRsvpConfig, waitForPromptStartTime, tryPrompt
    task.spawn(function() -- line 153 | captures: ReplicatedStorage, EventRsvpConfig, tryPrompt
        local v22 = ReplicatedStorage:WaitForChild(EventRsvpConfig.PromptRemote)
        if v22:IsA("RemoteEvent") then
            v22.OnClientEvent:Connect(function() -- line 156 | captures: tryPrompt
                task.spawn(tryPrompt, true)
            end)
        end
    end)
    task.wait(180)
    waitForPromptStartTime()
    if not v3 then
        tryPrompt(false)
    end
end

return v1
