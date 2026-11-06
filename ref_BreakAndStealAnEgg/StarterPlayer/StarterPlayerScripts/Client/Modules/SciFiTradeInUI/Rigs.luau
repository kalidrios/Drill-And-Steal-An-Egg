-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return {
    new = function(v1) -- new | line 28
        if v1 then
            return {
                s = 1,
                r = 0,
                a = 0,
                sw = nil,
                sh = nil,
                vis = true,
                wx = (1/0),
                wy = (1/0),
                wsx = -1,
                wsy = -1,
                wr = (1/0),
                wa = -1,
                touched = false,
                inst = v1,
                aPos = v1.Position,
                aSize = v1.Size,
                aRot = v1.Rotation,
                aZ = v1.ZIndex,
                aIT = v1.ImageTransparency,
                aVis = v1.Visible,
                aAnchor = v1.AnchorPoint,
                aScaleType = v1.ScaleType,
                x = v1.Position.X.Scale,
                y = v1.Position.Y.Scale,
                z = v1.ZIndex,
                wz = v1.ZIndex,
                wvis = v1.Visible
            }
        end
        return nil
    end,
    write = function(v2, v3) -- write | line 68
        local inst = v2.inst
        if not v2.touched then
            v2.touched = true
        end
        if v2.vis ~= v2.wvis then
            v2.wvis = v2.vis
            inst.Visible = v2.vis
        end
        if not v2.vis then
            return
        end
        local v4 = if v3 < 0.3 then 0.3 else v3
        local v5 = 1 / v4
        local v6 = 0.5 + (v2.x - 0.5) * v5
        local v7 = 0.5 + (v2.y - 0.5) * v5
        local v8 = v6 - v2.wx
        local v9 = v7 - v2.wy
        if v8 > 0.0004 or v8 < -0.0004 or v9 > 0.0004 or v9 < -0.0004 then
            v2.wx = v6
            v2.wy = v7
            inst.Position = UDim2.fromScale(v6, v7)
        end
        local v10, v11
        if v2.sw then
            v10, v11 = v2.sw * v5, v2.sh * v5
        else
            local v12 = v2.s * v5
            v10, v11 = v2.aSize.X.Scale * v12, v2.aSize.Y.Scale * v12
        end
        local v13 = v10 - v2.wsx
        local v14 = v11 - v2.wsy
        if v13 > 0.0004 or v13 < -0.0004 or v14 > 0.0004 or v14 < -0.0004 then
            v2.wsx = v10
            v2.wsy = v11
            inst.Size = UDim2.fromScale(v10, v11)
        end
        local v15 = v2.r - v2.wr
        if v15 > 0.05 or v15 < -0.05 then
            v2.wr = v2.r
            inst.Rotation = v2.r
        end
        if v2.z ~= v2.wz then
            v2.wz = v2.z
            inst.ZIndex = v2.z
        end
        local a = v2.a
        if a < 0 then
            a = 0
        elseif a > 1 then
            a = 1
        end
        local v16 = a - v2.wa
        if v16 > 0.004 or v16 < -0.004 or not (v16 == 0 or a ~= 0 and a ~= 1) then
            v2.wa = a
            inst.ImageTransparency = v2.aIT + (1 - v2.aIT) * a
        end
    end,
    toRest = function(v17) -- toRest | line 126
        if not (v17 and v17.touched) then
            return
        end
        v17.touched = false
        local inst = v17.inst
        inst.Position = v17.aPos
        inst.Size = v17.aSize
        inst.Rotation = v17.aRot
        inst.ZIndex = v17.aZ
        inst.ImageTransparency = v17.aIT
        inst.Visible = v17.aVis
        inst.AnchorPoint = v17.aAnchor
        inst.ScaleType = v17.aScaleType
        v17.wx = (1/0)
        v17.wy = (1/0)
        v17.wsx = -1
        v17.wsy = -1
        v17.wr = (1/0)
        v17.wa = -1
        local aZ = v17.aZ
        local aVis = v17.aVis
        v17.wz = aZ
        v17.wvis = aVis
        v17.vis = true
    end,
    smooth = function(v18) -- smooth | line 146
        if v18 <= 0 then
            return 0
        end
        if v18 >= 1 then
            return 1
        end
        return v18 * v18 * (3 - v18 * 2)
    end,
    catmull = function(v19, v20, v21, v22, v23) -- catmull | line 155
        local v24 = v23 * v23
        return (v20 * 2 + (-v19 + v21) * v23 + (v19 * 2 - v20 * 5 + v21 * 4 - v22) * v24 + (-v19 + v20 * 3 - v21 * 3 + v22) * v24 * v23) * 0.5
    end,
    hermite = function(v25, v26, v27, v28, v29) -- hermite | line 161
        local v30 = v29 * v29
        local v31 = v29 * v29 * v29
        return (v31 * 2 - v30 * 3 + 1) * v25 + (v31 - v30 * 2 + v29) * v26 + (v31 * -2 + v30 * 3) * v27 + (v31 - v30) * v28
    end
}
