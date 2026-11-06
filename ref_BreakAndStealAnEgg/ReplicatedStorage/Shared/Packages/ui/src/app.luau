-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local background = require(script.Parent.components.background)
local conch = require(script.Parent.Parent.roblox_packages.conch)
local corner = require(script.Parent.components.corner)
local flex = require(script.Parent.components.flex)
local gap = require(script.Parent.components.gap)
local language = require(script.Parent.Parent.roblox_packages.language)
local levenshtein_distance = require(script.Parent.levenshtein_distance)
local loading = require(script.Parent.components.loading)
local padding = require(script.Parent.components.padding)
local screen = require(script.Parent.components.screen)
local state = require(script.Parent.state)
local suggestion = require(script.Parent.components.suggestion)
local text = require(script.Parent.components.text)
local textbox = require(script.Parent.components.textbox)
local theme = require(script.Parent.theme)
local vide = require(script.Parent.Parent.roblox_packages.vide)
local source = vide.source
local derive = vide.derive
local show = vide.show
local changed = vide.changed
local effect = vide.effect
local cleanup = vide.cleanup
local indexes = vide.indexes
local v1 = ("conch-ui 0.3.1\tconch-language %*\tconch %*"):format(language.version, language.version)
local v2 = 0
local v3 = {}
return function() -- line 36 | captures: v2, TextService, UserInputService, background, conch, corner, flex, gap, levenshtein_distance, loading, padding, screen, state, suggestion, text, textbox, theme, vide, source, derive, show, changed, effect, cleanup, indexes, v1, v3
    local function output(v4) -- line 37 | captures: state
        for v5, v6 in (string.split(v4.text, "\n")) do
            local v7 = state.logs()
            local v8 = {
                kind = v4.kind,
                text = v6
            }
            table.insert(v7, 1, v8)
            table.remove(v7, 100)
            state.logs(v7)
        end
    end

    conch.console.output = output
    for v9, v10 in string.split(v1, "\n") do
        output({
            kind = "normal",
            text = v10
        })
    end
    output({
        kind = "warn",
        text = "If you got here accidentally, run the `close-ui` command to close this UI."
    })
    conch.register("clear", {
        description = "Clears the console.",
        permissions = {},
        arguments = function() -- arguments | line 62
        end,
        callback = function() -- callback | line 63 | captures: state
            state.logs({})
        end
    })
    conch.register("close-ui", {
        description = "Close the CLI",
        permissions = {},
        arguments = function() -- arguments | line 69
        end,
        callback = function() -- callback | line 70 | captures: state
            state.opened(false)
            state.focused(false)
        end
    })
    local v11 = source("")
    local v12 = source(false)
    local v13 = source(0)
    local v14 = source(Vector2.zero)
    local v15 = source(conch.analyze("", 0))
    local v16 = source(1)
    effect(function() -- line 85 | captures: v15, v16
        local v17 = v16()
        local v18 = #v15().suggestions
        local v19 = math.max(1, v18)
        v16((math.clamp(v17, 1, v19)))
    end)
    local v20 = false
    effect(function() -- line 97 | captures: v20, v11, v13, v15, conch
        v11()
        v13()
        if not v20 then
            v20 = true
            task.defer(function() -- line 103 | captures: v20, v11, v13, v15, conch
                v20 = false
                v15(conch.analyze(v11(), v13() - 1))
            end)
        end
    end)
    local v21 = derive(function() -- line 110 | captures: v11, v13
        local v22 = v11()
        local v23 = v13() - 1
        return (string.sub(v22, 1, v23))
    end)
    local v24 = source((Vector3.new(0, 0, 0)))
    local GetTextBoundsParams = Instance.new("GetTextBoundsParams")
    GetTextBoundsParams.Font = theme.font()
    GetTextBoundsParams.RichText = false
    GetTextBoundsParams.Size = 20
    GetTextBoundsParams.Width = 100000
    effect(function() -- line 121 | captures: v21, v24, GetTextBoundsParams, TextService
        local v25 = v21()
        GetTextBoundsParams.Text = v25
        task.spawn(function() -- line 124 | captures: v25, v21, v24, GetTextBoundsParams, TextService
            local v26 = TextService:GetTextBoundsAsync(GetTextBoundsParams)
            if v25 == v21() then
                v24(v26)
            end
        end)
    end)

    local function autofill(v27, v28, v29) -- line 131 | captures: v13
        local x = v28.x
        local v30 = string.sub(v27, 1, x)
        local v31 = v28.y + 1
        local v32 = string.sub(v27, v31, -1)
        task.defer(v13, v28.x + #v29 + 2)
        return v30 .. v29 .. " " .. v32
    end

    local InputBegan = UserInputService.InputBegan
    cleanup(InputBegan:Connect(function(v33) -- line 139 | captures: v11, v13, v15, v16, v2, v3
        local v34 = v15()
        if v33.KeyCode == Enum.KeyCode.Down then
            if #v34.suggestions == 0 then
                if v2 == 0 then
                    v3[v2] = v11()
                end
                local v35 = v2 - 1
                local v36 = #v3
                v2 = math.clamp(v35, 0, v36)
                v11(v3[v2] or "")
                v13(#v11() + 1)
            else
                local v37 = v16() + 1
                local v38 = #v34.suggestions
                v16((math.min(v37, v38)))
            end
        elseif v33.KeyCode == Enum.KeyCode.Up then
            if #v34.suggestions == 0 then
                if v2 == 0 then
                    v3[v2] = v11()
                end
                local v39 = v2 + 1
                local v40 = #v3
                v2 = math.clamp(v39, 0, v40)
                v11(v3[v2] or "")
                v13(#v11() + 1)
            else
                local v41 = v16() - 1
                v16((math.max(1, v41)))
            end
        end
    end))
    local v42 = derive(function() -- line 170 | captures: v11, v13, v15, levenshtein_distance
        local v43 = v15()
        local v44 = v43 and v43.suggestions
        if v44 then
            local v45 = {}
            local v46 = v11()
            local v47 = v43.replace.x + 1
            local v48 = v13() - 1
            local v49 = string.sub(v46, v47, v48)
            local v50 = string.gsub(v49, "\"(.*)\"", "%1", 1)
            local v51 = string.gsub(v50, "'(.*)'", "%1", 1)
            for v52, v53 in v44 do
                if string.find(v53.display, string.gsub(v51, "^%s", ""), 0, true) then
                    local v54 = levenshtein_distance(v51, v53.display)
                    if v54 ~= (-1/0) then
                        local v55 = {
                            suggestion = v53,
                            score = v54
                        }
                        table.insert(v45, v55)
                    end
                end
            end
            table.sort(v45, function(v56, v57) -- line 207
                return v56.score < v57.score
            end)
            local v58 = {}
            for v59, v60 in v45 do
                local suggestion = v60.suggestion
                table.insert(v58, suggestion)
            end
            return v58
        end
        return {}
    end)
    local v61 = false
    local opened = state.opened
    local bottom = flex():fill("horizontal"):vertical("bottom")
    local v62 = padding({ padding = 12 })
    local v63 = show(v15, function() -- line 228 | captures: v14, v15, v16, v21, v24, v42, suggestion, vide
        return vide.create("Folder")({
            suggestion({
                x = function() -- x | line 231 | captures: v21
                    local v64 = string.split(v21(), "\n")
                    return #v64[#v64] * 10 + 10
                end,
                y = function() -- y | line 235 | captures: v14, v24
                    return v24().Y + v14().Y - 20
                end,
                selected = v16,
                analysis = v15,
                suggestions = v42,
                result = v15
            })
        })
    end)
    local v65 = flex()
    local v66 = corner(4)
    local v67 = padding({ y = 4 })
    local v68 = background({
        auto = "Y",
        v65,
        v66,
        v67,
        indexes(function() -- line 258 | captures: v15
            return v15().issues
        end, function(v69, v70) -- line 259 | captures: padding, text
            local v71 = 0 - v70 + 100
            return text({
                order = v71,
                h = 20,
                text = function() -- text | line 264 | captures: v69
                    return (("%* at %*:%*:%*"):format(v69().why, v69().span.x, v69().span.y, v69().span.z))
                end,
                text_size = 16,
                text_style = "error",
                xalignment = Enum.TextXAlignment.Left,
                padding({ x = 8 })
            })
        end),
        indexes(state.logs, function(v72, v73) -- line 276 | captures: padding, text
            local v74 = -v73 - 1

            local function text_2() -- line 281 | captures: v72
                return v72().text
            end

            return text({
                h = 20,
                order = v74,
                text = text_2,
                text_size = 16,
                text_style = function() -- text_style | line 283 | captures: v72
                    return v72().kind
                end,
                xalignment = Enum.TextXAlignment.Left,
                padding({ x = 8 })
            })
        end)
    })
    local v75 = gap({ h = 4 })
    local Y = Enum.AutomaticSize.Y
    local v76 = corner(4)

    local function v77() -- line 299 | captures: loading
        return loading({
            h = 18,
            speed = 6,
            text_size = 18,
            xalignment = Enum.TextXAlignment.Left
        })
    end

    return screen({
        name = "Command Executor",
        display_order = 100000,
        enabled = opened,
        bottom,
        v62,
        v63,
        v68,
        v75,
        background({
            auto = Y,
            v76,
            show(v12, v77, function() -- line 307 | captures: v61, v11, v12, v13, v15, v16, v42, v2, conch, state, textbox, changed, v3
                return textbox({
                    text = v11,
                    update_text = function(v78) -- update_text | line 310 | captures: v61, v11, v13, v15, v16, v42
                        local v79 = v61 or v13()
                        local v80 = v79 - 1
                        local v81 = v79 - 1
                        local v82 = string.sub(v78, v80, v81)
                        local v83 = v42()[v16()]
                        local v84
                        if v82 == "\t" and v83 then
                            local v85 = v11()
                            local replace = v15().replace
                            local text = v83.text
                            local x = replace.x
                            local v86 = string.sub(v85, 1, x)
                            local v87 = replace.y + 1
                            local v88 = string.sub(v85, v87, -1)
                            task.defer(v13, replace.x + #text + 2)
                            v84 = v86 .. text .. " " .. v88
                        else
                            v84 = v78
                        end
                        v11(v84)
                    end,
                    placeholder = "Enter your command",
                    text_size = 18,
                    xalignment = Enum.TextXAlignment.Left,
                    enter = function(v89) -- enter | line 334 | captures: v11, v12, v2, conch, state, v3
                        v2 = 0
                        table.insert(v3, 1, v89)
                        v11("")
                        state.focused(true)
                        v12(true)
                        conch.execute(v89)
                        v12(false)
                    end,
                    focused = state.focused,
                    update_focused = state.focused,
                    {
                        CursorPosition = v13,
                        changed("CursorPosition", function(v90) -- line 350 | captures: v61, v13
                            if v61 then
                                v61 = v90
                            else
                                v61 = v90
                                task.defer(function() -- line 358 | captures: v61, v13
                                    v13(v61)
                                    v61 = false
                                end)
                            end
                        end)
                    }
                })
            end),
            padding({
                x = 8,
                y = 8
            }),
            flex():fill():vertical("center"):horizontal("left"),
            changed("AbsolutePosition", v14)
        })
    })
end
