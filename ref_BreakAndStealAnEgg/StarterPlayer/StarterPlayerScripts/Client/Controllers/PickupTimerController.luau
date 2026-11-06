-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AnimalOverhead = require(ReplicatedStorage.Shared.AnimalOverhead)
local v1 = {}
local v2 = {}

local function track(v3) -- line 34 | captures: v2
    if v3:IsA("Model") then
        v2[v3] = true
    end
end

function v1.Start() -- line 40 | captures: CollectionService, Workspace, AnimalOverhead, v2, track
    for v4, v5 in CollectionService:GetTagged("AnimalPickup") do
        if v5:IsA("Model") then
            v2[v5] = true
        end
    end
    CollectionService:GetInstanceAddedSignal("AnimalPickup"):Connect(track)
    CollectionService:GetInstanceRemovedSignal("AnimalPickup"):Connect(function(v6) -- line 45 | captures: v2
        v2[v6] = nil
    end)
    task.spawn(function() -- line 49 | captures: Workspace, AnimalOverhead, v2
        while true do
            local v7 = Workspace:GetServerTimeNow()
            for v8 in v2 do
                if v8.Parent == nil then
                    v2[v8] = nil
                elseif not v8:GetAttribute("Despawning") then
                    local DespawnAtServerTime = v8:GetAttribute("DespawnAtServerTime")
                    if typeof(DespawnAtServerTime) == "number" then
                        AnimalOverhead.UpdateTimer(v8, DespawnAtServerTime - v7)
                    end
                end
            end
            task.wait(1)
        end
    end)
end

return v1
