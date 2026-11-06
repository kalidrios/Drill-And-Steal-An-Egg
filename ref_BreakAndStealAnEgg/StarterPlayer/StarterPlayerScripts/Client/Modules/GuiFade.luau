-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local TweenService = game:GetService("TweenService")
local v1 = {}
local v2 = {
    {
        Class = "TextLabel",
        Props = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" }
    },
    {
        Class = "TextButton",
        Props = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" }
    },
    {
        Class = "TextBox",
        Props = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" }
    },
    {
        Class = "ImageLabel",
        Props = { "BackgroundTransparency", "ImageTransparency" }
    },
    {
        Class = "ImageButton",
        Props = { "BackgroundTransparency", "ImageTransparency" }
    },
    {
        Class = "ScrollingFrame",
        Props = { "BackgroundTransparency", "ScrollBarImageTransparency" }
    },
    {
        Class = "GuiObject",
        Props = { "BackgroundTransparency" }
    },
    {
        Class = "UIStroke",
        Props = { "Transparency" }
    }
}

local function readTransparency(v3) -- line 41
    local v4, v5 = pcall(function() -- line 42 | captures: v3
        return v3.Transparency
    end)
    if not (v4 and type(v5) == "number") then
        return nil
    end
    return v5
end

local function capture(v6) -- line 48 | captures: v2
    for v7, v8 in v2 do
        if v6:IsA(v8.Class) then
            local v9 = {}
            for v10, v11 in v8.Props do
                v9[v11] = v6[v11]
            end
            return {
                Instance = v6,
                Authored = v9
            }
        end
    end
    if v6:IsA("UIComponent") then
        local v12, v13 = pcall(function() -- line 42 | captures: v6
            return v6.Transparency
        end)
        if v12 then
            if type(v13) ~= "number" then
                v13 = nil
            end
        else
            v13 = nil
        end
        if v13 then
            return {
                Instance = v6,
                Authored = { Transparency = v13 }
            }
        end
    end
    return nil
end

function v1.Capture(v14) -- line 67 | captures: capture
    local v15 = {}
    local v16 = capture(v14)
    if v16 then
        table.insert(v15, v16)
    end
    for v17, v18 in v14:GetDescendants() do
        local v19 = capture(v18)
        if v19 then
            table.insert(v15, v19)
        end
    end
    return v15
end

local function goalFor(v20, v21) -- line 82
    local v22 = {}
    for v23, v24 in v20.Authored do
        v22[v23] = v24 + (1 - v24) * v21
    end
    return v22
end

function v1.Set(v25, v26) -- line 91
    for v27, v28 in v25 do
        if v28.Instance.Parent then
            local v29 = {}
            for v30, v31 in v28.Authored do
                v29[v30] = v31 + (1 - v31) * v26
            end
            for v32, v33 in v29 do
                v28.Instance[v32] = v33
            end
        end
    end
end

function v1.Tween(v34, v35, v36) -- line 102 | captures: TweenService
    local v37 = {}
    for v38, v39 in v34 do
        if v39.Instance.Parent then
            local Instance = v39.Instance
            local v40 = {}
            for v41, v42 in v39.Authored do
                v40[v41] = v42 + (1 - v42) * v36
            end
            local v43 = TweenService:Create(Instance, v35, v40)
            v43:Play()
            table.insert(v37, v43)
        end
    end
    return v37
end

return v1
