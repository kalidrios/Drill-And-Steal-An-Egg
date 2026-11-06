-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local CollectionService = game:GetService("CollectionService")
local v1 = {}

function v1.new() -- line 34 | captures: RunService, ContentProvider, CollectionService
    local v2 = {}
    local v3
    local v4 = true

    local function preloadLists(v5) -- line 41
        local gui = v5.gui
        local main = v5.main
        local T = v5.T
        local v6 = {}
        local v7 = {}
        local v8 = {}
        local v9 = {}

        local function put(v10, v11) -- line 45 | captures: v6
            if (v11:IsA("ImageLabel") or v11:IsA("ImageButton")) and v11.Image ~= "" and not v6[v11.Image] then
                v6[v11.Image] = true
                table.insert(v10, v11)
            end
        end

        local BG = v5.BG
        if (BG:IsA("ImageLabel") or BG:IsA("ImageButton")) and BG.Image ~= "" and not v6[BG.Image] then
            v6[BG.Image] = true
            table.insert(v7, BG)
        end
        for v12, v13 in ipairs(v5.BG:GetDescendants()) do
            if (v13:IsA("ImageLabel") or v13:IsA("ImageButton")) and v13.Image ~= "" and not v6[v13.Image] then
                v6[v13.Image] = true
                table.insert(v7, v13)
            end
        end
        local VFXAssets = gui:FindFirstChild("VFXAssets")
        if VFXAssets then
            for v14, v15 in ipairs(VFXAssets:GetChildren()) do
                if (v15:IsA("ImageLabel") or v15:IsA("ImageButton")) and v15.Image ~= "" and not v6[v15.Image] then
                    v6[v15.Image] = true
                    table.insert(v8, v15)
                end
            end
        end
        for v16, v17 in ipairs({
                v5.flames,
                v5.wings
            }) do
            for v18, v19 in ipairs(v17) do
                if (v19:IsA("ImageLabel") or v19:IsA("ImageButton")) and v19.Image ~= "" and not v6[v19.Image] then
                    v6[v19.Image] = true
                    table.insert(v8, v19)
                end
            end
        end
        for v20, v21 in ipairs(main:GetChildren()) do
            if (v21:IsA("ImageLabel") or v21:IsA("ImageButton")) and v21.Image ~= "" and not v6[v21.Image] then
                v6[v21.Image] = true
                table.insert(v7, v21)
            end
        end
        local TapBurst = gui:FindFirstChild("TapBurst")
        if not (not TapBurst or not TapBurst:IsA("ImageLabel") and not TapBurst:IsA("ImageButton")) and TapBurst.Image ~= "" and not v6[TapBurst.Image] then
            v6[TapBurst.Image] = true
            table.insert(v8, TapBurst)
        end
        for v22, v23 in ipairs(gui:GetDescendants()) do
            if (v23:IsA("ImageLabel") or v23:IsA("ImageButton")) and v23.Image ~= "" and not v6[v23.Image] then
                v6[v23.Image] = true
                table.insert(v9, v23)
            end
        end
        return { v7, v8, v9 }
    end

    function v2.start(v24, v25) -- line 79 | captures: v3, v4, v2, preloadLists, RunService, ContentProvider, CollectionService
        local T = v24.T
        task.defer(function() -- line 81 | captures: v24, v25, T, v3, v4, v2, preloadLists, RunService, ContentProvider, CollectionService
            if not (v4 and v24.gui:IsDescendantOf(game)) then
                return
            end
            task.spawn(function() -- line 86 | captures: v24, v4, preloadLists, ContentProvider
                for v26, v27 in ipairs((preloadLists(v24))) do
                    if v4 then
                        pcall(ContentProvider.PreloadAsync, ContentProvider, v27)
                    else
                        return
                    end
                end
            end)
            local v28 = {}
            for v29, v30 in ipairs(v24.grids) do
                for v31, v32 in ipairs(v30:GetChildren()) do
                    if v32:IsA("GuiObject") then
                        local v33 = v32

                        local function v34() -- line 100 | captures: v33, v24
                            v24.ShopCards.cardParts(v33)
                        end

                        table.insert(v28, v34)
                    end
                end
            end
            for v35, v36 in ipairs(CollectionService:GetTagged(T.STAGGER_TAG)) do
                if v36:IsDescendantOf(v24.main) then
                    for v37, v38 in ipairs(v36:GetChildren()) do
                        if v38:IsA("GuiObject") then
                            local v39 = v38

                            local function v40() -- line 110 | captures: v39, v24
                                v24.EggItems.itemParts(v39)
                            end

                            table.insert(v28, v40)
                        end
                    end
                end
            end

            local function v41() -- line 117 | captures: v24
                if v24.GradientLoop.hasRainbow() then
                    v24.GradientLoop.warm()
                end
            end

            table.insert(v28, v41)
            local Actors = v24.Actors

            local function v42() -- line 125 | captures: Actors, v24, v25
                if v25.atRest() then
                    Actors.panel.screen = v24.gui.AbsoluteSize
                end
            end

            table.insert(v28, v42)
            local v43 = Actors.count + 40
            for v44 = 1, v43, 6 do
                local v45 = v44

                local v46 = function() -- line 132 | captures: Actors, v45, v25
                    if not v25.atRest() then
                        return
                    end
                    local v47 = v45 + 6 - 1
                    local count = Actors.count
                    local v48 = math.min(v47, count)
                    for v49 = v45, v48 do
                        local v50 = Actors.list[v49]
                        if not v50.session and v50 ~= Actors.panel then
                            Actors.refresh(v50)
                        end
                    end
                end

                table.insert(v28, v46)
            end
            local v51 = table.create(T.LOWEND_FRAMES)
            local v52 = 0
            local v53 = false
            local v54 = 1
            local v55 = {
                v24.OpeningParticleBurst.build,
                v24.TapBurst.build
            }
            local v56 = 1
            local WARM_BUDGET = T.WARM_BUDGET
            v3 = RunService.Heartbeat:Connect(function(v57) -- line 153 | captures: v52, v53, v54, v56, v28, v51, v55, WARM_BUDGET, v24, v25, T, v2
                if not v53 then
                    v52 += 1
                    v51[v52] = v57
                    local v58 = v52
                    if T.LOWEND_FRAMES <= v58 then
                        v53 = true
                        table.sort(v51)
                        local v59 = v52 / 2
                        local v60 = v51[math.ceil(v59)]
                        v2.medianDt = v60
                        if T.LOWEND_DT < v60 then
                            v24.lowEnd = true
                            v25.lowEnd()
                        end
                    end
                end
                local v61 = os.clock()
                while true do
                    if os.clock() - v61 < WARM_BUDGET then
                        if v54 <= #v28 then
                            v28[v54]()
                            v54 += 1
                            continue
                        end
                        if v53 and v56 <= #v55 then
                            v55[v56]()
                            v56 += 1
                        end
                    end
                    break
                end
                if v53 then
                    local v62 = v54
                    if #v28 < v62 then
                        local v63 = v56
                        if #v55 < v63 then
                            v2.stop()
                            v2.done = true
                        end
                    end
                end
            end)
        end)
    end

    function v2.stop() -- line 190 | captures: v3
        if v3 then
            v3:Disconnect()
            v3 = nil
        end
    end

    function v2.destroy() -- line 197 | captures: v4, v2
        v4 = false
        v2.stop()
    end

    return v2
end

return v1
