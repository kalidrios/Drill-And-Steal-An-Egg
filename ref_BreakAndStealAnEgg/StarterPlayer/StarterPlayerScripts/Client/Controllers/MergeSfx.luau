-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local SpatialSfx = require(script.Parent.Parent.Modules.SpatialSfx)
local v1 = {}
local v2 = {}

function v1.Play(v3, v4, v5) -- line 41 | captures: MergeConfig, SpatialSfx, v2
    local v6 = MergeConfig.Sfx[v3]
    if v6 ~= nil then
        local SfxFolder = MergeConfig.SfxFolder
        if typeof(v6) == "table" then
            SfxFolder, v6 = v6.Folder, v6.Name
        end
        local v7 = SpatialSfx.Find(SfxFolder, v6)
        if v7 then
            local v8 = v5 or {}
            local Volume = v8.Volume
            if Volume == nil and v8.VolumeScale then
                Volume = v7.Volume * v8.VolumeScale
            end
            local Play = SpatialSfx.Play
            local v9 = {}
            v9.Mine = v8.Mine or v4 == nil
            v9.At = v4
            v9.Range = v8.RollOffMaxDistance or MergeConfig.SfxRollOffMax
            v9.MinRange = v8.RollOffMinDistance or MergeConfig.SfxRollOffMin
            v9.RollOffMode = Enum.RollOffMode.InverseTapered
            v9.Volume = Volume
            v9.PlaybackSpeed = v8.PlaybackSpeed
            return Play(SfxFolder, v6, v9)
        end
        if not v2[v3] then
            v2[v3] = true
            warn((("[MergeSfx] SoundService.%*.%* missing \226\128\148 \"%*\" is silent"):format(SfxFolder, v6 or v3, v3)))
        end
    end
    return nil
end

return v1
