-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local v1 = {}
local v2 = {
    "PlacedAnimal",
    MergeConfig.PlacedEggTag
}
local v3 = RaycastParams.new()

v3.FilterType = Enum.RaycastFilterType.Exclude

local function buildExclude() -- line 40 | captures: CollectionService, Players, v2
    local v4 = {}
    for v5, v6 in v2 do
        for v7, v8 in CollectionService:GetTagged(v6) do
            table.insert(v4, v8)
        end
    end
    for v9, v10 in Players:GetPlayers() do
        if v10.Character then
            local Character = v10.Character
            table.insert(v4, Character)
        end
    end
    return v4
end

function v1.Get() -- line 55 | captures: Players, Workspace, v3, buildExclude
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera then
        local v11 = Players.LocalPlayer:GetMouse()
        local v12 = CurrentCamera:ScreenPointToRay(v11.X, v11.Y)
        v3.FilterDescendantsInstances = buildExclude()
        local v13 = Workspace:Raycast(v12.Origin, v12.Direction * 1000, v3)
        if v13 then
            return v13.Position
        end
    end
    return nil
end

return v1
