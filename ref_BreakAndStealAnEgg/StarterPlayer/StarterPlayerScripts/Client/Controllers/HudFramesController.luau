-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local UiFrames = require(script.Parent.UiFrames)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {
    Index = "Index",
    Shop = "Shop"
}
local v2 = {}

function v2.Start() -- line 30 | captures: UiFrames, MainGui, v1
    MainGui.Observe(function(v3) -- line 34 | captures: UiFrames, v1
        local LeftHUD = v3:FindFirstChild("LeftHUD")
        local Frames = v3:FindFirstChild("Frames")
        if LeftHUD and Frames then
            for v4, v5 in v1 do
                local v6 = LeftHUD:FindFirstChild(v4)
                local v7 = Frames:FindFirstChild(v5)
                if v6 and v6:IsA("GuiButton") and v7 and v7:IsA("GuiObject") then
                    v7.Visible = false
                    v6.Activated:Connect(function() -- line 46 | captures: v7, UiFrames
                        UiFrames.Toggle(v7)
                    end)
                else
                    warn((("[HudFramesController] missing HUD button '%*' or window 'Frames.%*'"):format(v4, v5)))
                end
            end
        end
    end)
end

return v2
