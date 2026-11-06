-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local MusicMuteConfig = require(ReplicatedStorage.Shared.MusicMuteConfig)
local v1 = {}
local v2, v3
local v4 = 1
local v5 = {}
for v6, v7 in MusicMuteConfig.ExemptSoundNames do
    v5[v7] = true
end

function v1.IsExempt(v8) -- line 50 | captures: v5
    return v5[v8.Name] == true
end

function v1.MusicGroup() -- line 56 | captures: v2, v4, SoundService, MusicMuteConfig
    if v2 and v2.Parent then
        return v2
    end
    local v9 = SoundService:WaitForChild(MusicMuteConfig.GroupName, 30)
    if not (v9 and v9:IsA("SoundGroup")) then
        warn((("[MusicBus] SoundService.%* missing"):format(MusicMuteConfig.GroupName)))
        return nil
    end
    v2 = v9
    v4 = v9.Volume
    return v9
end

function v1.AuthoredVolume() -- line 72 | captures: v4, v1
    v1.MusicGroup()
    return v4
end

function v1.ExemptGroup() -- line 79 | captures: v3, v4, SoundService, MusicMuteConfig, v1
    if v1.MusicGroup() then
        if not (v3 and v3.Parent) then
            local v10 = SoundService:FindFirstChild(MusicMuteConfig.ExemptGroupName)
            if not (v10 and v10:IsA("SoundGroup")) then
                local SoundGroup = Instance.new("SoundGroup")
                SoundGroup.Name = MusicMuteConfig.ExemptGroupName
                SoundGroup.Volume = v4
                SoundGroup.Parent = SoundService
                v3 = SoundGroup
            else
                v3 = v10
            end
        end
        return v3
    end
    return nil
end

function v1.RouteExempt(v11) -- line 103 | captures: v1
    local v12 = v1.ExemptGroup()
    if v12 then
        v11.SoundGroup = v12
    end
    return v12
end

function v1.Route(v13) -- line 114 | captures: v1
    local v14
    if v1.IsExempt(v13) then
        v14 = v1.ExemptGroup()
    else
        v14 = v1.MusicGroup()
    end
    if v14 then
        v13.SoundGroup = v14
    end
    return v14
end

return v1
