-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local v1 = {}
local v2 = Random.new()
local v3

local function getContainer() -- line 19 | captures: v3, Workspace
    if not (v3 and v3.Parent) then
        v3 = Instance.new("Folder")
        v3.Name = "EggDebrisParts"
        v3.Parent = Workspace
    end
    return v3
end

local function despawn(v4) -- line 28 | captures: TweenService, EggConfig
    local Debris = EggConfig.Debris
    v4.Anchored = true
    v4.CanCollide = false
    local Size = v4.Size
    local v5 = Size * Debris.PopScale
    local v6 = (v5.Y - Size.Y) / 2
    local v7 = TweenService:Create(v4, TweenInfo.new(Debris.PopTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = v5,
        CFrame = v4.CFrame + Vector3.new(0, v6, 0)
    })
    v7.Completed:Connect(function() -- line 45 | captures: v4, Debris, v5, TweenService
        local v8 = v5.Y / 2 - 0.025
        local v9 = TweenService:Create(v4, TweenInfo.new(Debris.ShrinkTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806),
            CFrame = v4.CFrame - Vector3.new(0, v8, 0)
        })
        v9.Completed:Connect(function() -- line 51 | captures: v4
            v4:Destroy()
        end)
        v9:Play()
    end)
    v7:Play()
end

function v1.Erupt(v10, v11) -- line 61 | captures: v3, TweenService, Workspace, EggConfig, v2, despawn
    local function v12(v13, v14, ...)
        return (Vector3.new(v13, v14, ...))
    end

    local v15 = v11 or 1
    local v16 = math.max(v15, 0.5)
    local Debris = EggConfig.Debris
    local v17 = v2:NextInteger(Debris.MinCount, Debris.MaxCount) * v16 + 0.5
    local v18 = math.floor(v17)
    local X = v10.Size.X
    local Z = v10.Size.Z
    local v19 = math.min(X, Z) / 2
    local v20 = EggConfig.VFXScaleForWidth(v19 * 2)
    local v21 = math.sqrt(v20)
    local v22 = v2:NextNumber(0, 6.283185307179586)
    local v23 = 6.283185307179586 / v18
    local v24 = Debris.Size * v20 * math.min(v16, 1.6)
    local v25 = math.min(v16, 1.5) * v21
    for v26 = 1, v18 do
        local v27 = v22 + v23 * (v26 - 1) + v2:NextNumber(-v23 * 0.25, v23 * 0.25)
        local v28 = math.cos(v27)
        local v29 = math.sin(v27)
        local v30 = Vector3.new(v28, 0, v29)
        local Part = Instance.new("Part")
        Part.Name = "EggChunk"
        Part.Size = Vector3.new(1, 1, 1) * (v24 * Debris.SpawnScale)
        Part.Color = v10.Color
        Part.Material = Enum.Material.Plastic
        Part.MaterialVariant = Debris.MaterialVariant
        Part.CollisionGroup = "EggDebris"
        Part.CanCollide = true
        Part.CanTouch = false
        Part.CanQuery = false
        local Position = v10.Position
        local v31 = v10.Size.Y * v2:NextNumber(0.3, 0.42)
        local v32 = Position + Vector3.new(0, v31, 0) + v30 * (v19 * v2:NextNumber(0.05, 0.25))
        Part.CFrame = CFrame.new(v32) * CFrame.Angles(v2:NextNumber(0, 3.141592653589793), v2:NextNumber(0, 3.141592653589793), v2:NextNumber(0, 3.141592653589793))
        if not (v3 and v3.Parent) then
            v3 = Instance.new("Folder")
            v3.Name = "EggDebrisParts"
            v3.Parent = Workspace
        end
        Part.Parent = v3
        TweenService:Create(Part, TweenInfo.new(Debris.GrowTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = Vector3.new(1, 1, 1) * v24 }):Play()
        local v33 = v2:NextNumber(Debris.SideSpeed[1], Debris.SideSpeed[2]) * v25
        local v34 = v2:NextNumber(Debris.UpSpeed[1], Debris.UpSpeed[2]) * v25
        Part.AssemblyLinearVelocity = v30 * v33 + Vector3.new(0, v34, 0)
        Part.AssemblyAngularVelocity = v12(v2:NextNumber(-8, 8), v2:NextNumber(-8, 8), v2:NextNumber(-8, 8))
        local spawn = task.spawn
        spawn(function() -- line 120 | captures: Debris, Part, v2, despawn
            task.wait(Debris.MinLifetime)
            local v35 = os.clock()
            while Part.Parent and os.clock() - v35 < Debris.SettleTimeout do
                if Part.AssemblyLinearVelocity.Magnitude < 1 then
                    break
                end
                task.wait(0.05)
            end
            if Part.Parent then
                task.wait(v2:NextNumber(Debris.RestTime[1], Debris.RestTime[2]))
                if Part.Parent then
                    despawn(Part)
                end
            end
        end)
    end
end

return v1
