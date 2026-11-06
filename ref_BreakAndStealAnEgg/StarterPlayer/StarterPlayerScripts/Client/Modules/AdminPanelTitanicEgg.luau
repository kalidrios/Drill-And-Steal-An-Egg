-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local TitanicEggConfig = require(ReplicatedStorage.Shared.TitanicEggConfig)
local ZoneDisplayInfo = require(ReplicatedStorage.Shared.ZoneDisplayInfo)
local AdminEditDropdown = require(script.Parent.AdminEditDropdown)
local NotificationController = require(script.Parent.Parent.Controllers.NotificationController)
local v1 = {}
local TitanicEgg = AdminConfig.TitanicEgg

local function setRowTitle(v2, v3) -- line 45
    local Button = v2:FindFirstChild("Button")
    local v4 = Button and Button:FindFirstChild("Title")
    if v4 and v4:IsA("TextLabel") then
        v4.Text = v3
    end
end

local function buildZoneRows(v5) -- line 55 | captures: TitanicEggConfig, ZoneDisplayInfo
    local v6 = {}
    local Template = v5:FindFirstChild("Template")
    if not (Template and Template:IsA("GuiObject")) then
        warn("[AdminPanelTitanicEgg] ZoneList.Template is missing \226\128\148 only Random can be picked")
    else
        Template.Visible = false
        local v7 = TitanicEggConfig.FirstZone
        while true do
            local v8 = ZoneDisplayInfo[("Zone%*"):format(v7)]
            if v8 then
                v6[v8.Name] = v7
                if not v5:FindFirstChild(v8.Name) then
                    local v9 = Template:Clone()
                    v9.Name = v8.Name
                    v9.LayoutOrder = Template.LayoutOrder + v7
                    v9.Visible = true
                    local Name = v8.Name
                    local Button = v9:FindFirstChild("Button")
                    if Button then
                        Button = Button:FindFirstChild("Title")
                        if Button and Button:IsA("TextLabel") then
                            Button.Text = Name
                        end
                    end
                    v9.Parent = v5
                end
            else
                break
            end
            v7 += 1
        end
    end
    return v6
end

function v1.Bind(v10, v11) -- line 84 | captures: ReplicatedStorage, AdminConfig, AdminEditDropdown, NotificationController, TitanicEgg, buildZoneRows
    local v12 = v11:FindFirstChild(TitanicEgg.ToggleName)
    local v13 = v11:FindFirstChild(TitanicEgg.ListName)
    local Spawn = v11:FindFirstChild("Spawn")
    if v12 and v12:IsA("GuiButton") and v13 and v13:IsA("GuiObject") and Spawn and Spawn:IsA("GuiButton") then
        for v14, v15 in { v12, Spawn } do
            v15:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
            v15:SetAttribute("PressScale", AdminConfig.PanelPressScale)
        end
        local v16 = buildZoneRows(v13)
        local v17 = AdminEditDropdown.Bind(v11, TitanicEgg.RandomOption, nil, {
            Toggle = v12,
            List = v13
        })
        local v18 = false

        local function spawn() -- line 113 | captures: v18, v16, v17, ReplicatedStorage, AdminConfig, NotificationController, TitanicEgg
            if v18 then
                return
            end
            local v19 = ReplicatedStorage:FindFirstChild(AdminConfig.PanelRemotes.TitanicEgg)
            if v19 and v19:IsA("RemoteFunction") then
                local v20
                if v17 then
                    v20 = v17.GetValue()
                else
                    v20 = TitanicEgg.RandomOption
                end
                local v21 = v16[v20]
                v18 = true
                local v22, v23, v24 = pcall(function() -- line 126 | captures: v19, v21
                    return v19:InvokeServer(v21)
                end)
                v18 = false
                if v22 and v23 == true then
                    local Show = NotificationController.Show
                    local v25 = if type(v24) == "string" then v24 else "Titanic Egg spawned"
                    Show(v25, "Success")
                else
                    if not (v22 and type(v24) == "string") then
                        v24 = "couldn't spawn"
                    end
                    NotificationController.Show(("Titanic Egg failed: %*"):format(v24), "Error")
                end
            else
                NotificationController.Show("Titanic spawning isn't ready yet", "Error")
            end
        end

        Spawn.Activated:Connect(function() -- line 138 | captures: spawn
            task.spawn(spawn)
        end)
        return v17
    end
    warn((("[AdminPanelTitanicEgg] card needs Container.%* + Container.%* + Container.Spawn"):format(TitanicEgg.ToggleName, TitanicEgg.ListName)))
    return nil
end

return v1
