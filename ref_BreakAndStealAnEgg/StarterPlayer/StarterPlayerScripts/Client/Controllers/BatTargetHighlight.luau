-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local BatConfig = require(ReplicatedStorage.Shared.BatConfig)
local v1 = {}
local v2, Highlight, v3

local function clear() -- line 22 | captures: v2, Highlight, v3
    if v3 then
        v3:Cancel()
        v3 = nil
    end
    if Highlight then
        Highlight:Destroy()
        Highlight = nil
    end
    v2 = nil
end

function v1.SetTarget(v4) -- line 36 | captures: v2, Highlight, v3, TweenService, BatConfig
    if v4 == v2 then
        return
    end
    if v3 then
        v3:Cancel()
        v3 = nil
    end
    if Highlight then
        Highlight:Destroy()
        Highlight = nil
    end
    v2 = nil
    if not v4 then
        return
    end
    local Highlight_2 = BatConfig.Highlight
    local Highlight_3 = Instance.new("Highlight")
    Highlight_3.Name = "BatTargetHighlight"
    Highlight_3.Adornee = v4
    Highlight_3.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight_3.FillColor = Highlight_2.FillColor
    Highlight_3.OutlineColor = Highlight_2.OutlineColor
    Highlight_3.FillTransparency = 1
    Highlight_3.OutlineTransparency = 1
    Highlight_3.Enabled = true
    Highlight_3.Parent = v4
    v2 = v4
    Highlight = Highlight_3
    v3 = TweenService:Create(Highlight_3, TweenInfo.new(Highlight_2.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        FillTransparency = Highlight_2.FillTransparency,
        OutlineTransparency = Highlight_2.OutlineTransparency
    })
    v3:Play()
end

function v1.Clear() -- line 73 | captures: v2, Highlight, v3
    if v3 then
        v3:Cancel()
        v3 = nil
    end
    if Highlight then
        Highlight:Destroy()
        Highlight = nil
    end
    v2 = nil
end

return v1
