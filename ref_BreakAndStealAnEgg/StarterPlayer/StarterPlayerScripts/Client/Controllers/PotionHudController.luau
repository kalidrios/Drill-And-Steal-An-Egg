-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local PotionConfig = require(ReplicatedStorage.Shared.PotionConfig)
local UiSpinFX = require(ReplicatedStorage.Shared.UiSpinFX)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local PotionInfoController = require(script.Parent.PotionInfoController)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2, v3
local v4 = {}

local function clearEntries() -- line 59 | captures: v4
    for v5, v6 in v4 do
        v6.Frame:Destroy()
    end
    table.clear(v4)
end

local function paintTimer(v7, v8) -- line 66 | captures: PotionConfig
    local v9 = PotionConfig.FormatTime(v7.Remaining())
    if v8.Timer and v8.LastText ~= v9 then
        v8.LastText = v9
        v8.Timer.Text = v9
    end
end

local function createEntry(v10, v11) -- line 74 | captures: v2, v3, PotionConfig, UiSpinFX, PotionInfoController
    local v12 = v2
    local v13 = v3
    local Potion, v14, Icon, v15
    if v12 and v13 and v13.Parent then
        Potion = v10.Potion
        v14 = v13:Clone()
        v14.Name = v10.Key
        v14.LayoutOrder = v11
        v14.Visible = true
        Icon = v14:FindFirstChild("Icon")
        v15 = Icon and Icon:FindFirstChild("Timer")
    else
        return nil
    end
    if Icon and (Icon:IsA("ImageButton") or Icon:IsA("ImageLabel")) then
        Icon:SetAttribute("NoButtonTween", nil)
        for v16, v17 in PotionConfig.IconTween do
            Icon:SetAttribute(v16, v17)
        end
        Icon.Image = Potion.Icon
        PotionInfoController.Bind(Icon, Potion)
    end
    local Sunray = v14:FindFirstChild("Sunray")
    if Sunray and Sunray:IsA("GuiObject") then
        UiSpinFX.Attach(Sunray, PotionConfig.SunrayDegreesPerSecond)
    end
    local v18 = { Frame = v14 }
    if not (v15 and v15:IsA("TextLabel")) then
        v15 = nil
    end
    v18.Timer = v15
    v18.Multiplier = v10.Multiplier
    local v19 = PotionConfig.FormatTime(v10.Remaining())
    if v18.Timer and v18.LastText ~= v19 then
        v18.LastText = v19
        v18.Timer.Text = v19
    end
    v14.Parent = v12
    return v18
end

local function ownSource(v20) -- line 113 | captures: PotionConfig, LocalPlayer
    local v21 = {
        Key = v20.Id,
        Potion = v20
    }

    function v21.Remaining() -- line 117 | captures: v20, PotionConfig, LocalPlayer
        return PotionConfig.RemainingFor(LocalPlayer, v20.Id)
    end

    return v21
end

local function globalSource(v22) -- line 124 | captures: PotionConfig
    local v23 = PotionConfig.GlobalMultiplier(v22.Id)
    local v24 = table.clone(v22)
    v24.HoverMultiplier = "x" .. string.format("%g", v23)
    v24.HoverName = ("%* %*"):format(v22.HoverName, PotionConfig.GlobalHoverName)
    v24.HoverInfo = PotionConfig.GlobalHoverInfo
    local v25 = {
        Key = ("Global_%*"):format(v22.Id),
        Potion = v24
    }

    function v25.Remaining() -- line 133 | captures: v22, PotionConfig
        return PotionConfig.GlobalRemaining(v22.Id)
    end

    v25.Multiplier = v23
    return v25
end

local function sync(v26, v27, v28) -- line 141 | captures: PotionConfig, v4, createEntry
    local v29 = v4[v26]
    local v30, v31
    if v29 then
        if v27 and v29.Multiplier == v27.Multiplier then
            v30 = v29
            v31 = true
        else
            v31 = false
        end
    else
        v30 = v29
        v31 = true
    end
    if not v31 then
        v29.Frame:Destroy()
        v4[v26] = nil
        v30 = nil
    end
    if v27 then
        if not (v30 and v30.Frame.Parent) then
            v30 = createEntry(v27, v28)
            v4[v26] = v30
        end
        if v30 then
            local v32 = PotionConfig.FormatTime(v27.Remaining())
            if v30.Timer and v30.LastText ~= v32 then
                v30.LastText = v32
                v30.Timer.Text = v32
            end
        end
    end
end

local function refresh() -- line 162 | captures: PotionConfig, LocalPlayer, globalSource, sync
    local v33 = #PotionConfig.Potions
    for v34, v35 in PotionConfig.Potions do
        local v36 = {
            Key = v35.Id,
            Potion = v35
        }
        local v37 = v35

        function v36.Remaining() -- line 117 | captures: v37, PotionConfig, LocalPlayer
            return PotionConfig.RemainingFor(LocalPlayer, v37.Id)
        end

        local Key = v36.Key
        if not (PotionConfig.RemainingFor(LocalPlayer, v35.Id) > 0) then
            v36 = nil
        end
        sync(Key, v36, v34)
        local v38 = PotionConfig.GlobalRemaining(v35.Id) > 0
        local v39 = ("Global_%*"):format(v35.Id)
        local v40
        if v38 then
            v40 = globalSource(v35)
        end
        sync(v39, v40, v33 + v34)
    end
end

local function adopt(v41) -- line 172 | captures: v2, v3, PotionConfig, v4, refresh
    for v42, v43 in v4 do
        v43.Frame:Destroy()
    end
    table.clear(v4)
    v2 = nil
    v3 = nil
    local v44 = v41
    for v45, v46 in PotionConfig.HudPath do
        v44 = v44 and v44:FindFirstChild(v46)
    end
    if v44 then
        local v47 = v44:FindFirstChild(PotionConfig.HudTemplateName)
        if v47 and v47:IsA("GuiObject") then
            v47.Visible = false
            v2 = v44
            v3 = v47
            refresh()
            return
        end
    end
    warn((("[PotionHudController] MainGUI.%*.%* not found"):format(table.concat(PotionConfig.HudPath, "."), PotionConfig.HudTemplateName)))
end

function v1.Start() -- line 193 | captures: v2, Workspace, PotionConfig, MainGui, LocalPlayer, refresh, adopt
    for v48, v49 in PotionConfig.Potions do
        LocalPlayer:GetAttributeChangedSignal(PotionConfig.EndsAtAttribute(v49.Id)):Connect(refresh)
        Workspace:GetAttributeChangedSignal(PotionConfig.GlobalEndsAtAttribute(v49.Id)):Connect(refresh)
        Workspace:GetAttributeChangedSignal(PotionConfig.GlobalMultiplierAttribute(v49.Id)):Connect(refresh)
    end
    MainGui.Observe(adopt)
    task.spawn(function() -- line 202 | captures: v2, refresh
        while true do
            task.wait(0.25)
            if v2 and v2.Parent then
                refresh()
            end
        end
    end)
end

return v1
