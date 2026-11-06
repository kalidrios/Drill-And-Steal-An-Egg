-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopSpeedFocusConfig = require(ReplicatedStorage.Shared.ShopSpeedFocusConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local ScrollToChild = require(script.Parent.Parent.Modules.ScrollToChild)
local UiFrames = require(script.Parent.UiFrames)
local v1 = {}
local v2 = 0
local v3, focus, v4

local function resolve(v5, v6) -- line 44
    local v7 = v5
    for v8, v9 in v6 do
        v7 = v7 and v7:FindFirstChild(v9)
    end
    return v7
end

local function bind(v10) -- line 52 | captures: v2, v3, focus, v4, ShopSpeedFocusConfig, ScrollToChild, UiFrames
    local v11 = v10
    for v12, v13 in {
            "Frames",
            ShopSpeedFocusConfig.ShopFrame
        } do
        v11 = v11 and v11:FindFirstChild(v13)
    end
    local v14 = v11 and v11:FindFirstChild(ShopSpeedFocusConfig.ScrollingFrame)
    local v15 = v14 and v14:FindFirstChild(ShopSpeedFocusConfig.SectionHeader)
    if v11 and v11:IsA("GuiObject") and v14 and v14:IsA("ScrollingFrame") and v15 and v15:IsA("GuiObject") then
        local v16 = {}
        for v17, v18 in ShopSpeedFocusConfig.SectionCards do
            local v19 = v14:FindFirstChild(v18, true)
            if v19 and v19:IsA("GuiObject") then
                table.insert(v16, v19)
            end
        end
        local v20 = v11

        local function focus_2(v21, v22, v23) -- line 77 | captures: v14, v20, v2, ShopSpeedFocusConfig, ScrollToChild, UiFrames
            v2 += 1
            local v24 = v2

            local function glide() -- line 80 | captures: v21, v22, v23, v24, v14, v20, v2, ShopSpeedFocusConfig, ScrollToChild, UiFrames
                local TweenToSection, v25, v26, v27, v28
                if v24 == v2 and UiFrames.IsOpen(v20) then
                    TweenToSection = ScrollToChild.TweenToSection
                    v25 = v14
                    v26 = v21
                    v27 = v22
                    v28 = v23 or ShopSpeedFocusConfig.ScrollTweenInfo
                else
                    return
                end
                TweenToSection(v25, v26, v27, v28)
            end

            task.defer(glide)
            task.delay(ShopSpeedFocusConfig.SettleDelay, glide)
        end

        v3 = v11
        v4 = v14
        focus = focus_2

        local function toggle() -- line 98 | captures: v14, v16, v20, v15, v2, ShopSpeedFocusConfig, ScrollToChild, UiFrames
            if UiFrames.IsOpen(v20) then
                v2 += 1
                ScrollToChild.Cancel(v14)
                UiFrames.Close(v20)
            else
                UiFrames.Open(v20)
                v2 += 1
                local v29 = v2
                local v30

                local function glide() -- line 80 | captures: v29, v30, v14, v16, v20, v15, v2, ShopSpeedFocusConfig, ScrollToChild, UiFrames
                    local TweenToSection, v31, v32, v33, v34
                    if v29 == v2 and UiFrames.IsOpen(v20) then
                        TweenToSection = ScrollToChild.TweenToSection
                        v31 = v14
                        v32 = v15
                        v33 = v16
                        v34 = v30 or ShopSpeedFocusConfig.ScrollTweenInfo
                    else
                        return
                    end
                    TweenToSection(v31, v32, v33, v34)
                end

                task.defer(glide)
                task.delay(ShopSpeedFocusConfig.SettleDelay, glide)
            end
        end

        for v35, v36 in ShopSpeedFocusConfig.ToggleButtons do
            local v37 = v10
            for v38, v39 in v36 do
                v37 = v37 and v37:FindFirstChild(v39)
            end
            if v37 and v37:IsA("GuiButton") then
                v37.Activated:Connect(toggle)
            else
                warn((("[ShopSpeedFocusController] missing MainGUI.%*"):format((table.concat(v36, ".")))))
            end
        end
        local LeftHUD = v10:FindFirstChild("LeftHUD")
        local v40 = LeftHUD and LeftHUD:FindFirstChild("Shop")
        if v40 and v40:IsA("GuiButton") then
            v40.Activated:Connect(function() -- line 122 | captures: v2
                v2 += 1
            end)
        end
    else
        warn("[ShopSpeedFocusController] missing Shop window, its ScrollingFrame, or the speed section header")
    end
end

function v1.OpenOnSection(v41, v42, v43) -- line 132 | captures: v3, focus, v4, UiFrames
    local v44 = v3
    local v45 = v4
    local focus_2 = focus
    if v44 and v45 and focus_2 and v44.Parent then
        local v46 = v45:FindFirstChild(v41, true)
        if not (v46 and v46:IsA("GuiObject")) then
            warn((("[ShopSpeedFocusController] missing Shop section header %*"):format(v41)))
            return false
        end
        local v47 = {}
        for v48, v49 in v42 do
            local v50 = v45:FindFirstChild(v49, true)
            if v50 and v50:IsA("GuiObject") then
                table.insert(v47, v50)
            end
        end
        if not UiFrames.IsOpen(v44) then
            UiFrames.Open(v44)
        end
        focus_2(v46, v47, v43)
        return true
    end
    return false
end

function v1.Start() -- line 156 | captures: MainGui, bind
    MainGui.Observe(bind)
end

return v1
