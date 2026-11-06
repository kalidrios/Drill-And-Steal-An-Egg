-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local constants = require(script.Parent.constants)
local net = require(script.Parent.net)
local state = require(script.Parent.state)
require(script.Parent.types)
local v1 = RunService:IsServer()

local function obtain_user_key(v2, v3) -- line 11
    if v2 then
        return (("player-%*"):format(v2.UserId))
    end
    return (("server-%*"):format(v3))
end

local function create_user(v4) -- line 15 | captures: net, state, v1
    local v5 = {
        disconnected = false,
        dirty = false
    }
    local player = v4.player
    local name = v4.name
    if player then
        v5.id = ("player-%*"):format(player.UserId)
    else
        v5.id = ("server-%*"):format(name)
    end
    v5.name = v4.name
    v5.player = v4.player
    v5.roles = {}
    if v1 and v5.player then
        net.server.fire_create_user(v5.player, v5.id, v5.name)
    end
    state.users[v5.id] = v5
    return v5
end

local function has_permissions(v6, ...) -- line 38 | captures: constants, state
    local v7 = { ... }
    for v8, v9 in v6.roles do
        if constants.ADMIN_ROLE == v9 then
            return true
        end
        if state.roles[v9] then
            for v10, v11 in state.roles[v9] do
                local v12 = table.find(v7, v11)
                if v12 then
                    table.remove(v7, v12)
                    if #v7 == 0 then
                        return true
                    end
                end
            end
        end
    end
    return false
end

return {
    obtain_user_key = obtain_user_key,
    create_user = create_user,
    disconnect_user = function(v13) -- disconnect_user | line 57 | captures: state
        if v13.disconnected ~= true then
            v13.disconnected = true
            state.users[v13.id] = nil
        end
    end,
    has_permissions = has_permissions,
    give_roles = function(v14, ...) -- give_roles | line 65 | captures: net, v1
        if v14.disconnected then
            return
        end
        local v15 = {}
        local v16 = select("#", ...)
        for v17 = 1, v16 do
            local v18 = select(v17, ...)
            if not table.find(v15, v18) then
                table.insert(v15, v18)
            end
        end
        for v19, v20 in v14.roles do
            if not table.find(v15, v20) then
                table.insert(v15, v20)
            end
        end
        v14.roles = v15
        if v1 and v14.player then
            v14.dirty = true
            net.server.fire_update_user_roles(v14.player, {
                id = v14.id,
                roles = v15
            })
        end
    end,
    remove_roles = function(v21, ...) -- remove_roles | line 92 | captures: RunService, net
        if v21.disconnected then
            return
        end
        local v22 = table.clone(v21.roles)
        local v23 = { ... }
        local v24 = #v22
        for v25 = v24, 1, -1 do
            if table.find(v23, v22[v25]) then
                v22[v25] = v22[#v22]
                v22[#v22] = nil
            end
        end
        v21.roles = v22
        if RunService:IsServer() and v21.player then
            v21.dirty = true
            net.server.fire_update_user_roles(v21.player, {
                id = v21.id,
                roles = v22
            })
        end
    end
}
