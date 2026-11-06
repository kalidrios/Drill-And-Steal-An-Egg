-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local root = require(script.Parent.root)
local apply = require(script.Parent.apply)

local function mount(v1, v2) -- line 6 | captures: root, apply
    return root(function() -- line 7 | captures: v1, v2, apply
        local v3 = v1()
        if v2 then
            apply(v2, { v3 })
        end
    end)
end

return mount
