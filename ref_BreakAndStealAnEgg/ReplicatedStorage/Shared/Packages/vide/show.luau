-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local switch = require(script.Parent.switch)

local function show(v1, v2, v3) -- line 5 | captures: switch
    local function truthy() -- line 6 | captures: v1
        return not not v1()
    end

    return switch(truthy)({
        [true] = v2,
        [false] = v3
    })
end

return show
