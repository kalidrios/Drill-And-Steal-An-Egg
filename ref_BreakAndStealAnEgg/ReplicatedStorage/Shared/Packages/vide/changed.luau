-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

if not game then
    script = nil
end
local v1 = require(script.Parent.action)()
local cleanup = require(script.Parent.cleanup)

local function changed(v2, v3) -- line 6 | captures: v1, cleanup
    return v1(function(v4) -- line 7 | captures: v2, v3, cleanup
        local v5 = v4:GetPropertyChangedSignal(v2):Connect(function() -- line 8 | captures: v4, v2, v3
            v3(v4[v2])
        end)
        cleanup(function() -- line 12 | captures: v5
            v5:Disconnect()
        end)
        v3(v4[v2])
    end)
end

return changed
