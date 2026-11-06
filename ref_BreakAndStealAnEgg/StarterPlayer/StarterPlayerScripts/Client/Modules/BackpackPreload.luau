-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local BatConfig = require(ReplicatedStorage.Shared.BatConfig)
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local BackpackSlotVisuals = require(script.Parent.BackpackSlotVisuals)
local v1 = {}
local v2 = {}

local function add(v3, v4) -- line 38 | captures: v2
    if v4 and v4 ~= "" and not v2[v4] then
        v2[v4] = true
        table.insert(v3, v4)
    end
end

local function ownedToolImages(v5) -- line 45 | captures: Players, BackpackSlotVisuals, v2
    local LocalPlayer = Players.LocalPlayer
    for v6, v7 in {
            LocalPlayer.Character,
            LocalPlayer:FindFirstChildOfClass("Backpack")
        } do
        if v7 then
            for v8, v9 in v7:GetChildren() do
                if v9:IsA("Tool") then
                    local v10 = BackpackSlotVisuals.ImageFor(v9)
                    if v10 and v10 ~= "" and not v2[v10] then
                        v2[v10] = true
                        table.insert(v5, v10)
                    end
                end
            end
        end
    end
end

local function templateToolImages(v11) -- line 58 | captures: ReplicatedStorage, BatConfig, PickaxeConfig, v2
    for v12, v13 in {
            PickaxeConfig.TemplatesFolderName,
            BatConfig.TemplatesFolderName
        } do
        local v14 = ReplicatedStorage:FindFirstChild(v13)
        if v14 then
            for v15, v16 in v14:GetDescendants() do
                if v16:IsA("Tool") then
                    local TextureId = v16.TextureId
                    if TextureId and TextureId ~= "" and not v2[TextureId] then
                        v2[TextureId] = true
                        table.insert(v11, TextureId)
                    end
                end
            end
        end
    end
end

local function warm(v17) -- line 71 | captures: ContentProvider
    local v18 = {}
    for v19, v20 in v17 do
        table.insert(v18, v20)
        if #v18 >= 20 or v19 == #v17 then
            pcall(ContentProvider.PreloadAsync, ContentProvider, v18)
            table.clear(v18)
            task.wait(0.05)
        end
    end
end

function v1.Warm() -- line 85 | captures: AnimalRenders, v2, ownedToolImages, templateToolImages, warm
    local v21 = {}
    ownedToolImages(v21)
    templateToolImages(v21)
    for v22, v23 in AnimalRenders.AllImages() do
        if v23 and v23 ~= "" and not v2[v23] then
            v2[v23] = true
            table.insert(v21, v23)
        end
    end
    warm(v21)
end

return v1
