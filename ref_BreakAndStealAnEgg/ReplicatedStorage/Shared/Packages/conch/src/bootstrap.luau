-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local arguments = require(script.Parent.arguments)
local console = require(script.Parent.console)
local state = require(script.Parent.state)
require(script.Parent.types)
local v1 = RunService:IsClient()

local function output(v2) -- line 37 | captures: console
    console.console.output(v2)
end

local function concat(...) -- line 39
    local v3 = { ... }
    for v4, v5 in v3 do
        v3[v4] = tostring(v5)
    end
    return table.concat(v3, " ")
end

local function conch_print(...) -- line 47 | captures: console, concat
    local v6 = {
        kind = "normal",
        text = concat(...)
    }
    console.console.output(v6)
end

local function conch_error(...) -- line 52 | captures: concat
    local v7 = concat(...)
    error(v7, 0)
end

local function conch_warn(...) -- line 57 | captures: console, concat
    local v8 = {
        kind = "warn",
        text = concat(...)
    }
    console.console.output(v8)
end

local function conch_info(...) -- line 62 | captures: console, concat
    local v9 = {
        kind = "info",
        text = concat(...)
    }
    console.console.output(v9)
end

if v1 then
    local register_command = console.register_command
    local v10 = {
        description = "Outputs the license to the console.",
        permissions = {},
        arguments = function() -- arguments | line 71
        end
    }

    function v10.callback() -- line 72 | captures: console
        for v11, v12 in string.split("MIT License\n\nCopyright (c) 2025 alicesays_hallo\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE.", "\n") do
            local v13 = {
                kind = "normal",
                text = v12
            }
            console.console.output(v13)
        end
    end

    register_command("license", v10)
end
return function() -- line 80 | captures: RunService, arguments, console, state, v1, conch_print, conch_error, conch_warn, conch_info
    local function internal() -- line 81 | captures: RunService, state, conch_print
        local v14
        if RunService:IsClient() then
            v14 = "CLIENT"
        elseif RunService:IsServer() then
            v14 = "SERVER"
        else
            v14 = "?"
        end
        conch_print((("CONCH INTERNAL INFORMATION - %*"):format(v14)))
        conch_print("")
        conch_print("REGISTERED ROLES:")
        for v15, v16 in state.roles do
            conch_print((("[%*]: %*"):format(v15, (table.concat(v16, ", ")))))
        end
        conch_print("")
        conch_print("REGISTERED COMMANDS")
    end

    local function set(v17, v18, v19) -- line 97
        v17[v18] = v19
    end

    if not v1 then
        return
    end
    console.register_command("print", {
        description = "Converts the given arguments into a string and sends it to the output",
        permissions = {},
        arguments = function() -- arguments | line 104 | captures: arguments
            return arguments.variadic(arguments.any("any", "Arguments to output"))
        end,
        callback = conch_print
    })
    console.register_command("sleep", {
        description = "Waits for a given amount of time before continuing execution",
        arguments = function() -- arguments | line 112 | captures: arguments
            return arguments.number("time", "The amount of time to sleep for")
        end,
        callback = task.wait
    })
    console.register_quick("error", conch_error)
    console.register_quick("warn", conch_warn)
    console.register_quick("info", conch_info)
    console.register_command("set", {
        description = "Attempts to set the given key and value onto the given object",
        permissions = {},
        arguments = function() -- arguments | line 124 | captures: arguments
            return arguments.any("object", "the object to set"), arguments.any("key", "key of the object"), arguments.any("value", "the value to set it to")
        end,
        callback = set
    })
end
