-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local graph = require(script.Parent.graph)
local create_node = graph.create_node
local assert_stable_scope = graph.assert_stable_scope
local evaluate_node = graph.evaluate_node

function create_implicit_effect(v1, v2) -- line 9 | captures: create_node, assert_stable_scope, evaluate_node
    evaluate_node(create_node(assert_stable_scope(), v1, v2))
end

local function update_property_effect(v3) -- line 19
    v3.instance[v3.property] = v3.source()
    return v3
end

local function update_parent_effect(v4) -- line 29
    v4.instance.Parent = v4.parent()
    return v4
end

local function update_children_effect(v5) -- line 42
    local cur_children_set = v5.cur_children_set
    local new_children_set = v5.new_children_set
    local v6 = v5.children()
    if type(v6) ~= "table" then
        v6 = { v6 }
    end
    local process_child

    local function process_child_2(v7) -- line 52 | captures: v5, cur_children_set, new_children_set, process_child
        if type(v7) == "table" then
            for v8, v9 in next, v7 do
                process_child(v9)
            end
        elseif not new_children_set[v7] then
            new_children_set[v7] = true
            if cur_children_set[v7] then
                cur_children_set[v7] = nil
            else
                v7.Parent = v5.instance
            end
        end
    end

    process_child = process_child_2
    process_child_2(v6)
    for v10 in next, cur_children_set do
        v10.Parent = nil
    end
    table.clear(cur_children_set)
    v5.cur_children_set = new_children_set
    v5.new_children_set = cur_children_set
    return v5
end

local v11 = {}

function v11.property(v12, v13, v14) -- line 82 | captures: update_property_effect
    return create_implicit_effect(update_property_effect, {
        instance = v12,
        property = v13,
        source = v14
    })
end

function v11.parent(v15, v16) -- line 90 | captures: update_parent_effect
    return create_implicit_effect(update_parent_effect, {
        instance = v15,
        parent = v16
    })
end

function v11.children(v17, v18) -- line 97 | captures: update_children_effect
    return create_implicit_effect(update_children_effect, {
        instance = v17,
        cur_children_set = {},
        new_children_set = {},
        children = v18
    })
end

return v11
