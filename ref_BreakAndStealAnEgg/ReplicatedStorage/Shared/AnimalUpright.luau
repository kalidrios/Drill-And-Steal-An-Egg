-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {
    YawOnly = function(v2) -- YawOnly | line 24
        local LookVector = v2.LookVector
        local X = LookVector.X
        local Z = LookVector.Z
        local v3 = Vector3.new(X, 0, Z)
        local v4
        if v3.Magnitude < 0.0001 then
            local UpVector = v2.UpVector
            local v5 = if LookVector.Y > 0 then -1 else 1
            local X = UpVector.X
            local Z = UpVector.Z
            v4 = Vector3.new(X, 0, Z) * v5
        else
            v4 = v3
        end
        if v4.Magnitude < 0.0001 then
            return CFrame.identity
        end
        return CFrame.lookAt(Vector3.new(0, 0, 0), v4.Unit)
    end
}

function v1.AlignPivotToMesh(v6, v7) -- line 48 | captures: v1
    local v8 = v6:GetPivot()
    if (v8.Rotation:Inverse() * v7.CFrame.Rotation).UpVector.Y > 0.999 then
        return false
    end
    local v9 = CFrame.new(v8.Position) * v1.YawOnly(v7.CFrame.Rotation)
    local PrimaryPart = v6.PrimaryPart
    if PrimaryPart then
        PrimaryPart.PivotOffset = PrimaryPart.CFrame:Inverse() * v9
    else
        v6.WorldPivot = v9
    end
    return true
end

return v1
