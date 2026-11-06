-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SettingsConfig = require(ReplicatedStorage.Shared.SettingsConfig)
local v1 = {}
local v2 = table.clone(SettingsConfig.Defaults)
local v3 = {}

function v1.Get(v4) -- line 36 | captures: v2
    return v2[v4]
end

function v1.Set(v5, v6) -- line 40 | captures: v2, v3
    if v2[v5] == v6 then
        return
    end
    v2[v5] = v6
    local v7 = v3[v5]
    if v7 then
        for v8 in v7 do
            task.spawn(v8, v6)
        end
    end
end

function v1.Observe(v9, v10) -- line 55 | captures: v2, v3
    local v11 = v3[v9]
    local v12 = v11
    if v11 == nil then
        v11 = {}
        v12 = v11
        v3[v9] = v11
    end
    v11[v10] = true
    task.spawn(v10, v2[v9])
    return function() -- line 63 | captures: v12, v10
        v12[v10] = nil
    end
end

return v1
