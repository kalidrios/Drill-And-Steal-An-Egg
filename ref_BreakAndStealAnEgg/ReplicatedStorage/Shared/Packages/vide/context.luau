-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local throw = require(script.Parent.throw)
local graph = require(script.Parent.graph)
local create_node = graph.create_node
local get_scope = graph.get_scope
local push_scope = graph.push_scope
local pop_scope = graph.pop_scope
local set_context = graph.set_context
local v1 = newproxy()
local v2 = 0

local function context(...) -- line 17 | captures: v2, throw, create_node, get_scope, push_scope, pop_scope, set_context, v1
    v2 += 1
    local v3 = v2
    local v4 = select("#", ...) > 0
    local v5 = ...
    return function(...) -- line 24 | captures: v3, v5, v4, throw, create_node, get_scope, push_scope, pop_scope, set_context, v1
        local v6 = get_scope()
        if select("#", ...) == 0 then
            while v6 do
                local context = v6.context
                if context then
                    local v7 = context[v3]
                    if v7 == nil then
                        v6 = v6.owner
                    else
                        if v7 == v1 then
                            return nil
                        end
                        return v7
                    end
                else
                    v6 = v6.owner
                end
            end
            if v4 == nil then
                throw("attempt to get context when no context is set and no default context is set")
                return nil
            end
            return v5
        end
        if v6 then
            local v8, v9 = ...
            local v10 = create_node(v6, false, false)
            if v8 == nil then
                v8 = v1
            end
            set_context(v10, v3, v8)
            push_scope(v10)

            local function efn(v11) -- line 61
                return debug.traceback(v11, 3)
            end

            local v12, v13 = xpcall(v9, efn)
            pop_scope()
            if not v12 then
                throw((("error while running context:\n\n%*"):format(v13)))
            end
            return v13
        end
        return throw("attempt to set context outside of a vide scope")
    end
end

return context
