-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local theme = require(script.Parent.Parent.theme)
local vide = require(script.Parent.Parent.Parent.roblox_packages.vide)
local create = vide.create
local read = vide.read
return function(v1) -- line 23 | captures: theme, create, read
    local TextLabel = create("TextLabel")

    local function Size() -- line 25 | captures: v1, read
        return UDim2.fromOffset(read(v1.w) or 0, read(v1.h) or 0)
    end

    local v2
    if not (v1.w and v1.h) then
        if v1.w then
            v2 = Enum.AutomaticSize.Y
        else
            v2 = Enum.AutomaticSize.X
        end
    end
    return TextLabel({
        Size = Size,
        AutomaticSize = v2,
        LayoutOrder = v1.order,
        Text = v1.text,
        TextSize = v1.text_size,
        TextColor3 = function() -- TextColor3 | line 36 | captures: v1, theme, read
            local text_style = v1.text_style
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
        FontFace = function() -- FontFace | line 45 | captures: v1, theme, read
            local v3 = theme.font()
            local v4 = read(v1.weight) or Enum.FontWeight.Regular
            return Font.new(v3.Family, v4)
        end,
        TextWrapped = v1.wrapped,
        TextXAlignment = v1.xalignment,
        LayoutOrder = v1.order,
        BackgroundTransparency = 1,
        unpack(v1)
    })
end
