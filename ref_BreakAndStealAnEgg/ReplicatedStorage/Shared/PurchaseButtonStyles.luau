-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = {
    FolderName = "PurchaseButtonsGradients",
    Affordable = "Affordable",
    NoneAffordable = "NoneAffordable"
}
local v2 = {}

local function getFolder() -- line 41 | captures: ReplicatedStorage, v1
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    return Assets and Assets:FindFirstChild(v1.FolderName)
end

local function SnapshotGradient(v3) -- line 46
    return {
        Color = v3.Color,
        Rotation = v3.Rotation,
        Transparency = v3.Transparency,
        Offset = v3.Offset
    }
end

v1.SnapshotGradient = SnapshotGradient

local function SnapshotStroke(v4) -- line 55
    return {
        Color = v4.Color,
        Transparency = v4.Transparency
    }
end

v1.SnapshotStroke = SnapshotStroke

function v1.Get(v5) -- line 64 | captures: ReplicatedStorage, v1, v2
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local v6 = Assets and Assets:FindFirstChild(v1.FolderName)
    local v7 = v6 and v6:FindFirstChild(v5)
    if v7 then
        local v8 = {
            Gradient = nil,
            Strokes = {}
        }
        for v9, v10 in v7:GetChildren() do
            if v10:IsA("UIGradient") then
                v8.Gradient = v1.SnapshotGradient(v10)
            elseif v10:IsA("UIStroke") then
                v8.Strokes[v10.Name] = v1.SnapshotStroke(v10)
            end
        end
        return v8
    end
    if not v2[v5] then
        v2[v5] = true
        warn((("[PurchaseButtonStyles] ReplicatedStorage.Assets.%*.%* not found"):format(v1.FolderName, v5)))
    end
    return nil
end

local function ApplyGradient(v11, v12) -- line 86
    v11.Color = v12.Color
    v11.Rotation = v12.Rotation
    v11.Transparency = v12.Transparency
    v11.Offset = v12.Offset
end

v1.ApplyGradient = ApplyGradient

local function ApplyStroke(v13, v14) -- line 93
    v13.Color = v14.Color
    v13.Transparency = v14.Transparency
end

v1.ApplyStroke = ApplyStroke
return v1
