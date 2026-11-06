-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local CollectionService = game:GetService("CollectionService")
local v1 = {}
local v2
local v3 = true
local v4 = 0

local function preloadLists(v5) -- line 34
    local v6 = {}
    local v7 = {}
    local v8 = {}
    local v9 = {}

    local function put(v10, v11) -- line 37 | captures: v6
        if not (not v11 or not v11:IsA("ImageLabel") and not v11:IsA("ImageButton")) and v11.Image ~= "" and not v6[v11.Image] then
            v6[v11.Image] = true
            table.insert(v10, v11)
        end
    end

    local main = v5.main
    if not (not main or not main:IsA("ImageLabel") and not main:IsA("ImageButton")) and main.Image ~= "" and not v6[main.Image] then
        v6[main.Image] = true
        table.insert(v7, main)
    end
    local v12 = v5.main:FindFirstChild("StudBG and Stroke Holder")
    if not (not v12 or not v12:IsA("ImageLabel") and not v12:IsA("ImageButton")) and v12.Image ~= "" and not v6[v12.Image] then
        v6[v12.Image] = true
        table.insert(v7, v12)
    end
    for v13, v14 in ipairs({
            v5.UFOBig,
            v5.AbductionBeam,
            v5.OpeningBurst,
            v5.Sattelite,
            v5.UFOSmall
        }) do
        if v14 and (v14:IsA("ImageLabel") or v14:IsA("ImageButton")) and v14.Image ~= "" and not v6[v14.Image] then
            v6[v14.Image] = true
            table.insert(v8, v14)
        end
    end
    for v15, v16 in ipairs(v5.decor) do
        if v16 and (v16:IsA("ImageLabel") or v16:IsA("ImageButton")) and v16.Image ~= "" and not v6[v16.Image] then
            v6[v16.Image] = true
            table.insert(v8, v16)
        end
    end
    for v17, v18 in ipairs(v5.main:GetDescendants()) do
        if v18 and (v18:IsA("ImageLabel") or v18:IsA("ImageButton")) and v18.Image ~= "" and not v6[v18.Image] then
            v6[v18.Image] = true
            table.insert(v9, v18)
        end
    end
    return { v7, v8, v9 }
end

function v1.start(v19, v20) -- line 58 | captures: v2, v3, v4, RunService, ContentProvider, CollectionService, v1, preloadLists
    local T = v19.T
    v1.stop()
    v3 = true
    v1.done = false
    v4 += 1
    local v21 = v4
    task.defer(function() -- line 65 | captures: v19, v20, T, v21, v2, v3, v4, RunService, ContentProvider, CollectionService, v1, preloadLists
        if not (v3 and v21 == v4 and v19.gui:IsDescendantOf(game)) then
            return
        end
        task.spawn(function() -- line 70 | captures: v19, v21, v3, v4, ContentProvider, preloadLists
            for v22, v23 in ipairs((preloadLists(v19))) do
                if v3 and v21 == v4 then
                    pcall(ContentProvider.PreloadAsync, ContentProvider, v23)
                else
                    return
                end
            end
        end)
        local v24 = {}
        for v25, v26 in ipairs(CollectionService:GetTagged(T.STAGGER_TAG)) do
            if v26:IsDescendantOf(v19.main) then
                for v27, v28 in ipairs(v26:GetChildren()) do
                    if v28:IsA("GuiObject") then
                        local v29 = v28

                        local function v30() -- line 84 | captures: v29, v19
                            v19.Rows.rowParts(v29)
                        end

                        table.insert(v24, v30)
                    end
                end
            end
        end

        local function v31() -- line 91 | captures: v19
            if v19.GradientLoop.hasRainbow() then
                v19.GradientLoop.warm()
            end
        end

        table.insert(v24, v31)
        local Actors = v19.Actors

        local function v32() -- line 99 | captures: Actors, v19, v20
            if v20.atRest() then
                Actors.panel.screen = v19.gui.AbsoluteSize
            end
        end

        table.insert(v24, v32)
        local v33 = Actors.count + 60
        for v34 = 1, v33, 6 do
            local v35 = v34

            local v36 = function() -- line 106 | captures: Actors, v35, v20
                if not v20.atRest() then
                    return
                end
                local v37 = v35 + 6 - 1
                local count = Actors.count
                local v38 = math.min(v37, count)
                for v39 = v35, v38 do
                    local v40 = Actors.list[v39]
                    if not v40.session then
                        Actors.refresh(v40)
                    end
                end
            end

            table.insert(v24, v36)
        end
        local v41 = table.create(T.LOWEND_FRAMES)
        local v42 = 0
        local v43 = false
        local v44 = 1
        local v45 = {
            v19.buildGlitch,
            v19.Juice.build
        }
        local v46 = 1
        local WARM_BUDGET = T.WARM_BUDGET
        v2 = RunService.Heartbeat:Connect(function(v47) -- line 127 | captures: v42, v43, v44, v46, v24, v41, v45, WARM_BUDGET, v19, v20, T, v1
            if not v43 then
                v42 += 1
                v41[v42] = v47
                local v48 = v42
                if T.LOWEND_FRAMES <= v48 then
                    v43 = true
                    table.sort(v41)
                    local v49 = v42 / 2
                    local v50 = v41[math.ceil(v49)]
                    v1.medianDt = v50
                    if T.LOWEND_DT < v50 then
                        v19.lowEnd = true
                        v20.lowEnd()
                    end
                end
            end
            local v51 = os.clock()
            while true do
                if os.clock() - v51 < WARM_BUDGET then
                    if v44 <= #v24 then
                        v24[v44]()
                        v44 += 1
                        continue
                    end
                    if v43 and v46 <= #v45 then
                        v45[v46]()
                        v46 += 1
                    end
                end
                break
            end
            if v43 then
                local v52 = v44
                if #v24 < v52 then
                    local v53 = v46
                    if #v45 < v53 then
                        v1.stop()
                        v1.done = true
                    end
                end
            end
        end)
    end)
end

function v1.stop() -- line 163 | captures: v2
    if v2 then
        v2:Disconnect()
        v2 = nil
    end
end

function v1.destroy() -- line 170 | captures: v3, v1
    v3 = false
    v1.stop()
end

return v1
