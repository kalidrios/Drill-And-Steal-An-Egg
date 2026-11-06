-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminConchTypes = require(ReplicatedStorage.Shared.AdminConchTypes)
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local conch = require(ReplicatedStorage.Shared.Packages.conch)
local ui = require(ReplicatedStorage.Shared.Packages.ui)
local AdminRawText = require(script.Parent.Parent.Modules.AdminRawText)
local v1 = {}

local function waitForVerdict(v2) -- line 33 | captures: AdminConfig
    local v3 = v2:GetAttribute(AdminConfig.Attribute)
    while v3 == nil do
        v2:GetAttributeChangedSignal(AdminConfig.Attribute):Wait()
        v3 = v2:GetAttribute(AdminConfig.Attribute)
    end
    return v3 == true
end

local function keepAcrossRespawns(v4) -- line 45
    task.spawn(function() -- line 46 | captures: v4
        local v5 = v4:WaitForChild("PlayerGui"):WaitForChild("Command Executor", 10)
        if v5 and v5:IsA("ScreenGui") then
            v5.ResetOnSpawn = false
            v5.IgnoreGuiInset = true
        end
    end)
end

function v1.Start() -- line 56 | captures: Players, AdminConchTypes, AdminConfig, conch, ui, AdminRawText, waitForVerdict
    local LocalPlayer = Players.LocalPlayer
    if not waitForVerdict(LocalPlayer) then
        return
    end
    AdminConchTypes.Register(conch)
    conch.initiate_default_lifecycle()
    conch.register_default_commands()
    AdminRawText.Install(conch)
    ui.bind_to(AdminConfig.Keybind)
    task.spawn(function() -- line 46 | captures: LocalPlayer
        local v6 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Command Executor", 10)
        if v6 and v6:IsA("ScreenGui") then
            v6.ResetOnSpawn = false
            v6.IgnoreGuiInset = true
        end
    end)
    print((("[admin] console ready \226\128\148 press %* to open, or type %*cmds in chat"):format(AdminConfig.Keybind.Name, AdminConfig.ChatPrefix)))
end

return v1
