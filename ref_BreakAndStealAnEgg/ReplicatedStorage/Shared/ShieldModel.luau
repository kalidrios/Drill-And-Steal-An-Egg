-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local Shields = require(script.Parent.HellBossConfig).Shields
local v1 = {}
local v2 = { "Beam", "ParticleEmitter", "Trail", "Light", "Fire", "Smoke", "Sparkles" }

local function isEffect(v3) -- line 58 | captures: v2
    for v4, v5 in v2 do
        if v3:IsA(v5) then
            return true
        end
    end
    return false
end

local function darken(v6, v7) -- line 67
    return Color3.new(v6.R * v7, v6.G * v7, v6.B * v7)
end

function v1.HitPart(v8) -- line 71 | captures: Shields
    if v8:IsA("BasePart") then
        return v8
    end
    local v9 = v8:FindFirstChild(Shields.HitboxName)
    if v9 and v9:IsA("BasePart") then
        return v9
    end
    if not (v8:IsA("Model") and v8.PrimaryPart) then
        return v8:FindFirstChildWhichIsA("BasePart", true)
    end
    return v8.PrimaryPart
end

function v1.Capture(v10) -- line 85 | captures: v1, v2
    local v11 = v1.HitPart(v10)
    local v12 = {
        Shield = v10,
        HitPart = v11
    }
    if v11 then
        v12.HitCanQuery = v11.CanQuery
        v12.HitCanTouch = v11.CanTouch
    else
        v12.HitCanQuery = false
        v12.HitCanTouch = false
    end
    if v10:IsA("BasePart") then
        v12.Transparency = v10.Transparency
    else
        v12.Transparency = nil
    end
    v12.Effects = {}
    v12.Neon = {}
    v12.Glow = {}
    for v13, v14 in v10:GetDescendants() do
        local v15 = false
        for v16, v17 in v2 do
            if v14:IsA(v17) then
                v15 = true
                break
            end
            v15 = false
        end
        if v15 then
            local Effects = v12.Effects
            local v18 = {
                Instance = v14,
                Enabled = v14.Enabled
            }
            if v14:IsA("Light") then
                v18.Brightness = v14.Brightness
            else
                v18.Brightness = nil
            end
            if v14:IsA("Beam") then
                v18.Transparency = v14.Transparency
            else
                v18.Transparency = nil
            end
            table.insert(Effects, v18)
        elseif v14:IsA("BasePart") and v14.Material == Enum.Material.Neon then
            local Neon = v12.Neon
            local v19 = {
                Part = v14,
                Color = v14.Color,
                Material = v14.Material
            }
            table.insert(Neon, v19)
        end
        if v14:IsA("SurfaceAppearance") then
            local pcall_2 = pcall
            local v20 = v14
            local v21, v22, v23 = pcall_2(function() -- line 109 | captures: v20
                return v20.EmissiveStrength, v20.Color
            end)
            local Parent = v14.Parent
            if v21 and v22 > 0 and Parent and Parent:IsA("BasePart") then
                local Glow = v12.Glow
                local v24 = {
                    Surface = v14,
                    Part = Parent,
                    Emissive = v22,
                    Color = v23,
                    PartColor = Parent.Color
                }
                table.insert(Glow, v24)
            end
        end
    end
    return v12
end

local function apply(v25, v26, v27) -- line 129 | captures: Shields
    local Off = Shields.Off
    for v28, v29 in v25.Effects do
        local Instance = v29.Instance
        if v26 then
            Instance.Enabled = v29.Enabled
        else
            Instance.Enabled = false
        end
        if v29.Brightness then
            Instance.Brightness = v29.Brightness
        end
        if v29.Transparency then
            Instance.Transparency = v29.Transparency
        end
        if not v26 and v27 and Instance:IsA("ParticleEmitter") then
            Instance:Clear()
        end
    end
    for v30, v31 in v25.Neon do
        local Part = v31.Part
        if v26 then
            Part.Material = v31.Material
            Part.Color = v31.Color
        else
            Part.Material = Off.Material
            local Color = v31.Color
            local ColorScale = Off.ColorScale
            Part.Color = Color3.new(Color.R * ColorScale, Color.G * ColorScale, Color.B * ColorScale)
        end
    end
    for v32, v33 in v25.Glow do
        local Surface = v33.Surface
        local Part = v33.Part
        if v26 then
            Part.Color = v33.PartColor
        else
            local PartColor = v33.PartColor
            local ColorScale = Off.ColorScale
            Part.Color = Color3.new(PartColor.R * ColorScale, PartColor.G * ColorScale, PartColor.B * ColorScale)
        end
        local pcall_2 = pcall
        local v34 = v33
        if not pcall_2(function() -- line 158 | captures: v26, Off, Surface, v34
                if v26 then
                    Surface.EmissiveStrength = v34.Emissive
                else
                    Surface.EmissiveStrength = 0
                end
                if v26 then
                    Surface.Color = v34.Color
                else
                    local Color = v34.Color
                    local ColorScale = Off.ColorScale
                    Surface.Color = Color3.new(Color.R * ColorScale, Color.G * ColorScale, Color.B * ColorScale)
                end
            end) then
            if not v26 then
                Part = nil
            end
            Surface.Parent = Part
        end
    end
    local HitPart = v25.HitPart
    if HitPart then
        if v26 then
            HitPart.CanQuery = v25.HitCanQuery
            HitPart.CanTouch = v25.HitCanTouch
        else
            HitPart.CanQuery = false
            HitPart.CanTouch = false
        end
    end
    local Shield = v25.Shield
    if v25.Transparency and Shield:IsA("BasePart") then
        if v26 then
            Shield.Transparency = v25.Transparency
        else
            Shield.Transparency = 1
        end
    end
end

function v1.SetPowered(v35, v36) -- line 179 | captures: apply
    apply(v35, v36, true)
end

local function fadeSequence(v37, v38) -- line 183
    local function v39(v40, ...)
        table.insert(v40, ...)
    end

    local v41 = {}
    for v42, v43 in v37.Keypoints do
        v39(v41, NumberSequenceKeypoint.new(v43.Time, v43.Value + (1 - v43.Value) * v38, v43.Envelope))
    end
    return NumberSequence.new(v41)
end

function v1.FadeOff(v44, v45) -- line 191 | captures: RunService, Shields, apply, fadeSequence
    local Off = Shields.Off
    if v45 <= 0 then
        apply(v44, false, true)
        return function() -- line 195
        end
    end
    local v46 = Off.FadeDim or 0.35
    local v47 = Off.FadeTail or 0
    local v48 = math.max(v47, 0)
    local v49 = {}
    local v50 = {}
    for v51, v52 in v44.Effects do
        local Instance = v52.Instance
        if Instance:IsA("Light") then
            local v53 = {
                Light = Instance,
                From = Instance.Brightness
            }
            table.insert(v49, v53)
        elseif Instance:IsA("Beam") then
            if Instance.Enabled then
                local v54 = {
                    Beam = Instance,
                    From = Instance.Transparency
                }
                table.insert(v50, v54)
            end
        else
            Instance.Enabled = false
        end
    end
    local v55 = {}
    for v56, v57 in v44.Neon do
        local Color = v57.Color
        local ColorScale = Off.ColorScale
        local v58 = Color3.new(Color.R * ColorScale, Color.G * ColorScale, Color.B * ColorScale)
        local v59 = {
            Part = v57.Part,
            From = v57.Part.Color,
            Dim = Color3.new(v58.R * v46, v58.G * v46, v58.B * v46),
            To = v58
        }
        table.insert(v55, v59)
    end
    local v60 = {}
    for v61, v62 in v44.Glow do
        local v63 = v62
        local v64, v65, v66 = pcall(function() -- line 228 | captures: v63
            return v63.Surface.EmissiveStrength, v63.Surface.Color
        end)
        local v67 = {
            Glow = v62,
            Editable = v64
        }
        if not v64 then
            v65 = v62.Emissive
        end
        v67.FromEmissive = v65
        if not v64 then
            v66 = v62.Color
        end
        v67.FromColor = v66
        v67.FromPart = v62.Part.Color
        table.insert(v60, v67)
    end
    local v68 = os.clock()
    local v69 = false
    local v70

    local function step() -- line 243 | captures: v69, v70, v44, v45, Off, v48, v49, v50, v55, v60, v68, apply, fadeSequence
        local v71 = os.clock() - v68
        local v72 = v71 / v45
        local v73 = math.clamp(v72, 0, 1)
        local v74 = 1 - (1 - v73) * (1 - v73)
        for v75, v76 in v49 do
            v76.Light.Brightness = v76.From * (1 - v74)
        end
        for v77, v78 in v50 do
            v78.Beam.Transparency = fadeSequence(v78.From, v74)
        end
        for v79, v80 in v60 do
            local Glow = v80.Glow
            local Part = Glow.Part
            local FromPart = v80.FromPart
            local PartColor = Glow.PartColor
            local ColorScale = Off.ColorScale
            Part.Color = FromPart:Lerp(Color3.new(PartColor.R * ColorScale, PartColor.G * ColorScale, PartColor.B * ColorScale), v74)
            if v80.Editable then
                local pcall_2 = pcall
                local v81 = v80
                pcall_2(function() -- line 258 | captures: v74, Glow, v81, Off
                    Glow.Surface.EmissiveStrength = v81.FromEmissive * (1 - v74)
                    local Surface = Glow.Surface
                    local FromColor = v81.FromColor
                    local Color = Glow.Color
                    local ColorScale = Off.ColorScale
                    Surface.Color = FromColor:Lerp(Color3.new(Color.R * ColorScale, Color.G * ColorScale, Color.B * ColorScale), v74)
                end)
            end
        end
        if v73 < 1 then
            for v82, v83 in v55 do
                v83.Part.Color = v83.From:Lerp(v83.Dim, v74)
            end
        else
            if not v69 then
                v69 = true
                for v84, v85 in v55 do
                    v85.Part.Material = Off.Material
                end
            end
            local v86
            if v48 > 0 then
                local v87 = (v71 - v45) / v48
                v86 = math.clamp(v87, 0, 1)
            else
                v86 = 1
            end
            for v88, v89 in v55 do
                v89.Part.Color = v89.Dim:Lerp(v89.To, v86)
            end
            if v86 >= 1 then
                if v70 then
                    v70:Disconnect()
                    v70 = nil
                end
                apply(v44, false, false)
            end
        end
    end

    v70 = RunService.Heartbeat:Connect(step)
    return function() -- line 293 | captures: v70
        if v70 then
            v70:Disconnect()
            v70 = nil
        end
    end
end

return v1
