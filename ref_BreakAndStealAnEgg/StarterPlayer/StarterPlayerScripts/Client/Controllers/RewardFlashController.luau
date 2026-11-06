-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RewardFlashConfig = require(ReplicatedStorage.Shared.RewardFlashConfig)
local CameraFovController = require(script.Parent.CameraFovController)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local NumberValue = Instance.new("NumberValue")

NumberValue.Name = "RewardFlashFovOffset"
NumberValue.Value = 0
NumberValue.Changed:Connect(function() -- line 47 | captures: CameraFovController, NumberValue
    CameraFovController.Set("RewardFlash", NumberValue.Value)
end)
local v2 = {}

local function getHolder() -- line 56 | captures: RewardFlashConfig, LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local RewardFlashHolder = PlayerGui:FindFirstChild("RewardFlashHolder")
    if RewardFlashHolder ~= nil and RewardFlashHolder:IsA("ScreenGui") then
        return RewardFlashHolder
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RewardFlashHolder"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = RewardFlashConfig.DisplayOrder
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    return ScreenGui
end

local function cancelFovTweens() -- line 79 | captures: v2
    for v3, v4 in ipairs(v2) do
        v4:Cancel()
        v4:Destroy()
    end
    table.clear(v2)
end

function v1.Play() -- line 94 | captures: TweenService, RewardFlashConfig, CameraFovController, NumberValue, v2, getHolder, cancelFovTweens
    local Frame = Instance.new("Frame")
    Frame.Name = "RewardFlash"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Position = UDim2.fromScale(0, 0)
    Frame.BackgroundColor3 = RewardFlashConfig.Color
    Frame.BackgroundTransparency = 0
    Frame.BorderSizePixel = 0
    Frame.Parent = getHolder()
    local v5 = TweenInfo.new(RewardFlashConfig.FadeTime, RewardFlashConfig.FadeEasingStyle, RewardFlashConfig.FadeEasingDirection, 0, false, RewardFlashConfig.FadeDelay)
    local v6 = TweenService:Create(Frame, v5, { BackgroundTransparency = 1 })
    v6.Completed:Once(function() -- line 117 | captures: Frame
        Frame:Destroy()
    end)
    v6:Play()
    cancelFovTweens()
    local v7 = TweenService:Create(NumberValue, TweenInfo.new(RewardFlashConfig.FovOutTime, RewardFlashConfig.FovEasingStyle, RewardFlashConfig.FovEasingDirection, 0, false, RewardFlashConfig.FovOutDelay), { Value = RewardFlashConfig.FieldOfView - CameraFovController.GetOriginal() })
    local v8 = TweenService:Create(NumberValue, TweenInfo.new(RewardFlashConfig.FovReturnTime, RewardFlashConfig.FovEasingStyle, RewardFlashConfig.FovEasingDirection), { Value = 0 })
    v7.Completed:Once(function(v9) -- line 147 | captures: v8
        if v9 == Enum.PlaybackState.Completed then
            v8:Play()
        end
    end)
    v8.Completed:Once(function(v10) -- line 153 | captures: CameraFovController, NumberValue
        if v10 == Enum.PlaybackState.Completed then
            NumberValue.Value = 0
            CameraFovController.Clear("RewardFlash")
        end
    end)
    table.insert(v2, v7)
    table.insert(v2, v8)
    v7:Play()
end

function v1.Stop() -- line 166 | captures: CameraFovController, LocalPlayer, NumberValue, cancelFovTweens
    cancelFovTweens()
    NumberValue.Value = 0
    CameraFovController.Clear("RewardFlash")
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v11
    if PlayerGui then
        v11 = PlayerGui:FindFirstChild("RewardFlashHolder")
    end
    if v11 ~= nil then
        for v12, v13 in ipairs(v11:GetChildren()) do
            v13:Destroy()
        end
    end
end

return v1
