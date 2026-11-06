-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2

local function bind(v3) -- line 26 | captures: v2, LocalPlayer
    v2 = nil
    local v4 = v3:WaitForChild("HumanoidRootPart", 10)
    if v4 and v4:IsA("BasePart") and LocalPlayer.Character == v3 then
        v2 = v4
    end
end

if LocalPlayer.Character then
    task.spawn(bind, LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(bind)
LocalPlayer.CharacterRemoving:Connect(function() -- line 41 | captures: v2
    v2 = nil
end)

function v1.GetRoot() -- line 46 | captures: v2, LocalPlayer
    local v5 = v2
    if not (v5 and v5.Parent == nil) then
        if v5 == nil then
            local Character = LocalPlayer.Character
            local v6 = Character and Character:FindFirstChild("HumanoidRootPart")
            if v6 and v6:IsA("BasePart") then
                v2 = v6
                return v6
            end
        end
        return v5
    end
    v2 = nil
    return nil
end

function v1.GetPosition() -- line 67 | captures: v1
    local v7 = v1.GetRoot()
    return v7 and v7.Position
end

return v1
