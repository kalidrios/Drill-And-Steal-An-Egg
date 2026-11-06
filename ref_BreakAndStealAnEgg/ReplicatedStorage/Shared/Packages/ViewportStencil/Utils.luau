-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local v1 = {}

local function getDefaultParams() -- line 12 | captures: Players
    local v2 = RaycastParams.new()
    v2.FilterType = Enum.RaycastFilterType.Exclude
    local v3 = Players.LocalPlayer and Players.LocalPlayer.Character
    if v3 then
        v2.FilterDescendantsInstances = { v3 }
    end
    return v2
end

local function fromNormal(v4, v5, v6) -- line 23
    local Unit = v5.Unit
    local Z = Unit.Z
    local v7
    if math.abs(Z) < 0.999 then
        v7 = Vector3.new(0, 0, 1)
    else
        v7 = Vector3.new(1, 0, 0)
    end
    local Unit_2 = Unit:Cross(v7).Unit
    local v8 = Unit_2:Cross(Unit)
    local v9 = CFrame.fromMatrix(v4, Unit_2, Unit, v8)
    if v6 then
        v9 *= CFrame.Angles(0, v6, 0)
    end
    return v9
end

v1.fromNormal = fromNormal

function v1.fromRaycastResult(v10, v11) -- line 36 | captures: v1
    return v1.fromNormal(v10.Position, v10.Normal, v11)
end

function v1.raycast(v12, v13, v14, v15) -- line 41 | captures: Players, v1
    local workspace_2 = workspace
    local v16
    if v14 then
        v16 = v14
    else
        local v17 = RaycastParams.new()
        v17.FilterType = Enum.RaycastFilterType.Exclude
        local v18 = Players.LocalPlayer and Players.LocalPlayer.Character
        if v18 then
            v17.FilterDescendantsInstances = { v18 }
        end
        v16 = v17
    end
    local v19 = workspace_2:Raycast(v12, v13, v16)
    if v19 then
        return (v1.fromRaycastResult(v19, v15))
    end
    return nil
end

function v1.fromScreenPoint(v20, v21, v22, v23, v24) -- line 47 | captures: v1
    local CurrentCamera = workspace.CurrentCamera
    if CurrentCamera then
        local v25 = CurrentCamera:ViewportPointToRay(v20, v21)
        return v1.raycast(v25.Origin, v25.Direction * (v23 or 1000), v22, v24)
    end
    return nil
end

function v1.fromMouse(v26, v27, v28) -- line 62 | captures: UserInputService, v1
    local v29 = UserInputService:GetMouseLocation()
    return v1.fromScreenPoint(v29.X, v29.Y, v26, v27, v28)
end

function v1.belowCharacter(v30, v31, v32) -- line 68 | captures: Players, v1
    local v33 = v30 or Players.LocalPlayer and Players.LocalPlayer.Character
    if v33 then
        local HumanoidRootPart = v33:FindFirstChild("HumanoidRootPart")
        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            return nil
        end
        local v34 = RaycastParams.new()
        v34.FilterType = Enum.RaycastFilterType.Exclude
        v34.FilterDescendantsInstances = { v33 }
        local v35 = -(v31 or 10)
        local v36 = Vector3.new(0, v35, 0)
        return v1.raycast(HumanoidRootPart.Position, v36, v34, v32)
    end
    return nil
end

return v1
