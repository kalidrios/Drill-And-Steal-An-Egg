-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local ModelScaler = require(ReplicatedStorage.Shared.ModelScaler)
local v1 = {}
local v2 = {}
local v3 = { __mode = "k" }
local v4 = setmetatable(v2, v3)

local function quadOut(v5) -- line 26
    return 1 - (1 - v5) * (1 - v5)
end

local function hideBillboards(v6) -- line 33
    for v7, v8 in v6:GetDescendants() do
        if v8:IsA("BillboardGui") then
            v8.Enabled = false
        end
    end
end

local function popAway(v9) -- line 43 | captures: RunService, EggRewards, ModelScaler, hideBillboards
    local PickupDespawnPop = EggRewards.PickupDespawnPop
    hideBillboards(v9)
    local v10 = ModelScaler.Capture(v9)
    local v11 = PickupDespawnPop.PopTime + PickupDespawnPop.ShrinkTime
    local v12 = os.clock()
    while true do
        local v13, v14
        if v9.Parent then
            v13 = os.clock() - v12
            if v13 < PickupDespawnPop.PopTime then
                local v15 = PickupDespawnPop.PopScale - 1
                local v16 = v13 / PickupDespawnPop.PopTime
                v14 = 1 + v15 * (1 - (1 - v16) * (1 - v16))
            else
                local v17 = (v13 - PickupDespawnPop.PopTime) / PickupDespawnPop.ShrinkTime
                local v18 = math.clamp(v17, 0, 1)
                v14 = PickupDespawnPop.PopScale * (1 - v18 * v18)
            end
        else
            break
        end
        ModelScaler.Apply(v10, (math.max(v14, 0.01)))
        if v11 <= v13 then
            break
        end
        RunService.RenderStepped:Wait()
    end
    if v9.Parent then
        for v19, v20 in v9:GetDescendants() do
            if v20:IsA("BasePart") then
                v20.LocalTransparencyModifier = 1
            end
        end
    end
end

local function watchPickup(v21) -- line 78 | captures: v4, popAway
    if v21:IsA("Model") and not v4[v21] then
        v4[v21] = true
        if v21:GetAttribute("Despawning") then
            task.spawn(popAway, v21)
        else
            v21:GetAttributeChangedSignal("Despawning"):Connect(function() -- line 87 | captures: v21, popAway
                if v21:GetAttribute("Despawning") then
                    popAway(v21)
                end
            end)
        end
    end
end

function v1.Start() -- line 94 | captures: CollectionService, watchPickup
    for v22, v23 in CollectionService:GetTagged("AnimalPickup") do
        watchPickup(v23)
    end
    CollectionService:GetInstanceAddedSignal("AnimalPickup"):Connect(watchPickup)
end

return v1
