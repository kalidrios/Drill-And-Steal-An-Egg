-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Renderer = require(script.Renderer)
local Stencil = require(script.Stencil)
require(script.Types)
local v1 = {
    Utils = require(script.Utils),
    new = Stencil.new
}

function v1.getActive() -- line 27 | captures: Renderer
    return (Renderer.getAll())
end

function v1.destroyAll() -- line 31 | captures: v1
    for v2, v3 in v1.getActive() do
        v3:destroy()
    end
end

return v1
