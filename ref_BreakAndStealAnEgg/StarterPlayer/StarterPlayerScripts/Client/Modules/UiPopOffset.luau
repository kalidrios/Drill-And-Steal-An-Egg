-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2 = {}
local v3 = { __mode = "k" }
local v4 = setmetatable(v2, v3)
local v5 = {}
local v6 = { __mode = "k" }
local v7 = setmetatable(v5, v6)

function v1.Manage(v8) -- line 27 | captures: v4
    v4[v8] = true
end

function v1.Unmanage(v9) -- line 31 | captures: v4, v7
    v4[v9] = nil
    v7[v9] = nil
end

function v1.IsManaged(v10) -- line 36 | captures: v4
    return v4[v10] == true
end

function v1.Set(v11, v12) -- line 40 | captures: v7
    v7[v11] = v12
end

function v1.Get(v13) -- line 44 | captures: v7
    return v7[v13]
end

function v1.Active() -- line 48 | captures: v7
    return next(v7) ~= nil
end

return v1
