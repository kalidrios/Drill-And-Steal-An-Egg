-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SettingsConfig = require(ReplicatedStorage.Shared.SettingsConfig)
local SettingsState = require(script.Parent.Parent.Modules.SettingsState)
local v1 = {}

function v1.Start() -- line 33 | captures: ReplicatedStorage, SettingsConfig, SettingsState
    local v2 = ReplicatedStorage:WaitForChild(SettingsConfig.RemoteName)
    local v3 = false
    local v4 = false
    local v5 = {}
    local v6 = false
    v2.OnClientEvent:Connect(function(v7) -- line 41 | captures: v3, v4, SettingsConfig, SettingsState
        if type(v7) ~= "table" then
            return
        end
        v4 = true
        for v8, v9 in SettingsConfig.Defaults do
            local v10 = v7[v8]
            if v10 ~= nil and typeof(v10) == typeof(v9) then
                if type(v10) == "number" then
                    v10 = math.clamp(v10, 0, 1)
                end
                SettingsState.Set(v8, v10)
            end
        end
        v4 = false
        v3 = true
    end)
    local v11 = (-1/0)
    local v12 = false

    local function flush() -- line 67 | captures: v5, v6, v11, v2
        if not v6 then
            return
        end
        local v13 = v5
        v5 = {}
        v6 = false
        v11 = os.clock()
        v2:FireServer(v13)
    end

    local function requestFlush() -- line 78 | captures: v5, v6, v11, v12, v2, SettingsConfig
        if not v12 then
            local v14 = SettingsConfig.SaveFlushInterval - (os.clock() - v11)
            if v14 <= 0 then
                if v6 then
                    local v15 = v5
                    v5 = {}
                    v6 = false
                    v11 = os.clock()
                    v2:FireServer(v15)
                end
            else
                v12 = true
                task.delay(v14, function() -- line 88 | captures: v5, v6, v11, v12, v2
                    v12 = false
                    if not v6 then
                        return
                    end
                    local v16 = v5
                    v5 = {}
                    v6 = false
                    v11 = os.clock()
                    v2:FireServer(v16)
                end)
            end
        end
    end

    for v17 in SettingsConfig.Defaults do
        local Observe = SettingsState.Observe
        local v18 = v17
        Observe(v17, function(v19) -- line 95 | captures: v3, v4, v5, v6, requestFlush, v18
            if not v3 or v4 then
                return
            end
            v5[v18] = v19
            v6 = true
            requestFlush()
        end)
    end
    v2:FireServer(nil)
end

return v1
