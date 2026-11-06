-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local AnimationCache = require(script.Parent.AnimationCache)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local GuardSfxConfig = require(ReplicatedStorage.Shared.GuardSfxConfig)
local BackpackPreload = require(script.Parent.Parent.Modules.BackpackPreload)
local HatchVFX = require(ReplicatedStorage.Shared.HatchVFX)
local NotificationConfig = require(ReplicatedStorage.Shared.NotificationConfig)
local v1 = {}
local v2 = {
    {
        Name = "VFX",
        Parent = ReplicatedStorage
    },
    {
        Parent = ReplicatedStorage,
        Name = HatchVFX.FolderName
    },
    {
        NoWait = true,
        Parent = Workspace,
        Name = HatchVFX.FolderName
    },
    {
        Name = "SFX",
        Parent = SoundService
    },
    {
        Name = "UiSounds",
        Parent = SoundService
    },
    {
        Parent = SoundService,
        Name = NotificationConfig.SoundFolderName
    }
}

local function preloadUi() -- line 74 | captures: ContentProvider, Players, StarterGui
    local v3 = { StarterGui }
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if PlayerGui then
        table.insert(v3, PlayerGui)
    end
    pcall(ContentProvider.PreloadAsync, ContentProvider, v3)
end

local function preloadEffects() -- line 83 | captures: ContentProvider, v2
    for v4, v5 in v2 do
        local v6 = v5.Parent:FindFirstChild(v5.Name)
        if not (v6 or v5.NoWait) then
            v6 = v5.Parent:WaitForChild(v5.Name, 5)
        end
        if v6 then
            pcall(ContentProvider.PreloadAsync, ContentProvider, { v6 })
            task.wait(0.1)
        end
    end
end

local function preloadGuardRoars() -- line 107 | captures: ContentProvider, GuardSfxConfig
    local Folder = Instance.new("Folder")
    local v7 = {}
    for v8, v9 in GuardSfxConfig.AllAssetIds() do
        local Sound = Instance.new("Sound")
        Sound.SoundId = v9
        Sound.Parent = Folder
        table.insert(v7, Sound)
    end
    if #v7 > 0 then
        pcall(ContentProvider.PreloadAsync, ContentProvider, v7)
    end
    Folder:Destroy()
end

local v10 = {}
local v11 = {}

local function waitForPool() -- line 138 | captures: ReplicatedStorage, EggRewards
    local v12 = ReplicatedStorage:WaitForChild(EggRewards.PoolFolderName, 30)
    if v12 then
        v12:WaitForChild(EggRewards.DefaultPoolVariant, 30)
        return true
    end
    return false
end

local function orderedAnimalModels(v13) -- line 158 | captures: EggRewards, v10
    local v14 = {}
    for v15, v16 in EggRewards.Pool do
        if v13(v16.Zone) then
            local v17 = EggRewards.FindAnimalTemplate(v16.Name)
            if v17 and not v10[v17] then
                v10[v17] = true
                table.insert(v14, v17)
            end
        end
    end
    return v14
end

local function warmModelBatches(v18) -- line 175 | captures: ContentProvider
    local v19 = {}
    for v20, v21 in v18 do
        table.insert(v19, v21)
        if #v19 >= 3 or v20 == #v18 then
            pcall(ContentProvider.PreloadAsync, ContentProvider, v19)
            table.clear(v19)
            task.wait(0.1)
        end
    end
end

function v1.WarmZone(v22) -- line 189 | captures: ReplicatedStorage, EggRewards, v11, orderedAnimalModels, warmModelBatches
    if typeof(v22) ~= "number" or v11[v22] then
        return
    end
    v11[v22] = true
    task.spawn(function() -- line 194 | captures: v22, ReplicatedStorage, EggRewards, orderedAnimalModels, warmModelBatches
        local v23 = ReplicatedStorage:WaitForChild(EggRewards.PoolFolderName, 30)
        if v23 then
            v23:WaitForChild(EggRewards.DefaultPoolVariant, 30)
            warmModelBatches((orderedAnimalModels(function(v24) -- line 198 | captures: v22
                return v24 == v22
            end)))
        end
    end)
end

function v1.Start() -- line 204 | captures: ContentProvider, Players, ReplicatedStorage, StarterGui, AnimationCache, EggRewards, BackpackPreload, preloadEffects, preloadGuardRoars, v11, orderedAnimalModels, warmModelBatches
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    task.wait(0.5)
    local v25 = { StarterGui }
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if PlayerGui then
        table.insert(v25, PlayerGui)
    end
    pcall(ContentProvider.PreloadAsync, ContentProvider, v25)
    task.spawn(BackpackPreload.Warm)
    AnimationCache.WarmAssets()
    preloadEffects()
    preloadGuardRoars()
    task.wait(3)
    local v26 = ReplicatedStorage:WaitForChild(EggRewards.PoolFolderName, 30)
    if not v26 then
        return
    end
    v26:WaitForChild(EggRewards.DefaultPoolVariant, 30)
    v11[1] = true
    v11[2] = true
    warmModelBatches((orderedAnimalModels(function(v27) -- line 234
        if v27 == nil then
            return true
        end
        return v27 <= 2
    end)))
end

return v1
