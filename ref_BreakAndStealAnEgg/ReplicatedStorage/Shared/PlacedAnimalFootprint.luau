-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlacedAnimalScatter = require(ReplicatedStorage.Shared.PlacedAnimalScatter)
local v1 = {
    Attribute = "PlacedFootSpan",
    GroundBand = 0.2,
    StridePad = 0.08,
    MinRatio = 0.2
}
local v2 = {}
local v3 = { __mode = "k" }
local v4 = setmetatable(v2, v3)

local function isLeafBone(v5) -- line 52
    for v6, v7 in v5:GetChildren() do
        if v7:IsA("Bone") then
            return false
        end
    end
    return true
end

function v1.Ratio(v8) -- line 63 | captures: v1, v4
    local v9 = v4[v8]
    if v9 then
        return v9
    end
    local v10, v11, v12 = pcall(v8.GetBoundingBox, v8)
    local v13
    if v10 and v12.Y > 0 then
        local X = v12.X
        local Z = v12.Z
        local v14 = math.max(X, Z) / 2
        local Position = v11.Position
        local v15 = Position.Y - v12.Y / 2 + v12.Y * v1.GroundBand
        local v16 = 0
        local v17 = 0
        for v18, v19 in v8:GetDescendants() do
            if v19:IsA("Bone") then
                local v20 = true
                for v21, v22 in v19:GetChildren() do
                    if v22:IsA("Bone") then
                        v20 = false
                        break
                    end
                    v20 = true
                end
                if v20 then
                    local WorldPosition = v19.WorldPosition
                    if WorldPosition.Y <= v15 then
                        v17 += 1
                        local v23 = WorldPosition.X - Position.X
                        local v24 = WorldPosition.Z - Position.Z
                        local v25 = v23 * v23 + v24 * v24
                        local v26 = math.sqrt(v25)
                        v16 = math.max(v16, v26)
                    end
                end
            end
        end
        if v17 > 0 and v14 > 0 then
            local v27 = v16 / v14 + v1.StridePad
            local MinRatio = v1.MinRatio
            v13 = math.clamp(v27, MinRatio, 1)
        else
            v13 = 1
        end
    else
        v13 = 1
    end
    v4[v8] = v13
    return v13
end

function v1.FootSpanOf(v28) -- line 97 | captures: PlacedAnimalScatter, v1
    local v29 = v28:GetAttribute(v1.Attribute)
    if not (typeof(v29) == "number" and v29 >= 0) then
        return PlacedAnimalScatter.HalfSpanOf(v28)
    end
    return v29
end

return v1
