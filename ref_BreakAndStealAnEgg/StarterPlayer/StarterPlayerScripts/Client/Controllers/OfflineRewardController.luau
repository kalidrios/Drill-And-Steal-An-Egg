-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local OfflineRewardConfig = require(ReplicatedStorage.Shared.OfflineRewardConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local RewardIcons = require(script.Parent.Parent.Modules.RewardIcons)
local NewItemController = require(script.Parent.NewItemController)
local RobuxPurchase = require(script.Parent.RobuxPurchase)
local UiFrames = require(script.Parent.UiFrames)
local v1 = {}
local v2, v3, v4, v5
local v6 = 0
local v7 = false

local function cashText(v8) -- line 48 | captures: FormatNumber
    return (("$%*"):format((FormatNumber.Short(v8))))
end

local function applyState(v9) -- line 52 | captures: v3, v4, v5, v6, v7, FormatNumber, UiFrames
    if v3 then
        if v9 <= 0 then
            v6 = 0
            v7 = false
            UiFrames.Close(v3)
        else
            local v10 = ("$%*"):format((FormatNumber.Short(v9)))
            if v4 then
                v4.Text = v10
            end
            if v5 then
                v5.Text = "Claim"
            end
            if v9 ~= v6 then
                v6 = v9
                v7 = false
                UiFrames.Open(v3)
            end
        end
    else
        v6 = math.max(v9, 0)
    end
end

local function showClaimPopup(v11) -- line 83 | captures: FormatNumber, RewardIcons, NewItemController
    local v12 = RewardIcons.Cash()
    if v11 > 0 and v12 then
        NewItemController.Show({
            {
                Icon = v12,
                Count = v11,
                Text = ("$%*"):format((FormatNumber.Short(v11)))
            }
        })
    end
end

local function findTextLabel(v13, v14) -- line 90
    local v15 = v13 and v13:FindFirstChild(v14)
    if v15 and v15:IsA("TextLabel") then
        return v15
    end
    return nil
end

local function adopt(v16) -- line 98 | captures: v2, v3, v4, v5, v6, v7, FormatNumber, OfflineRewardConfig, RobuxPurchase, UiFrames
    local Frames = v16:FindFirstChild("Frames")
    local v17 = Frames and Frames:FindFirstChild(OfflineRewardConfig.FrameName)
    if v17 and v17:IsA("GuiObject") then
        v3 = v17
        v17.Visible = false
        local v18 = v17:FindFirstChild(OfflineRewardConfig.AmountLabelName)
        if not (v18 and v18:IsA("TextLabel")) then
            v18 = nil
        end
        v4 = v18
        local v19 = v17:FindFirstChild(OfflineRewardConfig.ClaimButtonName)
        if v19 and v19:IsA("GuiButton") then
            local v20 = v19:FindFirstChild(OfflineRewardConfig.ButtonTextName)
            if not (v20 and v20:IsA("TextLabel")) then
                v20 = nil
            end
            v5 = v20
            v19.Activated:Connect(function() -- line 116 | captures: v2, v6, v7
                if v7 or v6 <= 0 or not v2 then
                    return
                end
                v7 = true
                v2:FireServer("Claim")
                task.delay(3, function() -- line 125 | captures: v7
                    v7 = false
                end)
            end)
        end
        local v21 = v17:FindFirstChild(OfflineRewardConfig.RobuxButtonName)
        if v21 and v21:IsA("GuiButton") then
            RobuxPurchase.Bind(v21, OfflineRewardConfig.DevProductId, OfflineRewardConfig.ButtonTextName)
        end
        if v6 > 0 then
            if v4 then
                local v22 = v4
                local v23 = v6
                v22.Text = ("$%*"):format((FormatNumber.Short(v23)))
            end
            if v5 then
                v5.Text = "Claim"
            end
            UiFrames.Open(v17)
        end
    else
        v3 = nil
        v4 = nil
        v5 = nil
        warn("[OfflineRewardController] MainGUI.Frames.OfflineRewards not found")
    end
end

function v1.Start() -- line 150 | captures: v2, ReplicatedStorage, OfflineRewardConfig, MainGui, applyState, showClaimPopup, adopt
    MainGui.Observe(adopt)
    local v24 = ReplicatedStorage:WaitForChild(OfflineRewardConfig.RemoteName, 30)
    if not (v24 and v24:IsA("RemoteEvent")) then
        return
    end
    v2 = v24
    v24.OnClientEvent:Connect(function(v25, v26) -- line 159 | captures: applyState, showClaimPopup
        if typeof(v26) == "table" then
            if v25 == "State" then
                local Cash = v26.Cash
                applyState(tonumber(Cash) or 0)
            elseif v25 == "Claimed" then
                local Cash = v26.Cash
                showClaimPopup(tonumber(Cash) or 0)
            end
        end
    end)
    v24:FireServer("Get")
end

return v1
