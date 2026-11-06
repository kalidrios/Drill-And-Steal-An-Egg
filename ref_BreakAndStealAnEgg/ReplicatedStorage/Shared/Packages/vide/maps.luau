-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local throw = require(script.Parent.throw)
local flags = require(script.Parent.flags)
local graph = require(script.Parent.graph)
local create_node = graph.create_node
local create_source_node = graph.create_source_node
local push_child_to_scope = graph.push_child_to_scope
local update_descendants = graph.update_descendants
local assert_stable_scope = graph.assert_stable_scope
local push_scope = graph.push_scope
local pop_scope = graph.pop_scope
local evaluate_node = graph.evaluate_node
local destroy = graph.destroy

local function check_primitives(v1) -- line 20 | captures: throw, flags
    if flags.strict then
        for v2, v3 in next, v1 do
            if type(v3) ~= "table" and type(v3) ~= "userdata" and type(v3) ~= "function" then
                throw("table source map cannot return primitives")
            end
        end
    end
end

local function indexes(v4, v5) -- line 29 | captures: create_node, create_source_node, push_child_to_scope, update_descendants, assert_stable_scope, push_scope, pop_scope, evaluate_node, destroy, check_primitives
    local v6 = assert_stable_scope()
    local v7 = create_node(v6, false, false)
    local v8 = {}
    local v9 = {}
    local v10 = {}
    local v11 = {}
    local v12 = {}

    local function update_children(v13) -- line 39 | captures: v5, v7, v8, v9, v10, v11, v12, create_node, create_source_node, push_child_to_scope, update_descendants, push_scope, pop_scope, destroy, check_primitives
        for v14 in next, v12 do
            if v13[v14] == nil then
                table.insert(v10, v14)
            end
        end
        for v15, v16 in next, v10 do
            destroy(v11[v16])
            v12[v16] = nil
            v8[v16] = nil
            v9[v16] = nil
            v11[v16] = nil
        end
        table.clear(v10)
        push_scope(v7)
        for v17, v18 in next, v13 do
            local v19 = v12[v17]
            if v19 ~= v18 then
                if v19 == nil then
                    local v20 = create_node(v7, false, false)
                    v11[v17] = v20
                    local v21 = create_source_node(v18)
                    push_scope(v20)
                    local v22, v23 = pcall(v5, function() -- line 74 | captures: v21, push_child_to_scope
                        push_child_to_scope(v21)
                        return v21.cache
                    end, v17)
                    pop_scope()
                    if not v22 then
                        pop_scope()
                        error(v23, 0)
                    end
                    v9[v17] = v21
                    v8[v17] = v23
                else
                    v9[v17].cache = v18
                    update_descendants(v9[v17])
                end
                v12[v17] = v18
            end
        end
        pop_scope()
        local v24 = table.create(#v11)
        for v25, v26 in next, v8 do
            table.insert(v24, v26)
        end
        check_primitives(v24)
        return v24
    end

    local v27 = create_node(v6, function() -- line 108 | captures: v4, update_children
        return (update_children(v4()))
    end, false)
    evaluate_node(v27)
    return function() -- line 114 | captures: v27, push_child_to_scope
        push_child_to_scope(v27)
        return v27.cache
    end
end

local function values(v28, v29) -- line 120 | captures: throw, flags, create_node, create_source_node, push_child_to_scope, update_descendants, assert_stable_scope, push_scope, pop_scope, evaluate_node, destroy, check_primitives
    local v30 = assert_stable_scope()
    local v31 = create_node(v30, false, false)
    local v32 = {}
    local v33 = {}
    local v34 = {}
    local v35 = {}
    local v36 = {}

    local function update_children(v37) -- line 130 | captures: v32, v33, v29, v31, v34, v35, v36, throw, flags, create_node, create_source_node, push_child_to_scope, update_descendants, push_scope, pop_scope, destroy, check_primitives
        local v38 = v32
        local v39 = v33
        if flags.strict then
            local v40 = {}
            for v41, v42 in next, v37 do
                if v40[v42] ~= nil then
                    throw("duplicate table value detected")
                end
                v40[v42] = true
            end
        end
        push_scope(v31)
        for v43, v44 in next, v37 do
            v39[v44] = v43
            local v45 = v38[v44]
            if v45 == nil then
                local v46 = create_node(v31, false, false)
                v36[v44] = v46
                local v47 = create_source_node(v43)
                push_scope(v46)
                local v48, v49 = pcall(v29, v44, function() -- line 159 | captures: v47, push_child_to_scope
                    push_child_to_scope(v47)
                    return v47.cache
                end)
                pop_scope()
                if not v48 then
                    pop_scope()
                    error(v49, 0)
                end
                v35[v44] = v47
                v34[v44] = v49
            else
                if v45 ~= v43 then
                    v35[v44].cache = v43
                    update_descendants(v35[v44])
                end
                v38[v44] = nil
            end
        end
        pop_scope()
        for v50 in next, v38 do
            destroy(v36[v50])
            v34[v50] = nil
            v35[v50] = nil
            v36[v50] = nil
        end
        table.clear(v38)
        v32 = v39
        v33 = v38
        local v51 = table.create(#v36)
        for v52, v53 in next, v34 do
            table.insert(v51, v53)
        end
        check_primitives(v51)
        return v51
    end

    local v54 = create_node(v30, function() -- line 207 | captures: v28, update_children
        return (update_children(v28()))
    end, false)
    evaluate_node(v54)
    return function() -- line 213 | captures: v54, push_child_to_scope
        push_child_to_scope(v54)
        return v54.cache
    end
end

return function() -- line 219 | captures: indexes, values
    return indexes, values
end
