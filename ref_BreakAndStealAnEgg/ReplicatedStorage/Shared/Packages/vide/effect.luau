-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local graph = require(script.Parent.graph)
local create_node = graph.create_node
local assert_stable_scope = graph.assert_stable_scope
local evaluate_node = graph.evaluate_node

local function effect(v1, v2) -- line 8 | captures: create_node, assert_stable_scope, evaluate_node
    local v3 = create_node(assert_stable_scope(), v1, v2)
    evaluate_node(v3)
end

return effect
