-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local throw = require(script.Parent.throw)
local flags = require(script.Parent.flags)
local v1 = { n = 0 }

local function ycall(v2, v3) -- line 27
    local v4 = coroutine.create(xpcall)

    local function efn(v5) -- line 29
        return debug.traceback(v5, 3)
    end

    local v6, v7, v8 = coroutine.resume(v4, v2, efn, v3)
    assert(v6)
    if coroutine.status(v4) == "dead" then
        return v7, v8
    end
    return false, debug.traceback(v4, "attempt to yield in reactive scope")
end

local function get_scope() -- line 41 | captures: v1
    return v1[v1.n]
end

local function assert_stable_scope() -- line 45 | captures: throw, v1
    local v9 = v1[v1.n]
    if v9 then
        if v9.effect then
            throw("cannot create a new reactive scope inside another reactive scope")
        end
        return v9
    end
    local n = debug.info(2, "n")
    return throw((("cannot use %*() outside a stable or reactive scope"):format(n)))
end

local function push_child(v10, v11) -- line 58
    table.insert(v10, v11)
    local parents = v11.parents
    table.insert(parents, v10)
end

local function push_scope(v12) -- line 63 | captures: v1
    local v13 = v1.n + 1
    v1.n = v13
    v1[v13] = v12
end

local function pop_scope() -- line 69 | captures: v1
    local n = v1.n
    v1.n = n - 1
    v1[n] = nil
end

local function push_cleanup(v14, v15) -- line 75
    if v14.cleanups then
        local cleanups = v14.cleanups
        table.insert(cleanups, v15)
    else
        v14.cleanups = { v15 }
    end
end

local function flush_cleanups(v16) -- line 83 | captures: throw
    if v16.cleanups then
        for v17, v18 in next, v16.cleanups do
            local v19, v20 = pcall(v18)
            if not v19 then
                throw((("cleanup error: %*"):format(v20)))
            end
        end
        table.clear(v16.cleanups)
    end
end

local function find_and_swap_pop(v21, v22) -- line 94
    local v23 = table.find(v21, v22)
    local v24 = #v21
    v21[v23] = v21[v24]
    v21[v24] = nil
end

local function unparent(v25) -- line 101
    local parents = v25.parents
    for v26, v27 in parents do
        local v28 = table.find(v27, v25)
        local v29 = #v27
        v27[v28] = v27[v29]
        v27[v29] = nil
        parents[v26] = nil
    end
end

local destroy

local function destroy_2(v30) -- line 110 | captures: flush_cleanups, destroy
    flush_cleanups(v30)
    local parents = v30.parents
    for v31, v32 in parents do
        local v33 = table.find(v32, v30)
        local v34 = #v32
        v32[v33] = v32[v34]
        v32[v34] = nil
        parents[v31] = nil
    end
    if v30.owner then
        local owned = v30.owner.owned
        local v35 = table.find(owned, v30)
        local v36 = #owned
        owned[v35] = owned[v36]
        owned[v36] = nil
        v30.owner = false
    end
    if v30.owned then
        local owned = v30.owned
        while owned[1] do
            destroy(owned[1])
        end
    end
end

destroy = destroy_2

local function destroy_owned(v37) -- line 125 | captures: destroy_2
    if v37.owned then
        local owned = v37.owned
        while owned[1] do
            destroy_2(owned[1])
        end
    end
end

local v38 = { n = 0 }

local function evaluate_node(v39) -- line 134 | captures: throw, flags, v1, ycall, flush_cleanups, destroy_2, v38
    if flags.strict then
        local cache = v39.cache
        for v40 = 1, 2 do
            local cache = v39.cache
            flush_cleanups(v39)
            if v39.owned then
                local owned = v39.owned
                while owned[1] do
                    destroy_2(owned[1])
                end
            end
            local v41 = v1.n + 1
            v1.n = v41
            v1[v41] = v39
            local v42, v43 = ycall(v39.effect, cache)
            local n = v1.n
            v1.n = n - 1
            v1[n] = nil
            if not v42 then
                table.clear(v38)
                v38.n = 0
                throw((("effect stacktrace:\n%*"):format(v43)))
            end
            v39.cache = v43
        end
        return cache ~= v39.cache
    end
    local cache = v39.cache
    flush_cleanups(v39)
    if v39.owned then
        local owned = v39.owned
        while owned[1] do
            destroy_2(owned[1])
        end
    end
    local v44 = v1.n + 1
    v1.n = v44
    v1[v44] = v39
    local v45, v46 = pcall(v39.effect, v39.cache)
    local n = v1.n
    v1.n = n - 1
    v1[n] = nil
    if not v45 then
        table.clear(v38)
        v38.n = 0
        throw((("effect stacktrace:\n%*\n"):format(v46)))
    end
    v39.cache = v46
    return cache ~= v46
end

local function queue_children_for_update(v47) -- line 179 | captures: v38
    local v48 = v38.n
    while v47[1] do
        v48 += 1
        v38[v48] = v47[1]
        local v49 = v47[1]
        local parents = v49.parents
        for v50, v51 in parents do
            local v52 = table.find(v51, v49)
            local v53 = #v51
            v51[v52] = v51[v53]
            v51[v53] = nil
            parents[v50] = nil
        end
    end
    v38.n = v48
end

local function get_update_queue_length() -- line 189 | captures: v38
    return v38.n
end

local function flush_update_queue(v54) -- line 193 | captures: v38, evaluate_node
    local v55 = v54 + 1
    while v55 <= v38.n do
        local v56 = v38[v55]
        if v56.owner and evaluate_node(v56) then
            local v57 = v38.n
            while v56[1] do
                v57 += 1
                v38[v57] = v56[1]
                local v58 = v56[1]
                local parents = v58.parents
                for v59, v60 in parents do
                    local v61 = table.find(v60, v58)
                    local v62 = #v60
                    v60[v61] = v60[v62]
                    v60[v62] = nil
                    parents[v59] = nil
                end
            end
            v38.n = v57
        end
        v38[v55] = false
        v55 += 1
    end
    v38.n = v54
end

local function update_descendants(v63) -- line 210 | captures: flags, v38, evaluate_node
    local n = v38.n
    local v64 = v38.n
    while v63[1] do
        v64 += 1
        v38[v64] = v63[1]
        local v65 = v63[1]
        local parents = v65.parents
        for v66, v67 in parents do
            local v68 = table.find(v67, v65)
            local v69 = #v67
            v67[v68] = v67[v69]
            v67[v69] = nil
            parents[v66] = nil
        end
    end
    v38.n = v64
    if flags.batch then
        return
    end
    local v70 = n + 1
    while v70 <= v38.n do
        local v71 = v38[v70]
        if v71.owner and evaluate_node(v71) then
            local v72 = v38.n
            while v71[1] do
                v72 += 1
                v38[v72] = v71[1]
                local v73 = v71[1]
                local parents = v73.parents
                for v74, v75 in parents do
                    local v76 = table.find(v75, v73)
                    local v77 = #v75
                    v75[v76] = v75[v77]
                    v75[v77] = nil
                    parents[v74] = nil
                end
            end
            v38.n = v72
        end
        v38[v70] = false
        v70 += 1
    end
    v38.n = n
end

local function push_child_to_scope(v78) -- line 233 | captures: v1
    local v79 = v1[v1.n]
    if not (v79 and v79.effect) then
        return
    end
    table.insert(v78, v79)
    local parents = v79.parents
    table.insert(parents, v78)
end

local function create_node(v80, v81, v82) -- line 240
    local v83 = {
        cleanups = false,
        context = false,
        owned = false,
        cache = v82,
        effect = v81,
        owner = v80,
        parents = {}
    }
    if v80 then
        if v80.owned then
            local owned = v80.owned
            table.insert(owned, v83)
            return v83
        end
        v80.owned = { v83 }
    end
    return v83
end

local function create_source_node(v84) -- line 265
    return { cache = v84 }
end

local function get_children(v85) -- line 269
    return { unpack(v85) }
end

local function set_context(v86, v87, v88) -- line 273
    if v86.context then
        v86.context[v87] = v88
    else
        v86.context = { [v87] = v88 }
    end
end

return table.freeze({
    push_scope = push_scope,
    pop_scope = pop_scope,
    evaluate_node = evaluate_node,
    get_scope = get_scope,
    assert_stable_scope = assert_stable_scope,
    push_cleanup = push_cleanup,
    destroy = destroy_2,
    flush_cleanups = flush_cleanups,
    push_child_to_scope = push_child_to_scope,
    update_descendants = update_descendants,
    push_child = push_child,
    create_node = create_node,
    create_source_node = create_source_node,
    get_children = get_children,
    flush_update_queue = flush_update_queue,
    get_update_queue_length = get_update_queue_length,
    set_context = set_context,
    scopes = v1
})
