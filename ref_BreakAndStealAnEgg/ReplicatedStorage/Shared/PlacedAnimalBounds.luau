-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    Margin = 0.5,
    MinPenFrac = 0.35,
    HalfSpan = function(v2) -- HalfSpan | line 56
        local v3, v4 = pcall(function() -- line 57 | captures: v2
            local v5, v6 = v2:GetBoundingBox()
            return v6
        end)
        if not (v3 and typeof(v4) == "Vector3") then
            return 0
        end
        local X = v4.X
        local Z = v4.Z
        return math.max(X, Z) / 2
    end
}

function v1.HalfExtents(v7, v8) -- line 72 | captures: v1
    local v9 = v1.Margin + (v8 or 0)
    local v10 = v7.Size.X / 2
    local v11 = v7.Size.Z / 2
    local MinPenFrac = v1.MinPenFrac
    local v12 = v10 - v9
    local v13 = v10 * MinPenFrac
    local v14 = math.max(v12, v13, 1)
    local v15 = v11 - v9
    local v16 = v11 * MinPenFrac
    return v14, (math.max(v15, v16, 1))
end

function v1.Clamp(v17, v18, v19) -- line 81 | captures: v1
    local v20, v21 = v1.HalfExtents(v17, v18)
    local v22 = v17.CFrame:PointToObjectSpace(v19)
    local CFrame = v17.CFrame
    local X = v22.X
    local v23 = -v20
    local v24 = math.clamp(X, v23, v20)
    local Z = v22.Z
    local v25 = -v21
    local v26 = math.clamp(Z, v25, v21)
    local v27 = CFrame:PointToWorldSpace((Vector3.new(v24, 0, v26)))
    local X_2 = v27.X
    local Y = v19.Y
    local Z_2 = v27.Z
    return (Vector3.new(X_2, Y, Z_2))
end

function v1.RandomPoint(v28, v29, v30) -- line 91 | captures: v1
    local function v31(v32, v33, ...)
        return (Vector3.new(v32, v33, ...))
    end

    local v34, v35 = v1.HalfExtents(v28, v29)
    local v36 = v28.CFrame:PointToWorldSpace((v31(v30:NextNumber(-v34, v34), 0, v30:NextNumber(-v35, v35))))
    local X = v36.X
    local Y = v28.Position.Y
    local Z = v36.Z
    return (Vector3.new(X, Y, Z))
end

return v1
