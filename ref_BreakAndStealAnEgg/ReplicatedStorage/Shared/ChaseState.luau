-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    ChasedAttribute = "BeingChased",
    CarryingAttribute = "Carrying"
}

local function observe(v2, v3, v4, v5) -- line 26
    local function v6(v7, ...)
        table.insert(v7, ...)
    end

    local v8

    local function update() -- line 34 | captures: v8, v2, v4, v5
        local v9 = v4(v2)
        if v9 ~= v8 then
            v8 = v9
            v5(v9)
        end
    end

    local v10 = {}
    for v11, v12 in v3 do
        v6(v10, v2:GetAttributeChangedSignal(v12):Connect(update))
    end
    local v13 = v4(v2)
    if v13 ~= v8 then
        v8 = v13
        v5(v13)
    end
    return function() -- line 50 | captures: v10
        for v14, v15 in v10 do
            v15:Disconnect()
        end
        table.clear(v10)
    end
end

function v1.IsCarrying(v16) -- line 58 | captures: v1
    if v16 == nil then
        return false
    end
    return v16:GetAttribute(v1.CarryingAttribute) ~= nil
end

function v1.IsActive(v17) -- line 62 | captures: v1
    if v17 then
        if v17:GetAttribute(v1.ChasedAttribute) == nil then
            return false
        end
        return (v1.IsCarrying(v17))
    end
    return false
end

function v1.Observe(v18, v19) -- line 71 | captures: v1, observe
    return (observe(v18, {
        v1.ChasedAttribute,
        v1.CarryingAttribute
    }, v1.IsActive, v19))
end

function v1.ObserveCarrying(v20, v21) -- line 77 | captures: v1, observe
    return (observe(v20, { v1.CarryingAttribute }, v1.IsCarrying, v21))
end

return v1
