-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2 = {}
local v3 = {}

function v1.TryAcquire(v4, v5) -- line 26 | captures: v3
    local v6 = v3[v4] or 0
    if v5 <= v6 then
        return nil
    end
    v3[v4] = v6 + 1
    local v7 = false
    return function() -- line 33 | captures: v7, v4, v3
        if v7 then
            return
        end
        v7 = true
        local v8 = (v3[v4] or 1) - 1
        v3[v4] = math.max(v8, 0)
    end
end

function v1.Ready(v9, v10) -- line 42 | captures: v2
    local v11 = os.clock()
    local v12 = v2[v9]
    if v12 and v11 - v12 < v10 then
        return false
    end
    v2[v9] = v11
    return true
end

return v1
