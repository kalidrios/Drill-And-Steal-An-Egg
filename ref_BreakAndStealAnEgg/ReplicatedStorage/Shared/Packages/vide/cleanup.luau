-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local typeof_2 = game and typeof or (nil).typeof
local throw = require(script.Parent.throw)
local graph = require(script.Parent.graph)
local get_scope = graph.get_scope
local push_cleanup = graph.push_cleanup

local function helper(v1) -- line 9 | captures: typeof_2, throw
    if typeof_2(v1) == "RBXScriptConnection" then
        return function() -- line 11 | captures: v1
            v1:Disconnect()
        end
    end
    if typeof_2(v1) == "Instance" then
        return function() -- line 12 | captures: v1
            v1:Destroy()
        end
    end
    if v1.destroy then
        return function() -- line 13 | captures: v1
            v1:destroy()
        end
    end
    if v1.disconnect then
        return function() -- line 14 | captures: v1
            v1:disconnect()
        end
    end
    if v1.Destroy then
        return function() -- line 15 | captures: v1
            v1:Destroy()
        end
    end
    if v1.Disconnect then
        return function() -- line 16 | captures: v1
            v1:Disconnect()
        end
    end
    return (throw("cannot cleanup given object"))
end

local function cleanup(v2) -- line 20 | captures: throw, get_scope, push_cleanup, helper
    local v3 = get_scope()
    if not v3 then
        throw("cannot cleanup outside a stable or reactive scope")
    end
    assert(v3)
    if type(v2) == "function" then
        push_cleanup(v3, v2)
    else
        push_cleanup(v3, (helper(v2)))
    end
end

return cleanup
