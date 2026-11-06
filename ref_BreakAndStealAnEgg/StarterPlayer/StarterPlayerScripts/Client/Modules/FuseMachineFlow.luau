-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local TweenService = game:GetService("TweenService")
local v1 = {}
local v2 = { "LeftBar", "MiddleBar", "RightBar" }
local v3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v5 = {}
local Fill
local v6 = UDim.new(1, 0)
local OutputEgg, v7, FusePunch
local v8 = 0
local v9, v10, v11, v12
local v13 = -1
local v14

local function smoothstep(v15) -- line 63
    local v16 = math.clamp(v15, 0, 1)
    return v16 * v16 * (3 - v16 * 2)
end

local function maskFor(v17) -- line 70
    local function v18(v19, ...)
        table.insert(v19, ...)
    end

    local function v20(v21, ...)
        table.insert(v21, ...)
    end

    if v17 <= 0 then
        return NumberSequence.new(1)
    end
    if v17 >= 1 then
        return NumberSequence.new(0)
    end
    local v22 = { NumberSequenceKeypoint.new(0, 0) }
    local v23 = v17 - 0.07
    local v24 = v17 + 0.07
    for v25 = 0, 6 do
        local v26 = v23 + (v24 - v23) * v25 / 6
        if v26 > 0 and v26 < 1 then
            local new = NumberSequenceKeypoint.new
            local v27 = (v26 - v23) / (v24 - v23)
            local v28 = math.clamp(v27, 0, 1)
            v18(v22, new(v26, v28 * v28 * (3 - v28 * 2)))
        end
    end
    v20(v22, NumberSequenceKeypoint.new(1, 1))
    local v29 = { v22[1] }
    local v30 = #v22
    for v31 = 2, v30 do
        local Time = v22[v31].Time
        if v29[#v29].Time < Time then
            local v32 = v22[v31]
            table.insert(v29, v32)
        end
    end
    return NumberSequence.new(v29)
end

local function drawLevel(v33) -- line 96 | captures: v7, v8, maskFor
    v8 = v33
    if v7 then
        v7.Transparency = maskFor(v33)
    end
end

local function punch(v34) -- line 103 | captures: FusePunch, TweenService, v4
    local FusePunch_2 = FusePunch
    if not FusePunch_2 then
        return
    end
    if v34 then
        FusePunch_2.Scale = 1.14
    else
        FusePunch_2.Scale = 1.06
    end
    TweenService:Create(FusePunch_2, v4, { Scale = 1 }):Play()
end

function v1.Bind(v35) -- line 116 | captures: Fill, v6, OutputEgg, v7, FusePunch, v8, v9, v10, v11, v12, v13, v14, v2, v5, maskFor, drawLevel
    table.clear(v5)
    Fill = nil
    OutputEgg = nil
    v7 = nil
    FusePunch = nil
    v13 = -1
    if v11 then
        v11:Cancel()
        v11 = nil
    end
    if v12 then
        v12:Cancel()
        v12 = nil
    end
    local DesignBars = v35:FindFirstChild("DesignBars")
    for v36, v37 in v2 do
        local v38 = DesignBars and DesignBars:FindFirstChild(v37)
        local v39 = v38 and v38:FindFirstChild("Fill")
        if v39 and v39:IsA("GuiObject") then
            v5[v36] = v39
        end
    end
    local SacrificeOutput = v35:FindFirstChild("SacrificeOutput")
    local v40 = SacrificeOutput and SacrificeOutput:FindFirstChild("Output")
    if not v40 then
        return
    end
    local Fill_2 = v40:FindFirstChild("Fill")
    if Fill_2 and Fill_2:IsA("GuiObject") then
        Fill = Fill_2
        v6 = Fill_2.Size.X
    end
    local OutputEgg_2 = v40:FindFirstChild("OutputEgg")
    if OutputEgg_2 and OutputEgg_2:IsA("ImageLabel") then
        OutputEgg = OutputEgg_2
        local OutputEggSilhouette = v40:FindFirstChild("OutputEggSilhouette")
        if not (OutputEggSilhouette and OutputEggSilhouette:IsA("ImageLabel")) then
            OutputEggSilhouette = OutputEgg_2:Clone()
            for v41, v42 in OutputEggSilhouette:GetChildren() do
                v42:Destroy()
            end
            OutputEggSilhouette.Name = "OutputEggSilhouette"
            OutputEggSilhouette.ImageColor3 = Color3.new(0, 0, 0)
            OutputEggSilhouette.ZIndex = OutputEgg_2.ZIndex
            OutputEgg_2.ZIndex += 1
            OutputEggSilhouette.Parent = v40
        end
        local PourMask = OutputEgg_2:FindFirstChild("PourMask")
        if not (PourMask and PourMask:IsA("UIGradient")) then
            local UIGradient = Instance.new("UIGradient")
            UIGradient.Name = "PourMask"
            UIGradient.Rotation = -90
            UIGradient.Parent = OutputEgg_2
            v7 = UIGradient
        else
            v7 = PourMask
        end
        local FusePunch_2 = OutputEgg_2:FindFirstChild("FusePunch")
        if not (FusePunch_2 and FusePunch_2:IsA("UIScale")) then
            FusePunch_2 = Instance.new("UIScale")
            FusePunch_2.Name = "FusePunch"
            FusePunch_2.Parent = OutputEgg_2
        end
        FusePunch = FusePunch_2
        local FusePunch_3 = OutputEggSilhouette:FindFirstChild("FusePunch")
        local v43 = FusePunch_3
        if not FusePunch_3 then
            local UIScale = Instance.new("UIScale")
            v43 = UIScale
            UIScale.Name = "FusePunch"
            UIScale.Parent = OutputEggSilhouette
        end
        if v14 then
            v14:Disconnect()
        end
        v14 = FusePunch:GetPropertyChangedSignal("Scale"):Connect(function() -- line 194 | captures: v43, FusePunch
            v43.Scale = FusePunch.Scale
        end)
    end
    v9 = v9 or Instance.new("NumberValue")
    if v10 then
        v10:Disconnect()
    end
    v10 = v9.Changed:Connect(drawLevel)
    local v44 = v8
    v8 = v44
    if v7 then
        v7.Transparency = maskFor(v44)
    end
end

function v1.SetEggImage(v45) -- line 210 | captures: OutputEgg
    if OutputEgg then
        OutputEgg.Image = v45
    end
    local v46 = OutputEgg and OutputEgg.Parent and OutputEgg.Parent:FindFirstChild("OutputEggSilhouette")
    if v46 and v46:IsA("ImageLabel") then
        v46.Image = v45
    end
end

function v1.Set(v47, v48) -- line 220 | captures: Fill, v6, v7, FusePunch, v8, v9, v11, v12, v13, TweenService, v3, v4, v5, maskFor
    local v49 = v47[1] == true
    local v50 = if v49 then 0 + 1 else 0
    local v51 = v5[1]
    if v51 then
        v51.Visible = v49
    end
    local v52 = v47[2] == true
    if v52 then
        v50 += 1
    end
    local v53 = v5[2]
    if v53 then
        v53.Visible = v52
    end
    local v54 = v47[3] == true
    if v54 then
        v50 += 1
    end
    local v55 = v5[3]
    if v55 then
        v55.Visible = v54
    end
    local v56 = v50 / 3
    if Fill then
        local Fill_2 = Fill
        if v11 then
            v11:Cancel()
            v11 = nil
        end
        local v57 = UDim2.new(v6, UDim.new(v56, 0))
        if v56 > 0 then
            Fill_2.Visible = true
        end
        if v48 then
            local v58 = TweenService:Create(Fill_2, v3, { Size = v57 })
            v11 = v58
            v58.Completed:Once(function(v59) -- line 247 | captures: v56, Fill_2
                if v59 == Enum.PlaybackState.Completed and v56 <= 0 then
                    Fill_2.Visible = false
                end
            end)
            v58:Play()
        else
            Fill_2.Size = v57
            local v60 = v56 > 0
            Fill_2.Visible = v60
        end
    end
    if v9 then
        if v12 then
            v12:Cancel()
            v12 = nil
        end
        if v48 then
            local v61 = TweenService:Create(v9, v3, { Value = v56 })
            v12 = v61
            v61:Play()
        else
            v9.Value = v56
            v8 = v56
            if v7 then
                v7.Transparency = maskFor(v56)
            end
        end
    end
    local v62, v63
    if v48 and v13 >= 0 then
        if v50 == v13 then
            v63 = true
        else
            v62 = v50 == 3
            v63 = false
        end
    else
        v63 = true
    end
    if not v63 then
        local FusePunch_2 = FusePunch
        if FusePunch_2 then
            if v62 then
                FusePunch_2.Scale = 1.14
            else
                FusePunch_2.Scale = 1.06
            end
            TweenService:Create(FusePunch_2, v4, { Scale = 1 }):Play()
        end
    end
    v13 = v50
end

return v1
