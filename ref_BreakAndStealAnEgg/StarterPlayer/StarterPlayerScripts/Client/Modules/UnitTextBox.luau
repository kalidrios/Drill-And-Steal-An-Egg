-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}

local function trim(v2) -- line 19
    return (string.gsub(string.gsub(v2, "^%s+", ""), "%s+$", ""))
end

local function literal(v3) -- line 25
    return (string.gsub(v3, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0"))
end

function v1.Bind(v4, v5) -- line 29
    if not v4 then
        return
    end
    v4.ClearTextOnFocus = false
    v4.Focused:Connect(function() -- line 35 | captures: v4, v5
        local match = string.match
        local Text = v4.Text
        local v6 = match(string.gsub(string.gsub(Text, "^%s+", ""), "%s+$", ""), "^(%d*%.?%d+)" .. string.gsub(v5, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0") .. "$")
        if v6 then
            v4.Text = v6
        end
    end)
    v4.FocusLost:Connect(function() -- line 41 | captures: v4, v5
        local Text = v4.Text
        local v7 = string.gsub(string.gsub(Text, "^%s+", ""), "%s+$", "")
        if tonumber(v7) then
            v4.Text = v7 .. v5
        end
    end)
end

function v1.Number(v8, v9) -- line 51
    local v10 = string.gsub(string.gsub(v8, "^%s+", ""), "%s+$", "")
    local v11 = string.match(v10, "^(%d*%.?%d+)" .. string.gsub(v9, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0") .. "$") or v10
    return (tonumber(v11))
end

function v1.BindPrefix(v12, v13) -- line 59
    if not v12 then
        return
    end
    v12.ClearTextOnFocus = false
    v12.Focused:Connect(function() -- line 65 | captures: v12, v13
        local match = string.match
        local Text = v12.Text
        local v14 = match(string.gsub(string.gsub(Text, "^%s+", ""), "%s+$", ""), "^" .. string.gsub(v13, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0") .. "(%d*%.?%d+)$")
        if v14 then
            v12.Text = v14
        end
    end)
    v12.FocusLost:Connect(function() -- line 71 | captures: v12, v13
        local Text = v12.Text
        local v15 = string.gsub(string.gsub(Text, "^%s+", ""), "%s+$", "")
        if tonumber(v15) then
            v12.Text = v13 .. v15
        end
    end)
end

function v1.PrefixNumber(v16, v17) -- line 80
    local v18 = string.gsub(string.gsub(v16, "^%s+", ""), "%s+$", "")
    local v19 = string.match(v18, "^" .. string.gsub(v17, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0") .. "(%d*%.?%d+)$") or v18
    return (tonumber(v19))
end

return v1
