-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local PublicTreadmillConfig = require(ReplicatedStorage.Shared.PublicTreadmillConfig)
local NotificationController = require(script.Parent.Parent.Controllers.NotificationController)
local UnitTextBox = require(script.Parent.UnitTextBox)
local v1 = {}

local function boxIn(v2, v3) -- line 29
    local v4 = v2:FindFirstChild(v3)
    local v5 = v4 and v4:FindFirstChildWhichIsA("TextBox")
    if v5 and v5:IsA("TextBox") then
        return v5
    end
    return nil
end

function v1.Bind(v6, v7) -- line 35 | captures: ReplicatedStorage, AdminConfig, PublicTreadmillConfig, NotificationController, UnitTextBox
    local Multiplier = v7:FindFirstChild("Multiplier")
    local v8 = Multiplier and Multiplier:FindFirstChildWhichIsA("TextBox")
    if not (v8 and v8:IsA("TextBox")) then
        v8 = nil
    end
    local SpawnTime = v7:FindFirstChild("SpawnTime")
    local v9 = SpawnTime and SpawnTime:FindFirstChildWhichIsA("TextBox")
    if not (v9 and v9:IsA("TextBox")) then
        v9 = nil
    end
    local Spawn = v7:FindFirstChild("Spawn")
    if v8 and v9 and Spawn and Spawn:IsA("GuiButton") then
        Spawn:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
        Spawn:SetAttribute("PressScale", AdminConfig.PanelPressScale)
        UnitTextBox.BindPrefix(v8, "x")
        UnitTextBox.Bind(v9, "s")
        local v10 = false
        local v11 = v8
        local v12 = v9

        local function spawn() -- line 49 | captures: v10, v6, v11, v12, ReplicatedStorage, AdminConfig, PublicTreadmillConfig, NotificationController, UnitTextBox
            if not v10 then
                local x = UnitTextBox.PrefixNumber(v11.Text, "x")
                if not x or x <= 0 then
                    NotificationController.Show("Type a multiplier (e.g. 2)", "Error")
                else
                    local s = UnitTextBox.Number(v12.Text, "s")
                    if not s or s <= 0 then
                        NotificationController.Show("Type how long it stays, in seconds (e.g. 300)", "Error")
                    else
                        local v13 = ReplicatedStorage:FindFirstChild(AdminConfig.PanelRemotes.Treadmill)
                        if v13 and v13:IsA("RemoteFunction") then
                            local Scope = v6:GetAttribute("Scope")
                            local v14 = Scope
                            if type(Scope) == "string" then
                                if not PublicTreadmillConfig.AdminSpawn.Scopes[Scope] then
                                    v14 = PublicTreadmillConfig.AdminSpawn.DefaultScope
                                end
                            else
                                v14 = PublicTreadmillConfig.AdminSpawn.DefaultScope
                            end
                            v10 = true
                            local v15, v16, v17 = pcall(function() -- line 75 | captures: v14, x, s, v13
                                return v13:InvokeServer(x, s, v14)
                            end)
                            v10 = false
                            if v15 and v16 == true and v14 == "Global" and type(v17) == "string" then
                                NotificationController.Show(v17, "Success")
                            else
                                local v18, v19
                                if v15 then
                                    if v16 == true then
                                        v19 = true
                                    else
                                        if type(v17) == "string" then
                                            v18 = v17
                                        else
                                            v18 = "couldn't spawn"
                                        end
                                        v19 = false
                                    end
                                else
                                    v18 = "couldn't spawn"
                                    v19 = false
                                end
                                if not v19 then
                                    NotificationController.Show(("Admin Treadmill failed: %*"):format(v18), "Error")
                                end
                            end
                        else
                            NotificationController.Show("The Admin Treadmill isn't ready yet", "Error")
                        end
                    end
                end
            end
        end

        Spawn.Activated:Connect(function() -- line 88 | captures: spawn
            task.spawn(spawn)
        end)
    else
        warn("[AdminPanelTreadmill] card needs Container.Multiplier / SpawnTime TextBoxes + Container.Spawn")
    end
end

return v1
