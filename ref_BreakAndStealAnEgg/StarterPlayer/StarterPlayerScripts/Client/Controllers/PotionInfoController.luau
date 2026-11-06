-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local PotionConfig = require(ReplicatedStorage.Shared.PotionConfig)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local v2, v3, v4, v5, TextColor3, v6, v7, v8

local function adopt(v9) -- line 56 | captures: v2, v3, v4, v5, TextColor3, v8, PotionConfig
    local v10 = v9:FindFirstChild(PotionConfig.HoverInfoName)
    if v10 and v10:IsA("GuiObject") then
        v10.Visible = false
        v2 = v10
        v5 = v9
        v8 = nil
        local v11 = v10:FindFirstChild("Name", true)
        if v11 then
            if not v11:IsA("TextLabel") then
                v11 = nil
            end
        else
            v11 = nil
        end
        v3 = v11
        local v12 = v10:FindFirstChild("Info", true)
        if not (v12 and v12:IsA("TextLabel")) then
            v12 = nil
        end
        v4 = v12
        if v4 then
            TextColor3 = v4.TextColor3
        else
            TextColor3 = nil
        end
        if v3 then
            v3.RichText = true
        end
    else
        warn((("[PotionInfoController] MainGUI.%* not found"):format(PotionConfig.HoverInfoName)))
    end
end

local function paintInfoRarity(v13) -- line 77 | captures: v4, TextColor3, RarityGradientFX
    local v14 = v4
    if v14 and not (v13 and RarityGradientFX.ApplyToLabel(v14, v13)) then
        for v15, v16 in v14:GetChildren() do
            if v16:IsA("UIGradient") then
                RarityGradientFX.Detach(v16)
                v16:Destroy()
            end
        end
        if TextColor3 then
            v14.TextColor3 = TextColor3
        end
    end
end

local function isStillHovered(v17) -- line 98 | captures: GuiService, UserInputService
    local v18 = v17
    while v18 do
        if v18:IsA("GuiObject") then
            if v18.Visible then
                v18 = v18.Parent
                continue
            end
            return false
        end
        if v18:IsA("LayerCollector") then
            if v18.Enabled then
                break
            end
            return false
        end
        v18 = v18.Parent
    end
    if v18 then
        local v19 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
        local v20 = v17.AbsolutePosition - Vector2.new(2, 2)
        local v21 = v17.AbsoluteSize + Vector2.new(4, 4)
        local X = v19.X
        if v20.X <= X and v19.X <= v20.X + v21.X then
            local Y = v19.Y
            if v20.Y <= Y then
                return v19.Y <= v20.Y + v21.Y
            end
        end
        return false
    end
    return false
end

local function position() -- line 130 | captures: v2, v5, v8, GuiService, UserInputService, PotionConfig
    local v22 = v2
    local v23 = v5
    local v24, AbsoluteSize, v25
    if v22 and v23 then
        v24 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset() - v23.AbsolutePosition
        AbsoluteSize = v22.AbsoluteSize
        local HoverCursorGap = PotionConfig.HoverCursorGap
        v25 = v24.X + HoverCursorGap
        local v26 = v25 + AbsoluteSize.X
        if v23.AbsoluteSize.X < v26 then
            v25 = v24.X - HoverCursorGap - AbsoluteSize.X
        end
    else
        return
    end
    local v27 = v24.Y - AbsoluteSize.Y / 2
    local AnchorPoint = v22.AnchorPoint
    local v28 = UDim2.fromOffset(v25 + AnchorPoint.X * AbsoluteSize.X, v27 + AnchorPoint.Y * AbsoluteSize.Y)
    if v28 ~= v8 then
        v8 = v28
        v22.Position = v28
    end
end

local function hide() -- line 151 | captures: v2, v6, v7
    v6 = nil
    if v7 then
        v7:Disconnect()
        v7 = nil
    end
    if v2 then
        v2.Visible = false
    end
end

local function show(v29, v30) -- line 162 | captures: v2, v3, v4, v6, v7, RunService, paintInfoRarity, isStillHovered, position
    local v31 = v2
    if v31 and v31.Parent then
        v6 = v29
        if v3 then
            v3.Text = v30.Title
        end
    else
        return
    end
    if v4 then
        v4.Text = v30.Info
    end
    paintInfoRarity(v30.Rarity)
    position()
    v31.Visible = true
    v7 = v7 or
    RunService.RenderStepped:Connect(function() -- line 178 | captures: v2, v6, v7, isStillHovered, position
        local v32 = v6
        if v32 and v32:IsDescendantOf(game) and isStillHovered(v32) then
            position()
        else
            v6 = nil
            if v7 then
                v7:Disconnect()
                v7 = nil
            end
            if v2 then
                v2.Visible = false
            end
        end
    end)
end

function v1.BindInfo(v33, v34) -- line 190 | captures: v2, v6, v7, show
    v33.MouseEnter:Connect(function() -- line 191 | captures: v33, v34, show
        show(v33, v34)
    end)
    v33.MouseLeave:Connect(function() -- line 194 | captures: v33, v2, v6, v7
        if v6 ~= v33 then
            return
        end
        v6 = nil
        if v7 then
            v7:Disconnect()
            v7 = nil
        end
        if v2 then
            v2.Visible = false
        end
    end)
    v33.Destroying:Connect(function() -- line 199 | captures: v33, v2, v6, v7
        if v6 ~= v33 then
            return
        end
        v6 = nil
        if v7 then
            v7:Disconnect()
            v7 = nil
        end
        if v2 then
            v2.Visible = false
        end
    end)
end

function v1.Bind(v35, v36) -- line 207 | captures: v2, v6, v7, PotionConfig, show
    v35.MouseEnter:Connect(function() -- line 208 | captures: v35, v36, PotionConfig, show
        show(v35, {
            Title = PotionConfig.HoverTitle(v36),
            Info = v36.HoverInfo
        })
    end)
    v35.MouseLeave:Connect(function() -- line 214 | captures: v35, v2, v6, v7
        if v6 ~= v35 then
            return
        end
        v6 = nil
        if v7 then
            v7:Disconnect()
            v7 = nil
        end
        if v2 then
            v2.Visible = false
        end
    end)
    v35.Destroying:Connect(function() -- line 219 | captures: v35, v2, v6, v7
        if v6 ~= v35 then
            return
        end
        v6 = nil
        if v7 then
            v7:Disconnect()
            v7 = nil
        end
        if v2 then
            v2.Visible = false
        end
    end)
end

function v1.Start() -- line 226 | captures: v2, v6, v7, MainGui, adopt
    MainGui.Observe(function(v37) -- line 227 | captures: v2, v6, v7, adopt
        v6 = nil
        if v7 then
            v7:Disconnect()
            v7 = nil
        end
        if v2 then
            v2.Visible = false
        end
        adopt(v37)
    end)
end

return v1
