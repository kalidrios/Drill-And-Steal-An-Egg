-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = table.freeze({})

local function is_action(v2) -- line 8 | captures: v1
    return getmetatable(v2) == v1
end

local function action(v3, v4) -- line 12 | captures: v1
    local v5 = {
        priority = v4 or 1,
        callback = v3
    }
    setmetatable(v5, v1)
    return table.freeze(v5)
end

return function() -- line 23 | captures: is_action, action
    return action, is_action
end
