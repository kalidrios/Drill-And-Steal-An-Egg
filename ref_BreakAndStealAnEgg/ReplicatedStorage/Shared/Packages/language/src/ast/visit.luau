-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

require(script.Parent.ast)

local function create_visitor() -- line 98
    local function v1() -- line 99
    end

    return {
        visit_block = v1,
        visit_block_end = v1,
        visit_token = v1,
        visit_fn_argument = v1,
        visit_command = v1,
        visit_command_end = v1,
        visit_statement = v1,
        visit_statement_end = v1,
        visit_stat_for = v1,
        visit_stat_for_end = v1,
        visit_stat_while = v1,
        visit_stat_while_end = v1,
        visit_stat_if = v1,
        visit_stat_if_end = v1,
        visit_stat_assign = v1,
        visit_stat_assign_end = v1,
        visit_stat_command = v1,
        visit_stat_command_end = v1,
        visit_if_branch = v1,
        visit_if_branch_end = v1,
        visit_elseif_branch = v1,
        visit_elseif_branch_end = v1,
        visit_else_branch = v1,
        visit_else_branch_end = v1,
        visit_last_statement = v1,
        visit_last_statement_end = v1,
        visit_return = v1,
        visit_return_end = v1,
        visit_break = v1,
        visit_break_end = v1,
        visit_continue = v1,
        visit_continue_end = v1,
        visit_table = v1,
        visit_table_end = v1,
        visit_tablefield = v1,
        visit_tablefield_end = v1,
        visit_tablefield_nokey = v1,
        visit_tablefield_nokey_end = v1,
        visit_tablefield_namekey = v1,
        visit_tablefield_namekey_end = v1,
        visit_tablefield_exprkey = v1,
        visit_tablefield_exprkey_end = v1,
        visit_var = v1,
        visit_var_end = v1,
        visit_var_suffix = v1,
        visit_var_suffix_end = v1,
        visit_var_suffix_expression = v1,
        visit_var_suffix_expression_end = v1,
        visit_var_suffix_name = v1,
        visit_var_suffix_name_end = v1,
        visit_var_root = v1,
        visit_var_root_end = v1,
        visit_var_root_paren = v1,
        visit_var_root_paren_end = v1,
        visit_var_root_variable = v1,
        visit_var_root_variable_end = v1,
        visit_var_root_global = v1,
        visit_var_root_global_end = v1,
        visit_expression = v1,
        visit_expression_end = v1,
        visit_expr_command = v1,
        visit_expr_command_end = v1,
        visit_expr_evaluate = v1,
        visit_expr_evaluate_end = v1,
        visit_expr_unary = v1,
        visit_expr_unary_end = v1,
        visit_expr_vector = v1,
        visit_expr_vector_end = v1,
        visit_expr_lambda = v1,
        visit_expr_lambda_end = v1,
        visit_expr_string = v1,
        visit_expr_string_end = v1,
        visit_expr_binary = v1,
        visit_expr_binary_end = v1,
        visit_expr_number = v1,
        visit_expr_number_end = v1,
        visit_expr_boolean = v1,
        visit_expr_boolean_end = v1,
        visit_expr_var = v1,
        visit_expr_var_end = v1,
        visit_expr_nil = v1,
        visit_expr_nil_end = v1
    }
end

local v2, v3

local function visit_token(v4, v5, v6) -- line 213
    v4.visit_token(v5, v6)
end

local function visit_delimited(v7, v8, v9, v10) -- line 221
    local left = v10.left
    v7.visit_token(v8, left)
    if v10.value then
        v9(v7, v8, v10.value)
    end
    if v10.right then
        local right = v10.right
        v7.visit_token(v8, right)
    end
end

local function visit_separated(v11, v12, v13, v14) -- line 238
    for v15, v16 in v14 do
        v13(v11, v12, v16.value)
        if v16.separator then
            local separator = v16.separator
            v11.visit_token(v12, separator)
        end
    end
end

local function gen_separated(v17) -- line 250 | captures: visit_separated
    return function(v18, v19, v20) -- line 251 | captures: v17, visit_separated
        visit_separated(v18, v19, v17, v20)
    end
end

local function visit_argument(v21, v22, v23) -- line 260
    v21.visit_fn_argument(v21, v22)
    v21.visit_token(v22, v23)
end

local function visit_tablefield(v24, v25, v26) -- line 269 | captures: v2
    v24.visit_tablefield(v25, v26)
    if v26.kind == "expression_key" then
        v24.visit_tablefield_exprkey(v25, v26)
        if v26.key then
            local v27 = v2
            local key = v26.key
            local left = key.left
            v24.visit_token(v25, left)
            if key.value then
                v27(v24, v25, key.value)
            end
            if key.right then
                local right = key.right
                v24.visit_token(v25, right)
            end
        end
        if v26.equals then
            local equals = v26.equals
            v24.visit_token(v25, equals)
        end
        if v26.value then
            v2(v24, v25, v26.value)
        end
        v24.visit_tablefield_exprkey_end(v25, v26)
    elseif v26.kind == "name_key" then
        v24.visit_tablefield_namekey(v25, v26)
        local name = v26.name
        v24.visit_token(v25, name)
        local equals = v26.equals
        v24.visit_token(v25, equals)
        if v26.value then
            v2(v24, v25, v26.value)
        end
        v24.visit_tablefield_namekey_end(v25, v26)
    elseif v26.kind == "nokey" then
        v24.visit_tablefield_nokey(v25, v26)
        if v26.value then
            v2(v24, v25, v26.value)
        end
        v24.visit_tablefield_nokey_end(v25, v26)
    end
    v24.visit_tablefield_end(v25, v26)
end

local function v28(v29, v30, v31) -- line 308 | captures: v2
    v29.visit_var(v30, v31)
    v29.visit_var_root(v30, v31.root)
    if v31.root.kind == "global" then
        v29.visit_var_root_global(v30, v31.root)
        local token = v31.root.token
        v29.visit_token(v30, token)
        v29.visit_var_root_global_end(v30, v31.root)
    elseif v31.root.kind == "name" then
        v29.visit_var_root_variable(v30, v31.root)
        local var = v31.root.var
        v29.visit_token(v30, var)
        if v31.root.name then
            local name = v31.root.name
            v29.visit_token(v30, name)
        end
        v29.visit_var_root_variable_end(v30, v31.root)
    elseif v31.root.kind == "paren" then
        v29.visit_var_root_paren(v30, v31.root)
        local var = v31.root.var
        v29.visit_token(v30, var)
        local v32 = v2
        local node = v31.root.node
        local left = node.left
        v29.visit_token(v30, left)
        if node.value then
            v32(v29, v30, node.value)
        end
        if node.right then
            local right = node.right
            v29.visit_token(v30, right)
        end
        v29.visit_var_root_paren_end(v30, v31.root)
    end
    v29.visit_var_root_end(v30, v31.root)
    for v33, v34 in v31.suffixes do
        v29.visit_var_suffix(v30, v34)
        if v34.kind == "expression_index" then
            v29.visit_var_suffix_expression(v30, v34)
            local period = v34.period
            v29.visit_token(v30, period)
            local v35 = v2
            local node = v34.node
            local left = node.left
            v29.visit_token(v30, left)
            if node.value then
                v35(v29, v30, node.value)
            end
            if node.right then
                local right = node.right
                v29.visit_token(v30, right)
            end
            v29.visit_var_suffix_expression_end(v30, v34)
        elseif v34.kind == "name_index" then
            v29.visit_var_suffix_name(v30, v34)
            local period = v34.period
            v29.visit_token(v30, period)
            if v34.name then
                local name = v34.name
                v29.visit_token(v30, name)
            end
            v29.visit_var_suffix_name_end(v30, v34)
        end
        v29.visit_var_suffix_end(v30, v34)
    end
    v29.visit_var_end(v30, v31)
end

function v2(v36, v37, v38) -- line 356 | captures: v28, v2, v3, visit_separated, visit_argument, visit_tablefield
    v36.visit_expression(v37, v38)
    if v38.kind == "binary" then
        v36.visit_expr_binary(v37, v38)
        v2(v36, v37, v38.left)
        local operator = v38.operator
        v36.visit_token(v37, operator)
        if v38.right then
            v2(v36, v37, v38.right)
        end
        v36.visit_expr_binary_end(v37, v38)
    elseif v38.kind == "boolean" then
        v36.visit_expr_boolean(v37, v38)
        local token = v38.token
        v36.visit_token(v37, token)
        v36.visit_expr_boolean_end(v37, v38)
    elseif v38.kind == "evaluate" then
        v36.visit_expr_evaluate(v37, v38)
        local v39 = v2
        local command = v38.command
        local left = command.left
        v36.visit_token(v37, left)
        if command.value then
            v39(v36, v37, command.value)
        end
        if command.right then
            local right = command.right
            v36.visit_token(v37, right)
        end
        v36.visit_expr_evaluate_end(v37, v38)
    elseif v38.kind == "lambda" then
        v36.visit_expr_lambda(v37, v38)

        local function v40(v41, v42, v43) -- line 251 | captures: visit_separated, visit_argument
            visit_separated(v41, v42, visit_argument, v43)
        end

        local arguments = v38.body.arguments
        local left = arguments.left
        v36.visit_token(v37, left)
        if arguments.value then
            v40(v36, v37, arguments.value)
        end
        if arguments.right then
            local right = arguments.right
            v36.visit_token(v37, right)
        end
        if v38.body.block then
            local v44 = v3
            local block = v38.body.block
            local left = block.left
            v36.visit_token(v37, left)
            if block.value then
                v44(v36, v37, block.value)
            end
            if block.right then
                local right = block.right
                v36.visit_token(v37, right)
            end
        end
        v36.visit_expr_lambda_end(v37, v38)
    elseif v38.kind == "nil" then
        v36.visit_expr_nil(v37, v38)
        local token = v38.token
        v36.visit_token(v37, token)
        v36.visit_expr_nil_end(v37, v38)
    elseif v38.kind == "number" then
        v36.visit_expr_number(v37, v38)
        local token = v38.token
        v36.visit_token(v37, token)
        v36.visit_expr_number_end(v37, v38)
    elseif v38.kind == "string" then
        v36.visit_expr_string(v37, v38)
        local token = v38.token
        v36.visit_token(v37, token)
        v36.visit_expr_string_end(v37, v38)
    elseif v38.kind == "table" then
        v36.visit_table(v37, v38)

        local function v45(v46, v47, v48) -- line 251 | captures: visit_separated, visit_tablefield
            visit_separated(v46, v47, visit_tablefield, v48)
        end

        local values = v38.values
        local left = values.left
        v36.visit_token(v37, left)
        if values.value then
            v45(v36, v37, values.value)
        end
        if values.right then
            local right = values.right
            v36.visit_token(v37, right)
        end
        v36.visit_table_end(v37, v38)
    elseif v38.kind == "unary" then
        v36.visit_expr_unary(v37, v38)
        local operator = v38.operator
        v36.visit_token(v37, operator)
        if v38.value then
            v2(v36, v37, v38.value)
        end
        v36.visit_expr_unary_end(v37, v38)
    elseif v38.kind == "command" then
        v36.visit_expr_command(v37, v38)
        v36.visit_token(v37, v38.prefix)
        if v38.command then
            v36.visit_command(v37, v38.command)
        end
        v36.visit_expr_command_end(v37, v38)
    elseif v38.kind == "var" then
        v36.visit_expr_var(v37, v38)
        v28(v36, v37, v38)
        v36.visit_expr_var_end(v37, v38)
    elseif v38.kind == "vector" then
        v36.visit_expr_vector(v37, v38)
        local v49 = v2

        local function v50(v51, v52, v53) -- line 251 | captures: v49, visit_separated
            visit_separated(v51, v52, v49, v53)
        end

        local contents = v38.contents
        local left = contents.left
        v36.visit_token(v37, left)
        if contents.value then
            v50(v36, v37, contents.value)
        end
        if contents.right then
            local right = contents.right
            v36.visit_token(v37, right)
        end
        v36.visit_expr_vector_end(v37, v38)
    end
    v36.visit_expression_end(v37, v38)
end

local function v54(v55, v56, v57) -- line 461 | captures: v28, v2
    v55.visit_command(v56, v57)
    v28(v55, v56, v57.var)
    for v58, v59 in v57.arguments do
        v2(v55, v56, v59)
    end
    v55.visit_command_end(v56, v57)
end

local function visit_if_branch(v60, v61, v62) -- line 473
    v60.visit_if_branch(v61, v62)
    v60.visit_if_branch_end(v61, v62)
end

local function v63(v64, v65, v66) -- line 483 | captures: v54, v2, v3
    v64.visit_statement(v65, v66)
    if v66.kind == "assign" then
        v64.visit_stat_assign(v65, v66)
        v64.visit_token(v65, v66.identifier)
        v64.visit_token(v65, v66.equals)
        if v66.value then
            v2(v64, v65, v66.value)
        end
        v64.visit_stat_assign_end(v65, v66)
    elseif v66.kind == "command" then
        v64.visit_stat_command(v65, v66)
        v54(v64, v65, v66)
        v64.visit_stat_command_end(v65, v66)
    elseif v66.kind == "for" then
        v64.visit_stat_for(v65, v66)
        v64.visit_token(v65, v66.token)
        if v66.expression then
            local v67 = v2
            local expression = v66.expression
            local left = expression.left
            v64.visit_token(v65, left)
            if expression.value then
                v67(v64, v65, expression.value)
            end
            if expression.right then
                local right = expression.right
                v64.visit_token(v65, right)
            end
        end
        if v66.body then
            v2(v64, v65, v66.body)
        end
        v64.visit_stat_for_end(v65, v66)
    elseif v66.kind == "if" then
        v64.visit_stat_if(v65, v66)
        v64.visit_token(v65, v66.token)
        if v66.first_branch then
            local first_branch = v66.first_branch
            v64.visit_if_branch(v65, first_branch)
            v64.visit_if_branch_end(v65, first_branch)
        end
        for v68, v69 in v66.branches do
            v64.visit_elseif_branch(v65, v69)
            v64.visit_token(v65, v69.ifelse)
            local branch = v69.branch
            v64.visit_if_branch(v65, branch)
            v64.visit_if_branch_end(v65, branch)
            v64.visit_elseif_branch_end(v65, v69)
        end
        if v66.else_branch then
            v64.visit_else_branch(v65, v66.else_branch)
            v64.visit_token(v65, v66.else_branch.token)
            if v66.else_branch.block then
                local v70 = v3
                local block = v66.else_branch.block
                local left = block.left
                v64.visit_token(v65, left)
                if block.value then
                    v70(v64, v65, block.value)
                end
                if block.right then
                    local right = block.right
                    v64.visit_token(v65, right)
                end
            end
            v64.visit_else_branch_end(v65, v66.else_branch)
        end
        v64.visit_stat_if_end(v65, v66)
    elseif v66.kind == "while" then
        v64.visit_stat_while(v65, v66)
        v64.visit_token(v65, v66.token)
        if v66.condition then
            local v71 = v2
            local condition = v66.condition
            local left = condition.left
            v64.visit_token(v65, left)
            if condition.value then
                v71(v64, v65, condition.value)
            end
            if condition.right then
                local right = condition.right
                v64.visit_token(v65, right)
            end
        end
        if v66.block then
            local v72 = v3
            local block = v66.block
            local left = block.left
            v64.visit_token(v65, left)
            if block.value then
                v72(v64, v65, block.value)
            end
            if block.right then
                local right = block.right
                v64.visit_token(v65, right)
            end
        end
        v64.visit_stat_while_end(v65, v66)
    end
    v64.visit_statement_end(v65, v66)
end

local function v73(v74, v75, v76) -- line 561 | captures: v2, visit_separated
    v74.visit_last_statement(v75, v76)
    if v76.kind == "break" then
        v74.visit_break(v75, v76)
        local token = v76.token
        v74.visit_token(v75, token)
        v74.visit_break_end(v75, v76)
    elseif v76.kind == "continue" then
        v74.visit_continue(v75, v76)
        local token = v76.token
        v74.visit_token(v75, token)
        v74.visit_continue_end(v75, v76)
    elseif v76.kind == "return" then
        v74.visit_return(v75, v76)
        local token = v76.token
        v74.visit_token(v75, token)
        visit_separated(v74, v75, v2, v76.values)
        v74.visit_return_end(v75, v76)
    end
    v74.visit_last_statement_end(v75, v76)
end

function v3(v77, v78, v79) -- line 592 | captures: v73, v63
    v77.visit_block(v78, v79)
    for v80, v81 in v79.body do
        v63(v77, v78, v81)
    end
    if v79.last_statement then
        v73(v77, v78, v79.last_statement)
    end
    v77.visit_block_end(v78, v79)
end

local function visit_ast(v82, v83, v84) -- line 606 | captures: v3
    v3(v82, v83, v84.block)
end

return {
    visit_block = v3,
    visit_ast = visit_ast,
    create_visitor = create_visitor
}
