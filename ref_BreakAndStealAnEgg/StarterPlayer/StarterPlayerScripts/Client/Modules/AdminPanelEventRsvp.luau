-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local EventRsvpConfig = require(ReplicatedStorage.Shared.EventRsvpConfig)
local NotificationController = require(script.Parent.Parent.Controllers.NotificationController)
local v1 = {}

local function formatRemaining(v2) -- line 38
    local v3 = math.ceil(v2)
    local v4 = math.max(v3, 0)
    local v5 = v4 // 3600
    local v6 = v4 % 3600 // 60
    local v7 = v4 % 60
    if v5 > 0 then
        return string.format("%d:%02d:%02d", v5, v6, v7)
    end
    return string.format("%d:%02d", v6, v7)
end

local function autoPromptLive() -- line 49 | captures: Workspace, EventRsvpConfig
    return EventRsvpConfig.IsUnlocked(Workspace:GetServerTimeNow())
end

function v1.Bind(v8, v9) -- line 53 | captures: ReplicatedStorage, Workspace, AdminConfig, EventRsvpConfig, NotificationController
    local Prompt = v9:FindFirstChild("Prompt")
    local Status = v9:FindFirstChild("Status")
    if Prompt and Prompt:IsA("GuiButton") and Status and Status:IsA("TextLabel") then
        Prompt:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
        Prompt:SetAttribute("PressScale", AdminConfig.PanelPressScale)
        Prompt.Interactable = true
        local Title = Prompt:FindFirstChild("Title")
        if Title and Title:IsA("TextLabel") then
            Title.Text = "Prompt"
        end

        local function refresh() -- line 72 | captures: Status, Workspace, EventRsvpConfig
            local v10
            if EventRsvpConfig.IsUnlocked(Workspace:GetServerTimeNow()) then
                v10 = "Auto-prompt: <font color=\"#55FF7F\">Live</font>"
            else
                local v11 = "Auto-prompt starts in <font color=\"#FFD23C\">%*</font>"
                local v12 = EventRsvpConfig.PromptStartTime - Workspace:GetServerTimeNow()
                local v13 = math.ceil(v12)
                local v14 = math.max(v13, 0)
                local v15 = v14 // 3600
                local v16 = v14 % 3600 // 60
                local v17 = v14 % 60
                local v18
                if v15 > 0 then
                    v18 = string.format("%d:%02d:%02d", v15, v16, v17)
                else
                    v18 = string.format("%d:%02d", v16, v17)
                end
                v10 = v11:format(v18)
            end
            if Status.Text ~= v10 then
                Status.Text = v10
            end
        end

        local v19
        if EventRsvpConfig.IsUnlocked(Workspace:GetServerTimeNow()) then
            v19 = "Auto-prompt: <font color=\"#55FF7F\">Live</font>"
        else
            local v20 = "Auto-prompt starts in <font color=\"#FFD23C\">%*</font>"
            local v21 = EventRsvpConfig.PromptStartTime - Workspace:GetServerTimeNow()
            local v22 = math.ceil(v21)
            local v23 = math.max(v22, 0)
            local v24 = v23 // 3600
            local v25 = v23 % 3600 // 60
            local v26 = v23 % 60
            local v27
            if v24 > 0 then
                v27 = string.format("%d:%02d:%02d", v24, v25, v26)
            else
                v27 = string.format("%d:%02d", v25, v26)
            end
            v19 = v20:format(v27)
        end
        if Status.Text ~= v19 then
            Status.Text = v19
        end
        task.spawn(function() -- line 83 | captures: Status, Workspace, EventRsvpConfig
            while true do
                local v28, v29
                if Status:IsDescendantOf(game) then
                    if EventRsvpConfig.IsUnlocked(Workspace:GetServerTimeNow()) then
                        v29 = true
                    else
                        task.wait(0.5)
                        if EventRsvpConfig.IsUnlocked(Workspace:GetServerTimeNow()) then
                            v28 = "Auto-prompt: <font color=\"#55FF7F\">Live</font>"
                        else
                            local v30 = "Auto-prompt starts in <font color=\"#FFD23C\">%*</font>"
                            local v31 = EventRsvpConfig.PromptStartTime - Workspace:GetServerTimeNow()
                            local v32 = math.ceil(v31)
                            local v33 = math.max(v32, 0)
                            local v34 = v33 // 3600
                            local v35 = v33 % 3600 // 60
                            local v36 = v33 % 60
                            local v37
                            if v34 > 0 then
                                v37 = string.format("%d:%02d:%02d", v34, v35, v36)
                            else
                                v37 = string.format("%d:%02d", v35, v36)
                            end
                            v28 = v30:format(v37)
                        end
                        v29 = false
                    end
                else
                    v29 = true
                end
                if v29 then
                    break
                end
                if Status.Text ~= v28 then
                    Status.Text = v28
                end
            end
        end)
        local v38 = false

        local function send() -- line 93 | captures: v38, ReplicatedStorage, AdminConfig, NotificationController
            if not v38 then
                local v39 = ReplicatedStorage:FindFirstChild(AdminConfig.PanelRemotes.EventRsvp)
                if not (v39 and v39:IsA("RemoteFunction")) then
                    NotificationController.Show("The event prompt isn't ready yet", "Error")
                else
                    v38 = true
                    local v40, v41, v42 = pcall(function() -- line 103 | captures: v39
                        return v39:InvokeServer()
                    end)
                    v38 = false
                    if v40 and v41 == true then
                        local Show = NotificationController.Show
                        local v43 = if type(v42) == "string" then v42 else "Event prompt sent"
                        Show(v43, "Success")
                    else
                        if not (v40 and type(v42) == "string") then
                            v42 = "something went wrong"
                        end
                        NotificationController.Show(("Event prompt failed: %*"):format(v42), "Error")
                    end
                end
            end
        end

        Prompt.Activated:Connect(function() -- line 115 | captures: send
            task.spawn(send)
        end)
    else
        warn("[AdminPanelEventRsvp] card needs Container.Prompt (button) + Container.Status (label)")
    end
end

return v1
