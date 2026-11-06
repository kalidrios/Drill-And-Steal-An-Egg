-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalEggsConfig = require(script.Parent.AnimalEggsConfig)
local EggRewards = require(script.Parent.EggRewards)
local v1 = {
    Attribute = "EggType",
    TemplateFolder = "Eggs",
    AnimMaxDistance = 140,
    AnimCheckInterval = 0.5,
    DisabledNoticeDelay = 6,
    Types = {
        Demon = {
            DisplayName = "Demon Egg",
            Template = "Demon Egg",
            Body = "Demon Egg.014",
            Front = Vector3.new(0, 0, 1),
            BodyCenter = Vector3.new(0, 0.029999999329447746, 0.14000000059604645),
            HeldHeight = 3,
            HoldForward = 0.21,
            HoldLift = 0.1,
            GroundSink = 0.11,
            GrowthSeconds = 60,
            Rarity = "Inferno",
            Icon = "rbxassetid://76560393633139",
            GrowByWeight = true,
            HeldScaleRange = { 0.8, 2.5 },
            HatchPool = { "HellAnky", "HellTrike", "HellMegalodon", "HellTRex", "HellDragon", "HellHydra" },
            HatchWeights = {
                HellAnky = 50,
                HellTrike = 32,
                HellMegalodon = 14.4,
                HellTRex = 3,
                HellDragon = 0.5,
                HellHydra = 0.1
            },
            VariantChance = {
                Gold = 0.05,
                Diamond = 0.01
            }
        },
        FallenAngel = {
            DisplayName = "Fallen Angel Egg",
            Template = "Angel Egg",
            Body = "Demon Egg.014",
            Front = Vector3.new(0, 0, 1),
            BodyCenter = Vector3.new(0, 0.029999999329447746, 0.14000000059604645),
            HeldHeight = 3,
            HoldForward = 0.21,
            HoldLift = 0.1,
            GroundSink = 0.11,
            GrowthSeconds = 60,
            Rarity = "Celestial",
            Icon = "rbxassetid://83525826842415",
            GrowByWeight = true,
            HeldScaleRange = { 0.8, 2.5 },
            HatchPool = { "AngelAnky", "AngelTrike", "AngelMegalodon", "AngelTRex", "AngelDragon", "AngelHydra" },
            HatchWeights = {
                AngelAnky = 70,
                AngelTrike = 18,
                AngelMegalodon = 9.9,
                AngelTRex = 1,
                AngelDragon = 1,
                AngelHydra = 0.1
            },
            Renames = {
                AngelCroc = "AngelAnky",
                HellCroc = "AngelAnky",
                HellAnky = "AngelAnky",
                HellTrike = "AngelTrike",
                HellMegalodon = "AngelMegalodon",
                HellTRex = "AngelTRex",
                HellDragon = "AngelDragon",
                HellHydra = "AngelHydra"
            },
            VariantChance = {
                Gold = 0.05,
                Diamond = 0.01
            }
        },
        Celestial = {
            DisplayName = "Celestial Egg",
            Template = "Celestial Egg",
            Body = "Egg",
            Front = Vector3.new(0, 0, 1),
            BodyCenter = Vector3.new(0, 0, 0),
            HeldHeight = 3,
            HoldForward = 0.37,
            HoldLift = 0,
            GrowthSeconds = 60,
            Rarity = "Celestial",
            Icon = "rbxassetid://128356870637903",
            GrowByWeight = true,
            HeldScaleRange = { 0.8, 2.5 },
            HatchPool = { "CelestialLamb", "CelestialSpiritFox", "CelestialFrog", "CelestialAxolotl", "CelestialGorilla" },
            HatchWeights = {
                CelestialLamb = 60,
                CelestialSpiritFox = 25,
                CelestialFrog = 12,
                CelestialAxolotl = 2.9,
                CelestialGorilla = 0.1
            }
        }
    }
}

function v1.Get(v2) -- line 345 | captures: v1
    if typeof(v2) == "string" then
        return v1.Types[v2]
    end
    return nil
end

function v1.IsDisabled(v3) -- line 354 | captures: v1
    local v4 = v1.Get(v3)
    if v4 == nil then
        return false
    end
    return v4.Disabled == true
end

function v1.GrowsByWeight(v5) -- line 361 | captures: v1
    local v6 = v1.Get(v5)
    if v6 == nil then
        return false
    end
    if v6.GrowByWeight == true then
        return true
    end
    return v6.WeightLuck ~= nil
end

function v1.RollAnimal(v7, v8) -- line 368 | captures: EggRewards, v1
    local v9 = v1.Get(v7)
    if v9 then
        local v10 = v8 or Random.new()
        local HatchPool = v9.HatchPool
        if HatchPool and #HatchPool > 0 then
            local HatchWeights = v9.HatchWeights
            if HatchWeights then
                local v11 = 0
                for v12, v13 in HatchPool do
                    local v14 = HatchWeights[v13] or 1
                    v11 += math.max(v14, 0)
                end
                local v15 = v10:NextNumber() * v11
                for v16, v17 in HatchPool do
                    local v18 = HatchWeights[v17] or 1
                    v15 -= math.max(v18, 0)
                    if v15 <= 0 then
                        return v17
                    end
                end
                return HatchPool[#HatchPool]
            end
            return HatchPool[v10:NextInteger(1, #HatchPool)]
        end
        local v19 = {}
        for v20, v21 in EggRewards.Pool do
            if v21.Zone then
                local Name = v21.Name
                table.insert(v19, Name)
            end
        end
        if #v19 == 0 then
            return nil
        end
        return v19[v10:NextInteger(1, #v19)]
    end
    return nil
end

function v1.HatchOdds(v22) -- line 411 | captures: v1
    local v23 = v1.Get(v22)
    local v24 = v23 and v23.HatchPool
    local v25 = {}
    if v23 and v24 and #v24 > 0 then
        local HatchWeights = v23.HatchWeights
        local v26 = 0
        for v27, v28 in v24 do
            local v29
            if HatchWeights then
                local v30 = HatchWeights[v28] or 1
                v29 = math.max(v30, 0)
            else
                v29 = 1
            end
            v26 += v29
        end
        for v31, v32 in v24 do
            local v33
            if HatchWeights then
                local v34 = HatchWeights[v32] or 1
                v33 = math.max(v34, 0)
            else
                v33 = 1
            end
            if v26 > 0 then
                v25[v32] = v33 / v26 * 100
            else
                v25[v32] = 0
            end
        end
        return v25
    end
    return v25
end

local function FormatChance(v35) -- line 431
    local v36 = v35 * 1000
    local v37 = math.round(v36) / 1000
    return string.format("%g%%", v37)
end

v1.FormatChance = FormatChance

local v38 = { "Diamond", "Gold" }

function v1.RollVariant(v39, v40) -- line 441 | captures: v1, v38
    local v41 = v1.Get(v39)
    local v42 = v41 and v41.VariantChance
    if v42 then
        local v43 = v40 or Random.new()
        for v44, v45 in v38 do
            if v43:NextNumber() < (v42[v45] or 0) then
                return v45
            end
        end
    end
    return nil
end

function v1.RollLuckKg(v46, v47) -- line 458 | captures: v1
    local v48 = v1.Get(v46)
    local v49 = v48 and v48.WeightLuck
    local v50, v51
    if v49 then
        if #v49 == 0 then
            v51 = true
        else
            v50 = v47 or Random.new()
            v51 = false
        end
    else
        v51 = true
    end
    if v51 then
        return nil, nil
    end
    local v52 = 0
    for v53, v54 in v49 do
        v52 += v54.Chance
    end
    local v55 = v50:NextNumber() * v52
    local v56 = v49[#v49]
    for v57, v58 in v49 do
        v55 -= v58.Chance
        if v55 <= 0 then
            v56 = v58
            break
        end
    end
    local MinKg = v56.MinKg
    local v59 = math.log(MinKg)
    local MaxKg = v56.MaxKg
    local MinKg_2 = v56.MinKg
    local v60 = math.max(MaxKg, MinKg_2)
    local v61 = v59 + (math.log(v60) - v59) * v50:NextNumber()
    local v62 = math.exp(v61) + 0.5
    return math.floor(v62), v56.Label
end

function v1.CloneModel(v63) -- line 488 | captures: ReplicatedStorage, AnimalEggsConfig, v1
    local v64 = v1.Get(v63)
    if v64 then
        local v65 = ReplicatedStorage:FindFirstChild(v1.TemplateFolder)
        local v66 = v65 and v65:FindFirstChild(v64.Template)
        if not (v66 and v66:IsA("Model")) then
            v66 = ReplicatedStorage:FindFirstChild(v64.Template)
        end
        if not (v66 and v66:IsA("Model")) then
            warn((("[EggTypeConfig] %*: ReplicatedStorage.%*.%* (Model) not found"):format(v63, v1.TemplateFolder, v64.Template)))
        else
            local v67 = v66:Clone()
            for v68, v69 in v67:GetDescendants() do
                if v69:IsA("LuaSourceContainer") or v69:IsA("ProximityPrompt") then
                    v69:Destroy()
                end
            end
            for v70, v71 in { "AnimSaves", "InitialPoses" } do
                local v72 = v67:FindFirstChild(v71)
                if v72 then
                    v72:Destroy()
                end
            end
            local v73
            if v64.Body then
                v73 = v67:FindFirstChild(v64.Body, true)
            end
            if not (v73 and v73:IsA("BasePart")) then
                v73 = v67.PrimaryPart or v67:FindFirstChildWhichIsA("BasePart", true)
            end
            if v73 then
                v67.PrimaryPart = v73
                v73.PivotOffset = CFrame.identity
                local v74 = v73:FindFirstChild(AnimalEggsConfig.FrameAttachmentName)
                if v74 then
                    v74:Destroy()
                end
                local Attachment = Instance.new("Attachment")
                Attachment.Name = AnimalEggsConfig.FrameAttachmentName
                local new = CFrame.new
                local BodyCenter = v64.BodyCenter
                local v75 = Vector3.new(0, 0, 0)
                Attachment.CFrame = new(BodyCenter or v75) * CFrame.lookAt(Vector3.new(0, 0, 0), v64.Front)
                Attachment:SetAttribute("AuthoredFacing", CFrame.lookAt(Vector3.new(0, 0, 0), v64.Front).Rotation)
                Attachment.Parent = v73
                return v67
            end
            v67:Destroy()
        end
    end
    return nil
end

function v1.HeldHeightFor(v76, v77) -- line 541 | captures: EggRewards, v1
    local v78 = v1.Get(v76)
    if v78 then
        local v79 = v78.HeldScaleRange or { 1, 1 }
        local v80 = v77 / EggRewards.TargetHeight
        local v81 = v79[1]
        local v82 = v79[2]
        local v83 = math.clamp(v80, v81, v82)
        return v78.HeldHeight * v83
    end
    return v77
end

function v1.DisplayName(v84, v85) -- line 552 | captures: EggRewards, v1
    local v86 = v1.Get(v84)
    if v86 then
        return v86.DisplayName
    end
    return (("%* Egg"):format((EggRewards.DisplayName(v85))))
end

return v1
