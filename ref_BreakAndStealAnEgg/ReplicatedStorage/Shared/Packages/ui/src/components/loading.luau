-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local theme = require(script.Parent.Parent.theme)
local vide = require(script.Parent.Parent.Parent.roblox_packages.vide)
local create = vide.create
local source = vide.source
local cleanup = vide.cleanup
local read = vide.read
local v1 = { "-", "/", "|", "\\" }
return function(v2) -- line 34 | captures: theme, create, source, cleanup, read, v1
    local v3 = source(0)
    local v4 = task.spawn(function() -- line 36 | captures: v3
        while true do
            v3(v3() + task.wait())
        end
    end)
    cleanup(function() -- line 42 | captures: v4
        task.cancel(v4)
    end)
    local TextLabel = create("TextLabel")

    local function Size() -- line 45 | captures: v2, read
        local v5 = read(v2.w)
        local v6 = read(v2.h)
        return UDim2.new(0, v5 or 0, 0, v6 or 0)
    end

    local function Position() -- line 49 | captures: v2, read
        return UDim2.new(read(v2.xs) or 0, read(v2.x) or 0, read(v2.ys) or 0, read(v2.y) or 0)
    end

    local v7
    if v2.anchor then
        function v7() -- line 58 | captures: v2, read
            return Vector2.new(read(v2.anchor)[1] or 0, read(v2.anchor)[2] or 0)
        end
    end
    return TextLabel({
        Size = Size,
        Position = Position,
        AnchorPoint = v7,
        AutomaticSize = v2.auto,
        LayoutOrder = v2.layout,
        BackgroundTransparency = 1,
        Text = function() -- Text | line 70 | captures: v2, v3, v1
            return (("%* - %*\ts"):format(v1[v3() * v2.speed // 1 % 4 + 1], v3() * 100 // 1 / 100))
        end,
        TextSize = v2.text_size,
        TextColor3 = v2.color or function() -- line 74 | captures: v2, theme, read
            local text_style = v2.text_style
            if read(text_style) ~= "normal" then
                if read(text_style) == "warn" then
                    return (theme.text_warn())
                end
                if read(text_style) == "error" then
                    return (theme.text_error())
                end
                if read(text_style) == "info" then
                    return (theme.text_info())
                end
            end
            return (theme.text())
        end,
        FontFace = function() -- FontFace | line 83 | captures: v2, theme, read
            local v8 = theme.font()
            local v9 = read(v2.weight) or Enum.FontWeight.Regular
            return Font.new(v8.Family, v9)
        end,
        TextWrapped = v2.wrapped,
        TextXAlignment = v2.xalignment,
        BackgroundTransparency = 1,
        unpack(v2)
    })
end
