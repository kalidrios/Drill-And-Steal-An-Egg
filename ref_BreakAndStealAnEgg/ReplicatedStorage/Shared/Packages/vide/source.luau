-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local graph = require(script.Parent.graph)
local create_source_node = graph.create_source_node
local push_child_to_scope = graph.push_child_to_scope
local update_descendants = graph.update_descendants

local function source(v1) -- line 11 | captures: create_source_node, push_child_to_scope, update_descendants
    local v2 = create_source_node(v1)
    return function(...) -- line 14 | captures: v2, push_child_to_scope, update_descendants
        if select("#", ...) == 0 then
            push_child_to_scope(v2)
            return v2.cache
        end
        local v3 = ...
        if v2.cache == v3 and (type(v3) ~= "table" or table.isfrozen(v3)) then
            return v3
        end
        v2.cache = v3
        update_descendants(v2)
        return v3
    end
end

return source
