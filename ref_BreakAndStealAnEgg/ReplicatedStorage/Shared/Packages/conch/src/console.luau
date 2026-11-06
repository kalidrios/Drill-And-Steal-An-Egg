-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local language = require(script.Parent.Parent.roblox_packages.language)
local net = require(script.Parent.net)
local signal = require(script.Parent.signal)
local state = require(script.Parent.state)
require(script.Parent.types)
local user = require(script.Parent.user)
local v1 = RunService:IsServer()
local v2 = language.create_vm()
local v3 = {}
local v4 = signal()
local v5 = {
    vm = v2,
    commands = v3,
    output = print
}
local v6 = {}

local function register_type(v7, v8) -- line 25 | captures: v6
    v6[v7] = v8
    if v8.analysis then
        local v9 = v8.analysis.kind == "argument"
        assert(v9)
        v8.analysis.unique_identifier = v7
    end
    return function(v10, v11) -- line 39 | captures: v7, v8
        if v8.analysis then
            local v12 = v8.analysis.kind == "argument"
            assert(v12)
            local v13 = {
                kind = "argument",
                optional = false,
                vararg = false
            }
            v13.name = v10 or v8.analysis.name
            v13.description = v11 or ""
            v13.type = v8.analysis.type
            v13.unique_identifier = v7
            v13.suggestions = v8.analysis.suggestions
            return v13
        end
        local v14 = {
            kind = "argument",
            optional = false,
            vararg = false
        }
        v14.name = v10 or v7
        v14.description = v11 or ""
        v14.type = v7
        v14.unique_identifier = v7

        function v14.suggestions() -- line 63
            return {}
        end

        return v14
    end
end

local function write_global(v15, v16) -- line 72 | captures: language, v1, v2
    local v17 = not v1
    assert(v17, "cannot set global on server")
    local v18 = string.match(v15, "^[A-z%-@_]*$")
    local v19 = ("%* is not a valid name"):format(v15)
    assert(v18, v19)
    language.set_command(v2, v15, v16)
end

local function get_type(v20) -- line 78 | captures: v6
    return v6[v20]
end

local function replicate_to_player(v21, v22) -- line 80 | captures: net, state, user
    local v23 = user.obtain_user_key(v21)
    local v24 = state.users[v23]
    if not v24 then
        return
    end
    local has_permissions = user.has_permissions
    local permissions = v22.permissions
    if has_permissions(v24, unpack(permissions)) then
        net.server.fire_register_command(v21, {
            name = v22.name,
            description = v22.description,
            permissions = v22.permissions,
            overloads = v22.information.overloads
        })
    end
end

local v25 = false

local function execute(v26) -- line 107 | captures: v25, language, v2, v5
    local v27 = not v25
    assert(v27, "already executing!")
    v5.output({
        kind = "info",
        text = ("> %*"):format(v26)
    })
    v25 = true
    local v28 = language.run(v2, v26)
    if v28.ok then
        for v29, v30 in v28.values or {} do
            v5.output({
                kind = "normal",
                text = tostring(v30)
            })
        end
    else
        v5.output({
            kind = "error",
            text = table.concat(v28.why, "\n")
        })
    end
    v25 = false
end

local function determine_overload(v31, ...) -- line 126
    if #v31 == 1 then
        return v31[1]
    end
    local v32 = table.clone(v31)
    local v33 = select("#", ...)
    for v34 = 1, v33 do
        local v35 = select(v34, ...)
        local v36 = #v32
        for v37 = v36, 1, -1 do
            local v38 = v32[v37].arguments[v34]
            if not v38 then
                table.remove(v32, v37)
            end
            if v38.kind == "literal" then
                if v38.optional then
                    if v35 ~= nil and v38.value ~= v35 then
                        table.remove(v32, v37)
                    end
                elseif v38.value ~= v35 then
                    table.remove(v32, v37)
                end
            end
        end
        if #v32 > 0 then
            v32 = table.clone(v32)
        end
    end
    if #v32 == 0 then
        error("no overload matches the given command")
    end
    return v32[1]
end

local function register_command(v39, v40) -- line 160 | captures: Players, language, state, v1, v2, v3, v4, v6, replicate_to_player, determine_overload
    local v41 = { v40.arguments() } or
    {
        {
            kind = "argument",
            name = "...",
            description = "unspecified",
            type = "any",
            optional = false,
            vararg = true,
            suggestions = function() -- suggestions | line 177
                return {}
            end
        }
    }
    local v42 = {}
    local v43 = {}
    if v41[1] and v41[1].kind == "overload" then
        local v44 = v41[1]
        local v45 = v44.kind == "overload"
        assert(v45)
        for v46, v47 in v44.overloads do
            local v48 = {}
            local v49 = {}
            for v50, v51 in v47.arguments do
                if v51.kind == "argument" then
                    local unique_identifier = v51.unique_identifier
                    local v52 = v6[unique_identifier] or warn((("no argument of type \"%*\" is registered"):format(v51.unique_identifier))) or v6.any
                    v48[v50] = v52.convert
                    if v52.analysis and v52.analysis.kind == "argument" and v52.analysis.type ~= "any" then
                        local v53 = table.clone(v52.analysis)
                        local v54 = v53.kind == "argument"
                        assert(v54)
                        v53.vararg = v51.vararg
                        v53.optional = v51.optional
                    end
                    v49[v50] = v51
                end
            end
            table.insert(v43, v47)
            v42[v47] = v48
        end
    else
        local v55 = {}
        local v56 = {}
        for v57, v58 in v41 do
            local v59 = v58.kind ~= "overload"
            assert(v59, "overloads must be the first argument")
            if v58.kind == "argument" then
                local unique_identifier = v58.unique_identifier
                local v60 = v6[unique_identifier] or warn((("no argument of type \"%*\" is registered"):format(v58.type))) or v6.any
                v55[v57] = v60.convert
                if v60.analysis and v60.analysis.kind == "argument" and v60.analysis.type ~= "any" then
                    local v61 = table.clone(v60.analysis)
                    local v62 = v61.kind == "argument"
                    assert(v62)
                    v61.vararg = v58.vararg
                    v61.optional = v58.optional
                end
                v56[v57] = v58
            end
        end
        local v63 = {
            description = v40.description,
            arguments = v56
        }
        table.insert(v43, v63)
        v42[v63] = v55
    end
    local v64 = {
        dirty_replicate = true,
        name = v39,
        description = v40.description,
        permissions = v40.permissions,
        information = {
            name = v39,
            description = v40.description or "",
            key = v39,
            overloads = v43
        },
        callback = v40.callback
    }
    v3[v39] = v64
    if not v1 then
        local function v65(...) -- line 286 | captures: v39, v40, v42, v43, state, v4, determine_overload
            local function v66(v67, v68, ...)
                return unpack(v67, v68, ...)
            end

            local v69 = determine_overload(v43, ...)
            if not v69 then
                error("could not match with an overload")
            end
            local v70 = { ... }
            local v71 = v42[v69]
            local v72, v73
            for v74, v75 in v69.arguments do
                if v75.kind == "argument" and v75.vararg then
                    v72 = v71[v74]
                    v73 = v74
                    break
                end
                if v75.optional and select(v74, ...) == nil then
                    v70[v74] = nil
                elseif v71[v74] then
                    v70[v74] = v71[v74]((select(v74, ...)))
                else
                    v70[v74] = select(v74, ...)
                end
                v72 = nil
                v73 = nil
            end
            if v72 and v73 then
                local v76 = v73 + 1
                local v77 = select("#", ...)
                for v78 = v76, v77 do
                    v70[v78] = v72((select(v78, ...)))
                end
            end
            local v79 = { pcall(v40.callback, v66(v70, 1, select("#", ...))) }
            local v80 = table.remove(v79, 1)
            local v81 = state.command_context[coroutine.running()]
            local v82 = { ok = v80 }
            v82.who = v81 and v81.executor
            v82.command = v39
            v82.arguments = v70
            v82.result = v79
            v4:fire(v82)
            if not v80 then
                error(v79[2], 0)
            end
            return unpack(v79)
        end

        local v83 = not v1
        assert(v83, "cannot set global on server")
        local v84 = string.match(v39, "^[A-z%-@_]*$")
        local v85 = ("%* is not a valid name"):format(v39)
        assert(v84, v85)
        language.set_command(v2, v39, v65)
    end
    if v1 then
        for v86, v87 in Players:GetPlayers() do
            replicate_to_player(v87, v64)
        end
    end
    language.attach_info(v2, {
        is_var = false,
        name = v39,
        description = v40.description or "",
        key = v39,
        overloads = v43
    })
    return v64
end

local function register(v88, v89, ...) -- line 354 | captures: register_command
    register_command(v88, {
        name = v88,
        callback = v89,
        arguments = function() -- line 358
        end,
        permissions = { ... }
    })
end

return {
    console = v5,
    register_quick = register,
    register_command = register_command,
    replicate_to_player = replicate_to_player,
    execute = execute,
    analyze = function(v90, v91) -- analyze | line 363 | captures: language, v2
        return language.analyze(v2, v90, v91)
    end,
    write_global = write_global,
    after_command_run = v4,
    register_type = register_type,
    get_type = get_type
}
