-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local theme = require(script.Parent.Parent.theme)
local vide = require(script.Parent.Parent.Parent.roblox_packages.vide)
local create = vide.create
local read = vide.read
return function(v1) -- line 25 | captures: theme, create, read
    local Frame = create("Frame")

    local function Size() -- line 27 | captures: v1, read
        local v2 = read(v1.w)
        local v3 = read(v1.h)
        local new = UDim2.new
        local v4 = if v2 then 0 else 1
        local v5 = v2 or 0
        local v6 = if v3 then 0 else 1
        return new(v4, v5, v6, v3 or 0)
    end

    local function Position() -- line 36 | captures: v1, read
        return UDim2.new(read(v1.xs) or 0, read(v1.x) or 0, read(v1.ys) or 0, read(v1.y) or 0)
    end

    local v7
    if v1.anchor then
        function v7() -- line 45 | captures: v1, read
            return Vector2.new(read(v1.anchor)[1] or 0, read(v1.anchor)[2] or 0)
        end
    end
    return Frame({
        Size = Size,
        Position = Position,
        AnchorPoint = v7,
        AutomaticSize = v1.auto,
        LayoutOrder = v1.layout,
        BackgroundColor3 = v1.color or theme.background,
        BackgroundTransparency = v1.transparency or theme.background_transparency,
        unpack(v1)
    })
end
