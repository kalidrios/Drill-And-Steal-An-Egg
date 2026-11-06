-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FriendBoostConfig = require(ReplicatedStorage.Shared.FriendBoostConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2

local function refresh() -- line 33 | captures: v2, FriendBoostConfig, LocalPlayer
    local v3 = v2
    if v3 and v3.Parent then
        local v4 = LocalPlayer:GetAttribute(FriendBoostConfig.AttributeName)
        if typeof(v4) ~= "number" or v4 <= 0 then
            v3.Visible = false
        else
            v3.RichText = true
            v3.Text = ("Friend Boost: <font color=\"%*\">+%*%%</font>"):format(FriendBoostConfig.TagColor, v4)
            v3.Visible = true
        end
    end
end

local function bind(v5) -- line 50 | captures: v2, FriendBoostConfig, LocalPlayer
    local Currencies = v5:FindFirstChild("Currencies")
    local v6 = Currencies and Currencies:FindFirstChild("Friend Boost")
    if v6 and v6:IsA("TextLabel") then
        v2 = v6
        local v7 = v2
        if v7 then
            local v8
            if v7.Parent then
                v8 = LocalPlayer:GetAttribute(FriendBoostConfig.AttributeName)
                if typeof(v8) ~= "number" or v8 <= 0 then
                    v7.Visible = false
                    return
                end
            else
                return
            end
            v7.RichText = true
            v7.Text = ("Friend Boost: <font color=\"%*\">+%*%%</font>"):format(FriendBoostConfig.TagColor, v8)
            v7.Visible = true
        end
    else
        warn("[FriendBoostController] missing MainGUI.Currencies.Friend Boost")
    end
end

function v1.Start() -- line 61 | captures: v2, FriendBoostConfig, MainGui, LocalPlayer, refresh, bind
    LocalPlayer:GetAttributeChangedSignal(FriendBoostConfig.AttributeName):Connect(refresh)
    LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(function(v9) -- line 65 | captures: bind
        if v9.Name == "MainGUI" and v9:IsA("ScreenGui") then
            bind(v9)
        end
    end)
    local v10 = MainGui.Wait()
    if v2 == nil then
        bind(v10)
    end
end

return v1
