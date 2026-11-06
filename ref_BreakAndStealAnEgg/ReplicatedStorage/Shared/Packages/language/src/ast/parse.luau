-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

require(script.Parent.ast)

local function char(v1) -- line 3
    return (string.byte(v1))
end

local function to_span(v2, v3, v4, v5, v6, v7, v8, v9) -- line 5
    local v10, v11
    if v2 then
        local x = v2.x
        if x then
            v10 = x
            v11 = true
        elseif v3 then
            local x = v3.x
            if x then
                v10 = x
                v11 = true
            else
                v11 = false
            end
        else
            v11 = false
        end
    elseif v3 then
        local x = v3.x
        if x then
            v10 = x
            v11 = true
        else
            v11 = false
        end
    else
        v11 = false
    end
    if not v11 then
        local v12
        if v4 then
            local x = v4.x
            if x then
                v10 = x
                v12 = true
            elseif v5 then
                local x = v5.x
                if x then
                    v10 = x
                    v12 = true
                else
                    v12 = false
                end
            else
                v12 = false
            end
        elseif v5 then
            local x = v5.x
            if x then
                v10 = x
                v12 = true
            else
                v12 = false
            end
        else
            v12 = false
        end
        if not v12 then
            local v13
            if v6 then
                local x = v6.x
                if x then
                    v10 = x
                    v13 = true
                elseif v7 then
                    local x = v7.x
                    if x then
                        v10 = x
                        v13 = true
                    else
                        v13 = false
                    end
                else
                    v13 = false
                end
            elseif v7 then
                local x = v7.x
                if x then
                    v10 = x
                    v13 = true
                else
                    v13 = false
                end
            else
                v13 = false
            end
            if not v13 then
                local v14
                if v8 then
                    local x = v8.x
                    if x then
                        v10 = x
                        v14 = true
                    elseif v9 then
                        local x = v9.x
                        if x then
                            v10 = x
                            v14 = true
                        else
                            v14 = false
                        end
                    else
                        v14 = false
                    end
                elseif v9 then
                    local x = v9.x
                    if x then
                        v10 = x
                        v14 = true
                    else
                        v14 = false
                    end
                else
                    v14 = false
                end
                if not v14 then
                    v10 = 0
                end
            end
        end
    end
    local v15, v16
    if v9 then
        local y = v9.y
        if y then
            v15 = y
            v16 = true
        elseif v8 then
            local y = v8.y
            if y then
                v15 = y
                v16 = true
            else
                v16 = false
            end
        else
            v16 = false
        end
    elseif v8 then
        local y = v8.y
        if y then
            v15 = y
            v16 = true
        else
            v16 = false
        end
    else
        v16 = false
    end
    if not v16 then
        local v17
        if v7 then
            local y = v7.y
            if y then
                v15 = y
                v17 = true
            elseif v6 then
                local y = v6.y
                if y then
                    v15 = y
                    v17 = true
                else
                    v17 = false
                end
            else
                v17 = false
            end
        elseif v6 then
            local y = v6.y
            if y then
                v15 = y
                v17 = true
            else
                v17 = false
            end
        else
            v17 = false
        end
        if not v17 then
            local v18
            if v5 then
                local y = v5.y
                if y then
                    v15 = y
                    v18 = true
                elseif v4 then
                    local y = v4.y
                    if y then
                        v15 = y
                        v18 = true
                    else
                        v18 = false
                    end
                else
                    v18 = false
                end
            elseif v4 then
                local y = v4.y
                if y then
                    v15 = y
                    v18 = true
                else
                    v18 = false
                end
            else
                v18 = false
            end
            if not v18 then
                local v19
                if v3 then
                    local y = v3.y
                    if y then
                        v15 = y
                        v19 = true
                    elseif v2 then
                        local y = v2.y
                        if y then
                            v15 = y
                            v19 = true
                        else
                            v19 = false
                        end
                    else
                        v19 = false
                    end
                elseif v2 then
                    local y = v2.y
                    if y then
                        v15 = y
                        v19 = true
                    else
                        v19 = false
                    end
                else
                    v19 = false
                end
                if not v19 then
                    v15 = 0
                end
            end
        end
    end
    local v20, v21
    if v2 then
        local z = v2.z
        if z then
            v20 = z
            v21 = true
        elseif v3 then
            local z = v3.z
            if z then
                v20 = z
                v21 = true
            else
                v21 = false
            end
        else
            v21 = false
        end
    elseif v3 then
        local z = v3.z
        if z then
            v20 = z
            v21 = true
        else
            v21 = false
        end
    else
        v21 = false
    end
    if not v21 then
        local v22
        if v4 then
            local z = v4.z
            if z then
                v20 = z
                v22 = true
            elseif v5 then
                local z = v5.z
                if z then
                    v20 = z
                    v22 = true
                else
                    v22 = false
                end
            else
                v22 = false
            end
        elseif v5 then
            local z = v5.z
            if z then
                v20 = z
                v22 = true
            else
                v22 = false
            end
        else
            v22 = false
        end
        if not v22 then
            local v23
            if v6 then
                local z = v6.z
                if z then
                    v20 = z
                    v23 = true
                elseif v7 then
                    local z = v7.z
                    if z then
                        v20 = z
                        v23 = true
                    else
                        v23 = false
                    end
                else
                    v23 = false
                end
            elseif v7 then
                local z = v7.z
                if z then
                    v20 = z
                    v23 = true
                else
                    v23 = false
                end
            else
                v23 = false
            end
            if not v23 then
                local v24
                if v8 then
                    local z = v8.z
                    if z then
                        v20 = z
                        v24 = true
                    elseif v9 then
                        local z = v9.z
                        if z then
                            v20 = z
                            v24 = true
                        else
                            v24 = false
                        end
                    else
                        v24 = false
                    end
                elseif v9 then
                    local z = v9.z
                    if z then
                        v20 = z
                        v24 = true
                    else
                        v24 = false
                    end
                else
                    v24 = false
                end
                if not v24 then
                    v20 = 0
                end
            end
        end
    end
    return (vector.create(v10, v15, v20))
end

local function parse(v25) -- line 53 | captures: to_span
    local v26 = 0
    local v27 = 0
    local v28 = buffer.len(v25)
    local v29 = {}

    local function peek() -- line 59 | captures: v26, v25, v28
        if v26 == v28 then
            return 0
        end
        local v30 = v26
        return (buffer.readu8(v25, v30))
    end

    local function peek_2() -- line 64 | captures: v26, v25, v28
        local v31 = v26 + 1
        if v28 <= v31 then
            return 0
        end
        local v32 = v26 + 1
        return (buffer.readu8(v25, v32))
    end

    local function bump() -- line 69 | captures: v26, v28
        local v33 = v26 + 1
        v26 = math.min(v33, v28)
    end

    local function bump_any() -- line 71 | captures: v26, v27, v25, v28
        local v34
        if v26 == v28 then
            v34 = 0
        else
            local v35 = v26
            v34 = buffer.readu8(v25, v35)
        end
        if v34 == 10 then
            v27 += 1
        end
        local v36 = v26 + 1
        v26 = math.min(v36, v28)
        if v26 == v28 then
            return 0
        end
        local v37 = v26
        return (buffer.readu8(v25, v37))
    end

    local function throw(v38, v39) -- line 80 | captures: v29
        local v40 = {
            why = ("SyntaxError: %*"):format(v38),
            span = v39
        }
        table.insert(v29, v40)
    end

    local function panic(v41) -- line 84 | captures: v29
        if v41 then
            local v42 = {
                span = vector.create(0, 0, 0),
                why = v41
            }
            table.insert(v29, v42)
        end
        error({
            result = nil,
            issues = v29
        })
    end

    local function eof(v43) -- line 92 | captures: v26, v27, v28, v29
        local v44 = v26
        if v28 <= v44 then
            local v45 = { why = v43 }
            local v46 = v26
            local v47 = v26
            local v48 = v27
            v45.span = vector.create(v46, v47, v48)
            table.insert(v29, v45)
            error({
                result = nil,
                issues = v29
            }, 0)
        end
        return false
    end

    local function bump_peek() -- line 106 | captures: v26, v25, v28
        local v49 = v26 + 1
        v26 = math.min(v49, v28)
        if v26 == v28 then
            return 0
        end
        local v50 = v26
        return (buffer.readu8(v25, v50))
    end

    local function is_whitespace(v51) -- line 111
        if v51 == 32 or v51 == 9 then
            return true
        end
        return v51 == 13
    end

    local function is_digit(v52) -- line 115
        if v52 >= 48 then
            return v52 <= 57
        end
        return false
    end

    local function is_alpha(v53) -- line 119
        if v53 >= 97 and v53 <= 122 or v53 >= 65 and v53 <= 90 or v53 == 64 then
            return true
        end
        return v53 == 95
    end

    local function string_backslash() -- line 126 | captures: v26, v27, v25, v28
        local v54
        if v26 == v28 then
            v54 = 0
        else
            local v55 = v26
            v54 = buffer.readu8(v25, v55)
        end
        if v54 == 13 then
            local v56 = v26 + 1
            v26 = math.min(v56, v28)
            local v57
            if v26 == v28 then
                v57 = 0
            else
                local v58 = v26
                v57 = buffer.readu8(v25, v58)
            end
            if v57 == 10 then
                local v59 = v26 + 1
                v26 = math.min(v59, v28)
                v27 += 1
            end
        elseif v54 == 122 then
            local v60 = v26 + 1
            v26 = math.min(v60, v28)
            while true do
                local v61
                if v26 == v28 then
                    v61 = 0
                else
                    local v62 = v26
                    v61 = buffer.readu8(v25, v62)
                end
                local v63
                if v61 == 32 or v61 == 9 or v61 == 13 then
                    if v26 == v28 then
                        v63 = 0
                    else
                        local v64 = v26
                        v63 = buffer.readu8(v25, v64)
                    end
                else
                    break
                end
                if v63 == 10 then
                    v27 += 1
                end
                local v65 = v26 + 1
                v26 = math.min(v65, v28)
                if v26 ~= v28 then
                    local v66 = v26
                    buffer.readu8(v25, v66)
                end
            end
        else
            local v67
            if v26 == v28 then
                v67 = 0
            else
                local v68 = v26
                v67 = buffer.readu8(v25, v68)
            end
            if v67 == 10 then
                v27 += 1
            end
            local v69 = v26 + 1
            v26 = math.min(v69, v28)
            if v26 == v28 then
                return
            end
            local v70 = v26
            buffer.readu8(v25, v70)
        end
    end

    local function quoted_string() -- line 147 | captures: v26, v25, v28, eof, string_backslash
        local v71
        if v26 == v28 then
            v71 = 0
        else
            local v72 = v26
            v71 = buffer.readu8(v25, v72)
        end
        local v73 = v26 + 1
        v26 = math.min(v73, v28)
        local v74
        if v26 == v28 then
            v74 = 0
        else
            local v75 = v26
            v74 = buffer.readu8(v25, v75)
        end
        while true do
            local v76
            if v74 == v71 then
                v76 = v26 + 1
                v26 = math.min(v76, v28)
                return "string"
            end
            if eof("expected string to be finished at", v26) then
                v76 = v26 + 1
                v26 = math.min(v76, v28)
                return "string"
            end
            if v74 == 0 or v74 == 10 or v74 == 13 then
                break
            end
            if v74 == 92 then
                local v77 = v26 + 1
                v26 = math.min(v77, v28)
                string_backslash()
            else
                local v78 = v26 + 1
                v26 = math.min(v78, v28)
            end
            if v26 == v28 then
                v74 = 0
            else
                local v79 = v26
                v74 = buffer.readu8(v25, v79)
            end
        end
        return "error"
    end

    local function number() -- line 170 | captures: v26, v25, v28, is_alpha
        local v80 = v26
        local v81
        if v26 == v28 then
            v81 = 0
        else
            local v82 = v26
            v81 = buffer.readu8(v25, v82)
        end
        local v83, v84
        if v81 == 48 then
            local v85 = v26 + 1
            v26 = math.min(v85, v28)
            local v86
            if v26 == v28 then
                v86 = 0
            else
                local v87 = v26
                v86 = buffer.readu8(v25, v87)
            end
            if v86 == 120 or v86 == 88 then
                local v88 = v26 + 1
                v26 = math.min(v88, v28)
                local v89
                if v26 == v28 then
                    v89 = 0
                else
                    local v90 = v26
                    v89 = buffer.readu8(v25, v90)
                end
                v84 = 16
                v83 = v89
            elseif v86 == 98 or v86 == 66 then
                local v91 = v26 + 1
                v26 = math.min(v91, v28)
                local v92
                if v26 == v28 then
                    v92 = 0
                else
                    local v93 = v26
                    v92 = buffer.readu8(v25, v93)
                end
                v84 = 2
                v83 = v92
            else
                v84 = 10
                v83 = v86
            end
        else
            v84 = 10
            v83 = v81
        end
        while true do
            local v94, v95
            if v83 >= 48 and v83 <= 57 then
                v94 = v26 + 1
                v26 = math.min(v94, v28)
                if v26 == v28 then
                    v83 = 0
                else
                    v95 = v26
                    v83 = buffer.readu8(v25, v95)
                end
                continue
            end
            if v83 == 46 then
                v94 = v26 + 1
                v26 = math.min(v94, v28)
                if v26 == v28 then
                    v83 = 0
                else
                    v95 = v26
                    v83 = buffer.readu8(v25, v95)
                end
                continue
            end
            if v83 == 95 then
                v94 = v26 + 1
                v26 = math.min(v94, v28)
                if v26 == v28 then
                    v83 = 0
                else
                    v95 = v26
                    v83 = buffer.readu8(v25, v95)
                end
                continue
            end
            break
        end
        local v96
        if v83 == 101 or v83 == 69 then
            local v97 = v26 + 1
            v26 = math.min(v97, v28)
            local v98
            if v26 == v28 then
                v98 = 0
            else
                local v99 = v26
                v98 = buffer.readu8(v25, v99)
            end
            if v98 == 43 or v98 == 45 then
                local v100 = v26 + 1
                v26 = math.min(v100, v28)
                if v26 == v28 then
                    v96 = 0
                else
                    local v101 = v26
                    v96 = buffer.readu8(v25, v101)
                end
            else
                v96 = v98
            end
        else
            v96 = v83
        end
        while true do
            local v102, v103
            if v96 >= 48 and v96 <= 57 then
                v102 = v26 + 1
                v26 = math.min(v102, v28)
                if v26 == v28 then
                    v96 = 0
                else
                    v103 = v26
                    v96 = buffer.readu8(v25, v103)
                end
                continue
            end
            if is_alpha(v96) then
                v102 = v26 + 1
                v26 = math.min(v102, v28)
                if v26 == v28 then
                    v96 = 0
                else
                    v103 = v26
                    v96 = buffer.readu8(v25, v103)
                end
                continue
            end
            if v96 == 95 then
                v102 = v26 + 1
                v26 = math.min(v102, v28)
                if v26 == v28 then
                    v96 = 0
                else
                    v103 = v26
                    v96 = buffer.readu8(v25, v103)
                end
                continue
            end
            break
        end
        local v104
        if v84 == 10 then
            v104 = buffer.readstring(v25, v80, v26 - v80)
        else
            v104 = buffer.readstring(v25, v80 + 2, v26 - v80 - 2)
        end
        local v105 = string.gsub(v104, "_", "")
        if tonumber(v105, v84) then
            return "number"
        end
        return "error"
    end

    local function read_kind() -- line 219 | captures: v26, v25, v28, is_alpha, quoted_string, number
        local v106
        if v26 == v28 then
            v106 = 0
        else
            local v107 = v26
            v106 = buffer.readu8(v25, v107)
        end
        if v106 == 0 then
            return "eof"
        end
        if v106 == 61 then
            local v108 = v26 + 1
            v26 = math.min(v108, v28)
            local v109
            if v26 == v28 then
                v109 = 0
            else
                local v110 = v26
                v109 = buffer.readu8(v25, v110)
            end
            if v109 == 61 then
                local v111 = v26 + 1
                v26 = math.min(v111, v28)
                return "=="
            end
            return "="
        end
        if v106 == 33 then
            local v112 = v26 + 1
            v26 = math.min(v112, v28)
            local v113
            if v26 == v28 then
                v113 = 0
            else
                local v114 = v26
                v113 = buffer.readu8(v25, v114)
            end
            if v113 == 61 then
                local v115 = v26 + 1
                v26 = math.min(v115, v28)
                return "!="
            end
            return "!"
        end
        if v106 == 126 then
            local v116 = v26 + 1
            v26 = math.min(v116, v28)
            local v117
            if v26 == v28 then
                v117 = 0
            else
                local v118 = v26
                v117 = buffer.readu8(v25, v118)
            end
            if v117 == 61 then
                local v119 = v26 + 1
                v26 = math.min(v119, v28)
                return "~="
            end
            return "error"
        end
        if v106 == 62 then
            local v120 = v26 + 1
            v26 = math.min(v120, v28)
            local v121
            if v26 == v28 then
                v121 = 0
            else
                local v122 = v26
                v121 = buffer.readu8(v25, v122)
            end
            if v121 == 61 then
                local v123 = v26 + 1
                v26 = math.min(v123, v28)
                return ">="
            end
            return ">"
        end
        if v106 == 60 then
            local v124 = v26 + 1
            v26 = math.min(v124, v28)
            local v125
            if v26 == v28 then
                v125 = 0
            else
                local v126 = v26
                v125 = buffer.readu8(v25, v126)
            end
            if v125 == 61 then
                local v127 = v26 + 1
                v26 = math.min(v127, v28)
                return "<="
            end
            return "<"
        end
        if v106 == 42 then
            local v128 = v26 + 1
            v26 = math.min(v128, v28)
            return "*"
        end
        if v106 == 47 then
            local v129 = v26 + 1
            v26 = math.min(v129, v28)
            local v130
            if v26 == v28 then
                v130 = 0
            else
                local v131 = v26
                v130 = buffer.readu8(v25, v131)
            end
            if v130 == 47 then
                local v132 = v26 + 1
                v26 = math.min(v132, v28)
                return "//"
            end
            return "/"
        end
        if v106 == 94 then
            local v133 = v26 + 1
            v26 = math.min(v133, v28)
            return "^"
        end
        if v106 == 37 then
            local v134 = v26 + 1
            v26 = math.min(v134, v28)
            return "%"
        end
        if v106 == 45 then
            local v135 = v26 + 1
            v26 = math.min(v135, v28)
            return "-"
        end
        if v106 == 43 then
            local v136 = v26 + 1
            v26 = math.min(v136, v28)
            return "+"
        end
        if v106 == 40 then
            local v137 = v26 + 1
            v26 = math.min(v137, v28)
            return "("
        end
        if v106 == 41 then
            local v138 = v26 + 1
            v26 = math.min(v138, v28)
            return ")"
        end
        if v106 == 36 then
            local v139 = v26 + 1
            v26 = math.min(v139, v28)
            return "$"
        end
        if v106 == 44 then
            local v140 = v26 + 1
            v26 = math.min(v140, v28)
            return ","
        end
        if v106 == 38 then
            local v141 = v26 + 1
            v26 = math.min(v141, v28)
            return "&"
        end
        if v106 == 123 then
            local v142 = v26 + 1
            v26 = math.min(v142, v28)
            return "{"
        end
        if v106 == 125 then
            local v143 = v26 + 1
            v26 = math.min(v143, v28)
            return "}"
        end
        if v106 == 91 then
            local v144 = v26 + 1
            v26 = math.min(v144, v28)
            return "["
        end
        if v106 == 93 then
            local v145 = v26 + 1
            v26 = math.min(v145, v28)
            return "]"
        end
        if v106 == 124 then
            local v146 = v26 + 1
            v26 = math.min(v146, v28)
            return "|"
        end
        if v106 == 10 then
            local v147 = v26 + 1
            v26 = math.min(v147, v28)
            return "\n"
        end
        if v106 == 59 then
            local v148 = v26 + 1
            v26 = math.min(v148, v28)
            return ";"
        end
        if v106 >= 48 and v106 <= 57 then
            return (number())
        end
        if is_alpha(v106) then
            local v149 = v26
            while true do
                local v150 = v26 + 1
                v26 = math.min(v150, v28)
                local v151
                if v26 == v28 then
                    v151 = 0
                else
                    local v152 = v26
                    v151 = buffer.readu8(v25, v152)
                end
                if is_alpha(v151) then
                    continue
                end
                if v151 >= 48 and v151 <= 57 then
                    continue
                end
                if v151 == 45 then
                    continue
                end
                break
            end
            local v153 = buffer.readstring(v25, v149, v26 - v149)
            if v153 == "true" then
                return "true"
            end
            if v153 == "false" then
                return "false"
            end
            if v153 == "nil" then
                return "nil"
            end
            if v153 == "if" then
                return "if"
            end
            if v153 == "else" then
                return "else"
            end
            if v153 == "elseif" then
                return "elseif"
            end
            if v153 == "while" then
                return "while"
            end
            if v153 == "for" then
                return "for"
            end
            if v153 == "return" then
                return "return"
            end
            if v153 == "break" then
                return "break"
            end
            if v153 == "continue" then
                return "continue"
            end
            if v153 == "and" then
                return "and"
            end
            if v153 == "or" then
                return "or"
            end
            return "identifier"
        end
        if v106 == 34 or v106 == 39 then
            return (quoted_string())
        end
        if v106 == 46 then
            local v154 = v26 + 1
            local v155
            if v28 <= v154 then
                v155 = 0
            else
                local v156 = v26 + 1
                v155 = buffer.readu8(v25, v156)
            end
            if v155 >= 48 and v155 <= 57 then
                return (number())
            end
        end
        if v106 == 46 then
            local v157 = v26 + 1
            v26 = math.min(v157, v28)
            local v158
            if v26 == v28 then
                v158 = 0
            else
                local v159 = v26
                v158 = buffer.readu8(v25, v159)
            end
            if v158 == 46 then
                local v160 = v26 + 1
                v26 = math.min(v160, v28)
                return ".."
            end
            return "."
        end
        if v106 == 32 or v106 == 9 or v106 == 13 then
            local v161 = v26 + 1
            v26 = math.min(v161, v28)
            return "whitespace"
        end
        local v162 = v26 + 1
        v26 = math.min(v162, v28)
        return "error"
    end

    local function next_token() -- line 401 | captures: v26, v27, v25, v29, read_kind
        local v163, v164, v165 = v26, v27, read_kind()
        while v165 == "whitespace" or v165 == "comment" do
            v163, v164, v165 = v26, v27, read_kind()
        end
        if v165 == "error" then
            local v166 = ("could not parse %* into a token"):format((buffer.readstring(v25, v163, v26 - v163)))
            local v167 = v26
            local v168 = vector.create(v163, v167, v164)
            local v169 = {
                why = ("SyntaxError: %*"):format(v166),
                span = v168
            }
            table.insert(v29, v169)
        end
        local v170 = {
            kind = v165,
            text = buffer.readstring(v25, v163, v26 - v163)
        }
        local v171 = v26
        v170.span = vector.create(v163, v171, v164)
        return v170
    end

    local v172 = next_token()
    local v173 = v172
    local kind = v172.kind
    local x = v172.span.x
    local v174 = next_token()
    local v175 = v174
    local kind_2 = v174.kind
    local x_2 = v174.span.x

    local function consume() -- line 434 | captures: v173, kind, x, v175, kind_2, x_2, next_token
        local v176 = v173
        local kind_3 = kind
        local v177 = v175
        local kind_4 = kind_2
        v173 = v177
        kind = kind_4
        x = x_2
        v175 = next_token()
        kind_2 = v175.kind
        x_2 = v175.span.x
        return v176, kind_3
    end

    local function skip_current() -- line 444 | captures: v173, kind, x, v175, kind_2, x_2, next_token
        while kind == "\n" do
            local v178 = v175
            local kind_3 = kind_2
            v173 = v178
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
    end

    local function current_is(v179) -- line 450 | captures: v173, kind, x, v175, kind_2, x_2, next_token
        while kind == "\n" do
            local v180 = v175
            local kind_3 = kind_2
            v173 = v180
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        return kind == v179
    end

    local function lookahead_is(v181) -- line 456 | captures: v175, kind_2, x_2, next_token
        while kind_2 == "\n" do
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        return kind_2 == v181
    end

    local function display(v182) -- line 466
        local kind = v182.kind
        if kind ~= "identifier" and kind ~= "number" and kind ~= "string" then
            if v182.kind == "error" then
                return "error '" .. v182.text .. "'"
            end
            return "'" .. kind .. "'"
        end
        return v182.text
    end

    local function expected_but(v183) -- line 478 | captures: v173, kind, x, v175, kind_2, x_2, v29, next_token
        local v184 = "expected %*, but got %* of %* instead"
        local v185 = v173
        local kind_3 = v185.kind
        local v186
        if kind_3 ~= "identifier" and kind_3 ~= "number" and kind_3 ~= "string" then
            if v185.kind == "error" then
                v186 = "error '" .. v185.text .. "'"
            else
                v186 = "'" .. kind_3 .. "'"
            end
        else
            v186 = v185.text
        end
        local v187 = v184:format(v183, v186, kind)
        local span = v173.span
        local v188 = {
            why = ("SyntaxError: %*"):format(v187),
            span = span
        }
        table.insert(v29, v188)
        local v189 = v175
        local kind_4 = kind_2
        v173 = v189
        kind = kind_4
        x = x_2
        v175 = next_token()
        kind_2 = v175.kind
        x_2 = v175.span.x
        return nil
    end

    local function expect(v190) -- line 487 | captures: v173, kind, x, v175, kind_2, x_2, v29, next_token
        while kind == "\n" do
            local v191 = v175
            local kind_3 = kind_2
            v173 = v191
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == v190 then
            local v192 = v173
            local v193 = v175
            local kind_3 = kind_2
            v173 = v193
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
            return v192
        end
        local v194 = "expected %*, but got %* of %* instead"
        local v195 = v173
        local kind_3 = v195.kind
        local v196
        if kind_3 ~= "identifier" and kind_3 ~= "number" and kind_3 ~= "string" then
            if v195.kind == "error" then
                v196 = "error '" .. v195.text .. "'"
            else
                v196 = "'" .. kind_3 .. "'"
            end
        else
            v196 = v195.text
        end
        local v197 = v194:format(v190, v196, kind)
        local span = v173.span
        local v198 = {
            why = ("SyntaxError: %*"):format(v197),
            span = span
        }
        table.insert(v29, v198)
        local v199 = v175
        local kind_4 = kind_2
        v173 = v199
        kind = kind_4
        x = x_2
        v175 = next_token()
        kind_2 = v175.kind
        x_2 = v175.span.x
        return false
    end

    local function expect_fatal(v200) -- line 498 | captures: v173, kind, x, v175, kind_2, x_2, v29, panic, next_token
        while kind == "\n" do
            local v201 = v175
            local kind_3 = kind_2
            v173 = v201
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == v200 then
            local v202 = v173
            local v203 = v175
            local kind_3 = kind_2
            v173 = v203
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
            return v202
        end
        local v204 = { kind = v200 }
        local kind_3 = v204.kind
        local v205
        if kind_3 ~= "identifier" and kind_3 ~= "number" and kind_3 ~= "string" then
            if v204.kind == "error" then
                v205 = "error '" .. v204.text .. "'"
            else
                v205 = "'" .. kind_3 .. "'"
            end
        else
            v205 = v204.text
        end
        local v206 = "expected %*, but got %* of %* instead"
        local v207 = v173
        local kind_4 = v207.kind
        local v208
        if kind_4 ~= "identifier" and kind_4 ~= "number" and kind_4 ~= "string" then
            if v207.kind == "error" then
                v208 = "error '" .. v207.text .. "'"
            else
                v208 = "'" .. kind_4 .. "'"
            end
        else
            v208 = v207.text
        end
        local v209 = v206:format(v205, v208, kind)
        local span = v173.span
        local v210 = {
            why = ("SyntaxError: %*"):format(v209),
            span = span
        }
        table.insert(v29, v210)
        local v211 = v175
        local kind_5 = kind_2
        v173 = v211
        kind = kind_5
        x = x_2
        v175 = next_token()
        kind_2 = v175.kind
        x_2 = v175.span.x
        return panic()
    end

    local function is_delimiter() -- line 513 | captures: v173, kind, x, v175, kind_2, x_2, next_token
        while kind == "\n" do
            local v212 = v175
            local kind_3 = kind_2
            v173 = v212
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "}" or kind == "]" or kind == ")" or kind == ";" or kind == "\n" then
            return true
        end
        return kind == "eof"
    end

    local v213, v214, v215, v216, v217, v218, v219, v220, v221, v222, v223, v224

    local function separated(v225, v226) -- line 548 | captures: v27, v173, kind, x, v175, kind_2, x_2, v29, next_token
        local v227 = {}
        while true do
            if kind == "\n" then
                local v228 = v175
                local kind_3 = kind_2
                v173 = v228
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
                continue
            end
            if kind == "}" or kind == "]" or kind == ")" or kind == ";" or kind == "\n" or kind == "eof" then
                break
            end
            local x_3, v229, v230, v231
            if v226 then
                while kind == "\n" do
                    local v232 = v175
                    local kind_3 = kind_2
                    v173 = v232
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                if kind == v226 then
                    break
                end
                while kind == "\n" do
                    local v233 = v175
                    local kind_3 = kind_2
                    v173 = v233
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                x_3 = x
                v229 = v27
                local v234 = v225()
                while kind == "\n" do
                    local v235 = v175
                    local kind_3 = kind_2
                    v173 = v235
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                local v236
                if kind == "," then
                    while kind == "\n" do
                        local v237 = v175
                        local kind_3 = kind_2
                        v173 = v237
                        kind = kind_3
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                    end
                    if kind == "," then
                        v236 = v173
                        local v238 = v175
                        local kind_3 = kind_2
                        v173 = v238
                        kind = kind_3
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                    else
                        local v239 = "expected ,, but got %* of %* instead"
                        local v240 = v173
                        local kind_3 = v240.kind
                        local text
                        if kind_3 == "identifier" or kind_3 == "number" or kind_3 == "string" then
                            text = v240.text
                        elseif v240.kind == "error" then
                            text = "error '" .. v240.text .. "'"
                        else
                            text = "'" .. kind_3 .. "'"
                        end
                        local v241 = v239:format(text, kind)
                        local span = v173.span
                        local v242 = {}
                        v242.why = ("SyntaxError: %*"):format(v241)
                        v242.span = span
                        table.insert(v29, v242)
                        local v243 = v175
                        local kind_4 = kind_2
                        v173 = v243
                        kind = kind_4
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                        v236 = false
                    end
                end
                v230 = {
                    value = v234,
                    separator = v236
                }
                local y = if v236 then v236.span.y else nil
                if not v236 or not y then
                    v231 = x_3
                else
                    v231 = y
                end
            else
                while kind == "\n" do
                    local v244 = v175
                    local kind_3 = kind_2
                    v173 = v244
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                x_3 = x
                v229 = v27
                local v245 = v225()
                while kind == "\n" do
                    local v246 = v175
                    local kind_3 = kind_2
                    v173 = v246
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                local v247
                if kind == "," then
                    while kind == "\n" do
                        local v248 = v175
                        local kind_3 = kind_2
                        v173 = v248
                        kind = kind_3
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                    end
                    if kind == "," then
                        v247 = v173
                        local v249 = v175
                        local kind_3 = kind_2
                        v173 = v249
                        kind = kind_3
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                    else
                        local v250 = "expected ,, but got %* of %* instead"
                        local v251 = v173
                        local kind_3 = v251.kind
                        local text
                        if kind_3 == "identifier" or kind_3 == "number" or kind_3 == "string" then
                            text = v251.text
                        elseif v251.kind == "error" then
                            text = "error '" .. v251.text .. "'"
                        else
                            text = "'" .. kind_3 .. "'"
                        end
                        local v252 = v250:format(text, kind)
                        local span = v173.span
                        local v253 = {}
                        v253.why = ("SyntaxError: %*"):format(v252)
                        v253.span = span
                        table.insert(v29, v253)
                        local v254 = v175
                        local kind_4 = kind_2
                        v173 = v254
                        kind = kind_4
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                        v247 = false
                    end
                end
                v230 = {
                    value = v245,
                    separator = v247
                }
                if v247 then
                    local y = v247.span.y
                    v231 = y or x_3
                else
                    v231 = x_3
                end
            end
            v230.span = vector.create(x_3, v231, v229)
            table.insert(v227, v230)
        end
        return v227
    end

    local function v255() -- line 578 | captures: v173, kind, x, v175, kind_2, x_2, v213, v217, v218, v219, v220, v221, v29, next_token
        local function v256(v257, ...)
            table.insert(v257, ...)
        end

        local function v258(v259, ...)
            table.insert(v259, ...)
        end

        local function v260(v261, ...)
            table.insert(v261, ...)
        end

        local function v262(v263, ...)
            table.insert(v263, ...)
        end

        local function v264(v265, ...)
            table.insert(v265, ...)
        end

        local x_3 = x
        local v266 = {}
        while true do
            if kind == "\n" then
                local v267 = v175
                local kind_3 = kind_2
                v173 = v267
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
                continue
            end
            local v268, kind_3, v269, kind_4, v270, kind_5, v271, kind_6, v272, v273, kind_7, text, v274, span, v275, v276, kind_8
            if kind == "eof" then
                while kind == "\n" do
                    v268 = v175
                    kind_3 = kind_2
                    v173 = v268
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                if kind == ";" then
                    while kind == ";" do
                        v269 = v175
                        kind_4 = kind_2
                        v173 = v269
                        kind = kind_4
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                    end
                    while kind == "\n" do
                        v270 = v175
                        kind_5 = kind_2
                        v173 = v270
                        kind = kind_5
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                    end
                    if kind == "if" then
                        v256(v266, v217())
                    elseif kind == "while" then
                        v258(v266, v218())
                    elseif kind == "for" then
                        v260(v266, v219())
                    elseif kind_2 == "=" then
                        v262(v266, v220())
                    else
                        if kind == "break" then
                            break
                        end
                        if kind == "return" then
                            break
                        end
                        if kind == "continue" then
                            break
                        end
                        while kind == "\n" do
                            v271 = v175
                            kind_6 = kind_2
                            v173 = v271
                            kind = kind_6
                            x = x_2
                            v175 = next_token()
                            kind_2 = v175.kind
                            x_2 = v175.span.x
                        end
                        if kind == "}" or kind == "]" or kind == ")" or kind == ";" or kind == "\n" or kind == "eof" then
                            break
                        end
                        if kind == "eof" then
                            break
                        end
                        if kind == "identifier" or kind == "$" then
                            v264(v266, v221())
                        else
                            v272 = "expected statement, but got %* of %* instead"
                            v273 = v173
                            kind_7 = v273.kind
                            if kind_7 == "identifier" or kind_7 == "number" or kind_7 == "string" then
                                text = v273.text
                            elseif v273.kind == "error" then
                                text = "error '" .. v273.text .. "'"
                            else
                                text = "'" .. kind_7 .. "'"
                            end
                            v274 = v272:format(text, kind)
                            span = v173.span
                            v275 = {}
                            v275.why = ("SyntaxError: %*"):format(v274)
                            v275.span = span
                            table.insert(v29, v275)
                            v276 = v175
                            kind_8 = kind_2
                            v173 = v276
                            kind = kind_8
                            x = x_2
                            v175 = next_token()
                            kind_2 = v175.kind
                            x_2 = v175.span.x
                        end
                    end
                    continue
                end
                break
            end
            while kind == "\n" do
                local v277 = v175
                local kind_3 = kind_2
                v173 = v277
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "}" or kind == "]" or kind == ")" or kind == ";" or kind == "\n" or kind == "eof" then
                while kind == "\n" do
                    v268 = v175
                    kind_3 = kind_2
                    v173 = v268
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                if kind == ";" then
                    while kind == ";" do
                        v269 = v175
                        kind_4 = kind_2
                        v173 = v269
                        kind = kind_4
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                    end
                    while kind == "\n" do
                        v270 = v175
                        kind_5 = kind_2
                        v173 = v270
                        kind = kind_5
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                    end
                    if kind == "if" then
                        v256(v266, v217())
                    elseif kind == "while" then
                        v258(v266, v218())
                    elseif kind == "for" then
                        v260(v266, v219())
                    elseif kind_2 == "=" then
                        v262(v266, v220())
                    else
                        if kind == "break" then
                            break
                        end
                        if kind == "return" then
                            break
                        end
                        if kind == "continue" then
                            break
                        end
                        while kind == "\n" do
                            v271 = v175
                            kind_6 = kind_2
                            v173 = v271
                            kind = kind_6
                            x = x_2
                            v175 = next_token()
                            kind_2 = v175.kind
                            x_2 = v175.span.x
                        end
                        if kind == "}" or kind == "]" or kind == ")" or kind == ";" or kind == "\n" or kind == "eof" then
                            break
                        end
                        if kind == "eof" then
                            break
                        end
                        if kind == "identifier" or kind == "$" then
                            v264(v266, v221())
                        else
                            v272 = "expected statement, but got %* of %* instead"
                            v273 = v173
                            kind_7 = v273.kind
                            if kind_7 == "identifier" or kind_7 == "number" or kind_7 == "string" then
                                text = v273.text
                            elseif v273.kind == "error" then
                                text = "error '" .. v273.text .. "'"
                            else
                                text = "'" .. kind_7 .. "'"
                            end
                            v274 = v272:format(text, kind)
                            span = v173.span
                            v275 = {}
                            v275.why = ("SyntaxError: %*"):format(v274)
                            v275.span = span
                            table.insert(v29, v275)
                            v276 = v175
                            kind_8 = kind_2
                            v173 = v276
                            kind = kind_8
                            x = x_2
                            v175 = next_token()
                            kind_2 = v175.kind
                            x_2 = v175.span.x
                        end
                    end
                    continue
                end
                break
            end
            while kind == ";" do
                v269 = v175
                kind_4 = kind_2
                v173 = v269
                kind = kind_4
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            while kind == "\n" do
                v270 = v175
                kind_5 = kind_2
                v173 = v270
                kind = kind_5
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "if" then
                v256(v266, v217())
            elseif kind == "while" then
                v258(v266, v218())
            elseif kind == "for" then
                v260(v266, v219())
            elseif kind_2 == "=" then
                v262(v266, v220())
            else
                if kind == "break" then
                    break
                end
                if kind == "return" then
                    break
                end
                if kind == "continue" then
                    break
                end
                while kind == "\n" do
                    v271 = v175
                    kind_6 = kind_2
                    v173 = v271
                    kind = kind_6
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                if kind == "}" or kind == "]" or kind == ")" or kind == ";" or kind == "\n" or kind == "eof" then
                    break
                end
                if kind == "eof" then
                    break
                end
                if kind == "identifier" or kind == "$" then
                    v264(v266, v221())
                else
                    v272 = "expected statement, but got %* of %* instead"
                    v273 = v173
                    kind_7 = v273.kind
                    if kind_7 == "identifier" or kind_7 == "number" or kind_7 == "string" then
                        text = v273.text
                    elseif v273.kind == "error" then
                        text = "error '" .. v273.text .. "'"
                    else
                        text = "'" .. kind_7 .. "'"
                    end
                    v274 = v272:format(text, kind)
                    span = v173.span
                    v275 = {}
                    v275.why = ("SyntaxError: %*"):format(v274)
                    v275.span = span
                    table.insert(v29, v275)
                    v276 = v175
                    kind_8 = kind_2
                    v173 = v276
                    kind = kind_8
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
            end
        end
        local v278 = {
            body = v266,
            last_statement = v213()
        }
        local x_4 = x
        v278.span = vector.create(x_3, x_4)
        return v278
    end

    local function parse_statement_node() -- line 619 | captures: v173, kind, x, v175, kind_2, x_2, v217, v218, v219, v220, v221, next_token
        while kind == "\n" do
            local v279 = v175
            local kind_3 = kind_2
            v173 = v279
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "if" then
            return v217()
        end
        while kind == "\n" do
            local v280 = v175
            local kind_3 = kind_2
            v173 = v280
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "while" then
            return v218()
        end
        while kind == "\n" do
            local v281 = v175
            local kind_3 = kind_2
            v173 = v281
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "for" then
            return v219()
        end
        while kind == "\n" do
            local v282 = v175
            local kind_3 = kind_2
            v173 = v282
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        local v283 = kind == "identifier"
        local v284
        if v283 then
            while kind_2 == "\n" do
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            v284 = kind_2 == "="
        end
        if not v283 or not v284 then
            return v221()
        end
        return v220()
    end

    function v213() -- line 633 | captures: v173, kind, x, v175, kind_2, x_2, v216, next_token, expect_fatal, separated
        while kind == "\n" do
            local v285 = v175
            local kind_3 = kind_2
            v173 = v285
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "continue" then
            local continue = expect_fatal("continue")
            return {
                kind = "continue",
                token = continue,
                span = continue.span
            }
        end
        while kind == "\n" do
            local v286 = v175
            local kind_3 = kind_2
            v173 = v286
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "break" then
            local v287 = expect_fatal("break")
            return {
                kind = "break",
                token = v287,
                span = v287.span
            }
        end
        while kind == "\n" do
            local v288 = v175
            local kind_3 = kind_2
            v173 = v288
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "return" then
            local v289 = expect_fatal("return")
            return {
                kind = "return",
                token = v289,
                values = separated(v216),
                span = v289.span
            }
        end
        return nil
    end

    local function v290(v291, v292, v293) -- line 665 | captures: v173, kind, x, v175, kind_2, x_2, v29, next_token
        while kind == "\n" do
            local v294 = v175
            local kind_3 = kind_2
            v173 = v294
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        local v295
        if kind == v291 then
            v295 = v173
            local v296 = v175
            local kind_3 = kind_2
            v173 = v296
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        else
            local v297 = "expected %*, but got %* of %* instead"
            local v298 = v173
            local kind_3 = v298.kind
            local text
            if kind_3 == "identifier" or kind_3 == "number" or kind_3 == "string" then
                text = v298.text
            elseif v298.kind == "error" then
                text = "error '" .. v298.text .. "'"
            else
                text = "'" .. kind_3 .. "'"
            end
            local v299 = v297:format(v291, text, kind)
            local span = v173.span
            local v300 = {
                why = ("SyntaxError: %*"):format(v299),
                span = span
            }
            table.insert(v29, v300)
            local v301 = v175
            local kind_4 = kind_2
            v173 = v301
            kind = kind_4
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
            v295 = false
        end
        local v302 = v293()
        while kind == "\n" do
            local v303 = v175
            local kind_3 = kind_2
            v173 = v303
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        local v304
        if kind == v292 then
            v304 = v173
            local v305 = v175
            local kind_3 = kind_2
            v173 = v305
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        else
            local v306 = "expected %*, but got %* of %* instead"
            local v307 = v173
            local kind_3 = v307.kind
            local text
            if kind_3 == "identifier" or kind_3 == "number" or kind_3 == "string" then
                text = v307.text
            elseif v307.kind == "error" then
                text = "error '" .. v307.text .. "'"
            else
                text = "'" .. kind_3 .. "'"
            end
            local v308 = v306:format(v292, text, kind)
            local span = v173.span
            local v309 = {
                why = ("SyntaxError: %*"):format(v308),
                span = span
            }
            table.insert(v29, v309)
            local v310 = v175
            local kind_4 = kind_2
            v173 = v310
            kind = kind_4
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
            v304 = false
        end
        if v295 then
            return {
                left = v295,
                value = v302,
                right = v304 or nil
            }
        end
        return false
    end

    local function v311() -- line 683 | captures: v173, kind, x, v175, kind_2, x_2, v255, v290, v29, panic, next_token, separated, to_span
        local v312 = v290("|", "|", function() -- line 684 | captures: v173, kind, x, v175, kind_2, x_2, v29, next_token, separated
            return (separated(function() -- line 685 | captures: v173, kind, x, v175, kind_2, x_2, v29, next_token
                while kind == "\n" do
                    local v313 = v175
                    local kind_3 = kind_2
                    v173 = v313
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                if kind == "identifier" then
                    local v314 = v173
                    local v315 = v175
                    local kind_3 = kind_2
                    v173 = v315
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                    return v314
                end
                local v316 = "expected identifier, but got %* of %* instead"
                local v317 = v173
                local kind_3 = v317.kind
                local v318
                if kind_3 ~= "identifier" and kind_3 ~= "number" and kind_3 ~= "string" then
                    if v317.kind == "error" then
                        v318 = "error '" .. v317.text .. "'"
                    else
                        v318 = "'" .. kind_3 .. "'"
                    end
                else
                    v318 = v317.text
                end
                local v319 = v316:format(v318, kind)
                local span = v173.span
                local v320 = {
                    why = ("SyntaxError: %*"):format(v319),
                    span = span
                }
                table.insert(v29, v320)
                local v321 = v175
                local kind_4 = kind_2
                v173 = v321
                kind = kind_4
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
                return false
            end, "|"))
        end)
        local v322 = v290("{", "}", v255)
        if v312 then
            local v323 = {
                arguments = v312,
                block = v322 or nil
            }
            local span = v312.left.span
            local v324 = v312.right and v312.right.span
            local span_2, v325
            if v322 and v322.left then
                local span = v322.left.span
                if span then
                    span_2 = span
                    v325 = true
                else
                    v325 = false
                end
            else
                v325 = false
            end
            if not v325 then
                span_2 = nil
            end
            local span_3, v326
            if v322 and v322.right then
                local span = v322.right.span
                if span then
                    span_3 = span
                    v326 = true
                else
                    v326 = false
                end
            else
                v326 = false
            end
            if not v326 then
                span_3 = nil
            end
            v323.span = to_span(span, v324, span_2, span_3)
            return v323
        end
        return panic("no arguments obtained")
    end

    local function parse_if_branch() -- line 705 | captures: v255, v216, v290, to_span
        local v327 = v290("(", ")", v216)
        local v328 = v290("{", "}", v255)
        local v329 = {
            condition = v327 or nil,
            block = v328 or nil
        }
        local span, v330
        if v327 and v327.left then
            local span_2 = v327.left.span
            if span_2 then
                span = span_2
                v330 = true
            else
                v330 = false
            end
        else
            v330 = false
        end
        if not v330 then
            span = nil
        end
        local span_2, v331
        if v327 and v327.value then
            local span = v327.value.span
            if span then
                span_2 = span
                v331 = true
            else
                v331 = false
            end
        else
            v331 = false
        end
        if not v331 then
            span_2 = nil
        end
        local span_3, v332
        if v327 and v327.right then
            local span = v327.right.span
            if span then
                span_3 = span
                v332 = true
            else
                v332 = false
            end
        else
            v332 = false
        end
        if not v332 then
            span_3 = nil
        end
        local span_4, v333
        if v328 and v328.left then
            local span = v328.left.span
            if span then
                span_4 = span
                v333 = true
            else
                v333 = false
            end
        else
            v333 = false
        end
        if not v333 then
            span_4 = nil
        end
        local span_5, v334
        if v328 and v328.value then
            local span = v328.value.span
            if span then
                span_5 = span
                v334 = true
            else
                v334 = false
            end
        else
            v334 = false
        end
        if not v334 then
            span_5 = nil
        end
        local span_6, v335
        if v328 and v328.right then
            local span = v328.right.span
            if span then
                span_6 = span
                v335 = true
            else
                v335 = false
            end
        else
            v335 = false
        end
        if not v335 then
            span_6 = nil
        end
        v329.span = to_span(span, span_2, span_3, span_4, span_5, span_6)
        return v329
    end

    local function parse_elseif_branch() -- line 726 | captures: expect_fatal, parse_if_branch
        local v336 = expect_fatal("elseif")
        local v337 = parse_if_branch()
        local v338 = {
            ifelse = v336,
            branch = v337
        }
        local span = v336.span
        local span_2 = v337.span
        local v339, v340
        if span then
            local x = span.x
            if x then
                v339 = x
                v340 = true
            elseif span_2 then
                local x = span_2.x
                if x then
                    v339 = x
                    v340 = true
                else
                    v340 = false
                end
            else
                v340 = false
            end
        elseif span_2 then
            local x = span_2.x
            if x then
                v339 = x
                v340 = true
            else
                v340 = false
            end
        else
            v340 = false
        end
        if not v340 then
            v339 = 0
        end
        local v341, v342
        if span_2 then
            local y = span_2.y
            if y then
                v341 = y
                v342 = true
            elseif span then
                local y = span.y
                if y then
                    v341 = y
                    v342 = true
                else
                    v342 = false
                end
            else
                v342 = false
            end
        elseif span then
            local y = span.y
            if y then
                v341 = y
                v342 = true
            else
                v342 = false
            end
        else
            v342 = false
        end
        if not v342 then
            v341 = 0
        end
        local v343, v344
        if span then
            local z = span.z
            if z then
                v343 = z
                v344 = true
            elseif span_2 then
                local z = span_2.z
                if z then
                    v343 = z
                    v344 = true
                else
                    v344 = false
                end
            else
                v344 = false
            end
        elseif span_2 then
            local z = span_2.z
            if z then
                v343 = z
                v344 = true
            else
                v344 = false
            end
        else
            v344 = false
        end
        if not v344 then
            v343 = 0
        end
        v338.span = vector.create(v339, v341, v343)
        return v338
    end

    function v217() -- line 737 | captures: v173, kind, x, v175, kind_2, x_2, v255, v290, next_token, expect_fatal, parse_if_branch
        local v345 = expect_fatal("if")
        local v346 = parse_if_branch()
        local v347 = {}
        while true do
            if kind == "\n" then
                local v348 = v175
                local kind_3 = kind_2
                v173 = v348
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
                continue
            end
            local v349, span, span_2, x_3
            if kind == "elseif" then
                local v350 = expect_fatal("elseif")
                local v351 = parse_if_branch()
                v349 = {
                    ifelse = v350,
                    branch = v351
                }
                span = v350.span
                span_2 = v351.span
                x_3 = span and span.x or span_2 and span_2.x or 0
            else
                break
            end
            local v352, v353
            if span_2 then
                local y = span_2.y
                if y then
                    v352 = y
                    v353 = true
                elseif span then
                    local y = span.y
                    if y then
                        v352 = y
                        v353 = true
                    else
                        v353 = false
                    end
                else
                    v353 = false
                end
            elseif span then
                local y = span.y
                if y then
                    v352 = y
                    v353 = true
                else
                    v353 = false
                end
            else
                v353 = false
            end
            if not v353 then
                v352 = 0
            end
            local v354, v355
            if span then
                local z = span.z
                if z then
                    v354 = z
                    v355 = true
                elseif span_2 then
                    local z = span_2.z
                    if z then
                        v354 = z
                        v355 = true
                    else
                        v355 = false
                    end
                else
                    v355 = false
                end
            elseif span_2 then
                local z = span_2.z
                if z then
                    v354 = z
                    v355 = true
                else
                    v355 = false
                end
            else
                v355 = false
            end
            if not v355 then
                v354 = 0
            end
            v349.span = vector.create(x_3, v352, v354)
            table.insert(v347, v349)
        end
        while kind == "\n" do
            local v356 = v175
            local kind_3 = kind_2
            v173 = v356
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        local v357
        if kind == "else" then
            local v358 = expect_fatal("else")
            local v359 = v290("{", "}", v255)
            v357 = {
                token = v358,
                block = v359 or nil
            }
            local span = v358.span
            local span_2, v360
            if v359 and v359.left then
                local span = v359.left.span
                if span then
                    span_2 = span
                    v360 = true
                else
                    v360 = false
                end
            else
                v360 = false
            end
            if not v360 then
                span_2 = nil
            end
            local span_3, v361
            if v359 and v359.value then
                local span = v359.value.span
                if span then
                    span_3 = span
                    v361 = true
                else
                    v361 = false
                end
            else
                v361 = false
            end
            if not v361 then
                span_3 = nil
            end
            local span_4, v362
            if v359 and v359.right then
                local span = v359.right.span
                if span then
                    span_4 = span
                    v362 = true
                else
                    v362 = false
                end
            else
                v362 = false
            end
            if not v362 then
                span_4 = nil
            end
            local v363, v364
            if span then
                local x = span.x
                if x then
                    v363 = x
                    v364 = true
                elseif span_2 then
                    local x = span_2.x
                    if x then
                        v363 = x
                        v364 = true
                    else
                        v364 = false
                    end
                else
                    v364 = false
                end
            elseif span_2 then
                local x = span_2.x
                if x then
                    v363 = x
                    v364 = true
                else
                    v364 = false
                end
            else
                v364 = false
            end
            if not v364 then
                local v365
                if span_3 then
                    local x = span_3.x
                    if x then
                        v363 = x
                        v365 = true
                    elseif span_4 then
                        local x = span_4.x
                        if x then
                            v363 = x
                            v365 = true
                        else
                            v365 = false
                        end
                    else
                        v365 = false
                    end
                elseif span_4 then
                    local x = span_4.x
                    if x then
                        v363 = x
                        v365 = true
                    else
                        v365 = false
                    end
                else
                    v365 = false
                end
                if not v365 then
                    v363 = 0
                end
            end
            local v366, v367
            if span_4 then
                local y = span_4.y
                if y then
                    v366 = y
                    v367 = true
                elseif span_3 then
                    local y = span_3.y
                    if y then
                        v366 = y
                        v367 = true
                    else
                        v367 = false
                    end
                else
                    v367 = false
                end
            elseif span_3 then
                local y = span_3.y
                if y then
                    v366 = y
                    v367 = true
                else
                    v367 = false
                end
            else
                v367 = false
            end
            if not v367 then
                local v368
                if span_2 then
                    local y = span_2.y
                    if y then
                        v366 = y
                        v368 = true
                    elseif span then
                        local y = span.y
                        if y then
                            v366 = y
                            v368 = true
                        else
                            v368 = false
                        end
                    else
                        v368 = false
                    end
                elseif span then
                    local y = span.y
                    if y then
                        v366 = y
                        v368 = true
                    else
                        v368 = false
                    end
                else
                    v368 = false
                end
                if not v368 then
                    v366 = 0
                end
            end
            local v369, v370
            if span then
                local z = span.z
                if z then
                    v369 = z
                    v370 = true
                elseif span_2 then
                    local z = span_2.z
                    if z then
                        v369 = z
                        v370 = true
                    else
                        v370 = false
                    end
                else
                    v370 = false
                end
            elseif span_2 then
                local z = span_2.z
                if z then
                    v369 = z
                    v370 = true
                else
                    v370 = false
                end
            else
                v370 = false
            end
            if not v370 then
                local v371
                if span_3 then
                    local z = span_3.z
                    if z then
                        v369 = z
                        v371 = true
                    elseif span_4 then
                        local z = span_4.z
                        if z then
                            v369 = z
                            v371 = true
                        else
                            v371 = false
                        end
                    else
                        v371 = false
                    end
                elseif span_4 then
                    local z = span_4.z
                    if z then
                        v369 = z
                        v371 = true
                    else
                        v371 = false
                    end
                else
                    v371 = false
                end
                if not v371 then
                    v369 = 0
                end
            end
            v357.span = vector.create(v363, v366, v369)
        end
        local v372 = {
            kind = "if",
            token = v345,
            first_branch = v346,
            branches = v347,
            else_branch = v357
        }
        local span = v345.span
        local span_2 = v346.span
        local v373 = if #v347 > 0 then v347[#v347].span else nil
        local v374 = v357 and v357.span
        local v375, v376
        if span then
            local x = span.x
            if x then
                v375 = x
                v376 = true
            elseif span_2 then
                local x = span_2.x
                if x then
                    v375 = x
                    v376 = true
                else
                    v376 = false
                end
            else
                v376 = false
            end
        elseif span_2 then
            local x = span_2.x
            if x then
                v375 = x
                v376 = true
            else
                v376 = false
            end
        else
            v376 = false
        end
        if not v376 then
            local v377
            if v373 then
                local x = v373.x
                if x then
                    v375 = x
                    v377 = true
                elseif v374 then
                    local x = v374.x
                    if x then
                        v375 = x
                        v377 = true
                    else
                        v377 = false
                    end
                else
                    v377 = false
                end
            elseif v374 then
                local x = v374.x
                if x then
                    v375 = x
                    v377 = true
                else
                    v377 = false
                end
            else
                v377 = false
            end
            if not v377 then
                v375 = 0
            end
        end
        local v378, v379
        if v374 then
            local y = v374.y
            if y then
                v378 = y
                v379 = true
            elseif v373 then
                local y = v373.y
                if y then
                    v378 = y
                    v379 = true
                else
                    v379 = false
                end
            else
                v379 = false
            end
        elseif v373 then
            local y = v373.y
            if y then
                v378 = y
                v379 = true
            else
                v379 = false
            end
        else
            v379 = false
        end
        if not v379 then
            local v380
            if span_2 then
                local y = span_2.y
                if y then
                    v378 = y
                    v380 = true
                elseif span then
                    local y = span.y
                    if y then
                        v378 = y
                        v380 = true
                    else
                        v380 = false
                    end
                else
                    v380 = false
                end
            elseif span then
                local y = span.y
                if y then
                    v378 = y
                    v380 = true
                else
                    v380 = false
                end
            else
                v380 = false
            end
            if not v380 then
                v378 = 0
            end
        end
        local v381, v382
        if span then
            local z = span.z
            if z then
                v381 = z
                v382 = true
            elseif span_2 then
                local z = span_2.z
                if z then
                    v381 = z
                    v382 = true
                else
                    v382 = false
                end
            else
                v382 = false
            end
        elseif span_2 then
            local z = span_2.z
            if z then
                v381 = z
                v382 = true
            else
                v382 = false
            end
        else
            v382 = false
        end
        if not v382 then
            local v383
            if v373 then
                local z = v373.z
                if z then
                    v381 = z
                    v383 = true
                elseif v374 then
                    local z = v374.z
                    if z then
                        v381 = z
                        v383 = true
                    else
                        v383 = false
                    end
                else
                    v383 = false
                end
            elseif v374 then
                local z = v374.z
                if z then
                    v381 = z
                    v383 = true
                else
                    v383 = false
                end
            else
                v383 = false
            end
            if not v383 then
                v381 = 0
            end
        end
        v372.span = vector.create(v375, v378, v381)
        return v372
    end

    function v218() -- line 784 | captures: v255, v216, v290, expect_fatal
        local v384 = expect_fatal("while")
        local v385 = v290("(", ")", v216)
        local v386 = v290("{", "}", v255)
        local v387 = {
            kind = "while",
            token = v384,
            condition = v385 or nil,
            block = v386 or nil
        }
        local v388 = v384 and v384.span
        local span, v389
        if v385 and v385.left then
            local span_2 = v385.left.span
            if span_2 then
                span = span_2
                v389 = true
            else
                v389 = false
            end
        else
            v389 = false
        end
        if not v389 then
            span = nil
        end
        local span_2, v390
        if v385 and v385.value then
            local span = v385.value.span
            if span then
                span_2 = span
                v390 = true
            else
                v390 = false
            end
        else
            v390 = false
        end
        if not v390 then
            span_2 = nil
        end
        local span_3, v391
        if v385 and v385.right then
            local span = v385.right.span
            if span then
                span_3 = span
                v391 = true
            else
                v391 = false
            end
        else
            v391 = false
        end
        if not v391 then
            span_3 = nil
        end
        local span_4, v392
        if v386 and v386.left then
            local span = v386.left.span
            if span then
                span_4 = span
                v392 = true
            else
                v392 = false
            end
        else
            v392 = false
        end
        if not v392 then
            span_4 = nil
        end
        local span_5, v393
        if v386 and v386.value then
            local span = v386.value.span
            if span then
                span_5 = span
                v393 = true
            else
                v393 = false
            end
        else
            v393 = false
        end
        if not v393 then
            span_5 = nil
        end
        local span_6, v394
        if v386 and v386.right then
            local span = v386.right.span
            if span then
                span_6 = span
                v394 = true
            else
                v394 = false
            end
        else
            v394 = false
        end
        if not v394 then
            span_6 = nil
        end
        local v395, v396
        if v388 then
            local x = v388.x
            if x then
                v395 = x
                v396 = true
            elseif span then
                local x = span.x
                if x then
                    v395 = x
                    v396 = true
                else
                    v396 = false
                end
            else
                v396 = false
            end
        elseif span then
            local x = span.x
            if x then
                v395 = x
                v396 = true
            else
                v396 = false
            end
        else
            v396 = false
        end
        if not v396 then
            local v397
            if span_2 then
                local x = span_2.x
                if x then
                    v395 = x
                    v397 = true
                elseif span_3 then
                    local x = span_3.x
                    if x then
                        v395 = x
                        v397 = true
                    else
                        v397 = false
                    end
                else
                    v397 = false
                end
            elseif span_3 then
                local x = span_3.x
                if x then
                    v395 = x
                    v397 = true
                else
                    v397 = false
                end
            else
                v397 = false
            end
            if not v397 then
                local v398
                if span_4 then
                    local x = span_4.x
                    if x then
                        v395 = x
                        v398 = true
                    elseif span_5 then
                        local x = span_5.x
                        if x then
                            v395 = x
                            v398 = true
                        else
                            v398 = false
                        end
                    else
                        v398 = false
                    end
                elseif span_5 then
                    local x = span_5.x
                    if x then
                        v395 = x
                        v398 = true
                    else
                        v398 = false
                    end
                else
                    v398 = false
                end
                if not v398 then
                    local x = if span_6 then span_6.x else nil
                    if not span_6 or not x then
                        v395 = 0
                    else
                        v395 = x
                    end
                end
            end
        end
        local v399, v400
        if span_6 then
            local y = span_6.y
            if y then
                v399 = y
                v400 = true
            elseif span_5 then
                local y = span_5.y
                if y then
                    v399 = y
                    v400 = true
                else
                    v400 = false
                end
            else
                v400 = false
            end
        elseif span_5 then
            local y = span_5.y
            if y then
                v399 = y
                v400 = true
            else
                v400 = false
            end
        else
            v400 = false
        end
        if not v400 then
            local v401
            if span_4 then
                local y = span_4.y
                if y then
                    v399 = y
                    v401 = true
                elseif span_3 then
                    local y = span_3.y
                    if y then
                        v399 = y
                        v401 = true
                    else
                        v401 = false
                    end
                else
                    v401 = false
                end
            elseif span_3 then
                local y = span_3.y
                if y then
                    v399 = y
                    v401 = true
                else
                    v401 = false
                end
            else
                v401 = false
            end
            if not v401 then
                local v402
                if span_2 then
                    local y = span_2.y
                    if y then
                        v399 = y
                        v402 = true
                    elseif span then
                        local y = span.y
                        if y then
                            v399 = y
                            v402 = true
                        else
                            v402 = false
                        end
                    else
                        v402 = false
                    end
                elseif span then
                    local y = span.y
                    if y then
                        v399 = y
                        v402 = true
                    else
                        v402 = false
                    end
                else
                    v402 = false
                end
                if not v402 then
                    local y = if v388 then v388.y else nil
                    if not v388 or not y then
                        v399 = 0
                    else
                        v399 = y
                    end
                end
            end
        end
        local v403, v404
        if v388 then
            local z = v388.z
            if z then
                v403 = z
                v404 = true
            elseif span then
                local z = span.z
                if z then
                    v403 = z
                    v404 = true
                else
                    v404 = false
                end
            else
                v404 = false
            end
        elseif span then
            local z = span.z
            if z then
                v403 = z
                v404 = true
            else
                v404 = false
            end
        else
            v404 = false
        end
        if not v404 then
            local v405
            if span_2 then
                local z = span_2.z
                if z then
                    v403 = z
                    v405 = true
                elseif span_3 then
                    local z = span_3.z
                    if z then
                        v403 = z
                        v405 = true
                    else
                        v405 = false
                    end
                else
                    v405 = false
                end
            elseif span_3 then
                local z = span_3.z
                if z then
                    v403 = z
                    v405 = true
                else
                    v405 = false
                end
            else
                v405 = false
            end
            if not v405 then
                local v406
                if span_4 then
                    local z = span_4.z
                    if z then
                        v403 = z
                        v406 = true
                    elseif span_5 then
                        local z = span_5.z
                        if z then
                            v403 = z
                            v406 = true
                        else
                            v406 = false
                        end
                    else
                        v406 = false
                    end
                elseif span_5 then
                    local z = span_5.z
                    if z then
                        v403 = z
                        v406 = true
                    else
                        v406 = false
                    end
                else
                    v406 = false
                end
                if not v406 then
                    local z = if span_6 then span_6.z else nil
                    if not span_6 or not z then
                        v403 = 0
                    else
                        v403 = z
                    end
                end
            end
        end
        v387.span = vector.create(v395, v399, v403)
        return v387
    end

    function v220() -- line 806 | captures: v216, expect_fatal
        local identifier = expect_fatal("identifier")
        local v407 = expect_fatal("=")
        local v408 = v216()
        local v409 = {
            kind = "assign",
            identifier = identifier,
            equals = v407,
            value = v408 or nil
        }
        local v410 = identifier and identifier.span
        local v411 = v407 and v407.span
        local v412 = v408 and v408.span
        local v413, v414
        if v410 then
            local x = v410.x
            if x then
                v413 = x
                v414 = true
            elseif v411 then
                local x = v411.x
                if x then
                    v413 = x
                    v414 = true
                else
                    v414 = false
                end
            else
                v414 = false
            end
        elseif v411 then
            local x = v411.x
            if x then
                v413 = x
                v414 = true
            else
                v414 = false
            end
        else
            v414 = false
        end
        if not v414 then
            local x = if v412 then v412.x else nil
            if not v412 or not x then
                v413 = 0
            else
                v413 = x
            end
        end
        local v415, v416
        if v412 then
            local y = v412.y
            if y then
                v415 = y
                v416 = true
            elseif v411 then
                local y = v411.y
                if y then
                    v415 = y
                    v416 = true
                else
                    v416 = false
                end
            else
                v416 = false
            end
        elseif v411 then
            local y = v411.y
            if y then
                v415 = y
                v416 = true
            else
                v416 = false
            end
        else
            v416 = false
        end
        if not v416 then
            local y = if v410 then v410.y else nil
            if not v410 or not y then
                v415 = 0
            else
                v415 = y
            end
        end
        local v417, v418
        if v410 then
            local z = v410.z
            if z then
                v417 = z
                v418 = true
            elseif v411 then
                local z = v411.z
                if z then
                    v417 = z
                    v418 = true
                else
                    v418 = false
                end
            else
                v418 = false
            end
        elseif v411 then
            local z = v411.z
            if z then
                v417 = z
                v418 = true
            else
                v418 = false
            end
        else
            v418 = false
        end
        if not v418 then
            local z = if v412 then v412.z else nil
            if not v412 or not z then
                v417 = 0
            else
                v417 = z
            end
        end
        v409.span = vector.create(v413, v415, v417)
        return v409
    end

    function v219() -- line 824 | captures: v216, v290, expect_fatal
        local v419 = expect_fatal("for")
        local v420 = v290("(", ")", v216)
        local v421 = v216()
        local v422 = {
            kind = "for",
            token = v419,
            expression = v420 or nil,
            body = v421
        }
        local span = v419.span
        local span_2, v423
        if v420 and v420.left then
            local span = v420.left.span
            if span then
                span_2 = span
                v423 = true
            else
                v423 = false
            end
        else
            v423 = false
        end
        if not v423 then
            span_2 = nil
        end
        local span_3, v424
        if v420 and v420.value then
            local span = v420.value.span
            if span then
                span_3 = span
                v424 = true
            else
                v424 = false
            end
        else
            v424 = false
        end
        if not v424 then
            span_3 = nil
        end
        local span_4, v425
        if v420 and v420.right then
            local span = v420.right.span
            if span then
                span_4 = span
                v425 = true
            else
                v425 = false
            end
        else
            v425 = false
        end
        if not v425 then
            span_4 = nil
        end
        local span_5 = v421 and v421.span or nil
        local v426, v427
        if span then
            local x = span.x
            if x then
                v426 = x
                v427 = true
            elseif span_2 then
                local x = span_2.x
                if x then
                    v426 = x
                    v427 = true
                else
                    v427 = false
                end
            else
                v427 = false
            end
        elseif span_2 then
            local x = span_2.x
            if x then
                v426 = x
                v427 = true
            else
                v427 = false
            end
        else
            v427 = false
        end
        if not v427 then
            local v428
            if span_3 then
                local x = span_3.x
                if x then
                    v426 = x
                    v428 = true
                elseif span_4 then
                    local x = span_4.x
                    if x then
                        v426 = x
                        v428 = true
                    else
                        v428 = false
                    end
                else
                    v428 = false
                end
            elseif span_4 then
                local x = span_4.x
                if x then
                    v426 = x
                    v428 = true
                else
                    v428 = false
                end
            else
                v428 = false
            end
            if not v428 then
                local x = if span_5 then span_5.x else nil
                if not span_5 or not x then
                    v426 = 0
                else
                    v426 = x
                end
            end
        end
        local v429, v430
        if span_5 then
            local y = span_5.y
            if y then
                v429 = y
                v430 = true
            elseif span_4 then
                local y = span_4.y
                if y then
                    v429 = y
                    v430 = true
                else
                    v430 = false
                end
            else
                v430 = false
            end
        elseif span_4 then
            local y = span_4.y
            if y then
                v429 = y
                v430 = true
            else
                v430 = false
            end
        else
            v430 = false
        end
        if not v430 then
            local v431
            if span_3 then
                local y = span_3.y
                if y then
                    v429 = y
                    v431 = true
                elseif span_2 then
                    local y = span_2.y
                    if y then
                        v429 = y
                        v431 = true
                    else
                        v431 = false
                    end
                else
                    v431 = false
                end
            elseif span_2 then
                local y = span_2.y
                if y then
                    v429 = y
                    v431 = true
                else
                    v431 = false
                end
            else
                v431 = false
            end
            if not v431 then
                local y = if span then span.y else nil
                if not span or not y then
                    v429 = 0
                else
                    v429 = y
                end
            end
        end
        local v432, v433
        if span then
            local z = span.z
            if z then
                v432 = z
                v433 = true
            elseif span_2 then
                local z = span_2.z
                if z then
                    v432 = z
                    v433 = true
                else
                    v433 = false
                end
            else
                v433 = false
            end
        elseif span_2 then
            local z = span_2.z
            if z then
                v432 = z
                v433 = true
            else
                v433 = false
            end
        else
            v433 = false
        end
        if not v433 then
            local v434
            if span_3 then
                local z = span_3.z
                if z then
                    v432 = z
                    v434 = true
                elseif span_4 then
                    local z = span_4.z
                    if z then
                        v432 = z
                        v434 = true
                    else
                        v434 = false
                    end
                else
                    v434 = false
                end
            elseif span_4 then
                local z = span_4.z
                if z then
                    v432 = z
                    v434 = true
                else
                    v434 = false
                end
            else
                v434 = false
            end
            if not v434 then
                local z = if span_5 then span_5.z else nil
                if not span_5 or not z then
                    v432 = 0
                else
                    v432 = z
                end
            end
        end
        v422.span = vector.create(v426, v429, v432)
        return v422
    end

    function v221() -- line 844 | captures: v173, kind, x, v175, kind_2, x_2, v214, v223, next_token, expect_fatal
        local function v435(v436, ...)
            table.insert(v436, ...)
        end

        local v437 = v223()
        local v438 = {}
        while true do
            if kind == "\n" then
                break
            end
            while kind == "\n" do
                local v439 = v175
                local kind_3 = kind_2
                v173 = v439
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "if" then
                break
            end
            while kind == "\n" do
                local v440 = v175
                local kind_3 = kind_2
                v173 = v440
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "else" then
                break
            end
            while kind == "\n" do
                local v441 = v175
                local kind_3 = kind_2
                v173 = v441
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "elseif" then
                break
            end
            while kind == "\n" do
                local v442 = v175
                local kind_3 = kind_2
                v173 = v442
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "while" then
                break
            end
            while kind == "\n" do
                local v443 = v175
                local kind_3 = kind_2
                v173 = v443
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "for" then
                break
            end
            while kind == "\n" do
                local v444 = v175
                local kind_3 = kind_2
                v173 = v444
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "return" then
                break
            end
            while kind == "\n" do
                local v445 = v175
                local kind_3 = kind_2
                v173 = v445
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "break" then
                break
            end
            while kind == "\n" do
                local v446 = v175
                local kind_3 = kind_2
                v173 = v446
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "continue" then
                break
            end
            while kind == "\n" do
                local v447 = v175
                local kind_3 = kind_2
                v173 = v447
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "}" or kind == "]" or kind == ")" or kind == ";" or kind == "\n" or kind == "eof" then
                break
            end
            while kind == "\n" do
                local v448 = v175
                local kind_3 = kind_2
                v173 = v448
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind == "," then
                break
            end
            while kind == "\n" do
                local v449 = v175
                local kind_3 = kind_2
                v173 = v449
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind ~= "identifier" or kind_2 == "." then
                v435(v438, v214())
            else
                local identifier = expect_fatal("identifier")
                local v450 = {
                    kind = "string",
                    token = identifier,
                    span = identifier.span
                }
                table.insert(v438, v450)
            end
        end
        local v451 = {
            kind = "command",
            var = v437,
            arguments = v438
        }
        local span = v437.span
        local v452 = if #v438 > 0 then v438[#v438].span else nil
        while kind == "\n" do
            local v453 = v175
            local kind_3 = kind_2
            v173 = v453
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        local span_2
        if kind == "eof" then
            local v454 = v173
            local v455 = v175
            local kind_3 = kind_2
            v173 = v455
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
            span_2 = v454.span
        end
        local v456, v457
        if span then
            local x = span.x
            if x then
                v456 = x
                v457 = true
            elseif v452 then
                local x = v452.x
                if x then
                    v456 = x
                    v457 = true
                else
                    v457 = false
                end
            else
                v457 = false
            end
        elseif v452 then
            local x = v452.x
            if x then
                v456 = x
                v457 = true
            else
                v457 = false
            end
        else
            v457 = false
        end
        if not v457 then
            local x = if span_2 then span_2.x else nil
            if not span_2 or not x then
                v456 = 0
            else
                v456 = x
            end
        end
        local v458, v459
        if span_2 then
            local y = span_2.y
            if y then
                v458 = y
                v459 = true
            elseif v452 then
                local y = v452.y
                if y then
                    v458 = y
                    v459 = true
                else
                    v459 = false
                end
            else
                v459 = false
            end
        elseif v452 then
            local y = v452.y
            if y then
                v458 = y
                v459 = true
            else
                v459 = false
            end
        else
            v459 = false
        end
        if not v459 then
            local y = if span then span.y else nil
            if not span or not y then
                v458 = 0
            else
                v458 = y
            end
        end
        local v460, v461
        if span then
            local z = span.z
            if z then
                v460 = z
                v461 = true
            elseif v452 then
                local z = v452.z
                if z then
                    v460 = z
                    v461 = true
                else
                    v461 = false
                end
            else
                v461 = false
            end
        elseif v452 then
            local z = v452.z
            if z then
                v460 = z
                v461 = true
            else
                v461 = false
            end
        else
            v461 = false
        end
        if not v461 then
            local z = if span_2 then span_2.z else nil
            if not span_2 or not z then
                v460 = 0
            else
                v460 = z
            end
        end
        v451.span = vector.create(v456, v458, v460)
        return v451
    end

    local function parse_tablefield_nokey() -- line 886 | captures: v216
        local v462 = v216()
        local v463 = {
            kind = "nokey",
            value = v462
        }
        v463.span = v462 and v462.span or vector.create(0, 0, 0)
        return v463
    end

    local function parse_tablefield_namekey() -- line 895 | captures: v216, expect_fatal
        local identifier = expect_fatal("identifier")
        local v464 = expect_fatal("=")
        local v465 = v216()
        local v466 = {
            kind = "name_key",
            name = identifier,
            equals = v464,
            value = v465
        }
        local span = identifier.span
        local span_2 = v464.span
        local v467 = v465 and v465.span
        local v468, v469
        if span then
            local x = span.x
            if x then
                v468 = x
                v469 = true
            elseif span_2 then
                local x = span_2.x
                if x then
                    v468 = x
                    v469 = true
                else
                    v469 = false
                end
            else
                v469 = false
            end
        elseif span_2 then
            local x = span_2.x
            if x then
                v468 = x
                v469 = true
            else
                v469 = false
            end
        else
            v469 = false
        end
        if not v469 then
            local x = if v467 then v467.x else nil
            if not v467 or not x then
                v468 = 0
            else
                v468 = x
            end
        end
        local v470, v471
        if v467 then
            local y = v467.y
            if y then
                v470 = y
                v471 = true
            elseif span_2 then
                local y = span_2.y
                if y then
                    v470 = y
                    v471 = true
                else
                    v471 = false
                end
            else
                v471 = false
            end
        elseif span_2 then
            local y = span_2.y
            if y then
                v470 = y
                v471 = true
            else
                v471 = false
            end
        else
            v471 = false
        end
        if not v471 then
            local y = if span then span.y else nil
            if not span or not y then
                v470 = 0
            else
                v470 = y
            end
        end
        local v472, v473
        if span then
            local z = span.z
            if z then
                v472 = z
                v473 = true
            elseif span_2 then
                local z = span_2.z
                if z then
                    v472 = z
                    v473 = true
                else
                    v473 = false
                end
            else
                v473 = false
            end
        elseif span_2 then
            local z = span_2.z
            if z then
                v472 = z
                v473 = true
            else
                v473 = false
            end
        else
            v473 = false
        end
        if not v473 then
            local z = if v467 then v467.z else nil
            if not v467 or not z then
                v472 = 0
            else
                v472 = z
            end
        end
        v466.span = vector.create(v468, v470, v472)
        return v466
    end

    local function parse_tablefield_expressionkey() -- line 909 | captures: v173, kind, x, v175, kind_2, x_2, v216, v29, next_token, expect_fatal
        local v474 = expect_fatal("[")
        local v475 = v216()
        while kind == "\n" do
            local v476 = v175
            local kind_3 = kind_2
            v173 = v476
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        local v477 = kind == "]"
        local v478
        if v477 then
            while kind_2 == "\n" do
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            v478 = kind_2 == "="
        end
        if not v477 or not v478 then
            local v479 = expect_fatal(",")
            local v480 = {}
            local v481 = {
                value = v475,
                separator = v479
            }
            local v482 = v475 and v475.span
            local span = v479.span
            local v483, v484
            if v482 then
                local x = v482.x
                if x then
                    v483 = x
                    v484 = true
                elseif span then
                    local x = span.x
                    if x then
                        v483 = x
                        v484 = true
                    else
                        v484 = false
                    end
                else
                    v484 = false
                end
            elseif span then
                local x = span.x
                if x then
                    v483 = x
                    v484 = true
                else
                    v484 = false
                end
            else
                v484 = false
            end
            if not v484 then
                v483 = 0
            end
            local v485, v486
            if span then
                local y = span.y
                if y then
                    v485 = y
                    v486 = true
                elseif v482 then
                    local y = v482.y
                    if y then
                        v485 = y
                        v486 = true
                    else
                        v486 = false
                    end
                else
                    v486 = false
                end
            elseif v482 then
                local y = v482.y
                if y then
                    v485 = y
                    v486 = true
                else
                    v486 = false
                end
            else
                v486 = false
            end
            if not v486 then
                v485 = 0
            end
            local v487, v488
            if v482 then
                local z = v482.z
                if z then
                    v487 = z
                    v488 = true
                elseif span then
                    local z = span.z
                    if z then
                        v487 = z
                        v488 = true
                    else
                        v488 = false
                    end
                else
                    v488 = false
                end
            elseif span then
                local z = span.z
                if z then
                    v487 = z
                    v488 = true
                else
                    v488 = false
                end
            else
                v488 = false
            end
            if not v488 then
                v487 = 0
            end
            v481.span = vector.create(v483, v485, v487)
            v480[1] = v481
            while true do
                if kind == "\n" then
                    local v489 = v175
                    local kind_3 = kind_2
                    v173 = v489
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                    continue
                end
                if not (kind == "}" or kind == "]" or kind == ")" or kind == ";" or kind == "\n" or kind == "eof") then
                    while kind == "\n" do
                        local v490 = v175
                        local kind_3 = kind_2
                        v173 = v490
                        kind = kind_3
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                    end
                    local x_3 = x
                    local v491 = v216()
                    while kind == "\n" do
                        local v492 = v175
                        local kind_3 = kind_2
                        v173 = v492
                        kind = kind_3
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                    end
                    if kind == "," then
                        local v493 = expect_fatal(",")
                        local v494 = {
                            value = v491,
                            separator = v493
                        }
                        local y = v493.span.y
                        v494.span = vector.create(x_3, y)
                        table.insert(v480, v494)
                        continue
                    end
                end
                break
            end
            while kind == "\n" do
                local v495 = v175
                local kind_3 = kind_2
                v173 = v495
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            local v496
            if kind == "]" then
                v496 = v173
                local v497 = v175
                local kind_3 = kind_2
                v173 = v497
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            else
                local v498 = "expected ], but got %* of %* instead"
                local v499 = v173
                local kind_3 = v499.kind
                local text
                if kind_3 == "identifier" or kind_3 == "number" or kind_3 == "string" then
                    text = v499.text
                elseif v499.kind == "error" then
                    text = "error '" .. v499.text .. "'"
                else
                    text = "'" .. kind_3 .. "'"
                end
                local v500 = v498:format(text, kind)
                local span = v173.span
                local v501 = {
                    why = ("SyntaxError: %*"):format(v500),
                    span = span
                }
                table.insert(v29, v501)
                local v502 = v175
                local kind_4 = kind_2
                v173 = v502
                kind = kind_4
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
                v496 = false
            end
            local v503 = {
                kind = "vector",
                contents = {
                    left = v474,
                    right = v496 or nil,
                    value = v480
                }
            }
            local span_2 = v474.span
            local span_3 = v475 and v475.span or nil
            local span_4 = v480[#v480] and v480[#v480].span or nil
            local span_5 = v496 and v496.span or nil
            local v504, v505
            if span_2 then
                local x = span_2.x
                if x then
                    v504 = x
                    v505 = true
                elseif span_3 then
                    local x = span_3.x
                    if x then
                        v504 = x
                        v505 = true
                    else
                        v505 = false
                    end
                else
                    v505 = false
                end
            elseif span_3 then
                local x = span_3.x
                if x then
                    v504 = x
                    v505 = true
                else
                    v505 = false
                end
            else
                v505 = false
            end
            if not v505 then
                local v506
                if span_4 then
                    local x = span_4.x
                    if x then
                        v504 = x
                        v506 = true
                    elseif span_5 then
                        local x = span_5.x
                        if x then
                            v504 = x
                            v506 = true
                        else
                            v506 = false
                        end
                    else
                        v506 = false
                    end
                elseif span_5 then
                    local x = span_5.x
                    if x then
                        v504 = x
                        v506 = true
                    else
                        v506 = false
                    end
                else
                    v506 = false
                end
                if not v506 then
                    v504 = 0
                end
            end
            local v507, v508
            if span_5 then
                local y = span_5.y
                if y then
                    v507 = y
                    v508 = true
                elseif span_4 then
                    local y = span_4.y
                    if y then
                        v507 = y
                        v508 = true
                    else
                        v508 = false
                    end
                else
                    v508 = false
                end
            elseif span_4 then
                local y = span_4.y
                if y then
                    v507 = y
                    v508 = true
                else
                    v508 = false
                end
            else
                v508 = false
            end
            if not v508 then
                local v509
                if span_3 then
                    local y = span_3.y
                    if y then
                        v507 = y
                        v509 = true
                    elseif span_2 then
                        local y = span_2.y
                        if y then
                            v507 = y
                            v509 = true
                        else
                            v509 = false
                        end
                    else
                        v509 = false
                    end
                elseif span_2 then
                    local y = span_2.y
                    if y then
                        v507 = y
                        v509 = true
                    else
                        v509 = false
                    end
                else
                    v509 = false
                end
                if not v509 then
                    v507 = 0
                end
            end
            local v510, v511
            if span_2 then
                local z = span_2.z
                if z then
                    v510 = z
                    v511 = true
                elseif span_3 then
                    local z = span_3.z
                    if z then
                        v510 = z
                        v511 = true
                    else
                        v511 = false
                    end
                else
                    v511 = false
                end
            elseif span_3 then
                local z = span_3.z
                if z then
                    v510 = z
                    v511 = true
                else
                    v511 = false
                end
            else
                v511 = false
            end
            if not v511 then
                local v512
                if span_4 then
                    local z = span_4.z
                    if z then
                        v510 = z
                        v512 = true
                    elseif span_5 then
                        local z = span_5.z
                        if z then
                            v510 = z
                            v512 = true
                        else
                            v512 = false
                        end
                    else
                        v512 = false
                    end
                elseif span_5 then
                    local z = span_5.z
                    if z then
                        v510 = z
                        v512 = true
                    else
                        v512 = false
                    end
                else
                    v512 = false
                end
                if not v512 then
                    v510 = 0
                end
            end
            v503.span = vector.create(v504, v507, v510)
            return {
                kind = "nokey",
                value = v503,
                span = v503.span
            }
        end
        local v513 = {
            left = v474,
            value = v475,
            right = expect_fatal("]")
        }
        while kind == "\n" do
            local v514 = v175
            local kind_3 = kind_2
            v173 = v514
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        local v515
        if kind == "=" then
            v515 = v173
            local v516 = v175
            local kind_3 = kind_2
            v173 = v516
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        else
            local v517 = "expected =, but got %* of %* instead"
            local v518 = v173
            local kind_3 = v518.kind
            local text
            if kind_3 == "identifier" or kind_3 == "number" or kind_3 == "string" then
                text = v518.text
            elseif v518.kind == "error" then
                text = "error '" .. v518.text .. "'"
            else
                text = "'" .. kind_3 .. "'"
            end
            local v519 = v517:format(text, kind)
            local span = v173.span
            local v520 = {
                why = ("SyntaxError: %*"):format(v519),
                span = span
            }
            table.insert(v29, v520)
            local v521 = v175
            local kind_4 = kind_2
            v173 = v521
            kind = kind_4
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
            v515 = false
        end
        local v522 = v216()
        local v523 = {
            kind = "expression_key",
            key = v513 or nil,
            equals = v515 or nil,
            value = v522
        }
        local span, v524
        if v513 and v513.left then
            local span_2 = v513.left.span
            if span_2 then
                span = span_2
                v524 = true
            else
                v524 = false
            end
        else
            v524 = false
        end
        if not v524 then
            span = nil
        end
        local span_2, v525
        if v513 and v513.value then
            local span = v513.value.span
            if span then
                span_2 = span
                v525 = true
            else
                v525 = false
            end
        else
            v525 = false
        end
        if not v525 then
            span_2 = nil
        end
        local span_3, v526
        if v513 and v513.right then
            local span = v513.right.span
            if span then
                span_3 = span
                v526 = true
            else
                v526 = false
            end
        else
            v526 = false
        end
        if not v526 then
            span_3 = nil
        end
        local span_4 = v515 and v515.span or nil
        local v527 = v522 and v522.span
        local v528, v529
        if span then
            local x = span.x
            if x then
                v528 = x
                v529 = true
            elseif span_2 then
                local x = span_2.x
                if x then
                    v528 = x
                    v529 = true
                else
                    v529 = false
                end
            else
                v529 = false
            end
        elseif span_2 then
            local x = span_2.x
            if x then
                v528 = x
                v529 = true
            else
                v529 = false
            end
        else
            v529 = false
        end
        if not v529 then
            local v530
            if span_3 then
                local x = span_3.x
                if x then
                    v528 = x
                    v530 = true
                elseif span_4 then
                    local x = span_4.x
                    if x then
                        v528 = x
                        v530 = true
                    else
                        v530 = false
                    end
                else
                    v530 = false
                end
            elseif span_4 then
                local x = span_4.x
                if x then
                    v528 = x
                    v530 = true
                else
                    v530 = false
                end
            else
                v530 = false
            end
            if not v530 then
                local x = if v527 then v527.x else nil
                if not v527 or not x then
                    v528 = 0
                else
                    v528 = x
                end
            end
        end
        local v531, v532
        if v527 then
            local y = v527.y
            if y then
                v531 = y
                v532 = true
            elseif span_4 then
                local y = span_4.y
                if y then
                    v531 = y
                    v532 = true
                else
                    v532 = false
                end
            else
                v532 = false
            end
        elseif span_4 then
            local y = span_4.y
            if y then
                v531 = y
                v532 = true
            else
                v532 = false
            end
        else
            v532 = false
        end
        if not v532 then
            local v533
            if span_3 then
                local y = span_3.y
                if y then
                    v531 = y
                    v533 = true
                elseif span_2 then
                    local y = span_2.y
                    if y then
                        v531 = y
                        v533 = true
                    else
                        v533 = false
                    end
                else
                    v533 = false
                end
            elseif span_2 then
                local y = span_2.y
                if y then
                    v531 = y
                    v533 = true
                else
                    v533 = false
                end
            else
                v533 = false
            end
            if not v533 then
                local y = if span then span.y else nil
                if not span or not y then
                    v531 = 0
                else
                    v531 = y
                end
            end
        end
        local v534, v535
        if span then
            local z = span.z
            if z then
                v534 = z
                v535 = true
            elseif span_2 then
                local z = span_2.z
                if z then
                    v534 = z
                    v535 = true
                else
                    v535 = false
                end
            else
                v535 = false
            end
        elseif span_2 then
            local z = span_2.z
            if z then
                v534 = z
                v535 = true
            else
                v535 = false
            end
        else
            v535 = false
        end
        if not v535 then
            local v536
            if span_3 then
                local z = span_3.z
                if z then
                    v534 = z
                    v536 = true
                elseif span_4 then
                    local z = span_4.z
                    if z then
                        v534 = z
                        v536 = true
                    else
                        v536 = false
                    end
                else
                    v536 = false
                end
            elseif span_4 then
                local z = span_4.z
                if z then
                    v534 = z
                    v536 = true
                else
                    v536 = false
                end
            else
                v536 = false
            end
            if not v536 then
                local z = if v527 then v527.z else nil
                if not v527 or not z then
                    v534 = 0
                else
                    v534 = z
                end
            end
        end
        v523.span = vector.create(v528, v531, v534)
        return v523
    end

    local function parse_tablefield() -- line 993 | captures: v173, kind, x, v175, kind_2, x_2, v216, next_token, parse_tablefield_namekey, parse_tablefield_expressionkey
        while kind == "\n" do
            local v537 = v175
            local kind_3 = kind_2
            v173 = v537
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "identifier" then
            while kind_2 == "\n" do
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind_2 == "=" then
                return (parse_tablefield_namekey())
            end
        end
        while kind == "\n" do
            local v538 = v175
            local kind_3 = kind_2
            v173 = v538
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "[" then
            return (parse_tablefield_expressionkey())
        end
        local v539 = v216()
        local v540 = {
            kind = "nokey",
            value = v539
        }
        v540.span = v539 and v539.span or vector.create(0, 0, 0)
        return v540
    end

    local function v541() -- line 1003 | captures: v290, panic, separated, parse_tablefield
        local v542 = v290("{", "}", function() -- line 1007 | captures: separated, parse_tablefield
            return (separated(parse_tablefield))
        end)
        if v542 then
            local v543 = {
                kind = "table",
                values = v542
            }
            local v544 = v542.left and v542.left.span
            local value = v542.value and v542.value[1] and v542.value[1].span
            local value_2 = v542.value and v542.value[#v542.value] and v542.value[#v542.value].span
            local v545 = v542.right and v542.right.span
            local v546, v547
            if v544 then
                local x = v544.x
                if x then
                    v546 = x
                    v547 = true
                elseif value then
                    local x = value.x
                    if x then
                        v546 = x
                        v547 = true
                    else
                        v547 = false
                    end
                else
                    v547 = false
                end
            elseif value then
                local x = value.x
                if x then
                    v546 = x
                    v547 = true
                else
                    v547 = false
                end
            else
                v547 = false
            end
            if not v547 then
                local v548
                if value_2 then
                    local x = value_2.x
                    if x then
                        v546 = x
                        v548 = true
                    elseif v545 then
                        local x = v545.x
                        if x then
                            v546 = x
                            v548 = true
                        else
                            v548 = false
                        end
                    else
                        v548 = false
                    end
                elseif v545 then
                    local x = v545.x
                    if x then
                        v546 = x
                        v548 = true
                    else
                        v548 = false
                    end
                else
                    v548 = false
                end
                if not v548 then
                    v546 = 0
                end
            end
            local v549, v550
            if v545 then
                local y = v545.y
                if y then
                    v549 = y
                    v550 = true
                elseif value_2 then
                    local y = value_2.y
                    if y then
                        v549 = y
                        v550 = true
                    else
                        v550 = false
                    end
                else
                    v550 = false
                end
            elseif value_2 then
                local y = value_2.y
                if y then
                    v549 = y
                    v550 = true
                else
                    v550 = false
                end
            else
                v550 = false
            end
            if not v550 then
                local v551
                if value then
                    local y = value.y
                    if y then
                        v549 = y
                        v551 = true
                    elseif v544 then
                        local y = v544.y
                        if y then
                            v549 = y
                            v551 = true
                        else
                            v551 = false
                        end
                    else
                        v551 = false
                    end
                elseif v544 then
                    local y = v544.y
                    if y then
                        v549 = y
                        v551 = true
                    else
                        v551 = false
                    end
                else
                    v551 = false
                end
                if not v551 then
                    v549 = 0
                end
            end
            local v552, v553
            if v544 then
                local z = v544.z
                if z then
                    v552 = z
                    v553 = true
                elseif value then
                    local z = value.z
                    if z then
                        v552 = z
                        v553 = true
                    else
                        v553 = false
                    end
                else
                    v553 = false
                end
            elseif value then
                local z = value.z
                if z then
                    v552 = z
                    v553 = true
                else
                    v553 = false
                end
            else
                v553 = false
            end
            if not v553 then
                local v554
                if value_2 then
                    local z = value_2.z
                    if z then
                        v552 = z
                        v554 = true
                    elseif v545 then
                        local z = v545.z
                        if z then
                            v552 = z
                            v554 = true
                        else
                            v554 = false
                        end
                    else
                        v554 = false
                    end
                elseif v545 then
                    local z = v545.z
                    if z then
                        v552 = z
                        v554 = true
                    else
                        v554 = false
                    end
                else
                    v554 = false
                end
                if not v554 then
                    v552 = 0
                end
            end
            v543.span = vector.create(v546, v549, v552)
            return v543
        end
        return panic("no table")
    end

    local function parse_unary_operator() -- line 1028 | captures: v173, kind, x, v175, kind_2, x_2, next_token
        if kind == "-" or kind == "!" then
            local v555 = v173
            local v556 = v175
            local kind_3 = kind_2
            v173 = v556
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
            return v555
        end
        return nil
    end

    local function current_binary_operator() -- line 1036 | captures: v173, kind
        if kind ~= "+" and kind ~= "-" and kind ~= "*" and kind ~= "/" and kind ~= "//" and kind ~= "%" and kind ~= "^" and kind ~= ".." and kind ~= "<" and kind ~= "<=" and kind ~= ">" and kind ~= ">=" and kind ~= "==" and kind ~= "~=" and kind ~= "!=" and kind ~= "and" and kind ~= "or" then
            return nil
        end
        return v173
    end

    local function binary_operator_priority(v557) -- line 1062 | captures: panic
        local kind = v557.kind
        if kind == "+" or kind == "-" then
            return 6, 6
        end
        if kind ~= "*" and kind ~= "/" and kind ~= "//" and kind ~= "%" then
            if kind == "^" then
                return 10, 9
            end
            if kind == ".." then
                return 5, 4
            end
            if kind ~= "==" and kind ~= "~=" and kind ~= "!=" then
                if kind ~= "<" and kind ~= "<=" and kind ~= ">" and kind ~= ">=" then
                    if kind == "and" then
                        return 2, 2
                    end
                    if kind == "or" then
                        return 1, 1
                    end
                    return panic(kind), 0
                end
                return 3, 3
            end
            return 3, 3
        end
        return 7, 7
    end

    function v214() -- line 1100 | captures: v173, kind, x, v175, kind_2, x_2, v215, v216, v290, v541, v222, v223, v224, v29, next_token, expect_fatal, current_binary_operator
        local v558
        if kind == "-" or kind == "!" then
            v558 = v173
            local v559 = v175
            local kind_3 = kind_2
            v173 = v559
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if v558 then
            local v560 = v215(8)
            local v561 = {
                kind = "unary",
                operator = v558,
                value = v560
            }
            local span = v558.span
            local v562 = v560 and v560.span
            local v563, v564
            if span then
                local x = span.x
                if x then
                    v563 = x
                    v564 = true
                elseif v562 then
                    local x = v562.x
                    if x then
                        v563 = x
                        v564 = true
                    else
                        v564 = false
                    end
                else
                    v564 = false
                end
            elseif v562 then
                local x = v562.x
                if x then
                    v563 = x
                    v564 = true
                else
                    v564 = false
                end
            else
                v564 = false
            end
            if not v564 then
                v563 = 0
            end
            local v565, v566
            if v562 then
                local y = v562.y
                if y then
                    v565 = y
                    v566 = true
                elseif span then
                    local y = span.y
                    if y then
                        v565 = y
                        v566 = true
                    else
                        v566 = false
                    end
                else
                    v566 = false
                end
            elseif span then
                local y = span.y
                if y then
                    v565 = y
                    v566 = true
                else
                    v566 = false
                end
            else
                v566 = false
            end
            if not v566 then
                v565 = 0
            end
            local v567, v568
            if span then
                local z = span.z
                if z then
                    v567 = z
                    v568 = true
                elseif v562 then
                    local z = v562.z
                    if z then
                        v567 = z
                        v568 = true
                    else
                        v568 = false
                    end
                else
                    v568 = false
                end
            elseif v562 then
                local z = v562.z
                if z then
                    v567 = z
                    v568 = true
                else
                    v568 = false
                end
            else
                v568 = false
            end
            if not v568 then
                v567 = 0
            end
            v561.span = vector.create(v563, v565, v567)
            return v561
        end
        while kind == "\n" do
            local v569 = v175
            local kind_3 = kind_2
            v173 = v569
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "error" then
            return expect_fatal("error")
        end
        while kind == "\n" do
            local v570 = v175
            local kind_3 = kind_2
            v173 = v570
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "(" then
            local v571 = v290("(", ")", v216)
            assert(v571)
            local v572 = {
                kind = "evaluate",
                command = v571
            }
            local v573, v574
            if v571 then
                v573 = v571.left and v571.left.span
                v574 = v571.value and v571.value.span
                v571 = v571.right and v571.right.span
            else
                v573 = v571
                v574 = v571
            end
            local v575, v576
            if v573 then
                local x = v573.x
                if x then
                    v575 = x
                    v576 = true
                elseif v574 then
                    local x = v574.x
                    if x then
                        v575 = x
                        v576 = true
                    else
                        v576 = false
                    end
                else
                    v576 = false
                end
            elseif v574 then
                local x = v574.x
                if x then
                    v575 = x
                    v576 = true
                else
                    v576 = false
                end
            else
                v576 = false
            end
            if not v576 then
                local x = if v571 then v571.x else nil
                if not v571 or not x then
                    v575 = 0
                else
                    v575 = x
                end
            end
            local v577, v578
            if v571 then
                local y = v571.y
                if y then
                    v577 = y
                    v578 = true
                elseif v574 then
                    local y = v574.y
                    if y then
                        v577 = y
                        v578 = true
                    else
                        v578 = false
                    end
                else
                    v578 = false
                end
            elseif v574 then
                local y = v574.y
                if y then
                    v577 = y
                    v578 = true
                else
                    v578 = false
                end
            else
                v578 = false
            end
            if not v578 then
                local y = if v573 then v573.y else nil
                if not v573 or not y then
                    v577 = 0
                else
                    v577 = y
                end
            end
            local v579, v580
            if v573 then
                local z = v573.z
                if z then
                    v579 = z
                    v580 = true
                elseif v574 then
                    local z = v574.z
                    if z then
                        v579 = z
                        v580 = true
                    else
                        v580 = false
                    end
                else
                    v580 = false
                end
            elseif v574 then
                local z = v574.z
                if z then
                    v579 = z
                    v580 = true
                else
                    v580 = false
                end
            else
                v580 = false
            end
            if not v580 then
                local z = if v571 then v571.z else nil
                if not v571 or not z then
                    v579 = 0
                else
                    v579 = z
                end
            end
            v572.span = vector.create(v575, v577, v579)
            return v572
        end
        while kind == "\n" do
            local v581 = v175
            local kind_3 = kind_2
            v173 = v581
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "nil" then
            local v582 = expect_fatal("nil")
            return {
                kind = "nil",
                token = v582,
                span = v582.span
            }
        end
        while kind == "\n" do
            local v583 = v175
            local kind_3 = kind_2
            v173 = v583
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind ~= "false" then
            while kind == "\n" do
                local v584 = v175
                local kind_3 = kind_2
                v173 = v584
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind ~= "true" then
                while kind == "\n" do
                    local v585 = v175
                    local kind_3 = kind_2
                    v173 = v585
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                if kind == "number" then
                    local number = expect_fatal("number")
                    return {
                        kind = "number",
                        token = number,
                        span = number.span
                    }
                end
                while kind == "\n" do
                    local v586 = v175
                    local kind_3 = kind_2
                    v173 = v586
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                if kind == "string" then
                    local string = expect_fatal("string")
                    return {
                        kind = "string",
                        token = string,
                        span = string.span
                    }
                end
                while kind == "\n" do
                    local v587 = v175
                    local kind_3 = kind_2
                    v173 = v587
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                if kind == "{" then
                    return v541()
                end
                while kind == "\n" do
                    local v588 = v175
                    local kind_3 = kind_2
                    v173 = v588
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                if kind == "|" then
                    return v222()
                end
                while kind == "\n" do
                    local v589 = v175
                    local kind_3 = kind_2
                    v173 = v589
                    kind = kind_3
                    x = x_2
                    v175 = next_token()
                    kind_2 = v175.kind
                    x_2 = v175.span.x
                end
                if kind ~= "$" then
                    while kind == "\n" do
                        local v590 = v175
                        local kind_3 = kind_2
                        v173 = v590
                        kind = kind_3
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                    end
                    if kind ~= "identifier" then
                        while kind == "\n" do
                            local v591 = v175
                            local kind_3 = kind_2
                            v173 = v591
                            kind = kind_3
                            x = x_2
                            v175 = next_token()
                            kind_2 = v175.kind
                            x_2 = v175.span.x
                        end
                        if kind == "[" then
                            return v224()
                        end
                        while kind == "\n" do
                            local v592 = v175
                            local kind_3 = kind_2
                            v173 = v592
                            kind = kind_3
                            x = x_2
                            v175 = next_token()
                            kind_2 = v175.kind
                            x_2 = v175.span.x
                        end
                        if kind == "&" then
                            local v593 = {
                                why = "SyntaxError: you are not allowed to run a command here due to ambiguous syntax. please wrap the command with ()",
                                span = expect_fatal("&").span
                            }
                            table.insert(v29, v593)
                            local v594 = "expected expression, but got %* of %* instead"
                            local v595 = v173
                            local kind_3 = v595.kind
                            local text
                            if kind_3 == "identifier" or kind_3 == "number" or kind_3 == "string" then
                                text = v595.text
                            elseif v595.kind == "error" then
                                text = "error '" .. v595.text .. "'"
                            else
                                text = "'" .. kind_3 .. "'"
                            end
                            local v596 = v594:format(text, kind)
                            local span = v173.span
                            local v597 = {
                                why = ("SyntaxError: %*"):format(v596),
                                span = span
                            }
                            table.insert(v29, v597)
                            local v598 = v175
                            local kind_4 = kind_2
                            v173 = v598
                            kind = kind_4
                        elseif current_binary_operator() then
                            local v599 = {
                                why = "SyntaxError: you are not allowed to use binary operators here due to ambiguous syntax. please wrap the expression with ()",
                                span = v173.span
                            }
                            table.insert(v29, v599)
                            local v600 = v175
                            local kind_3 = kind_2
                            v173 = v600
                            kind = kind_3
                        else
                            local v601 = "expected expression, but got %* of %* instead"
                            local v602 = v173
                            local kind_3 = v602.kind
                            local text
                            if kind_3 == "identifier" or kind_3 == "number" or kind_3 == "string" then
                                text = v602.text
                            elseif v602.kind == "error" then
                                text = "error '" .. v602.text .. "'"
                            else
                                text = "'" .. kind_3 .. "'"
                            end
                            local v603 = v601:format(text, kind)
                            local span = v173.span
                            local v604 = {
                                why = ("SyntaxError: %*"):format(v603),
                                span = span
                            }
                            table.insert(v29, v604)
                            local v605 = v175
                            local kind_4 = kind_2
                            v173 = v605
                            kind = kind_4
                        end
                        x = x_2
                        v175 = next_token()
                        kind_2 = v175.kind
                        x_2 = v175.span.x
                        return nil
                    end
                end
                return v223()
            end
        end
        local v606 = v173
        local v607 = v175
        local kind_3 = kind_2
        v173 = v607
        kind = kind_3
        x = x_2
        v175 = next_token()
        kind_2 = v175.kind
        x_2 = v175.span.x
        return {
            kind = "boolean",
            token = v606,
            span = v606.span
        }
    end

    local function parse_simple_expression_command() -- line 1186 | captures: v173, kind, x, v175, kind_2, x_2, v214, v221, next_token, expect_fatal
        while kind == "\n" do
            local v608 = v175
            local kind_3 = kind_2
            v173 = v608
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "&" then
            local v609 = expect_fatal("&")
            local v610 = v221()
            local v611 = {
                kind = "command",
                prefix = v609,
                command = v610
            }
            local span = v609.span
            local v612 = v610 and v610.span
            local v613, v614
            if span then
                local x = span.x
                if x then
                    v613 = x
                    v614 = true
                elseif v612 then
                    local x = v612.x
                    if x then
                        v613 = x
                        v614 = true
                    else
                        v614 = false
                    end
                else
                    v614 = false
                end
            elseif v612 then
                local x = v612.x
                if x then
                    v613 = x
                    v614 = true
                else
                    v614 = false
                end
            else
                v614 = false
            end
            if not v614 then
                v613 = 0
            end
            local v615, v616
            if v612 then
                local y = v612.y
                if y then
                    v615 = y
                    v616 = true
                elseif span then
                    local y = span.y
                    if y then
                        v615 = y
                        v616 = true
                    else
                        v616 = false
                    end
                else
                    v616 = false
                end
            elseif span then
                local y = span.y
                if y then
                    v615 = y
                    v616 = true
                else
                    v616 = false
                end
            else
                v616 = false
            end
            if not v616 then
                v615 = 0
            end
            local v617, v618
            if span then
                local z = span.z
                if z then
                    v617 = z
                    v618 = true
                elseif v612 then
                    local z = v612.z
                    if z then
                        v617 = z
                        v618 = true
                    else
                        v618 = false
                    end
                else
                    v618 = false
                end
            elseif v612 then
                local z = v612.z
                if z then
                    v617 = z
                    v618 = true
                else
                    v618 = false
                end
            else
                v618 = false
            end
            if not v618 then
                v617 = 0
            end
            v611.span = vector.create(v613, v615, v617)
            return v611
        end
        return v214()
    end

    function v215(v619) -- line 1204 | captures: v173, kind, x, v175, kind_2, x_2, v214, v215, panic, next_token, current_binary_operator, binary_operator_priority
        local v620 = v619 or 0
        local v621
        if kind == "-" or kind == "!" then
            v621 = v173
            local v622 = v175
            local kind_3 = kind_2
            v173 = v622
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        local v623
        if v621 then
            local v624 = v215(8)
            v623 = {
                kind = "unary",
                operator = v621,
                value = v624
            }
            local span = v621.span
            local span_2 = v624.span
            local x = span and span.x or span_2 and span_2.x or 0
            local v625, v626
            if span_2 then
                local y = span_2.y
                if y then
                    v625 = y
                    v626 = true
                elseif span then
                    local y = span.y
                    if y then
                        v625 = y
                        v626 = true
                    else
                        v626 = false
                    end
                else
                    v626 = false
                end
            elseif span then
                local y = span.y
                if y then
                    v625 = y
                    v626 = true
                else
                    v626 = false
                end
            else
                v626 = false
            end
            if not v626 then
                v625 = 0
            end
            local v627, v628
            if span then
                local z = span.z
                if z then
                    v627 = z
                    v628 = true
                elseif span_2 then
                    local z = span_2.z
                    if z then
                        v627 = z
                        v628 = true
                    else
                        v628 = false
                    end
                else
                    v628 = false
                end
            elseif span_2 then
                local z = span_2.z
                if z then
                    v627 = z
                    v628 = true
                else
                    v628 = false
                end
            else
                v628 = false
            end
            if not v628 then
                v627 = 0
            end
            v623.span = vector.create(x, v625, v627)
        else
            v623 = v214()
        end
        while true do
            local v629 = current_binary_operator()
            if v629 == nil then
                break
            end
            local v630, v631 = binary_operator_priority(v629)
            if v630 < v620 then
                break
            end
            local v632 = v175
            local kind_3 = kind_2
            v173 = v632
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
            local v633 = v215(v631)
            if v623 then
                local v634 = {
                    kind = "binary",
                    left = v623,
                    operator = v629,
                    right = v633
                }
                local span = v623.span
                if not v623 or not span then
                    span = nil
                end
                local span_2 = if v629 then v629.span else nil
                local span_3
                if not v629 or not span_2 then
                else
                    span_3 = span_2
                end
                local v635, v636
                if span then
                    local x = span.x
                    if x then
                        v635 = x
                        v636 = true
                    elseif span_3 then
                        local x = span_3.x
                        if x then
                            v635 = x
                            v636 = true
                        else
                            v636 = false
                        end
                    else
                        v636 = false
                    end
                elseif span_3 then
                    local x = span_3.x
                    if x then
                        v635 = x
                        v636 = true
                    else
                        v636 = false
                    end
                else
                    v636 = false
                end
                if not v636 then
                    v635 = 0
                end
                local v637, v638
                if span_3 then
                    local y = span_3.y
                    if y then
                        v637 = y
                        v638 = true
                    elseif span then
                        local y = span.y
                        if y then
                            v637 = y
                            v638 = true
                        else
                            v638 = false
                        end
                    else
                        v638 = false
                    end
                elseif span then
                    local y = span.y
                    if y then
                        v637 = y
                        v638 = true
                    else
                        v638 = false
                    end
                else
                    v638 = false
                end
                if not v638 then
                    v637 = 0
                end
                local v639, v640
                if span then
                    local z = span.z
                    if z then
                        v639 = z
                        v640 = true
                    elseif span_3 then
                        local z = span_3.z
                        if z then
                            v639 = z
                            v640 = true
                        else
                            v640 = false
                        end
                    else
                        v640 = false
                    end
                elseif span_3 then
                    local z = span_3.z
                    if z then
                        v639 = z
                        v640 = true
                    else
                        v640 = false
                    end
                else
                    v640 = false
                end
                if not v640 then
                    v639 = 0
                end
                v634.span = vector.create(v635, v637, v639)
                v623 = v634
                continue
            end
            return panic("no left hand side")
        end
        if v623 then
            return v623
        end
        return panic("no expression")
    end

    function v216() -- line 1255 | captures: v173, kind, x, v175, kind_2, x_2, v215, next_token, parse_simple_expression_command
        while kind == "\n" do
            local v641 = v175
            local kind_3 = kind_2
            v173 = v641
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "&" then
            return parse_simple_expression_command()
        end
        return v215()
    end

    function v222() -- line 1264 | captures: v311
        local v642 = v311()
        local v643 = { kind = "lambda" }
        v643.span = v642 and v642.span
        v643.body = v642
        return v643
    end

    function v224() -- line 1274 | captures: v216, v290, panic, separated
        local v644 = v290("[", "]", function() -- line 1278 | captures: v216, separated
            return (separated(v216))
        end)
        if v644 then
            local v645 = {
                kind = "vector",
                contents = v644
            }
            local v646 = v644.left and v644.left.span
            local value = v644.value and v644.value[1] and v644.value[1].span
            local value_2 = v644.value and v644.value[#v644.value] and v644.value[#v644.value].span
            local v647 = v644.right and v644.right.span
            local v648, v649
            if v646 then
                local x = v646.x
                if x then
                    v648 = x
                    v649 = true
                elseif value then
                    local x = value.x
                    if x then
                        v648 = x
                        v649 = true
                    else
                        v649 = false
                    end
                else
                    v649 = false
                end
            elseif value then
                local x = value.x
                if x then
                    v648 = x
                    v649 = true
                else
                    v649 = false
                end
            else
                v649 = false
            end
            if not v649 then
                local v650
                if value_2 then
                    local x = value_2.x
                    if x then
                        v648 = x
                        v650 = true
                    elseif v647 then
                        local x = v647.x
                        if x then
                            v648 = x
                            v650 = true
                        else
                            v650 = false
                        end
                    else
                        v650 = false
                    end
                elseif v647 then
                    local x = v647.x
                    if x then
                        v648 = x
                        v650 = true
                    else
                        v650 = false
                    end
                else
                    v650 = false
                end
                if not v650 then
                    v648 = 0
                end
            end
            local v651, v652
            if v647 then
                local y = v647.y
                if y then
                    v651 = y
                    v652 = true
                elseif value_2 then
                    local y = value_2.y
                    if y then
                        v651 = y
                        v652 = true
                    else
                        v652 = false
                    end
                else
                    v652 = false
                end
            elseif value_2 then
                local y = value_2.y
                if y then
                    v651 = y
                    v652 = true
                else
                    v652 = false
                end
            else
                v652 = false
            end
            if not v652 then
                local v653
                if value then
                    local y = value.y
                    if y then
                        v651 = y
                        v653 = true
                    elseif v646 then
                        local y = v646.y
                        if y then
                            v651 = y
                            v653 = true
                        else
                            v653 = false
                        end
                    else
                        v653 = false
                    end
                elseif v646 then
                    local y = v646.y
                    if y then
                        v651 = y
                        v653 = true
                    else
                        v653 = false
                    end
                else
                    v653 = false
                end
                if not v653 then
                    v651 = 0
                end
            end
            local v654, v655
            if v646 then
                local z = v646.z
                if z then
                    v654 = z
                    v655 = true
                elseif value then
                    local z = value.z
                    if z then
                        v654 = z
                        v655 = true
                    else
                        v655 = false
                    end
                else
                    v655 = false
                end
            elseif value then
                local z = value.z
                if z then
                    v654 = z
                    v655 = true
                else
                    v655 = false
                end
            else
                v655 = false
            end
            if not v655 then
                local v656
                if value_2 then
                    local z = value_2.z
                    if z then
                        v654 = z
                        v656 = true
                    elseif v647 then
                        local z = v647.z
                        if z then
                            v654 = z
                            v656 = true
                        else
                            v656 = false
                        end
                    else
                        v656 = false
                    end
                elseif v647 then
                    local z = v647.z
                    if z then
                        v654 = z
                        v656 = true
                    else
                        v656 = false
                    end
                else
                    v656 = false
                end
                if not v656 then
                    v654 = 0
                end
            end
            v645.span = vector.create(v648, v651, v654)
            return v645
        end
        return panic("no values")
    end

    local function parse_var_root() -- line 1298 | captures: v173, kind, x, v175, kind_2, x_2, v216, v290, v29, panic, next_token, expect_fatal
        while kind == "\n" do
            local v657 = v175
            local kind_3 = kind_2
            v173 = v657
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "identifier" then
            local identifier = expect_fatal("identifier")
            return {
                kind = "global",
                token = identifier,
                span = identifier.span
            }
        end
        while kind == "\n" do
            local v658 = v175
            local kind_3 = kind_2
            v173 = v658
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "$" then
            while kind_2 == "\n" do
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind_2 == "(" then
                local v659 = expect_fatal("$")
                local v660 = v290("(", ")", v216)
                local v661, span, v662
                if v660 then
                    v661 = {
                        kind = "paren",
                        var = v659,
                        node = v660
                    }
                    span = v659.span
                    v662 = v660.left and v660.left.span
                else
                    return panic("no expression")
                end
                local v663 = v660.value and v660.value.span
                local v664 = v660.right and v660.right.span
                local v665, v666
                if span then
                    local x = span.x
                    if x then
                        v665 = x
                        v666 = true
                    elseif v662 then
                        local x = v662.x
                        if x then
                            v665 = x
                            v666 = true
                        else
                            v666 = false
                        end
                    else
                        v666 = false
                    end
                elseif v662 then
                    local x = v662.x
                    if x then
                        v665 = x
                        v666 = true
                    else
                        v666 = false
                    end
                else
                    v666 = false
                end
                if not v666 then
                    local v667
                    if v663 then
                        local x = v663.x
                        if x then
                            v665 = x
                            v667 = true
                        elseif v664 then
                            local x = v664.x
                            if x then
                                v665 = x
                                v667 = true
                            else
                                v667 = false
                            end
                        else
                            v667 = false
                        end
                    elseif v664 then
                        local x = v664.x
                        if x then
                            v665 = x
                            v667 = true
                        else
                            v667 = false
                        end
                    else
                        v667 = false
                    end
                    if not v667 then
                        v665 = 0
                    end
                end
                local v668, v669
                if v664 then
                    local y = v664.y
                    if y then
                        v668 = y
                        v669 = true
                    elseif v663 then
                        local y = v663.y
                        if y then
                            v668 = y
                            v669 = true
                        else
                            v669 = false
                        end
                    else
                        v669 = false
                    end
                elseif v663 then
                    local y = v663.y
                    if y then
                        v668 = y
                        v669 = true
                    else
                        v669 = false
                    end
                else
                    v669 = false
                end
                if not v669 then
                    local v670
                    if v662 then
                        local y = v662.y
                        if y then
                            v668 = y
                            v670 = true
                        elseif span then
                            local y = span.y
                            if y then
                                v668 = y
                                v670 = true
                            else
                                v670 = false
                            end
                        else
                            v670 = false
                        end
                    elseif span then
                        local y = span.y
                        if y then
                            v668 = y
                            v670 = true
                        else
                            v670 = false
                        end
                    else
                        v670 = false
                    end
                    if not v670 then
                        v668 = 0
                    end
                end
                local v671, v672
                if span then
                    local z = span.z
                    if z then
                        v671 = z
                        v672 = true
                    elseif v662 then
                        local z = v662.z
                        if z then
                            v671 = z
                            v672 = true
                        else
                            v672 = false
                        end
                    else
                        v672 = false
                    end
                elseif v662 then
                    local z = v662.z
                    if z then
                        v671 = z
                        v672 = true
                    else
                        v672 = false
                    end
                else
                    v672 = false
                end
                if not v672 then
                    local v673
                    if v663 then
                        local z = v663.z
                        if z then
                            v671 = z
                            v673 = true
                        elseif v664 then
                            local z = v664.z
                            if z then
                                v671 = z
                                v673 = true
                            else
                                v673 = false
                            end
                        else
                            v673 = false
                        end
                    elseif v664 then
                        local z = v664.z
                        if z then
                            v671 = z
                            v673 = true
                        else
                            v673 = false
                        end
                    else
                        v673 = false
                    end
                    if not v673 then
                        v671 = 0
                    end
                end
                v661.span = vector.create(v665, v668, v671)
                return v661
            end
        end
        while kind == "\n" do
            local v674 = v175
            local kind_3 = kind_2
            v173 = v674
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "$" then
            local v675 = expect_fatal("$")
            while kind == "\n" do
                local v676 = v175
                local kind_3 = kind_2
                v173 = v676
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            local v677
            if kind == "identifier" then
                v677 = v173
                local v678 = v175
                local kind_3 = kind_2
                v173 = v678
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            else
                local v679 = "expected identifier, but got %* of %* instead"
                local v680 = v173
                local kind_3 = v680.kind
                local text
                if kind_3 == "identifier" or kind_3 == "number" or kind_3 == "string" then
                    text = v680.text
                elseif v680.kind == "error" then
                    text = "error '" .. v680.text .. "'"
                else
                    text = "'" .. kind_3 .. "'"
                end
                local v681 = v679:format(text, kind)
                local span = v173.span
                local v682 = {
                    why = ("SyntaxError: %*"):format(v681),
                    span = span
                }
                table.insert(v29, v682)
                local v683 = v175
                local kind_4 = kind_2
                v173 = v683
                kind = kind_4
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
                v677 = false
            end
            local v684 = {
                kind = "name",
                var = v675,
                name = v677 or nil
            }
            local span = v675.span
            local span_2 = v677 and v677.span or nil
            local v685, v686
            if span then
                local x = span.x
                if x then
                    v685 = x
                    v686 = true
                elseif span_2 then
                    local x = span_2.x
                    if x then
                        v685 = x
                        v686 = true
                    else
                        v686 = false
                    end
                else
                    v686 = false
                end
            elseif span_2 then
                local x = span_2.x
                if x then
                    v685 = x
                    v686 = true
                else
                    v686 = false
                end
            else
                v686 = false
            end
            if not v686 then
                v685 = 0
            end
            local v687, v688
            if span_2 then
                local y = span_2.y
                if y then
                    v687 = y
                    v688 = true
                elseif span then
                    local y = span.y
                    if y then
                        v687 = y
                        v688 = true
                    else
                        v688 = false
                    end
                else
                    v688 = false
                end
            elseif span then
                local y = span.y
                if y then
                    v687 = y
                    v688 = true
                else
                    v688 = false
                end
            else
                v688 = false
            end
            if not v688 then
                v687 = 0
            end
            local v689, v690
            if span then
                local z = span.z
                if z then
                    v689 = z
                    v690 = true
                elseif span_2 then
                    local z = span_2.z
                    if z then
                        v689 = z
                        v690 = true
                    else
                        v690 = false
                    end
                else
                    v690 = false
                end
            elseif span_2 then
                local z = span_2.z
                if z then
                    v689 = z
                    v690 = true
                else
                    v690 = false
                end
            else
                v690 = false
            end
            if not v690 then
                v689 = 0
            end
            v684.span = vector.create(v685, v687, v689)
            return v684
        end
        local v691 = ("could not parse into var. got %*"):format(kind)
        local span = v173.span
        local v692 = {
            why = ("SyntaxError: %*"):format(v691),
            span = span
        }
        table.insert(v29, v692)
        return panic()
    end

    local function parse_var_suffix() -- line 1343 | captures: v173, kind, x, v175, kind_2, x_2, v216, v290, v29, panic, next_token, expect_fatal
        while kind == "\n" do
            local v693 = v175
            local kind_3 = kind_2
            v173 = v693
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "." then
            while kind_2 == "\n" do
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            if kind_2 == "[" then
                local v694 = expect_fatal(".")
                local v695 = v290("[", "]", v216)
                local v696, v697
                if v695 then
                    v696 = {
                        kind = "expression_index",
                        node = v695,
                        period = v694
                    }
                    v697 = v695.left and v695.left.span or nil
                else
                    return panic("unreachable")
                end
                local span = v695.value and v695.value.span or nil
                local span_2 = v695.right and v695.right.span or nil
                local v698, v699
                if v697 then
                    local x = v697.x
                    if x then
                        v698 = x
                        v699 = true
                    elseif span then
                        local x = span.x
                        if x then
                            v698 = x
                            v699 = true
                        else
                            v699 = false
                        end
                    else
                        v699 = false
                    end
                elseif span then
                    local x = span.x
                    if x then
                        v698 = x
                        v699 = true
                    else
                        v699 = false
                    end
                else
                    v699 = false
                end
                if not v699 then
                    local x = if span_2 then span_2.x else nil
                    if not span_2 or not x then
                        v698 = 0
                    else
                        v698 = x
                    end
                end
                local v700, v701
                if span_2 then
                    local y = span_2.y
                    if y then
                        v700 = y
                        v701 = true
                    elseif span then
                        local y = span.y
                        if y then
                            v700 = y
                            v701 = true
                        else
                            v701 = false
                        end
                    else
                        v701 = false
                    end
                elseif span then
                    local y = span.y
                    if y then
                        v700 = y
                        v701 = true
                    else
                        v701 = false
                    end
                else
                    v701 = false
                end
                if not v701 then
                    local y = if v697 then v697.y else nil
                    if not v697 or not y then
                        v700 = 0
                    else
                        v700 = y
                    end
                end
                local v702, v703
                if v697 then
                    local z = v697.z
                    if z then
                        v702 = z
                        v703 = true
                    elseif span then
                        local z = span.z
                        if z then
                            v702 = z
                            v703 = true
                        else
                            v703 = false
                        end
                    else
                        v703 = false
                    end
                elseif span then
                    local z = span.z
                    if z then
                        v702 = z
                        v703 = true
                    else
                        v703 = false
                    end
                else
                    v703 = false
                end
                if not v703 then
                    local z = if span_2 then span_2.z else nil
                    if not span_2 or not z then
                        v702 = 0
                    else
                        v702 = z
                    end
                end
                v696.span = vector.create(v698, v700, v702)
                return v696
            end
        end
        while kind == "\n" do
            local v704 = v175
            local kind_3 = kind_2
            v173 = v704
            kind = kind_3
            x = x_2
            v175 = next_token()
            kind_2 = v175.kind
            x_2 = v175.span.x
        end
        if kind == "." then
            local v705 = expect_fatal(".")
            while kind == "\n" do
                local v706 = v175
                local kind_3 = kind_2
                v173 = v706
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            end
            local v707
            if kind == "identifier" then
                v707 = v173
                local v708 = v175
                local kind_3 = kind_2
                v173 = v708
                kind = kind_3
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
            else
                local v709 = "expected identifier, but got %* of %* instead"
                local v710 = v173
                local kind_3 = v710.kind
                local text
                if kind_3 == "identifier" or kind_3 == "number" or kind_3 == "string" then
                    text = v710.text
                elseif v710.kind == "error" then
                    text = "error '" .. v710.text .. "'"
                else
                    text = "'" .. kind_3 .. "'"
                end
                local v711 = v709:format(text, kind)
                local span = v173.span
                local v712 = {
                    why = ("SyntaxError: %*"):format(v711),
                    span = span
                }
                table.insert(v29, v712)
                local v713 = v175
                local kind_4 = kind_2
                v173 = v713
                kind = kind_4
                x = x_2
                v175 = next_token()
                kind_2 = v175.kind
                x_2 = v175.span.x
                v707 = false
            end
            local v714 = {
                kind = "name_index",
                period = v705,
                name = v707 or nil
            }
            local span = v705.span
            local span_2 = v707 and v707.span or nil
            local v715, v716
            if span then
                local x = span.x
                if x then
                    v715 = x
                    v716 = true
                elseif span_2 then
                    local x = span_2.x
                    if x then
                        v715 = x
                        v716 = true
                    else
                        v716 = false
                    end
                else
                    v716 = false
                end
            elseif span_2 then
                local x = span_2.x
                if x then
                    v715 = x
                    v716 = true
                else
                    v716 = false
                end
            else
                v716 = false
            end
            if not v716 then
                v715 = 0
            end
            local v717, v718
            if span_2 then
                local y = span_2.y
                if y then
                    v717 = y
                    v718 = true
                elseif span then
                    local y = span.y
                    if y then
                        v717 = y
                        v718 = true
                    else
                        v718 = false
                    end
                else
                    v718 = false
                end
            elseif span then
                local y = span.y
                if y then
                    v717 = y
                    v718 = true
                else
                    v718 = false
                end
            else
                v718 = false
            end
            if not v718 then
                v717 = 0
            end
            local v719, v720
            if span then
                local z = span.z
                if z then
                    v719 = z
                    v720 = true
                elseif span_2 then
                    local z = span_2.z
                    if z then
                        v719 = z
                        v720 = true
                    else
                        v720 = false
                    end
                else
                    v720 = false
                end
            elseif span_2 then
                local z = span_2.z
                if z then
                    v719 = z
                    v720 = true
                else
                    v720 = false
                end
            else
                v720 = false
            end
            if not v720 then
                v719 = 0
            end
            v714.span = vector.create(v715, v717, v719)
            return v714
        end
        return panic("unreachable")
    end

    function v223() -- line 1377 | captures: kind, parse_var_root, parse_var_suffix
        local function v721(v722, ...)
            table.insert(v722, ...)
        end

        local v723 = parse_var_root()
        local v724 = {}
        while kind == "." do
            v721(v724, parse_var_suffix())
        end
        local v725 = {
            kind = "var",
            root = v723,
            suffixes = v724
        }
        local span = v723.span
        local v726 = v724[#v724] and v724[#v724].span
        local v727, v728
        if span then
            local x = span.x
            if x then
                v727 = x
                v728 = true
            elseif v726 then
                local x = v726.x
                if x then
                    v727 = x
                    v728 = true
                else
                    v728 = false
                end
            else
                v728 = false
            end
        elseif v726 then
            local x = v726.x
            if x then
                v727 = x
                v728 = true
            else
                v728 = false
            end
        else
            v728 = false
        end
        if not v728 then
            v727 = 0
        end
        local v729, v730
        if v726 then
            local y = v726.y
            if y then
                v729 = y
                v730 = true
            elseif span then
                local y = span.y
                if y then
                    v729 = y
                    v730 = true
                else
                    v730 = false
                end
            else
                v730 = false
            end
        elseif span then
            local y = span.y
            if y then
                v729 = y
                v730 = true
            else
                v730 = false
            end
        else
            v730 = false
        end
        if not v730 then
            v729 = 0
        end
        local v731, v732
        if span then
            local z = span.z
            if z then
                v731 = z
                v732 = true
            elseif v726 then
                local z = v726.z
                if z then
                    v731 = z
                    v732 = true
                else
                    v732 = false
                end
            else
                v732 = false
            end
        elseif v726 then
            local z = v726.z
            if z then
                v731 = z
                v732 = true
            else
                v732 = false
            end
        else
            v732 = false
        end
        if not v732 then
            v731 = 0
        end
        v725.span = vector.create(v727, v729, v731)
        return v725
    end

    local v733 = { block = v255() }
    if #v29 > 0 then
        error({
            result = v733,
            issues = v29
        })
    else
        return {
            result = v733,
            issues = v29
        }
    end
end

return parse
