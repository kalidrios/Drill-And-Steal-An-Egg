-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local ZonesConfig = require(ReplicatedStorage.Shared.ZonesConfig)
local v1 = {}
local v2
local v3 = 0

function v1.Params() -- line 27 | captures: v2, v3, Workspace, EggConfig, ZonesConfig
    if v2 and os.clock() - v3 < 10 then
        return v2
    end
    local v4 = { Workspace.Terrain }
    local v5 = Workspace:FindFirstChild(ZonesConfig.BuildFolderName)
    local v6 = v5 and v5:FindFirstChild(ZonesConfig.ZoneBuildsName)
    if v6 then
        for v7, v8 in v6:GetChildren() do
            local v9 = v8:FindFirstChild(EggConfig.Spawn.ZoneFloorFolderName)
            if v9 then
                table.insert(v4, v9)
            end
        end
    end
    local v10 = RaycastParams.new()
    v10.FilterType = Enum.RaycastFilterType.Include
    v10.FilterDescendantsInstances = v4
    v10.RespectCanCollide = true
    v2 = v10
    v3 = os.clock()
    return v10
end

function v1.Height(v11, v12, v13) -- line 53 | captures: Workspace, v1
    local v14 = v11 + Vector3.new(0, v12, 0)
    local v15 = -(v12 + 400)
    local v16 = Workspace:Raycast(v14, Vector3.new(0, v15, 0), v13 or v1.Params())
    if v16 then
        return v16.Position.Y
    end
    return nil
end

return v1
