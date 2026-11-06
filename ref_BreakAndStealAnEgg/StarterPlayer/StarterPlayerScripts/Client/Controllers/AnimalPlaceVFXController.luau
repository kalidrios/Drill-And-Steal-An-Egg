-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ModelScaler = require(ReplicatedStorage.Shared.ModelScaler)
local v1 = {}

local function getTemplate() -- line 65 | captures: ReplicatedStorage
    local VFX = ReplicatedStorage:FindFirstChild("VFX")
    local v2 = VFX and VFX:FindFirstChild("AnimalPlace")
    if v2 and v2:IsA("BasePart") then
        return v2
    end
    return nil
end

local v3 = (-1/0)

local function playCollectSound() -- line 80 | captures: v3, Debris, SoundService
    local v4 = os.clock()
    if v4 - v3 < 0.1 then
        return
    end
    v3 = v4
    local rransCustomSFX = SoundService:FindFirstChild("rransCustomSFX")
    local v5 = rransCustomSFX and rransCustomSFX:FindFirstChild("Correct Reveal")
    if v5 and v5:IsA("Sound") then
        local v6 = v5:Clone()
        v6.Parent = SoundService
        v6.Ended:Once(function() -- line 96 | captures: v6
            v6:Destroy()
        end)
        local TimeLength = v6.TimeLength
        Debris:AddItem(v6, math.max(TimeLength, 1) + 1)
        v6:Play()
    else
        warn("[AnimalPlaceVFXController] SoundService.rransCustomSFX.Correct Reveal missing")
    end
end

local v7 = {}
local v8 = {}
local v9 = { __mode = "k" }
local v10 = setmetatable(v8, v9)

local function armPop(v11) -- line 118 | captures: v7
    local v12 = os.clock()
    local v13 = #v7
    for v14 = v13, 1, -1 do
        if v12 - v7[v14].stamp > 3 then
            table.remove(v7, v14)
        end
    end
    local v15 = {
        position = v11,
        stamp = v12
    }
    table.insert(v7, v15)
end

local function consumePopAt(v16) -- line 134 | captures: v7
    local v17 = os.clock()
    local v18 = #v7
    local v19
    local v20 = (1/0)
    for v21 = v18, 1, -1 do
        local v22 = v7[v21]
        if v17 - v22.stamp > 3 then
            table.remove(v7, v21)
        else
            local Magnitude = (v22.position - v16).Magnitude
            if Magnitude <= 15 and Magnitude < v20 then
                v19 = v21
                v20 = Magnitude
            end
        end
    end
    if v19 then
        table.remove(v7, v19)
        return true
    end
    return false
end

local function getRoot(v23) -- line 158
    local PrimaryPart = v23.PrimaryPart
    if PrimaryPart then
        return PrimaryPart
    end
    local v24
    local v25 = -1
    for v26, v27 in v23:GetDescendants() do
        if v27:IsA("BasePart") then
            local Size = v27.Size
            local v28 = Size.X * Size.Y * Size.Z
            if v25 < v28 then
                v24 = v27
                v25 = v28
            end
        end
    end
    return v24
end

local function elasticPopIn(v29) -- line 182 | captures: RunService, TweenService, ModelScaler, v7, consumePopAt, getRoot
    local v30 = os.clock() + 3
    local v31
    local v32 = 0
    local v33, v34
    while true do
        if os.clock() < v30 then
            if v29.Parent then
                if not v31 and v32 <= os.clock() then
                    v31, v32 = getRoot(v29), os.clock() + 0.1
                end
                if not (v31 and consumePopAt(v31.Position)) then
                    if #v7 > 0 then
                        RunService.RenderStepped:Wait()
                    else
                        task.wait(0.1)
                    end
                    continue
                end
                v34 = v31
                v33 = true
                break
            end
            return
        end
        v34 = v31
        v33 = false
        break
    end
    if not (v33 and v34 and v29.Parent) then
        return
    end
    local v35 = ModelScaler.Capture(v29, v34.CFrame)
    local v36 = os.clock()
    while v29.Parent do
        if v34.Parent then
            local v37 = os.clock() - v36
            local v38 = v37 / 0.7
            local v39 = 0.05 + 0.95 * TweenService:GetValue(math.clamp(v38, 0, 1), Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
            ModelScaler.Apply(v35, math.max(v39, 0.01), v34.CFrame)
            if v37 >= 0.7 then
                break
            end
            RunService.RenderStepped:Wait()
            continue
        end
        break
    end
    if v29.Parent and v34.Parent then
        ModelScaler.Apply(v35, 1, v34.CFrame)
    end
end

local function watchPlacedModel(v40) -- line 245 | captures: v10, elasticPopIn
    if v40:IsA("Model") and not v10[v40] then
        v10[v40] = true
        task.spawn(elasticPopIn, v40)
    end
end

local function play(v41) -- line 252 | captures: ReplicatedStorage, Workspace, armPop
    armPop(v41)
    local VFX = ReplicatedStorage:FindFirstChild("VFX")
    local v42 = VFX and VFX:FindFirstChild("AnimalPlace")
    if not (v42 and v42:IsA("BasePart")) then
        v42 = nil
    end
    if v42 then
        local v43 = v42:Clone()
        v43.Anchored = true
        v43.CanCollide = false
        v43.CanQuery = false
        v43.CanTouch = false
        v43.CFrame = CFrame.new(v41 + Vector3.new(0, 0.5, 0))
        local v44 = {}
        local v45 = 0
        for v46, v47 in v43:GetDescendants() do
            if v47:IsA("ParticleEmitter") then
                v47.Enabled = false
                table.insert(v44, v47)
                local Max = v47.Lifetime.Max
                local TimeScale = v47.TimeScale
                local v48 = Max / math.max(TimeScale, 0.05)
                v45 = math.max(v45, v48)
            end
        end
        v43.Parent = Workspace
        for v49, v50 in v44 do
            local v51 = v50:GetAttribute("EmitCount") or v50.Rate
            v50:Emit((math.max(v51, 1)))
        end
        task.delay(v45 + 0.5, function() -- line 291 | captures: v43
            v43:Destroy()
        end)
    else
        warn("[AnimalPlaceVFXController] ReplicatedStorage.VFX.AnimalPlace missing")
    end
end

local v52 = {}

local function prunePredictions() -- line 305 | captures: v52
    local v53 = #v52
    for v54 = v53, 1, -1 do
        if os.clock() - v52[v54] > 3 then
            table.remove(v52, v54)
        end
    end
end

function v1.PredictPlacement(v55) -- line 315 | captures: playCollectSound, play, v52, prunePredictions
    local function v56(v57, ...)
        table.insert(v57, ...)
    end

    prunePredictions()
    v56(v52, os.clock())
    playCollectSound()
    play(v55)
end

function v1.CancelPrediction() -- line 324 | captures: v52, prunePredictions
    prunePredictions()
    table.remove(v52)
end

function v1.Start() -- line 329 | captures: CollectionService, Players, ReplicatedStorage, Workspace, playCollectSound, watchPlacedModel, play, v52, prunePredictions
    CollectionService:GetInstanceAddedSignal("PlacedAnimal"):Connect(watchPlacedModel)
    local v58 = ReplicatedStorage:WaitForChild("AnimalPlacedVFXRemote", 30)
    if not (v58 and v58:IsA("RemoteEvent")) then
        warn("[AnimalPlaceVFXController] AnimalPlacedVFXRemote missing")
    else
        v58.OnClientEvent:Connect(function(v59, v60, v61) -- line 340 | captures: Players, Workspace, playCollectSound, play, v52, prunePredictions
            if typeof(v59) ~= "Vector3" then
                return
            end
            if v60 == Players.LocalPlayer and v61 ~= false then
                prunePredictions()
                if #v52 > 0 then
                    table.remove(v52, 1)
                    return
                end
                playCollectSound()
            end
            local CurrentCamera = Workspace.CurrentCamera
            if not (CurrentCamera and (CurrentCamera.CFrame.Position - v59).Magnitude > 250) then
                play(v59)
            end
        end)
    end
end

return v1
