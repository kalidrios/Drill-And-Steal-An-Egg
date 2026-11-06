-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local OwnBase = require(script.Parent.OwnBase)
local v1 = {}
local v2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = Color3.fromRGB(255, 60, 50)
local LocalPlayer = Players.LocalPlayer
local v4
local v5 = 0
local Color
local Get = OwnBase.Get
local Hitbox = OwnBase.Hitbox

local function isPlotFull() -- line 37 | captures: Get
    local v6 = Get()
    if v6 then
        local v7 = v6:GetAttribute("AnimalsPlaced") or 0
        local MaxAnimals = v6:GetAttribute("MaxAnimals")
        if typeof(MaxAnimals) == "number" then
            return MaxAnimals <= v7
        end
        return false
    end
    return false
end

local function holdingPlaceableTool() -- line 49 | captures: CollectionService, MergeConfig, LocalPlayer
    local Character = LocalPlayer.Character
    if Character then
        for v8, v9 in Character:GetChildren() do
            if v9:IsA("Tool") then
                if CollectionService:HasTag(v9, "AnimalTool") then
                    return "animal"
                end
                if CollectionService:HasTag(v9, MergeConfig.EggToolTag) then
                    return "egg"
                end
            end
        end
    end
    return nil
end

local function updateColor() -- line 67 | captures: v4, Color, v3, Get, holdingPlaceableTool
    if not (v4 and v4.Parent and Color) then
        return
    end
    local v10
    if holdingPlaceableTool() == "animal" then
        local v11 = Get()
        if v11 then
            local v12 = v11:GetAttribute("AnimalsPlaced") or 0
            local MaxAnimals = v11:GetAttribute("MaxAnimals")
            if typeof(MaxAnimals) == "number" then
                v10 = MaxAnimals <= v12
            else
                v10 = false
            end
        else
            v10 = false
        end
    else
        v10 = false
    end
    local v13 = v4
    if v10 then
        v13.Color = v3
    else
        v13.Color = Color
    end
end

local function applyFootprint(v14, v15) -- line 80
    local v16 = v15.Size.X - 0.15
    local Y = v14.Size.Y
    local v17 = v15.Size.Z - 0.15
    v14.Size = Vector3.new(v16, Y, v17)
    v14.CFrame = v15.CFrame * CFrame.new(0, -v15.Size.Y / 2 + v14.Size.Y / 2, 0)
end

local function refit() -- line 91 | captures: v4, Hitbox, applyFootprint
    local v18 = Hitbox()
    if v4 and v4.Parent and v18 then
        applyFootprint(v4, v18)
    end
end

local function ensureIndicator() -- line 99 | captures: v4, v5, Color, ReplicatedStorage, Workspace, Hitbox, applyFootprint
    if v4 and v4.Parent then
        return v4
    end
    local v19 = Hitbox()
    local BuildIndicator = ReplicatedStorage:FindFirstChild("BuildIndicator")
    if v19 and BuildIndicator and BuildIndicator:IsA("BasePart") then
        local v20 = BuildIndicator:Clone()
        v5 = v20.Transparency
        Color = v20.Color
        applyFootprint(v20, v19)
        v20.Transparency = 1
        v20.Anchored = true
        v20.CanCollide = false
        v20.CanQuery = false
        v20.CanTouch = false
        v20.Parent = Workspace
        v4 = v20
        return v20
    end
    return nil
end

local function show() -- line 123 | captures: v4, v5, Color, TweenService, v2, v3, Get, holdingPlaceableTool, ensureIndicator
    local v21 = ensureIndicator()
    if v21 then
        if v4 and v4.Parent and Color then
            if holdingPlaceableTool() == "animal" then
                local v22 = Get()
                if v22 then
                    local v23 = v22:GetAttribute("AnimalsPlaced") or 0
                    local MaxAnimals = v22:GetAttribute("MaxAnimals")
                    if typeof(MaxAnimals) == "number" and MaxAnimals <= v23 then
                        v4.Color = v3
                    else
                        v4.Color = Color
                    end
                else
                    v4.Color = Color
                end
            else
                v4.Color = Color
            end
        end
        TweenService:Create(v21, v2, { Transparency = v5 }):Play()
    end
end

local function hide() -- line 131 | captures: v4, TweenService, v2
    if v4 and v4.Parent then
        TweenService:Create(v4, v2, { Transparency = 1 }):Play()
    end
end

local function refresh() -- line 137 | captures: v4, TweenService, v2, holdingPlaceableTool, show
    if holdingPlaceableTool() == nil then
        if v4 and v4.Parent then
            TweenService:Create(v4, v2, { Transparency = 1 }):Play()
        end
    else
        show()
    end
end

function v1.Start() -- line 145 | captures: v4, TweenService, OwnBase, v2, LocalPlayer, Hitbox, holdingPlaceableTool, updateColor, applyFootprint, refit, show, refresh
    local v24 = {}

    local function unhookCharacter() -- line 149 | captures: v24
        for v25, v26 in v24 do
            v26:Disconnect()
        end
        table.clear(v24)
    end

    local function hookCharacter(v27) -- line 155 | captures: v24, v4, TweenService, v2, holdingPlaceableTool, show, refresh
        local function v28(v29, ...)
            table.insert(v29, ...)
        end

        local function v30(v31, ...)
            table.insert(v31, ...)
        end

        for v32, v33 in v24 do
            v33:Disconnect()
        end
        table.clear(v24)
        v28(v24, v27.ChildAdded:Connect(function(v34) -- line 157 | captures: refresh
            if v34:IsA("Tool") then
                task.defer(refresh)
            end
        end))
        v30(v24, v27.ChildRemoved:Connect(function(v35) -- line 162 | captures: refresh
            if v35:IsA("Tool") then
                task.defer(refresh)
            end
        end))
        if holdingPlaceableTool() == nil then
            if v4 and v4.Parent then
                TweenService:Create(v4, v2, { Transparency = 1 }):Play()
            end
        else
            show()
        end
    end

    if LocalPlayer.Character then
        hookCharacter(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(hookCharacter)
    LocalPlayer.CharacterRemoving:Connect(function() -- line 173 | captures: v24, v4, TweenService, v2
        for v36, v37 in v24 do
            v37:Disconnect()
        end
        table.clear(v24)
        if v4 and v4.Parent then
            TweenService:Create(v4, v2, { Transparency = 1 }):Play()
        end
    end)
    local v38 = {}
    local v39
    OwnBase.Observe(function(v40) -- line 186 | captures: v39, v38, v4, TweenService, v2, Hitbox, holdingPlaceableTool, updateColor, applyFootprint, refit, show
        local function v41(v42, ...)
            table.insert(v42, ...)
        end

        local function v43(v44, ...)
            table.insert(v44, ...)
        end

        local function v45(v46, ...)
            table.insert(v46, ...)
        end

        local function v47(v48, ...)
            table.insert(v48, ...)
        end

        v39 = v40
        for v49, v50 in v38 do
            v50:Disconnect()
        end
        table.clear(v38)
        v41(v38, v40:GetAttributeChangedSignal("AnimalsPlaced"):Connect(updateColor))
        v43(v38, v40:GetAttributeChangedSignal("MaxAnimals"):Connect(updateColor))
        local v51 = v40:WaitForChild("Hitbox", 10)
        if v39 ~= v40 then
            return
        end
        if v51 and v51:IsA("BasePart") then
            v45(v38, v51:GetPropertyChangedSignal("Size"):Connect(refit))
            v47(v38, v51:GetPropertyChangedSignal("CFrame"):Connect(refit))
        end
        local v52 = Hitbox()
        if v4 and v4.Parent and v52 then
            applyFootprint(v4, v52)
        end
        if holdingPlaceableTool() == nil then
            if v4 and v4.Parent then
                TweenService:Create(v4, v2, { Transparency = 1 }):Play()
            end
        else
            show()
        end
    end)
end

return v1
