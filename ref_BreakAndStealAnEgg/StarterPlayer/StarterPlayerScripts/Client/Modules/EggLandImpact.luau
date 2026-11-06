-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local EggPlaceBurst = require(script.Parent.EggPlaceBurst)
local SurfaceLook = require(script.Parent.SurfaceLook)
local v1 = {}
local v2 = {
    ChunkCountMin = 6,
    ChunkCountMax = 10,
    ChunkStagger = 0.015,
    ChunkUpSeconds = 0.2,
    ChunkLandSeconds = 0.12,
    ChunkSettleSeconds = 0.08,
    ChunkFadeDelay = 0.15,
    ChunkFadeSeconds = 0.5,
    DecalFadeInSeconds = 0.25,
    DecalLingerMin = 7,
    DecalLingerMax = 11,
    DecalFadeOutSeconds = 1,
    RingSeconds = 0.3,
    MudColor = Color3.fromRGB(101, 67, 33),
    ChunkColors = {
        Color3.fromRGB(101, 67, 33),
        Color3.fromRGB(92, 60, 28),
        Color3.fromRGB(110, 75, 40),
        Color3.fromRGB(85, 55, 25)
    }
}
local v3 = Random.new()
local Folder

local function getVfxFolder() -- line 59 | captures: Folder, Workspace
    if Folder and Folder.Parent then
        return Folder
    end
    local Folder_2 = Instance.new("Folder")
    Folder_2.Name = "EggLandImpact_Local"
    Folder_2.Parent = Workspace
    Folder = Folder_2
    return Folder_2
end

local function makeDebrisPart(v4, v5) -- line 70
    local Part = Instance.new("Part")
    Part.Size = v4
    Part.Color = v5
    Part.Material = Enum.Material.SmoothPlastic
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    return Part
end

local function spawnDirtChunk(v6, v7, v8, v9) -- line 88 | captures: Debris, TweenService, SurfaceLook, v2, v3
    local function v10(v11, v12, ...)
        return (Vector3.new(v11, v12, ...))
    end

    local function v13(v14, v15, ...)
        return (Vector3.new(v14, v15, ...))
    end

    local v16 = v3:NextNumber(0.25, 0.45) * v8
    local v17 = v16 * 0.7
    local v18 = Vector3.new(v16, v17, v16)
    local v19 = v2.ChunkColors[v3:NextInteger(1, #v2.ChunkColors)]
    local Part = Instance.new("Part")
    Part.Size = v18
    Part.Color = v19
    Part.Material = Enum.Material.SmoothPlastic
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    local v20 = SurfaceLook.Apply(Part, v9)
    Part.Position = v7 + Vector3.new(0, 0.05000000074505806, 0)
    Part.Orientation = v10(v3:NextNumber(-30, 30), v3:NextNumber(-180, 180), v3:NextNumber(-30, 30))
    Part.Parent = v6
    Debris:AddItem(Part, 3)
    local v21 = v3:NextNumber(0, 360)
    local v22 = math.rad(v21)
    local v23 = v3:NextNumber(0.3, 0.6) * v8
    local v24 = math.cos(v22) * v23
    local v25 = math.sin(v22) * v23
    local v26 = v24 * 0.6
    local v27 = v3:NextNumber(0.5, 0.9) * v8
    local v28 = v25 * 0.6
    local v29 = v7 + Vector3.new(v26, v27, v28)
    local v30 = v8 * 0.02
    local v31 = v7 + Vector3.new(v24, v30, v25)
    local v32 = v8 * -0.01
    local v33 = v31 + Vector3.new(0, v32, 0)
    local v34 = TweenService:Create(Part, TweenInfo.new(v2.ChunkUpSeconds, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = v29,
        Orientation = Part.Orientation + v13(v3:NextNumber(-45, 45), v3:NextNumber(-90, 90), v3:NextNumber(-45, 45))
    })
    v34:Play()
    v34.Completed:Once(function() -- line 115 | captures: v16, Part, v20, v31, v33, Debris, TweenService, SurfaceLook, v2
        local v35 = TweenInfo.new(v2.ChunkLandSeconds, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
        local v36 = { Position = v31 }
        local v37 = v16 * 1.1
        local v38 = v16 * 0.5
        local v39 = v16 * 1.1
        v36.Size = Vector3.new(v37, v38, v39)
        local v40 = TweenService:Create(Part, v35, v36)
        v40:Play()
        v40.Completed:Once(function() -- line 121 | captures: v16, Part, v20, v33, Debris, TweenService, SurfaceLook, v2
            local v41 = TweenInfo.new(v2.ChunkSettleSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local v42 = { Position = v33 }
            local v43 = v16 * 0.65
            v42.Size = Vector3.new(v16, v43, v16)
            local v44 = TweenService:Create(Part, v41, v42)
            v44:Play()
            v44.Completed:Once(function() -- line 127 | captures: Part, v20, Debris, TweenService, SurfaceLook, v2
                task.delay(v2.ChunkFadeDelay, function() -- line 128 | captures: Part, v20, Debris, TweenService, SurfaceLook, v2
                    local v45 = TweenInfo.new(v2.ChunkFadeSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                    TweenService:Create(Part, v45, { Transparency = 1 }):Play()
                    SurfaceLook.Fade(v20, v45)
                    Debris:AddItem(Part, v2.ChunkFadeSeconds)
                end)
            end)
        end)
    end)
end

local function spawnDirtChunks(v46, v47, v48, v49) -- line 141 | captures: SurfaceLook, v2, v3, spawnDirtChunk
    local v50 = v49
    local v51 = v49 or SurfaceLook.Below(v47, { v46 })
    v50 = v51
    local v52 = v3:NextInteger(v2.ChunkCountMin, v2.ChunkCountMax)
    spawnDirtChunk(v46, v47, v48, v51)
    for v53 = 2, v52 do
        local delay = task.delay
        local v54 = (v53 - 1) * v2.ChunkStagger
        delay(v54, function() -- line 148 | captures: v50, v46, v47, v48, spawnDirtChunk
            spawnDirtChunk(v46, v47, v48, v50)
        end)
    end
end

local function spawnDirtDecal(v55, v56, v57) -- line 154 | captures: Debris, TweenService, v2, v3
    local v58 = v57 * 0.1
    local v59 = v57 * 0.8
    local v60 = v57 * 1.6
    local v61 = v57 * 1.4
    local v62 = Vector3.new(v58, v59, v59)
    local MudColor = v2.MudColor
    local Part = Instance.new("Part")
    Part.Size = v62
    Part.Color = MudColor
    Part.Material = Enum.Material.SmoothPlastic
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Name = "EggPlaceDirtDecal"
    Part.Shape = Enum.PartType.Cylinder
    Part.Transparency = 1
    Part.Position = v56 - Vector3.new(0, 0.009999999776482582, 0)
    local v63 = v3:NextNumber(-180, 180)
    Part.Orientation = Vector3.new(0, v63, 90)
    Part.Parent = v55
    TweenService:Create(Part, TweenInfo.new(v2.DecalFadeInSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0,
        Size = Vector3.new(v58, v60, v60)
    }):Play()
    task.delay(v3:NextNumber(v2.DecalLingerMin, v2.DecalLingerMax), function() -- line 173 | captures: v58, v61, Part, Debris, TweenService, v2
        local v64 = TweenInfo.new(v2.DecalFadeOutSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v65 = { Transparency = 1 }
        v65.Size = Vector3.new(v58, v61, v61)
        TweenService:Create(Part, v64, v65):Play()
        Debris:AddItem(Part, v2.DecalFadeOutSeconds)
    end)
end

local function spawnImpactRing(v66, v67, v68) -- line 182 | captures: Debris, TweenService, v2
    local v69 = v68 * 0.05
    local v70 = v68 * 0.3
    local v71 = v68 * 0.3
    local v72 = Vector3.new(v69, v70, v71)
    local v73 = Color3.fromRGB(139, 90, 43)
    local Part = Instance.new("Part")
    Part.Size = v72
    Part.Color = v73
    Part.Material = Enum.Material.SmoothPlastic
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Name = "EggPlaceImpactRing"
    Part.Shape = Enum.PartType.Cylinder
    Part.Transparency = 0.3
    Part.Position = v67 + Vector3.new(0, 0.019999999552965164, 0)
    Part.Orientation = Vector3.new(0, 0, 90)
    Part.Parent = v66
    local v74 = TweenInfo.new(v2.RingSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v75 = { Transparency = 1 }
    local v76 = v68 * 0.05
    local v77 = v68 * 1.8
    local v78 = v68 * 1.8
    v75.Size = Vector3.new(v76, v77, v78)
    TweenService:Create(Part, v74, v75):Play()
    Debris:AddItem(Part, 0.35)
end

function v1.Dirt(v79, v80, v81) -- line 199 | captures: spawnDirtChunks, spawnDirtDecal, spawnImpactRing
    spawnDirtChunks(v79, v80, v81)
    spawnDirtDecal(v79, v80, v81)
    spawnImpactRing(v79, v80, v81)
end

function v1.Play(v82, v83, v84) -- line 206 | captures: Folder, Workspace, EggPlaceBurst, v1
    local Dirt = v1.Dirt
    local Folder_2
    if not (Folder and Folder.Parent) then
        Folder_2 = Instance.new("Folder")
        Folder_2.Name = "EggLandImpact_Local"
        Folder_2.Parent = Workspace
        Folder = Folder_2
    else
        Folder_2 = Folder
    end
    Dirt(Folder_2, v82, (math.max(v83, 0.1)))
    EggPlaceBurst.Play(v82, v84)
end

function v1.Chunks(v85, v86, v87, v88) -- line 214 | captures: Folder, Workspace, EggPlaceBurst, spawnDirtChunks
    local Folder_2
    if not (Folder and Folder.Parent) then
        Folder_2 = Instance.new("Folder")
        Folder_2.Name = "EggLandImpact_Local"
        Folder_2.Parent = Workspace
        Folder = Folder_2
    else
        Folder_2 = Folder
    end
    spawnDirtChunks(Folder_2, v85, math.max(v86, 0.1), v88)
    EggPlaceBurst.Play(v85, v87)
end

return v1
