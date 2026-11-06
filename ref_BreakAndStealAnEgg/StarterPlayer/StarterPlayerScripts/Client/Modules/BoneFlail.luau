-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}

v1.__index = v1

local function restOf(v2, v3) -- line 67
    local v4, Parent = v2.CFrame, v2.Parent
    while Parent do
        if Parent ~= v3 and Parent:IsA("Bone") then
            v4, Parent = Parent.CFrame * v4, Parent.Parent
            continue
        end
        break
    end
    return v4
end

local function firstChildBone(v5) -- line 77
    for v6, v7 in v5:GetChildren() do
        if v7:IsA("Bone") then
            return v7
        end
    end
    return nil
end

local function smooth(v8) -- line 86
    local v9 = math.clamp(v8, 0, 1)
    return v9 * v9 * (3 - v9 * 2)
end

local function keyAngle(v10, v11) -- line 92
    if v11 <= v10[1][1] then
        return v10[1][2]
    end
    local v12 = #v10 - 1
    for v13 = 1, v12 do
        local v14 = v10[v13]
        local v15 = v10[v13 + 1]
        if v11 < v15[1] then
            local v16 = v11 - v14[1]
            local v17 = v15[1] - v14[1]
            local v18 = v16 / math.max(v17, 0.001)
            local v19 = math.clamp(v18, 0, 1)
            local v20 = v19 * v19 * (3 - v19 * 2)
            return v14[2] + (v15[2] - v14[2]) * v20
        end
    end
    return v10[#v10][2]
end

local function angleAt(v21, v22) -- line 106 | captures: keyAngle
    local v23
    if not (v21.Keys and #v21.Keys > 0) then
        v23 = v21.Base or 0
    else
        v23 = keyAngle(v21.Keys, v22)
    end
    local v24 = v21.Amp or 0
    if v24 == 0 then
        return v23
    end
    local v25
    if v21.AmpFrom then
        local v26 = (v22 - v21.AmpFrom) / 0.15
        local v27 = math.clamp(v26, 0, 1)
        v25 = 1 * (v27 * v27 * (3 - v27 * 2))
    else
        v25 = 1
    end
    if v21.AmpTo then
        local v28 = (v22 - (v21.AmpTo - 0.15)) / 0.15
        local v29 = math.clamp(v28, 0, 1)
        v25 *= 1 - v29 * v29 * (3 - v29 * 2)
    end
    local v30 = v24 * v25
    local v31 = 6.283185307179586 * ((v21.Speed or 1) * v22 + (v21.Phase or 0))
    return v23 + v30 * math.sin(v31)
end

function v1.new(v32, v33, v34) -- line 122 | captures: v1, restOf
    local v35 = {}
    local v36 = {}
    for v37, v38 in v34 do
        local v39 = v32:FindFirstChild(v38.Bone, true)
        if v39 and v39:IsA("Bone") then
            local v40 = restOf(v39, v33)
            local v41
            if v38.Axis == "Swing" then
                local v42
                for v43, v44 in v39:GetChildren() do
                    if v44:IsA("Bone") then
                        v42 = v44
                        break
                    end
                    v42 = nil
                end
                local v45
                if v42 then
                    v45 = (v40 * v42.CFrame).Position - v40.Position
                else
                    v45 = Vector3.new(-0, -1, -0)
                end
                local v46
                if v45.Magnitude > 0.001 then
                    v46 = v45.Unit
                else
                    v46 = Vector3.new(-0, -1, -0)
                end
                local v47 = v46:Cross((Vector3.new(0, 0, -1)))
                if v47.Magnitude < 0.001 then
                    v47 = Vector3.new(1, 0, 0)
                end
                v41 = v47.Unit
            elseif v38.Axis == "Flap" then
                v41 = Vector3.new(0, 0, -1) * (v38.Side or 1)
            else
                v41 = Vector3.new(0, 1, 0)
            end
            local v48 = v36[v39]
            if not v48 then
                v48 = {
                    Bone = v39,
                    Moves = {}
                }
                v36[v39] = v48
                table.insert(v35, v48)
            end
            local Moves = v48.Moves
            local v49 = {
                LocalAxis = v40:VectorToObjectSpace(v41),
                Move = v38
            }
            table.insert(Moves, v49)
        end
    end
    local v50 = { Bones = v35 }
    return (setmetatable(v50, v1))
end

function v1.Step(v51, v52, v53) -- line 157 | captures: angleAt
    local v54 = math.clamp(v53, 0, 1)
    if not (v54 <= 0) then
        for v55, v56 in v51.Bones do
            local v57 = CFrame.identity
            for v58, v59 in v56.Moves do
                local fromAxisAngle = CFrame.fromAxisAngle
                local LocalAxis = v59.LocalAxis
                local v60 = angleAt(v59.Move, v52)
                v57 *= fromAxisAngle(LocalAxis, (math.rad(v60)))
            end
            local Bone = v56.Bone
            if not (v54 >= 1) then
                v57 = v56.Bone.Transform:Lerp(v57, v54)
            end
            Bone.Transform = v57
        end
    end
end

local function Reset(v61) -- line 171
    for v62, v63 in v61.Bones do
        v63.Bone.Transform = CFrame.identity
    end
end

v1.Reset = Reset
return v1
