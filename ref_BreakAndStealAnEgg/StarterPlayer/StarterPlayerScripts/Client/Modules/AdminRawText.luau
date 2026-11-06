-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminConfig = require(ReplicatedStorage.Shared.AdminConfig)
local v1 = {}

local function isRawCommand(v2) -- line 28 | captures: AdminConfig
    local v3 = string.lower(v2)
    for v4, v5 in AdminConfig.RawTextCommands do
        if v5 == v3 then
            return true
        end
    end
    return false
end

local function isSingleQuotedString(v6) -- line 38
    if string.match(v6, "^\"[^\"]*\"$") == nil then
        return string.match(v6, "^'[^']*'$") ~= nil
    end
    return true
end

function v1.Rewrite(v7) -- line 43 | captures: AdminConfig
    local v8, v9 = string.match(v7, "^%s*([%w_%-]+)%s+(.-)%s*$")
    if v8 and v9 and v9 ~= "" then
        local v10 = string.lower(v8)
        local v11 = false
        local v12
        for v13, v14 in AdminConfig.RawTextCommands do
            if v14 == v10 then
                v12 = true
                v11 = true
                break
            end
        end
        if not v11 then
            v12 = false
        end
        if v12 then
            if string.match(v9, "^\"[^\"]*\"$") ~= nil or string.match(v9, "^'[^']*'$") ~= nil then
                return v7
            end
            local v15 = string.gsub(v9, "\\", "\\92")
            return (("%* \"%*\""):format(v8, (string.gsub(v15, "\"", "\\34"))))
        end
    end
    return v7
end

local function QuoteUnitNumbers(v16, v17) -- line 62
    local v18 = {}
    local v19 = #v16
    local v20 = 0
    local v21 = 1
    while true do
        local v22, v23
        if v21 <= v19 then
            local v24 = string.sub(v16, v21, v21)
            if v24 == "\"" or v24 == "'" then
                local v25 = string.find(v16, v24, v21 + 1, true) or v19
                local v26 = string.sub(v16, v21, v25)
                table.insert(v18, v26)
                v22 = v25 + 1
                v23 = v20
            else
                local v27
                if v21 > 1 then
                    local v28 = v21 - 1
                    local v29 = v21 - 1
                    v27 = string.sub(v16, v28, v29)
                else
                    v27 = " "
                end
                if string.match(v24, "%d") and string.match(v27, "[%s%(%[{,=]") then
                    local v30 = string.match(v16, "^[%w%._]+", v21)
                    local v31 = v21 + #v30 - 1
                    local v32 = string.gsub(v30, "_", "")
                    if tonumber(v32) == nil then
                        local v33 = ("\"%*\""):format(v30)
                        table.insert(v18, v33)
                        if v17 then
                            if v31 <= v17 then
                                v23 = v20 + 2
                            elseif v21 <= v17 then
                                v23 = v20 + 1
                            else
                                v23 = v20
                            end
                        else
                            v23 = v20
                        end
                    else
                        table.insert(v18, v30)
                        v23 = v20
                    end
                    v22 = v31 + 1
                else
                    table.insert(v18, v24)
                    v22 = v21 + 1
                    v23 = v20
                end
            end
        else
            break
        end
        v20 = v23
        v21 = v22
    end
    local v34 = table.concat(v18)
    if v17 then
        return v34, v17 + v20
    end
    return v34, nil
end

v1.QuoteUnitNumbers = QuoteUnitNumbers

function v1.Install(v35) -- line 107 | captures: v1
    local execute = v35.execute

    function v35.execute(v36, ...) -- line 109 | captures: execute, v1
        local v37 = v1.Rewrite(v36)
        if v37 == v36 then
            v37 = v1.QuoteUnitNumbers(v36)
        end
        return execute(v37, ...)
    end

    local analyze = v35.analyze

    function v35.analyze(v38, v39, ...) -- line 118 | captures: analyze, v1
        local v40 = v1.Rewrite(v38)
        if v40 == v38 then
            local v41, v42 = v1.QuoteUnitNumbers(v38, v39)
            return analyze(v41, v42 or v39, ...)
        end
        return analyze(v40, #v40, ...)
    end
end

return v1
