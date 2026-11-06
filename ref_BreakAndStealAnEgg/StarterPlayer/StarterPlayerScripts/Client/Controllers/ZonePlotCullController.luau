-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local ZonesConfig = require(ReplicatedStorage.Shared.ZonesConfig)
local ZoneHitboxLookup = require(ReplicatedStorage.Shared.ZoneHitboxLookup)
local LocalCharacter = require(script.Parent.Parent.Modules.LocalCharacter)
local LocalModelHider = require(script.Parent.Parent.Modules.LocalModelHider)
local v1 = { HIDE_REASON = "ZoneCull" }
local HIDE_REASON = v1.HIDE_REASON
local v2 = {
    "PlacedAnimal",
    MergeConfig.PlacedEggTag
}
local PlotCull = ZonesConfig.PlotCull
local v3 = false
local v4

function v1.IsActive() -- line 50 | captures: v3
    return v3
end

local function hideTagged(v5) -- line 54 | captures: v3, LocalModelHider, HIDE_REASON
    if v3 and v5:IsA("Model") then
        LocalModelHider.Hide(v5, HIDE_REASON)
    end
end

local function showUntagged(v6) -- line 60 | captures: LocalModelHider, HIDE_REASON
    if v6:IsA("Model") then
        LocalModelHider.Show(v6, HIDE_REASON)
    end
end

local function setActive(v7) -- line 66 | captures: v3, CollectionService, LocalModelHider, HIDE_REASON, v2
    if v3 ~= v7 then
        v3 = v7
        for v8, v9 in v2 do
            for v10, v11 in CollectionService:GetTagged(v9) do
                if v11:IsA("Model") then
                    if v7 then
                        LocalModelHider.Hide(v11, HIDE_REASON)
                    else
                        LocalModelHider.Show(v11, HIDE_REASON)
                    end
                end
            end
        end
    end
end

function v1.Start() -- line 84 | captures: v3, v4, CollectionService, RunService, ZonesConfig, ZoneHitboxLookup, LocalCharacter, v2, PlotCull, hideTagged, showUntagged, setActive
    for v12, v13 in v2 do
        CollectionService:GetInstanceAddedSignal(v13):Connect(hideTagged)
        CollectionService:GetInstanceRemovedSignal(v13):Connect(showUntagged)
    end
    local v14 = 0
    RunService.Heartbeat:Connect(function() -- line 91 | captures: v14, v3, v4, ZonesConfig, ZoneHitboxLookup, LocalCharacter, PlotCull, setActive
        local v15 = os.clock()
        if v15 < v14 then
            return
        end
        v14 = v15 + PlotCull.CheckInterval
        local v16 = LocalCharacter.GetPosition()
        local v17 = v16 and ZoneHitboxLookup.GetZoneAt(v16)
        if v17 == nil then
            if v3 then
                v4 = v4 or v15 + PlotCull.GapGrace
                if v4 <= v15 then
                    v4 = nil
                    setActive(false)
                end
            end
        else
            v4 = nil
            local v18 = ZonesConfig.IndexOf(v17)
            local v19 = if v18 == nil then false else PlotCull.FromZone <= v18
            setActive(v19)
        end
    end)
end

return v1
