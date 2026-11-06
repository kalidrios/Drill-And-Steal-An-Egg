-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local get_scope = require(script.Parent.graph).get_scope

local function untrack(v1) -- line 7 | captures: get_scope
    local v2 = get_scope()
    if v2 then
        local effect = v2.effect
        v2.effect = false
        local v3, v4 = pcall(v1)
        v2.effect = effect
        if not v3 then
            error(v4, 0)
        end
        return v4
    end
    return v1()
end

return untrack
