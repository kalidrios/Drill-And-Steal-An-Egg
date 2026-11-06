-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local v1 = {}

local function ready(v2) -- line 28
    if v2 == nil then
        return false
    end
    return v2 ~= false
end

function v1.Frame() -- line 33 | captures: RunService
    RunService.Heartbeat:Wait()
end

function v1.Until(v3, v4) -- line 40 | captures: RunService
    local v5 = v3()
    if v5 ~= nil and v5 ~= false then
        return v5
    end
    local v6 = os.clock() + (v4 or 10)
    local v7
    while true do
        if os.clock() < v6 then
            RunService.Heartbeat:Wait()
            v7 = v3()
            if v7 ~= nil and v7 ~= false then
                break
            end
            continue
        end
        return nil
    end
    return v7
end

function v1.Stable(v8, v9, v10) -- line 66 | captures: RunService
    local v11 = v9 or 3
    local v12 = os.clock() + (v10 or 10)
    local v13 = v8()
    local v14 = 0
    local v15
    while true do
        if os.clock() < v12 then
            RunService.Heartbeat:Wait()
            v15 = v8()
            local v16, v17, v18
            if v15 == v13 then
                local v19 = v14 + 1
                if v11 <= v19 then
                    v18 = true
                else
                    v16 = v13
                    v17 = v19
                    v18 = false
                end
            else
                v16 = v15
                v17 = 0
                v18 = false
            end
            if v18 then
                break
            end
            v13 = v16
            v14 = v17
            continue
        end
        return v13
    end
    return v15
end

return v1
