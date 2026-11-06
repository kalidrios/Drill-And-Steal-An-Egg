-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local v1 = {}
local v2 = {}

local function rewardList() -- line 24 | captures: Players
    local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    local v3 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v4 = v3 and v3:FindFirstChild("Frames")
    local v5 = v4 and v4:FindFirstChild("Index")
    local v6 = v5 and v5:FindFirstChild("Reward")
    return v6 and v6:FindFirstChild("List")
end

local function iconFor(v7) -- line 33 | captures: v2, rewardList
    local v8 = v2[v7]
    if v8 then
        return v8
    end
    local v9 = rewardList()
    local v10 = v9 and v9:FindFirstChild(v7)
    local v11 = v10 and v10:FindFirstChild("Icon")
    if v11 and v11:IsA("ImageLabel") and v11.Image ~= "" then
        v2[v7] = v11.Image
        return v11.Image
    end
    return nil
end

function v1.Cash() -- line 48 | captures: iconFor
    return (iconFor("Cash"))
end

function v1.Speed() -- line 52 | captures: iconFor
    return (iconFor("Speed"))
end

return v1
