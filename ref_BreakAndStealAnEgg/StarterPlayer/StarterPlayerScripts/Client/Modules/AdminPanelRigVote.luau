-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminConchTypes = require(ReplicatedStorage.Shared.AdminConchTypes)
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local PollConfig = require(ReplicatedStorage.Shared.PollConfig)
local UnitTextBox = require(script.Parent.UnitTextBox)
local v1 = {}
local v2 = { "Random", "Red", "Blue" }
local v3 = ""
local v4 = ""
local v5 = 1
local v6, v7

local function trim(v8) -- line 47
    return (string.gsub(string.gsub(v8, "^%s+", ""), "%s+$", ""))
end

local function child(v9, v10) -- line 51
    if v9 then
        return (v9:FindFirstChild(v10))
    end
    return nil
end

local function boxIn(v11, v12) -- line 55
    local v13
    if v11 then
        v13 = v11:FindFirstChild(v12)
    end
    local v14
    if v13 then
        v14 = v13:FindFirstChild("TextBox")
    end
    if not (v14 and v14:IsA("TextBox")) then
        return nil
    end
    v14.ClearTextOnFocus = false
    return v14
end

local function answerColor(v15, v16) -- line 65
    local v17
    if v15 then
        v17 = v15:FindFirstChild(v16)
    end
    local v18
    if v17 then
        v18 = v17:FindFirstChild("Text")
    end
    if not (v18 and v18:IsA("GuiObject")) then
        return nil
    end
    return v18.BackgroundColor3
end

function v1.Bind(v19) -- line 70 | captures: v3, v4, v5, v6, v7, AdminConfig, UnitTextBox, v2
    local List = v19:FindFirstChild("List")
    local v20
    if List then
        v20 = List:FindFirstChild("Duration")
    end
    local v21
    if v20 then
        v21 = v20:FindFirstChild("CCU")
    end
    local v22
    if v21 then
        v22 = v21:FindFirstChild("TextBox")
    end
    if not (v22 and v22:IsA("TextBox")) then
        v22 = nil
    else
        v22.ClearTextOnFocus = false
    end
    v6 = v22
    local v23
    if v20 then
        v23 = v20:FindFirstChild("Percent")
    end
    local v24
    if v23 then
        v24 = v23:FindFirstChild("TextBox")
    end
    if not (v24 and v24:IsA("TextBox")) then
        v24 = nil
    else
        v24.ClearTextOnFocus = false
    end
    v7 = v24
    local v25
    if v20 then
        v25 = v20:FindFirstChild("Winner")
    end
    if v6 and v7 and v25 and v25:IsA("GuiButton") then
        v25:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
        v25:SetAttribute("PressScale", AdminConfig.PanelPressScale)
        UnitTextBox.Bind(v7, "%")
        local v26 = v6
        local v27 = v7
        v26.Text = v3
        v27.Text = v4
        v26:GetPropertyChangedSignal("Text"):Connect(function() -- line 89 | captures: v26, v3
            v3 = v26.Text
        end)
        v27:GetPropertyChangedSignal("Text"):Connect(function() -- line 92 | captures: v27, v4
            v4 = v27.Text
        end)
        local Title = v25:FindFirstChild("Title")
        local v28 = { Random = v25.BackgroundColor3 }
        local v29
        if List then
            v29 = List:FindFirstChild("Answer_1")
        end
        local v30
        if v29 then
            v30 = v29:FindFirstChild("Text")
        end
        local BackgroundColor3
        if not (v30 and v30:IsA("GuiObject")) then
        else
            BackgroundColor3 = v30.BackgroundColor3
        end
        v28.Red = BackgroundColor3 or Color3.fromRGB(200, 0, 0)
        local v31
        if List then
            v31 = List:FindFirstChild("Answer_2")
        end
        local v32
        if v31 then
            v32 = v31:FindFirstChild("Text")
        end
        local BackgroundColor3_2
        if not (v32 and v32:IsA("GuiObject")) then
        else
            BackgroundColor3_2 = v32.BackgroundColor3
        end
        v28.Blue = BackgroundColor3_2 or Color3.fromRGB(0, 60, 200)
        local v33 = v25

        local function paint() -- line 102 | captures: Title, v28, v33, v5, v2
            local v34 = v2[v5]
            if Title and Title:IsA("TextLabel") then
                Title.Text = v34
            end
            v33.BackgroundColor3 = v28[v34]
        end

        local v35 = v2[v5]
        if Title and Title:IsA("TextLabel") then
            Title.Text = v35
        end
        v25.BackgroundColor3 = v28[v35]
        v25.Activated:Connect(function() -- line 110 | captures: Title, v28, v33, v5, v2
            v5 = v5 % #v2 + 1
            local v36 = v2[v5]
            if Title and Title:IsA("TextLabel") then
                Title.Text = v36
            end
            v33.BackgroundColor3 = v28[v36]
        end)
    else
        warn("[AdminPanelRigVote] Create a Poll needs List.Duration.CCU / Percent (TextBox) + Winner (button)")
    end
end

function v1.Get() -- line 118 | captures: v5, v6, v7, AdminConchTypes, PollConfig, UnitTextBox, v2
    local v37
    if v6 then
        local Text = v6.Text
        v37 = string.gsub(string.gsub(Text, "^%s+", ""), "%s+$", "")
    else
        v37 = ""
    end
    local v38
    if v7 then
        local Text = v7.Text
        v38 = string.gsub(string.gsub(Text, "^%s+", ""), "%s+$", "") ~= ""
    else
        v38 = false
    end
    if v37 == "" then
        if v38 or not (v2[v5] == "Random") then
            return nil, "type the CCU (e.g. 420K) to rig it, or clear Winner % and set Winner to Random"
        end
        return nil, nil
    end
    local v39 = AdminConchTypes.ParseNumber(v37)
    local v40, v41
    if v39 then
        if v39 < 1 then
            v41 = true
        else
            if v7 then
                local Text = v7.Text
                v40 = string.gsub(string.gsub(Text, "^%s+", ""), "%s+$", "")
            else
                v40 = ""
            end
            v41 = false
        end
    else
        v41 = true
    end
    if v41 then
        return nil, "type the CCU like 420K, 1.2M or 85000"
    end
    local v42
    if v40 == "" then
        v42 = true
    else
        local v43 = UnitTextBox.Number(v40, "%")
        if v43 then
            if v43 < PollConfig.Rig.MinShare then
                v42 = false
            else
                v42 = not (PollConfig.Rig.MaxShare < v43)
            end
        else
            v42 = false
        end
    end
    if not v42 then
        return nil, (("winner %% must be %*-%*"):format(PollConfig.Rig.MinShare, PollConfig.Rig.MaxShare))
    end
    local v44 = v2[v5]
    local v45 = { CCU = v37 }
    if v44 == "Random" then
        v45.Winner = ""
    else
        v45.Winner = string.lower(v44)
    end
    v45.Share = v40
    return v45, nil
end

return v1
