-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Heartbeat = game:GetService("RunService").Heartbeat

local function getPromiseReference() -- line 26
    return false
end

local v1 = newproxy(true)

getmetatable(v1).__tostring = function() -- line 31
    return "IndicesReference"
end

local v2 = newproxy(true)

getmetatable(v2).__tostring = function() -- line 36
    return "LinkToInstanceIndex"
end

local v3 = {
    IGNORE_MEMORY_DEBUG = true,
    ClassName = "Janitor"
}
local v4 = { CurrentlyCleaning = true }

v4[v1] = nil
v3.__index = v4

local v5 = {
    ["function"] = true,
    Promise = "cancel",
    RBXScriptConnection = "Disconnect"
}

function v3.new() -- line 58 | captures: v1, v3
    local v6 = { CurrentlyCleaning = false }
    v6[v1] = nil
    return (setmetatable(v6, v3))
end

function v3.Is(v7) -- line 65 | captures: v3
    if type(v7) == "table" then
        return getmetatable(v7) == v3
    end
    return false
end

v3.is = v3.Is

local function Add(v8, v9, v10, v11) -- line 71 | captures: v1, v5
    if v11 then
        v8:Remove(v11)
        local v12 = v8[v1]
        if not v12 then
            v12 = {}
            v8[v1] = v12
        end
        v12[v11] = v9
    end
    local v13 = typeof(v9)
    if v13 == "table" and string.match(tostring(v9), "Promise") then
        v13 = "Promise"
    end
    local v14 = v10 or v5[v13] or "Destroy"
    if type(v9) ~= "function" and not v9[v14] then
        warn(string.format("Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s", tostring(v9), tostring(v14), debug.traceback(nil, 2)))
    end
    v8[v9] = {
        v14,
        (debug.traceback(""))
    }
    return v9
end

v3.__index.Add = Add
v3.__index.Give = v3.__index.Add

local function AddPromise(v15, v16) -- line 103
    return v16
end

v3.__index.AddPromise = AddPromise
v3.__index.GivePromise = v3.__index.AddPromise

local function AddObject(v17, v18) -- line 133
    local v19 = newproxy(false)
    return v17:Add(v18, false, v19), v19
end

v3.__index.AddObject = AddObject
v3.__index.GiveObject = v3.__index.AddObject

local function Remove(v20, v21) -- line 151 | captures: v1
    local v22 = v20[v1]
    local v23, v24, v25
    if v22 then
        v23 = v22[v21]
        if v23 then
            local v26 = v20[v23]
            v24 = v26 and v26[1]
            v25 = false
        else
            v25 = true
        end
    else
        v25 = true
    end
    if not v25 then
        if v24 then
            if v24 == true then
                v23()
            else
                local v27 = v23[v24]
                if v27 then
                    v27(v23)
                end
            end
            v20[v23] = nil
        end
        v22[v21] = nil
    end
    return v20
end

v3.__index.Remove = Remove

local function Get(v28, v29) -- line 180 | captures: v1
    local v30 = v28[v1]
    if v30 then
        return v30[v29]
    end
    return nil
end

v3.__index.Get = Get

local function Cleanup(v31) -- line 188 | captures: v1
    if v31.CurrentlyCleaning then
        return
    end
    v31.CurrentlyCleaning = nil
    for v32, v33 in next, v31 do
        if v32 ~= v1 then
            local v34 = type(v32)
            if v34 ~= "string" and v34 ~= "number" then
                local v35 = v33[1]
                local v36 = v33[2]

                local function warnUser(v37) -- line 205 | captures: v36
                    local v38 = debug.traceback("", 3)
                    warn("-------- Janitor Error --------" .. "\n" .. tostring(v37) .. "\n" .. v38 .. "" .. v36)
                end

                if v35 == true then
                    local v39, v40 = pcall(v32)
                    if not v39 then
                        local v41 = debug.traceback("", 3)
                        warn("-------- Janitor Error --------" .. "\n" .. tostring(v40) .. "\n" .. v41 .. "" .. v36)
                    end
                else
                    local v42 = v32[v35]
                    if v42 then
                        local v43, v44 = pcall(v42, v32)
                        local v45 = if typeof(v32) == "Instance" then v42 == "Destroy" else false
                        if not v43 and not v45 then
                            local v46 = debug.traceback("", 3)
                            warn("-------- Janitor Error --------" .. "\n" .. tostring(v44) .. "\n" .. v46 .. "" .. v36)
                        end
                    end
                end
            end
            v31[v32] = nil
        end
    end
    local v47 = v31[v1]
    if v47 then
        for v48 in next, v47 do
            v47[v48] = nil
        end
        v31[v1] = {}
    end
    v31.CurrentlyCleaning = false
end

v3.__index.Cleanup = Cleanup
v3.__index.Clean = v3.__index.Cleanup

local function Destroy(v49) -- line 244
    v49:Cleanup()
end

v3.__index.Destroy = Destroy
v3.__call = v3.__index.Cleanup

local v50 = { Connected = true }

v50.__index = v50

local function Disconnect(v51) -- line 254
    if v51.Connected then
        v51.Connected = false
        v51.Connection:Disconnect()
    end
end

v50.Disconnect = Disconnect

local function __tostring(v52) -- line 261
    local Connected = v52.Connected
    return "Disconnect<" .. tostring(Connected) .. ">"
end

v50.__tostring = __tostring

local function LinkToInstance(v53, v54, v55) -- line 265 | captures: Heartbeat, v2, v50
    local v56
    local v57 = v55 and newproxy(false) or v2
    local v58 = v54.Parent == nil
    local v59 = {}
    local v60 = setmetatable(v59, v50)

    local function ChangedFunction(v61, v62) -- line 271 | captures: v56, v58, v53, v60, Heartbeat
        if not v60.Connected then
            return
        end
        v58 = v62 == nil
        if v58 then
            coroutine.wrap(function() -- line 277 | captures: v56, v58, v53, v60, Heartbeat
                Heartbeat:Wait()
                if v60.Connected then
                    if v56.Connected then
                        while v58 do
                            if v56.Connected and v60.Connected then
                                Heartbeat:Wait()
                                continue
                            end
                            break
                        end
                        if v60.Connected and v58 then
                            v53:Cleanup()
                        end
                    else
                        v53:Cleanup()
                    end
                end
            end)()
        end
    end

    v56 = v54.AncestryChanged:Connect(ChangedFunction)
    v60.Connection = v56
    local v63
    if v58 then
        local Parent = v54.Parent
        if v60.Connected then
            v58 = Parent == nil
            v63 = false
        else
            v63 = true
        end
    else
        v63 = true
    end
    if not v63 and v58 then
        coroutine.wrap(function() -- line 277 | captures: v56, v58, v53, v60, Heartbeat
            Heartbeat:Wait()
            if v60.Connected then
                if v56.Connected then
                    while v58 do
                        if v56.Connected and v60.Connected then
                            Heartbeat:Wait()
                            continue
                        end
                        break
                    end
                    if v60.Connected and v58 then
                        v53:Cleanup()
                    end
                else
                    v53:Cleanup()
                end
            end
        end)()
    end
    return v53:Add(v60, "Disconnect", v57)
end

v3.__index.LinkToInstance = LinkToInstance

local function LinkToInstances(v64, ...) -- line 308 | captures: v3
    local v65 = v3.new()
    for v66, v67 in ipairs({ ... }) do
        v65:Add(v64:LinkToInstance(v67, true), "Disconnect")
    end
    return v65
end

v3.__index.LinkToInstances = LinkToInstances
for v68, v69 in next, v3.__index do
    local v70 = string.lower(v68)
    local v71 = string.sub(v70, 1, 1) .. string.sub(v68, 2)
    v3.__index[v71] = v69
end
return v3
