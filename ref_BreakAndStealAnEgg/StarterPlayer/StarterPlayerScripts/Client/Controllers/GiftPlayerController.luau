-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PaidRandomItemsConfig = require(ReplicatedStorage.Shared.PaidRandomItemsConfig)
local RobuxShopConfig = require(ReplicatedStorage.Shared.RobuxShopConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local ProductPrompt = require(script.Parent.Parent.Modules.ProductPrompt)
local NotificationController = require(script.Parent.NotificationController)
local RobuxPurchase = require(script.Parent.RobuxPurchase)
local UiFrames = require(script.Parent.UiFrames)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2, v3, v4, Nobody, v5, v6, v7, v8
local v9 = false

local function getRemote() -- line 75 | captures: v8, ReplicatedStorage, RobuxShopConfig
    if v8 and v8.Parent then
        return v8
    end
    local v10 = ReplicatedStorage:FindFirstChild(RobuxShopConfig.GiftIntentRemoteName)
    if not (v10 and v10:IsA("RemoteEvent")) then
        return nil
    end
    v8 = v10
    return v10
end

local function onSelect(v11) -- line 91 | captures: v2, v5, v6, v7, v8, v9, Players, ReplicatedStorage, PaidRandomItemsConfig, RobuxShopConfig, NotificationController, RobuxPurchase, UiFrames, LocalPlayer
    local v12 = v5
    local v13 = v2
    if not v12 or not v13 or not (v11.Parent == Players) then
        return
    end
    if v6 then
        local v14
        v12, v14 = v6(v11)
        if not v12 then
            NotificationController.Show(v14 or ("%* can't get that!"):format(v11.DisplayName), "Error")
            return
        end
    end
    local v15 = RobuxShopConfig.OneTimeAttributeFor(v12)
    if v15 and v11:GetAttribute(v15) == true then
        NotificationController.Show(("%* already owns that!"):format(v11.DisplayName), "Error")
    else
        if PaidRandomItemsConfig.IsPaidRandomProduct(v12) then
            if PaidRandomItemsConfig.IsRestricted(LocalPlayer) then
                NotificationController.ShowPreset(PaidRandomItemsConfig.Presets.Restricted)
                return
            end
            if PaidRandomItemsConfig.IsRestricted(v11) then
                NotificationController.ShowPreset(PaidRandomItemsConfig.Presets.GiftRecipientRestricted, v11.DisplayName)
                return
            end
        end
        local v16
        if not (v8 and v8.Parent) then
            v16 = ReplicatedStorage:FindFirstChild(RobuxShopConfig.GiftIntentRemoteName)
            if not (v16 and v16:IsA("RemoteEvent")) then
                v16 = nil
            else
                v8 = v16
            end
        else
            v16 = v8
        end
        local v17 = ReplicatedStorage:FindFirstChild(RobuxShopConfig.GiftRequestRemoteName)
        if v16 and v17 and v17:IsA("RemoteFunction") then
            if not v9 then
                v9 = true
                local v18, v19, v20 = pcall(v17.InvokeServer, v17, v12, v11.UserId)
                v9 = false
                if not (v18 and typeof(v19) == "number") then
                    if not v18 then
                        warn((("[GiftPlayerController] gift request failed: %*"):format(v19)))
                        v20 = "Couldn't send the gift \226\128\148 try again."
                    end
                    if typeof(v20) == "string" then
                        NotificationController.Show(v20, "Error")
                    end
                elseif v2 == v13 and UiFrames.IsOpen(v13) then
                    v7 = v19
                    v5 = nil
                    v6 = nil
                    UiFrames.Close(v13)
                    if not RobuxPurchase.Prompt(v19) then
                        v7 = nil
                        v16:FireServer(v19, nil)
                        NotificationController.Show("Couldn't open the purchase prompt.", "Error")
                    end
                else
                    v16:FireServer(v19, nil)
                end
            end
        else
            warn("[GiftPlayerController] gift remotes missing \226\128\148 is GiftService running?")
            NotificationController.Show("Gifting isn't available right now.", "Error")
        end
    end
end

local function clearRows(v21) -- line 184
    for v22, v23 in v21:GetChildren() do
        if v23:GetAttribute("GiftPlayerEntry") then
            v23:Destroy()
        end
    end
end

local function populate(v24) -- line 195 | captures: v3, v4, Nobody, Players, LocalPlayer, onSelect, clearRows
    local v25 = v3
    local v26 = v4
    if not v25 or not v26 then
        return 0
    end
    clearRows(v25)
    local v27 = v25.AbsoluteSize.Y * v26.Size.Y.Scale
    local v28 = math.round(v27)
    local v29 = 0
    for v30, v31 in Players:GetPlayers() do
        if v31 ~= LocalPlayer and v31 ~= v24 then
            v29 += 1
            local v32 = v26:Clone()
            v32.Name = ("Player_%*"):format(v31.UserId)
            v32:SetAttribute("GiftPlayerEntry", true)
            v32.LayoutOrder = v29
            if v28 > 0 then
                v32.Size = UDim2.new(v26.Size.X.Scale, v26.Size.X.Offset, 0, v28)
            end
            local Container = v32:FindFirstChild("Container")
            local v33, v34, v35
            if Container then
                v33 = Container:FindFirstChild("DisplayName")
                v34 = Container:FindFirstChild("Name")
                v35 = Container:FindFirstChild("PlayerDisplay")
                Container = Container:FindFirstChild("Select")
            else
                v33 = Container
                v34 = Container
                v35 = Container
            end
            if v33 and v33:IsA("TextLabel") then
                v33.Text = v31.DisplayName
            end
            if v34 and v34:IsA("TextLabel") then
                v34.Text = "@" .. v31.Name
            end
            if v35 and v35:IsA("ImageLabel") then
                v35.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(v31.UserId)
            end
            if Container and Container:IsA("GuiButton") then
                local Activated = Container.Activated
                local v36 = v31
                Activated:Connect(function() -- line 241 | captures: v36, onSelect
                    onSelect(v36)
                end)
            end
            v32.Visible = true
            v32.Parent = v25
        end
    end
    if Nobody then
        Nobody.Visible = v29 == 0
    end
    return v29
end

local function refreshIfOpen(v37) -- line 260 | captures: v2, UiFrames, populate
    local v38 = v2
    if v38 and UiFrames.IsOpen(v38) then
        populate(v37)
    end
end

function v1.Open(v39, v40) -- line 276 | captures: v2, v5, v6, UiFrames, populate
    local v41 = v2
    if v41 then
        v5 = v39
        v6 = v40
        populate(nil)
        UiFrames.OpenOver(v41)
    else
        warn("[GiftPlayerController] GiftPlayer window missing \226\128\148 can't gift")
    end
end

function v1.Start() -- line 291 | captures: v2, v3, v4, Nobody, v5, v6, v7, v8, Players, ReplicatedStorage, RobuxShopConfig, MainGui, ProductPrompt, UiFrames, LocalPlayer, populate
    MainGui.Observe(function(v42) -- line 293 | captures: v2, v3, v4, Nobody, v5, v6, UiFrames
        local Frames = v42:FindFirstChild("Frames")
        local v43 = Frames and Frames:FindFirstChild("GiftPlayer")
        local v44 = v43 and v43:FindFirstChild("PlayerList")
        local v45 = v44 and v44:FindFirstChild("Template")
        if v43 and v43:IsA("GuiObject") and v44 and v44:IsA("ScrollingFrame") and v45 and v45:IsA("GuiObject") then
            v2 = v43
            v3 = v44
            v4 = v45
            v5 = nil
            v6 = nil
            v43.Visible = false
            v45.Visible = false
            local Nobody_2 = v44:FindFirstChild("Nobody")
            if Nobody_2 then
                if not Nobody_2:IsA("GuiObject") then
                    Nobody_2 = nil
                end
            else
                Nobody_2 = nil
            end
            Nobody = Nobody_2
            if Nobody then
                Nobody.Visible = false
            end
            v44.CanvasSize = UDim2.new()
            v44.AutomaticCanvasSize = Enum.AutomaticSize.Y
            v44.ScrollingDirection = Enum.ScrollingDirection.Y
            local UIListLayout = v44:FindFirstChildOfClass("UIListLayout")
            if UIListLayout then
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                if UIListLayout.Padding.Scale ~= 0 then
                    task.spawn(function() -- line 333 | captures: v44, UIListLayout
                        for v46 = 1, 60 do
                            if v44.AbsoluteSize.Y > 0 then
                                break
                            end
                            task.wait()
                        end
                        local new = UDim.new
                        local v47 = v44.AbsoluteSize.Y * UIListLayout.Padding.Scale
                        UIListLayout.Padding = new(0, math.round(v47) + UIListLayout.Padding.Offset)
                    end)
                end
            end
            UiFrames.Observe(v43, function(v48) -- line 350 | captures: v5, v6
                if not v48 then
                    v5 = nil
                    v6 = nil
                end
            end)
        else
            warn("[GiftPlayerController] MainGUI.Frames.GiftPlayer.PlayerList.Template not found")
            v2 = nil
            v3 = nil
            v4 = nil
            Nobody = nil
        end
    end)
    Players.PlayerAdded:Connect(function() -- line 358 | captures: v2, UiFrames, populate
        local v49 = v2
        if v49 then
            if not UiFrames.IsOpen(v49) then
                return
            end
            populate(nil)
        end
    end)
    Players.PlayerRemoving:Connect(function(v50) -- line 361 | captures: v2, UiFrames, populate
        local v51 = v2
        if v51 then
            if not UiFrames.IsOpen(v51) then
                return
            end
            populate(v50)
        end
    end)
    ProductPrompt.Finished:Connect(function(v52, v53, v54) -- line 370 | captures: v7, v8, ReplicatedStorage, RobuxShopConfig, LocalPlayer
        if not (v52 == LocalPlayer.UserId and v7 == v53) then
            return
        end
        v7 = nil
        if not v54 then
            if v8 and v8.Parent then
                local v55 = v8
                if v55 then
                    v55:FireServer(v53, nil)
                end
            else
                local v56 = ReplicatedStorage:FindFirstChild(RobuxShopConfig.GiftIntentRemoteName)
                if v56 and v56:IsA("RemoteEvent") then
                    v8 = v56
                    v56:FireServer(v53, nil)
                end
            end
        end
    end)
end

return v1
