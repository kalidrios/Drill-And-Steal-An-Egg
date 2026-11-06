-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local app = require(script.app)
local conch = require(script.Parent.roblox_packages.conch)
local state = require(script.state)
local vide = require(script.Parent.roblox_packages.vide)
local v1 = false
local opened = state.opened
local focused = state.focused

local function mount() -- line 12 | captures: v1, Players, app, vide
    if v1 then
        return
    end
    v1 = true
    return vide.mount(app, Players.LocalPlayer:WaitForChild("PlayerGui"))
end

return {
    app = app,
    mount = mount,
    opened = opened,
    bind_to = function(v2) -- bind_to | line 18 | captures: v1, Players, UserInputService, app, vide, opened, focused
        if not v1 then
            v1 = true
            vide.mount(app, Players.LocalPlayer:WaitForChild("PlayerGui"))
        end
        UserInputService.InputBegan:Connect(function(v3) -- line 20 | captures: v2, opened, focused
            if v3.KeyCode == v2 or v3.UserInputType == v2 then
                opened(not opened())
                focused(opened())
            end
        end)
    end,
    conch = conch
}
