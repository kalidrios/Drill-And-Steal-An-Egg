-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local arguments = require(script.arguments)
local bootstrap = require(script.bootstrap)
local client = require(script.client)
local console = require(script.console)
local context = require(script.context)
local net = require(script.net)
local state = require(script.state)
require(script.types)
local user = require(script.user)
local v1 = RunService:IsServer()
local v2 = RunService:IsClient()
local create_user = user.create_user
local disconnect_user = user.disconnect_user
local has_permissions = user.has_permissions
local create_command_context = context.create_command_context
local get_command_context = context.get_command_context

local function FOREACH(v3, v4) -- line 26
    for v5, v6 in v3 do
        v4(v6, v5)
    end
end

local function set_role(v7, ...) -- line 32 | captures: net, state, v1
    state.roles[v7] = { ... }
    if v1 then
        net.server.fire_update_role_perms(v7, { ... })
    end
end

local function initiate_user_replication(v8) -- line 38 | captures: console, net, has_permissions
    if v8.player then
        for v9, v10 in console.console.commands do
            local permissions = v10.permissions
            if has_permissions(v8, unpack(permissions)) then
                net.server.fire_register_command(v8.player, {
                    name = v10.name,
                    permissions = v10.permissions,
                    overloads = v10.information.overloads
                })
            end
        end
    end
end

local function get_user(v11) -- line 54 | captures: state, user, create_user, initiate_user_replication
    if typeof(v11) == "string" then
        local v12 = user.obtain_user_key(false, v11)
        return state.users[v12] or
        create_user({
            player = false,
            name = v12
        })
    end
    local v13 = user.obtain_user_key(v11, v11.DisplayName)
    local v14 = state.users[v13]
    if v14 then
        return v14
    end
    local v15 = create_user({
        name = v11.DisplayName,
        player = v11
    })
    initiate_user_replication(v15)
    return v15
end

local function disconnect_user_for_player(v16) -- line 76 | captures: state, user, disconnect_user
    local v17 = user.obtain_user_key(v16, v16.DisplayName)
    local v18 = state.users[v17]
    if v18 then
        disconnect_user(v18)
    end
end

local function invoke_server_command(v19, v20) -- line 85 | captures: console, net, has_permissions, create_command_context, get_user
    local v21 = get_user(v19)
    local v22 = console.console.commands[v20.name]

    local function fail() -- line 92 | captures: v19, v20, net
        net.server.fire_failed_invoke_reply(v19, v20.invoke_id)
    end

    if v22 and v21 then
        local permissions = v22.permissions
        if has_permissions(v21, unpack(permissions)) then
            local v23 = create_command_context(v21, v20.invoke_id)

            local function handle(v24, ...) -- line 103 | captures: v19, v20, v21, fail, v23, console, net
                console.after_command_run:fire({
                    ok = v24,
                    who = v21,
                    command = v20.name,
                    arguments = v20.args,
                    result = { ... }
                })
                v23()
                if v24 then
                    return net.server.fire_successful_invoke_reply(v19, v20.invoke_id, { ... })
                end
                warn(...)
                return fail()
            end

            local pcall_2 = pcall
            local callback = v22.callback
            local args = v20.args
            return handle(pcall_2(callback, unpack(args)))
        end
    end
    return fail()
end

local function resend_new_commands(v25) -- line 127 | captures: console
    if v25.dirty and v25.player then
        for v26, v27 in console.console.commands do
            console.replicate_to_player(v25.player, v27)
        end
        v25.dirty = false
    end
end

local v28 = {}

local function on_ready(v29) -- line 139 | captures: net, state, get_user, resend_new_commands, v28
    if v28[v29] then
        return
    end
    v28[v29] = true
    local v30 = get_user(v29)
    v30.dirty = true
    net.server.fire_create_user(v29, v30.id, v30.name)
    for v31, v32 in state.roles do
        net.server.fire_update_role_perms_to(v29, v31, v32)
    end
    net.server.fire_update_user_roles(v29, {
        id = v30.id,
        roles = v30.roles
    })
    resend_new_commands((get_user(v29)))
end

local function initiate_default_lifecycle() -- line 160 | captures: Players, RunService, client, net, state, v1, v2, get_user, disconnect_user_for_player, invoke_server_command, resend_new_commands, on_ready
    if v2 then
        net.client.init()
        net.client.on_command_registered(client.register_command)
        net.client.on_invoke_reply(client.receive_server_results)
        net.client.on_log_received(client.log)
        net.client.on_user_info_received(client.create_local_user)
        net.client.on_role_info_received(client.update_role_permissions)
        net.client.on_user_roles_update(client.update_user_roles)
        net.client.fire_ready()
    elseif v1 then
        net.server.init()
        Players.PlayerAdded:Connect(get_user)
        Players.PlayerRemoving:Connect(disconnect_user_for_player)
        for v33, v34 in (Players:GetPlayers()) do
            get_user(v34, v33)
        end
        local v35 = Players:GetPlayers()

        local function v36(v37) -- line 183 | captures: get_user, resend_new_commands
            resend_new_commands((get_user(v37)))
        end

        for v38, v39 in v35 do
            resend_new_commands((get_user(v39)))
        end
        net.server.on_ready(on_ready)
        net.server.on_command_invoke(invoke_server_command)
        RunService.PostSimulation:Connect(function() -- line 190 | captures: state, resend_new_commands
            for v40, v41 in state.users do
                resend_new_commands(v41)
            end
        end)
    end
end

local v42 = {
    version = "0.3.1",
    args = arguments
}

function v42.execute(v43) -- line 204 | captures: console, net, state, v2, create_command_context
    local local_user = state.local_user
    assert(v2, "cannot run commands outside of the client")
    assert(local_user, "unable to run commands without a local user")
    if v2 then
        net.client.fire_log_command(v43)
    end
    local v44 = create_command_context(local_user, false)
    local v45, v46 = pcall(console.execute, v43)
    if not v45 then
        console.console.output({
            kind = "error",
            text = v46
        })
    end
    v44()
end

v42.register_quick = console.register_quick
v42.register = console.register_command

function v42.on_execution(v47) -- line 220 | captures: net
    local v48 = net.server.on_log_command(function(v49, v50) -- line 221 | captures: v47
        if typeof(v50) ~= "string" then
            v49:Kick()
        end
        v47(v49, v50)
    end)
    return function() -- line 226 | captures: v48
        v48:Disconnect()
    end
end

function v42.on_command_run(v51) -- line 228 | captures: console
    local v52 = console.after_command_run:connect(v51)
    return function() -- line 231 | captures: v52
        v52:disconnect()
    end
end

v42.initiate_default_lifecycle = initiate_default_lifecycle
v42.has_permissions = user.has_permissions
v42.set_role_permissions = set_role
v42.give_roles = user.give_roles
v42.remove_roles = user.remove_roles
v42.get_user = get_user
v42.set_var = console.write_global
v42.get_command_context = get_command_context
v42.register_type = console.register_type

function v42.log(v53, v54) -- line 248 | captures: console, net, state, v1
    if v1 then
        local v55 = state.command_context[coroutine.running()]
        if v55 then
            local player = v55.executor.player
            if player then
                net.server.fire_log(player, {
                    kind = v53,
                    text = v54
                })
            end
        end
    else
        console.console.output({
            kind = v53,
            text = v54
        })
    end
end

function v42.log_to(v56, v57, v58) -- line 260 | captures: Players, console, net, v1
    if v1 then
        net.server.fire_log(v56, {
            kind = v57,
            text = v58
        })
    elseif Players.LocalPlayer == v56 then
        console.console.output({
            kind = v57,
            text = v58
        })
    end
end

v42.register_default_commands = bootstrap
v42.console = console.console
v42.analyze = console.analyze

local v59 = {
    create_user = user.create_user,
    disconnect_user = user.disconnect_user
}

function v59.create_local_user() -- line 281 | captures: state, user, create_user
    local v60 = user.obtain_user_key(false, "local")
    local v61 = state.users[v60] or
    create_user({
        player = false,
        name = v60
    })
    state.local_user = v61
    return v61
end

v42._ = v59
return v42
