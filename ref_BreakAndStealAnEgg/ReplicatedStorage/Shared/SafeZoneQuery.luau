-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Workspace = game:GetService("Workspace")
local SpeedConfig = require(script.Parent.SpeedConfig)
local ZonesConfig = require(script.Parent.ZonesConfig)
local v1 = {}
local v2 = SpeedConfig.MaxWalkSpeed * 0.1 + 3

v1.YPad = 2

local function IsPositionInPart(v3, v4) -- line 55
    local v5 = v3.CFrame:PointToObjectSpace(v4)
    local v6 = v3.Size * 0.5
    local X = v5.X
    if math.abs(X) <= v6.X then
        local Y = v5.Y
        if math.abs(Y) <= v6.Y + 2 then
            local Z = v5.Z
            return math.abs(Z) <= v6.Z
        end
    end
    return false
end

v1.IsPositionInPart = IsPositionInPart

function v1.LeadPosition(v7) -- line 63 | captures: v2
    local AssemblyLinearVelocity = v7.AssemblyLinearVelocity
    local X = AssemblyLinearVelocity.X
    local Z = AssemblyLinearVelocity.Z
    local v8 = Vector3.new(X, 0, Z) * 0.1
    local Magnitude = v8.Magnitude
    if v2 < Magnitude then
        v8 = v8.Unit * v2
    end
    return v7.Position + v8
end

local v9
local v10 = table.freeze({})
local v11 = 0
local v12, v13

local function watchBuild(v14) -- line 89 | captures: v9, v11, v12, v13, ZonesConfig
    if v12 == v14 then
        return
    end
    v12 = v14
    if v13 then
        v13:Disconnect()
    end
    v13 = v14.DescendantAdded:Connect(function(v15) -- line 97 | captures: v9, v11, ZonesConfig
        if v15.Name == ZonesConfig.SafeZoneName and v15:IsA("BasePart") then
            v9 = nil
            v11 = 0
        end
    end)
end

function v1.GetSafeParts() -- line 107 | captures: v9, v11, v12, v13, Workspace, ZonesConfig, v10
    if v9 then
        for v16, v17 in v9 do
            if v17.Parent then
                return v9
            end
        end
        v9 = nil
    end
    local v18 = os.clock()
    if v18 < v11 then
        return v10
    end
    local v19 = {}
    local v20 = Workspace:FindFirstChild(ZonesConfig.BuildFolderName)
    if v20 then
        if v12 ~= v20 then
            v12 = v20
            if v13 then
                v13:Disconnect()
            end
            v13 = v20.DescendantAdded:Connect(function(v21) -- line 97 | captures: v9, v11, ZonesConfig
                if v21.Name == ZonesConfig.SafeZoneName and v21:IsA("BasePart") then
                    v9 = nil
                    v11 = 0
                end
            end)
        end
        for v22, v23 in v20:GetDescendants() do
            if v23.Name == ZonesConfig.SafeZoneName and v23:IsA("BasePart") then
                table.insert(v19, v23)
            end
        end
    end
    if #v19 > 0 then
        v9 = v19
    else
        v11 = v18 + 1
    end
    return v19
end

function v1.IsPositionSafe(v24) -- line 142 | captures: v1
    for v25, v26 in v1.GetSafeParts() do
        if v1.IsPositionInPart(v26, v24) then
            return true
        end
    end
    return false
end

local v27 = {}
local v28 = {}

function v1.GetOwnedPlotHitbox(v29) -- line 169 | captures: Workspace, ZonesConfig, v27, v28
    local v30 = v28[v29]
    if v30 then
        if v30.hitbox.Parent and v30.model:GetAttribute("OwnerUserId") == v29 then
            return v30.hitbox
        end
        v28[v29] = nil
    end
    local v31 = os.clock()
    if not (v31 < (v27[v29] or 0)) then
        local v32 = Workspace:FindFirstChild(ZonesConfig.PlotsFolderName)
        if v32 then
            for v33, v34 in v32:GetChildren() do
                if v34:GetAttribute("OwnerUserId") == v29 then
                    local v35 = v34:FindFirstChild(ZonesConfig.PlotSafePartName)
                    if v35 and v35:IsA("BasePart") then
                        v28[v29] = {
                            model = v34,
                            hitbox = v35
                        }
                        v27[v29] = nil
                        return v35
                    end
                end
            end
        end
        v27[v29] = v31 + 1
    end
    return nil
end

function v1.IsPositionInOwnedPlot(v36, v37) -- line 201 | captures: v1
    local v38 = v1.GetOwnedPlotHitbox(v36)
    if v38 == nil then
        return false
    end
    return (v1.IsPositionInPart(v38, v37))
end

function v1.IsBankable(v39, v40) -- line 211 | captures: v1
    return v1.IsPositionInOwnedPlot(v39, v40) or v1.IsPositionSafe(v40)
end

return v1
