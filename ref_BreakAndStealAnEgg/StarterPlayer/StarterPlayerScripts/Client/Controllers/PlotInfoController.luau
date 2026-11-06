-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ZonesConfig = require(ReplicatedStorage.Shared.ZonesConfig)
local SafeZoneQuery = require(ReplicatedStorage.Shared.SafeZoneQuery)
local LocalCharacter = require(script.Parent.Parent.Modules.LocalCharacter)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}

local function refreshOwnerView(v3) -- line 35 | captures: LocalPlayer
    local OwnerUserId = v3.Model:GetAttribute("OwnerUserId")
    local v4 = OwnerUserId == LocalPlayer.UserId
    if OwnerUserId == nil then
        if v3.Ui.Enabled then
            v3.Ui.Enabled = false
        end
    else
        local PlayerIcon = v3.Ui:FindFirstChild("PlayerIcon")
        if PlayerIcon and PlayerIcon:IsA("ImageLabel") then
            PlayerIcon.Visible = not v4
        end
        local HomeIcon = v3.Ui:FindFirstChild("HomeIcon")
        if HomeIcon and HomeIcon:IsA("ImageLabel") then
            HomeIcon.Visible = v4
        end
        if v4 then
            local Name = v3.Ui:FindFirstChild("Name")
            if Name and Name:IsA("TextLabel") then
                Name.Text = "Your Base"
            end
        end
    end
end

local function trackPlotNow(v5) -- line 68 | captures: LocalPlayer, v2, refreshOwnerView
    local v6 = v5:WaitForChild("Hitbox", 30)
    if not (v6 and v6:IsA("BasePart")) then
        return
    end
    local v7 = v6:WaitForChild("PlayerInfoUi", 30)
    local v8
    if v7 and v7:IsA("BillboardGui") then
        v8 = {
            Model = v5,
            Hitbox = v6,
            Ui = v7
        }
        v8.Claimed = v5:GetAttribute("OwnerUserId") ~= nil
    else
        return
    end
    table.insert(v2, v8)
    refreshOwnerView(v8)
    local OwnerUserId = v5:GetAttributeChangedSignal("OwnerUserId")
    local v9 = v8
    OwnerUserId:Connect(function() -- line 89 | captures: v5, v9, refreshOwnerView
        v9.Claimed = v5:GetAttribute("OwnerUserId") ~= nil
        refreshOwnerView(v9)
    end)
    local Name = v7:FindFirstChild("Name")
    if not (Name and Name:IsA("TextLabel")) then
        return
    end
    local Text = Name:GetPropertyChangedSignal("Text")
    Text:Connect(function() -- line 101 | captures: v9, Name, LocalPlayer, refreshOwnerView
        if v9.Model:GetAttribute("OwnerUserId") == LocalPlayer.UserId and Name.Text ~= "Your Base" then
            refreshOwnerView(v9)
        end
    end)
end

local function trackPlot(v10) -- line 112 | captures: trackPlotNow
    task.spawn(trackPlotNow, v10)
end

local IsPositionInPart = SafeZoneQuery.IsPositionInPart

function v1.Start() -- line 119 | captures: RunService, Workspace, ZonesConfig, LocalCharacter, v2, trackPlotNow, trackPlot, IsPositionInPart
    local v11 = Workspace:WaitForChild(ZonesConfig.PlotsFolderName, 10)
    if v11 then
        for v12, v13 in v11:GetChildren() do
            task.spawn(trackPlotNow, v13)
        end
        v11.ChildAdded:Connect(trackPlot)
        RunService.Heartbeat:Connect(function() -- line 136 | captures: LocalCharacter, v2, IsPositionInPart
            local v14 = LocalCharacter.GetPosition()
            local v15 = #v2
            for v16 = v15, 1, -1 do
                local v17 = v2[v16]
                if v17.Ui.Parent and v17.Hitbox.Parent then
                    local Claimed = v17.Claimed
                    if Claimed then
                        if v14 == nil then
                            Claimed = true
                        else
                            Claimed = not IsPositionInPart(v17.Hitbox, v14)
                        end
                    end
                    if v17.Ui.Enabled ~= Claimed then
                        v17.Ui.Enabled = Claimed
                    end
                else
                    table.remove(v2, v16)
                end
            end
        end)
    else
        warn("[PlotInfoController] Workspace.Plots not found")
    end
end

return v1
