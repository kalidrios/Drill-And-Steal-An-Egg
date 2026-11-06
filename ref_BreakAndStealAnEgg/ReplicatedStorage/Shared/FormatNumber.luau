-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2 = {}

local function fixedFormat(v3) -- line 15 | captures: v2
    local v4 = v2[v3]
    if not v4 then
        v4 = "%." .. v3 .. "f"
        v2[v3] = v4
    end
    return v4
end

function v1.Commas(v5, v6) -- line 27 | captures: v2
    local format, v7, v8
    if v5 == v5 then
        if v5 == (1/0) or v5 == (-1/0) then
            v8 = true
        else
            format = string.format
            local v9 = v6 or 0
            v7 = v2[v9]
            if not v7 then
                v7 = "%." .. v9 .. "f"
                v2[v9] = v7
            end
            v8 = false
        end
    else
        v8 = true
    end
    if v8 then
        return (tostring(v5))
    end
    local v10 = format(v7, v5)
    local v11, v12, v13 = v10:match("^(%-?)(%d+)%.?(%d*)$")
    if v12 == nil then
        return v10
    end
    local v14
    while true do
        local v15
        v14, v15 = v12:gsub("^(%d+)(%d%d%d)", "%1,%2")
        if v15 == 0 then
            break
        end
        v12 = v14
    end
    local v16 = v13:gsub("0+$", "")
    local v17 = if v16 == "" then "" else "." .. v16
    return v11 .. v14 .. v17
end

local v18 = {
    "",
    "K",
    "M",
    "B",
    "T",
    "Qa",
    "Qi",
    "Sx",
    "Sp",
    "Oc",
    "No",
    "Dc"
}

function v1.Short(v19, v20) -- line 56 | captures: v1, v18
    local v21, v22
    if v19 == v19 then
        if v19 == (1/0) or v19 == (-1/0) then
            v22 = true
        else
            if v19 < 0 then
                v21 = "-"
            else
                v21 = ""
            end
            v22 = false
        end
    else
        v22 = true
    end
    if v22 then
        return (tostring(v19))
    end
    local v23 = math.abs(v19)
    if v23 < 1000 then
        return v21 .. v1.Commas(v23, v20 or 0)
    end
    local v24 = math.log(v23, 1000)
    local v25 = math.floor(v24)
    if v23 / 1000 ^ v25 >= 1000 then
        v25 += 1
    elseif v23 / 1000 ^ v25 < 1 then
        v25 -= 1
    end
    if #v18 <= v25 then
        return v1.Commas(v19)
    end
    local v26 = v20 or 1
    local v27 = v23 / 1000 ^ v25
    local v28 = 10 ^ v26
    local v29 = v27 * v28 + 0.000000001
    local v30 = math.floor(v29) / v28
    return v21 .. v1.Commas(v30, v26) .. v18[v25 + 1]
end

return v1
