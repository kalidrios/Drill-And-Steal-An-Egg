-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local BillboardAssets = require(script.Parent.BillboardAssets)
local FormatNumber = require(script.Parent.FormatNumber)
local v1 = {
    TemplateName = "AnimalCashGainPopup",
    HolderName = "AnimalCashPopups",
    AmountNames = { "Amount", "Cash", "CashGain", "Gain", "Text", "Label" },
    MinScale = 0.85,
    MaxScale = 2.2
}
local v2 = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(1.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.4)

v1.HeightAboveHead = 1
v1.Lanes = { -1, 0, 1 }
v1.SideGap = 0.6
v1.SideHeightMin = 0.55
v1.SideHeightMax = 0.85

local v5 = Random.new()
local v6 = {}
local v7 = { __mode = "k" }
local v8 = setmetatable(v6, v7)
local LocalPlayer = Players.LocalPlayer

local function getTemplate() -- line 126 | captures: BillboardAssets, v1
    return BillboardAssets.Get(v1.TemplateName)
end

local function getHolder() -- line 132 | captures: v1, LocalPlayer
    if LocalPlayer then
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if PlayerGui then
            local v9 = PlayerGui:FindFirstChild(v1.HolderName)
            if v9 and v9:IsA("ScreenGui") then
                return v9
            end
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = v1.HolderName
            ScreenGui.ResetOnSpawn = false
            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ScreenGui.Parent = PlayerGui
            return ScreenGui
        end
    end
    return nil
end

local function findAmountLabel(v10) -- line 158 | captures: v1
    for v11, v12 in v1.AmountNames do
        local v13 = v10:FindFirstChild(v12, true)
        if v13 and v13:IsA("TextLabel") then
            return v13
        end
    end
    return v10:FindFirstChildWhichIsA("TextLabel", true)
end

local function ensureScale(v14, v15) -- line 173
    local v16 = v14:FindFirstChildOfClass("UIScale") or v15 and v15:FindFirstChildOfClass("UIScale")
    if v16 then
        return v16
    end
    if v15 then
        local UIScale = Instance.new("UIScale")
        UIScale.Parent = v15
        return UIScale
    end
    return nil
end

local function collectFadeTargets(v17) -- line 191
    local v18 = {}
    for v19, v20 in v17:GetDescendants() do
        if v20:IsA("TextLabel") or v20:IsA("TextButton") then
            local v21 = {
                Property = "TextTransparency",
                Instance = v20
            }
            table.insert(v18, v21)
            if v20.BackgroundTransparency < 1 then
                local v22 = {
                    Property = "BackgroundTransparency",
                    Instance = v20
                }
                table.insert(v18, v22)
            end
        elseif v20:IsA("ImageLabel") or v20:IsA("ImageButton") then
            local v23 = {
                Property = "ImageTransparency",
                Instance = v20
            }
            table.insert(v18, v23)
            if v20.BackgroundTransparency < 1 then
                local v24 = {
                    Property = "BackgroundTransparency",
                    Instance = v20
                }
                table.insert(v18, v24)
            end
        elseif v20:IsA("UIStroke") then
            local v25 = {
                Property = "Transparency",
                Instance = v20
            }
            table.insert(v18, v25)
        elseif v20:IsA("Frame") and v20.BackgroundTransparency < 1 then
            local v26 = {
                Property = "BackgroundTransparency",
                Instance = v20
            }
            table.insert(v18, v26)
        end
    end
    return v18
end

local function HeadHeight(v27, v28) -- line 230
    local v29 = v28 or v27.PrimaryPart or v27:FindFirstChildWhichIsA("BasePart", true)
    if v29 then
        local v30, v31 = v27:GetBoundingBox()
        local Y = v30.RightVector.Y
        local v32 = math.abs(Y) * v31.X
        local Y_2 = v30.UpVector.Y
        local v33 = v32 + math.abs(Y_2) * v31.Y
        local Y_3 = v30.LookVector.Y
        local v34 = (v33 + math.abs(Y_3) * v31.Z) / 2
        local v35 = v30.Position.Y + v34 - v29.Position.Y
        return (math.max(v35, 0))
    end
    return 0
end

v1.HeadHeight = HeadHeight

local function SideReach(v36) -- line 252
    local v37, v38 = v36:GetBoundingBox()
    local RightVector = v37.RightVector
    local UpVector = v37.UpVector
    local LookVector = v37.LookVector
    local X = RightVector.X
    local v39 = math.abs(X) * v38.X
    local X_2 = UpVector.X
    local v40 = v39 + math.abs(X_2) * v38.Y
    local X_3 = LookVector.X
    local v41 = v40 + math.abs(X_3) * v38.Z
    local Z = RightVector.Z
    local v42 = math.abs(Z) * v38.X
    local Z_2 = UpVector.Z
    local v43 = v42 + math.abs(Z_2) * v38.Y
    local Z_3 = LookVector.Z
    local v44 = v43 + math.abs(Z_3) * v38.Z
    return math.max(v41, v44) / 2
end

v1.SideReach = SideReach

local function pickLane(v45) -- line 262 | captures: v1, v5, v8
    local Lanes = v1.Lanes
    local v46 = v8[v45]
    local v47 = {}
    for v48, v49 in Lanes do
        if v49 ~= v46 then
            table.insert(v47, v49)
        end
    end
    if #v47 ~= 0 then
        Lanes = v47
    end
    local v50 = Lanes[v5:NextInteger(1, #Lanes)]
    v8[v45] = v50
    return v50
end

function v1.Play(v51, v52, v53) -- line 284 | captures: Debris, TweenService, BillboardAssets, FormatNumber, v1, v2, v3, v4, v5, getHolder, findAmountLabel, collectFadeTargets, pickLane
    local v54, v55
    if v52 <= 0 then
        v55 = true
    elseif v51.Parent then
        v54 = v51.PrimaryPart or v51:FindFirstChildWhichIsA("BasePart", true)
        v55 = false
    else
        v55 = true
    end
    if v55 then
        return nil
    end
    if v54 then
        local v56 = BillboardAssets.Get(v1.TemplateName)
        local v57 = getHolder()
        local v58
        if v56 and v57 then
            v58 = v53 or {}
        else
            return nil
        end
        local v59 = v56:Clone()
        v59.Name = "AnimalCashGain"
        v59.Adornee = v54
        v59.Enabled = true
        local v60 = findAmountLabel(v59)
        if v60 then
            local v61 = v58.Prefix or "+"
            local Short = FormatNumber.Short
            local v62 = math.round(v52)
            v60.Text = ("%*$%*"):format(v61, (Short((math.max(v62, 1)))))
            if v58.Color then
                v60.TextColor3 = v58.Color
            end
        end
        local v63 = v58.SizeMult or 1
        local MinScale = v1.MinScale
        local MaxScale = v1.MaxScale
        local v64 = math.clamp(v63, MinScale, MaxScale)
        if v64 ~= 1 then
            v59.Size = UDim2.new(v59.Size.X.Scale * v64, v59.Size.X.Offset * v64, v59.Size.Y.Scale * v64, v59.Size.Y.Offset * v64)
        end
        local StudsOffsetWorldSpace = v59.StudsOffsetWorldSpace
        local v65 = v58.HeadHeight or v1.HeadHeight(v51, v54)
        local v66 = pickLane(v51)
        local v67 = if v66 == 0 then v65 + v1.HeightAboveHead else v65 * v5:NextNumber(v1.SideHeightMin, v1.SideHeightMax)
        local X = StudsOffsetWorldSpace.X
        local Z = StudsOffsetWorldSpace.Z
        local v68 = Vector3.new(X, v67, Z)
        v59.StudsOffsetWorldSpace = v68
        local v69 = v58.SideReach or v1.SideReach(v51)
        local StudsOffset = v59.StudsOffset
        local v70 = v66 * (v69 + v1.SideGap)
        v59.StudsOffset = StudsOffset + Vector3.new(v70, 0, 0)
        local v71 = v5:NextNumber(2.6, 4.2)
        local v72 = v68 + Vector3.new(0, v71, 0)
        local v73
        if v66 == 0 then
            v73 = v5:NextNumber(-0.9, 0.9)
        else
            v73 = v66 * v5:NextNumber(0, 0.9)
        end
        local v74 = v59.StudsOffset + Vector3.new(v73, 0, 0)
        local GuiObject = v59:FindFirstChildWhichIsA("GuiObject")
        local v75 = v73 * 10
        local v76 = math.clamp(v75, -9, 9)
        local v77 = v59:FindFirstChildOfClass("UIScale") or GuiObject and GuiObject:FindFirstChildOfClass("UIScale")
        if not v77 then
            if GuiObject then
                v77 = Instance.new("UIScale")
                v77.Parent = GuiObject
            else
                v77 = nil
            end
        end
        local v78
        if v77 then
            v78 = v77.Scale
            v77.Scale = 0
        else
            v78 = 1
        end
        v59.Parent = v57
        if v77 then
            TweenService:Create(v77, v2, { Scale = v78 }):Play()
        end
        TweenService:Create(v59, v3, {
            StudsOffsetWorldSpace = v72,
            StudsOffset = v74
        }):Play()
        if GuiObject then
            TweenService:Create(GuiObject, v3, { Rotation = GuiObject.Rotation + v76 }):Play()
        end
        local v79 = collectFadeTargets(v59)
        task.delay(0.8700000000000001, function() -- line 364 | captures: v59, v79, TweenService, v4
            if v59.Parent ~= nil then
                for v80, v81 in v79 do
                    TweenService:Create(v81.Instance, v4, { [v81.Property] = 1 }):Play()
                end
            end
        end)
        Debris:AddItem(v59, 1.37)
        return v59
    end
    return nil
end

local function Duration() -- line 381
    return 1.27
end

v1.Duration = Duration
return v1
