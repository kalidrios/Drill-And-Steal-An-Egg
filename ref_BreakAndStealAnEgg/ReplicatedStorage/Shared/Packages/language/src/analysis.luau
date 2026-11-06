-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ast = require(script.Parent.ast)
require(script.Parent.treewalker)

local function span_cursor(v1, v2) -- line 91
    if v1.cursor < v2.x then
        return "before"
    end
    local cursor = v1.cursor
    if v2.y < cursor then
        return "after"
    end
    return "within"
end

local v3 = newproxy()
local v4 = {
    a = "\007",
    b = "\008",
    f = "\012",
    n = "\n",
    r = "\r",
    t = "\t",
    v = "\011",
    ["\\"] = "\\",
    ["'"] = "'",
    ["\""] = "\""
}

local function get_value(v5) -- line 117 | captures: v3, v4
    if v5.kind == "number" then
        local text = v5.text
        return tonumber(text) or v3
    end
    if v5.kind == "string" then
        local text = v5.text
        local v6 = string.sub(text, 2, -2)
        local v7 = string.gsub(v6, "\\([0-9][0-9]?[0-9]?)", function(v8) -- line 127
            local v9 = tonumber(v8)
            assert(v9)
            return (string.char(v9))
        end)
        for v10, v11 in v4 do
            v7 = string.gsub(v7, ("\\%*"):format(v10), v11)
        end
        return v7
    end
    if v5.kind == "identifier" then
        return v5.text
    end
    if v5.kind == "true" then
        return true
    end
    if v5.kind == "false" then
        return false
    end
    if v5.kind == "nil" then
        return nil
    end
    return v3
end

local function char(v12) -- line 152
    return string.byte(v12)
end

local function is_start_ident_char(v13) -- line 154
    if v13 >= 97 and v13 <= 122 or v13 >= 65 and v13 <= 90 or v13 == 64 then
        return true
    end
    return v13 == 95
end

local function is_digit_char(v14) -- line 161
    if v14 >= 48 then
        return v14 <= 57
    end
    return false
end

local function is_ident_char(v15) -- line 165 | captures: is_start_ident_char
    local v16 = is_start_ident_char(v15)
    if not v16 then
        if v15 == 45 then
            v16 = true
        elseif v15 >= 48 then
            v16 = v15 <= 57
        else
            v16 = false
        end
    end
    return v16
end

local function is_identifier(v17) -- line 169 | captures: is_start_ident_char
    if is_start_ident_char(string.byte(v17, 1, 1)) then
        local v18 = #v17
        for v19 = 2, v18 do
            local v20 = string.byte(v17, v19, v19)
            local v21 = is_start_ident_char(v20)
            if not v21 then
                if v20 == 45 then
                    v21 = true
                elseif v20 >= 48 then
                    v21 = v20 <= 57
                else
                    v21 = false
                end
            end
            if not v21 then
                return false
            end
        end
        return true
    end
    return false
end

local function wrap_if_necessary(v22) -- line 180 | captures: is_identifier
    if is_identifier(v22) then
        return v22
    end
    return string.format("%q", v22)
end

local evaluate_expression

local function evaluate_expression_2(v23) -- line 188 | captures: v3, get_value, evaluate_expression
    if v23.kind == "boolean" then
        return (get_value(v23.token))
    end
    if v23.kind == "evaluate" then
        if v23.command.value then
            return evaluate_expression(v23.command.value)
        end
    else
        if v23.kind == "nil" then
            return (get_value(v23.token))
        end
        if v23.kind == "number" then
            return (get_value(v23.token))
        end
        if v23.kind == "string" then
            return (get_value(v23.token))
        end
        if v23.kind == "unary" and v23.value then
            local v24 = evaluate_expression(v23.value)
            if v23.operator.kind == "!" then
                return not v24
            end
            if v23.operator.kind == "-" then
                local v25, v26 = pcall(function() -- line 209 | captures: v24
                    return -v24
                end)
                if v25 then
                    return v26
                end
            end
        end
    end
    return v3
end

evaluate_expression = evaluate_expression_2
local v27 = ast.visit.create_visitor()

local function visit_var_root(v28, v29) -- line 222
    local span = v29.span
    local v30
    if v28.cursor < span.x then
        v30 = "before"
    else
        local cursor = v28.cursor
        if span.y < cursor then
            v30 = "after"
        else
            v30 = "within"
        end
    end
    if v30 ~= "within" then
        return
    end
    local span_2 = v29.span
    local v31 = {}
    local v32
    if v29.kind == "global" then
        local v33
        for v34 in v28.globals do
            if v29.token.text == v34 then
                local v35 = v28.vm.global_metadata[v29.token.text]
                v33 = {
                    type = "",
                    optional = false,
                    name = v35.name,
                    description = v35.description
                }
            end
            local v36 = {
                text = v34,
                display = v34
            }
            table.insert(v31, v36)
            v32 = v33
        end
    elseif v29.kind == "name" then
        for v37 in v28.vars do
            local v38 = {
                text = ("$%*"):format(v37),
                display = ("$%*"):format(v37)
            }
            table.insert(v31, v38)
            v32 = nil
        end
    end
    v28.result = {
        replace = span_2,
        suggestions = v31,
        additional_info = v32
    }
end

v27.visit_var_root = visit_var_root

local function visit_block(v39, v40) -- line 265
    local span = v40.span
    local v41
    if v39.cursor < span.x then
        v41 = "before"
    else
        local cursor = v39.cursor
        if span.y < cursor then
            v41 = "after"
        else
            v41 = "within"
        end
    end
    if v41 == "within" then
        for v42, v43 in v40.body do
            if v43.kind == "assign" then
                v39.vars[v43.identifier.text] = true
            end
        end
    end
end

v27.visit_block = visit_block

local function visit_expr_lambda(v44, v45) -- line 275
    local span = v45.span
    local v46
    if v44.cursor < span.x then
        v46 = "before"
    else
        local cursor = v44.cursor
        if span.y < cursor then
            v46 = "after"
        else
            v46 = "within"
        end
    end
    if not (v46 == "within" and v45.body.block and v45.body.block.value and v45.body.arguments) then
        return
    end
    local span_2 = v45.body.block.value.span
    local v47
    if v44.cursor < span_2.x then
        v47 = "before"
    else
        local cursor = v44.cursor
        if span_2.y < cursor then
            v47 = "after"
        else
            v47 = "within"
        end
    end
    if v47 == "within" then
        for v48, v49 in v45.body.arguments.value do
            local value = v49.value
            if value then
                v44.vars[value.text] = true
            end
        end
    end
end

v27.visit_expr_lambda = visit_expr_lambda

function v27.visit_command(v50, v51) -- line 290 | captures: v3, evaluate_expression_2
    local span = v51.span
    local v52
    if v50.cursor < span.x then
        v52 = "before"
    else
        local cursor = v50.cursor
        if span.y < cursor then
            v52 = "after"
        else
            v52 = "within"
        end
    end
    if v52 ~= "within" then
        return
    end
    local span_2 = v51.var.span
    local v53
    if v50.cursor < span_2.x then
        v53 = "before"
    else
        local cursor = v50.cursor
        if span_2.y < cursor then
            v53 = "after"
        else
            v53 = "within"
        end
    end
    if v53 ~= "after" then
        return
    end
    local root = v51.var.root
    if #v51.var.suffixes > 0 then
        return
    end
    local v54, text
    if root.kind == "global" then
        v54, text = v50.vm.global_metadata[root.token.text], root.token.text
    end
    if v54 == nil then
        return
    end
    local v55 = table.clone(v54.overloads)
    local v56 = table.clone(v54.overloads)
    local y = v51.span.y
    local y_2 = v51.span.y
    local v57, span_3 = 1, vector.create(y, y_2)
    for v58, v59 in v51.arguments do
        local span = v59.span
        local v60
        if v50.cursor < span.x then
            v60 = "before"
        else
            local cursor = v50.cursor
            if span.y < cursor then
                v60 = "after"
            else
                v60 = "within"
            end
        end
        if v60 == "before" then
            break
        end
        span_3 = v59.span
        local v61 = evaluate_expression_2(v59)
        local v62 = #v55
        for v63 = v62, 1, -1 do
            local v64 = v55[v63].arguments[v58]
            if v64 and v64.kind == "literal" and v61 ~= v3 then
                if v64.optional then
                    if v61 ~= nil and v64.value ~= v61 then
                        table.remove(v55, v63)
                    end
                elseif v64.value ~= v61 then
                    table.remove(v55, v63)
                end
            end
        end
        if #v55 > 0 then
            v55, v56, v57 = table.clone(v55), v55, v58
        else
            v57 = v58
        end
    end
    local v65 = v51.arguments[#v51.arguments]
    if v65 then
        local span = v65.span
        local v66
        if v50.cursor < span.x then
            v66 = "before"
        else
            local cursor = v50.cursor
            if span.y < cursor then
                v66 = "after"
            else
                v66 = "within"
            end
        end
        if v66 == "after" then
            v57 += 1
            local v67 = span_3.y + 1
            local v68 = span_3.y + 1
            span_3 = vector.create(v67, v68, 0)
        end
    end
    if #v55 == 0 then
        local issues = v50.issues
        local v69 = {
            why = ("no overloads match command \"%*\""):format(text),
            span = v51.span
        }
        table.insert(issues, v69)
    else
        v56 = v55
    end
    local v70 = {}
    local v71 = {}
    local v72
    for v73, v74 in v56 do
        local v75 = v74.arguments[v57]
        if v75 then
            if v75.kind == "argument" then
                v72 = {
                    name = v75.name,
                    description = v75.description,
                    type = v75.type,
                    optional = v75.optional
                }
            elseif v75.kind == "literal" then
                v72 = { type = "literal" }
                v72.name = v75.name
                v72.description = v75.description
                v72.optional = v75.optional
            else
                v72 = nil
            end
            if v75.kind == "literal" then
                local v76 = { text = v75.value }
                local value = v75.value
                v76.display = tostring(value)
                table.insert(v70, v76)
            else
                local input = v50.input
                local v77 = span_3.x + 1
                local v78 = span_3.y + 1
                local v79 = string.sub(input, v77, v78)
                for v80, v81 in v75.suggestions and v75.suggestions(v79) or {} do
                    local v82 = ("%*:%*"):format(v81.text, v81.display)
                    if not v71[v82] then
                        table.insert(v70, v81)
                        v71[v82] = true
                    end
                end
            end
        else
            v72 = nil
        end
    end
    assert(v54)
    v50.result = {
        replace = span_3,
        suggestions = v70,
        additional_info = v72
    }
end

local function visit_stat_command_end(v83, v84) -- line 413
    if not v83.result then
        return
    end
    local span = v84.var.root.span
    local v85
    if v83.cursor < span.x then
        v85 = "before"
    else
        local cursor = v83.cursor
        if span.y < cursor then
            v85 = "after"
        else
            v85 = "within"
        end
    end
    if v85 ~= "within" then
        return
    end
    local suggestions = v83.result.suggestions
    local v86 = {
        text = "for",
        display = "for"
    }
    table.insert(suggestions, v86)
    local suggestions_2 = v83.result.suggestions
    local v87 = {
        text = "while",
        display = "while"
    }
    table.insert(suggestions_2, v87)
end

v27.visit_stat_command_end = visit_stat_command_end
return function(v88, v89, v90) -- line 427 | captures: ast, is_identifier, v27
    local v91, v92 = pcall(ast.parse, (buffer.fromstring(v89)))
    if v92.result then
        local v93 = {
            vars = table.clone(v88.state.scope.vars),
            globals = table.clone(v88.state.globals),
            cursor = v90,
            input = v89,
            vm = v88,
            issues = v92.issues
        }
        ast.visit.visit_ast(v27, v93, v92.result)
        if v93.result and v93.result.suggestions then
            for v94, v95 in v93.result.suggestions do
                local text = v95.text
                if not is_identifier(text) then
                    text = string.format("%q", text)
                end
                v95.text = text
            end
        end
        local v96 = {}
        v96.replace = v93.result and v93.result.replace or vector.create(0, 0, 0)
        v96.suggestions = v93.result and v93.result.suggestions or {}
        v96.additional_info = v93.result and v93.result.additional_info
        v96.issues = v93.issues
        return v96
    end
    return {
        replace = vector.create(0, 0, 0),
        suggestions = {},
        issues = v92.issues
    }
end
