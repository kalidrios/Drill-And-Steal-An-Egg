-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local UiFrames = require(script.Parent.UiFrames)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local v2 = { MergeMachine = true }

local function wireWindow(v3) -- line 27 | captures: UiFrames, v2
    if v2[v3.Name] then
        return
    end

    local function tryWire(v4) -- line 31 | captures: v3, UiFrames
        if v4.Name == "Close" and v4:IsA("GuiButton") then
            v4.Activated:Connect(function() -- line 33 | captures: v3, UiFrames
                UiFrames.Close(v3)
            end)
        end
    end

    for v5, v6 in v3:GetDescendants() do
        if v6.Name == "Close" and v6:IsA("GuiButton") then
            v6.Activated:Connect(function() -- line 33 | captures: v3, UiFrames
                UiFrames.Close(v3)
            end)
        end
    end
    v3.DescendantAdded:Connect(tryWire)
end

function v1.Start() -- line 45 | captures: MainGui, wireWindow
    MainGui.Observe(function(v7) -- line 48 | captures: wireWindow
        local Frames = v7:FindFirstChild("Frames")
        if Frames then
            for v8, v9 in Frames:GetChildren() do
                if v9:IsA("GuiObject") then
                    wireWindow(v9)
                end
            end
            Frames.ChildAdded:Connect(function(v10) -- line 59 | captures: wireWindow
                if v10:IsA("GuiObject") then
                    wireWindow(v10)
                end
            end)
        end
    end)
end

return v1
