-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AdminConchTypes = require(ReplicatedStorage.Shared.AdminConchTypes)
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local PotionConfig = require(ReplicatedStorage.Shared.PotionConfig)
local NotificationController = require(script.Parent.Parent.Controllers.NotificationController)
local UnitTextBox = require(script.Parent.UnitTextBox)
local v1 = {}
local GlobalBoost = AdminConfig.GlobalBoost

local function boxIn(v2, v3) -- line 39
    local v4 = v2:FindFirstChild(v3)
    local v5 = v4 and v4:FindFirstChildWhichIsA("TextBox")
    if v5 and v5:IsA("TextBox") then
        return v5
    end
    return nil
end

local function boostName(v6) -- line 45 | captures: AdminConchTypes, PotionConfig, GlobalBoost
    if v6 == AdminConchTypes.ALL_POTIONS then
        return GlobalBoost.AllName
    end
    local v7 = PotionConfig.ById(v6)
    if v7 then
        return v7.HoverName
    end
    return v6
end

local function boostColor(v8) -- line 53 | captures: AdminConchTypes, PotionConfig, GlobalBoost
    if v8 == AdminConchTypes.ALL_POTIONS then
        return GlobalBoost.AllColor
    end
    local v9 = PotionConfig.ById(v8)
    if v9 then
        return v9.Color
    end
    return PotionConfig.HoverMultiplierColor
end

local function idsOf(v10) -- line 62 | captures: AdminConchTypes, PotionConfig
    if v10 == AdminConchTypes.ALL_POTIONS then
        local v11 = {}
        for v12, v13 in PotionConfig.Potions do
            local Id = v13.Id
            table.insert(v11, Id)
        end
        return v11
    end
    return { v10 }
end

local function statusText(v14) -- line 74 | captures: AdminConchTypes, PotionConfig, GlobalBoost, idsOf
    local v15
    local v16 = 0
    for v17, v18 in idsOf(v14) do
        local v19 = PotionConfig.GlobalRemaining(v18)
        if v16 < v19 then
            v15 = v18
            v16 = v19
        end
    end
    if v15 then
        local v20 = string.format("%g", PotionConfig.GlobalMultiplier(v15))
        if v14 == AdminConchTypes.ALL_POTIONS or v15 == AdminConchTypes.ALL_POTIONS then
            v15 = GlobalBoost.AllName
        else
            local v21 = PotionConfig.ById(v15)
            if v21 then
                v15 = v21.HoverName
            end
        end
        local v22 = "<font color=\"%*\">x%* %*</font>: %* left"
        local v23
        if v14 == AdminConchTypes.ALL_POTIONS then
            v23 = GlobalBoost.AllColor
        else
            local v24 = PotionConfig.ById(v14)
            if v24 then
                v23 = v24.Color
            else
                v23 = PotionConfig.HoverMultiplierColor
            end
        end
        return (v22:format(v23, v20, v15, (PotionConfig.FormatTime(v16))))
    end
    return "Not running"
end

local function shrinkOnHover(v25) -- line 90 | captures: AdminConfig
    v25:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
    v25:SetAttribute("PressScale", AdminConfig.PanelPressScale)
end

function v1.Bind(v26, v27) -- line 95 | captures: ReplicatedStorage, Workspace, AdminConchTypes, AdminConfig, PotionConfig, NotificationController, UnitTextBox, GlobalBoost, statusText
    local function v28(v29, ...)
        table.insert(v29, ...)
    end

    local Boost = v27:FindFirstChild("Boost")
    local v30 = Boost and Boost:FindFirstChild("Pick")
    local v31 = v30 and v30:FindFirstChild("Title")
    local Multiplier = v27:FindFirstChild("Multiplier")
    local v32 = Multiplier and Multiplier:FindFirstChildWhichIsA("TextBox")
    if not (v32 and v32:IsA("TextBox")) then
        v32 = nil
    end
    local Duration = v27:FindFirstChild("Duration")
    local v33 = Duration and Duration:FindFirstChildWhichIsA("TextBox")
    if not (v33 and v33:IsA("TextBox")) then
        v33 = nil
    end
    local Start = v27:FindFirstChild("Start")
    local End = v27:FindFirstChild("End")
    local Timer = v27:FindFirstChild("Timer")
    if v30 and v30:IsA("GuiButton") and v32 and v33 and Start and Start:IsA("GuiButton") and End and End:IsA("GuiButton") then
        for v34, v35 in { v30, Start, End } do
            v35:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
            v35:SetAttribute("PressScale", AdminConfig.PanelPressScale)
        end
        UnitTextBox.BindPrefix(v32, GlobalBoost.MultiplierPrefix)
        UnitTextBox.Bind(v33, GlobalBoost.MinutesSuffix)
        local v36 = 1

        local function picked() -- line 129 | captures: v36, GlobalBoost
            return GlobalBoost.Choices[v36]
        end

        local function paintPick() -- line 132 | captures: v36, v31, AdminConchTypes, PotionConfig, GlobalBoost
            if not (v31 and v31:IsA("TextLabel")) then
                return
            end
            local v37 = GlobalBoost.Choices[v36]
            if v37 == AdminConchTypes.ALL_POTIONS then
                v37 = GlobalBoost.AllName
            else
                local v38 = PotionConfig.ById(v37)
                if v38 then
                    v37 = v38.HoverName
                end
            end
            v31.Text = v37
            local fromHex = Color3.fromHex
            local v39 = GlobalBoost.Choices[v36]
            local v40
            if v39 == AdminConchTypes.ALL_POTIONS then
                v40 = GlobalBoost.AllColor
            else
                local v41 = PotionConfig.ById(v39)
                if v41 then
                    v40 = v41.Color
                else
                    v40 = PotionConfig.HoverMultiplierColor
                end
            end
            v31.TextColor3 = fromHex(v40)
        end

        if v31 and v31:IsA("TextLabel") then
            local v42 = GlobalBoost.Choices[v36]
            if v42 == AdminConchTypes.ALL_POTIONS then
                v42 = GlobalBoost.AllName
            else
                local v43 = PotionConfig.ById(v42)
                if v43 then
                    v42 = v43.HoverName
                end
            end
            v31.Text = v42
            local fromHex = Color3.fromHex
            local v44 = GlobalBoost.Choices[v36]
            local v45
            if v44 == AdminConchTypes.ALL_POTIONS then
                v45 = GlobalBoost.AllColor
            else
                local v46 = PotionConfig.ById(v44)
                if v46 then
                    v45 = v46.Color
                else
                    v45 = PotionConfig.HoverMultiplierColor
                end
            end
            v31.TextColor3 = fromHex(v45)
        end
        if not (Timer and Timer:IsA("TextLabel")) then
            Timer = nil
        end
        local Timer_2 = Timer

        local function refreshTimer() -- line 142 | captures: v36, Timer_2, GlobalBoost, statusText
            if Timer_2 then
                local v47 = statusText(GlobalBoost.Choices[v36])
                if Timer_2.Text ~= v47 then
                    Timer_2.RichText = true
                    Timer_2.Text = v47
                end
            end
        end

        if Timer then
            local v48 = {}
            for v49, v50 in PotionConfig.Potions do
                v28(v48, Workspace:GetAttributeChangedSignal(PotionConfig.GlobalEndsAtAttribute(v50.Id)):Connect(refreshTimer))
            end
            local spawn = task.spawn
            local Timer_2 = Timer
            spawn(function() -- line 162 | captures: v36, v48, Timer_2, GlobalBoost, statusText
                while true do
                    if Timer_2:IsDescendantOf(game) then
                        if Timer_2 then
                            local v51 = statusText(GlobalBoost.Choices[v36])
                            if Timer_2.Text ~= v51 then
                                Timer_2.RichText = true
                                Timer_2.Text = v51
                            end
                        end
                    else
                        break
                    end
                    task.wait(0.25)
                end
                for v52, v53 in v48 do
                    v53:Disconnect()
                end
            end)
        else
            warn((("[AdminPanelBoosts] %* has no Timer label"):format((v27:GetFullName()))))
        end
        v30.Activated:Connect(function() -- line 176 | captures: v36, Timer_2, v31, AdminConchTypes, PotionConfig, GlobalBoost, statusText
            v36 = v36 % #GlobalBoost.Choices + 1
            if v31 and v31:IsA("TextLabel") then
                local v54 = GlobalBoost.Choices[v36]
                if v54 == AdminConchTypes.ALL_POTIONS then
                    v54 = GlobalBoost.AllName
                else
                    local v55 = PotionConfig.ById(v54)
                    if v55 then
                        v54 = v55.HoverName
                    end
                end
                v31.Text = v54
                local fromHex = Color3.fromHex
                local v56 = GlobalBoost.Choices[v36]
                local v57
                if v56 == AdminConchTypes.ALL_POTIONS then
                    v57 = GlobalBoost.AllColor
                else
                    local v58 = PotionConfig.ById(v56)
                    if v58 then
                        v57 = v58.Color
                    else
                        v57 = PotionConfig.HoverMultiplierColor
                    end
                end
                v31.TextColor3 = fromHex(v57)
            end
            if Timer_2 then
                local v59 = statusText(GlobalBoost.Choices[v36])
                if Timer_2.Text ~= v59 then
                    Timer_2.RichText = true
                    Timer_2.Text = v59
                end
            end
        end)

        local function scope() -- line 182 | captures: v26, GlobalBoost
            local Scope = v26:GetAttribute("Scope")
            if not (type(Scope) == "string" and GlobalBoost.Scopes[Scope]) then
                return GlobalBoost.DefaultScope
            end
            return Scope
        end

        local v60 = false
        local v61 = v32
        local v62 = v33

        local function send(v63) -- line 189 | captures: v36, v60, v26, Timer_2, v61, v62, ReplicatedStorage, AdminConchTypes, AdminConfig, NotificationController, UnitTextBox, GlobalBoost, statusText
            if v60 then
                return
            end
            local v64, v65
            if v63 == "Start" then
                local v66 = UnitTextBox.PrefixNumber(v61.Text, GlobalBoost.MultiplierPrefix)
                v64 = v66
                if not v66 or v66 <= 1 then
                    NotificationController.Show("Type a multiplier above 1 (e.g. 2)", "Error")
                    return
                end
                if GlobalBoost.MaxMultiplier < v66 then
                    NotificationController.Show(("The max multiplier is x%*"):format(GlobalBoost.MaxMultiplier), "Error")
                    return
                end
                local Text = v62.Text
                local v67 = UnitTextBox.Number(Text, GlobalBoost.MinutesSuffix)
                local v68
                if v67 then
                    local v69 = v67 * 60
                    v68 = math.floor(v69)
                else
                    v68 = AdminConchTypes.ParsePotionDuration(Text)
                end
                v65 = v68
                if not v68 or v68 < 1 then
                    NotificationController.Show("Type how long it lasts, in minutes (e.g. 10)", "Error")
                    return
                end
            end
            local v70 = ReplicatedStorage:FindFirstChild(AdminConfig.PanelRemotes.GlobalBoost)
            if v70 and v70:IsA("RemoteFunction") then
                v60 = true
                local v71, v72, v73 = pcall(function() -- line 218 | captures: v64, v65, v63, v70, v36, v26, GlobalBoost
                    local v74 = GlobalBoost.Choices[v36]
                    local v75 = v64
                    local v76 = v65
                    local Scope = v26:GetAttribute("Scope")
                    if not (type(Scope) == "string" and GlobalBoost.Scopes[Scope]) then
                        Scope = GlobalBoost.DefaultScope
                    end
                    return v70:InvokeServer(v63, v74, v75, v76, Scope)
                end)
                v60 = false
                if v71 then
                    if v72 == true then
                        if type(v73) == "string" then
                            NotificationController.Show(v73, "Success")
                        end
                    else
                        if type(v73) ~= "string" then
                            v73 = "something went wrong"
                        end
                        NotificationController.Show(("Global Boost failed: %*"):format(v73), "Error")
                    end
                else
                    v73 = "something went wrong"
                    NotificationController.Show(("Global Boost failed: %*"):format(v73), "Error")
                end
                if Timer_2 then
                    local v77 = statusText(GlobalBoost.Choices[v36])
                    if Timer_2.Text ~= v77 then
                        Timer_2.RichText = true
                        Timer_2.Text = v77
                    end
                end
            else
                NotificationController.Show("Global Boosts aren't ready yet", "Error")
            end
        end

        Start.Activated:Connect(function() -- line 233 | captures: send
            task.spawn(send, "Start")
        end)
        End.Activated:Connect(function() -- line 236 | captures: send
            task.spawn(send, "End")
        end)
    else
        warn("[AdminPanelBoosts] card needs Container.Boost.Pick, Multiplier / Duration TextBoxes, Container.Start + Container.End")
    end
end

return v1
