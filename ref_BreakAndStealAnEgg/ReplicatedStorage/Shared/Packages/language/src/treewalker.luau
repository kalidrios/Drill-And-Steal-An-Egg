-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

require(script.Parent.ast)
local v1 = {}
local v2 = { __mode = "k" }
local v3 = setmetatable(v1, v2)
local v4 = {}
local v5 = { __mode = "k" }
local v6 = setmetatable(v4, v5)

local function get_stack_trace_info(v7) -- line 60
    local fn_name = v7.fn_name
    local v8
    if fn_name or not v7.fn then
        v8 = ("function %*"):format(fn_name)
    else
        local nsl, nsl_2, nsl_3 = debug.info(v7.fn, "nsl")
        if nsl == "" then
            v8 = ("%*:%*"):format(nsl_2, nsl_3)
        else
            v8 = ("function %*"):format(nsl)
        end
    end
    if v7.origin == "conch" then
        return (("%*:%* %*"):format(v7.origin, v7.line, v8))
    end
    if v7.fn then
        return (("%* %*"):format(v7.origin, v8))
    end
    return ""
end

local function push_conch_trace(v9, v10, v11, v12) -- line 79
    local trace = v9.trace
    local v13 = {
        origin = "conch",
        fn = v10,
        fn_name = v11,
        line = v12
    }
    table.insert(trace, v13)
end

local function push_luau_trace(v14, v15, v16, v17) -- line 91
    local trace = v14.trace
    local v18 = {
        origin = "luau",
        fn = v15,
        fn_name = v16
    }
    table.insert(trace, v18)
end

local function pop_trace(v19) -- line 100
    table.remove(v19.trace)
end

local function reset_state(v20) -- line 102
    table.clear(v20.trace)
    while true do
        if v20.scope.root then
            break
        end
        v20.scope = v20.scope.up
    end
end

local function throw(v21, v22, v23) -- line 114 | captures: get_stack_trace_info
    local v24 = {}
    local v25 = #v21.trace
    for v26 = v25, 1, -1 do
        local v27 = get_stack_trace_info(v21.trace[v26])
        table.insert(v24, v27)
    end
    table.clear(v21.trace)
    while true do
        if v21.scope.root then
            break
        end
        v21.scope = v21.scope.up
    end
    error(("%* at %*:%*\n%*"):format(v23, v22.span.x, v22.span.y, (table.concat(v24, "\n"))), 0)
end

local v28, v29

local function read_variable(v30, v31) -- line 133
    local v32 = v30.scope
    local v33
    while true do
        if v32 then
            v33 = v32.vars[v31]
            if v33 then
                break
            end
            v32 = v32.up
            continue
        end
        return nil, nil
    end
    return v32, v33
end

local function write_variable(v34, v35, v36) -- line 148
    local v37 = v34.scope
    local v38
    while true do
        if v37 then
            if v37.vars[v35] then
                v38 = v37
                break
            end
            v37 = v37.up
            continue
        end
        v38 = nil
        break
    end
    (v38 or v34.scope).vars[v35] = v36
end

local function index(v39, v40, v41, v42) -- line 155 | captures: throw
    local v43, v44 = pcall(function() -- line 161 | captures: v41, v42
        return v41[v42]
    end)
    if not v43 then
        throw(v39, v40, (("could not index %* with %*"):format(typeof(v41), v42)))
    end
    return v44
end

local function call(v45, v46, v47, ...) -- line 169 | captures: v6, throw
    if v6[v47] then
        local v48 = v6[v47]
        if v48 == true then
            v48 = nil
        end
        local z = v46.span.z
        local trace = v45.trace
        local v49 = {
            origin = "conch",
            fn = v47,
            fn_name = v48,
            line = z
        }
        table.insert(trace, v49)
        local v50 = table.pack(v47(...))
        table.remove(v45.trace)
        return v50
    end
    local v51, v52 = pcall(function(...) -- line 183 | captures: v47
        return table.pack(v47(...))
    end, ...)
    local z = v46.span.z
    local trace = v45.trace
    local v53 = {
        fn_name = nil,
        origin = "luau",
        fn = v47
    }
    table.insert(trace, v53)
    if not v51 then
        throw(v45, v46, ("%*"):format(v52):gsub("^.+:%d+:%s*", ""))
    end
    table.remove(v45.trace)
    return v52
end

local v54 = {
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

local function get_value(v55, v56) -- line 210 | captures: throw, v54
    if v56.kind == "number" then
        local text = v56.text
        local v57 = tonumber(text)
        if v57 then
            return v57
        end
        return throw(v55, v56, (("%* is not a valid number"):format(v57)))
    end
    if v56.kind == "string" then
        local text = v56.text
        local v58 = string.sub(text, 2, -2)
        local v59 = string.gsub(v58, "\\([0-9][0-9]?[0-9]?)", function(v60) -- line 226
            local v61 = tonumber(v60)
            assert(v61)
            return (string.char(v61))
        end)
        for v62, v63 in v54 do
            v59 = string.gsub(v59, ("\\%*"):format(v62), v63)
        end
        return v59
    end
    if v56.kind == "identifier" then
        return v56.text
    end
    if v56.kind == "true" then
        return true
    end
    if v56.kind == "false" then
        return false
    end
    if v56.kind == "nil" then
        return nil
    end
    return throw(v55, v56, "could not get value")
end

local function evaluate_var(v64, v65) -- line 256 | captures: v28, throw, get_value
    local root = v65.root
    local v66
    if root.kind == "global" then
        v66 = v64.globals[root.token.text]
    elseif root.kind == "name" then
        if root.name then
            local text = root.name.text
            local v67 = v64.scope
            while true do
                if v67 then
                    local v68 = v67.vars[text]
                    if v68 then
                        v66 = v68
                        break
                    end
                    v67 = v67.up
                    continue
                end
                v66 = nil
                break
            end
        else
            return throw(v64, v65, "no root name token")
        end
    elseif root.kind == "paren" then
        local value = root.node.value
        if value then
            v66 = v28(v64, value)
        else
            return throw(v64, root, "missing expression")
        end
    end
    for v69, v70 in v65.suffixes do
        if v70.kind == "expression_index" then
            local value = v70.node.value
            if value then
                local v71 = v28(v64, value)
                local pcall_2 = pcall
                local v72 = v66
                local v73, v74 = pcall_2(function() -- line 161 | captures: v71, v72
                    return v72[v71]
                end)
                if not v73 then
                    throw(v64, v65, (("could not index %* with %*"):format(typeof(v66), v71)))
                end
                v66 = v74
            else
                return throw(v64, v70, "missing expression")
            end
        elseif v70.kind == "name_index" then
            if v70.name then
                local v75 = get_value(v64, v70.name)
                local pcall_2 = pcall
                local v76 = v66
                local v77, v78 = pcall_2(function() -- line 161 | captures: v75, v76
                    return v76[v75]
                end)
                if not v77 then
                    throw(v64, v65, (("could not index %* with %*"):format(typeof(v66), v75)))
                end
                v66 = v78
            else
                return throw(v64, v70, "missing expression")
            end
        end
    end
    return v66
end

local function evaluate_command(v79, v80) -- line 296 | captures: v28, call, evaluate_var
    local v81 = {}
    for v82, v83 in v80.arguments do
        table.move({ v28(v79, v83) }, 1, 8000, v82, v81)
    end
    local v84 = evaluate_var(v79, v80.var)
    return call(v79, v80, v84, unpack(v81))
end

local function evaluate_table(v85, v86) -- line 317 | captures: v28, throw
    local v87 = {}
    local v88 = 1
    for v89, v90 in v86.values.value do
        local value = v90.value
        if value.kind == "expression_key" then
            if value.key and value.key.value then
                if value.value then
                    v87[v28(v85, value.key.value)] = v28(v85, value.value)
                else
                    return throw(v85, v90, "no value")
                end
            else
                return throw(v85, v90, "no key")
            end
        elseif value.kind == "name_key" then
            if value.value then
                v87[value.name.text] = v28(v85, value.value)
            else
                return throw(v85, v90, "no value")
            end
        elseif value.kind == "nokey" then
            if value.value then
                v87[v88] = v28(v85, value.value)
                v88 += 1
            else
                return throw(v85, v90, "no value")
            end
        end
    end
    return v87
end

local function wrap_op(v91, v92, v93, v94, v95, v96) -- line 348 | captures: throw
    local v97, v98 = pcall(v96, v94, v95)
    if v97 then
        return v98
    end
    return throw(v91, v92, (("attempt to %* on %* and %*"):format(v93, typeof(v94), (typeof(v95)))))
end

local function evaluate_binary(v99, v100) -- line 369 | captures: v28, throw, wrap_op
    if v100.left then
        if v100.right then
            local v101 = v28(v99, v100.left)
            local v102 = v28(v99, v100.right)
            local kind = v100.operator.kind
            if kind == "!=" then
                return wrap_op(v99, v100, "compare !=", v101, v102, function(v103, v104) -- line 390
                    return v103 ~= v104
                end)
            end
            if kind == "%" then
                return wrap_op(v99, v100, "get modulo of", v101, v102, function(v105, v106) -- line 399
                    return v105 % v106
                end)
            end
            if kind == "*" then
                return wrap_op(v99, v100, "multiply", v101, v102, function(v107, v108) -- line 408
                    return v107 * v108
                end)
            end
            if kind == "+" then
                return wrap_op(v99, v100, "add", v101, v102, function(v109, v110) -- line 417
                    return v109 + v110
                end)
            end
            if kind == "-" then
                return wrap_op(v99, v100, "subtract", v101, v102, function(v111, v112) -- line 426
                    return v111 - v112
                end)
            end
            if kind == ".." then
                return wrap_op(v99, v100, "concatenate", v101, v102, function(v113, v114) -- line 435
                    return v113 .. v114
                end)
            end
            if kind == "/" then
                return wrap_op(v99, v100, "divide", v101, v102, function(v115, v116) -- line 444
                    return v115 / v116
                end)
            end
            if kind == "//" then
                return wrap_op(v99, v100, "idivide", v101, v102, function(v117, v118) -- line 453
                    return v117 // v118
                end)
            end
            if kind == "<" then
                return wrap_op(v99, v100, "compare <", v101, v102, function(v119, v120) -- line 462
                    return v119 < v120
                end)
            end
            if kind == "<=" then
                return wrap_op(v99, v100, "compare <=", v101, v102, function(v121, v122) -- line 471
                    return v121 <= v122
                end)
            end
            if kind == "==" then
                return wrap_op(v99, v100, "compare ==", v101, v102, function(v123, v124) -- line 480
                    return v123 == v124
                end)
            end
            if kind == ">" then
                return wrap_op(v99, v100, "compare >", v101, v102, function(v125, v126) -- line 489
                    return v126 < v125
                end)
            end
            if kind == ">=" then
                return wrap_op(v99, v100, "compare >=", v101, v102, function(v127, v128) -- line 498
                    return v128 <= v127
                end)
            end
            if kind == "^" then
                return wrap_op(v99, v100, "get the power", v101, v102, function(v129, v130) -- line 507
                    return v129 ^ v130
                end)
            end
            if kind == "and" then
                return v101 and v102
            end
            if kind == "or" then
                return v101 or v102
            end
            if kind == "~=" then
                return wrap_op(v99, v100, "compare ~=", v101, v102, function(v131, v132) -- line 520
                    return v131 ~= v132
                end)
            end
            return throw(v99, v100, (("unsupported operator %*"):format(kind)))
        end
        return throw(v99, v100, "missing rhs expression")
    end
    return throw(v99, v100, "missing lhs expression")
end

local function evaluate_unary(v133, v134) -- line 527 | captures: v28, throw
    if v134.value then
        local v135 = v28(v133, v134.value)
        if v134.operator.kind == "!" then
            return not v135
        end
        if v134.operator.kind == "-" then
            return -v135
        end
        return throw(v133, v134, (("unsupported operator %*"):format(v134.operator)))
    end
    return throw(v133, v134, "missing expression")
end

local function evaluate_lambda(v136, v137) -- line 543 | captures: v28, v29, v3, v6, throw
    local v138 = {
        root = true,
        vars = v136.scope.vars,
        up = v136.scope.up
    }

    local function conch_guest_fn(...) -- line 553 | captures: v136, v137, v138, v28, v29, v3, throw
        local v139 = {
            root = true,
            vars = v138.vars,
            up = v138.up
        }
        for v140, v141 in v137.body.arguments.value do
            local v142 = select(v140, ...)
            if v141.value then
                v139.vars[v141.value.text] = v142
            end
        end
        if v137.body.block then
            local v143 = v3[coroutine.running()]
            local v144 = { return_state = nil }
            v144.trace = v143 and v143.trace or {}
            v144.scope = v139
            v144.globals = v136.globals
            v29(v144, v137.body.block.value)
            if v144.last_statement then
                local node = v144.last_statement.node
                if node.kind == "return" then
                    local v145 = {}
                    for v146, v147 in node.values do
                        local value = v147.value
                        if value then
                            v145[v146] = v28(v144, value)
                        end
                    end
                    local v148 = #node.values
                    return unpack(v145, 1, v148)
                end
                if v143 then
                    v143.last_statement = {
                        scope = v139,
                        node = node
                    }
                end
            end
        else
            return throw(v136, v137, "no block")
        end
    end

    v6[conch_guest_fn] = true
    return conch_guest_fn
end

function v28(v149, v150) -- line 607 | captures: v28, throw, get_value, evaluate_var, evaluate_command, evaluate_table, evaluate_binary, evaluate_unary, evaluate_lambda
    if v150.kind == "binary" then
        return evaluate_binary(v149, v150)
    end
    if v150.kind == "boolean" then
        return get_value(v149, v150.token)
    end
    if v150.kind == "command" then
        if v150.command then
            local v151 = evaluate_command(v149, v150.command)
            local n = v151.n
            return unpack(v151, 1, n)
        end
        return throw(v149, v150, "missing command")
    end
    if v150.kind == "evaluate" then
        if v150.command.value then
            return v28(v149, v150.command.value)
        end
        return throw(v149, v150, "no expression within evaluate")
    end
    if v150.kind == "lambda" then
        return (evaluate_lambda(v149, v150))
    end
    if v150.kind == "nil" then
        return nil
    end
    if v150.kind == "number" then
        return get_value(v149, v150.token)
    end
    if v150.kind == "string" then
        return get_value(v149, v150.token)
    end
    if v150.kind == "table" then
        return evaluate_table(v149, v150)
    end
    if v150.kind == "unary" then
        return evaluate_unary(v149, v150)
    end
    if v150.kind == "var" then
        return evaluate_var(v149, v150)
    end
    if v150.kind == "vector" then
        local value = v150.contents.value
        local v152 = value[1] and value[1].value
        local v153 = value[2] and value[2].value
        local v154 = value[3] and value[3].value
        local v155
        if v152 then
            v155 = v28(v149, v152)
        else
            v155 = 0
        end
        local v156
        if v153 then
            v156 = v28(v149, v153)
        else
            v156 = 0
        end
        local v157
        if v154 then
            v157 = v28(v149, v154)
        else
            v157 = 0
        end
        return (vector.create(v155, v156, v157))
    end
    return throw(v149, v150, (("could not evaluate %*"):format(v150.kind)))
end

local function visit_stat_command(v158, v159) -- line 659 | captures: evaluate_command
    evaluate_command(v158, v159)
end

local function visit_stat_for(v160, v161) -- line 663 | captures: v28, throw, call
    local v162 = v161.expression and v161.expression.value
    local body = v161.body
    if v162 then
        local v163 = v28(v160, v162)
        if body then
            local v164 = v28(v160, body)
            local z = v161.span.z
            local trace = v160.trace
            local v165 = {
                fn_name = nil,
                origin = "conch",
                fn = v164,
                line = z
            }
            table.insert(trace, v165)
            for v166, v167, v168, v169, v170, v171, v172, v173, v174, v175, v176, v177, v178, v179, v180, v181, v182, v183, v184, v185, v186, v187, v188, v189, v190, v191 in v163 do
                call(v160, v161, v164, v166, v167, v168, v169, v170, v171, v172, v173, v174, v175, v176, v177, v178, v179, v180, v181, v182, v183, v184, v185, v186, v187, v188, v189, v190, v191)
                local last_statement = v160.last_statement
                if last_statement then
                    if last_statement.node.kind == "break" then
                        v160.last_statement = nil
                        break
                    end
                    if last_statement.node.kind == "continue" then
                        v160.last_statement = nil
                    elseif last_statement.node.kind == "return" then
                        break
                    end
                end
            end
            table.remove(v160.trace)
            return nil
        end
        return throw(v160, v161, "missing body")
    end
    return throw(v160, v161, "missing expression")
end

local function visit_stat_while(v192, v193) -- line 693 | captures: v28, v29, throw
    local v194 = v193.condition and v193.condition.value
    local v195 = v193.block and v193.block.value
    if v194 then
        if v195 then
            while true do
                if v28(v192, v194) then
                    v29(v192, v195)
                    local last_statement = v192.last_statement
                    if not (last_statement and last_statement.node.kind == "break") then
                        local v196
                        if last_statement then
                            if last_statement.node.kind == "continue" then
                                v192.last_statement = nil
                                v196 = false
                            else
                                v196 = last_statement.node.kind == "return"
                            end
                        else
                            v196 = false
                        end
                        if v196 then
                            break
                        end
                        continue
                    end
                    v192.last_statement = nil
                end
                break
            end
            return nil
        end
        return throw(v192, v193, "missing body")
    end
    return throw(v192, v193, "missing condition")
end

local function visit_stat_assign(v197, v198) -- line 720 | captures: v28, v6, throw
    if v198.value then
        local text = v198.identifier.text
        local v199 = v28(v197, v198.value)
        if typeof(v199) and v6[v199] then
            v6[v199] = text
        end
        local v200 = v197.scope
        local v201
        while true do
            if v200 then
                if v200.vars[text] then
                    v201 = v200
                    break
                end
                v200 = v200.up
                continue
            end
            v201 = nil
            break
        end
        (v201 or v197.scope).vars[text] = v199
        return nil
    end
    return throw(v197, v198, "missing value")
end

local function visit_stat_if(v202, v203) -- line 737 | captures: v28, v29, throw
    local function evaluate_branch(v204) -- line 738 | captures: v202, v203, v28, v29, throw
        local v205 = v204.condition and v204.condition.value
        local v206 = v204.block and v204.block.value
        if v205 then
            if v206 then
                if v28(v202, v205) then
                    v29(v202, v206)
                    return true
                end
                return false
            end
            return throw(v202, v203, "missing body")
        end
        return throw(v202, v203, "missing condition")
    end

    if not evaluate_branch(v203.first_branch) then
        for v207, v208 in v203.branches do
            if evaluate_branch(v208.branch) then
                return
            end
        end
        if v203.else_branch then
            if not v203.else_branch.block then
                return
            end
            v29(v202, v203.else_branch.block.value)
        end
    end
end

local function visit_lstat(v209, v210) -- line 764
    v209.last_statement = {
        node = v210,
        scope = v209.scope
    }
end

function v29(v211, v212) -- line 768 | captures: evaluate_command, visit_stat_for, visit_stat_while, visit_stat_assign, visit_stat_if
    v211.scope = {
        root = false,
        up = v211.scope,
        vars = {}
    }
    for v213, v214 in v212.body do
        if v214.kind == "assign" then
            visit_stat_assign(v211, v214)
        elseif v214.kind == "command" then
            evaluate_command(v211, v214)
        elseif v214.kind == "for" then
            visit_stat_for(v211, v214)
        elseif v214.kind == "if" then
            visit_stat_if(v211, v214)
        elseif v214.kind == "while" then
            visit_stat_while(v211, v214)
        end
        if v211.last_statement then
            break
        end
    end
    if v212.last_statement then
        v211.last_statement = {
            node = v212.last_statement,
            scope = v211.scope
        }
    end
    if v211.scope.up then
        v211.scope = v211.scope.up
    end
end

local function create_state() -- line 797
    return {
        last_statement = nil,
        trace = {},
        globals = {},
        scope = {
            root = true,
            up = nil,
            vars = {}
        }
    }
end

local function execute(v215, v216) -- line 812 | captures: v28, v29
    local v217, v218 = pcall(v29, v215, v216.block)
    if v217 then
        local v219 = {
            ok = true,
            values = nil
        }
        local last_statement = v215.last_statement
        v215.last_statement = nil
        if last_statement and last_statement.node.kind == "return" then
            v219.values = table.create(#last_statement.node.values, nil)
            local values = v219.values
            assert(values)
            for v220, v221 in last_statement.node.values do
                if v221.value then
                    local v222, v223 = pcall(v28, v215, v221.value)
                    if v222 then
                        v219.values[v220] = v223
                    else
                        table.clear(v215.trace)
                        while true do
                            if v215.scope.root then
                                break
                            end
                            v215.scope = v215.scope.up
                        end
                        return {
                            ok = false,
                            err = v223:gsub("^.+:%d+:%s*", "")
                        }
                    end
                end
            end
        end
        return v219
    end
    table.clear(v215.trace)
    while true do
        if v215.scope.root then
            break
        end
        v215.scope = v215.scope.up
    end
    return {
        ok = false,
        err = v218:gsub("^.+:%d+:%s*", "")
    }
end

local v224 = { create_state = create_state }

function v224.execute(v225, v226) -- line 855 | captures: v3, execute
    v3[coroutine.running()] = v225
    local v227 = execute(v225, v226)
    v3[coroutine.running()] = nil
    return v227
end

return v224
