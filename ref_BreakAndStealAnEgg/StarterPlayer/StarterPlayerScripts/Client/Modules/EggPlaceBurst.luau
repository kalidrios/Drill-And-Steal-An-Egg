-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local VFXScaler = require(ReplicatedStorage.Shared.VFXScaler)
local v1 = {}
local TargetHeight = EggRewards.TargetHeight

local function getTemplate() -- line 38 | captures: ReplicatedStorage
    local VFX = ReplicatedStorage:FindFirstChild("VFX")
    local v2 = VFX and VFX:FindFirstChild("EggPlaceVFX")
    if v2 and v2:IsA("BasePart") then
        return v2
    end
    return nil
end

function v1.Play(v3, v4) -- line 46 | captures: ReplicatedStorage, Workspace, VFXScaler, TargetHeight
    local function v5(...)
        return (tonumber(...))
    end

    local VFX = ReplicatedStorage:FindFirstChild("VFX")
    local v6 = VFX and VFX:FindFirstChild("EggPlaceVFX")
    if not (v6 and v6:IsA("BasePart")) then
        v6 = nil
    end
    if v6 then
        local v7 = v4 / TargetHeight
        local v8 = math.clamp(v7, 0.25, 20)
        local v9 = v6:Clone()
        v9.Anchored = true
        v9.CanCollide = false
        v9.CanQuery = false
        v9.CanTouch = false
        v9.Transparency = 1
        local new = CFrame.new
        local v10 = v8 * 0.1
        v9.CFrame = new(v3 + Vector3.new(0, v10, 0))
        local v11 = {}
        local v12 = 0
        for v13, v14 in v9:GetDescendants() do
            if v14:IsA("ParticleEmitter") then
                v14.Enabled = false
                VFXScaler.ScaleParticle(v14, v8)
                table.insert(v11, v14)
                local Max = v14.Lifetime.Max
                local TimeScale = v14.TimeScale
                local v15 = Max / math.max(TimeScale, 0.05)
                v12 = math.max(v12, v15)
            end
        end
        v9.Parent = Workspace
        for v16, v17 in v11 do
            local v18 = v5(v17:GetAttribute("EmitCount")) or v17.Rate
            v17:Emit((math.max(v18, 1)))
        end
        task.delay(v12 + 0.5, function() -- line 83 | captures: v9
            v9:Destroy()
        end)
    else
        warn("[EggPlaceBurst] ReplicatedStorage.VFX.EggPlaceVFX missing")
    end
end

return v1
