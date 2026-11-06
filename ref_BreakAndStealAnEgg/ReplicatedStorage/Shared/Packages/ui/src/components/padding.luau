-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local create = require(script.Parent.Parent.Parent.roblox_packages.vide).create

local function padding(v1) -- line 16 | captures: create
    local v2 = v1.padding or 0
    local v3 = v1.x or v2
    local v4 = v1.y or v2
    local v5 = v1.left or v3
    local v6 = v1.right or v3
    local v7 = v1.top or v4
    local v8 = v1.bottom or v4
    return create("UIPadding")({
        PaddingLeft = UDim.new(0, v5),
        PaddingRight = UDim.new(0, v6),
        PaddingTop = UDim.new(0, v7),
        PaddingBottom = UDim.new(0, v8)
    })
end

return padding
