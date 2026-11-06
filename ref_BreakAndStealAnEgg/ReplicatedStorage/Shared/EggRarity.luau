-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local EggRewards = require(script.Parent.EggRewards)
local ZonesConfig = require(script.Parent.ZonesConfig)
local v1 = {}
local v2 = { ["Basic Egg"] = "Forest Egg" }
local v3, v4
local v5 = { "Cosmic", "Secret", "Celestial", "Inferno", "Void", "Omega" }

function v1.Ladder() -- line 45 | captures: v3, ZonesConfig, v5
    if not v3 then
        local v6 = {}
        for v7, v8 in ZonesConfig.Zones do
            local Rarity = v8.Rarity
            table.insert(v6, Rarity)
        end
        for v9, v10 in v5 do
            if not table.find(v6, v10) then
                table.insert(v6, v10)
            end
        end
        v3 = v6
    end
    return v3
end

function v1.IndexOf(v11) -- line 62 | captures: v1
    if v11 then
        return table.find(v1.Ladder(), v11)
    end
    return nil
end

local function buildEggRarities() -- line 69 | captures: v4, EggRewards, v1, v2
    local function v12(...)
        return (tonumber(...))
    end

    local v13 = {}
    local v14 = {}
    for v15, v16 in EggRewards.Pool do
        local Zone = v16.Zone
        if Zone and v16.Rarity then
            local v17 = v1.IndexOf(v16.Rarity)
            if v17 then
                if v14[Zone] == nil or v17 < v14[Zone] then
                    v14[Zone] = v17
                    v13[Zone] = v16.Rarity
                end
            else
                warn((("[EggRarity] Zone%* pet \"%*\" has unknown rarity \"%*\""):format(Zone, v16.Name, v16.Rarity)))
            end
        end
    end
    local v18 = {}
    for v19, v20 in EggRewards.ZoneEggs do
        local v21 = v12(string.match(v19, "%d+"))
        local v22 = v21 and v13[v21]
        if v22 then
            for v23, v24 in v20.Eggs do
                v18[v24] = v22
            end
        end
    end
    for v25, v26 in v2 do
        if v18[v25] == nil then
            v18[v25] = v18[v26]
        end
    end
    v4 = v18
end

function v1.ForEggType(v27) -- line 109 | captures: v4, buildEggRarities
    if v27 then
        if not v4 then
            buildEggRarities()
        end
        return v4[v27]
    end
    return nil
end

function v1.Resolve(v28, v29) -- line 121 | captures: v1
    local v30 = v1.ForEggType(v28)
    local v31, v32
    if v30 then
        v31 = v30
        v32 = true
    elseif v29 then
        local Rarity = v29.Rarity
        if Rarity then
            v31 = Rarity
            v32 = true
        else
            v32 = false
        end
    else
        v32 = false
    end
    if not v32 then
        v31 = "Common"
    end
    return v31
end

function v1.PoolEggType(v33) -- line 127 | captures: v2
    if v33 then
        return v2[v33] or v33
    end
    return nil
end

local v34

function v1.LadderSpot(v35) -- line 140 | captures: v34, EggRewards, v1
    local function v36(...)
        return (tonumber(...))
    end

    local v37 = v1.PoolEggType(v35)
    if v37 then
        if not v34 then
            local v38 = {}
            for v39, v40 in EggRewards.ZoneEggs do
                local v41 = v36(string.match(v39, "%d+"))
                if v41 then
                    for v42, v43 in v40.Eggs do
                        v38[v43] = {
                            Zone = v41,
                            Tier = v42
                        }
                    end
                end
            end
            v34 = v38
        end
        local v44 = v34[v37]
        if v44 then
            return v44.Zone, v44.Tier
        end
    end
    return nil, nil
end

function v1.IsFirstZoneEgg(v45) -- line 168 | captures: v1
    return v1.LadderSpot(v45) == 1
end

function v1.IsStrongerEgg(v46, v47) -- line 178 | captures: v1
    local v48, v49 = v1.LadderSpot(v46)
    if v48 and v49 then
        if v48 == 1 then
            return v47 <= v49
        end
        return false
    end
    return false
end

function v1.IsPlainStarterEgg(v50, v51) -- line 190 | captures: v1
    if v50:GetAttribute("Lucky") or v50:GetAttribute("Titanic") or v50:GetAttribute("Variant") then
        return false
    end
    local EggType = v50:GetAttribute("EggType")
    return v1.IsFirstZoneEgg(EggType) and not v1.IsStrongerEgg(EggType, v51)
end

return v1
