-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SettingsButtonConfig = require(ReplicatedStorage.Shared.SettingsButtonConfig)
local UiFrames = require(script.Parent.UiFrames)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local v2

local function waitForTopbarPlus() -- line 45 | captures: ReplicatedStorage
    local v3 = { "Satchel", "SatchelLoader", "Satchel", "Packages", "topbarplus" }
    local v4 = ReplicatedStorage
    for v5, v6 in v3 do
        local v7 = v4:WaitForChild(v6, 30)
        if v7 == nil then
            warn((("[SettingsButtonController] missing %*.%*"):format(v4:GetFullName(), v6)))
            return nil
        end
        v4 = v7
    end
    if v4:IsA("ModuleScript") then
        return v4
    end
    return nil
end

local function getIconImage(v8) -- line 65
    local v9, v10 = pcall(function() -- line 66 | captures: v8
        return v8:getInstance("IconImage")
    end)
    if v9 and typeof(v10) == "Instance" and v10:IsA("ImageLabel") then
        return v10
    end
    local widget = v8.widget
    if typeof(widget) == "Instance" then
        local v11 = widget:FindFirstChild("IconImage", true)
        if v11 and v11:IsA("ImageLabel") then
            return v11
        end
    end
    warn("[SettingsButtonController] icon ImageLabel not found; spin disabled")
    return nil
end

local function spin(v12) -- line 86 | captures: v2, TweenService, SettingsButtonConfig
    if v2 ~= nil then
        v2:Cancel()
    end
    v12.Rotation = 0
    local v13 = TweenService:Create(v12, TweenInfo.new(SettingsButtonConfig.SpinDuration, SettingsButtonConfig.SpinEasingStyle, SettingsButtonConfig.SpinEasingDirection), { Rotation = SettingsButtonConfig.SpinDegrees })
    v2 = v13
    v13.Completed:Once(function(v14) -- line 101 | captures: v12
        if v14 == Enum.PlaybackState.Completed then
            v12.Rotation = 0
        end
    end)
    v13:Play()
end

function v1.Start() -- line 109 | captures: SettingsButtonConfig, UiFrames, MainGui, waitForTopbarPlus, getIconImage, spin
    local v15 = waitForTopbarPlus()
    if v15 == nil then
        return
    end
    local v16 = require(v15).new()
    v16:setName("Settings")
    v16:setImage(SettingsButtonConfig.Image)
    v16:setImageScale(SettingsButtonConfig.ImageScale)
    v16:setCaption(SettingsButtonConfig.Caption)
    v16:align(SettingsButtonConfig.Alignment)
    v16:setOrder(SettingsButtonConfig.Order)
    local v17 = getIconImage(v16)
    local v18
    MainGui.Observe(function(v19) -- line 130 | captures: v18, v16, SettingsButtonConfig, UiFrames
        v18 = nil
        v16:deselect()
        local v20 = v19:WaitForChild("Frames", 30)
        local v21 = v20 and v20:WaitForChild(SettingsButtonConfig.FrameName, 30)
        if v21 and v21:IsA("GuiObject") then
            v18 = v21
            UiFrames.Observe(v21, function(v22) -- line 144 | captures: v21, v18, v16
                if v18 == v21 then
                    if v22 then
                        v16:select()
                    else
                        v16:deselect()
                    end
                end
            end)
        else
            warn((("[SettingsButtonController] MainGUI.Frames.%* missing"):format(SettingsButtonConfig.FrameName)))
        end
    end)
    v16.selected:Connect(function() -- line 156 | captures: v18, v17, UiFrames, spin
        if v17 then
            spin(v17)
        end
        if v18 then
            UiFrames.Open(v18)
        end
    end)
    v16.deselected:Connect(function() -- line 165 | captures: v18, v17, UiFrames, spin
        if v17 then
            spin(v17)
        end
        if v18 then
            UiFrames.Close(v18)
        end
    end)
end

return v1
