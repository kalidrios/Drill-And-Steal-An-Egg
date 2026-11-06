-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local throw = require(script.Parent.throw)
local graph = require(script.Parent.graph)
local create_node = graph.create_node
local evaluate_node = graph.evaluate_node
local push_child_to_scope = graph.push_child_to_scope
local destroy = graph.destroy
local assert_stable_scope = graph.assert_stable_scope
local push_scope = graph.push_scope
local pop_scope = graph.pop_scope

local function switch(v1) -- line 17 | captures: throw, create_node, evaluate_node, push_child_to_scope, destroy, assert_stable_scope, push_scope, pop_scope
    local v2 = assert_stable_scope()
    return function(v3) -- line 20 | captures: v1, v2, throw, create_node, evaluate_node, push_child_to_scope, destroy, push_scope, pop_scope
        local v4, v5

        local function update(v6) -- line 24 | captures: v4, v5, v3, v1, v2, throw, create_node, destroy, push_scope, pop_scope
            local v7 = v3[v1()]
            if v7 == v5 then
                return v6
            end
            v5 = v7
            if v4 then
                destroy(v4)
                v4 = nil
            end
            if v7 == nil then
                return nil
            end
            if type(v7) ~= "function" then
                throw("map must map a value to a function")
            end
            local v8 = create_node(v2, false, false)
            v4 = v8
            push_scope(v8)
            local v9, v10 = pcall(v7)
            pop_scope()
            if not v9 then
                error(v10, 0)
            end
            return v10
        end

        local v11 = create_node(v2, update, nil)
        evaluate_node(v11)
        return function() -- line 58 | captures: v11, push_child_to_scope
            push_child_to_scope(v11)
            return v11.cache
        end
    end
end

return switch
