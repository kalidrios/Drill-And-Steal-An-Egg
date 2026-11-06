-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local vide = require(script.Parent.Parent.Parent.roblox_packages.vide)
local create = vide.create
local read = vide.read
return function(v1) -- line 22 | captures: create, read
    local Frame = create("Frame")

    local function Size() -- line 24 | captures: v1, read
        return UDim2.fromOffset(read(v1.w) or 0, read(v1.h) or 0)
    end

    local function Position() -- line 27 | captures: v1, read
        return UDim2.new(read(v1.xs) or 0, read(v1.x) or 0, read(v1.ys) or 0, read(v1.y) or 0)
    end

    local v2
    if v1.anchor then
        function v2() -- line 36 | captures: v1, read
            return Vector2.new(read(v1.anchor)[1] or 0, read(v1.anchor)[2] or 0)
        end
    end
    return Frame({
        Size = Size,
        Position = Position,
        AnchorPoint = v2,
        AutomaticSize = v1.auto,
        LayoutOrder = v1.layout,
        ZIndex = v1.zindex,
        BackgroundTransparency = 1,
        unpack(v1)
    })
end
