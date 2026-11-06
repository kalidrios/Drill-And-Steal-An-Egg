-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local UiFrames = require(script.Parent.UiFrames)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local v2 = { "Shop", "SpeedShop" }
local v3 = false

function v1.Start() -- line 28 | captures: v3, UiFrames, MainGui, v2
    MainGui.Observe(function(v4) -- line 31 | captures: v3, UiFrames, v2
        local LeftHUD = v4:FindFirstChild("LeftHUD")
        local Frames = v4:FindFirstChild("Frames")
        local v5 = Frames and Frames:FindFirstChild("Shop")
        if LeftHUD and v5 and v5:IsA("GuiObject") then
            local v6 = {}
            for v7, v8 in v2 do
                local v9 = LeftHUD:FindFirstChild(v8)
                local v10 = v9 and v9:FindFirstChild("Notification")
                if v10 and v10:IsA("GuiObject") then
                    v10.Visible = not v3
                    table.insert(v6, v10)
                else
                    warn((("[ShopBadgeController] missing LeftHUD.%*.Notification"):format(v8)))
                end
            end
            if not v3 then
                UiFrames.Observe(v5, function(v11) -- line 56 | captures: v6, v3
                    if v11 and not v3 then
                        v3 = true
                        for v12, v13 in v6 do
                            v13.Visible = false
                        end
                    end
                end)
            end
        else
            warn("[ShopBadgeController] missing LeftHUD or Frames.Shop")
        end
    end)
end

return v1
