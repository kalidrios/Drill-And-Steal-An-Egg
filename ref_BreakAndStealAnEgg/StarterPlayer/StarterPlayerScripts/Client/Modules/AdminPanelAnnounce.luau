-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local GlobalAnnouncementConfig = require(ReplicatedStorage.Shared.GlobalAnnouncementConfig)
local NotificationController = require(script.Parent.Parent.Controllers.NotificationController)
local UnitTextBox = require(script.Parent.UnitTextBox)
local v1 = {}

function v1.Bind(v2, v3) -- line 34 | captures: ReplicatedStorage, AdminConfig, GlobalAnnouncementConfig, NotificationController, UnitTextBox
    local UserNameVerify = v3:FindFirstChild("UserNameVerify")
    local v4 = UserNameVerify and UserNameVerify:FindFirstChild("TextBox")
    local Select = v3:FindFirstChild("Select")
    local v5
    if v4 and v4:IsA("TextBox") and Select and Select:IsA("GuiButton") then
        v4.ClearTextOnFocus = false
        local LastingTime = v3:FindFirstChild("LastingTime")
        v5 = LastingTime and LastingTime:FindFirstChild("TextBox")
    else
        return false
    end
    if not (v5 and v5:IsA("TextBox")) then
        v5 = nil
    end
    UnitTextBox.Bind(v5, "s")
    local v6 = false
    local v7 = v5

    local function announce() -- line 55 | captures: v6, v2, v4, v7, ReplicatedStorage, AdminConfig, GlobalAnnouncementConfig, NotificationController, UnitTextBox
        if v6 then
            return
        end
        local v8 = string.gsub(v4.Text, "^%s+", "")
        local v9 = string.gsub(v8, "%s+$", "")
        if v9 == "" then
            NotificationController.Show("Type something to announce first", "Error")
        else
            local Scope = v2:GetAttribute("Scope")
            local v10 = Scope
            if type(Scope) ~= "string" then
                v10 = AdminConfig.PanelDefaultScope
            end
            local v11 = ReplicatedStorage:FindFirstChild(AdminConfig.PanelRemotes.Announce)
            if v11 and v11:IsA("RemoteFunction") then
                local v12
                if v7 and string.match(v7.Text, "%S") then
                    local s = UnitTextBox.Number(v7.Text, "s")
                    if not s then
                        NotificationController.Show("Type how long it lasts in seconds (e.g. 3)", "Error")
                        return
                    end
                    v12 = GlobalAnnouncementConfig.ClampHold(s)
                end
                v6 = true
                local v13, v14, v15 = pcall(function() -- line 88 | captures: v10, v12, v9, v11
                    return v11:InvokeServer(v9, v10, v12)
                end)
                v6 = false
                local v16, v17
                if v13 then
                    if v14 == true then
                        v17 = true
                    else
                        if type(v15) == "string" then
                            v16 = v15
                        else
                            v16 = "couldn't announce"
                        end
                        v17 = false
                    end
                else
                    v16 = "couldn't announce"
                    v17 = false
                end
                if v17 then
                    v4.Text = ""
                else
                    NotificationController.Show(("Announce failed: %*"):format(v16), "Error")
                end
            else
                NotificationController.Show("Announcements aren't ready yet", "Error")
            end
        end
    end

    Select.Activated:Connect(function() -- line 102 | captures: announce
        task.spawn(announce)
    end)
    v4.FocusLost:Connect(function(v18) -- line 105 | captures: announce
        if v18 then
            task.spawn(announce)
        end
    end)
    return true
end

return v1
