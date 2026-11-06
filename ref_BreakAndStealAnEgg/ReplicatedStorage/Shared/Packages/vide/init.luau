-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    major = 0,
    minor = 3,
    patch = 1
}

if not game then
    script = nil
end
local root = require(script.root)
local mount = require(script.mount)
local create = require(script.create)
local apply = require(script.apply)
local source = require(script.source)
local effect = require(script.effect)
local derive = require(script.derive)
local cleanup = require(script.cleanup)
local untrack = require(script.untrack)
local read = require(script.read)
local batch = require(script.batch)
local context = require(script.context)
local switch = require(script.switch)
local show = require(script.show)
local v2, v3 = require(script.maps)()
local v4, v5 = require(script.spring)()
local v6 = require(script.action)()
local changed = require(script.changed)
local throw = require(script.throw)
local flags = require(script.flags)

local function step(v7) -- line 35 | captures: v5
    if game then
        debug.profilebegin("VIDE STEP")
        debug.profilebegin("VIDE SPRING")
    end
    v5(v7)
    if game then
        debug.profileend()
        debug.profileend()
    end
end

local game_2 = game
local v8 = game_2

if game_2 then
    v8 = game:GetService("RunService").Heartbeat:Connect(function(v9) -- line 49 | captures: step
        task.defer(step, v9)
    end)
end
local v10 = {
    strict = nil,
    version = v1,
    root = root,
    mount = mount,
    create = create,
    source = source,
    effect = effect,
    derive = derive,
    switch = switch,
    show = show,
    indexes = v2,
    values = v3,
    cleanup = cleanup,
    untrack = untrack,
    read = read,
    batch = batch,
    context = context,
    spring = v4,
    action = v6,
    changed = changed
}

function v10.apply(v11) -- line 86 | captures: apply
    return function(v12) -- line 87 | captures: v11, apply
        apply(v11, v12)
        return v11
    end
end

function v10.step(v13) -- line 94 | captures: v8, step
    if v8 then
        v8:Disconnect()
        v8 = nil
    end
    step(v13)
end

local v14 = {}

function v14.__index(v15, v16) -- line 104 | captures: throw, flags
    if v16 == "strict" then
        return flags.strict
    end
    throw((("%* is not a valid member of vide"):format((tostring(v16)))))
end

function v14.__newindex(v17, v18, v19) -- line 112 | captures: throw, flags
    if v18 == "strict" then
        flags.strict = v19
    else
        throw((("%* is not a valid member of vide"):format((tostring(v18)))))
    end
end

setmetatable(v10, v14)
return v10
