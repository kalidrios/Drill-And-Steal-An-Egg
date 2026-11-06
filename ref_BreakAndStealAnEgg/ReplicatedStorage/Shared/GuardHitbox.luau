-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalWalker = require(ReplicatedStorage.Shared.AnimalWalker)
local ZonesConfig = require(ReplicatedStorage.Shared.ZonesConfig)
local v1 = {
    NAME = "BodyHitbox",
    DefaultScale = Vector3.new(0.800000011920929, 0.5, 0.8500000238418579)
}

local function applyRuntimeProperties(v2) -- line 83
    v2.Transparency = 1
    v2.CanCollide = false
    v2.CanTouch = false
    v2.CanQuery = true
    v2.CastShadow = false
end

local function applyShrink(v3) -- line 97 | captures: ZonesConfig
    local HitboxShrink = ZonesConfig.Guard.HitboxShrink
    if not (HitboxShrink ~= nil) or v3:GetAttribute("HitboxShrunk") then
        return
    end
    v3:SetAttribute("HitboxShrunk", true)
    local v4 = v3.Size.X * HitboxShrink.X
    local v5 = math.max(v4, 0.1)
    local v6 = v3.Size.Y * HitboxShrink.Y
    local v7 = math.max(v6, 0.1)
    local v8 = v3.Size.Z * HitboxShrink.Z
    local v9 = math.max(v8, 0.1)
    v3.Size = Vector3.new(v5, v7, v9)
end

local function flatCFrame(v10) -- line 121
    local LookVector = v10.CFrame.LookVector
    local X = LookVector.X
    local Z = LookVector.Z
    local v11 = Vector3.new(X, 0, Z)
    if v11.Magnitude <= 0.0001 then
        return CFrame.new(v10.Position)
    end
    return CFrame.lookAt(v10.Position, v10.Position + v11.Unit)
end

function v1.Ensure(v12, v13) -- line 137 | captures: AnimalWalker, v1, applyShrink
    local v14 = v12:FindFirstChild(v1.NAME)
    if not (v14 ~= nil and v14:IsA("BasePart")) then
        local v15 = AnimalWalker.ResolveBodyMesh(v12, AnimalWalker.Find(v12))
        if v15 == nil then
            return nil
        end
        local v16 = v13 or v1.DefaultScale
        local Part = Instance.new("Part")
        Part.Name = v1.NAME
        local v17 = v15.Size.X * v16.X
        local v18 = math.max(v17, 0.1)
        local v19 = v15.Size.Y * v16.Y
        local v20 = math.max(v19, 0.1)
        local v21 = v15.Size.Z * v16.Z
        local v22 = math.max(v21, 0.1)
        Part.Size = Vector3.new(v18, v20, v22)
        local LookVector = v15.CFrame.LookVector
        local X = LookVector.X
        local Z = LookVector.Z
        local v23 = Vector3.new(X, 0, Z)
        if v23.Magnitude <= 0.0001 then
            Part.CFrame = CFrame.new(v15.Position)
        else
            Part.CFrame = CFrame.lookAt(v15.Position, v15.Position + v23.Unit)
        end
        Part.Transparency = 1
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = true
        Part.CastShadow = false
        applyShrink(Part)
        Part.Anchored = true
        Part.Parent = v12
        return Part
    end
    v14.Transparency = 1
    v14.CanCollide = false
    v14.CanTouch = false
    v14.CanQuery = true
    v14.CastShadow = false
    applyShrink(v14)
    return v14
end

local function SetVisible(v24, v25) -- line 181
    if v25 then
        v24.Transparency = 0.7
    else
        v24.Transparency = 1
    end
    v24.Color = Color3.fromRGB(255, 60, 60)
    v24.Material = Enum.Material.Neon
end

v1.SetVisible = SetVisible
return v1
