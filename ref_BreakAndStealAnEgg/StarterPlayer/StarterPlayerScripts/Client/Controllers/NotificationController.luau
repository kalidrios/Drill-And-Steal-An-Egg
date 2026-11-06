-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local NotificationConfig = require(ReplicatedStorage.Shared.NotificationConfig)
local GuiFade = require(script.Parent.Parent.Modules.GuiFade)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2 = TweenInfo.new(NotificationConfig.ShowTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(NotificationConfig.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = 0
local v5 = {}
local v6 = {}
local v7 = {}

local function isHeld() -- line 65 | captures: v6
    return next(v6) ~= nil
end

local v8, Parent, v9

local function getNotificationsFrame() -- line 75 | captures: v8, LocalPlayer
    if v8 and v8.Parent then
        return v8
    end
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v10 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v11 = v10 and v10:FindFirstChild("Notifications")
    if not (v11 and v11:IsA("Frame")) then
        return nil
    end
    return v11
end

local function escapeRichText(v12) -- line 88
    return (v12:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"):gsub("'", "&apos;"))
end

local function formatMessage(v13, v14) -- line 94 | captures: NotificationConfig, escapeRichText
    local v15 = NotificationConfig.Styles[v14] or NotificationConfig.Styles.Info
    local v16 = escapeRichText(v13)
    local KeyWords = v15.KeyWords
    return (string.gsub(v16, "{(.-)}", function(v17) -- line 98 | captures: KeyWords, NotificationConfig
        local v18, v19 = string.match(v17, "^(%a+):(.*)$")
        local v20 = v18 and NotificationConfig.NamedColors[string.lower(v18)]
        if not v20 then
            v19 = v17
        end
        local v21 = if KeyWords then v20 or KeyWords else nil
        if v21 then
            return (("<font color=\"#%*\">%*</font>"):format(v21:ToHex(), v19))
        end
        return v19
    end))
end

local function plainMessage(v22) -- line 111
    local v23 = string.gsub(v22, "{%a+:", "")
    return (string.gsub(v23, "[{}]", ""))
end

local function applyKind(v24, v25, v26) -- line 119 | captures: NotificationConfig, escapeRichText
    local Texts = v24:FindFirstChild("Texts")
    local v27 = Texts and Texts:FindFirstChild("Main")
    local v28
    if v27 and v27:IsA("TextLabel") then
        v28 = NotificationConfig.Styles[v26] or NotificationConfig.Styles.Info
    else
        return
    end
    v27.RichText = true
    v27.TextColor3 = v28.Text
    local v29 = NotificationConfig.Styles[v26] or NotificationConfig.Styles.Info
    local v30 = escapeRichText(v25)
    local KeyWords = v29.KeyWords
    v27.Text = string.gsub(v30, "{(.-)}", function(v31) -- line 98 | captures: KeyWords, NotificationConfig
        local v32, v33 = string.match(v31, "^(%a+):(.*)$")
        local v34 = v32 and NotificationConfig.NamedColors[string.lower(v32)]
        if not v34 then
            v33 = v31
        end
        local v35 = if KeyWords then v34 or KeyWords else nil
        if v35 then
            return (("<font color=\"#%*\">%*</font>"):format(v35:ToHex(), v33))
        end
        return v33
    end)
    for v36, v37 in v27:GetChildren() do
        if v37:IsA("UIGradient") then
            v37.Enabled = false
        elseif v37:IsA("UIStroke") then
            v37.Color = NotificationConfig.StrokeColor
            local UIGradient = v37:FindFirstChildWhichIsA("UIGradient")
            if UIGradient then
                UIGradient.Enabled = false
            end
        end
    end
end

local function findTemplate(v38) -- line 143 | captures: NotificationConfig
    for v39, v40 in NotificationConfig.TemplateNames do
        local v41 = v38:FindFirstChild(v40)
        if v41 and v41:IsA("GuiObject") then
            return v41
        end
    end
    return nil
end

local v42

local function playPopupSound(v43, v44, v45) -- line 160 | captures: v42, Debris, SoundService, NotificationConfig
    if v45 ~= false then
        local v46
        if v45 then
            v46 = v45
        else
            local MessageSounds = NotificationConfig.MessageSounds
            local v47 = string.gsub(v43, "{%a+:", "")
            v46 = MessageSounds[string.gsub(v47, "[{}]", "")] or NotificationConfig.Sounds[v44]
        end
        if v46 then
            if not (v42 and v42.Parent) then
                v42 = SoundService:FindFirstChild(NotificationConfig.SoundFolderName)
            end
            local v48 = v42 and v42:FindFirstChild(v46)
            local v49
            if v48 and v48:IsA("Sound") then
                v49 = v48:Clone()
                local v50 = NotificationConfig.SoundPitchVariance[v46]
                if v50 then
                    v49.PlaybackSpeed *= 1 + (math.random() * 2 - 1) * v50
                end
            else
                return
            end
            v49.Parent = SoundService
            local Ended = v49.Ended
            local v51 = v49
            Ended:Once(function() -- line 187 | captures: v51
                v51:Destroy()
            end)
            local TimeLength = v49.TimeLength
            Debris:AddItem(v49, math.max(TimeLength, 1) + 1)
            v49:Play()
        end
    end
end

local function prunePopups(v52) -- line 198 | captures: NotificationConfig, v5
    local v53 = #v5
    for v54 = v53, 1, -1 do
        if v5[v54].Parent ~= v52 then
            table.remove(v5, v54)
        end
    end
    while true do
        local v55 = #v5
        if NotificationConfig.MaxVisible < v55 then
            local v56 = table.remove(v5, 1)
            if v56 then
                v56:Destroy()
            end
        else
            break
        end
    end
end

function v1.Show(v57, v58, v59) -- line 213 | captures: v4, v7, v8, TweenService, NotificationConfig, GuiFade, LocalPlayer, v2, v3, v5, v6, applyKind, findTemplate, playPopupSound, prunePopups
    if next(v6) ~= nil then
        local v60 = v7
        local v61 = {
            message = v57,
            kind = v58,
            options = v59
        }
        table.insert(v60, v61)
        while true do
            local v62 = #v7
            if NotificationConfig.MaxVisible < v62 then
                table.remove(v7, 1)
                continue
            end
            break
        end
    else
        local v63
        if v8 and v8.Parent then
            v63 = v8
        else
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
            PlayerGui = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
            v63 = PlayerGui and PlayerGui:FindFirstChild("Notifications")
            if not (v63 and v63:IsA("Frame")) then
                v63 = nil
            end
        end
        local v64, playPopupSound_2, v65, v66, v67
        if v63 then
            local v68 = findTemplate(v63)
            if v68 then
                v68.Visible = false
                v64 = v68:Clone()
                v64.Name = "ActiveNotification"
                applyKind(v64, v57, v58 or "Info")
                playPopupSound_2 = playPopupSound
                v65 = v58 or "Info"
                v66 = v59 and v59.Sound
                v67 = false
            else
                v67 = true
            end
        else
            v67 = true
        end
        if v67 then
            return
        end
        playPopupSound_2(v57, v65, v66)
        local Time = v59 and v59.Time or NotificationConfig.HoldTime
        local v69 = if v64:IsA("CanvasGroup") then v64 else nil
        local v70
        if v69 then
        else
            v70 = GuiFade.Capture(v64)
        end
        v4 += 1
        v64.LayoutOrder = v4
        if v69 then
            v69.GroupTransparency = 1
        elseif v70 then
            GuiFade.Set(v70, 1)
        end
        v64.Visible = true
        v64.Parent = v63
        table.insert(v5, v64)
        prunePopups(v63)
        if v69 then
            TweenService:Create(v69, v2, { GroupTransparency = 0 }):Play()
        elseif v70 then
            GuiFade.Tween(v70, v2, 0)
        end
        local delay = task.delay
        local v71 = NotificationConfig.ShowTime + Time
        local v72 = v64
        local v73 = v63
        local v74 = v69
        local v75 = v70
        delay(v71, function() -- line 260 | captures: v72, v73, v74, v75, TweenService, NotificationConfig, GuiFade, v3
            if v72.Parent == v73 then
                if v74 then
                    TweenService:Create(v74, v3, { GroupTransparency = 1 }):Play()
                elseif v75 then
                    GuiFade.Tween(v75, v3, 1)
                end
                task.delay(NotificationConfig.FadeTime, function() -- line 269 | captures: v72
                    v72:Destroy()
                end)
            end
        end)
    end
end

function v1.Hold(v76) -- line 276 | captures: v6
    v6[v76] = true
end

function v1.Release(v77) -- line 281 | captures: v7, v1, v6
    if v6[v77] then
        v6[v77] = nil
        if next(v6) == nil then
            local v78 = v7
            v7 = {}
            for v79, v80 in v78 do
                v1.Show(v80.message, v80.kind, v80.options)
            end
        end
    end
end

local function returnRaisedFrame() -- line 300 | captures: v8, Parent, v9, LocalPlayer
    local v81 = v8
    local Parent_2 = Parent
    v8 = nil
    Parent = nil
    v9 = nil
    if v81 and v81.Parent then
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not (Parent_2 and Parent_2.Parent == PlayerGui) then
            v81:Destroy()
        else
            v81.Parent = Parent_2
        end
    end
end

function v1.Raise(v82) -- line 317 | captures: v8, Parent, v9, LocalPlayer
    if v9 == v82 and v8 and v8.Parent == v82 then
        return
    end
    local v83 = v8
    local Parent_2 = Parent
    v8 = nil
    Parent = nil
    v9 = nil
    if v83 and v83.Parent then
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not (Parent_2 and Parent_2.Parent == PlayerGui) then
            v83:Destroy()
        else
            v83.Parent = Parent_2
        end
    end
    local v84
    if v8 and v8.Parent then
        v84 = v8
    else
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        PlayerGui = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
        v84 = PlayerGui and PlayerGui:FindFirstChild("Notifications")
        if not (v84 and v84:IsA("Frame")) then
            v84 = nil
        end
    end
    if not v84 then
        return
    end
    Parent = v84.Parent
    v9 = v82
    v8 = v84
    v84.Parent = v82
end

function v1.Lower(v85) -- line 333 | captures: v8, Parent, v9, LocalPlayer
    if v9 ~= v85 then
        return
    end
    local v86 = v8
    local Parent_2 = Parent
    v8 = nil
    Parent = nil
    v9 = nil
    if v86 then
        if v86.Parent then
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if Parent_2 and Parent_2.Parent == PlayerGui then
                v86.Parent = Parent_2
                return
            end
        else
            return
        end
        v86:Destroy()
    end
end

function v1.ShowPreset(v87, ...) -- line 341 | captures: NotificationConfig, v1
    local v88, v89, v90 = NotificationConfig.Build(v87, ...)
    v1.Show(v88, v89, v90)
end

local function readOptions(v91) -- line 347
    if typeof(v91) == "table" then
        local v92 = {}
        local Time = v91.Time
        if typeof(Time) == "number" then
            v92.Time = v91.Time
        else
            v92.Time = nil
        end
        local Sound = v91.Sound
        if typeof(Sound) == "string" or v91.Sound == false then
            v92.Sound = v91.Sound
        else
            v92.Sound = nil
        end
        return v92
    end
    return nil
end

function v1.Start() -- line 358 | captures: ReplicatedStorage, NotificationConfig, v1, readOptions
    local v93 = ReplicatedStorage:WaitForChild(NotificationConfig.RemoteName, 30)
    if not v93 then
        warn("[NotificationController] Notify remote slow to arrive \226\128\148 still waiting")
        v93 = ReplicatedStorage:WaitForChild(NotificationConfig.RemoteName)
    end
    if v93:IsA("RemoteEvent") then
        v93.OnClientEvent:Connect(function(v94, v95, v96) -- line 373 | captures: v1, readOptions
            if typeof(v94) ~= "string" then
                return
            end
            local Show = v1.Show
            local v97 = if typeof(v95) == "string" then v95 else "Info"
            Show(v94, v97, (readOptions(v96)))
        end)
    else
        warn("[NotificationController] Notify remote is not a RemoteEvent \226\128\148 server popups disabled")
    end
end

return v1
