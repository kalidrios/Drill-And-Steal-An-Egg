-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

require(script.Parent.types)

local function create_signal() -- line 4
    local v1 = {}
    local v2 = {}

    function v2.connect(v3, v4) -- line 8 | captures: v1
        local v5 = false
        local v6 = { callback = v4 }

        function v6.disconnect() -- line 12 | captures: v5, v6, v1
            if v5 then
                return
            end
            v5 = true
            v6.disconnected = true
            local v7 = table.find(v1, v6)
            if v7 then
                table.remove(v1, v7)
            end
        end

        table.insert(v1, v6)
        return v6
    end

    function v2.fire(v8, ...) -- line 29 | captures: v1
        for v9, v10 in v1 do
            v10.callback(...)
        end
    end

    return v2
end

return create_signal
