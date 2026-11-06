-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local theme = require(script.Parent.Parent.theme)
local vide = require(script.Parent.Parent.Parent.roblox_packages.vide)
local create = vide.create
local source = vide.source
local effect = vide.effect
local changed = vide.changed
local read = vide.read
return function(v1) -- line 30 | captures: theme, create, source, effect, changed, read
    local v2 = source("")
    local TextBox = create("TextBox")

    local function Size() -- line 33 | captures: v1, read
        return UDim2.fromOffset(read(v1.w) or 0, read(v1.h) or 0)
    end

    local XY = Enum.AutomaticSize.XY
    local text = v1.text
    local placeholder = v1.placeholder
    local v3 = v1.text_size or 16
    local text_2 = theme.text
    local xalignment = v1.xalignment
    local multiline = v1.multiline
    local font = theme.font
    local v4
    if v1.update_text then
        v4 = changed("Text", v1.update_text)
    end
    local v5 = changed("Text", v2)
    local v6 = TextBox({
        Size = Size,
        AutomaticSize = XY,
        Text = text,
        PlaceholderText = placeholder,
        TextSize = v3,
        TextColor3 = text_2,
        TextXAlignment = xalignment,
        MultiLine = multiline,
        FontFace = font,
        BackgroundTransparency = 1,
        Focused = function() -- Focused | line 51 | captures: v1
            if v1.update_focused then
                v1.update_focused(true)
            end
        end,
        FocusLost = function(v7) -- FocusLost | line 56 | captures: v1, v2
            if v1.update_focused then
                v1.update_focused(false)
            end
            if v7 and v1.focused then
                v1.enter(v2())
            end
        end,
        v4,
        v5,
        unpack(v1)
    })
    effect(function() -- line 66 | captures: v1, v6, read
        local v8 = read(v1.focused)
        if v6:IsFocused() ~= v8 then
            task.defer(function() -- line 69 | captures: v8, v6
                if v8 then
                    v6:CaptureFocus()
                else
                    v6:ReleaseFocus(false)
                end
            end)
        end
    end)
    return v6
end
