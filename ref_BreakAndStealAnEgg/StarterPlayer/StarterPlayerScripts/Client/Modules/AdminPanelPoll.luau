-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local PollConfig = require(ReplicatedStorage.Shared.PollConfig)
local AdminPanelRigVote = require(script.Parent.AdminPanelRigVote)
local NotificationController = require(script.Parent.Parent.Controllers.NotificationController)
local UiFrames = require(script.Parent.Parent.Controllers.UiFrames)
local RichWordTyper = require(script.Parent.RichWordTyper)
local UnitTextBox = require(script.Parent.UnitTextBox)
local v1 = {}
local v2 = {
    Global = Color3.fromRGB(0, 170, 255),
    Server = Color3.fromRGB(0, 255, 0),
    Client = Color3.fromRGB(255, 60, 60)
}
local v3 = { "Create", "Start", "Post", "Submit", "Send", "CreatePoll", "StartPoll" }

local function child(v4, v5) -- line 54
    if v4 then
        return (v4:FindFirstChild(v5))
    end
    return nil
end

local function rowBox(v6, v7) -- line 58
    local v8
    if v6 then
        v8 = v6:FindFirstChild(v7)
    end
    local v9
    if v8 then
        v9 = v8:FindFirstChild("Text")
    end
    local v10
    if v9 then
        v10 = v9:FindFirstChild("TextBox")
    end
    if not (v10 and v10:IsA("TextBox")) then
        return nil
    end
    v10.ClearTextOnFocus = false
    return v10
end

local function trim(v11) -- line 67
    return (string.gsub(string.gsub(v11, "^%s+", ""), "%s+$", ""))
end

function v1.Bind(v12, v13, v14) -- line 71 | captures: ReplicatedStorage, AdminConfig, PollConfig, AdminPanelRigVote, NotificationController, UiFrames, RichWordTyper, UnitTextBox, v2, v3
    for v15, v16 in { "GlobalSwap", "NewPoll" } do
        local v17 = v13:FindFirstChild(v16)
        if v17 and v17:IsA("GuiButton") then
            v17:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
            v17:SetAttribute("PressScale", AdminConfig.PanelPressScale)
        end
    end
    local Scope = v12:GetAttribute("Scope")
    if not (type(Scope) == "string" and table.find(PollConfig.Scopes, Scope)) then
        Scope = PollConfig.DefaultScope
    end
    v12:SetAttribute("Scope", Scope)
    local Setting = v13:FindFirstChild("Setting")
    local v18
    if not (Setting and Setting:IsA("TextLabel")) then
    else
        v18 = RichWordTyper.new(Setting)
    end
    if v18 then
        v18:Set(Scope, v2[Scope], true)
    end
    local GlobalSwap = v13:FindFirstChild("GlobalSwap")
    if GlobalSwap and GlobalSwap:IsA("GuiButton") then
        local Activated = GlobalSwap.Activated
        local v19 = v18
        Activated:Connect(function() -- line 93 | captures: v12, v19, PollConfig, v2
            local v20 = table.find(PollConfig.Scopes, v12:GetAttribute("Scope")) or 0
            local v21 = PollConfig.Scopes[v20 % #PollConfig.Scopes + 1]
            v12:SetAttribute("Scope", v21)
            if v19 then
                v19:Set(v21, v2[v21])
            end
        end)
    end
    local Frames = v14:FindFirstChild("Frames")
    local PollCreateFrame = AdminConfig.PollCreateFrame
    local v22
    if Frames then
        v22 = Frames:FindFirstChild(PollCreateFrame)
    end
    if v22 and v22:IsA("GuiObject") then
        v22.Visible = false
        local NewPoll = v13:FindFirstChild("NewPoll")
        if NewPoll and NewPoll:IsA("GuiButton") then
            local Activated = NewPoll.Activated
            local v23 = v22
            Activated:Connect(function() -- line 114 | captures: v23, UiFrames
                UiFrames.Open(v23)
            end)
        end
    else
        return
    end
    local List = v22:FindFirstChild("List")
    local v24
    if List then
        v24 = List:FindFirstChild("Question")
    end
    local v25
    if v24 then
        v25 = v24:FindFirstChild("Text")
    end
    local v26
    if v25 then
        v26 = v25:FindFirstChild("TextBox")
    end
    if not (v26 and v26:IsA("TextBox")) then
        v26 = nil
    else
        v26.ClearTextOnFocus = false
    end
    local v27 = {}
    local v28
    if List then
        v28 = List:FindFirstChild("Answer_1")
    end
    local v29
    if v28 then
        v29 = v28:FindFirstChild("Text")
    end
    local v30
    if v29 then
        v30 = v29:FindFirstChild("TextBox")
    end
    if not (v30 and v30:IsA("TextBox")) then
        v30 = nil
    else
        v30.ClearTextOnFocus = false
    end
    local v31
    if List then
        v31 = List:FindFirstChild("Answer_2")
    end
    local v32
    if v31 then
        v32 = v31:FindFirstChild("Text")
    end
    local v33
    if v32 then
        v33 = v32:FindFirstChild("TextBox")
    end
    if not (v33 and v33:IsA("TextBox")) then
        v33 = nil
    else
        v33.ClearTextOnFocus = false
    end
    v27[1] = v30
    v27[2] = v33
    local v34
    if List then
        v34 = List:FindFirstChild("Duration")
    end
    local v35
    if v34 then
        v35 = v34:FindFirstChild("Text")
    end
    local v36
    if v35 then
        v36 = v35:FindFirstChild("TextBox")
    end
    if not (v36 and v36:IsA("TextBox")) then
        v36 = nil
    else
        v36.ClearTextOnFocus = false
    end
    UnitTextBox.Bind(v36, "s")
    AdminPanelRigVote.Bind(v22)
    for v37, v38 in { "Answer_1", "Answer_2" } do
        local v39
        if List then
            v39 = List:FindFirstChild(v38)
        end
        local v40
        if v39 then
            v40 = v39:FindFirstChild("Text")
        end
        local v41
        if v40 then
            v41 = v40:FindFirstChild("Delete")
        end
        if v41 and v41:IsA("GuiButton") then
            local Activated = v41.Activated
            local v42 = v37
            Activated:Connect(function() -- line 131 | captures: v27, v42
                local v43 = v27[v42]
                if v43 then
                    v43.Text = ""
                end
            end)
        end
    end
    local v44 = v26

    local function filled() -- line 140 | captures: v27, v44
        local v45
        if v44 then
            local Text = v44.Text
            v45 = string.gsub(string.gsub(Text, "^%s+", ""), "%s+$", "") == ""
        end
        if not v44 or v45 then
            return false
        end
        for v46, v47 in v27 do
            if v47 then
                local Text = v47.Text
                if string.gsub(string.gsub(Text, "^%s+", ""), "%s+$", "") == "" then
                    return false
                end
            else
                return false
            end
        end
        return true
    end

    local v48 = false
    local v49 = v36
    local v50 = v22

    local function submit() -- line 153 | captures: v48, v12, v27, filled, v44, v49, v50, ReplicatedStorage, AdminConfig, AdminPanelRigVote, NotificationController, UiFrames, UnitTextBox
        if not v48 then
            if filled() then
                local s
                if v49 and string.match(v49.Text, "%S") then
                    local s_2 = UnitTextBox.Number(v49.Text, "s")
                    s = s_2
                    if not s_2 then
                        NotificationController.Show("Type the duration in seconds (e.g. 15)", "Error")
                        return
                    end
                end
                local v51, v52 = AdminPanelRigVote.Get()
                if v52 then
                    NotificationController.Show(("Vote rig: %*"):format(v52), "Error")
                else
                    local v53 = ReplicatedStorage:FindFirstChild(AdminConfig.PanelRemotes.Poll)
                    if not (v53 and v53:IsA("RemoteFunction")) then
                        NotificationController.Show("Polls aren't ready yet", "Error")
                    else
                        v48 = true
                        local v54, v55, v56 = pcall(function() -- line 181 | captures: s, v51, v53, v12, v27, v44
                            local v57 = {}
                            if v44 then
                                v57.Question = v44.Text
                            else
                                v57.Question = ""
                            end
                            local v58 = {}
                            local v59 = if v27[1] then v27[1].Text else ""
                            local v60 = if v27[2] then v27[2].Text else ""
                            v58[1] = v59
                            v58[2] = v60
                            v57.Answers = v58
                            v57.Duration = s
                            v57.Scope = v12:GetAttribute("Scope")
                            v57.Rig = v51
                            return v53:InvokeServer(v57)
                        end)
                        v48 = false
                        local v61, v62
                        if v54 then
                            if v55 == true then
                                v62 = true
                            else
                                if type(v56) == "string" then
                                    v61 = v56
                                else
                                    v61 = "couldn't start the poll"
                                end
                                v62 = false
                            end
                        else
                            v61 = "couldn't start the poll"
                            v62 = false
                        end
                        if v62 then
                            local Show = NotificationController.Show
                            if type(v56) ~= "string" then
                                v56 = "{Poll} started!"
                            end
                            Show(v56, "Success")
                            if v44 then
                                v44.Text = ""
                            end
                            for v63, v64 in v27 do
                                if v64 then
                                    v64.Text = ""
                                end
                            end
                            UiFrames.Close(v50)
                        else
                            NotificationController.Show(("Poll failed: %*"):format(v61), "Error")
                        end
                    end
                end
            else
                NotificationController.Show("Fill in the question and both answers", "Error")
            end
        end
    end

    for v65, v66 in v3 do
        local v67 = v22:FindFirstChild(v66, true)
        if v67 and v67:IsA("GuiButton") then
            v67:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
            v67:SetAttribute("PressScale", AdminConfig.PanelPressScale)
            v67.Activated:Connect(function() -- line 217 | captures: submit
                task.spawn(submit)
            end)
            break
        end
    end
end

return v1
