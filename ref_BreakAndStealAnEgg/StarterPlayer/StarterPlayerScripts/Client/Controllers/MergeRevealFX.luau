-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local MergeRevealFXConfig = require(ReplicatedStorage.Shared.MergeRevealFXConfig)
local CameraFovController = require(script.Parent.CameraFovController)
local v1 = {}
local v2 = Color3.new(1, 1, 1)
local v3 = false
local v4 = 0
local v5 = 0
local v6 = 0
local v7, v8

local function finish() -- line 43 | captures: v3, v4, v5, RunService, CameraFovController
    RunService:UnbindFromRenderStep("MergeRevealFX")
    CameraFovController.Clear("MergeReveal")
    v3 = false
    v4 = 0
    v5 = 0
end

local function onRender(v9) -- line 51 | captures: v3, v4, v5, v6, RunService, Workspace, MergeRevealFXConfig, CameraFovController
    local CurrentCamera = Workspace.CurrentCamera
    if not CurrentCamera then
        return
    end
    local v10 = v4
    local v11 = -v4
    local v12 = -MergeRevealFXConfig.FovRecoverRate * v9
    v4 = v10 + v11 * (1 - math.exp(v12))
    CameraFovController.Set("MergeReveal", -v4)
    if v5 > 0.001 then
        local v13 = v5 - MergeRevealFXConfig.ShakeDecayPerSecond * v9
        v5 = math.max(0, v13)
        local v14 = os.clock() * MergeRevealFXConfig.ShakeFrequency
        local v15 = MergeRevealFXConfig.ShakeRadiansPerMagnitude * v5
        CurrentCamera.CFrame *= CFrame.Angles(math.noise(v14, v6) * v15, math.noise(v14, v6 + 7.3) * v15, math.noise(v14, v6 + 21.7) * v15)
    end
    if not (v4 < 0.01 and v5 <= 0.001) then
        return
    end
    RunService:UnbindFromRenderStep("MergeRevealFX")
    CameraFovController.Clear("MergeReveal")
    v3 = false
    v4 = 0
    v5 = 0
end

local function flashColor(v16) -- line 77 | captures: v7, Lighting, TweenService, MergeRevealFXConfig, v2
    if not (v7 and v7.Parent) then
        v7 = Instance.new("ColorCorrectionEffect")
        v7.Name = "MergeRevealFlash"
        v7.Parent = Lighting
    end
    local v17 = v7
    v17.Brightness = MergeRevealFXConfig.FlashBrightness
    v17.Contrast = MergeRevealFXConfig.FlashContrast
    v17.TintColor = v16:Lerp(v2, MergeRevealFXConfig.TintWhiteLerp)
    TweenService:Create(v17, TweenInfo.new(MergeRevealFXConfig.FlashSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Brightness = 0,
        Contrast = 0,
        TintColor = v2
    }):Play()
end

local function pulseDepthOfField() -- line 94 | captures: v8, Lighting, TweenService, MergeRevealFXConfig
    if not (v8 and v8.Parent) then
        v8 = Instance.new("DepthOfFieldEffect")
        v8.Name = "MergeRevealBlur"
        v8.NearIntensity = 0
        v8.FarIntensity = 0
        v8.Parent = Lighting
    end
    local v18 = v8
    v18.FocusDistance = MergeRevealFXConfig.DofFocusDistance
    v18.InFocusRadius = MergeRevealFXConfig.DofInFocusRadius
    local v19 = TweenService:Create(v18, TweenInfo.new(MergeRevealFXConfig.DofInSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        NearIntensity = MergeRevealFXConfig.DofNearIntensity,
        FarIntensity = MergeRevealFXConfig.DofFarIntensity
    })
    local v20 = TweenService:Create(v18, TweenInfo.new(MergeRevealFXConfig.DofOutSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, MergeRevealFXConfig.DofHoldSeconds), {
        NearIntensity = 0,
        FarIntensity = 0
    })
    v19.Completed:Once(function(v21) -- line 116 | captures: v20
        if v21 == Enum.PlaybackState.Completed then
            v20:Play()
        end
    end)
    v19:Play()
end

function v1.PlayRarity(v22) -- line 127 | captures: v3, v4, v5, v6, RunService, Workspace, EggRewards, MergeRevealFXConfig, v2, onRender, flashColor, pulseDepthOfField
    if not Workspace.CurrentCamera then
        return
    end
    local v23 = v22 and EggRewards.RarityColors[v22] or v2
    if not v3 then
        v3 = true
        RunService:BindToRenderStep("MergeRevealFX", Enum.RenderPriority.Camera.Value + 1, onRender)
    end
    local v24 = v4
    local FovKick = MergeRevealFXConfig.FovKick
    v4 = math.max(v24, FovKick)
    local v25 = v5
    local ShakeMagnitude = MergeRevealFXConfig.ShakeMagnitude
    v5 = math.max(v25, ShakeMagnitude)
    v6 = math.random() * 100
    flashColor(v23)
    pulseDepthOfField()
end

function v1.Play(v26) -- line 148 | captures: EggRewards, v1
    v1.PlayRarity(EggRewards.RarityOf(v26))
end

return v1
