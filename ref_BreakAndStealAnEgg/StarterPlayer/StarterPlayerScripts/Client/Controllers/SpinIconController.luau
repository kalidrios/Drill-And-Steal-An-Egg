-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UiSpinConfig = require(ReplicatedStorage.Shared.UiSpinConfig)
local UiSpinFX = require(ReplicatedStorage.Shared.UiSpinFX)
local v1 = {}
local LocalPlayer = Players.LocalPlayer

local function resolve(v2, v3) -- line 31
    local v4 = v2
    for v5, v6 in v3 do
        v4 = v4 and v4:FindFirstChild(v6)
        if not v4 then
            return nil
        end
    end
    if v4 and (v4:IsA("GuiObject") or v4:IsA("UIGradient")) then
        return v4
    end
    return nil
end

local function bind(v7) -- line 45 | captures: UiSpinConfig, UiSpinFX, resolve
    for v8, v9 in UiSpinConfig.Targets do
        local v10 = resolve(v7, v9.Path)
        if v10 then
            UiSpinFX.Attach(v10, v9.DegreesPerSecond)
        else
            warn((("[SpinIconController] missing MainGUI.%*"):format((table.concat(v9.Path, ".")))))
        end
    end
end

function v1.Start() -- line 56 | captures: LocalPlayer, bind
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local v11 = PlayerGui:WaitForChild("MainGUI", 30)
    if v11 then
        bind(v11)
    end
    PlayerGui.ChildAdded:Connect(function(v12) -- line 64 | captures: bind
        if v12.Name == "MainGUI" and v12:IsA("ScreenGui") then
            bind(v12)
        end
    end)
end

return v1
