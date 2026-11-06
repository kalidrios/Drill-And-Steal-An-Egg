-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local RranBossConfig = require(ReplicatedStorage.Shared.RranBossConfig)
local NotificationController = require(script.Parent.Parent.Controllers.NotificationController)
local UnitTextBox = require(script.Parent.UnitTextBox)
local v1 = {}

function v1.Bind(v2, v3) -- line 27 | captures: ReplicatedStorage, AdminConfig, RranBossConfig, NotificationController, UnitTextBox
    local SpawnTime = v3:FindFirstChild("SpawnTime")
    local v4 = SpawnTime and SpawnTime:FindFirstChildWhichIsA("TextBox")
    local Spawn = v3:FindFirstChild("Spawn")
    if v4 and v4:IsA("TextBox") and Spawn and Spawn:IsA("GuiButton") then
        Spawn:SetAttribute("HoverScale", AdminConfig.PanelHoverScale)
        Spawn:SetAttribute("PressScale", AdminConfig.PanelPressScale)
        UnitTextBox.Bind(v4, "s")
        local v5 = false

        local function spawn() -- line 42 | captures: v5, v2, v4, ReplicatedStorage, AdminConfig, RranBossConfig, NotificationController, UnitTextBox
            if not v5 then
                local s = UnitTextBox.Number(v4.Text, "s")
                if not s or s <= 0 then
                    NotificationController.Show("Type how long the bosses stay, in seconds (e.g. 300)", "Error")
                else
                    local v6 = ReplicatedStorage:FindFirstChild(AdminConfig.PanelRemotes.BossSpawn)
                    if v6 and v6:IsA("RemoteFunction") then
                        local Scope = v2:GetAttribute("Scope")
                        local v7 = Scope
                        if type(Scope) == "string" then
                            if not RranBossConfig.Scopes[Scope] then
                                v7 = RranBossConfig.DefaultScope
                            end
                        else
                            v7 = RranBossConfig.DefaultScope
                        end
                        v5 = true
                        local v8, v9, v10 = pcall(function() -- line 63 | captures: v7, s, v6
                            return v6:InvokeServer(s, v7)
                        end)
                        v5 = false
                        if v8 and v9 == true and v7 == "Global" and type(v10) == "string" then
                            NotificationController.Show(v10, "Success")
                        else
                            local v11, v12
                            if v8 then
                                if v9 == true then
                                    v12 = true
                                else
                                    if type(v10) == "string" then
                                        v11 = v10
                                    else
                                        v11 = "couldn't spawn"
                                    end
                                    v12 = false
                                end
                            else
                                v11 = "couldn't spawn"
                                v12 = false
                            end
                            if not v12 then
                                NotificationController.Show(("Boss Spawn failed: %*"):format(v11), "Error")
                            end
                        end
                    else
                        NotificationController.Show("Boss spawning isn't ready yet", "Error")
                    end
                end
            end
        end

        Spawn.Activated:Connect(function() -- line 76 | captures: spawn
            task.spawn(spawn)
        end)
    else
        warn("[AdminPanelBossSpawn] card needs Container.SpawnTime.TextBox + Container.Spawn")
    end
end

return v1
