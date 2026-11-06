-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local background = require(script.Parent.background)
local container = require(script.Parent.container)
local flex = require(script.Parent.flex)
require(script.Parent.Parent.Parent.roblox_packages.language)
local padding = require(script.Parent.padding)
local text = require(script.Parent.text)
local vide = require(script.Parent.Parent.Parent.roblox_packages.vide)
local show = vide.show
local indexes = vide.indexes
local source = vide.source
local effect = vide.effect
return function(v1) -- line 50 | captures: background, container, flex, padding, text, show, indexes, source, effect
    local v2 = source(v1.selected())
    effect(function() -- line 53 | captures: v1, v2
        local v3 = v1.selected()
        local v4 = v2()
        local v5 = v2() + 10 - 1
        if v5 < v3 then
            local v6 = v3 - v5
            v2(v2() + v6)
        elseif v3 < v4 then
            local v7 = v3 - v4
            v2(v2() + v7)
        end
    end)
    local x = v1.x
    local y = v1.y
    local v8 = { 0, 1 }
    local v9 = flex():vertical("bottom"):column():gap(4)

    local function v10() -- line 79 | captures: v1
        return #v1.result().suggestions > 0
    end

    local v11 = show(v10, function() -- line 79 | captures: v1, v2, background, flex, padding, text, indexes
        return background({
            ys = 1,
            w = 200,
            h = 0,
            anchor = { 0, 1 },
            auto = Enum.AutomaticSize.Y,
            transparency = 0,
            flex():vertical("bottom"):layout(),
            indexes(function() -- line 92 | captures: v1, v2
                local v12 = {}
                local v13 = v2()
                local v14 = v2() + 10 - 1
                for v15 = v13, v14 do
                    v12[v15 - v2() + 1] = v1.suggestions()[v15]
                end
                return v12
            end, function(v16, v17) -- line 99 | captures: v1, v2, padding, text
                local Left = Enum.TextXAlignment.Left

                local function text_2() -- line 107 | captures: v16
                    return v16().display
                end

                return text({
                    w = 200,
                    h = 20,
                    order = v17,
                    text_size = 16,
                    xalignment = Left,
                    text = text_2,
                    text_style = function() -- text_style | line 108 | captures: v17, v1, v2
                        if v17 == v1.selected() - v2() + 1 then
                            return "info"
                        end
                        return "normal"
                    end,
                    padding({ left = 4 })
                })
            end)
        })
    end)

    local function v18() -- line 123 | captures: v1
        return v1.result().additional_info
    end

    return container({
        x = x,
        y = y,
        w = 300,
        auto = "Y",
        anchor = v8,
        zindex = 10000,
        v9,
        v11,
        show(v18, function() -- line 123 | captures: v1, background, flex, padding, text
            local function v19() -- line 124 | captures: v1
                return v1.result().additional_info or {}
            end

            local Y = Enum.AutomaticSize.Y
            local v20 = flex()
            local v21 = background({
                w = 300,
                h = 24,
                flex():column():between("horizontal"):vertical("center"),
                padding({ x = 4 }),
                text({
                    text_size = 20,
                    text = function() -- text | line 147 | captures: v1
                        return (v1.result().additional_info or {}).name or ""
                    end,
                    weight = Enum.FontWeight.Bold
                }),
                text({
                    text_size = 18,
                    text = function() -- text | line 153 | captures: v1
                        local type = (v1.result().additional_info or {}).type
                        local v22 = if (v1.result().additional_info or {}).optional then "?" else ""
                        return ("%*%*"):format(type, v22) or ""
                    end,
                    weight = Enum.FontWeight.Light
                })
            })
            local v23 = { (padding({ padding = 4 })) }
            v23.w = 300
            v23.wrapped = true
            v23.text_size = 16
            v23.xalignment = Enum.TextXAlignment.Left

            function v23.text() -- line 169 | captures: v1
                local v24 = v1.result()
                return v24.additional_info and v24.additional_info.description or ""
            end

            return background({
                w = 300,
                layout = 10,
                auto = Y,
                transparency = 0,
                v20,
                v21,
                text(v23)
            })
        end)
    })
end
