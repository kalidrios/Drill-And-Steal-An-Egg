-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ZonesConfig = require(ReplicatedStorage.Shared.ZonesConfig)
local v1 = {}

local function isPointInPart(v2, v3) -- line 22
    local v4 = v2.CFrame:PointToObjectSpace(v3)
    local v5 = v2.Size * 0.5
    local X = v4.X
    if math.abs(X) <= v5.X then
        local Y = v4.Y
        if math.abs(Y) <= v5.Y + 2 then
            local Z = v4.Z
            return math.abs(Z) <= v5.Z
        end
    end
    return false
end

local v6, v7, v8

local function resolveHitboxes() -- line 36 | captures: v6, v7, v8, Workspace, ZonesConfig
    if v6 and v7 and v7.Parent ~= nil then
        return v6
    end
    local v9 = Workspace:FindFirstChild(ZonesConfig.BuildFolderName)
    local v10 = v9 and v9:FindFirstChild(ZonesConfig.ZoneHitboxesName)
    if v10 then
        if v6 and v10 == v7 then
            return v6
        end
        local v11 = {}
        for v12, v13 in ZonesConfig.Zones do
            local v14 = v10:FindFirstChild((tostring(v12)))
            if v14 and v14:IsA("BasePart") then
                local v15 = {
                    Part = v14,
                    Id = v13.Id
                }
                table.insert(v11, v15)
            end
        end
        local v16 = v10:FindFirstChild(ZonesConfig.SafeZoneName)
        if v16 and v16:IsA("BasePart") then
            local v17 = {
                Part = v16,
                Id = ZonesConfig.SafeZoneName
            }
            table.insert(v11, v17)
        end
        v6 = v11
        if v7 ~= v10 then
            v7 = v10
            if v8 then
                v8:Disconnect()
            end
            v8 = v10.ChildAdded:Connect(function() -- line 73 | captures: v6
                v6 = nil
            end)
        end
        return v11
    end
    return nil
end

function v1.GetZoneAt(v18) -- line 82 | captures: resolveHitboxes
    local v19 = resolveHitboxes()
    if v19 then
        for v20, v21 in v19 do
            if v21.Part.Parent ~= nil then
                local Part = v21.Part
                local v22 = Part.CFrame:PointToObjectSpace(v18)
                local v23 = Part.Size * 0.5
                local X = v22.X
                local v24
                if math.abs(X) <= v23.X then
                    local Y = v22.Y
                    if math.abs(Y) <= v23.Y + 2 then
                        local Z = v22.Z
                        v24 = math.abs(Z) <= v23.Z
                    else
                        v24 = false
                    end
                else
                    v24 = false
                end
                if v24 then
                    return v21.Id
                end
            end
        end
    end
    return nil
end

function v1.GetZoneIndexAt(v25) -- line 98 | captures: ZonesConfig, v1
    return ZonesConfig.IndexOf(v1.GetZoneAt(v25))
end

return v1
