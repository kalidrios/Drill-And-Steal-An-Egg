-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
require(script.Parent.Parent.roblox_packages.language)
local v1 = if RunService:IsServer() then "server" else "client"

local function assert_run_context(v2) -- line 65 | captures: v1
    local v3 = v1 == v2
    local v4 = ("expected run context %* but got %*"):format(v2, v1)
    assert(v3, v4)
end

local v5
local v6 = {
    client = { initialized = false },
    server = { initialized = false }
}

local function init() -- line 83 | captures: v5, ReplicatedStorage, v1, v6
    local v7 = v1 == "server"
    local v8 = ("expected run context server but got %*"):format(v1)
    assert(v7, v8)
    local Folder = Instance.new("Folder")
    Folder.Name = "conch_networking"
    Folder.Parent = ReplicatedStorage

    local function remote(v9) -- line 90 | captures: Folder
        local RemoteEvent = Instance.new("RemoteEvent")
        RemoteEvent.Name = v9
        RemoteEvent.Parent = Folder
        return RemoteEvent
    end

    local v10 = {}
    local RemoteEvent = Instance.new("RemoteEvent")
    RemoteEvent.Name = "invoke_server_command"
    RemoteEvent.Parent = Folder
    v10.invoke_server_command = RemoteEvent
    local RemoteEvent_2 = Instance.new("RemoteEvent")
    RemoteEvent_2.Name = "create_user"
    RemoteEvent_2.Parent = Folder
    v10.create_user = RemoteEvent_2
    local RemoteEvent_3 = Instance.new("RemoteEvent")
    RemoteEvent_3.Name = "update_user_roles"
    RemoteEvent_3.Parent = Folder
    v10.update_user_roles = RemoteEvent_3
    local RemoteEvent_4 = Instance.new("RemoteEvent")
    RemoteEvent_4.Name = "update_role_permissions"
    RemoteEvent_4.Parent = Folder
    v10.update_role_permissions = RemoteEvent_4
    local RemoteEvent_5 = Instance.new("RemoteEvent")
    RemoteEvent_5.Name = "register_command"
    RemoteEvent_5.Parent = Folder
    v10.register_command = RemoteEvent_5
    local RemoteEvent_6 = Instance.new("RemoteEvent")
    RemoteEvent_6.Name = "log"
    RemoteEvent_6.Parent = Folder
    v10.log = RemoteEvent_6
    local RemoteEvent_7 = Instance.new("RemoteEvent")
    RemoteEvent_7.Name = "log_command"
    RemoteEvent_7.Parent = Folder
    v10.log_command = RemoteEvent_7
    local RemoteEvent_8 = Instance.new("RemoteEvent")
    RemoteEvent_8.Name = "ready"
    RemoteEvent_8.Parent = Folder
    v10.ready = RemoteEvent_8
    v5 = v10
    v6.server.initialized = true
end

v6.server.init = init

local function init_2() -- line 115 | captures: v5, ReplicatedStorage, v1, v6
    local v11 = v1 == "client"
    local v12 = ("expected run context client but got %*"):format(v1)
    assert(v11, v12)
    local conch_networking = ReplicatedStorage:WaitForChild("conch_networking")

    local function remote(v13) -- line 120 | captures: conch_networking
        return (conch_networking:WaitForChild(v13))
    end

    v5 = {
        invoke_server_command = conch_networking:WaitForChild("invoke_server_command"),
        create_user = conch_networking:WaitForChild("create_user"),
        update_user_roles = conch_networking:WaitForChild("update_user_roles"),
        update_role_permissions = conch_networking:WaitForChild("update_role_permissions"),
        register_command = conch_networking:WaitForChild("register_command"),
        log = conch_networking:WaitForChild("log"),
        log_command = conch_networking:WaitForChild("log_command"),
        ready = conch_networking:WaitForChild("ready")
    }
    v6.client.initialized = true
end

v6.client.init = init_2

local function on_ready(v14) -- line 141 | captures: v5, v1, v6
    local initialized = v6.server.initialized
    assert(initialized, "client not initialized")
    local v15 = v1 == "server"
    local v16 = ("expected run context server but got %*"):format(v1)
    assert(v15, v16)
    v5.ready.OnServerEvent:Connect(v14)
end

v6.server.on_ready = on_ready

local function fire_ready() -- line 148 | captures: v5, v1, v6
    local initialized = v6.client.initialized
    assert(initialized, "client not initialized")
    local v17 = v1 == "client"
    local v18 = ("expected run context client but got %*"):format(v1)
    assert(v17, v18)
    v5.ready:FireServer()
end

v6.client.fire_ready = fire_ready

local function on_user_roles_update(v19) -- line 155 | captures: v5, v1, v6
    local initialized = v6.client.initialized
    assert(initialized, "client not initialized")
    local v20 = v1 == "client"
    local v21 = ("expected run context client but got %*"):format(v1)
    assert(v20, v21)
    v5.update_user_roles.OnClientEvent:Connect(v19)
end

v6.client.on_user_roles_update = on_user_roles_update

local function on_command_registered(v22) -- line 166 | captures: v5, v1, v6
    local initialized = v6.client.initialized
    assert(initialized, "client not initialized")
    local v23 = v1 == "client"
    local v24 = ("expected run context client but got %*"):format(v1)
    assert(v23, v24)
    v5.register_command.OnClientEvent:Connect(v22)
end

v6.client.on_command_registered = on_command_registered

local function on_role_info_received(v25) -- line 175 | captures: v5, v1, v6
    local initialized = v6.client.initialized
    assert(initialized, "client not initialized")
    local v26 = v1 == "client"
    local v27 = ("expected run context client but got %*"):format(v1)
    assert(v26, v27)
    v5.update_role_permissions.OnClientEvent:Connect(v25)
end

v6.client.on_role_info_received = on_role_info_received

local function on_user_info_received(v28) -- line 184 | captures: v5, v1, v6
    local initialized = v6.client.initialized
    assert(initialized, "client not initialized")
    local v29 = v1 == "client"
    local v30 = ("expected run context client but got %*"):format(v1)
    assert(v29, v30)
    v5.create_user.OnClientEvent:Connect(v28)
end

v6.client.on_user_info_received = on_user_info_received

local function on_log_received(v31) -- line 191 | captures: v5, v1, v6
    local initialized = v6.client.initialized
    assert(initialized, "client not initialized")
    local v32 = v1 == "client"
    local v33 = ("expected run context client but got %*"):format(v1)
    assert(v32, v33)
    v5.log.OnClientEvent:Connect(v31)
end

v6.client.on_log_received = on_log_received

local function invoke_command(v34, v35, v36) -- line 198 | captures: v5, v1, v6
    local initialized = v6.client.initialized
    assert(initialized, "client not initialized")
    local v37 = v1 == "client"
    local v38 = ("expected run context client but got %*"):format(v1)
    assert(v37, v38)
    local v39 = {
        invoke_id = v34,
        name = v35,
        args = v36
    }
    v5.invoke_server_command:FireServer(v39)
end

v6.client.invoke_command = invoke_command

local function on_invoke_reply(v40) -- line 215 | captures: v5, v1, v6
    local initialized = v6.client.initialized
    assert(initialized, "client not initialized")
    local v41 = v1 == "client"
    local v42 = ("expected run context client but got %*"):format(v1)
    assert(v41, v42)
    v5.invoke_server_command.OnClientEvent:Connect(v40)
end

v6.client.on_invoke_reply = on_invoke_reply

local function fire_log_command(v43) -- line 222 | captures: v5, v1, v6
    local initialized = v6.client.initialized
    assert(initialized, "client not initialized")
    local v44 = v1 == "client"
    local v45 = ("expected run context client but got %*"):format(v1)
    assert(v44, v45)
    v5.log_command:FireServer(v43)
end

v6.client.fire_log_command = fire_log_command

local function on_log_command(v46) -- line 229 | captures: v5, v1, v6
    local initialized = v6.server.initialized
    assert(initialized, "server not initialized")
    local v47 = v1 == "server"
    local v48 = ("expected run context server but got %*"):format(v1)
    assert(v47, v48)
    return v5.log_command.OnServerEvent:Connect(v46)
end

v6.server.on_log_command = on_log_command

local function fire_log(v49, v50) -- line 236 | captures: v5, v1, v6
    local initialized = v6.server.initialized
    assert(initialized, "server not initialized")
    local v51 = v1 == "server"
    local v52 = ("expected run context server but got %*"):format(v1)
    assert(v51, v52)
    v5.log:FireClient(v49, v50)
end

v6.server.fire_log = fire_log

local function fire_register_command(v53, v54) -- line 243 | captures: v5, v1, v6
    local initialized = v6.server.initialized
    assert(initialized, "server not initialized")
    local v55 = v1 == "server"
    local v56 = ("expected run context server but got %*"):format(v1)
    assert(v55, v56)
    v5.register_command:FireClient(v53, v54)
end

v6.server.fire_register_command = fire_register_command

local function on_command_invoke(v57) -- line 253 | captures: v5, v1, v6
    local initialized = v6.server.initialized
    assert(initialized, "server not initialized")
    local v58 = v1 == "server"
    local v59 = ("expected run context server but got %*"):format(v1)
    assert(v58, v59)
    v5.invoke_server_command.OnServerEvent:Connect(v57)
end

v6.server.on_command_invoke = on_command_invoke

local function fire_successful_invoke_reply(v60, v61, v62) -- line 263 | captures: v5, v1, v6
    local initialized = v6.server.initialized
    assert(initialized, "server not initialized")
    local v63 = v1 == "server"
    local v64 = ("expected run context server but got %*"):format(v1)
    assert(v63, v64)
    local v65 = {
        status = "ok",
        invoke_id = v61,
        results = v62
    }
    v5.invoke_server_command:FireClient(v60, v65)
end

v6.server.fire_successful_invoke_reply = fire_successful_invoke_reply

local function fire_failed_invoke_reply(v66, v67) -- line 280 | captures: v5, v1, v6
    local initialized = v6.server.initialized
    assert(initialized, "server not initialized")
    local v68 = v1 == "server"
    local v69 = ("expected run context server but got %*"):format(v1)
    assert(v68, v69)
    local v70 = {
        status = "err",
        invoke_id = v67
    }
    v5.invoke_server_command:FireClient(v66, v70)
end

v6.server.fire_failed_invoke_reply = fire_failed_invoke_reply

local function fire_create_user(v71, v72, v73) -- line 292 | captures: v5, v1, v6
    local initialized = v6.server.initialized
    assert(initialized, "server not initialized")
    local v74 = v1 == "server"
    local v75 = ("expected run context server but got %*"):format(v1)
    assert(v74, v75)
    local v76 = {
        name = v73,
        id = v72
    }
    v5.create_user:FireClient(v71, v76)
end

v6.server.fire_create_user = fire_create_user

local function fire_update_user_roles(v77, v78) -- line 304 | captures: v5, v1, v6
    local initialized = v6.server.initialized
    assert(initialized, "server not initialized")
    local v79 = v1 == "server"
    local v80 = ("expected run context server but got %*"):format(v1)
    assert(v79, v80)
    v5.update_user_roles:FireClient(v77, v78)
end

v6.server.fire_update_user_roles = fire_update_user_roles

local function fire_update_role_perms(v81, v82) -- line 314 | captures: v5, v1, v6
    local initialized = v6.server.initialized
    assert(initialized, "server not initialized")
    local v83 = v1 == "server"
    local v84 = ("expected run context server but got %*"):format(v1)
    assert(v83, v84)
    local v85 = {
        name = v81,
        permissions = v82
    }
    v5.update_role_permissions:FireAllClients(v85)
end

v6.server.fire_update_role_perms = fire_update_role_perms

local function fire_update_role_perms_to(v86, v87, v88) -- line 329 | captures: v5, v1, v6
    local initialized = v6.server.initialized
    assert(initialized, "server not initialized")
    local v89 = v1 == "server"
    local v90 = ("expected run context server but got %*"):format(v1)
    assert(v89, v90)
    local v91 = {
        name = v87,
        permissions = v88
    }
    v5.update_role_permissions:FireClient(v86, v91)
end

v6.server.fire_update_role_perms_to = fire_update_role_perms_to
return v6
