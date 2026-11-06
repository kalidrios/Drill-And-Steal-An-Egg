-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local v1 = {}
local v2

function v1.Settings() -- line 37 | captures: v2, EggConfig
    local v3 = v2
    if v3 then
        return v3
    end
    local v4 = EggConfig.Spawn and EggConfig.Spawn.SlowTail
    local Seconds = v4 and v4.Seconds or 0
    local v5 = math.max(Seconds, 0)
    local Multiplier = v4 and v4.Multiplier or 1
    local v6 = math.max(Multiplier, 1)
    if v5 <= 0 or v6 <= 1 then
        v5 = 0
        v6 = 1
    end
    local freeze = table.freeze
    local v7 = {
        Seconds = v5,
        Multiplier = v6
    }
    local HealthFraction = v4 and v4.HealthFraction or 0
    v7.HealthFraction = math.clamp(HealthFraction, 0, 1)
    local v8 = freeze(v7)
    v2 = v8
    return v8
end

function v1.MaxExtraSeconds() -- line 60 | captures: v1
    local v9 = v1.Settings()
    return v9.Seconds * (v9.Multiplier - 1)
end

function v1.ShownRemaining(v10) -- line 68 | captures: Workspace
    local DespawnAt = v10:GetAttribute("DespawnAt")
    if DespawnAt then
        local v11 = DespawnAt - Workspace:GetServerTimeNow()
        return (math.max(v11, 0))
    end
    return nil
end

function v1.IsHurtEnough(v12) -- line 78 | captures: v1
    local HealthFraction = v1.Settings().HealthFraction
    if not (HealthFraction <= 0) and not v12:GetAttribute("Hatching") and not v12:GetAttribute("Broken") and not v12:GetAttribute("Despawning") then
        local v13 = v12:GetAttribute("Health") or 0
        local v14 = v12:GetAttribute("MaxHealth") or 0
        if v13 <= 0 or v14 <= 0 then
            return false
        end
        return v13 / v14 < HealthFraction
    end
    return false
end

function v1.IsSlowed(v15) -- line 97 | captures: v1
    local v16 = v1.Settings()
    if not (v16.Seconds <= 0) then
        local v17 = v1.ShownRemaining(v15)
        if v17 and not (v17 <= 0) and not (v16.Seconds < v17) then
            return v1.IsHurtEnough(v15)
        end
    end
    return false
end

local function TickDelay(v18, v19) -- line 113
    if v19 then
        return 0.1
    end
    local v20 = v18 % 1
    return (math.clamp(v20, 0.1, 1))
end

v1.TickDelay = TickDelay
return v1
