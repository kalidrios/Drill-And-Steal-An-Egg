-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopTimerConfig = require(ReplicatedStorage.Shared.ShopTimerConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local v2 = {}

local function resolve(v3, v4) -- line 25
    local v5 = v3
    for v6, v7 in v4 do
        v5 = v5 and v5:FindFirstChild(v7)
    end
    return v5
end

local function refresh() -- line 33 | captures: ShopTimerConfig, v2
    local v8 = workspace:GetServerTimeNow()
    for v9, v10 in v2 do
        local v11 = v10.Target.EndsAt - v8
        local v12
        if v11 > 0 then
            v12 = ShopTimerConfig.Format(v11)
        else
            v12 = v10.Target.EndedText
        end
        if v10.Label.Text ~= v12 then
            v10.Label.Text = v12
        end
    end
end

local function bind(v13) -- line 44 | captures: ShopTimerConfig, v2, refresh
    table.clear(v2)
    for v14, v15 in ShopTimerConfig.Targets do
        local v16 = v13
        for v17, v18 in v15.Path do
            v16 = v16 and v16:FindFirstChild(v18)
        end
        if v16 and v16:IsA("TextLabel") then
            local v19 = {
                Label = v16,
                Target = v15
            }
            table.insert(v2, v19)
        else
            warn((("[ShopTimerController] missing TextLabel MainGUI.%*"):format((table.concat(v15.Path, ".")))))
        end
    end
    refresh()
end

function v1.Start() -- line 58 | captures: ShopTimerConfig, MainGui, refresh, bind
    MainGui.Observe(bind)
    while true do
        task.wait(ShopTimerConfig.UpdateInterval)
        refresh()
    end
end

return v1
