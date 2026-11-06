-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AnimalEggShape = require(script.Parent.AnimalEggShape)
local MergeConfig = require(script.Parent.MergeConfig)
local v1 = {
    FolderName = "AnimalisticEggs",
    BodyPartName = "Egg",
    FrameAttachmentName = "EggFrame",
    Front = Vector3.new(-1, 0, 0),
    ModelShellName = "Ninja egg",
    ModelFront = Vector3.new(1, 0, 0),
    FolderContainers = { ReplicatedStorage, Workspace },
    FrontOverrides = {},
    ModelShellOverrides = {
        ["Jax Egg"] = "Ninja egg.001",
        ["John Egg"] = "Toad.001",
        ["Mushroom Egg"] = "Toad.001",
        ["Scarecrow Egg"] = "Toad.001",
        ["Mimic Egg"] = "Cube.001",
        ["Gargoyle Egg"] = "Toad.002",
        ["BlackWidow Egg"] = "Toad.002",
        ["Rock Crab Egg"] = "Toad.002",
        ["VolcanicTurtle Egg"] = "Toad.002",
        ["WizardOwl Egg"] = "Toad.002"
    },
    WholeBodyEggs = {
        GoldfishEgg = true,
        FangtoothFishEgg = true,
        GoblinSharkEgg = true,
        SharkEgg = true,
        SwordfishEgg = true,
        AnglerfishEgg = true,
        BlobfishEgg = true,
        MEGALODONEgg = true,
        WhaleEgg = true,
        LeafySeaDragonEgg = true
    },
    GroupEggs = {
        {
            Front = Vector3.new(0, 0, 1),
            Path = { "EggHell", "Black" },
            ShellNames = { "Egg", "Egg Template" },
            Eggs = {
                HellCroc = "BoarEgg",
                HellAnky = "BoarEgg",
                HellTrike = "ScorpionEgg",
                HellMegalodon = "HoundEgg",
                HellDinoRex = "HoundEgg",
                HellTRex = "GolemEgg",
                HellDragon = "DragonEgg",
                HellHydra = "CerberusEgg"
            }
        },
        {
            Front = Vector3.new(0, 0, 1),
            Path = { "EggHell", "White" },
            ShellNames = { "Egg", "Egg Template" },
            Eggs = {
                AngelCroc = "BoarEgg",
                AngelAnky = "BoarEgg",
                AngelTrike = "ScorpionEgg",
                AngelMegalodon = "HoundEgg",
                AngelTRex = "GolemEgg",
                AngelDragon = "DragonEgg",
                AngelHydra = "CerberusEgg"
            }
        },
        {
            Front = Vector3.new(0, 0, 1),
            Path = { "AnimalisticEggs" },
            ShellNames = { "Egg" },
            Eggs = {
                Bug = "Bug Egg",
                CrystalLizard = "CrystalLizard Egg",
                CrystalBeast = "CrystalBeast Egg",
                CrystalRaptor = "CrystalRaptor Egg",
                CrystalDragon = "CrystalDragon Egg",
                Mantis = "Mantis Egg",
                AlienJellyfish = "AlienJellyfish Egg",
                CrystalScorpion = "CrystalScorpion Egg",
                Behemoth = "Behemoth Egg",
                CrystalWolf = "CrystalWolf Egg",
                CelestialBeast = "CelestialBeast Egg",
                CelestialSpirit = "CelestialSpirit Egg"
            }
        },
        {
            Front = Vector3.new(0, 0, -1),
            Straighten = true,
            HoldInFront = true,
            Path = { "AnimalisticEggs" },
            ShellNames = { "Egg Template", "Egg" },
            Eggs = {
                CelestialLamb = "Celestial Cow Egg",
                CelestialSpiritFox = "Celestial Fox Egg",
                CelestialFrog = "Celestial Frog Egg",
                CelestialAxolotl = "Axolotle Egg",
                CelestialGorilla = "Celestial Gorilla Egg"
            }
        }
    },
    Overrides = {
        CHIREMA = "CHIMERAEgg",
        MantisShrimp = "MantiShrimpEgg5",
        SABER_TOOTHED_TIGER = "SaborToothTigerEgg",
        Mamoth = "MammothEgg",
        Giraffee = "GiraffeEgg",
        Dullahan = "DullahanHorseEgg",
        trumpet = "TrumpetFish Egg",
        ["Moorish idol"] = "Moorish Egg",
        ["John The Toad"] = "John Egg",
        ["Volcano Turtle"] = "VolcanicTurtle Egg"
    }
}

local function normalize(v2) -- line 236
    return (string.lower(v2):gsub("[%s%-_]", ""))
end

function v1.GetFolder() -- line 240 | captures: v1
    for v3, v4 in v1.FolderContainers do
        local v5 = v4:FindFirstChild(v1.FolderName)
        if v5 then
            return v5
        end
    end
    return nil
end

function v1.GetPlaceholder() -- line 251 | captures: ReplicatedStorage, MergeConfig
    local v6 = ReplicatedStorage:FindFirstChild(MergeConfig.EggTemplateFolderName)
    local v7 = v6 and v6:FindFirstChild(MergeConfig.EggTemplateName)
    if v7 and v7:IsA("Model") then
        return v7
    end
    return nil
end

local function isEggSource(v8) -- line 261
    return v8:IsA("BasePart") or v8:IsA("Model") and v8:FindFirstChildWhichIsA("BasePart", true) ~= nil
end

local function findPath(v9) -- line 268 | captures: v1
    for v10, v11 in v1.FolderContainers do
        local v12 = v11
        for v13, v14 in v9 do
            v12 = v12 and v12:FindFirstChild(v14)
        end
        if v12 then
            return v12
        end
    end
    return nil
end

local function findGroupEgg(v15) -- line 282 | captures: v1, findPath
    for v16, v17 in v1.GroupEggs do
        local v18 = v17.Eggs[v15]
        if v18 then
            local v19 = findPath(v17.Path)
            local v20 = v19 and v19:FindFirstChild(v18)
            if v20 and (v20:IsA("BasePart") or v20:IsA("Model") and v20:FindFirstChildWhichIsA("BasePart", true) ~= nil) then
                return v20, v17
            end
            return nil, nil
        end
    end
    return nil, nil
end

function v1.FindOwnEgg(v21) -- line 298 | captures: v1, findGroupEgg
    local v22 = findGroupEgg(v21)
    if v22 then
        return v22
    end
    local v23 = v1.GetFolder()
    if v23 then
        local v24 = v1.Overrides[v21]
        if v24 then
            local v25 = v23:FindFirstChild(v24)
            if v25 and (v25:IsA("BasePart") or v25:IsA("Model") and v25:FindFirstChildWhichIsA("BasePart", true) ~= nil) then
                return v25
            end
        else
            local v26 = v21 .. "Egg"
            local v27 = string.lower(v26):gsub("[%s%-_]", "")
            for v28, v29 in v23:GetChildren() do
                if v29:IsA("BasePart") or v29:IsA("Model") and v29:FindFirstChildWhichIsA("BasePart", true) ~= nil then
                    local Name = v29.Name
                    if string.lower(Name):gsub("[%s%-_]", "") == v27 then
                        return v29
                    end
                end
            end
        end
    end
    return nil
end

function v1.UsesPlaceholder(v30) -- line 325 | captures: v1
    return v1.FindOwnEgg(v30) == nil
end

local function findShell(v31, v32) -- line 331
    local function biggest(v33) -- line 332 | captures: v31, v32
        local v34
        local v35 = -1
        for v36, v37 in v31:GetDescendants() do
            if v37:IsA("BasePart") then
                if v33 then
                    if table.find(v32, v37.Name) then
                        local v38 = v37.Size.X * v37.Size.Y * v37.Size.Z
                        if v35 < v38 then
                            v34 = v37
                            v35 = v38
                        end
                    end
                else
                    local v39 = v37.Size.X * v37.Size.Y * v37.Size.Z
                    if v35 < v39 then
                        v34 = v37
                        v35 = v39
                    end
                end
            end
        end
        return v34
    end

    return biggest(true) or biggest(false)
end

local function addFrame(v40, v41, v42, v43) -- line 350 | captures: v1
    local Attachment = Instance.new("Attachment")
    Attachment.Name = v1.FrameAttachmentName
    Attachment.CFrame = CFrame.new(v41) * CFrame.lookAt(Vector3.new(0, 0, 0), v42).Rotation
    Attachment:SetAttribute("AuthoredFacing", v43)
    Attachment.Parent = v40
end

function v1.CloneEgg(v44) -- line 361 | captures: AnimalEggShape, v1, findGroupEgg, addFrame
    local v45, v46 = findGroupEgg(v44)
    local v47 = v45 or v1.FindOwnEgg(v44)
    local v48 = if v47 then v1.FrontOverrides[v47.Name] else nil
    if not v47 or not v48 then
        if v46 then
            v48 = v46.Front
        else
            v48 = nil
        end
    end
    local v49 = v47 and v1.ModelShellOverrides[v47.Name]
    local v50
    if v46 then
        v50 = v46.ShellNames
    else
        v50 = {}
        v50[1] = v49 or v1.ModelShellName
    end
    if v47 and v47:IsA("BasePart") then
        local Model = Instance.new("Model")
        Model.Name = v47.Name
        local v51 = v47:Clone()
        v51.Name = v1.BodyPartName
        v51.Parent = Model
        Model.PrimaryPart = v51
        local v52
        if v1.WholeBodyEggs[v47.Name] then
            v52 = Vector3.new(0, 0, 0)
        else
            v52 = AnimalEggShape.GetBodyCenter(v47)
        end
        local v53 = v48 or v1.Front
        addFrame(v51, v52 * v51.Size, v53, CFrame.lookAt(Vector3.new(0, 0, 0), v53).Rotation)
        return Model
    end
    if v47 and v47:IsA("Model") then
        local v54 = v47:Clone()
        local v55 = v50

        local function biggest(v56) -- line 332 | captures: v54, v55
            local v57
            local v58 = -1
            for v59, v60 in v54:GetDescendants() do
                if v60:IsA("BasePart") then
                    if v56 then
                        if table.find(v55, v60.Name) then
                            local v61 = v60.Size.X * v60.Size.Y * v60.Size.Z
                            if v58 < v61 then
                                v57 = v60
                                v58 = v61
                            end
                        end
                    else
                        local v62 = v60.Size.X * v60.Size.Y * v60.Size.Z
                        if v58 < v62 then
                            v57 = v60
                            v58 = v62
                        end
                    end
                end
            end
            return v57
        end

        local v63 = biggest(true) or biggest(false)
        if v63 then
            v63.Name = v1.BodyPartName
            v54.PrimaryPart = v63
            local v64 = v48 or v1.ModelFront
            local v65 = v63.CFrame:VectorToObjectSpace(v64)
            if v46 and v46.Straighten then
                local X = v65.X
                local Z = v65.Z
                local v66 = Vector3.new(X, 0, Z)
                if v66.Magnitude > 0.001 then
                    v65 = v66.Unit
                end
            end
            addFrame(v63, Vector3.new(0, 0, 0), v65, CFrame.lookAt(Vector3.new(0, 0, 0), v64).Rotation)
            if v46 and v46.HoldInFront then
                local v67 = v63:FindFirstChild(v1.FrameAttachmentName)
                if v67 then
                    v67:SetAttribute("HoldInFront", true)
                end
            end
            return v54
        end
        v54:Destroy()
    end
    local v68 = v1.GetPlaceholder()
    if v68 then
        return (v68:Clone())
    end
    return nil
end

function v1.GetEggFrame(v69) -- line 425 | captures: v1
    local PrimaryPart = v69.PrimaryPart
    local v70 = PrimaryPart and PrimaryPart:FindFirstChild(v1.FrameAttachmentName)
    if v70 and v70:IsA("Attachment") then
        return v70.WorldCFrame
    end
    return (v69:GetBoundingBox())
end

function v1.GetFrameAttachment(v71) -- line 436 | captures: v1
    local PrimaryPart = v71.PrimaryPart
    local v72 = PrimaryPart and PrimaryPart:FindFirstChild(v1.FrameAttachmentName)
    if v72 and v72:IsA("Attachment") then
        return v72
    end
    return nil
end

function v1.AuthoredFacing(v73) -- line 444 | captures: v1
    local v74 = v1.GetFrameAttachment(v73)
    if v74 then
        local AuthoredFacing = v74:GetAttribute("AuthoredFacing")
        if typeof(AuthoredFacing) == "CFrame" then
            return AuthoredFacing.Rotation
        end
        return v74.CFrame.Rotation
    end
    return CFrame.identity
end

function v1.PlantedFacing(v75) -- line 463 | captures: v1
    local Rotation = CFrame.lookAt(Vector3.new(0, 0, 0), v1.Front).Rotation
    if v75 then
        return v75.Rotation * Rotation
    end
    return Rotation
end

function v1.AlignEggFrame(v76, v77) -- line 469 | captures: v1
    v76:PivotTo(v77 * v1.GetEggFrame(v76):ToObjectSpace(v76:GetPivot()))
end

function v1.PlaceOnGround(v78, v79) -- line 477 | captures: v1
    local LookVector = v79.LookVector
    local X = LookVector.X
    local Z = LookVector.Z
    local v80 = Vector3.new(X, 0, Z)
    local v81 = if v80.Magnitude > 0.001 then CFrame.lookAt(Vector3.new(0, 0, 0), v80).Rotation else CFrame.identity
    v1.AlignEggFrame(v78, CFrame.new(v79.Position) * v81)
    local v82, v83 = v78:GetBoundingBox()
    local v84 = v82.Position.Y - v83.Y / 2
    local v85 = v78:GetPivot()
    local v86 = v79.Position.Y - v84
    v78:PivotTo(v85 + Vector3.new(0, v86, 0))
end

function v1.PrepareForDisplay(v87) -- line 489 | captures: v1
    local v88 = v1.GetEggFrame(v87)
    v87.PrimaryPart = nil
    v87.WorldPivot = v88
    return v87
end

return v1
