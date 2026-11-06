-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DiscordRewardConfig = require(ReplicatedStorage.Shared.DiscordRewardConfig)
local NotificationController = require(script.Parent.NotificationController)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local v2
local v3 = {
    Claimed = false,
    Asked = false,
    Wait = 0
}
local v4 = (-1/0)
local v5, v6, v7
local v8 = Color3.new(1, 1, 1)
local v9 = (-1/0)

local function findPath(v10, v11) -- line 46
    local v12 = v10
    for v13, v14 in v11 do
        v12 = v12 and v12:FindFirstChild(v14)
    end
    return v12
end

local function paint() -- line 54 | captures: v3, v6, v7, v8, DiscordRewardConfig
    if v6 then
        v6.Active = true
        v6.AutoButtonColor = not v3.Claimed
        local v15 = v6
        if v3.Claimed then
            v15.BackgroundColor3 = DiscordRewardConfig.LockedTint
        else
            v15.BackgroundColor3 = v8
        end
    end
    if not v7 then
        return
    end
    local v16 = v7
    if v3.Claimed then
        v16.Text = DiscordRewardConfig.ClaimedText
    else
        v16.Text = DiscordRewardConfig.VerifyText
    end
end

local function verify() -- line 65 | captures: v2, v3, v4, v5, v9, DiscordRewardConfig, NotificationController
    local v17 = os.clock()
    if v17 - v9 < DiscordRewardConfig.PressDebounce then
        return
    end
    if not v3.Claimed and v3.Asked and v17 - v4 < DiscordRewardConfig.AskDebounce then
        return
    end
    v9 = v17
    local v18 = if v5 then v5.Text else ""
    local v19 = DiscordRewardConfig.InputDenial(v3, v18)
    if v19 then
        NotificationController.Show(v19, "Error")
    elseif v2 then
        v2:FireServer("Verify", v18)
    end
end

local function adopt(v20) -- line 89 | captures: v3, v5, v6, v7, v8, DiscordRewardConfig, verify
    v5 = nil
    v6 = nil
    v7 = nil
    local v21 = v20
    for v22, v23 in DiscordRewardConfig.CardPath do
        v21 = v21 and v21:FindFirstChild(v23)
    end
    if not v21 then
        return
    end
    local v24 = v21
    for v25, v26 in DiscordRewardConfig.TextBoxPath do
        v24 = v24 and v24:FindFirstChild(v26)
    end
    if not (v24 and v24:IsA("TextBox")) then
        v24 = v21:FindFirstChildWhichIsA("TextBox", true)
    end
    if v24 and v24:IsA("TextBox") then
        v5 = v24
        v24.FocusLost:Connect(function(v27) -- line 105 | captures: verify
            if v27 then
                verify()
            end
        end)
    end
    for v28, v29 in DiscordRewardConfig.VerifyButtonPath do
        v21 = v21 and v21:FindFirstChild(v29)
    end
    if v21 and v21:IsA("GuiButton") then
        v6 = v21
        v8 = v21.BackgroundColor3
        local v30 = v21:FindFirstChild(DiscordRewardConfig.VerifyTitleName)
        if v30 and v30:IsA("TextLabel") then
            v7 = v30
        end
        v21.Activated:Connect(verify)
    end
    if v6 then
        v6.Active = true
        v6.AutoButtonColor = not v3.Claimed
        local v31 = v6
        if v3.Claimed then
            v31.BackgroundColor3 = DiscordRewardConfig.LockedTint
        else
            v31.BackgroundColor3 = v8
        end
    end
    if v7 then
        local v32 = v7
        if v3.Claimed then
            v32.Text = DiscordRewardConfig.ClaimedText
        else
            v32.Text = DiscordRewardConfig.VerifyText
        end
    end
end

function v1.Start() -- line 127 | captures: v2, v3, v4, v6, v7, v8, ReplicatedStorage, DiscordRewardConfig, MainGui, adopt
    MainGui.Observe(adopt)
    local v33 = ReplicatedStorage:WaitForChild(DiscordRewardConfig.RemoteName, 30)
    if not (v33 and v33:IsA("RemoteEvent")) then
        return
    end
    v2 = v33
    v33.OnClientEvent:Connect(function(v34, v35) -- line 135 | captures: v3, v4, v6, v7, v8, DiscordRewardConfig
        local Asked, v36
        if v34 == "State" and typeof(v35) == "table" then
            Asked = v3.Asked
            v36 = {}
            v36.Claimed = v35.Claimed == true
        else
            return
        end
        v36.Asked = v35.Asked == true
        local Wait = v35.Wait
        if typeof(Wait) == "number" then
            local Wait = v35.Wait
            v36.Wait = math.max(Wait, 0)
        else
            v36.Wait = 0
        end
        v3 = v36
        if v3.Asked and not Asked then
            v4 = os.clock()
        end
        if v6 then
            v6.Active = true
            v6.AutoButtonColor = not v3.Claimed
            local v37 = v6
            if v3.Claimed then
                v37.BackgroundColor3 = DiscordRewardConfig.LockedTint
            else
                v37.BackgroundColor3 = v8
            end
        end
        if not v7 then
            return
        end
        local v38 = v7
        if v3.Claimed then
            v38.Text = DiscordRewardConfig.ClaimedText
        else
            v38.Text = DiscordRewardConfig.VerifyText
        end
    end)
    v33:FireServer("Get")
end

return v1
