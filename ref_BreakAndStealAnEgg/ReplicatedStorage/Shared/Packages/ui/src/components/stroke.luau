-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local theme = require(script.Parent.Parent.theme)
local create = require(script.Parent.Parent.Parent.roblox_packages.vide).create
return function(v1) -- line 13 | captures: theme, create
    return create("UIStroke")({
        Thickness = v1.thickness,
        Color = theme.stroke,
        unpack(v1)
    })
end
