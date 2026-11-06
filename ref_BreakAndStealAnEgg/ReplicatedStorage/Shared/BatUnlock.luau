-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BatConfig = require(ReplicatedStorage.Shared.BatConfig)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local v1 = {}
local v2 = {}
for v3, v4 in BatConfig.Tiers do
    local Zone = v4.Zone
    if typeof(Zone) == "number" then
        v2[v4.Zone] = v3
    end
end
local v5

local function buildRosters() -- line 40 | captures: v5, EggRewards
    if v5 then
        return v5
    end
    local v6 = {}
    for v7, v8 in EggRewards.Pool do
        if v8.Zone and not v8.IndexHidden then
            v6[v8.Zone] = v6[v8.Zone] or {}
            local v9 = v6[v8.Zone]
            local Name = v8.Name
            table.insert(v9, Name)
        end
    end
    v5 = v6
    return v6
end

function v1.TierForZone(v10) -- line 55 | captures: v2
    if typeof(v10) == "number" then
        return v2[v10]
    end
    return nil
end

function v1.ZoneRoster(v11) -- line 62 | captures: buildRosters
    return buildRosters()[v11] or {}
end

function v1.IsZoneComplete(v12, v13) -- line 68 | captures: v1
    if typeof(v12) == "table" then
        local v14 = v1.ZoneRoster(v13)
        if #v14 == 0 then
            return false
        end
        for v15, v16 in v14 do
            if v12[v16] == nil then
                return false
            end
        end
        return true
    end
    return false
end

function v1.TemplateFor(v17) -- line 85 | captures: ReplicatedStorage, BatConfig
    local v18 = BatConfig.Tiers[v17]
    local v19 = v18 and ReplicatedStorage:FindFirstChild(BatConfig.TemplatesFolderName)
    local v20 = v19 and v19:FindFirstChild(v18.Template)
    if not (v20 and v20:IsA("Tool")) then
        return nil
    end
    return v20
end

return v1
