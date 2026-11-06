-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local v1 = {}
local LocalPlayer = Players.LocalPlayer

local function confirmWindow() -- line 36 | captures: LocalPlayer
    local v2 = 1 + (LocalPlayer and LocalPlayer:GetNetworkPing() or 0) * 3
    return (math.min(v2, 8))
end

function v1.ConfirmWindow() -- line 43 | captures: LocalPlayer
    local v3 = 1 + (LocalPlayer and LocalPlayer:GetNetworkPing() or 0) * 3
    return (math.min(v3, 8))
end

local v4 = {}
local v5 = {}
local v6 = {}
local v7 = {}
local v8 = { __mode = "k" }
local v9 = setmetatable(v7, v8)
local v10 = {}
local v11 = { __mode = "k" }
local v12 = setmetatable(v10, v11)
local v13 = {}
local v14 = { __mode = "k" }
local v15 = setmetatable(v13, v14)
local v16 = 0

local function serverHealth(v17) -- line 79 | captures: v12
    local v18 = v17:GetAttribute("Health") or 0
    local v19 = v12[v17]
    if v19 == nil then
        return v18
    end
    if v18 <= v19 then
        v12[v17] = nil
        return v18
    end
    return v19
end

local function prune(v20) -- line 94 | captures: LocalPlayer, v9
    local v21 = v9[v20]
    if not v21 then
        return
    end
    local v22 = os.clock()
    local v23 = 1 + (LocalPlayer and LocalPlayer:GetNetworkPing() or 0) * 3
    local v24 = math.min(v23, 8)
    local v25 = #v21
    for v26 = v25, 1, -1 do
        if v24 < v22 - v21[v26].At then
            table.remove(v21, v26)
        end
    end
    if #v21 == 0 then
        v9[v20] = nil
    end
end

local function displayHealth(v27) -- line 111 | captures: v9, v12
    local v28 = v27:GetAttribute("Health") or 0
    local v29 = v12[v27]
    if v29 ~= nil then
        if v28 <= v29 then
            v12[v27] = nil
        else
            v28 = v29
        end
    end
    local v30 = v9[v27]
    if v30 then
        local v31 = v28
        for v32, v33 in v30 do
            v31 -= v33.Damage
            v28 = v31
        end
    end
    return (math.max(0, v28))
end

local function settle(v34, v35) -- line 124 | captures: v9
    local v36 = v9[v34]
    local v37, v38
    if v36 then
        if #v36 == 0 then
            v38 = true
        else
            if v35 == nil then
                v37 = 1
            end
            v38 = false
        end
    else
        v38 = true
    end
    if v38 then
        return nil
    end
    if v35 ~= nil then
        for v39, v40 in v36 do
            if v40.Id == v35 then
                v37 = v39
                break
            end
        end
    end
    if v37 == nil then
        return nil
    end
    local v41 = table.remove(v36, v37)
    if #v36 == 0 then
        v9[v34] = nil
    end
    return v41
end

function v1.Announce(v42, v43) -- line 150 | captures: v16, v4, v9, v12, prune
    prune(v42)
    v16 += 1
    local v44 = v9[v42] or {}
    local v45 = {
        Id = v16,
        At = os.clock(),
        Damage = v43
    }
    table.insert(v44, v45)
    v9[v42] = v44
    local v46 = v42:GetAttribute("Health") or 0
    local v47 = v12[v42]
    if v47 ~= nil then
        if v46 <= v47 then
            v12[v42] = nil
        else
            v46 = v47
        end
    end
    local v48 = v9[v42]
    if v48 then
        local v49 = v46
        for v50, v51 in v48 do
            v49 -= v51.Damage
            v46 = v49
        end
    end
    local v52 = math.max(0, v46)
    for v53, v54 in v4 do
        task.spawn(v54, v42, v52, v43)
    end
    return v16
end

function v1.OnHit(v55) -- line 166 | captures: v4
    table.insert(v4, v55)
end

function v1.Confirm(v56, v57, v58) -- line 171 | captures: v6, v12, v15, settle
    local v59 = settle(v56, v57)
    if v58 < (v56:GetAttribute("Health") or 0) then
        local v60 = v12[v56]
        local v61
        if v60 then
            v61 = math.min(v60, v58)
        else
            v61 = v58
        end
        v12[v56] = v61
    end
    if not (v59 and v59.Claimed) then
        local v62 = v15[v56] or {}
        local v63 = {
            Health = v58,
            At = os.clock()
        }
        table.insert(v62, v63)
        v15[v56] = v62
    end
    for v64, v65 in v6 do
        task.spawn(v65, v56)
    end
end

function v1.OnConfirm(v66) -- line 198 | captures: v6
    table.insert(v6, v66)
end

function v1.Reject(v67, v68) -- line 204 | captures: v5, settle
    settle(v67, v68)
    for v69, v70 in v5 do
        task.spawn(v70, v67)
    end
end

function v1.OnReject(v71) -- line 212 | captures: v5
    table.insert(v5, v71)
end

function v1.ConsumeConfirm(v72) -- line 219 | captures: LocalPlayer, v9, v15, prune
    local v73 = v15[v72]
    if v73 then
        local v74 = v72:GetAttribute("Health") or 0
        local v75 = os.clock()
        local v76 = 1 + (LocalPlayer and LocalPlayer:GetNetworkPing() or 0) * 3
        local v77 = math.min(v76, 8)
        local v78 = #v73
        local v79 = false
        for v80 = v78, 1, -1 do
            local v81 = v73[v80]
            if v77 < v75 - v81.At then
                table.remove(v73, v80)
            elseif v74 <= v81.Health then
                table.remove(v73, v80)
                v79 = true
            end
        end
        if #v73 == 0 then
            v15[v72] = nil
        end
        if v79 then
            return true
        end
    end
    prune(v72)
    local v82 = v9[v72]
    if v82 then
        for v83, v84 in v82 do
            if not v84.Claimed then
                v84.Claimed = true
                return true
            end
        end
    end
    return false
end

function v1.GetDisplayHealth(v85) -- line 262 | captures: v9, v12, prune
    prune(v85)
    local v86 = v85:GetAttribute("Health") or 0
    local v87 = v12[v85]
    if v87 ~= nil then
        if v86 <= v87 then
            v12[v85] = nil
        else
            v86 = v87
        end
    end
    local v88 = v9[v85]
    if v88 then
        local v89 = v86
        for v90, v91 in v88 do
            v89 -= v91.Damage
            v86 = v89
        end
    end
    return (math.max(0, v86))
end

function v1.Forget(v92) -- line 268 | captures: v9, v12, v15
    v9[v92] = nil
    v12[v92] = nil
    v15[v92] = nil
end

return v1
