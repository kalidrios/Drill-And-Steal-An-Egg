-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RranBossConfig = require(ReplicatedStorage.Shared.RranBossConfig)
local v1 = {}

function v1.Get(v2) -- line 23 | captures: RranBossConfig
    local v3 = v2:FindFirstChild(RranBossConfig.LauncherName)
    local PrimaryPart = v2.PrimaryPart
    if v3 and PrimaryPart then
        if v3:IsA("Model") then
            local v4 = v3:FindFirstChild(RranBossConfig.MuzzlePartName, true)
            if v4 and v4:IsA("BasePart") then
                local Position = v3:GetBoundingBox().Position
                local v5 = v4.Position - Position
                if v5.Magnitude < 0.001 then
                    v5 = PrimaryPart.CFrame.LookVector
                end
                return v4.Position, v5.Unit
            end
        elseif v3:IsA("BasePart") then
            local Size = v3.Size
            local CFrame = v3.CFrame
            local LookVector = CFrame.LookVector
            local v6 = Size.Z / 2
            local X = Size.X
            local v7 = Size.Y < X
            local v8
            if v7 then
                local X = Size.X
                v8 = Size.Z < X
            end
            if not v7 or not v8 then
                local Y = Size.Y
                if Size.X < Y then
                    local Y = Size.Y
                    if Size.Z < Y then
                        LookVector, v6 = CFrame.UpVector, Size.Y / 2
                    end
                end
            else
                LookVector, v6 = CFrame.RightVector, Size.X / 2
            end
            if LookVector:Dot(PrimaryPart.CFrame.LookVector + Vector3.new(0, 0.5, 0)) < 0 then
                LookVector = -LookVector
            end
            return v3.Position + LookVector * v6, LookVector
        end
    end
    return nil, nil
end

function v1.Nearest(v9, v10) -- line 61 | captures: CollectionService, RranBossConfig, v1
    local v11
    local v12 = v10
    for v13, v14 in CollectionService:GetTagged(RranBossConfig.Tag) do
        if v14:IsA("Model") then
            local v15 = v1.Get(v14)
            local v16 = if v15 then (v15 - v9).Magnitude else (1/0)
            if v16 < v12 then
                v11 = v14
                v12 = v16
            end
        end
    end
    return v11
end

return v1
