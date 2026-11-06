-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local Utility = require(script.Parent.Parent.Utility)
local Default = require(script.Default)

local function getThemeValue(v2, v3, v4, v5) -- line 16
    if v2 then
        for v6, v7 in pairs(v2) do
            local v8, v9, v10 = unpack(v7)
            if v3 == v8 and v4 == v9 then
                return v10
            end
        end
    end
    return nil
end

v1.getThemeValue = getThemeValue

local function getInstanceValue(v11, v12) -- line 28
    local v13, v14 = pcall(function() -- line 29 | captures: v11, v12
        return v11[v12]
    end)
    if not v13 then
        v14 = v11:GetAttribute(v12)
    end
    return v14
end

v1.getInstanceValue = getInstanceValue

local function getRealInstance(v15) -- line 38
    if v15:GetAttribute("IsAClippedClone") then
        local OriginalInstance = v15:FindFirstChild("OriginalInstance")
        if OriginalInstance then
            return OriginalInstance.Value
        end
    end
end

v1.getRealInstance = getRealInstance

local function getClippedClone(v16) -- line 49
    if v16:GetAttribute("HasAClippedClone") then
        local ClippedClone = v16:FindFirstChild("ClippedClone")
        if ClippedClone then
            return ClippedClone.Value
        end
    end
end

v1.getClippedClone = getClippedClone

function v1.refresh(v17, v18, v19) -- line 60 | captures: v1
    if v19 then
        local v20 = v17:getStateGroup()
        local v21 = v1.getThemeValue(v20, v18.Name, v19) or v1.getInstanceValue(v18, v19)
        v1.apply(v17, v18, v19, v21, true)
    else
        local v22 = v17:getStateGroup()
        if v22 then
            local v23 = { [v18.Name] = v18 }
            for v24, v25 in pairs(v18:GetDescendants()) do
                local Collective = v25:GetAttribute("Collective")
                if Collective then
                    v23[Collective] = v25
                end
                v23[v25.Name] = v25
            end
            for v26, v27 in pairs(v22) do
                local v28, v29, v30 = unpack(v27)
                local v31 = v23[v28]
                if v31 then
                    v1.apply(v17, v31.Name, v29, v30, true)
                end
            end
        end
    end
end

function v1.apply(v32, v33, v34, v35, v36) -- line 93 | captures: v1
    local v37 = v35
    if v32.isDestroyed then
        return
    end
    local v38, v39
    if typeof(v33) == "Instance" then
        v39, v38 = { v33 }, v33.Name
    else
        v39 = v32:getInstanceOrCollective(v33)
        v38 = v33
    end
    local v40 = v38 .. "-" .. v34
    local v41 = v32.customBehaviours[v40]
    for v42, v43 in pairs(v39) do
        local v44 = v1.getClippedClone(v43)
        if v44 then
            table.insert(v39, v44)
        end
    end
    local v45, v46
    for v47, v48 in pairs(v39) do
        if not (v34 == "Position" and v1.getClippedClone(v48)) then
            if v34 == "Size" then
                if not v1.getRealInstance(v48) then
                    local v49 = v1.getInstanceValue(v48, v34)
                    if v36 or v37 ~= v49 then
                        if v41 then
                            local v50 = v41(v37, v48, v34)
                            if v50 ~= nil then
                                v37 = v50
                            end
                        end
                        local pcall_2 = pcall
                        v45 = v48
                        v46 = v34
                        if not pcall_2(function() -- line 139 | captures: v37, v45, v46
                                v45[v46] = v37
                            end) then
                            v48:SetAttribute(v34, v37)
                        end
                    end
                end
            else
                local v51 = v1.getInstanceValue(v48, v34)
                if v36 or v37 ~= v51 then
                    if v41 then
                        local v52 = v41(v37, v48, v34)
                        if v52 ~= nil then
                            v37 = v52
                        end
                    end
                    local pcall_2 = pcall
                    v45 = v48
                    v46 = v34
                    if not pcall_2(function() -- line 139 | captures: v37, v45, v46
                            v45[v46] = v37
                        end) then
                        v48:SetAttribute(v34, v37)
                    end
                end
            end
        end
    end
end

local function getModifications(v53) -- line 153
    local v54 = v53[1]
    if typeof(v54) == "table" then
        return v53
    end
    return { v53 }
end

v1.getModifications = getModifications

function v1.merge(v55, v56, v57) -- line 162 | captures: v1
    local v58, v59, v60, v61 = table.unpack(v56)
    local v62, v63, v64, v65 = table.unpack(v55)
    local v66
    if v58 == v62 and v59 == v63 and v1.statesMatch(v61, v65) then
        v55[3] = v60
        if v57 then
            v57(v55)
        end
        v66 = false
    else
        v66 = true
    end
    return not v66
end

function v1.modify(v67, v68, v69) -- line 175 | captures: v1, Utility
    local v70 = v68
    local v71 = v69
    task.spawn(function() -- line 183 | captures: v70, v71, v67, v1, Utility
        v71 = v71 or Utility.generateUID()
        v70 = v1.getModifications(v70)
        for v72, v73 in pairs(v70) do
            local v74, v75, v76, v77 = table.unpack(v73)
            if v77 == nil then
                v1.modify(v67, { v74, v75, v76, "Selected" }, v71)
                v1.modify(v67, { v74, v75, v76, "Viewing" }, v71)
            end
            local v78 = Utility.formatStateName(v77 or "Deselected")
            local v79 = v67:getStateGroup(v78)
            local v80 = {}
            v80[1] = v78
            local v81 = {}
            v81[1] = v74
            local v82 = {}
            v82[1] = v75
            local v83 = {}
            v83[1] = v76;
            (function(v84, v85, v86, v87)
                local function nowSetIt() -- line 195 | captures: v84, v85, v86, v87, v67, v1
                    if v84[1] == v67.activeState then
                        v1.apply(v67, v85[1], v86[1], v87[1])
                    end
                end

                return nowSetIt
            end)(v80, v81, v82, v83)
            local v88 = v73

            local updateRecord = function() -- updateRecord | line 200 | captures: v74, v75, v76, v78, v79, v88, v71, v67, v1
                for v89, v90 in pairs(v79) do
                    if v1.merge(v90, v88, function(v91) -- line 202 | captures: v74, v75, v76, v78, v71, v67, v1
                            v91[5] = v71
                            if v78 == v67.activeState then
                                v1.apply(v67, v74, v75, v76)
                            end
                        end) then
                        return
                    end
                end
                local v92 = { v74, v75, v76, v78, v71 }
                table.insert(v79, v92)
                if v78 == v67.activeState then
                    v1.apply(v67, v74, v75, v76)
                end
            end

            updateRecord()
        end
    end)
    return v71
end

function v1.remove(v93, v94) -- line 220 | captures: v1
    for v95, v96 in pairs(v93.appearance) do
        local v97 = #v96
        for v98 = v97, 1, -1 do
            if v96[v98][5] == v94 then
                table.remove(v96, v98)
            end
        end
    end
    v1.rebuild(v93)
end

function v1.removeWith(v99, v100, v101, v102) -- line 233 | captures: v1
    for v103, v104 in pairs(v99.appearance) do
        if v102 == v103 or not v102 then
            local v105 = #v104
            for v106 = v105, 1, -1 do
                local v107 = v104[v106]
                local v108 = v107[1]
                local v109 = v107[2]
                if v108 == v100 and v109 == v101 then
                    table.remove(v104, v106)
                end
            end
        end
    end
    v1.rebuild(v99)
end

function v1.change(v110) -- line 249 | captures: v1
    local v111 = v110:getStateGroup()
    for v112, v113 in pairs(v111) do
        local v114, v115, v116 = unpack(v113)
        v1.apply(v110, v114, v115, v116)
    end
end

function v1.set(v117, v118) -- line 259 | captures: v1
    local themesJanitor = v117.themesJanitor
    themesJanitor:clean()
    themesJanitor:add(v117.stateChanged:Connect(function() -- line 265 | captures: v117, v1
        v1.change(v117)
    end))
    local v119
    if typeof(v118) == "Instance" and v118:IsA("ModuleScript") then
        v119 = require(v118)
    else
        v119 = v118
    end
    v117.appliedTheme = v119
    v1.rebuild(v117)
end

local function statesMatch(v120, v121) -- line 275
    if (v120 and string.lower(v120)) == (v121 and string.lower(v121)) then
        return true
    end
    return not v120 or not v121
end

v1.statesMatch = statesMatch

function v1.rebuild(v122) -- line 282 | captures: v1, Utility, Default
    local appliedTheme = v122.appliedTheme
    local v123 = { "Deselected", "Selected", "Viewing" }

    local function generateTheme() -- line 289 | captures: v122, appliedTheme, v123, v1, Utility, Default
        for v124, v125 in pairs(v123) do
            local v126 = {}

            local updateDetails = function(v127, v128) -- updateDetails | line 295 | captures: v126, v1, Utility
                if v127 then
                    for v129, v130 in pairs(v127) do
                        local v131 = v130[5]
                        local v132 = v130[4]
                        if v1.statesMatch(v128, v132) then
                            local v133 = v130[1] .. "-" .. v130[2]
                            local v134 = Utility.copyTable(v130)
                            v134[5] = v131
                            v126[v133] = v134
                        end
                    end
                end
            end

            if v125 == "Selected" then
                updateDetails(Default, "Deselected")
            end
            updateDetails(Default, "Empty")
            updateDetails(Default, v125)
            if appliedTheme ~= Default then
                if v125 == "Selected" then
                    updateDetails(appliedTheme, "Deselected")
                end
                updateDetails(Default, "Empty")
                updateDetails(appliedTheme, v125)
            end
            local v135 = {}
            local v136 = v122.appearance[v125]
            if v136 then
                for v137, v138 in pairs(v136) do
                    local v139 = v138[5]
                    if v139 ~= nil then
                        local v140 = {
                            v138[1],
                            v138[2],
                            v138[3],
                            v125,
                            v139
                        }
                        table.insert(v135, v140)
                    end
                end
            end
            updateDetails(v135, v125)
            local v141 = {}
            for v142, v143 in pairs(v126) do
                table.insert(v141, v143)
            end
            v122.appearance[v125] = v141
        end
        v1.change(v122)
    end

    generateTheme()
end

return v1
