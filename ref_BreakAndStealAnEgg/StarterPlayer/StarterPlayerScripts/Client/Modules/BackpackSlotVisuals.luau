-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalEggsConfig = require(ReplicatedStorage.Shared.AnimalEggsConfig)
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local AnimalViewport = require(ReplicatedStorage.Shared.AnimalViewport)
local BackpackSellConfig = require(ReplicatedStorage.Shared.BackpackSellConfig)
local BackpackUiConfig = require(ReplicatedStorage.Shared.BackpackUiConfig)
local BackpackHover = require(script.Parent.BackpackHover)
local BatConfig = require(ReplicatedStorage.Shared.BatConfig)
local BatToolQuery = require(ReplicatedStorage.Shared.BatToolQuery)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local FloatingIconConfig = require(ReplicatedStorage.Shared.FloatingIconConfig)
local FloatingIconFX = require(script.Parent.FloatingIconFX)
local MergeConfig = require(ReplicatedStorage.Shared.MergeConfig)
local PickaxeConfig = require(ReplicatedStorage.Shared.PickaxeConfig)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local ViewportLighting = require(ReplicatedStorage.Shared.ViewportLighting)
local WeightTag = require(ReplicatedStorage.Shared.WeightTag)
local v1 = {}

local function findClass(v2, v3, v4) -- line 88
    local v5 = v2 and v2:FindFirstChild(v3)
    if v5 and v5:IsA(v4) then
        return v5
    end
    return nil
end

local function Collect(v6, v7) -- line 97
    local InfoList = v7:FindFirstChild("InfoList")
    local v8 = {
        SellShrunk = false,
        Equipped = nil,
        SwapMark = nil,
        ViewportTool = nil,
        ViewportModel = nil,
        Root = v6,
        Button = v7
    }
    local v9 = v7 and v7:FindFirstChild("ImageDisplay")
    if not (v9 and v9:IsA("ImageLabel")) then
        v9 = nil
    end
    v8.Image = v9
    local v10 = v7 and v7:FindFirstChild("ViewportDisplay")
    if not (v10 and v10:IsA("ViewportFrame")) then
        v10 = nil
    end
    v8.Viewport = v10
    local v11 = InfoList and InfoList:FindFirstChild("Name")
    if not (v11 and v11:IsA("TextLabel")) then
        v11 = nil
    end
    v8.Name = v11
    local v12 = InfoList and InfoList:FindFirstChild("Weight")
    if not (v12 and v12:IsA("TextLabel")) then
        v12 = nil
    end
    v8.Weight = v12
    local v13 = v7 and v7:FindFirstChild("Number")
    if not (v13 and v13:IsA("TextLabel")) then
        v13 = nil
    end
    v8.Number = v13
    local v14 = v6 and v6:FindFirstChild("SellSelected")
    if not (v14 and v14:IsA("GuiObject")) then
        v14 = nil
    end
    v8.SellSelected = v14
    local v15 = v6 and v6:FindFirstChild("X")
    if not (v15 and v15:IsA("GuiObject")) then
        v15 = nil
    end
    v8.SellX = v15
    v8.Authored = {}
    for v16, v17 in {
            v8.Name,
            v8.Weight
        } do
        if v17 then
            local v18 = {}
            for v19, v20 in v17:GetChildren() do
                if v20:IsA("UIStroke") then
                    v18[v20] = v20.Color
                end
            end
            v8.Authored[v17] = {
                Text = v17.TextColor3,
                Strokes = v18
            }
        end
    end
    return v8
end

v1.Collect = Collect

function v1.AttachImageFX(v21) -- line 134 | captures: FloatingIconConfig, FloatingIconFX
    local Image = v21.Image
    if Image and Image:FindFirstChild("Inner") then
        FloatingIconFX.Attach(Image, FloatingIconConfig.Styles.AnimalTile, v21.Button)
    end
end

function v1.Pulse(v22) -- line 143 | captures: FloatingIconFX
    if v22.Image then
        FloatingIconFX.Pulse(v22.Image)
    end
end

function v1.ResetCopy(v23, v24) -- line 151 | captures: FloatingIconFX
    local Image = v23.Image
    if Image then
        local v25 = v24:FindFirstChild(Image.Name)
        if v25 and v25:IsA("GuiObject") then
            FloatingIconFX.ResetCopy(Image, v25)
        end
    end
end

local function AdoptSellOverlay(v26, v27) -- line 161
    if not v26.SellSelected then
        local v28 = v27 and v27:FindFirstChild("SellSelected")
        if not (v28 and v28:IsA("GuiObject")) then
            v28 = nil
        end
        if v28 then
            local v29 = v28:Clone()
            v29.Visible = false
            v29.Parent = v26.Button
            v26.SellSelected = v29
        end
    end
    if v26.SellX then
        return
    end
    local v30 = v27 and v27:FindFirstChild("X")
    if not (v30 and v30:IsA("GuiObject")) then
        v30 = nil
    end
    if not v30 then
        return
    end
    local v31 = v30:Clone()
    v31.Visible = false
    v31.Parent = v26.Button
    v26.SellX = v31
end

v1.AdoptSellOverlay = AdoptSellOverlay

function v1.AdoptStrokes(v32, v33, v34) -- line 190 | captures: BackpackUiConfig
    local v35 = v32.Button:FindFirstChild(BackpackUiConfig.SelectedStrokeName)
    if not (v35 and v35:IsA("UIStroke")) then
        v35 = nil
    end
    local v36 = v35 or v34 or v33
    if not v36 then
        return
    end
    if not v35 then
        if v34 then
            v35 = v34:Clone()
            v35.Name = BackpackUiConfig.SelectedStrokeName
        else
            v35 = v36:Clone()
            v35.Name = "Equipped"
            v35.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        end
        v35.Parent = v32.Button
    end
    v35.Enabled = false
    v32.Equipped = v35
    local v37 = v36:Clone()
    v37.Name = "SwapMark"
    v37.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    v37.Thickness = v36.Thickness * BackpackUiConfig.SwapMarkThicknessMult
    v37.Enabled = false
    v37.Parent = v32.Button
    v32.SwapMark = v37
end

local function SetEquipped(v38, v39) -- line 224
    if v38.Equipped then
        v38.Equipped.Enabled = v39
    end
end

v1.SetEquipped = SetEquipped

local function SetSwapMark(v40, v41) -- line 230
    if v40.SwapMark then
        v40.SwapMark.Enabled = v41
    end
end

v1.SetSwapMark = SetSwapMark

function v1.SetSellSelected(v42, v43) -- line 236 | captures: BackpackSellConfig, BackpackHover
    if v42.SellSelected then
        v42.SellSelected.Visible = v43
    end
    if v42.SellX then
        v42.SellX.Visible = v43
    end
    if v42.SellShrunk == v43 then
        return
    end
    v42.SellShrunk = v43
    local v44 = if v43 then BackpackSellConfig.SelectedScale else 1
    BackpackHover.SetShrink(v42.Button, v44, BackpackSellConfig.SelectedTweenInfo)
end

function v1.IsEgg(v45) -- line 264 | captures: CollectionService, MergeConfig
    return CollectionService:HasTag(v45, MergeConfig.EggToolTag)
end

function v1.IsPet(v46) -- line 268 | captures: CollectionService
    return CollectionService:HasTag(v46, "AnimalTool")
end

function v1.IsLocked(v47) -- line 275 | captures: BatToolQuery, PickaxeConfig, v1
    if v1.IsPet(v47) or v1.IsEgg(v47) then
        return false
    end
    if v47.Name == PickaxeConfig.ToolName then
        return true
    end
    return (BatToolQuery.IsBatWeapon(v47))
end

function v1.DisplayName(v48) -- line 284 | captures: BatConfig, BatToolQuery
    local PickaxeName = v48:GetAttribute("PickaxeName")
    if typeof(PickaxeName) ~= "string" or PickaxeName == "" then
        if BatToolQuery.IsBatWeapon(v48) then
            local v49 = v48:GetAttribute(BatConfig.NameAttribute)
            if typeof(v49) == "string" and v49 ~= "" then
                return v49
            end
        end
        return v48.Name
    end
    return PickaxeName
end

local function searchText(v50) -- line 300 | captures: EggRewards, v1
    local v51 = string.gsub(v50.ToolTip, "<[^>]*>", "")
    local Rarity = v50:GetAttribute("Rarity")
    if typeof(Rarity) ~= "string" then
        local AnimalName = v50:GetAttribute("AnimalName")
        if typeof(AnimalName) == "string" then
            Rarity = EggRewards.RarityOf(AnimalName)
        else
            Rarity = nil
        end
    end
    local Mutation = v50:GetAttribute("Mutation")
    local lower = string.lower
    local concat = table.concat
    local v52 = {}
    local v53 = v1.DisplayName(v50)
    if typeof(Rarity) ~= "string" then
        Rarity = ""
    end
    if typeof(Mutation) ~= "string" then
        Mutation = ""
    end
    v52[1] = v53
    v52[2] = v51
    v52[3] = Rarity
    v52[4] = Mutation
    return lower(concat(v52, " "))
end

function v1.SearchHits(v54, v55) -- line 317 | captures: searchText
    local v56 = searchText(v54)
    local v57 = 0
    for v58, v59 in v55 do
        if string.find(v56, v59, 1, true) then
            v57 += 1
        end
    end
    return v57
end

local function isRenderJunk(v60) -- line 333
    local LuaSourceContainer = v60:IsA("LuaSourceContainer")
    LuaSourceContainer = LuaSourceContainer or v60:IsA("Sound") or v60:IsA("ParticleEmitter") or v60:IsA("Trail") or v60:IsA("Beam") or v60:IsA("Light") or v60:IsA("Fire") or v60:IsA("Smoke") or v60:IsA("Sparkles")
    return LuaSourceContainer
end

local function buildToolModel(v61) -- line 347 | captures: AnimalEggsConfig, AnimalViewport, isRenderJunk
    local Model = Instance.new("Model")
    Model.Name = "SlotModel"
    for v62, v63 in v61:GetChildren() do
        local BasePart = v63:IsA("BasePart")
        local v64, Model_2
        if BasePart then
            v64 = v63.Transparency >= 1
        else
            Model_2 = v63:IsA("Model")
        end
        if BasePart and not v64 or not BasePart and Model_2 or not BasePart and v63:IsA("Folder") then
            local v65, v66 = pcall(v63.Clone, v63)
            if v65 and v66 then
                v66.Parent = Model
            end
        end
    end
    for v67, v68 in Model:GetDescendants() do
        if isRenderJunk(v68) then
            v68:Destroy()
        end
    end
    if Model:FindFirstChildWhichIsA("BasePart", true) then
        local v69 = Model:FindFirstChild(AnimalEggsConfig.FrameAttachmentName, true)
        if v69 and v69:IsA("Attachment") then
            Model.WorldPivot = v69.WorldCFrame
        end
        AnimalViewport.PrepareModel(Model)
        return Model
    end
    Model:Destroy()
    return nil
end

local function clearViewport(v70) -- line 382
    if v70.ViewportModel then
        v70.ViewportModel:Destroy()
    end
    v70.ViewportModel = nil
    v70.ViewportTool = nil
    if v70.Viewport then
        v70.Viewport.Visible = false
    end
end

local function frameCamera(v71, v72) -- line 393 | captures: BackpackUiConfig
    local SlotCamera = v71:FindFirstChild("SlotCamera")
    if not (SlotCamera and SlotCamera:IsA("Camera")) then
        SlotCamera = Instance.new("Camera")
        SlotCamera.Name = "SlotCamera"
        SlotCamera.Parent = v71
    end
    local v73, v74 = v72:GetBoundingBox()
    local ViewportFov = BackpackUiConfig.ViewportFov
    local v75 = v74.Magnitude / 2
    local v76 = ViewportFov / 2
    local v77 = math.rad(v76)
    local v78 = v75 / math.sin(v77)
    local v79 = v73:VectorToWorldSpace(BackpackUiConfig.ViewportDirection.Unit)
    SlotCamera.FieldOfView = ViewportFov
    SlotCamera.CFrame = CFrame.lookAt(v73.Position + v79 * v78, v73.Position)
    v71.CurrentCamera = SlotCamera
end

local function renderViewport(v80, v81) -- line 410 | captures: ViewportLighting, buildToolModel, frameCamera
    local Viewport = v80.Viewport
    if Viewport then
        if v80.ViewportTool == v81 and v80.ViewportModel and v80.ViewportModel.Parent == Viewport then
            Viewport.Visible = true
            return true
        end
        if v80.ViewportModel then
            v80.ViewportModel:Destroy()
        end
        v80.ViewportModel = nil
        v80.ViewportTool = nil
        if v80.Viewport then
            v80.Viewport.Visible = false
        end
        local v82 = buildToolModel(v81)
        if v82 then
            v82.Parent = Viewport
            frameCamera(Viewport, v82)
            ViewportLighting.Apply(Viewport)
            Viewport.Visible = true
            v80.ViewportTool = v81
            v80.ViewportModel = v82
            return true
        end
    end
    return false
end

function v1.ImageFor(v83) -- line 440 | captures: AnimalRenders, v1
    local TextureId = v83.TextureId
    if TextureId == "" and v1.IsEgg(v83) then
        local AnimalName = v83:GetAttribute("AnimalName")
        local GetEggImage = AnimalRenders.GetEggImage
        if typeof(AnimalName) ~= "string" then
            AnimalName = nil
        end
        return GetEggImage(AnimalName)
    end
    local AnimalName, Variant, GetImage, v84, v85
    if TextureId == "" and v1.IsPet(v83) then
        if v1.IsEgg(v83) then
            v84 = TextureId
            v85 = true
        else
            AnimalName = v83:GetAttribute("AnimalName")
            Variant = v83:GetAttribute("Variant")
            GetImage = AnimalRenders.GetImage
            if typeof(AnimalName) ~= "string" then
                AnimalName = nil
            end
            v85 = false
        end
    else
        v84 = TextureId
        v85 = true
    end
    if not v85 then
        if typeof(Variant) ~= "string" then
            Variant = nil
        end
        v84 = GetImage(AnimalName, Variant)
    end
    return v84
end

local function renderImage(v86, v87) -- line 457 | captures: v1, renderViewport
    local Image = v86.Image
    local v88 = v1.ImageFor(v87)
    if v88 == "" or not Image then
        if Image then
            Image.Image = ""
            Image.Visible = false
        end
        renderViewport(v86, v87)
    else
        Image.ScaleType = Enum.ScaleType.Fit
        Image.Image = v88
        for v89, v90 in Image:GetDescendants() do
            if v90:IsA("ImageLabel") then
                v90.ScaleType = Enum.ScaleType.Fit
                v90.Image = v88
            end
        end
        Image.Visible = true
        if v86.ViewportModel then
            v86.ViewportModel:Destroy()
        end
        v86.ViewportModel = nil
        v86.ViewportTool = nil
        if v86.Viewport then
            v86.Viewport.Visible = false
        end
    end
end

local function rarityOf(v91) -- line 486 | captures: EggRewards, v1
    if v1.IsPet(v91) or v1.IsEgg(v91) then
        local Rarity = v91:GetAttribute("Rarity")
        if typeof(Rarity) ~= "string" then
            local AnimalName = v91:GetAttribute("AnimalName")
            if typeof(AnimalName) == "string" then
                Rarity = EggRewards.RarityOf(AnimalName)
            else
                Rarity = nil
            end
        end
        if typeof(Rarity) == "string" then
            return Rarity
        end
    end
    return nil
end

v1.RarityOf = rarityOf

local function unpaint(v92, v93) -- line 502 | captures: RarityGradientFX
    for v94, v95 in v93:GetChildren() do
        if v95:IsA("UIGradient") then
            RarityGradientFX.Detach(v95)
            v95:Destroy()
        end
    end
    local v96 = v92.Authored[v93]
    if v96 then
        v93.TextColor3 = v96.Text
        for v97, v98 in v96.Strokes do
            v97.Color = v98
        end
    end
end

local function paintLabels(v99, v100) -- line 521 | captures: RarityGradientFX, rarityOf, unpaint
    local v101
    if v100 then
        v101 = rarityOf(v100)
    end
    for v102, v103 in {
            v99.Name,
            v99.Weight
        } do
        if v103 then
            unpaint(v99, v103)
            if v101 then
                RarityGradientFX.ApplyToLabel(v103, v101)
            end
        end
    end
end

function v1.Render(v104, v105) -- line 534 | captures: BackpackUiConfig, WeightTag, v1, renderImage, unpaint, paintLabels
    if v105 then
        local WeightKg = v105:GetAttribute("WeightKg")
        local v106 = typeof(WeightKg) == "number"
        if v104.Name then
            local v107 = v1.DisplayName(v105)
            if not v104.Weight and v106 then
                v107 = string.format(BackpackUiConfig.NameWeightFormat, v107, WeightTag.FormatKg(WeightKg))
            end
            v104.Name.Text = v107
        end
        local Weight = v104.Weight
        if Weight then
            if v106 then
                Weight.Text = string.format(BackpackUiConfig.WeightFormat, WeightTag.FormatKg(WeightKg))
                Weight.Visible = true
            else
                Weight.Text = ""
                Weight.Visible = false
            end
        end
        paintLabels(v104, v105)
        renderImage(v104, v105)
    else
        if v104.Image then
            v104.Image.Image = ""
            v104.Image.Visible = false
        end
        if v104.ViewportModel then
            v104.ViewportModel:Destroy()
        end
        v104.ViewportModel = nil
        v104.ViewportTool = nil
        if v104.Viewport then
            v104.Viewport.Visible = false
        end
        if v104.Name then
            v104.Name.Text = ""
        end
        if v104.Weight then
            v104.Weight.Text = ""
            v104.Weight.Visible = false
        end
        for v108, v109 in {
                v104.Name,
                v104.Weight
            } do
            if v109 then
                unpaint(v104, v109)
            end
        end
    end
end

return v1
