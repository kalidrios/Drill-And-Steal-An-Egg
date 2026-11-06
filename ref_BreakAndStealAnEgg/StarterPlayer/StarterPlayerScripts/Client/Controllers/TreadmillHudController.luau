-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HudVisibility = require(ReplicatedStorage.Shared.HudVisibility)
local TreadmillHudConfig = require(ReplicatedStorage.Shared.TreadmillHudConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = HudVisibility.new()
local v3 = false

function v1.IsActive() -- line 40 | captures: v3
    return v3
end

local function getHud(v4) -- line 44 | captures: TreadmillHudConfig, LocalPlayer
    local v5
    if v4 then
        v5 = v4
    else
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        v5 = PlayerGui and PlayerGui:FindFirstChild(TreadmillHudConfig.MainGui)
    end
    return v5 and v5:FindFirstChild(TreadmillHudConfig.Hud)
end

local function setTreadmillButtons(v6, v7) -- line 52 | captures: TreadmillHudConfig
    if v6 then
        for v8, v9 in TreadmillHudConfig.ShowDuringSession do
            local v10 = v6:FindFirstChild(v9)
            if v10 and v10:IsA("GuiObject") then
                v10.Visible = v7
            end
        end
    end
end

local function startSession() -- line 64 | captures: v3, TreadmillHudConfig, LocalPlayer, v2, setTreadmillButtons
    if v3 then
        return
    end
    v3 = true
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v11 = PlayerGui and PlayerGui:FindFirstChild(TreadmillHudConfig.MainGui)
    local v12 = v11 and v11:FindFirstChild(TreadmillHudConfig.Hud)
    v2:HideChildren(v12, TreadmillHudConfig.HideDuringSession)
    setTreadmillButtons(v12, true)
end

local function endSession() -- line 77 | captures: v3, TreadmillHudConfig, LocalPlayer, v2, setTreadmillButtons
    if not v3 then
        return
    end
    v3 = false
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v13 = PlayerGui and PlayerGui:FindFirstChild(TreadmillHudConfig.MainGui)
    local v14 = v13 and v13:FindFirstChild(TreadmillHudConfig.Hud)
    setTreadmillButtons(v14, false)
    v2:RestoreAll()
end

function v1.Start() -- line 89 | captures: v3, ReplicatedStorage, TreadmillHudConfig, LocalPlayer, v2, setTreadmillButtons, endSession
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local v15 = PlayerGui:WaitForChild(TreadmillHudConfig.MainGui, 30)
    local v16
    if v15 then
        v16 = v15
    else
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        v16 = PlayerGui and PlayerGui:FindFirstChild(TreadmillHudConfig.MainGui)
    end
    setTreadmillButtons(v16 and v16:FindFirstChild(TreadmillHudConfig.Hud), false)
    PlayerGui.ChildAdded:Connect(function(v17) -- line 97 | captures: v3, TreadmillHudConfig, LocalPlayer, v2, setTreadmillButtons
        local setTreadmillButtons_2, v18
        if v17.Name == TreadmillHudConfig.MainGui and v17:IsA("ScreenGui") then
            v3 = false
            v2:RestoreAll()
            setTreadmillButtons_2 = setTreadmillButtons
            if v17 then
                v18 = v17
            else
                local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                v18 = PlayerGui and PlayerGui:FindFirstChild(TreadmillHudConfig.MainGui)
            end
        else
            return
        end
        setTreadmillButtons_2(v18 and v18:FindFirstChild(TreadmillHudConfig.Hud), false)
    end)
    local v19 = ReplicatedStorage:WaitForChild("TreadmillSessionRemote", 30)
    if v19 and v19:IsA("RemoteEvent") then
        v19.OnClientEvent:Connect(function(v20) -- line 112 | captures: v3, TreadmillHudConfig, LocalPlayer, v2, setTreadmillButtons
            if typeof(v20) == "number" then
                if not v3 then
                    v3 = true
                    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    local v21 = PlayerGui and PlayerGui:FindFirstChild(TreadmillHudConfig.MainGui)
                    local v22 = v21 and v21:FindFirstChild(TreadmillHudConfig.Hud)
                    v2:HideChildren(v22, TreadmillHudConfig.HideDuringSession)
                    setTreadmillButtons(v22, true)
                end
            elseif v3 then
                v3 = false
                local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                local v23 = PlayerGui and PlayerGui:FindFirstChild(TreadmillHudConfig.MainGui)
                local v24 = v23 and v23:FindFirstChild(TreadmillHudConfig.Hud)
                setTreadmillButtons(v24, false)
                v2:RestoreAll()
            end
        end)
        LocalPlayer.CharacterAdded:Connect(endSession)
    else
        warn("[TreadmillHudController] TreadmillSessionRemote missing")
    end
end

return v1
