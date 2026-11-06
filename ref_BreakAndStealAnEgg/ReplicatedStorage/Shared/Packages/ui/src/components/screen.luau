-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local create = require(script.Parent.Parent.Parent.roblox_packages.vide).create
return function(v1) -- line 14 | captures: create
    return create("ScreenGui")({
        Name = v1.name,
        Enabled = v1.enabled,
        DisplayOrder = v1.display_order,
        unpack(v1)
    })
end
