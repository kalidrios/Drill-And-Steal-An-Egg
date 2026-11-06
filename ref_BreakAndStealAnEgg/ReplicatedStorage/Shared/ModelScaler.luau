-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VFXScaler = require(ReplicatedStorage.Shared.VFXScaler)
local v1 = {}

local function scaledOffset(v2, v3) -- line 55
    return v2.Rotation + v2.Position * v3
end

function v1.Capture(v4, v5) -- line 59 | captures: VFXScaler
    local v6 = v5 or v4:GetPivot()
    local v7 = {
        reference = v6,
        parts = {},
        attachments = {},
        joints = {},
        meshes = {},
        humanoids = {},
        vfx = VFXScaler.NewRig()
    }

    local function add(v8) -- line 71 | captures: v7, v6, VFXScaler
        if v8:IsA("BasePart") then
            local parts = v7.parts
            local v9 = {
                part = v8,
                size = v8.Size,
                offset = v6:ToObjectSpace(v8.CFrame)
            }
            table.insert(parts, v9)
        elseif v8:IsA("Attachment") then
            local attachments = v7.attachments
            local v10 = {
                attachment = v8,
                position = v8.Position
            }
            table.insert(attachments, v10)
        elseif v8:IsA("JointInstance") then
            local joints = v7.joints
            local v11 = {
                joint = v8,
                c0 = v8.C0,
                c1 = v8.C1
            }
            table.insert(joints, v11)
        elseif v8:IsA("DataModelMesh") then
            local meshes = v7.meshes
            local v12 = {
                mesh = v8,
                scale = v8.Scale,
                offset = v8.Offset
            }
            table.insert(meshes, v12)
        elseif v8:IsA("Humanoid") then
            local humanoids = v7.humanoids
            local v13 = {
                humanoid = v8,
                hipHeight = v8.HipHeight
            }
            table.insert(humanoids, v13)
        else
            VFXScaler.CaptureInstance(v7.vfx, v8)
        end
    end

    add(v4)
    for v14, v15 in v4:GetDescendants() do
        add(v15)
    end
    return v7
end

function v1.Apply(v16, v17, v18) -- line 101 | captures: VFXScaler
    local v19 = v18 or v16.reference
    if v16.lastScale == v17 then
        for v20, v21 in v16.parts do
            local part = v21.part
            if part.Parent then
                part.CFrame = v19 * v21.scaledOffset
            end
        end
    else
        v16.lastScale = v17
        for v22, v23 in v16.parts do
            local part = v23.part
            local offset = v23.offset
            local v24 = offset.Rotation + offset.Position * v17
            v23.scaledOffset = v24
            if part.Parent then
                part.Size = v23.size * v17
                part.CFrame = v19 * v24
            end
        end
        for v25, v26 in v16.attachments do
            if v26.attachment.Parent then
                v26.attachment.Position = v26.position * v17
            end
        end
        for v27, v28 in v16.joints do
            local joint = v28.joint
            if joint.Parent then
                local c0 = v28.c0
                joint.C0 = c0.Rotation + c0.Position * v17
                local c1 = v28.c1
                joint.C1 = c1.Rotation + c1.Position * v17
            end
        end
        for v29, v30 in v16.meshes do
            if v30.mesh.Parent then
                v30.mesh.Scale = v30.scale * v17
                v30.mesh.Offset = v30.offset * v17
            end
        end
        for v31, v32 in v16.humanoids do
            if v32.humanoid.Parent then
                v32.humanoid.HipHeight = v32.hipHeight * v17
            end
        end
        VFXScaler.Apply(v16.vfx, v17)
    end
end

function v1.ScaleBy(v33, v34) -- line 159 | captures: v1
    v1.Apply(v1.Capture(v33), v34)
end

return v1
