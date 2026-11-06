-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local v1 = {}

function v1.Wait() -- line 30 | captures: Players
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local v2 = PlayerGui:FindFirstChild("MainGUI")
    while not (v2 and v2:IsA("ScreenGui")) do
        PlayerGui.ChildAdded:Wait()
        v2 = PlayerGui:FindFirstChild("MainGUI")
    end
    return v2
end

function v1.Observe(v3) -- line 51 | captures: Players, v1
    task.spawn(function() -- line 52 | captures: v3, Players, v1
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local v4

        local function adopt(v5) -- line 55 | captures: v4, v3
            if v5 and v5 ~= v4 and v5.Name == "MainGUI" and v5:IsA("ScreenGui") then
                v4 = v5
                task.spawn(v3, v5)
            end
        end

        PlayerGui.ChildAdded:Connect(adopt)
        local v6 = v1.Wait()
        if v6 and v6 ~= v4 and v6.Name == "MainGUI" and v6:IsA("ScreenGui") then
            v4 = v6
            task.spawn(v3, v6)
        end
    end)
end

return v1
