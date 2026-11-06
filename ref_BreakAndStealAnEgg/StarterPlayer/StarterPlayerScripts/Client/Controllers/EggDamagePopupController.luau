-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local BillboardAssets = require(ReplicatedStorage.Shared.BillboardAssets)
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local EggLocalHits = require(script.Parent.EggLocalHits)
local v1 = {}
local v2 = { "Amount", "Damage", "Text", "Label" }
local v3 = TweenInfo.new(0.37, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.28)
local v6 = Random.new()
local LocalPlayer = Players.LocalPlayer
local v7 = if v6:NextNumber() < 0.5 then -1 else 1

local function getHolder() -- line 84 | captures: LocalPlayer
    local v8 = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if v8 then
        local EggDamagePopups = v8:FindFirstChild("EggDamagePopups")
        if EggDamagePopups and EggDamagePopups:IsA("ScreenGui") then
            return EggDamagePopups
        end
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "EggDamagePopups"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = v8
        return ScreenGui
    end
    return nil
end

local function findAmountLabel(v9) -- line 101 | captures: v2
    for v10, v11 in v2 do
        local v12 = v9:FindFirstChild(v11, true)
        if v12 and v12:IsA("TextLabel") then
            return v12
        end
    end
    return v9:FindFirstChildWhichIsA("TextLabel", true)
end

local function ensureScale(v13, v14) -- line 114
    local v15 = v13:FindFirstChildOfClass("UIScale") or v14 and v14:FindFirstChildOfClass("UIScale")
    if v15 then
        return v15
    end
    if v14 then
        local UIScale = Instance.new("UIScale")
        UIScale.Parent = v14
        return UIScale
    end
    return nil
end

local function collectFadeTargets(v16) -- line 129
    local v17 = {}
    for v18, v19 in v16:GetDescendants() do
        if v19:IsA("TextLabel") then
            local v20 = {
                Property = "TextTransparency",
                Instance = v19
            }
            table.insert(v17, v20)
        elseif v19:IsA("ImageLabel") then
            local v21 = {
                Property = "ImageTransparency",
                Instance = v19
            }
            table.insert(v17, v21)
        elseif v19:IsA("UIStroke") then
            local v22 = {
                Property = "Transparency",
                Instance = v19
            }
            table.insert(v17, v22)
        end
    end
    return v17
end

local function showDamagePopup(v23, v24) -- line 145 | captures: v7, Debris, TweenService, BillboardAssets, FormatNumber, v3, v4, v5, v6, getHolder, findAmountLabel, collectFadeTargets
    if v24 <= 0 then
        return
    end
    local Character = v23.Character
    local v25 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (v25 and v25:IsA("BasePart")) then
        return
    end
    local EggDamagePopup = BillboardAssets.Get("EggDamagePopup")
    local v26 = getHolder()
    local v27
    if EggDamagePopup and v26 then
        v27 = EggDamagePopup:Clone()
        v27.Name = "EggDamage"
        v27.Adornee = v25
        v27.Enabled = true
        local v28 = findAmountLabel(v27)
        if v28 then
            local Short = FormatNumber.Short
            local v29 = math.round(v24)
            v28.Text = ("-%*"):format((Short((math.max(v29, 1)))))
        end
    else
        return
    end
    local v30 = v27.StudsOffsetWorldSpace + Vector3.new(0, 2.5999999046325684, 0)
    v27.StudsOffsetWorldSpace = v30
    local v31 = v6:NextNumber(1.6, 2.6)
    local v32 = v30 + Vector3.new(0, v31, 0)
    local v33 = v7 * v6:NextNumber(0.7, 1.5)
    v7 = -v7
    local v34 = v27.StudsOffset + Vector3.new(v33, 0, 0)
    local GuiObject = v27:FindFirstChildWhichIsA("GuiObject")
    local v35 = v33 * 5.333333333333333
    local v36 = math.clamp(v35, -8, 8)
    local v37 = v27:FindFirstChildOfClass("UIScale") or GuiObject and GuiObject:FindFirstChildOfClass("UIScale")
    if not v37 then
        if GuiObject then
            v37 = Instance.new("UIScale")
            v37.Parent = GuiObject
        else
            v37 = nil
        end
    end
    local v38
    if v37 then
        v38 = v37.Scale
        v37.Scale = 0
    else
        v38 = 1
    end
    v27.Parent = v26
    if v37 then
        TweenService:Create(v37, v3, { Scale = v38 }):Play()
    end
    TweenService:Create(v27, v4, {
        StudsOffsetWorldSpace = v32,
        StudsOffset = v34
    }):Play()
    if GuiObject then
        TweenService:Create(GuiObject, v4, { Rotation = GuiObject.Rotation + v36 }):Play()
    end
    local v39 = collectFadeTargets(v27)
    local delay = task.delay
    local v40 = v27
    delay(0.55, function() -- line 200 | captures: v32, v39, v40, TweenService, v5
        if v40.Parent ~= nil then
            for v41, v42 in v39 do
                TweenService:Create(v42.Instance, v5, { [v42.Property] = 1 }):Play()
            end
            TweenService:Create(v40, v5, { StudsOffsetWorldSpace = v32 + Vector3.new(0, -0.6000000238418579, 0) }):Play()
        end
    end)
    Debris:AddItem(v27, 0.93)
end

local function inHell(v43) -- line 224 | captures: HellEventConfig
    return v43:GetAttribute(HellEventConfig.PlayerAttribute) == true
end

function v1.Start() -- line 228 | captures: ReplicatedStorage, HellEventConfig, EggLocalHits, LocalPlayer, showDamagePopup
    EggLocalHits.OnHit(function(v44, v45, v46) -- line 231 | captures: HellEventConfig, LocalPlayer, showDamagePopup
        if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) ~= true then
            showDamagePopup(LocalPlayer, v46)
        end
    end)
    task.spawn(function() -- line 243 | captures: ReplicatedStorage, HellEventConfig, LocalPlayer, showDamagePopup
        local v47 = ReplicatedStorage:WaitForChild("EggHitLanded", 30)
        if v47 and v47:IsA("RemoteEvent") then
            v47.OnClientEvent:Connect(function(v48, v49) -- line 248 | captures: HellEventConfig, LocalPlayer, showDamagePopup
                if not (typeof(v48) == "Instance" and v48:IsA("Player") and v48 ~= LocalPlayer and typeof(v49) == "number" and v48:GetAttribute(HellEventConfig.PlayerAttribute) ~= true) then
                    return
                end
                local Character = v48.Character
                local v50 = Character and Character:FindFirstChild("HumanoidRootPart")
                local CurrentCamera = workspace.CurrentCamera
                if v50 and v50:IsA("BasePart") and CurrentCamera and not ((v50.Position - CurrentCamera.CFrame.Position).Magnitude > 120) then
                    showDamagePopup(v48, v49)
                end
            end)
        end
    end)
end

function v1.Show(v51, v52) -- line 271 | captures: showDamagePopup
    showDamagePopup(v51, v52)
end

return v1
