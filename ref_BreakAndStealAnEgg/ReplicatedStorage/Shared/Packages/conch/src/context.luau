-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local state = require(script.Parent.state)
require(script.Parent.types)

return {
    create_command_context = function(v1, v2) -- create_command_context | line 4 | captures: state
        local v3 = not state.command_context[coroutine.running()]
        assert(v3, "there is already a command context for this thread")
        state.command_context[coroutine.running()] = {
            executor = v1,
            invocation_id = v2
        }
        return function() -- line 17 | captures: state
            state.command_context[coroutine.running()] = nil
        end
    end,
    get_command_context = function() -- get_command_context | line 20 | captures: state
        return state.command_context[coroutine.running()]
    end
}
