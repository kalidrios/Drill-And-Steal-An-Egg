-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local MutationConfig = require(ReplicatedStorage.Shared.MutationConfig)
local RarityNameGradient = require(ReplicatedStorage.Shared.RarityNameGradient)
local WeightTag = require(ReplicatedStorage.Shared.WeightTag)
local OwnBase = require(script.Parent.Parent.Controllers.OwnBase)
local AnimalTileStyle = require(script.Parent.AnimalTileStyle)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2, ScrollingFrame, v3, v4
local v5 = {}
local v6 = {}
local v7 = {}

local function placedFolder() -- line 55 | captures: OwnBase
    local v8 = OwnBase.Get()
    return v8 and v8:FindFirstChild("PlacedAnimals")
end

local function ownsTool(v9) -- line 60 | captures: LocalPlayer
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    local Character = LocalPlayer.Character
    local v10 = Backpack == nil
    local v11
    if not v10 then
        v11 = v9:IsDescendantOf(Backpack)
    end
    if v10 or not v11 then
        if Character == nil then
            v11 = false
        else
            v11 = v9:IsDescendantOf(Character)
        end
    end
    return v11
end

function v1.Candidates(v12) -- line 66 | captures: CollectionService, OwnBase, LocalPlayer
    local v13 = {}
    for v14, v15 in CollectionService:GetTagged("AnimalTool") do
        if v15:IsA("Tool") and v15:GetAttribute("AnimalName") == v12 then
            local Backpack = LocalPlayer:FindFirstChild("Backpack")
            local Character = LocalPlayer.Character
            local v16
            if Backpack == nil then
                if Character == nil then
                    v16 = false
                else
                    v16 = v15:IsDescendantOf(Character)
                end
            else
                v16 = v15:IsDescendantOf(Backpack)
                if not v16 then
                    if Character == nil then
                        v16 = false
                    else
                        v16 = v15:IsDescendantOf(Character)
                    end
                end
            end
            if v16 then
                table.insert(v13, v15)
            end
        end
    end
    local v17 = OwnBase.Get()
    local v18 = v17 and v17:FindFirstChild("PlacedAnimals")
    if v18 then
        for v19, v20 in v18:GetChildren() do
            if v20:GetAttribute("AnimalName") == v12 then
                table.insert(v13, v20)
            end
        end
    end
    table.sort(v13, function(v21, v22) -- line 81
        local v23 = v21:GetAttribute("WeightKg") or 0
        return (v22:GetAttribute("WeightKg") or 0) < v23
    end)
    return v13
end

local function tileLabels(v24) -- line 94
    local v25, v26
    for v27, v28 in v24:GetChildren() do
        if v28:IsA("TextLabel") then
            if v28:GetAttribute("FuseRole") == "Weight" then
                v26 = v28
            elseif v28:GetAttribute("FuseRole") == "Name" then
                v25 = v28
            end
        end
    end
    return v25, v26
end

local function clearTiles() -- line 108 | captures: v5, v6
    for v29, v30 in v6 do
        v30:Disconnect()
    end
    table.clear(v6)
    for v31, v32 in v5 do
        v32:Destroy()
    end
    table.clear(v5)
end

local function buildTile(v33, v34, v35) -- line 119 | captures: ScrollingFrame, v3, EggRewards, MutationConfig, RarityNameGradient, WeightTag, AnimalTileStyle, v1, v5, v6, tileLabels
    local function v36(v37, ...)
        table.insert(v37, ...)
    end

    local v38 = v3:Clone()
    v38.Name = "Pet"
    v38.LayoutOrder = v34
    v38.Visible = true
    local AnimalName = v33:GetAttribute("AnimalName")
    local Variant = v33:GetAttribute("Variant")
    local Mutation = v33:GetAttribute("Mutation")
    local v39 = v33:GetAttribute("WeightKg") or 1
    local PetDecal = v38:FindFirstChild("PetDecal")
    local SetRender = AnimalTileStyle.SetRender
    if typeof(Variant) ~= "string" then
        Variant = nil
    end
    SetRender(PetDecal, AnimalName, Variant)
    local v40, v41 = tileLabels(v38)
    if v40 then
        local PrefixName = MutationConfig.PrefixName
        local v42 = if typeof(Mutation) == "string" then Mutation else nil
        v40.Text = PrefixName(v42, EggRewards.DisplayName(AnimalName))
    end
    if v41 then
        v41.Text = ("(%* KG)"):format((WeightTag.FormatKg(v39)))
        RarityNameGradient.Apply(v41, { Base = WeightTag.Color(v39) })
    end
    if v38:IsA("ImageButton") and v38.Image == "rbxasset://textures/ui/GuiImagePlaceholder.png" then
        v38.Image = ""
    end
    AnimalTileStyle.PaintBackground(v38, EggRewards.RarityOf(AnimalName))
    AnimalTileStyle.Prepare(v38, PetDecal)
    local v43 = false
    local Activated = v38.Activated
    v36(v6, Activated:Connect(function() -- line 151 | captures: v43, v33, v35, v1
        if v43 then
            return
        end
        v43 = true
        v1.Close()
        v35(v33)
    end))
    v38.Parent = ScrollingFrame
    table.insert(v5, v38)
end

function v1.IsOpen() -- line 167 | captures: v2
    if v2 == nil then
        return false
    end
    return v2.Visible
end

function v1.Close() -- line 171 | captures: v2, clearTiles
    clearTiles()
    if v2 then
        v2.Visible = false
    end
end

function v1.Open(v44, v45) -- line 178 | captures: v2, ScrollingFrame, v3, v4, EggRewards, v1, clearTiles, buildTile
    if v2 and ScrollingFrame and v3 then
        clearTiles()
        if v4 then
            v4.Text = ("Select a %*"):format((EggRewards.DisplayName(v44)))
        end
    else
        return
    end
    for v46, v47 in v1.Candidates(v44) do
        buildTile(v47, v46, v45)
    end
    ScrollingFrame.CanvasPosition = Vector2.zero
    v2.Visible = true
end

function v1.Bind(v48) -- line 193 | captures: v2, ScrollingFrame, v3, v4, v1, v7, clearTiles
    local function v49(v50, ...)
        table.insert(v50, ...)
    end

    for v51, v52 in v7 do
        v52:Disconnect()
    end
    table.clear(v7)
    clearTiles()
    v2 = nil
    ScrollingFrame = nil
    v3 = nil
    v4 = nil
    if v48:IsA("GuiObject") then
        local ScrollingFrame_2 = v48:FindFirstChild("ScrollingFrame")
        if not (ScrollingFrame_2 and ScrollingFrame_2:IsA("ScrollingFrame")) then
            warn("[FuseMachinePicker] SciFiTradeInInventory.ScrollingFrame missing")
        else
            local v53
            for v54, v55 in ScrollingFrame_2:GetChildren() do
                if v55.Name == "Pet" and v55:IsA("GuiButton") then
                    if v53 then
                        v55:Destroy()
                    else
                        v53 = v55
                    end
                end
            end
            if v53 then
                for v56, v57 in v53:GetChildren() do
                    if v57:IsA("TextLabel") then
                        local v58 = if string.find(string.upper(v57.Text), "KG", 1, true) then "Weight" else "Name"
                        v57:SetAttribute("FuseRole", v58)
                    end
                end
                v53.Visible = false
                v2 = v48
                ScrollingFrame = ScrollingFrame_2
                v3 = v53
                local Header = v48:FindFirstChild("Header")
                local v59 = Header and Header:FindFirstChild("Title")
                if not (v59 and v59:IsA("TextLabel")) then
                    v59 = nil
                end
                v4 = v59
                v48.Visible = false
                for v60, v61 in v48:GetDescendants() do
                    if v61.Name == "Close" and v61:IsA("GuiButton") then
                        v49(v7, v61.Activated:Connect(v1.Close))
                    end
                end
            else
                warn("[FuseMachinePicker] no Pet tile template in SciFiTradeInInventory.ScrollingFrame")
            end
        end
    end
end

return v1
