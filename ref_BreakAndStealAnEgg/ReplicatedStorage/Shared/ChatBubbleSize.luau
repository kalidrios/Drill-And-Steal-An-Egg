-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local AnimalChatConfig = require(script.Parent.AnimalChatConfig)
local v1 = {}

local function codepointWidth(v2) -- line 52
    if v2 == 32 then
        return 0.28
    end
    if v2 >= 8592 then
        return 1.15
    end
    if v2 < 128 then
        local v3 = string.char(v2)
        if ("ijlItf.,:;'`|!()[]{}"):find(v3, 1, true) then
            return 0.3
        end
        if ("mwMW@%"):find(v3, 1, true) then
            return 0.92
        end
        return 0.55
    end
    return 0.6
end

local function estimateAspect(v4) -- line 71
    local v5 = 0
    if not pcall(function() -- line 75 | captures: v5, v4
            for v6, v7 in utf8.codes(v4) do
                local v8 = v5
                local v9
                if v7 == 32 then
                    v9 = 0.28
                elseif v7 >= 8592 then
                    v9 = 1.15
                elseif v7 < 128 then
                    local v10 = string.char(v7)
                    if ("ijlItf.,:;'`|!()[]{}"):find(v10, 1, true) then
                        v9 = 0.3
                    elseif ("mwMW@%"):find(v10, 1, true) then
                        v9 = 0.92
                    else
                        v9 = 0.55
                    end
                else
                    v9 = 0.6
                end
                v5 = v8 + v9
            end
        end) then
        v5 = #v4 * 0.55
    end
    return v5 / 1.2
end

function v1.TextAspect(v11, v12) -- line 89 | captures: RunService, TextService
    if v11 == "" then
        return 0
    end
    if RunService:IsClient() then
        local v13, v14 = pcall(function() -- line 103 | captures: v11, v12, TextService
            local GetTextBoundsParams = Instance.new("GetTextBoundsParams")
            GetTextBoundsParams.Text = v11
            GetTextBoundsParams.Size = 100
            GetTextBoundsParams.Width = 100000
            if v12 then
                GetTextBoundsParams.Font = v12
            end
            local v15 = TextService:GetTextBoundsAsync(GetTextBoundsParams)
            GetTextBoundsParams:Destroy()
            if not (v15.Y <= 0) and not (v15.X <= 0) then
                return v15.X / v15.Y
            end
            return nil
        end)
        if v13 and typeof(v14) == "number" then
            return v14
        end
        local v16 = 0
        if not pcall(function() -- line 75 | captures: v16, v11
                for v17, v18 in utf8.codes(v11) do
                    local v19 = v16
                    local v20
                    if v18 == 32 then
                        v20 = 0.28
                    elseif v18 >= 8592 then
                        v20 = 1.15
                    elseif v18 < 128 then
                        local v21 = string.char(v18)
                        if ("ijlItf.,:;'`|!()[]{}"):find(v21, 1, true) then
                            v20 = 0.3
                        elseif ("mwMW@%"):find(v21, 1, true) then
                            v20 = 0.92
                        else
                            v20 = 0.55
                        end
                    else
                        v20 = 0.6
                    end
                    v16 = v19 + v20
                end
            end) then
            v16 = #v11 * 0.55
        end
        return v16 / 1.2
    end
    local v22 = 0
    if not pcall(function() -- line 75 | captures: v22, v11
            for v23, v24 in utf8.codes(v11) do
                local v25 = v22
                local v26
                if v24 == 32 then
                    v26 = 0.28
                elseif v24 >= 8592 then
                    v26 = 1.15
                elseif v24 < 128 then
                    local v27 = string.char(v24)
                    if ("ijlItf.,:;'`|!()[]{}"):find(v27, 1, true) then
                        v26 = 0.3
                    elseif ("mwMW@%"):find(v27, 1, true) then
                        v26 = 0.92
                    else
                        v26 = 0.55
                    end
                else
                    v26 = 0.6
                end
                v22 = v25 + v26
            end
        end) then
        v22 = #v11 * 0.55
    end
    return v22 / 1.2
end

local function billboardAspect(v28) -- line 127
    local Size = v28.Size
    if Size.X.Scale > 0 and Size.Y.Scale > 0 then
        return Size.X.Scale / Size.Y.Scale
    end
    if not (Size.X.Offset > 0 and Size.Y.Offset > 0) then
        return 1
    end
    return Size.X.Offset / Size.Y.Offset
end

local function withWidthScale(v29, v30) -- line 142
    return UDim2.new(v30, v29.X.Offset, v29.Y.Scale, v29.Y.Offset)
end

function v1.Apply(v31, v32) -- line 154 | captures: AnimalChatConfig, v1
    local Size = AnimalChatConfig.Bubble.Size
    local v33 = v31:FindFirstChild(AnimalChatConfig.BubbleRootName, true)
    local v34 = v31:FindFirstChild(AnimalChatConfig.TextLabelName, true)
    if v34 and v34:IsA("TextLabel") then
        v34.Text = v32
    end
    if not (v33 and v33:IsA("Frame")) then
        return {
            WidthScale = 0,
            WidthMult = 1
        }
    end
    local Size_2 = v33.Size
    local Scale = Size_2.Y.Scale
    if Scale <= 0 then
        return {
            WidthMult = 1,
            WidthScale = Size_2.X.Scale
        }
    end
    local Size_3 = v31.Size
    local v35
    if not (Size_3.X.Scale > 0 and Size_3.Y.Scale > 0) then
        if not (Size_3.X.Offset > 0 and Size_3.Y.Offset > 0) then
            v35 = 1
        else
            v35 = Size_3.X.Offset / Size_3.Y.Offset
        end
    else
        v35 = Size_3.X.Scale / Size_3.Y.Scale
    end
    local v36 = Size_2.X.Scale * v35 / Scale
    local FontFace
    if not (v34 and v34:IsA("TextLabel")) then
    else
        FontFace = v34.FontFace
    end
    local v37 = (v1.TextAspect(v32, FontFace) * Size.TextHeightFraction + Size.SidePadding) * Scale / v35
    local MinWidthScale = Size.MinWidthScale
    local MaxWidthScale = Size.MaxWidthScale
    local v38 = math.clamp(v37, MinWidthScale, MaxWidthScale)
    local v39 = v37 / v38
    local MaxWidthMult = Size.MaxWidthMult
    local v40 = math.clamp(v39, 1, MaxWidthMult)
    local Size_4 = v33.Size
    v33.Size = UDim2.new(v38, Size_4.X.Offset, Size_4.Y.Scale, Size_4.Y.Offset)
    local v41 = v33:FindFirstChild(AnimalChatConfig.BubbleTailName)
    if v41 and v41:IsA("GuiObject") and v36 > 0 then
        local v42 = v38 * v40 * v35 / Scale
        local Size = v41.Size
        local v43 = v41.Size.X.Scale * (v36 / v42)
        v41.Size = UDim2.new(v43, Size.X.Offset, Size.Y.Scale, Size.Y.Offset)
    end
    return {
        WidthScale = v38,
        WidthMult = v40
    }
end

return v1
