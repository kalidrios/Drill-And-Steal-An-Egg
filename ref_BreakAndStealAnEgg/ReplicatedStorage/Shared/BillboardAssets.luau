-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = { FolderName = "BillboardGui" }
local v2 = {}

local function getFolder() -- line 27 | captures: ReplicatedStorage, v1
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    return Assets and Assets:FindFirstChild(v1.FolderName)
end

function v1.Find(v3) -- line 34 | captures: ReplicatedStorage, v1
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local v4 = Assets and Assets:FindFirstChild(v1.FolderName)
    local v5 = v4 and v4:FindFirstChild(v3)
    if v5 then
        if v5:IsA("BillboardGui") then
            return v5
        end
        return v5:FindFirstChildWhichIsA("BillboardGui")
    end
    return nil
end

function v1.Get(v6) -- line 51 | captures: v1, v2
    local v7 = v1.Find(v6)
    if not v7 and not v2[v6] then
        v2[v6] = true
        warn((("[BillboardAssets] ReplicatedStorage.Assets.%*.%* (BillboardGui) not found"):format(v1.FolderName, v6)))
    end
    return v7
end

return v1
