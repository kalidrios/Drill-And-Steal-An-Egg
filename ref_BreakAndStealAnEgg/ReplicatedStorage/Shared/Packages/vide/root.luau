-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local throw = require(script.Parent.throw)
local graph = require(script.Parent.graph)
local create_node = graph.create_node
local push_scope = graph.push_scope
local pop_scope = graph.pop_scope
local destroy = graph.destroy
local v1 = {}

local function root(v2) -- line 13 | captures: throw, create_node, push_scope, pop_scope, destroy, v1
    local v3 = create_node(false, false, false)
    v1[v3] = true

    local function v4() -- line 18 | captures: v3, throw, destroy, v1
        if not v1[v3] then
            throw("root already destroyed")
        end
        v1[v3] = nil
        destroy(v3)
    end

    push_scope(v3)

    local function efn(v5) -- line 26
        return debug.traceback(v5, 3)
    end

    local v6 = { xpcall(v2, efn, v4) }
    pop_scope()
    if not v6[1] then
        if not v1[v3] then
            throw("root already destroyed")
        end
        v1[v3] = nil
        destroy(v3)
        throw((("error while running root():\n\n%*"):format(v6[2])))
    end
    return v4, unpack(v6, 2)
end

return root
