-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local typeof_2 = game and typeof or (nil).typeof
local Instance_2 = game and Instance or (nil).Instance
local throw = require(script.Parent.throw)
local defaults = require(script.Parent.defaults)
local apply = require(script.Parent.apply)
local v1 = {}
local v2 = {}

function v2.__index(v3, v4) -- line 12 | captures: Instance_2, throw, defaults, apply
    local v5, v6 = pcall(Instance_2.new, v4)
    if not v5 then
        throw((("invalid class name, could not create instance of class %*"):format(v4)))
    end
    local v7 = defaults[v4]
    if v7 then
        for v8, v9 in next, v7 do
            v6[v8] = v9
        end
    end

    local function ctor(v10) -- line 23 | captures: v6, apply
        return apply(v6:Clone(), v10)
    end

    v3[v4] = ctor
    return ctor
end

setmetatable(v1, v2)

local function create_instance(v11) -- line 32 | captures: v1
    return v1[v11]
end

local function clone_instance(v12) -- line 36 | captures: throw, apply
    return function(v13) -- line 37 | captures: v12, throw, apply
        local v14 = v12:Clone()
        if not v14 then
            throw("attempt to clone a non-archivable instance")
        end
        return apply(v14, v13)
    end
end

local function create(v15) -- line 44 | captures: typeof_2, throw, apply, v1
    if type(v15) == "string" then
        return v1[v15]
    end
    if typeof_2(v15) == "Instance" then
        return function(v16) -- line 37 | captures: v15, throw, apply
            local v17 = v15:Clone()
            if not v17 then
                throw("attempt to clone a non-archivable instance")
            end
            return apply(v17, v16)
        end
    end
    throw("bad argument #1, expected string or instance, got " .. typeof_2(v15))
    return nil
end

return create
