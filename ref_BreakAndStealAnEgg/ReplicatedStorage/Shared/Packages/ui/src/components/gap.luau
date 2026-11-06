-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local vide = require(script.Parent.Parent.Parent.roblox_packages.vide)
local create = vide.create
local read = vide.read
return function(v1) -- line 14 | captures: create, read
    return create("Frame")({
        Name = "gap",
        Size = function() -- Size | line 17 | captures: v1, read
            return UDim2.fromOffset(read(v1.w) or 0, read(v1.h) or 0)
        end,
        BackgroundTransparency = 1,
        unpack(v1)
    })
end
