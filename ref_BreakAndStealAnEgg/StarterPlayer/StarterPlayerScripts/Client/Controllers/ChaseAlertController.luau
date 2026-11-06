-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local ChaseState = require(ReplicatedStorage.Shared.ChaseState)
local HudVisibility = require(ReplicatedStorage.Shared.HudVisibility)
local NotificationConfig = require(ReplicatedStorage.Shared.NotificationConfig)
local SettingsState = require(script.Parent.Parent.Modules.SettingsState)
local v1 = {}
local v2 = { "LeftHUD", "RightHUD" }
local v3 = Vector2.new(0.5, 0.5)
local LocalPlayer = Players.LocalPlayer
local v4, v5, v6, RunPulseScale
local v7 = {}
local v8 = HudVisibility.new()

local function getMainGui() -- line 58 | captures: LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v9 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if v9 and v9:IsA("ScreenGui") then
        return v9
    end
    return nil
end

local function recenterAnchor(v10) -- line 71 | captures: v3
    local AnchorPoint = v10.AnchorPoint
    if AnchorPoint == v3 then
        return
    end
    local Position = v10.Position
    local Size = v10.Size
    local v11 = 0.5 - AnchorPoint.X
    local v12 = 0.5 - AnchorPoint.Y
    v10.Position = UDim2.new(Position.X.Scale + Size.X.Scale * v11, Position.X.Offset + Size.X.Offset * v11, Position.Y.Scale + Size.Y.Scale * v12, Position.Y.Offset + Size.Y.Offset * v12)
    v10.AnchorPoint = v3
end

local function stopRunPulse() -- line 89 | captures: v6, RunPulseScale
    if v6 then
        v6:Cancel()
        v6 = nil
    end
    if RunPulseScale then
        if RunPulseScale.Parent then
            RunPulseScale.Scale = 1
        end
        RunPulseScale = nil
    end
end

local function startRunPulse(v13) -- line 105 | captures: v6, RunPulseScale, TweenService, recenterAnchor
    if v6 then
        v6:Cancel()
        v6 = nil
    end
    if RunPulseScale then
        if RunPulseScale.Parent then
            RunPulseScale.Scale = 1
        end
        RunPulseScale = nil
    end
    local Run = v13:FindFirstChild("Run")
    local RunPulseScale_2
    if Run and Run:IsA("GuiObject") then
        recenterAnchor(Run)
        RunPulseScale_2 = Run:FindFirstChild("RunPulseScale")
        if RunPulseScale_2 then
            if not RunPulseScale_2:IsA("UIScale") then
                RunPulseScale_2 = Instance.new("UIScale")
                RunPulseScale_2.Name = "RunPulseScale"
                RunPulseScale_2.Parent = Run
            end
        else
            RunPulseScale_2 = Instance.new("UIScale")
            RunPulseScale_2.Name = "RunPulseScale"
            RunPulseScale_2.Parent = Run
        end
    else
        return
    end
    RunPulseScale_2.Scale = 1
    RunPulseScale = RunPulseScale_2
    local v14 = TweenService:Create(RunPulseScale_2, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Scale = 1.15 })
    v6 = v14
    v14:Play()
end

local function stopPulse() -- line 131 | captures: v4, v5, v6, RunPulseScale
    if v4 then
        v4:Cancel()
        v4 = nil
    end
    if v6 then
        v6:Cancel()
        v6 = nil
    end
    if RunPulseScale then
        if RunPulseScale.Parent then
            RunPulseScale.Scale = 1
        end
        RunPulseScale = nil
    end
    if v5 then
        if v5.Parent then
            v5.Visible = false
            v5.ImageTransparency = 0.1
        end
        v5 = nil
    end
end

local function startPulse(v15) -- line 146 | captures: v4, v5, v6, RunPulseScale, TweenService, SettingsState, startRunPulse
    if v4 then
        v4:Cancel()
        v4 = nil
    end
    if v6 then
        v6:Cancel()
        v6 = nil
    end
    if RunPulseScale then
        if RunPulseScale.Parent then
            RunPulseScale.Scale = 1
        end
        RunPulseScale = nil
    end
    if v5 then
        if v5.Parent then
            v5.Visible = false
            v5.ImageTransparency = 0.1
        end
        v5 = nil
    end
    v5 = v15
    v15.Visible = true
    if SettingsState.Get("ScreenFFX") == true then
        v15.ImageTransparency = 0.1
        local v16 = TweenService:Create(v15, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { ImageTransparency = 0.8 })
        v4 = v16
        v16:Play()
    else
        v15.ImageTransparency = 1
    end
    startRunPulse(v15)
end

local v17

local function playAlertSound() -- line 174 | captures: v17, Debris, SoundService, NotificationConfig
    if not (v17 and v17.Parent) then
        v17 = SoundService:FindFirstChild(NotificationConfig.SoundFolderName)
    end
    local v18 = v17 and v17:FindFirstChild("Classic Surprise")
    if not (v18 and v18:IsA("Sound")) then
        return
    end
    local v19 = v18:Clone()
    v19.Parent = SoundService
    v19.Ended:Once(function() -- line 185 | captures: v19
        v19:Destroy()
    end)
    local TimeLength = v19.TimeLength
    Debris:AddItem(v19, math.max(TimeLength, 1) + 1)
    v19:Play()
end

local function setDropVisible(v20, v21) -- line 196
    local v22 = v20 and v20:FindFirstChild("Drop")
    if v22 and v22:IsA("GuiButton") then
        v22.Visible = v21
    end
end

local function shouldShowDrop() -- line 207 | captures: ChaseState, LocalPlayer
    return ChaseState.IsCarrying(LocalPlayer) or LocalPlayer:GetAttribute("CarryingJail") == true
end

local function applyOutline(v23) -- line 213 | captures: v4, v5, v6, RunPulseScale, ChaseState, LocalPlayer, startPulse
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v24 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if not (v24 and v24:IsA("ScreenGui")) then
        v24 = nil
    end
    local v25 = v23 or ChaseState.IsCarrying(LocalPlayer) or LocalPlayer:GetAttribute("CarryingJail") == true
    local v26 = v24 and v24:FindFirstChild("Drop")
    if v26 and v26:IsA("GuiButton") then
        v26.Visible = v25
    end
    if v23 then
        local v27 = v24 and v24:FindFirstChild("RedOutline")
        if v27 and v27:IsA("ImageLabel") then
            startPulse(v27)
        end
    else
        if v4 then
            v4:Cancel()
            v4 = nil
        end
        if v6 then
            v6:Cancel()
            v6 = nil
        end
        if RunPulseScale then
            if RunPulseScale.Parent then
                RunPulseScale.Scale = 1
            end
            RunPulseScale = nil
        end
        if v5 then
            if v5.Parent then
                v5.Visible = false
                v5.ImageTransparency = 0.1
            end
            v5 = nil
        end
    end
end

local function applyHud(v28) -- line 228 | captures: v2, LocalPlayer, v8
    if v28 then
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local v29 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
        if not (v29 and v29:IsA("ScreenGui")) then
            v29 = nil
        end
        if v29 then
            v8:HideChildren(v29, v2)
        end
    else
        v8:RestoreAll()
    end
end

local function requestDrop() -- line 242 | captures: ReplicatedStorage
    local DropCarriedRemote = ReplicatedStorage:FindFirstChild("DropCarriedRemote")
    if DropCarriedRemote and DropCarriedRemote:IsA("RemoteEvent") then
        DropCarriedRemote:FireServer()
    end
end

local function wireDropButton(v30) -- line 249 | captures: v7, requestDrop
    local Drop = v30:FindFirstChild("Drop")
    if not Drop or not Drop:IsA("GuiButton") or v7[Drop] then
        return
    end
    v7[Drop] = true
    Drop.Activated:Connect(requestDrop)
    Drop.Destroying:Connect(function() -- line 256 | captures: Drop, v7
        v7[Drop] = nil
    end)
end

local function onChaseChanged(v31) -- line 263 | captures: v2, LocalPlayer, v8, playAlertSound
    if v31 then
        playAlertSound()
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local v32 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
        if not (v32 and v32:IsA("ScreenGui")) then
            v32 = nil
        end
        if v32 then
            v8:HideChildren(v32, v2)
        end
    else
        v8:RestoreAll()
    end
end

function v1.Start() -- line 270 | captures: v5, ChaseState, SettingsState, LocalPlayer, startPulse, applyOutline, wireDropButton, onChaseChanged
    local function setupGui(v33) -- line 275 | captures: v5, ChaseState, LocalPlayer, startPulse, wireDropButton
        local v34 = ChaseState.IsCarrying(LocalPlayer)
        local RedOutline = v33:FindFirstChild("RedOutline")
        if RedOutline and RedOutline:IsA("ImageLabel") and RedOutline ~= v5 then
            if v34 then
                startPulse(RedOutline)
            else
                RedOutline.Visible = false
            end
        end
        local v35 = ChaseState.IsCarrying(LocalPlayer) or LocalPlayer:GetAttribute("CarryingJail") == true
        local v36 = v33 and v33:FindFirstChild("Drop")
        if v36 and v36:IsA("GuiButton") then
            v36.Visible = v35
        end
        wireDropButton(v33)
    end

    LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(function(v37) -- line 292 | captures: setupGui
        if v37.Name == "MainGUI" then
            task.defer(setupGui, v37)
        end
    end)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v38 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    if not (v38 and v38:IsA("ScreenGui")) then
        v38 = nil
    end
    if v38 then
        setupGui(v38)
    end
    ChaseState.ObserveCarrying(LocalPlayer, applyOutline)
    ChaseState.Observe(LocalPlayer, onChaseChanged)
    LocalPlayer:GetAttributeChangedSignal("CarryingJail"):Connect(function() -- line 307 | captures: ChaseState, LocalPlayer
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local v39 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
        if not (v39 and v39:IsA("ScreenGui")) then
            v39 = nil
        end
        local v40 = ChaseState.IsCarrying(LocalPlayer) or LocalPlayer:GetAttribute("CarryingJail") == true
        local v41 = v39 and v39:FindFirstChild("Drop")
        if v41 and v41:IsA("GuiButton") then
            v41.Visible = v40
        end
    end)
    SettingsState.Observe("ScreenFFX", function() -- line 313 | captures: v5, startPulse
        local v42 = v5
        if v42 and v42.Parent then
            startPulse(v42)
        end
    end)
end

return v1
