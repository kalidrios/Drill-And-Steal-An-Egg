-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local analysis = require(script.analysis)
local ast = require(script.ast)
local treewalker = require(script.treewalker)

return {
    version = "0.3.1",
    create_vm = function() -- create_vm | line 40 | captures: treewalker
        return {
            global_metadata = {},
            vars_metadata = {},
            state = treewalker.create_state()
        }
    end,
    set_command = function(v1, v2, v3) -- set_command | line 49
        v1.state.globals[v2] = v3
    end,
    set_variable = function(v4, v5, v6) -- set_variable | line 53
        v4.state.scope.vars[v5] = v6
    end,
    attach_info = function(v7, v8) -- attach_info | line 57
        if v8.is_var then
            v7.vars_metadata[v8.key] = v8
            local v9 = {}

            function v9.remove() -- line 60 | captures: v7, v8
                v7.vars_metadata[v8.key] = nil
            end

            return v9
        end
        v7.global_metadata[v8.key] = v8
        local v10 = {}

        function v10.remove() -- line 63 | captures: v7, v8
            v7.global_metadata[v8.key] = nil
        end

        return v10
    end,
    run = function(v11, v12) -- run | line 67 | captures: ast, treewalker
        local v13 = buffer.fromstring(v12)
        local v14, v15 = pcall(ast.parse, v13)
        if v14 then
            local v16 = treewalker.execute(v11.state, v15.result)
            if v16.ok then
                return v16
            end
            return {
                ok = false,
                why = { v16.err }
            }
        end
        local v17 = {}
        for v18, v19 in v15.issues do
            local v20 = ("%* at %*:%*:%*"):format(v19.why, v19.span.x, v19.span.y, v19.span.z)
            table.insert(v17, v20)
        end
        return {
            ok = false,
            why = v17
        }
    end,
    analyze = analysis
}
