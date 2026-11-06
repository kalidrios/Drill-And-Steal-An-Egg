-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local v1 = {}

function v1.Below(v2, v3) -- line 32 | captures: Players, Workspace
    local v4
    if v3 then
        v4 = table.clone(v3)
    else
        v4 = {}
    end
    for v5, v6 in Players:GetPlayers() do
        if v6.Character then
            local Character = v6.Character
            table.insert(v4, Character)
        end
    end
    local v7 = RaycastParams.new()
    v7.FilterType = Enum.RaycastFilterType.Exclude
    for v8 = 1, 6 do
        v7.FilterDescendantsInstances = v4
        local v9 = Workspace:Raycast(v2 + Vector3.new(0, 1.5, 0), Vector3.new(0, -12, 0), v7)
        if not (v9 and v9.Instance:IsA("BasePart")) then
            return nil
        end
        local Instance = v9.Instance
        if Instance.Transparency < 0.9 then
            return Instance
        end
        table.insert(v4, Instance)
    end
    return nil
end

function v1.Apply(v10, v11) -- line 56
    local v12 = {}
    if v11 and v11:IsA("BasePart") then
        v10.Material = v11.Material
        v10.MaterialVariant = v11.MaterialVariant
        v10.Color = v11.Color
        for v13, v14 in v11:GetChildren() do
            if v14:IsA("Texture") or v14:IsA("Decal") then
                local v15 = v14:Clone()
                v15.Parent = v10
                table.insert(v12, v15)
            end
        end
    end
    return v12
end

function v1.Fade(v16, v17) -- line 74 | captures: TweenService
    for v18, v19 in v16 do
        if v19.Parent then
            TweenService:Create(v19, v17, { Transparency = 1 }):Play()
        end
    end
end

return v1
