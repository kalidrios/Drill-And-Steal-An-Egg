-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local EggInfoUi = require(ReplicatedStorage.Shared.EggInfoUi)
local HellLoadout = require(ReplicatedStorage.Shared.HellLoadout)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local TitanicEggConfig = require(ReplicatedStorage.Shared.TitanicEggConfig)
local ClaimFeedback = require(script.Parent.ClaimFeedback)
local CustomSfx = require(script.Parent.Parent.Modules.CustomSfx)
local EggViewFrustum = require(script.Parent.Parent.Modules.EggViewFrustum)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local MessageBanner = require(script.Parent.Parent.Modules.MessageBanner)
local ZoneMessageController = require(script.Parent.ZoneMessageController)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local Attributes = TitanicEggConfig.Attributes
local v2

local function findLabel(v3, v4) -- line 89
    local v5 = v3:FindFirstChild(v4)
    if not (v5 and v5:IsA("TextLabel")) then
        return nil
    end
    return v5
end

local function evalSequence(v6, v7) -- line 97
    local Keypoints = v6.Keypoints
    if v7 <= Keypoints[1].Time then
        return Keypoints[1].Value
    end
    local v8 = #Keypoints - 1
    for v9 = 1, v8 do
        local v10 = Keypoints[v9]
        local v11 = Keypoints[v9 + 1]
        if v7 <= v11.Time then
            local v12 = v11.Time - v10.Time
            if v12 > 0 then
                return (v10.Value:Lerp(v11.Value, (v7 - v10.Time) / v12))
            end
            return v11.Value
        end
    end
    return Keypoints[#Keypoints].Value
end

local function setTitleText(v13, v14) -- line 115
    local function v15(v16, ...)
        table.insert(v16, ...)
    end

    if v13.CurrentText == v14 then
        return
    end
    v13.CurrentText = v14
    for v17, v18 in v13.Letters do
        v18.Label:Destroy()
    end
    table.clear(v13.Letters)
    local v19 = {}
    for v20, v21 in utf8.graphemes(v14) do
        v15(v19, v14:sub(v20, v21))
    end
    local v22 = #v19
    local v23 = math.max(v22, 1)
    v13.LetterCount = v23
    for v24, v25 in v19 do
        if v25 ~= " " then
            local v26 = v13.Template:Clone()
            v26.Name = "Letter"
            v26.Text = v25
            v26.AnchorPoint = Vector2.zero
            local v27 = (v24 - 1) / v23
            v26.Position = UDim2.fromScale(v27, 0)
            v26.Size = UDim2.fromScale(1 / v23, 1)
            v26.Parent = v13.Title
            local Letters = v13.Letters
            local v28 = {
                Label = v26,
                Index = v24,
                X = v27
            }
            table.insert(Letters, v28)
        end
    end
end

local function resolve() -- line 154 | captures: v2, Workspace, TitanicEggConfig
    local v29 = v2
    if v29 and v29.Gui.Parent then
        return v29
    end
    if v29 then
        v29.Template:Destroy()
    end
    v2 = nil
    local v30 = Workspace:FindFirstChild(TitanicEggConfig.Board.ModelName)
    local v31 = v30 and v30:FindFirstChild(TitanicEggConfig.Board.GuiName, true)
    if v31 then
        local Title = v31:FindFirstChild("Title")
        if not (Title and Title:IsA("TextLabel")) then
            Title = nil
        end
        local Timer = v31:FindFirstChild("Timer")
        if not (Timer and Timer:IsA("TextLabel")) then
            Timer = nil
        end
        local Color
        if Title and Timer then
            local UIGradient = Title:FindFirstChildWhichIsA("UIGradient")
            Color = UIGradient and UIGradient.Color or ColorSequence.new(Title.TextColor3)
        else
            return nil
        end
        local v32 = Title:Clone()
        v32.BackgroundTransparency = 1
        v32.Visible = true
        local UIGradient = v32:FindFirstChildWhichIsA("UIGradient")
        if UIGradient then
            UIGradient:Destroy()
        end
        v32.TextColor3 = Color3.new(1, 1, 1)
        local Text = Title.Text
        Title.Text = ""
        local v33 = {
            LetterCount = 1,
            CurrentText = nil,
            Gui = v31
        }
        if not (v31.Parent and v31.Parent:IsA("BasePart")) then
            v33.BoardPart = nil
        else
            v33.BoardPart = v31.Parent
        end
        v33.Title = Title
        v33.Timer = Timer
        v33.Template = v32
        v33.Master = Color
        v33.IdleTitle = Text
        v33.Letters = {}
        v2 = v33
        return v2
    end
    return nil
end

local function stepWave() -- line 210 | captures: v2, Workspace, EggViewFrustum, evalSequence
    local v34 = v2
    if not (v34 and v34.Gui.Parent and #v34.Letters ~= 0) then
        return
    end
    local BoardPart = v34.BoardPart
    if BoardPart then
        local CurrentCamera = Workspace.CurrentCamera
        if not (CurrentCamera and (CurrentCamera.CFrame.Position - BoardPart.Position).Magnitude > 250) then
            if not EggViewFrustum.IsSphereVisible(BoardPart.Position, BoardPart.Size.Magnitude * 0.5) then
                return
            end
        else
            return
        end
    end
    local v35 = os.clock()
    local LetterCount = v34.LetterCount
    for v36, v37 in v34.Letters do
        local v38 = v35 * 1.6 - v37.Index * 0.4
        local v39 = math.sin(v38) * -0.045
        v37.Label.Position = UDim2.fromScale(v37.X, v39)
        local v40 = (v37.Index / LetterCount * 1 - v35 * 0.1) % 1
        v37.Label.TextColor3 = evalSequence(v34.Master, v40)
    end
end

local function reverseSequence(v41) -- line 263
    local function v42(v43, ...)
        table.insert(v43, ...)
    end

    local Keypoints = v41.Keypoints
    local v44 = table.create(#Keypoints)
    local v45 = #Keypoints
    for v46 = v45, 1, -1 do
        local v47 = Keypoints[v46]
        v42(v44, ColorSequenceKeypoint.new(1 - v47.Time, v47.Value))
    end
    return ColorSequence.new(v44)
end

local v48

local function animateTitanicLabel(v49) -- line 280 | captures: v48, RarityGradientFX, reverseSequence
    local Texts = v49:FindFirstChild("Texts")
    local v50 = Texts and Texts:FindFirstChild("Titanic")
    local v51 = v50 and v50:FindFirstChildWhichIsA("UIGradient")
    if not v51 then
        return
    end
    v48 = v48 or reverseSequence(v51.Color)
    RarityGradientFX.Attach(v51, "Mythic", nil, {
        Master = v48,
        Rotation = v51.Rotation + 180
    })
end

local v52 = MessageBanner.new({
    Name = "TitanicSpawn",
    Order = 1,
    Hold = 4,
    OnResolve = animateTitanicLabel
})

local function showBanner(v53, v54) -- line 304 | captures: HellLoadout, TitanicEggConfig, ClaimFeedback, CustomSfx, ZoneMessageController, LocalPlayer, v52
    if not HellLoadout.InHell(LocalPlayer) and v53 then
        v52:Show(function(v55) -- line 308 | captures: v53, v54, TitanicEggConfig, ClaimFeedback, CustomSfx, ZoneMessageController
            local v56 = ZoneMessageController.ZoneInfo[("Zone%*"):format(v53)]
            local Texts = v55:FindFirstChild("Texts")
            local v57 = Texts and Texts:FindFirstChild("ZoneName")
            if v57 and v57:IsA("TextLabel") then
                if v56 then
                    v57.Text = v56.Name
                else
                    v57.Text = ("Zone %*"):format(v53)
                end
                local UIGradient = v57:FindFirstChildWhichIsA("UIGradient")
                if UIGradient and v56 then
                    UIGradient.Color = v56.Gradient
                end
            end
            CustomSfx.PlayCue(TitanicEggConfig.SpawnSfx)
            if v54 and TitanicEggConfig.AdminSpawnFeedback then
                ClaimFeedback.PlayBank()
            end
        end)
    end
end

function v1.Start() -- line 331 | captures: RunService, Workspace, EggInfoUi, HellLoadout, TitanicEggConfig, ClaimFeedback, CustomSfx, MainGui, ZoneMessageController, LocalPlayer, Attributes, setTitleText, resolve, stepWave, v52
    RunService.Heartbeat:Connect(stepWave)
    Workspace:GetAttributeChangedSignal(Attributes.SpawnId):Connect(function() -- line 339 | captures: Workspace, HellLoadout, TitanicEggConfig, ClaimFeedback, CustomSfx, ZoneMessageController, LocalPlayer, Attributes, v52
        task.defer(function() -- line 340 | captures: Workspace, HellLoadout, TitanicEggConfig, ClaimFeedback, CustomSfx, ZoneMessageController, LocalPlayer, Attributes, v52
            if not Workspace:GetAttribute(Attributes.EggName) then
                return
            end
            local v58 = Workspace:GetAttribute(Attributes.ZoneIndex)
            local v59 = Workspace:GetAttribute(Attributes.SpawnByAdmin) == true
            if not HellLoadout.InHell(LocalPlayer) then
                if not v58 then
                    return
                end
                v52:Show(function(v60) -- line 308 | captures: v58, v59, TitanicEggConfig, ClaimFeedback, CustomSfx, ZoneMessageController
                    local v61 = ZoneMessageController.ZoneInfo[("Zone%*"):format(v58)]
                    local Texts = v60:FindFirstChild("Texts")
                    local v62 = Texts and Texts:FindFirstChild("ZoneName")
                    if v62 and v62:IsA("TextLabel") then
                        if v61 then
                            v62.Text = v61.Name
                        else
                            v62.Text = ("Zone %*"):format(v58)
                        end
                        local UIGradient = v62:FindFirstChildWhichIsA("UIGradient")
                        if UIGradient and v61 then
                            UIGradient.Color = v61.Gradient
                        end
                    end
                    CustomSfx.PlayCue(TitanicEggConfig.SpawnSfx)
                    if v59 and TitanicEggConfig.AdminSpawnFeedback then
                        ClaimFeedback.PlayBank()
                    end
                end)
            end
        end)
    end)
    MainGui.Observe(function() -- line 351 | captures: v52
        v52:Resolve()
    end)
    task.spawn(function() -- line 355 | captures: Workspace, EggInfoUi, Attributes, setTitleText, resolve
        while true do
            local v63 = resolve()
            if v63 then
                local v64 = Workspace:GetServerTimeNow()
                local v65 = Workspace:GetAttribute(Attributes.NextAt)
                setTitleText(v63, v63.IdleTitle)
                if v65 then
                    local Timer = v63.Timer
                    local FormatTimer = EggInfoUi.FormatTimer
                    local v66 = v65 - v64
                    Timer.Text = ("Spawns in: %*"):format((FormatTimer((math.max(v66, 0)))))
                end
            end
            local wait = task.wait
            local v67 = if v63 then 0.25 else 1
            wait(v67)
        end
    end)
end

return v1
