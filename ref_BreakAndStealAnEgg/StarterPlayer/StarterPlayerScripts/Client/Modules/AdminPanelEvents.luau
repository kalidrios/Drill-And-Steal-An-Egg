-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AdminAbuseConfig = require(ReplicatedStorage.Shared.AdminAbuseConfig)
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local NotificationController = require(script.Parent.Parent.Controllers.NotificationController)
local UnitTextBox = require(script.Parent.UnitTextBox)
local v1 = {}
local Color = AdminAbuseConfig.Color

local function formatElapsed(v2) -- line 66
    local v3 = math.floor(v2)
    local v4 = math.max(v3, 0)
    local v5 = v4 // 3600
    local v6 = v4 % 3600 // 60
    local v7 = v4 % 60
    if v5 > 0 then
        return string.format("%d:%02d:%02d", v5, v6, v7)
    end
    return string.format("%d:%02d", v6, v7)
end

local function bindTimer(v8, v9, v10) -- line 77 | captures: Workspace, Color
    local function v11(v12, ...)
        table.insert(v12, ...)
    end

    local Timer = v8:FindFirstChild("Timer")
    if Timer and Timer:IsA("TextLabel") then
        local function refresh() -- line 84 | captures: v9, v10, Timer, Workspace, Color
            local v13 = Workspace:GetAttribute(v9)
            local v14
            if v10 then
                v14 = Workspace:GetAttribute(v10)
            end
            local v15
            if type(v13) == "number" then
                local v16 = "Running: <font color=\"%*\">%*</font>"
                local v17 = Workspace:GetServerTimeNow() - v13
                local v18 = math.floor(v17)
                local v19 = math.max(v18, 0)
                local v20 = v19 // 3600
                local v21 = v19 % 3600 // 60
                local v22 = v19 % 60
                local v23
                if v20 > 0 then
                    v23 = string.format("%d:%02d:%02d", v20, v21, v22)
                else
                    v23 = string.format("%d:%02d", v21, v22)
                end
                v15 = v16:format(Color, v23)
            elseif type(v14) == "number" then
                local v24 = "Starts in: <font color=\"%*\">%*</font>"
                local v25 = v14 - Workspace:GetServerTimeNow()
                local v26 = math.ceil(v25)
                local v27 = math.floor(v26)
                local v28 = math.max(v27, 0)
                local v29 = v28 // 3600
                local v30 = v28 % 3600 // 60
                local v31 = v28 % 60
                local v32
                if v29 > 0 then
                    v32 = string.format("%d:%02d:%02d", v29, v30, v31)
                else
                    v32 = string.format("%d:%02d", v30, v31)
                end
                v15 = v24:format(Color, v32)
            else
                v15 = "Not running"
            end
            if Timer.Text ~= v15 then
                Timer.Text = v15
            end
        end

        refresh()
        local v33 = { Workspace:GetAttributeChangedSignal(v9):Connect(refresh) }
        if v10 then
            v11(v33, Workspace:GetAttributeChangedSignal(v10):Connect(refresh))
        end
        task.spawn(function() -- line 101 | captures: Timer, refresh, v33
            while Timer:IsDescendantOf(game) do
                refresh()
                task.wait(0.25)
            end
            for v34, v35 in v33 do
                v35:Disconnect()
            end
        end)
    else
        warn((("[AdminPanelEvents] %* has no Timer label"):format((v8:GetFullName()))))
    end
end

local function bind(v36, v37) -- line 113 | captures: ReplicatedStorage, AdminConfig, NotificationController, bindTimer
    local Start = v36:FindFirstChild("Start")
    local End = v36:FindFirstChild("End")
    if Start and Start:IsA("GuiButton") and End and End:IsA("GuiButton") then
        for v38, v39 in { Start, End } do
            v39:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
            v39:SetAttribute("PressScale", AdminConfig.PanelPressScale)
        end
        bindTimer(v36, v37.Attribute, v37.ScheduledAttribute)
        local v40 = false

        local function send(v41) -- line 128 | captures: v40, v37, ReplicatedStorage, NotificationController
            if not v40 then
                local v42 = ReplicatedStorage:FindFirstChild(v37.Remote)
                if not (v42 and v42:IsA("RemoteFunction")) then
                    NotificationController.Show(("%* isn't ready yet"):format(v37.Label), "Error")
                else
                    local v43 = {}
                    if v37.Args then
                        local v44, v45 = v37.Args(v41)
                        if not v44 then
                            NotificationController.Show(v45 or ("%* failed"):format(v37.Label), "Error")
                            return
                        end
                        v43 = v44
                    end
                    v40 = true
                    local v46, v47, v48 = pcall(function() -- line 147 | captures: v43, v41, v42
                        local v49 = v43
                        return v42:InvokeServer(v41, table.unpack(v49))
                    end)
                    v40 = false
                    local v50, v51
                    if v46 then
                        if v47 == true then
                            v51 = true
                        else
                            if type(v48) == "string" then
                                v50 = v48
                            else
                                v50 = "something went wrong"
                            end
                            v51 = false
                        end
                    else
                        v50 = "something went wrong"
                        v51 = false
                    end
                    if v51 then
                        if type(v48) == "string" then
                            NotificationController.Show(v48, "Success")
                        end
                    else
                        NotificationController.Show(("%* failed: %*"):format(v37.Label, v50), "Error")
                    end
                end
            end
        end

        Start.Activated:Connect(function() -- line 161 | captures: send
            task.spawn(send, "Start")
        end)
        End.Activated:Connect(function() -- line 164 | captures: send
            task.spawn(send, "End")
        end)
    else
        warn((("[AdminPanelEvents] %* card needs Container.Start + Container.End"):format(v37.Label)))
    end
end

local function copyLook(v52, v53) -- line 171
    for v54, v55 in { "UiGradient", "Outer", "Inner" } do
        local v56 = v52:FindFirstChild(v55)
        local v57 = v53:FindFirstChild(v55)
        if v56 and v57 and v56.ClassName == v57.ClassName then
            if v56:IsA("UIGradient") then
                v57.Color = v56.Color
            elseif v56:IsA("UIStroke") then
                v57.Color = v56.Color
                local UIGradient = v56:FindFirstChildWhichIsA("UIGradient")
                local UIGradient_2 = v57:FindFirstChildWhichIsA("UIGradient")
                if UIGradient and UIGradient_2 then
                    UIGradient_2.Color = UIGradient.Color
                end
            end
        end
    end
end

local function bindHourly(v58) -- line 194 | captures: ReplicatedStorage, Workspace, AdminConfig, HellEventConfig, NotificationController, copyLook
    local HourlySwitch = HellEventConfig.HourlySwitch
    local v59 = v58:FindFirstChild(HourlySwitch.Button)
    if not (v59 and v59:IsA("GuiButton")) then
        warn((("[AdminPanelEvents] Hell card has no Container.%* button (no hourly switch)"):format(HourlySwitch.Button)))
    else
        local Title = v59:FindFirstChild("Title")
        local Start = v58:FindFirstChild("Start")
        local End = v58:FindFirstChild("End")
        v59:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
        v59:SetAttribute("PressScale", AdminConfig.PanelPressScale)

        local function refresh() -- line 208 | captures: HourlySwitch, v59, Title, Start, End, Workspace, copyLook
            local v60 = Workspace:GetAttribute(HourlySwitch.Attribute)
            if Title and Title:IsA("TextLabel") then
                local v61
                if v60 == true then
                    v61 = HourlySwitch.OnText
                elseif v60 == false then
                    v61 = HourlySwitch.OffText
                else
                    v61 = HourlySwitch.LoadingText
                end
                Title.Text = v61
            end
            local v62 = if v60 == true then Start else End
            if v62 then
                copyLook(v62, v59)
            end
        end

        refresh()
        local v63 = Workspace:GetAttributeChangedSignal(HourlySwitch.Attribute):Connect(refresh)
        v59.Destroying:Once(function() -- line 220 | captures: v63
            v63:Disconnect()
        end)
        local v64 = false
        v59.Activated:Connect(function() -- line 225 | captures: v64, HourlySwitch, ReplicatedStorage, Workspace, AdminConfig, NotificationController
            if not v64 then
                local v65 = Workspace:GetAttribute(HourlySwitch.Attribute)
                if type(v65) == "boolean" then
                    local v66 = ReplicatedStorage:FindFirstChild(AdminConfig.PanelRemotes.HellHourly)
                    if not (v66 and v66:IsA("RemoteFunction")) then
                        NotificationController.Show("Hourly Hell isn't ready yet", "Error")
                    else
                        v64 = true
                        task.spawn(function() -- line 240 | captures: v65, v66, v64, NotificationController
                            local v67, v68, v69 = pcall(function() -- line 241 | captures: v65, v66
                                return v66:InvokeServer(not v65)
                            end)
                            v64 = false
                            local v70, v71
                            if v67 then
                                if v68 == true then
                                    v71 = true
                                else
                                    if type(v69) == "string" then
                                        v70 = v69
                                    else
                                        v70 = "something went wrong"
                                    end
                                    v71 = false
                                end
                            else
                                v70 = "something went wrong"
                                v71 = false
                            end
                            if not v71 then
                                NotificationController.Show(("Hourly Hell failed: %*"):format(v70), "Error")
                            end
                        end)
                    end
                else
                    NotificationController.Show("Hourly Hell isn't ready yet", "Error")
                end
            end
        end)
    end
end

function v1.BindHell(v72, v73) -- line 255 | captures: AdminConfig, HellEventConfig, UnitTextBox, bind, bindHourly
    bindHourly(v73)
    local StartDelay = v73:FindFirstChild("StartDelay")
    local v74 = StartDelay and StartDelay:FindFirstChildWhichIsA("TextBox")
    if v74 then
        UnitTextBox.Bind(v74, "m")
    else
        warn("[AdminPanelEvents] Hell card has no Container.StartDelay.TextBox (no delayed starts)")
    end
    local v75 = {
        Label = "Hell",
        Remote = AdminConfig.PanelRemotes.Hell,
        Attribute = HellEventConfig.StartedAtAttribute,
        ScheduledAttribute = HellEventConfig.StartDelay.Attribute
    }

    function v75.Args(v76) -- line 270 | captures: v72, v74, HellEventConfig, UnitTextBox
        local Scope = v72:GetAttribute("Scope")
        if not (type(Scope) == "string" and HellEventConfig.Scopes[Scope]) then
            Scope = "Server"
        end
        if v76 == "Start" and v74 and not string.match(v74.Text, "^%s*$") then
            local m = UnitTextBox.Number(v74.Text, "m")
            if not m or m < 0 then
                return nil, "Type the delay in minutes (e.g. 10), or leave it blank to start now"
            end
            local v77 = m * 60 + 0.5
            local v78 = math.floor(v77)
            if HellEventConfig.StartDelay.Max < v78 then
                return nil, (("The delay can be at most %* minutes"):format(HellEventConfig.StartDelay.Max // 60))
            end
            return { Scope, v78 }
        end
        return { Scope }
    end

    bind(v73, v75)
end

function v1.BindAdminAbuse(v79, v80) -- line 291 | captures: AdminAbuseConfig, AdminConfig, bind
    bind(v80, {
        Label = "Admin Abuse",
        Remote = AdminConfig.PanelRemotes.AdminAbuse,
        Attribute = AdminAbuseConfig.StartedAtAttribute
    })
end

return v1
