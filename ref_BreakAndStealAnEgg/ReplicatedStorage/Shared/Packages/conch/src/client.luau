-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local console = require(script.Parent.console)
require(script.Parent.Parent.roblox_packages.language)
local net = require(script.Parent.net)
local state = require(script.Parent.state)
require(script.Parent.types)
local user = require(script.Parent.user)
local LocalPlayer = Players.LocalPlayer
local v1 = 0

return {
    create_local_user = function(v2) -- create_local_user | line 15 | captures: state, user, LocalPlayer
        local v3 = user.create_user({
            name = v2.name,
            player = LocalPlayer
        })
        state.local_user = v3
    end,
    update_user_roles = function(v4) -- update_user_roles | line 24 | captures: state
        local v5 = state.users[v4.id]
        assert(v5, "local user does not exist")
        v5.roles = v4.roles
    end,
    update_role_permissions = function(v6) -- update_role_permissions | line 32 | captures: state
        state.roles[v6.name] = v6.permissions
    end,
    register_command = function(v7) -- register_command | line 37 | captures: v1, console, net, state
        local v8 = {
            kind = "overload",
            overloads = v7.overloads
        }
        for v9, v10 in v8.overloads do
            for v11, v12 in v10.arguments do
                if v12.kind ~= "literal" then
                    local v13 = console.get_type(v12.unique_identifier)
                    if v13 then
                        local v14 = table.clone(v13.analysis)
                        v14.name = v12.name
                        v14.description = v12.description
                        v14.optional = v12.optional
                        v14.type = v12.type
                        if v14.kind == "argument" then
                            v14.vararg = v12.vararg
                        end
                        v10.arguments[v11] = v14
                    else
                        warn("unregistered type", v13)
                        return
                    end
                end
            end
        end
        local register_command = console.register_command
        local name = v7.name
        local v15 = {
            description = v7.description,
            permissions = v7.permissions
        }

        function v15.arguments() -- line 63 | captures: v8
            return v8
        end

        function v15.callback(...) -- line 65 | captures: v7, v1, net, state
            local v16 = coroutine.running()
            v1 += 1
            state.continuations[v1] = v16
            net.client.invoke_command(v1, v7.name, { ... })
            local v17 = coroutine.yield()
            if v17.status == "ok" then
                local results = v17.results
                return unpack(results)
            end
            error("something went wrong on the server")
        end

        register_command(name, v15)
    end,
    receive_server_results = function(v18) -- receive_server_results | line 86 | captures: state
        local v19 = state.continuations[v18.invoke_id]
        if v19 then
            state.continuations[v18.invoke_id] = nil
            task.spawn(v19, v18)
        end
    end,
    log = function(v20) -- log | line 94 | captures: console
        console.console.output(v20)
    end
}
