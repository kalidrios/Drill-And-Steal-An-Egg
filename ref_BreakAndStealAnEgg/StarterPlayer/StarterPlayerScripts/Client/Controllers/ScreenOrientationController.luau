-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local v1 = {}
local LandscapeSensor = Enum.ScreenOrientation.LandscapeSensor

function v1.Start() -- line 19 | captures: Players, LandscapeSensor
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    local function apply() -- line 22 | captures: PlayerGui, LandscapeSensor
        if PlayerGui.ScreenOrientation ~= LandscapeSensor then
            PlayerGui.ScreenOrientation = LandscapeSensor
        end
    end

    if PlayerGui.ScreenOrientation ~= LandscapeSensor then
        PlayerGui.ScreenOrientation = LandscapeSensor
    end
    PlayerGui:GetPropertyChangedSignal("ScreenOrientation"):Connect(apply)
end

return v1
