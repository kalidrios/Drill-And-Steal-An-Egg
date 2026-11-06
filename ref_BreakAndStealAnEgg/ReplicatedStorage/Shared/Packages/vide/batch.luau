-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local flags = require(script.Parent.flags)
local throw = require(script.Parent.throw)
local graph = require(script.Parent.graph)

local function batch(v1) -- line 7 | captures: flags, throw, graph
    local batch = flags.batch
    local v2
    if batch then
    else
        flags.batch = true
        v2 = graph.get_update_queue_length()
    end
    local v3, v4 = pcall(v1)
    if not batch then
        flags.batch = false
        graph.flush_update_queue(v2)
    end
    if not v3 then
        throw((("error occured while batching updates: %*"):format(v4)))
    end
end

return batch
