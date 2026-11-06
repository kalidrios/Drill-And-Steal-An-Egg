-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local v1 = {
    Tag = "BreakableEgg",
    ReachBelowAttribute = "ReachBelow"
}
local v2

local function tagSet() -- line 38 | captures: v2, CollectionService, v1
    local v3 = v2
    if v3 then
        return v3
    end
    local v4 = {}
    v2 = v4
    for v5, v6 in CollectionService:GetTagged(v1.Tag) do
        if v6:IsA("BasePart") then
            v4[v6] = true
        end
    end
    CollectionService:GetInstanceAddedSignal(v1.Tag):Connect(function(v7) -- line 52 | captures: v4
        if v7:IsA("BasePart") then
            v4[v7] = true
        end
    end)
    CollectionService:GetInstanceRemovedSignal(v1.Tag):Connect(function(v8) -- line 57 | captures: v4
        v4[v8] = nil
    end)
    return v4
end

local function IsLive(v9) -- line 66
    if v9 == nil or v9.Parent == nil then
        return false
    end
    return not v9:GetAttribute("Broken") and not v9:GetAttribute("Hatching") and not v9:GetAttribute("Despawning")
end

v1.IsLive = IsLive

function v1.SurfaceDistance(v10, v11) -- line 80 | captures: v1
    local Size = v10.Size
    local X = Size.X
    local Z = Size.Z
    local v12 = math.max(X, Z) / 2
    local v13 = v11 - v10.Position
    local X_2 = v13.X
    local Z_2 = v13.Z
    local v14 = Vector3.new(X_2, 0, Z_2).Magnitude - v12
    local v15 = math.max(v14, 0)
    local v16 = Size.Y / 2
    local Y = v13.Y
    local v17 = math.abs(Y) - v16
    local v18 = math.max(v17, 0)
    if v18 > 0 and v13.Y < 0 then
        local v19 = v10:GetAttribute(v1.ReachBelowAttribute)
        if type(v19) == "number" and v19 > 0 then
            local v20 = -v13.Y - v16 - v19
            v18 = math.max(v20, 0)
        end
    end
    local v21 = v15 * v15 + v18 * v18
    return (math.sqrt(v21))
end

function v1.Nearest(v22, v23) -- line 101 | captures: v1, tagSet
    local v24
    local v25 = v23
    for v26 in (tagSet()) do
        if v26.Parent ~= nil then
            local v27 = v1.SurfaceDistance(v26, v22)
            if v27 <= v25 and not (v26:GetAttribute("Broken") or v26:GetAttribute("Hatching") or v26:GetAttribute("Despawning")) then
                v24 = v26
                v25 = v27
            end
        end
    end
    return v24
end

function v1.Pick(v28, v29, v30, v31) -- line 139 | captures: v1, tagSet
    if v30 and tagSet()[v30] and v1.IsLive(v30) and v1.SurfaceDistance(v30, v28) <= (v31 or v29) then
        return v30
    end
    return v1.Nearest(v28, v29)
end

return v1
