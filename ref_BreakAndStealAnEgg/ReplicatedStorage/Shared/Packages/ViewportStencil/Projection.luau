-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2 = -Vector3.FromNormalId(Enum.NormalId.Top)
local fromAxisAngle = CFrame.fromAxisAngle
local Y = v2.Y
local v3 = fromAxisAngle(Vector3.new(Y, 0, 0), 1.5707963267948966) * v2
local Unit = v2:Cross(v3).Unit
local v4 = CFrame.fromMatrix(Vector3.new(0, 0, 0), v3, Unit, v2)

function v1.getSurface(v5, v6) -- line 20 | captures: v2, v3, Unit, v4
    return v5 * CFrame.new(-v2 * v6 / 2) * v4, (Vector2.new((v6 * v3).Magnitude, (v6 * Unit).Magnitude))
end

function v1.getViewRotation(v7) -- line 26
    return v7.Rotation * CFrame.Angles(0, 3.141592653589793, 0)
end

function v1.solve(v8, v9, v10) -- line 36
    local v11 = v9:PointToObjectSpace(v8)
    local v12 = v11.X / v10.X
    local v13 = v11.Y / v10.Y
    local v14 = -v11.Z
    local v15 = math.abs(v12)
    local v16 = math.abs(v13)
    local v17 = math.max(v15, v16) * 2 + 1
    local v18 = v10.Y / 2
    local v19 = math.atan2(v18, v14) * 2
    local v20, v21
    if v19 > 2.0943951023931953 then
        v20, v21 = 120, v14 * 1.7320508075688767 / v18 / v17
    else
        local v22 = math.deg(v19)
        v20, v21 = math.max(v22, 1), 1 / v17
    end
    return v12, v13, v17, v20, v21, v14
end

function v1.getCameraCFrame(v23, v24, v25) -- line 67
    return (v24 + v23) * CFrame.new(0, 0, 0, v25, 0, 0, 0, v25, 0, 0, 0, 1)
end

return v1
