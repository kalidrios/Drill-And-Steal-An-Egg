-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local AdminEditDropdown = require(script.Parent.Parent.Modules.AdminEditDropdown)
local AdminPanelAnnounce = require(script.Parent.Parent.Modules.AdminPanelAnnounce)
local AdminPanelBoosts = require(script.Parent.Parent.Modules.AdminPanelBoosts)
local AdminPanelGifting = require(script.Parent.Parent.Modules.AdminPanelGifting)
local AdminPanelBossSpawn = require(script.Parent.Parent.Modules.AdminPanelBossSpawn)
local AdminPanelEvents = require(script.Parent.Parent.Modules.AdminPanelEvents)
local AdminPanelEventRsvp = require(script.Parent.Parent.Modules.AdminPanelEventRsvp)
local AdminPanelPoll = require(script.Parent.Parent.Modules.AdminPanelPoll)
local AdminPanelTitanicEgg = require(script.Parent.Parent.Modules.AdminPanelTitanicEgg)
local AdminPanelTreadmill = require(script.Parent.Parent.Modules.AdminPanelTreadmill)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local UiFrames = require(script.Parent.UiFrames)
local LocalPlayer = Players.LocalPlayer
local v1 = {}

local function waitForVerdict() -- line 74 | captures: AdminConfig, LocalPlayer
    local v2 = LocalPlayer:GetAttribute(AdminConfig.PanelAttribute)
    while v2 == nil do
        LocalPlayer:GetAttributeChangedSignal(AdminConfig.PanelAttribute):Wait()
        v2 = LocalPlayer:GetAttribute(AdminConfig.PanelAttribute)
    end
    return v2 == true
end

local function findPanel(v3) -- line 83 | captures: AdminConfig
    local LeftHUD = v3:FindFirstChild("LeftHUD")
    local Frames = v3:FindFirstChild("Frames")
    local v4 = LeftHUD and LeftHUD:FindFirstChild(AdminConfig.PanelButtonName)
    local v5 = Frames and Frames:FindFirstChild(AdminConfig.PanelFrameName)
    if not (v4 and v4:IsA("GuiButton")) then
        v4 = nil
    end
    if not (v5 and v5:IsA("GuiObject")) then
        return v4, nil
    end
    return v4, v5
end

local function findAdminWindows(v6) -- line 93 | captures: AdminConfig
    local Frames = v6:FindFirstChild("Frames")
    local v7 = {}
    for v8, v9 in AdminConfig.AdminOnlyFrames do
        local v10 = Frames and Frames:FindFirstChild(v9)
        if v10 and v10:IsA("GuiObject") then
            table.insert(v7, v10)
        end
    end
    return v7
end

local function waitForChild(v11, v12) -- line 107
    local v13 = v11:FindFirstChild(v12)
    if v13 then
        return v13
    end
    local v14 = false
    task.delay(15, function() -- line 113 | captures: v14, v11, v12
        if not v14 then
            warn((("[AdminPanelController] still waiting for %*.%* from the server (AdminUiService)"):format(v11.Name, v12)))
        end
    end)
    while not v13 do
        v11.ChildAdded:Wait()
        v13 = v11:FindFirstChild(v12)
    end
    v14 = true
    return v13
end

local function removeAll(v15) -- line 128 | captures: UiFrames, findPanel, findAdminWindows
    local v16, v17 = findPanel(v15)
    local v18 = findAdminWindows(v15)
    for v19, v20 in {
            v17,
            table.unpack(v18)
        } do
        if v20 then
            if UiFrames.IsOpen(v20) then
                UiFrames.Close(v20)
            end
            v20:Destroy()
        end
    end
    if v16 then
        v16:Destroy()
    end
end

local function adopt(v21) -- line 143 | captures: AdminConfig, AdminEditDropdown, AdminPanelAnnounce, AdminPanelBoosts, AdminPanelGifting, AdminPanelBossSpawn, AdminPanelEvents, AdminPanelEventRsvp, AdminPanelPoll, AdminPanelTitanicEgg, AdminPanelTreadmill, UiFrames, LocalPlayer, waitForVerdict, findPanel, findAdminWindows, waitForChild, removeAll
    if waitForVerdict() then
        local LeftHUD = v21:FindFirstChild("LeftHUD")
        local Frames = v21:FindFirstChild("Frames")
        if not LeftHUD or not Frames then
            warn("[AdminPanelController] MainGUI.LeftHUD / MainGUI.Frames missing")
        else
            waitForChild(Frames, AdminConfig.PanelFrameName)
            for v22, v23 in AdminConfig.AdminOnlyFrames do
                waitForChild(Frames, v23)
            end
            waitForChild(LeftHUD, AdminConfig.PanelButtonName)
            if LocalPlayer:GetAttribute(AdminConfig.PanelAttribute) == true and v21.Parent then
                local v24, v25 = findPanel(v21)
                for v26, v27 in findAdminWindows(v21) do
                    v27.Visible = false
                end
                if v25 then
                    v25.Visible = false
                end
                if v24 and v25 then
                    local v28 = {}
                    local v29 = {}
                    local v30 = {}
                    local v31 = { __mode = "k" }
                    local v32 = setmetatable(v30, v31)

                    local function bindCard(v33) -- line 187 | captures: v21, v25, v28, v29, v32, AdminConfig, AdminEditDropdown, AdminPanelAnnounce, AdminPanelBoosts, AdminPanelGifting, AdminPanelBossSpawn, AdminPanelEvents, AdminPanelEventRsvp, AdminPanelPoll, AdminPanelTitanicEgg, AdminPanelTreadmill
                        local Container = v33:FindFirstChild("Container")
                        if not Container or v32[v33] then
                            return
                        end
                        v32[v33] = true
                        for v34, v35 in { "Edit", "Select" } do
                            local v36 = Container:FindFirstChild(v35)
                            if v36 and v36:IsA("GuiButton") then
                                v36:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
                                v36:SetAttribute("PressScale", AdminConfig.PanelPressScale)
                            end
                        end
                        local Scope = v33:GetAttribute("Scope")
                        local Bind = AdminEditDropdown.Bind
                        if type(Scope) ~= "string" then
                            Scope = AdminConfig.PanelDefaultScope
                        end
                        local v37 = Bind(Container, Scope, function(v38) -- line 205 | captures: v33
                            v33:SetAttribute("Scope", v38)
                        end)
                        if v37 then
                            v33:SetAttribute("Scope", v37.GetValue())
                            table.insert(v28, v37)
                        end
                        if v33.Name == AdminConfig.PanelCards.Announce then
                            AdminPanelAnnounce.Bind(v33, Container)
                        elseif v33.Name == AdminConfig.PanelCards.Poll then
                            AdminPanelPoll.Bind(v33, Container, v21)
                        elseif v33.Name == AdminConfig.PanelCards.BossSpawn then
                            AdminPanelBossSpawn.Bind(v33, Container)
                        elseif v33.Name == AdminConfig.PanelCards.Treadmill then
                            AdminPanelTreadmill.Bind(v33, Container)
                        elseif v33.Name == AdminConfig.PanelCards.Hell then
                            AdminPanelEvents.BindHell(v33, Container)
                        elseif v33.Name == AdminConfig.PanelCards.AdminAbuse then
                            AdminPanelEvents.BindAdminAbuse(v33, Container)
                        elseif v33.Name == AdminConfig.PanelCards.GlobalBoost then
                            AdminPanelBoosts.Bind(v33, Container)
                        elseif v33.Name == AdminConfig.PanelCards.TitanicEgg then
                            local v39 = AdminPanelTitanicEgg.Bind(v33, Container)
                            if v39 then
                                table.insert(v28, v39)
                            end
                        elseif v33.Name == AdminConfig.PanelCards.EventRsvp then
                            AdminPanelEventRsvp.Bind(v33, Container)
                        elseif v33.Name == AdminConfig.PanelCards.Gift then
                            local v40 = AdminPanelGifting.Bind(v33, Container, v25)
                            for v41, v42 in v40.Dropdowns do
                                table.insert(v28, v42)
                            end
                            local Reset = v40.Reset
                            table.insert(v29, Reset)
                        end
                    end

                    local CommandsList = v25:FindFirstChild("CommandsList")
                    if CommandsList then
                        for v43, v44 in CommandsList:GetChildren() do
                            bindCard(v44)
                        end
                        CommandsList.ChildAdded:Connect(bindCard)
                    end
                    UiFrames.Observe(v25, function(v45) -- line 252 | captures: v28, v29
                        if not v45 then
                            for v46, v47 in v28 do
                                v47.Close(true)
                            end
                            for v48, v49 in v29 do
                                v49()
                            end
                        end
                    end)
                    v24.Visible = true
                    v24.Activated:Connect(function() -- line 264 | captures: v25, AdminConfig, UiFrames, LocalPlayer
                        if LocalPlayer:GetAttribute(AdminConfig.PanelAttribute) == true then
                            UiFrames.Toggle(v25)
                        end
                    end)
                else
                    warn((("[AdminPanelController] missing LeftHUD.%* or Frames.%*"):format(AdminConfig.PanelButtonName, AdminConfig.PanelFrameName)))
                end
            end
        end
    else
        removeAll(v21)
    end
end

function v1.Start() -- line 272 | captures: AdminConfig, MainGui, LocalPlayer, removeAll, adopt
    MainGui.Observe(adopt)
    LocalPlayer:GetAttributeChangedSignal(AdminConfig.PanelAttribute):Connect(function() -- line 276 | captures: AdminConfig, LocalPlayer, removeAll
        if LocalPlayer:GetAttribute(AdminConfig.PanelAttribute) ~= false then
            return
        end
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local v50 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
        if v50 and v50:IsA("ScreenGui") then
            removeAll(v50)
        end
    end)
end

return v1
