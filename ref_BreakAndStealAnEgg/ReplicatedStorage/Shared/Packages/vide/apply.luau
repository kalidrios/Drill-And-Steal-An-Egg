-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local typeof_2 = game and typeof or (nil).typeof
local Vector2_2 = game and Vector2 or (nil).Vector2
local UDim2_2 = game and UDim2 or (nil).UDim2
local flags = require(script.Parent.flags)
local throw = require(script.Parent.throw)
local bind = require(script.Parent.bind)
local v1, v2 = require(script.Parent.action)()
require(script.Parent.graph)
local v3

local function borrow_caches() -- line 43 | captures: v3
    if v3 then
        local v4 = v3
        v3 = nil
        return v4
    end
    local v5 = {
        events = {}
    }
    local v6 = {}
    local v7 = {
        __index = function(v8, v9) -- __index | line 52
            v8[v9] = {}
            return v8[v9]
        end
    }
    v5.actions = setmetatable(v6, v7)
    local v10 = {}
    local v11 = {
        __index = function(v12, v13) -- __index | line 55
            v12[v13] = {}
            return v12[v13]
        end
    }
    v5.nested_debug = setmetatable(v10, v11)
    v5.nested_stack = {}
    return v5
end

local function return_caches(v14) -- line 62 | captures: v3
    v3 = v14
end

local v15 = {}
for v16, v17 in {
        CFrame = CFrame,
        Color3 = Color3,
        UDim = UDim,
        UDim2 = UDim2_2,
        Vector2 = Vector2_2,
        Vector3 = Vector3,
        Rect = Rect
    } do
    v15[v16] = v17.new
end

local function apply(v18, v19) -- line 81 | captures: v3, typeof_2, flags, throw, bind, v2, borrow_caches, v15
    if not v19 then
        throw("attempt to call a constructor returned by create() with no properties")
    end
    local strict = flags.strict
    local Parent = v19.Parent
    local v20 = borrow_caches()
    local events = v20.events
    local actions = v20.actions
    local nested_debug = v20.nested_debug
    local nested_stack = v20.nested_stack
    local v21 = v19
    local v22 = 1
    while true do
        for v23, v24 in v21 do
            if v23 ~= "Parent" then
                if type(v23) == "string" then
                    if strict then
                        if nested_debug[v22][v23] then
                            throw((("duplicate property %* at depth %*"):format(v23, v22)))
                        end
                        nested_debug[v22][v23] = true
                    end
                    if type(v24) == "table" then
                        local v25 = v15[typeof_2(v18[v23])]
                        if v25 == nil then
                            throw((("cannot aggregate type %* for property %*"):format(typeof_2(v24), v23)))
                        end
                        v18[v23] = v25(unpack(v24))
                    elseif type(v24) == "function" then
                        if typeof_2(v18[v23]) == "RBXScriptSignal" then
                            events[v23] = v24
                        else
                            bind.property(v18, v23, v24)
                        end
                    else
                        v18[v23] = v24
                    end
                elseif type(v23) == "number" then
                    if type(v24) == "function" then
                        bind.children(v18, v24)
                    elseif type(v24) == "table" then
                        if v2(v24) then
                            local v26 = actions[v24.priority]
                            local callback = v24.callback
                            table.insert(v26, callback)
                        else
                            table.insert(nested_stack, v24)
                            local v27 = v22 + 1
                            table.insert(nested_stack, v27)
                        end
                    else
                        v24.Parent = v18
                    end
                end
            end
        end
        v22 = table.remove(nested_stack)
        v21 = table.remove(nested_stack)
        if v21 then
            continue
        end
        break
    end
    for v28, v29 in next, events do
        v18[v28]:Connect(v29)
    end
    for v30, v31 in next, actions do
        for v32, v33 in next, v31 do
            v33(v18)
        end
    end
    if Parent then
        if type(Parent) == "function" then
            bind.parent(v18, Parent)
        else
            v18.Parent = Parent
        end
    end
    table.clear(events)
    for v34, v35 in next, actions do
        table.clear(v35)
    end
    if strict then
        table.clear(nested_debug)
    end
    table.clear(nested_stack)
    v3 = v20
    return v18
end

return apply
