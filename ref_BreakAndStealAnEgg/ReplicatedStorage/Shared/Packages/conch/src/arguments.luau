-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local console = require(script.Parent.console)
local context = require(script.Parent.context)
require(script.Parent.Parent.roblox_packages.language)
require(script.Parent.types)

local function noop(v1) -- line 8
    return v1
end

local function wrap_if_not(v2) -- line 10
    if type(v2) == "table" then
        return v2
    end
    return { v2 }
end

local v3 = {
    convert = noop,
    analysis = {
        kind = "argument",
        optional = false,
        name = "any",
        type = "any",
        vararg = false
    }
}
local v4 = {
    convert = tostring,
    analysis = {
        kind = "argument",
        optional = false,
        name = "string",
        type = "string"
    }
}
local v5 = {
    convert = function(v6) -- convert | line 39
        if typeof(v6) == "table" then
            local v7 = table.clone(v6)
            for v8, v9 in v7 do
                v7[v8] = tostring(v9)
            end
            return v7
        end
        return { (tostring(v6)) }
    end,
    analysis = {
        kind = "argument",
        optional = false,
        name = "strings",
        type = "{ string }"
    }
}
local v10 = {
    convert = function(v11) -- convert | line 60
        local v12 = tonumber(v11)
        if v12 == nil then
            error((("%* is not a valid number"):format(v11)))
        end
        return v12
    end,
    analysis = {
        kind = "argument",
        optional = false,
        name = "number",
        type = "number"
    }
}
local v13 = {
    convert = function(v14) -- convert | line 75
        local v15 = if type(v14) == "table" then v14 else { v14 }
        local v16 = {}
        for v17, v18 in v15 do
            local v19 = tonumber(v15)
            if v19 == nil then
                error((("%* is not a valid number"):format(v15)))
            end
            v16[v17] = v19
        end
        return v16
    end,
    analysis = {
        kind = "argument",
        optional = false,
        vararg = false,
        name = "numbers",
        type = "{ number }"
    }
}
local v20 = {
    convert = function(v21) -- convert | line 96
        if typeof(v21) == "boolean" then
            return v21
        end
        if typeof(v21) == "number" and v21 > 0 then
            return true
        end
        if typeof(v21) == "number" and v21 <= 0 then
            return false
        end
        error((("%* is not a valid boolean"):format((typeof(v21)))))
    end,
    analysis = {
        kind = "argument",
        optional = false,
        vararg = false,
        name = "boolean",
        type = "boolean",
        suggestions = function() -- suggestions | line 115
            return {
                {
                    text = "true",
                    display = "true"
                },
                {
                    text = "false",
                    display = "false"
                }
            }
        end
    }
}
local v22 = {
    convert = function(v23) -- convert | line 125
        if typeof(v23) == "table" then
            local v24 = table.clone(v23)
            for v25, v26 in v24 do
                if typeof(v26) == "boolean" then
                    v24[v25] = v26
                elseif typeof(v26) == "number" and v26 > 0 then
                    v24[v25] = true
                elseif typeof(v26) == "number" and v26 <= 0 then
                    v24[v25] = false
                else
                    error((("type %* of %* is not a valid boolean"):format(typeof(v26), v25)))
                end
            end
            return v24
        end
        if typeof(v23) == "boolean" then
            return { v23 }
        end
        if typeof(v23) == "number" and v23 > 0 then
            return { true }
        end
        if typeof(v23) == "number" and v23 <= 0 then
            return { false }
        end
        error((("%* is not a valid boolean"):format((typeof(v23)))))
    end,
    analysis = {
        kind = "argument",
        optional = false,
        vararg = false,
        name = "boolean",
        type = "{ boolean }",
        suggestions = function() -- suggestions | line 158
            return {
                {
                    text = "true",
                    display = "true"
                },
                {
                    text = "false",
                    display = "false"
                }
            }
        end
    }
}
local v27 = {
    convert = noop,
    analysis = {
        kind = "argument",
        optional = false,
        name = "table",
        type = "table"
    }
}
local v28 = {
    convert = function(v29) -- into_vector | line 178
        if type(v29) == "vector" then
            return v29
        end
        if typeof(v29) == "table" then
            local v30 = v29[1] or 0
            local v31 = v29[2] or 0
            local v32 = v29[3] or 0
            return (vector.create(v30, v31, v32))
        end
        error(("%* is not valid"):format(v29), 0)
    end,
    analysis = {
        kind = "argument",
        optional = false,
        vararg = false,
        name = "vector",
        type = "vector"
    }
}
local v33 = {
    convert = function(v34) -- convert | line 200
        if type(v34) == "vector" then
            return { v34 }
        end
        if typeof(v34) == "table" then
            local v35 = {}
            for v36, v37 in v34 do
                if type(v37) == "vector" then
                    v35[v36] = v37
                elseif typeof(v37) == "table" then
                    local v38 = v37[1] or 0
                    local v39 = v37[2] or 0
                    local v40 = v37[3] or 0
                    v35[v36] = vector.create(v38, v39, v40)
                else
                    error(("%* is not valid"):format(v37), 0)
                    v35[v36] = nil
                end
            end
            return v35
        end
        error(("%* is not valid"):format(v34), 0)
    end,
    analysis = {
        kind = "argument",
        optional = false,
        vararg = false,
        name = "vector",
        type = "vector"
    }
}

local function enum_map(v41, v42, v43) -- line 228
    local v44 = {}

    function v44.convert(v45) -- line 234 | captures: v41
        local v46 = tostring(v45)
        if v41[v46] == nil then
            error(("%* is not valid"):format(v46), 0)
        end
        return v41[v46]
    end

    local v47 = {
        kind = "argument",
        optional = false,
        vararg = false,
        name = v42 or "enum",
        description = v43,
        type = v42 or "enum"
    }

    function v47.suggestions() -- line 247 | captures: v41
        local v48 = {}
        for v49 in v41 do
            local v50 = {
                text = v49,
                display = v49
            }
            table.insert(v48, v50)
        end
        return v48
    end

    v44.analysis = v47
    return v44
end

local function enum_new(v51, v52, v53) -- line 261 | captures: enum_map
    local v54 = {}
    for v55, v56 in v51 do
        v54[tostring(v56)] = v56
    end
    return (enum_map(v54, v52, v53))
end

local function convert_arg_to_player(v57) -- line 271 | captures: Players, context
    local v58 = context.get_command_context()
    if v57 == "@s" then
        return v58 and v58.executor.player or error("not executed by a player")
    end
    if typeof(v57) == "number" then
        local v59 = Players:GetPlayerByUserId(v57)
        local v60 = ("player with id %* is not in this server"):format(v57)
        return (assert(v59, v60))
    end
    if typeof(v57) == "string" then
        local v61 = Players:FindFirstChild(v57)
        local v62 = ("player \"%*\" is not valid"):format(v57)
        return (assert(v61, v62))
    end
    if typeof(v57) == "Instance" and v57:IsA("Player") then
        return v57
    end
    error((("unknown arg %*"):format(v57)))
end

local function convert_arg_to_players(v63) -- line 296 | captures: Players, convert_arg_to_player
    if v63 == "@a" then
        return Players:GetPlayers()
    end
    if typeof(v63) == "table" then
        local v64 = table.clone(v63)
        for v65, v66 in v64 do
            v64[v65] = convert_arg_to_player(v66)
        end
        return v64
    end
    return { convert_arg_to_player(v63) }
end

local v67 = {}

function v67.convert(v68) -- line 315 | captures: convert_arg_to_player
    return convert_arg_to_player(v68)
end

local v69 = {
    kind = "argument",
    optional = false,
    vararg = false,
    name = "player",
    type = "Player"
}

function v69.suggestions() -- line 323 | captures: Players
    local v70 = {}
    for v71, v72 in Players:GetPlayers() do
        local v73 = {
            text = v72.Name,
            display = ("%* (@%*)"):format(v72.DisplayName, v72.Name)
        }
        table.insert(v70, v73)
    end
    return v70
end

v67.analysis = v69

local v74 = {}

function v74.convert(v75) -- line 339 | captures: convert_arg_to_players
    return convert_arg_to_players(v75)
end

local v76 = {
    kind = "argument",
    optional = false,
    name = "players",
    vararg = false,
    type = "{ Player }"
}

function v76.suggestions(v77) -- line 347 | captures: Players
    local v78 = {}
    for v79, v80 in Players:GetPlayers() do
        local v81 = {
            text = v80.Name,
            display = ("%* (@%*)"):format(v80.DisplayName, v80.Name)
        }
        table.insert(v78, v81)
    end
    return v78
end

v74.analysis = v76

local function convert_arg_to_userid(v82) -- line 362 | captures: Players, context
    local function v83(...)
        assert(...)
    end

    local v84 = context.get_command_context()
    if v82 == "@s" then
        local v85, v86
        if v84 and v84.executor.player then
            local UserId = v84.executor.player.UserId
            if UserId then
                v85 = UserId
                v86 = true
            else
                v86 = false
            end
        else
            v86 = false
        end
        if not v86 then
            v85 = error("not executed by a proyer")
        end
        return v85
    end
    if typeof(v82) == "number" then
        local v87, v88 = pcall(function() -- line 371 | captures: v82, Players
            return Players:GetNameFromUserIdAsync(v82)
        end)
        if not v87 and v88:find("Unknown User") then
            error(("No user found with UserId %*"):format(v82), 0)
        end
        return v82
    end
    if typeof(v82) == "string" then
        local v89 = Players:FindFirstChild(v82)
        if v89 then
            v83(v89:IsA("Player"))
            return v89.UserId
        end
        local v90, v91 = pcall(function() -- line 384 | captures: v82, Players
            return Players:GetUserIdFromNameAsync(v82)
        end)
        if v90 or not v91:find("Unknown User") then
            error(("Could not fetch player name, try again later: %*"):format(v82), 0)
        else
            error(("No user found with name %*"):format(v82), 0)
        end
        return v91
    end
    if typeof(v82) == "Instance" and v82:IsA("Player") then
        return v82.UserId
    end
    error(("unknown arg %*"):format(v82), 0)
end

local function convert_arg_to_userids(v92) -- line 406 | captures: Players, convert_arg_to_userid
    local v93
    if v92 == "@a" then
        v93 = Players:GetPlayers()
    else
        v93 = v92
    end
    if typeof(v93) == "table" then
        local v94 = {}
        for v95, v96 in v94 do
            v94[v95] = convert_arg_to_userid(v96)
        end
        return v94
    end
    return { convert_arg_to_userid(v93) }
end

local v97 = {}

function v97.convert(v98) -- line 425 | captures: convert_arg_to_userid
    return convert_arg_to_userid(v98)
end

local v99 = {
    kind = "argument",
    optional = false,
    name = "userid",
    type = "number",
    vararg = false
}

function v99.suggestions() -- line 433 | captures: Players
    local v100 = {}
    for v101, v102 in Players:GetPlayers() do
        local v103 = {
            text = v102.Name,
            display = ("%* (@%*)"):format(v102.DisplayName, v102.Name)
        }
        table.insert(v100, v103)
    end
    return v100
end

v97.analysis = v99

local v104 = {}

function v104.convert(v105) -- line 449 | captures: convert_arg_to_userids
    return (convert_arg_to_userids(v105))
end

local v106 = {
    kind = "argument",
    optional = false,
    name = "userids",
    type = "{ number }",
    vararg = false
}

function v106.suggestions() -- line 457 | captures: Players
    local v107 = {}
    for v108, v109 in Players:GetPlayers() do
        local v110 = {
            text = v109.Name,
            display = ("%* (@%*)"):format(v109.DisplayName, v109.Name)
        }
        table.insert(v107, v110)
    end
    return v107
end

v104.analysis = v106

local v111 = {
    convert = function(v112) -- convert | line 473
        if typeof(v112) == "Color3" then
            return v112
        end
        if typeof(v112) == "string" then
            return (Color3.fromHex(v112))
        end
        if type(v112) == "vector" then
            return (Color3.fromRGB(v112.x, v112.y, v112.z))
        end
        return (error(("cannot convert %* into color3"):format((typeof(v112))), 0))
    end,
    analysis = {
        kind = "argument",
        optional = false,
        vararg = false,
        name = "Color3",
        type = "Color3"
    }
}
local v113 = {
    convert = function(v114) -- convert | line 495
        if typeof(v114) == "Color3" then
            return v114
        end
        if typeof(v114) == "string" then
            return (Color3.fromHex(v114))
        end
        if type(v114) == "vector" then
            return (Color3.fromRGB(v114.x, v114.y, v114.z))
        end
        if typeof(v114) == "table" then
            local v115 = {}
            for v116, v117 in v114 do
                if typeof(v117) == "Color3" then
                    v115[v116] = v114
                elseif typeof(v117) == "string" then
                    v115[v116] = Color3.fromHex(v117)
                elseif type(v117) == "vector" then
                    v115[v116] = Color3.fromRGB(v117.x, v117.y, v117.z)
                else
                    v115[v116] = error(("cannot convert %* into color3"):format((typeof(v114))), 0)
                end
            end
            return v115
        end
        return (error(("cannot convert %* into color3"):format((typeof(v114))), 0))
    end,
    analysis = {
        kind = "argument",
        optional = false,
        vararg = false,
        name = "Color3",
        type = "Color3"
    }
}
local v118 = {
    ms = 0.001,
    milisecond = 0.001,
    miliseconds = 0.001,
    s = 1,
    sec = 1,
    second = 1,
    seconds = 1,
    min = 60,
    minute = 60,
    minutes = 60,
    hr = 3600,
    hour = 3600,
    hours = 3600,
    d = 86400,
    day = 86400,
    days = 86400,
    wk = 604800,
    week = 604800,
    weeks = 604800,
    mo = 2592000,
    month = 2592000,
    months = 2592000,
    y = 31536000,
    yr = 31536000,
    year = 31536000,
    years = 31536000
}

local function parse_duration(v119) -- line 574 | captures: v118
    local v120 = 0
    for v121, v122 in (string.split(v119, " ")) do
        local v123, v124 = string.match(v122, "(.-)[%s]?([A-z]+)$")
        if v123 and v124 then
            local v125 = v118[v124]
            if not v125 then
                error(("\"%*\" is not a valid suffix"):format(v125), 0)
            end
            local v126 = tonumber(v123)
            if not v126 then
                error(("could not convert \"%*\" into a duration"):format(v122), 0)
            end
            v120 += v126 * v125
        else
            local v127 = tonumber(v122)
            if not v127 then
                error(("could not convert \"%*\" into a duration"):format(v122), 0)
            end
            v120 += v127
        end
    end
    return v120
end

local v128 = {}

function v128.convert(v129) -- line 601 | captures: parse_duration
    if typeof(v129) == "number" then
        return v129
    end
    return (parse_duration(v129))
end

local v130 = {
    kind = "argument",
    optional = false,
    vararg = false,
    name = "duration",
    type = "number"
}

function v130.suggestions(v131) -- line 612 | captures: v118
    local v132 = string.split(v131:gsub("\"(.*)\"", "%1"), " ")
    local v133 = v132[#v132] or "1"
    local v134 = {}
    local v135 = table.concat(v132, " ", 1, #v132 - 1)
    local v136, v137 = string.match(v133, "(.-)([A-z]+)$")
    if v137 then
        for v138 in v118 do
            local v139 = {
                text = ("%*%*"):format(v136, v138),
                display = ("%*%*"):format(v136, v138)
            }
            table.insert(v134, v139)
        end
    else
        for v140 in v118 do
            local v141 = {
                text = ("%*%*"):format(v133, v140),
                display = ("%*%*"):format(v133, v140)
            }
            table.insert(v134, v141)
        end
    end
    if #v135 > 0 then
        v135 = ("%* "):format(v135)
    end
    for v142, v143 in v134 do
        v134[v142] = {
            text = ("%*%*"):format(v135, v143.text),
            display = ("%*%*"):format(v135, v143.display)
        }
    end
    return v134
end

v128.analysis = v130

local function generate_names_for_enum(v144) -- line 649 | captures: enum_map
    local v145 = {}
    for v146, v147 in v144:GetEnumItems() do
        v145[v147.Name] = v147
    end
    return (enum_map(v145, (tostring(v144))))
end

local function variadic(v148) -- line 661
    local v149 = v148.kind == "argument"
    assert(v149)
    v148.vararg = true
    return v148
end

local function optional(v150) -- line 668
    v150.optional = true
    return v150
end

local function literal(v151, v152, v153) -- line 674
    return {
        kind = "literal",
        optional = false,
        name = v152 or "",
        description = v153 or "",
        value = v151
    }
end

return {
    overload = function(v154) -- overload | line 684
        return {
            kind = "overload",
            overloads = v154
        }
    end,
    literal = literal,
    any = console.register_type("any", v3),
    string = console.register_type("string", v4),
    strings = console.register_type("strings", v5),
    number = console.register_type("number", v10),
    numbers = console.register_type("numbers", v13),
    boolean = console.register_type("boolean", v20),
    booleans = console.register_type("booleans", v22),
    table = console.register_type("table", v27),
    vector = console.register_type("vector", v28),
    vectors = console.register_type("vectors", v33),
    player = console.register_type("player", v67),
    players = console.register_type("players", v74),
    userid = console.register_type("userid", v97),
    userids = console.register_type("userids", v104),
    color = console.register_type("color", v111),
    colors = console.register_type("colors", v113),
    duration = console.register_type("duration", v128),
    userinput = console.register_type("userinput", (generate_names_for_enum(Enum.UserInputType))),
    variadic = variadic,
    optional = optional,
    opt = optional,
    enum_new = enum_new,
    enum_map = enum_map
}
