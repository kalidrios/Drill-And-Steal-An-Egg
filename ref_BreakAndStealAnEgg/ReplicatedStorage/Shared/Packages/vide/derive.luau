-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local graph = require(script.Parent.graph)
local create_node = graph.create_node
local push_child_to_scope = graph.push_child_to_scope
local assert_stable_scope = graph.assert_stable_scope
local evaluate_node = graph.evaluate_node

local function derive(v1) -- line 9 | captures: create_node, push_child_to_scope, assert_stable_scope, evaluate_node
    local v2 = create_node(assert_stable_scope(), v1, false)
    evaluate_node(v2)
    return function() -- line 14 | captures: v2, push_child_to_scope
        push_child_to_scope(v2)
        return v2.cache
    end
end

return derive
