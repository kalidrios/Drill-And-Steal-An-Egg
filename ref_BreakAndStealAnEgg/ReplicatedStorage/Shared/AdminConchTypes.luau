-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuardMorphConfig = require(ReplicatedStorage.Shared.GuardMorphConfig)
local PotionConfig = require(ReplicatedStorage.Shared.PotionConfig)
local v1 = {}
local v2 = {
    k = 1000,
    m = 1000000,
    b = 1000000000,
    t = 1000000000000,
    q = 1000000000000000,
    qa = 1000000000000000,
    qi = 1000000000000000000,
    sx = 1000000000000000000000,
    sp = 1000000000000000000000000,
    oc = 1000000000000000000000000000,
    no = 1000000000000000000000000000000,
    dc = 1000000000000000000000000000000000
}

local function finiteOrNil(v3) -- line 44
    if v3 ~= nil and v3 == v3 and math.abs(v3) ~= (1/0) then
        return v3
    end
    return nil
end

function v1.ParseNumber(v4) -- line 51 | captures: v2
    if typeof(v4) == "number" then
        if v4 ~= nil and v4 == v4 and math.abs(v4) ~= (1/0) then
            return v4
        end
    elseif v4 ~= nil then
        local v5 = string.lower((string.gsub(tostring(v4), ",", "")))
        local v6 = tonumber(v5)
        if v6 then
            if v6 ~= nil and v6 == v6 and math.abs(v6) ~= (1/0) then
                return v6
            end
        else
            local v7, v8 = string.match(v5, "^(-?%d*%.?%d+)(%a+)$")
            if v7 and v8 and v2[v8] then
                local v9 = tonumber(v7)
                if v9 then
                    local v10 = v9 * v2[v8]
                    if v10 ~= nil and v10 == v10 and math.abs(v10) ~= (1/0) then
                        return v10
                    end
                    return nil
                end
            end
        end
    end
    return nil
end

v1.PERMANENT = -1

local v11 = {
    perm = true,
    permanent = true,
    forever = true,
    inf = true,
    never = true,
    p = true,
    ["-1"] = true
}
local v12 = {
    s = 1,
    sec = 1,
    secs = 1,
    second = 1,
    seconds = 1,
    m = 60,
    min = 60,
    mins = 60,
    minute = 60,
    minutes = 60,
    h = 3600,
    hr = 3600,
    hrs = 3600,
    hour = 3600,
    hours = 3600,
    d = 86400,
    day = 86400,
    days = 86400,
    w = 604800,
    wk = 604800,
    week = 604800,
    weeks = 604800,
    mo = 2592000,
    month = 2592000,
    months = 2592000,
    y = 31536000,
    yr = 31536000,
    year = 31536000,
    years = 31536000
}

function v1.ParseDuration(v13) -- line 105 | captures: v1, v11, v12
    if v13 == nil then
        return nil
    end
    if typeof(v13) == "number" then
        if v13 < 0 then
            return v1.PERMANENT
        end
        local v14 = v13 * 86400
        local v15 = math.floor(v14)
        if v15 >= 1 then
            return v15
        end
        return nil
    end
    local v16 = string.lower((string.gsub(tostring(v13), "%s", "")))
    if v11[v16] then
        return v1.PERMANENT
    end
    local v17 = tonumber(v16)
    if v17 then
        return v1.ParseDuration(v17)
    end
    local v18 = 0
    if string.gsub(v16, "(%d*%.?%d+)(%a+)", function(v19, v20) -- line 128 | captures: v18, v12
            local v21 = v12[v20]
            local v22 = tonumber(v19)
            if not v21 or not v22 then
                return nil
            end
            v18 += v22 * v21
            return ""
        end) ~=
        "" or
        v18 < 1 then
        return nil
    end
    local v23 = v18
    return (math.floor(v23))
end

local function FormatDuration(v24) -- line 145
    if v24 < 0 then
        return "permanent"
    end
    local v25 = {
        { "y", 31536000 },
        { "d", 86400 },
        { "h", 3600 },
        { "m", 60 },
        { "s", 1 }
    }
    local v26 = {}
    local v27 = math.floor(v24)
    for v28, v29 in v25 do
        local v30 = v27 // v29[2]
        if v30 > 0 then
            local v31 = ("%*%*"):format(v30, v29[1])
            table.insert(v26, v31)
            v27 -= v30 * v29[2]
            if #v26 == 2 then
                break
            end
        end
    end
    if #v26 > 0 then
        return (table.concat(v26, " "))
    end
    return "0s"
end

v1.FormatDuration = FormatDuration
v1.ALL_POTIONS = "all"

function v1.ParsePotion(v32) -- line 180 | captures: PotionConfig, v1
    if v32 ~= nil then
        local v33 = tostring(v32)
        if string.lower(v33) == v1.ALL_POTIONS then
            return v1.ALL_POTIONS
        end
        local v34 = PotionConfig.Find(v33)
        if v34 then
            return v34.Id
        end
    end
    return nil
end

function v1.PotionNames() -- line 193 | captures: PotionConfig, v1
    local function v35(v36, ...)
        table.insert(v36, ...)
    end

    local v37 = {}
    for v38, v39 in PotionConfig.Potions do
        v35(v37, string.lower(v39.Id))
    end
    local ALL_POTIONS = v1.ALL_POTIONS
    table.insert(v37, ALL_POTIONS)
    return table.concat(v37, " / ")
end

local function guardSuggestions(v40) -- line 203 | captures: GuardMorphConfig
    local lower = string.lower
    local v41 = if type(v40) == "string" then v40 else ""
    local v42 = lower(v41)
    local v43 = string.gsub(v42, "[\"']", "")
    local v44 = {}
    for v45, v46 in GuardMorphConfig.Guards do
        local v47 = string.lower((("%* %* %*"):format(v46.Key, v46.DisplayName, v46.ZoneId)))
        if v43 == "" or string.find(v47, v43, 1, true) then
            local v48 = {}
            v48.text = v46.Key
            v48.display = ("%*  (%*, %*)"):format(v46.Key, v46.DisplayName, v46.ZoneId)
            table.insert(v44, v48)
        end
    end
    return v44
end

local function potionSuggestions(v49) -- line 221 | captures: PotionConfig, v1
    local lower = string.lower
    local v50 = if type(v49) == "string" then v49 else ""
    local v51 = lower(v50)
    local v52 = string.gsub(v51, "[\"']", "")
    local v53 = {}
    for v54, v55 in PotionConfig.Potions do
        local v56 = string.lower((("%* %*"):format(v55.Id, v55.DisplayName)))
        if v52 == "" or string.find(v56, v52, 1, true) then
            local v57 = {}
            v57.text = string.lower(v55.Id)
            v57.display = ("%*  (%*)"):format(string.lower(v55.Id), v55.DisplayName)
            table.insert(v53, v57)
        end
    end
    if v52 == "" or string.find(v1.ALL_POTIONS, v52, 1, true) then
        local v58 = {
            display = "all  (every potion)",
            text = v1.ALL_POTIONS
        }
        table.insert(v53, v58)
    end
    return v53
end

local v59 = {
    no = true,
    n = true,
    ["false"] = true,
    off = true,
    ["0"] = true
}
local v60 = {
    yes = true,
    y = true,
    ["true"] = true,
    on = true,
    ["1"] = true
}

function v1.ParseYesNo(v61) -- line 249 | captures: v59, v60
    if typeof(v61) == "boolean" then
        return v61
    end
    if v61 ~= nil then
        local v62 = string.lower((tostring(v61)))
        if v60[v62] then
            return true
        end
        if v59[v62] then
            return false
        end
    end
    return nil
end

local function yesNoSuggestions(v63) -- line 266
    local lower = string.lower
    local v64 = if type(v63) == "string" then v63 else ""
    local v65 = lower(v64)
    local v66 = {}
    for v67, v68 in { "yes", "no" } do
        if v65 == "" then
            local v69 = {
                text = v68,
                display = v68
            }
            table.insert(v66, v69)
        else
            local v70 = #v65
            if string.sub(v68, 1, v70) == v65 then
                local v71 = {
                    text = v68,
                    display = v68
                }
                table.insert(v66, v71)
            end
        end
    end
    return v66
end

function v1.ParsePotionDuration(v72) -- line 280 | captures: v1
    if v72 == nil then
        return nil
    end
    local v73
    if typeof(v72) == "number" then
        v73 = v72
    else
        local v74 = tostring(v72)
        v73 = tonumber(v74)
    end
    if v73 then
        local v75 = v73 * 60
        local v76 = math.floor(v75)
        if v76 >= 1 and v76 == v76 and v76 ~= (1/0) then
            return v76
        end
        return nil
    end
    local v77 = v1.ParseDuration(v72)
    if v77 == nil or v77 == v1.PERMANENT then
        return nil
    end
    return v77
end

local function FormatDurationWords(v78) -- line 298
    local v79 = {
        { "day", 86400 },
        { "hour", 3600 },
        { "minute", 60 },
        { "second", 1 }
    }
    local v80 = {}
    local v81 = math.floor(v78)
    for v82, v83 in v79 do
        local v84 = v81 // v83[2]
        if v84 > 0 then
            local v85 = v83[1]
            local v86 = if v84 == 1 then "" else "s"
            local v87 = ("%* %*%*"):format(v84, v85, v86)
            table.insert(v80, v87)
            v81 -= v84 * v83[2]
            if #v80 == 2 then
                break
            end
        end
    end
    if #v80 > 0 then
        return (table.concat(v80, " and "))
    end
    return "0 seconds"
end

v1.FormatDurationWords = FormatDurationWords

function v1.Register(v88) -- line 322 | captures: GuardMorphConfig, v1, guardSuggestions, potionSuggestions, yesNoSuggestions
    local v89 = v88.register_type("amount", {
        convert = function(v90) -- convert | line 324 | captures: v1
            local v91 = v1.ParseNumber(v90)
            if v91 == nil then
                error(("%* is not a number \226\128\148 try 500, 400t, 2.5qa or 1e9"):format(v90), 0)
            end
            return v91
        end,
        analysis = {
            kind = "argument",
            optional = false,
            vararg = false,
            name = "amount",
            type = "number"
        }
    })
    local v92 = v88.register_type("banduration", {
        convert = function(v93) -- convert | line 343 | captures: v1
            local v94 = v1.ParseDuration(v93)
            if v94 == nil then
                error(("%* is not a ban length \226\128\148 try perm, 30m, 12h, 7d or 1d12h"):format(v93), 0)
            end
            return v94
        end,
        analysis = {
            kind = "argument",
            optional = false,
            vararg = false,
            name = "banduration",
            type = "string"
        }
    })
    local v95 = v88.register_type("bantarget", {
        convert = function(v96) -- convert | line 363
            if v96 == nil or tostring(v96) == "" then
                error("give a username or a UserId", 0)
            end
            return (tostring(v96))
        end,
        analysis = {
            kind = "argument",
            optional = false,
            vararg = false,
            name = "bantarget",
            type = "string"
        }
    })
    local v97 = v88.register_type("potion", {
        convert = function(v98) -- convert | line 382 | captures: v1
            local v99 = v1.ParsePotion(v98)
            if v99 == nil then
                error(("%* is not a potion \226\128\148 try %*"):format(v98, (v1.PotionNames())), 0)
            end
            return v99
        end,
        analysis = {
            kind = "argument",
            optional = false,
            vararg = false,
            name = "potion",
            type = "string",
            suggestions = potionSuggestions
        }
    })
    local v100 = v88.register_type("potionduration", {
        convert = function(v101) -- convert | line 402 | captures: v1
            local v102 = v1.ParsePotionDuration(v101)
            if v102 == nil then
                error(("%* is not a potion length \226\128\148 try 10 (minutes), 30s, 10m, 1h or 1h30m"):format(v101), 0)
            end
            return v102
        end,
        analysis = {
            kind = "argument",
            optional = false,
            vararg = false,
            name = "potionduration",
            type = "string"
        }
    })
    local v103 = v88.register_type("guard", {
        convert = function(v104) -- convert | line 422 | captures: GuardMorphConfig
            local v105 = GuardMorphConfig.Resolve((tostring(v104)))
            if v105 == nil then
                error(("%* is not a guard \226\128\148 try %*"):format(v104, (table.concat(GuardMorphConfig.Keys(), ", "))), 0)
            end
            return v105.Key
        end,
        analysis = {
            kind = "argument",
            optional = false,
            vararg = false,
            name = "guard",
            type = "string",
            suggestions = guardSuggestions
        }
    })
    return {
        yesno = v88.register_type("yesno", {
            convert = function(v106) -- convert | line 442 | captures: v1
                local v107 = v1.ParseYesNo(v106)
                if v107 == nil then
                    error(("%* isn't yes or no"):format(v106), 0)
                end
                return v107
            end,
            analysis = {
                kind = "argument",
                optional = false,
                vararg = false,
                name = "yesno",
                type = "string",
                suggestions = yesNoSuggestions
            }
        }),
        amount = v89,
        banduration = v92,
        bantarget = v95,
        guard = v103,
        potion = v97,
        potionduration = v100
    }
end

return v1
