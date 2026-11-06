-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local HellEssenceConfig = require(ReplicatedStorage.Shared.HellEssenceConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local StackedText = require(script.Parent.StackedText)
local v1 = {}
local Bar = HellEssenceConfig.Bar
local HpCountUp = HellEventConfig.HpCountUp
local v2 = {}
local v3 = { __mode = "k" }
local v4 = setmetatable(v2, v3)

local function resolve(v5, v6) -- line 46
    local v7 = v5
    for v8, v9 in v6 do
        v7 = v7 and v7:FindFirstChild(v9)
    end
    return v7
end

local function slider(v10, v11) -- line 54
    local v12
    if v11 then
        local v13 = v10
        v12 = v10
        for v14, v15 in v11 do
            v13 = v13 and v13:FindFirstChild(v15)
            v12 = v13
        end
    else
        v12 = v11
    end
    if not (v12 and v12:IsA("GuiObject")) then
        return nil
    end
    return {
        Instance = v12,
        Position = v12.Position,
        Lead = (1 - v12.AnchorPoint.X) * v12.Size.X.Scale
    }
end

local function stateOf(v16) -- line 62 | captures: HpCountUp, v4, slider
    local v17 = v4[v16]
    if not v17 then
        local v18 = v16
        for v19, v20 in HpCountUp.TextPath do
            v18 = v18 and v18:FindFirstChild(v20)
        end
        v17 = {
            Shown = 0,
            ShownHave = 0,
            Glide = nil,
            Fill = slider(v16, HpCountUp.BarPath),
            Trail = slider(v16, HpCountUp.TrailPath)
        }
        if not (v18 and v18:IsA("TextLabel")) then
            v18 = nil
        end
        v17.Label = v18
        v4[v16] = v17
    end
    return v17
end

local function place(v21, v22) -- line 79
    if v21 then
        local Position = v21.Position
        v21.Instance.Position = UDim2.new(v22 - v21.Lead, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
    end
end

local function setLooks(v23, v24, v25) -- line 87 | captures: StackedText, Bar
    local v26 = v23:FindFirstChild(Bar.IconName)
    if v26 and (v26:IsA("ImageLabel") or v26:IsA("ImageButton")) then
        v26.Image = v24
    end
    local v27 = v23:FindFirstChild(Bar.TitleName)
    if not (v27 and v27:IsA("TextLabel")) then
        return
    end
    v27.Visible = v25 ~= nil
    if v25 then
        StackedText.Set(v27, v25)
    end
end

local function showShare(v28, v29) -- line 101
    v28.Shown = v29
    local Fill = v28.Fill
    if Fill then
        local Position = Fill.Position
        Fill.Instance.Position = UDim2.new(v29 - Fill.Lead, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
    end
    local Trail = v28.Trail
    if Trail then
        local Position = Trail.Position
        Trail.Instance.Position = UDim2.new(v29 - Trail.Lead, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
    end
end

local function setText(v30, v31, v32) -- line 107 | captures: FormatNumber, Bar
    if v30.Label then
        v30.Label.Text = string.format(Bar.Format, FormatNumber.Commas((math.floor(v31))), FormatNumber.Commas((math.floor(v32))))
    end
end

local function stopGlide(v33) -- line 113
    if v33.Glide then
        v33.Glide:Disconnect()
        v33.Glide = nil
    end
end

function v1.Show(v34, v35, v36) -- line 120 | captures: FormatNumber, Bar, stateOf, setLooks
    local v37 = stateOf(v34)
    if v37.Glide then
        v37.Glide:Disconnect()
        v37.Glide = nil
    end
    local Icon = Bar.Icon
    local v38 = if Bar.ShowTitle then Bar.Title else nil
    setLooks(v34, Icon, v38)
    if v37.Label then
        v37.Label.Text = string.format(Bar.Format, FormatNumber.Commas((math.floor(v35))), FormatNumber.Commas((math.floor(v36))))
    end
    v37.ShownHave = v35
    local v39
    if v36 > 0 then
        local v40 = v35 / v36
        v39 = math.clamp(v40, 0, 1)
    else
        v39 = 0
    end
    v37.Shown = v39
    local Fill = v37.Fill
    if Fill then
        local Position = Fill.Position
        Fill.Instance.Position = UDim2.new(v39 - Fill.Lead, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
    end
    local Trail = v37.Trail
    if Trail then
        local Position = Trail.Position
        Trail.Instance.Position = UDim2.new(v39 - Trail.Lead, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
    end
end

function v1.Set(v41, v42, v43) -- line 129 | captures: RunService, FormatNumber, Bar, stateOf
    local v44 = stateOf(v41)
    if v44.Glide then
        v44.Glide:Disconnect()
        v44.Glide = nil
    end
    local Shown = v44.Shown
    local v45
    if v43 > 0 then
        local v46 = v42 / v43
        v45 = math.clamp(v46, 0, 1)
    else
        v45 = 0
    end
    local ShownHave = v44.ShownHave
    local v47 = os.clock()
    local RenderStepped = RunService.RenderStepped
    local v48 = v45
    v44.Glide = RenderStepped:Connect(function() -- line 138 | captures: v42, v43, v44, Shown, ShownHave, v47, v48, FormatNumber, Bar
        local v49 = (os.clock() - v47) / Bar.FillTime
        local v50 = math.clamp(v49, 0, 1)
        local v51 = 1 - (1 - v50) * (1 - v50)
        local v52 = Shown + (v48 - Shown) * v51
        v44.Shown = v52
        local Fill = v44.Fill
        if Fill then
            local Position = Fill.Position
            Fill.Instance.Position = UDim2.new(v52 - Fill.Lead, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
        end
        local Trail = v44.Trail
        if Trail then
            local Position = Trail.Position
            Trail.Instance.Position = UDim2.new(v52 - Trail.Lead, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
        end
        local v53 = if v50 >= 1 then v42 else ShownHave + (v42 - ShownHave) * v51
        v44.ShownHave = v53
        local ShownHave_2 = v44.ShownHave
        if v44.Label then
            v44.Label.Text = string.format(Bar.Format, FormatNumber.Commas((math.floor(ShownHave_2))), FormatNumber.Commas((math.floor(v43))))
        end
        if v50 >= 1 and v44.Glide then
            v44.Glide:Disconnect()
            v44.Glide = nil
        end
    end)
end

function v1.Restore(v54) -- line 150 | captures: HellBossConfig, Bar, v4, setLooks
    local v55 = v4[v54]
    if v55 and v55.Glide then
        v55.Glide:Disconnect()
        v55.Glide = nil
    end
    setLooks(v54, Bar.BossIcon, HellBossConfig.DisplayName)
end

return v1
