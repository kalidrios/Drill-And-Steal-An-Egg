-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local TextService = game:GetService("TextService")
local v1 = {}
local v2 = { 0.1, 0.5, 1.5, 3 }
local v3 = { "Text", "TextBounds", "AbsoluteSize", "AbsolutePosition", "FontFace" }

local function waitForFont(v4) -- line 40 | captures: TextService
    pcall(function() -- line 41 | captures: v4, TextService
        local GetTextBoundsParams = Instance.new("GetTextBoundsParams")
        if v4.Text == "" then
            GetTextBoundsParams.Text = "0"
        else
            GetTextBoundsParams.Text = v4.Text
        end
        GetTextBoundsParams.Font = v4.FontFace
        local TextSize = v4.TextSize
        GetTextBoundsParams.Size = math.max(TextSize, 1)
        GetTextBoundsParams.Width = (1/0)
        TextService:GetTextBoundsAsync(GetTextBoundsParams)
    end)
end

function v1.Watch(v5, v6) -- line 51 | captures: TextService, v2, v3
    local function v7(v8, ...)
        table.insert(v8, ...)
    end

    local v9 = true
    local v10 = {}

    local function fire() -- line 55 | captures: v9, v5, v6
        if v9 and v5.Parent ~= nil then
            v6()
        end
    end

    for v11, v12 in v3 do
        v7(v10, v5:GetPropertyChangedSignal(v12):Connect(fire))
    end
    task.spawn(function() -- line 66 | captures: v9, v5, v6, fire, TextService, v2
        pcall(function() -- line 41 | captures: v5, TextService
            local GetTextBoundsParams = Instance.new("GetTextBoundsParams")
            if v5.Text == "" then
                GetTextBoundsParams.Text = "0"
            else
                GetTextBoundsParams.Text = v5.Text
            end
            GetTextBoundsParams.Font = v5.FontFace
            local TextSize = v5.TextSize
            GetTextBoundsParams.Size = math.max(TextSize, 1)
            GetTextBoundsParams.Width = (1/0)
            TextService:GetTextBoundsAsync(GetTextBoundsParams)
        end)
        if v9 and v5.Parent ~= nil then
            v6()
        end
        task.delay(v2[1], fire)
    end)
    for v13, v14 in v2 do
        task.delay(v14, fire)
    end
    if v9 and v5.Parent ~= nil then
        v6()
    end
    return function() -- line 78 | captures: v9, v10
        v9 = false
        for v15, v16 in v10 do
            v16:Disconnect()
        end
        table.clear(v10)
    end
end

return v1
