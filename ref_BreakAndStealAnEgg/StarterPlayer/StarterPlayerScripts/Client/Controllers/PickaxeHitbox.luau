-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local EggTargeting = require(ReplicatedStorage.Shared.EggTargeting)
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local v1 = {}
local v2 = {}
local v3 = {}
local v4 = true
local v5 = OverlapParams.new()

v5.FilterType = Enum.RaycastFilterType.Include

local function onEggAdded(v6) -- line 37 | captures: v4, v2, v3
    if v3[v6] then
        return
    end
    table.insert(v2, v6)
    v3[v6] = #v2
    v4 = true
end

local function onEggRemoved(v7) -- line 46 | captures: v4, v2, v3
    local v8 = v3[v7]
    if not v8 then
        return
    end
    local v9 = #v2
    local v10 = v2[v9]
    v2[v8] = v10
    v3[v10] = v8
    v2[v9] = nil
    v3[v7] = nil
    v4 = true
end

for v11, v12 in CollectionService:GetTagged("BreakableEgg") do
    if not v3[v12] then
        table.insert(v2, v12)
        v3[v12] = #v2
        v4 = true
    end
end
CollectionService:GetInstanceAddedSignal("BreakableEgg"):Connect(onEggAdded)
CollectionService:GetInstanceRemovedSignal("BreakableEgg"):Connect(onEggRemoved)
local v13, v14

local function stop() -- line 72 | captures: v13, v14
    if v13 then
        v13:Disconnect()
        v13 = nil
    end
    v14 = nil
end

function v1.Stop() -- line 84 | captures: v13, v14
    if v13 then
        v13:Disconnect()
        v13 = nil
    end
    v14 = nil
end

function v1.Flush() -- line 96 | captures: v13, v14
    local v15 = v14
    if v13 then
        v13:Disconnect()
        v13 = nil
    end
    v14 = nil
    if v15 then
        v15()
    end
end

function v1.Sweep(v16, v17, v18, v19) -- line 119 | captures: v4, v13, v14, RunService, Workspace, EggConfig, EggTargeting, PickaxeConfig, v2, v3, v5
    local v20 = v14
    if v13 then
        v13:Disconnect()
        v13 = nil
    end
    v14 = nil
    if v20 then
        v20()
    end
    local v21 = v16:FindFirstChild(PickaxeConfig.ToolName)
    if not (v21 and v21:IsA("Tool")) then
        return
    end
    local Handle = v21:FindFirstChild("Handle")
    if Handle and Handle:IsA("BasePart") then
        if v4 then
            v5.FilterDescendantsInstances = v2
            v4 = false
        end
    else
        return
    end
    local Hitbox = PickaxeConfig.Hitbox
    local v22 = Vector3.new(1, 1, 1) * (Hitbox.Padding * 2)
    local v23 = os.clock() + (v19 or Hitbox.SweepDuration)
    v14 = v18
    v13 = RunService.Heartbeat:Connect(function() -- line 155 | captures: v16, v17, v18, v21, Handle, v22, v23, v13, v14, Workspace, EggConfig, EggTargeting, v3, v5
        if not (Handle.Parent == v21 and v21.Parent == v16) then
            if v13 then
                v13:Disconnect()
                v13 = nil
            end
            v14 = nil
        else
            local v24 = os.clock()
            if v23 < v24 then
                if v13 then
                    v13:Disconnect()
                    v13 = nil
                end
                v14 = nil
                if v18 then
                    v18()
                end
            else
                local v25 = Workspace:GetPartBoundsInBox(Handle.CFrame, Handle.Size + v22, v5)
                local HumanoidRootPart = v16:FindFirstChild("HumanoidRootPart")
                for v26, v27 in v25 do
                    local v28 = v27
                    while v28 do
                        if v3[v28] then
                            break
                        end
                        v28 = v28.Parent
                        if not (v28 and v28:IsA("BasePart")) then
                            v28 = nil
                        end
                    end
                    if v28 and not v28:GetAttribute("Broken") and not v28:GetAttribute("Hatching") and not v28:GetAttribute("Despawning") and HumanoidRootPart and HumanoidRootPart:IsA("BasePart") and EggTargeting.SurfaceDistance(v28, HumanoidRootPart.Position) <= EggConfig.HitRange then
                        if v13 then
                            v13:Disconnect()
                            v13 = nil
                        end
                        v14 = nil
                        v17(v28)
                        return
                    end
                end
            end
        end
    end)
end

return v1
