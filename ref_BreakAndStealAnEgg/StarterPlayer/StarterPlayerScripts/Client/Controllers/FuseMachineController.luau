-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalEggsConfig = require(ReplicatedStorage.Shared.AnimalEggsConfig)
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local EggTypeConfig = require(ReplicatedStorage.Shared.EggTypeConfig)
local FuseMachineConfig = require(ReplicatedStorage.Shared.FuseMachineConfig)
local MutationConfig = require(ReplicatedStorage.Shared.MutationConfig)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local ZoneDisplayInfo = require(ReplicatedStorage.Shared.ZoneDisplayInfo)
local MergeRevealFX = require(script.Parent.MergeRevealFX)
local MergeSfx = require(script.Parent.MergeSfx)
local NewItemController = require(script.Parent.NewItemController)
local NotificationController = require(script.Parent.NotificationController)
local SciFiTradeInUIController = require(script.Parent.SciFiTradeInUIController)
local FuseMachineChances = require(script.Parent.Parent.Modules.FuseMachineChances)
local FuseMachineFlow = require(script.Parent.Parent.Modules.FuseMachineFlow)
local FuseMachinePicker = require(script.Parent.Parent.Modules.FuseMachinePicker)
local SFX = require(script.Parent.Parent.Modules.SciFiTradeInUI.SFX)
local v1 = {}
local v2 = Color3.new(0, 0, 0)
local LocalPlayer = Players.LocalPlayer
local v3
local v4 = {}
local v5 = false
local v6
local v7 = {}
local v8
local v9 = {}

local function setText(v10, v11, v12) -- line 80
    local v13 = v10 and v10:FindFirstChild(v11)
    if v13 and v13:IsA("TextLabel") then
        v13.Text = v12
        return v13
    end
    return nil
end

local function setRender(v14, v15, v16, v17) -- line 91 | captures: AnimalRenders, v2
    local v18 = v14 and v14:FindFirstChild("Pet")
    if not v18 or not v18:IsA("ImageLabel") and not v18:IsA("ImageButton") then
        return
    end
    AnimalRenders.Apply(v18, v15, v16)
    if v17 then
        v18.ImageColor3 = v2
    else
        v18.ImageColor3 = Color3.new(1, 1, 1)
    end
end

local function paintRarity(v19, v20) -- line 99 | captures: RarityGradientFX
    local v21 = v19 and v19:FindFirstChild("Rarity")
    if not (v21 and v21:IsA("TextLabel")) then
        v21 = nil
    else
        v21.Text = v20
    end
    if v21 then
        RarityGradientFX.ApplyToLabel(v21, v20)
    end
end

local function paintFoundIn(v22, v23) -- line 109 | captures: EggRewards, FuseMachineConfig, ZoneDisplayInfo
    local v24 = FuseMachineConfig.FoundInText(v23)
    local v25 = v22 and v22:FindFirstChild("FoundInWorld")
    if not (v25 and v25:IsA("TextLabel")) then
        v25 = nil
    else
        v25.Text = v24
    end
    if not v25 then
        return
    end
    local v26 = EggRewards.HomeZoneOf(v23)
    local v27 = v26 and ZoneDisplayInfo[("Zone%*"):format(v26)]
    local ZoneGradient = v25:FindFirstChild("ZoneGradient")
    if v27 then
        if not (ZoneGradient and ZoneGradient:IsA("UIGradient")) then
            ZoneGradient = Instance.new("UIGradient")
            ZoneGradient.Name = "ZoneGradient"
            ZoneGradient.Rotation = 90
            ZoneGradient.Parent = v25
        end
        v25.TextColor3 = Color3.new(1, 1, 1)
        ZoneGradient.Color = v27.Gradient
    elseif ZoneGradient then
        ZoneGradient:Destroy()
    end
end

local function missingCount() -- line 133 | captures: v4, FuseMachineConfig
    local v28 = 0
    for v29, v30 in FuseMachineConfig.Requirements do
        if v4[v30] == nil then
            v28 += 1
        end
    end
    return v28
end

local function refresh(v31) -- line 145 | captures: v4, v8, EggRewards, FuseMachineConfig, MutationConfig, RarityGradientFX, FuseMachineFlow, v7, setRender, paintFoundIn
    local v32 = {}
    for v33, v34 in FuseMachineConfig.Requirements do
        v32[v33] = v4[v34] ~= nil
        local v35 = v7[v33]
        if v35 then
            local v36 = v4[v34]
            local Empty = v35:FindFirstChild("Empty")
            local Full = v35:FindFirstChild("Full")
            local v37 = EggRewards.RarityOf(v34) or "Common"
            local v38 = EggRewards.DisplayName(v34)
            paintFoundIn(v35, v34)
            if Empty and Empty:IsA("GuiObject") then
                Empty.Visible = v36 == nil
                local v39 = Empty:FindFirstChild("Name")
                if v39 and v39:IsA("TextLabel") then
                    v39.Text = v38
                end
                local v40 = Empty:FindFirstChild("Rarity")
                if v40 and v40:IsA("TextLabel") then
                    v40.Text = v37
                else
                    v40 = nil
                end
                if v40 then
                    RarityGradientFX.ApplyToLabel(v40, v37)
                end
                setRender(Empty, v34, nil, true)
                local v41 = Empty:FindFirstChild("Amount")
                if v41 and v41:IsA("TextLabel") then
                    v41.Text = "0/1"
                end
            end
            if Full and Full:IsA("GuiObject") then
                Full.Visible = v36 ~= nil
                if v36 then
                    local v42 = MutationConfig.PrefixName(v36.Mutation, v38)
                    local v43 = Full:FindFirstChild("Name")
                    if v43 and v43:IsA("TextLabel") then
                        v43.Text = v42
                    end
                    local v44 = v36.Rarity or v37
                    local v45 = Full:FindFirstChild("Rarity")
                    if v45 and v45:IsA("TextLabel") then
                        v45.Text = v44
                    else
                        v45 = nil
                    end
                    if v45 then
                        RarityGradientFX.ApplyToLabel(v45, v44)
                    end
                    setRender(Full, v34, v36.Variant, false)
                end
            end
        end
    end
    FuseMachineFlow.Set(v32, v31 == true)
    if not v8 then
        return
    end
    local v46 = 0
    for v47, v48 in FuseMachineConfig.Requirements do
        if v4[v48] == nil then
            v46 += 1
        end
    end
    local v49 = v8
    if v46 == 0 then
        v49.Text = "Fuse!"
    elseif v46 == 1 then
        v49.Text = "1 Pet Left"
    else
        v49.Text = ("%* Pets Left"):format(v46)
    end
end

local function send(v50, ...) -- line 189 | captures: v3
    if v3 then
        v3:FireServer(v50, ...)
    end
end

local function onAdd(v51) -- line 195 | captures: v4, EggRewards, ZoneDisplayInfo, NotificationController, FuseMachinePicker, send
    if not v4[v51] then
        if #FuseMachinePicker.Candidates(v51) == 0 then
            local v52 = EggRewards.HomeZoneOf(v51)
            local v53 = v52 and ZoneDisplayInfo[("Zone%*"):format(v52)]
            local ShowPreset = NotificationController.ShowPreset
            local v54 = EggRewards.DisplayName(v51)
            local v55
            if v53 then
                v55 = v53.Name
            elseif v52 then
                v55 = ("Zone %*"):format(v52)
            else
                v55 = "world"
            end
            ShowPreset("FuseMissingAnimal", v54, v55)
        else
            FuseMachinePicker.Open(v51, function(v56) -- line 209 | captures: v51, send
                send("Deposit", v51, v56)
            end)
        end
    end
end

local function onSacrifice() -- line 214 | captures: v4, FuseMachineConfig, NotificationController, send
    local v57 = 0
    for v58, v59 in FuseMachineConfig.Requirements do
        if v4[v59] == nil then
            v57 += 1
        end
    end
    if v57 > 0 then
        local ShowPreset = NotificationController.ShowPreset
        local v60
        if v57 == 1 then
            v60 = "1 pet"
        else
            v60 = ("%* pets"):format(v57)
        end
        ShowPreset("FuseNotReady", v60)
    else
        send("Fuse")
    end
end

local function connectButton(v61, v62) -- line 223 | captures: v9
    local function v63(v64, ...)
        table.insert(v64, ...)
    end

    if v61 and v61:IsA("GuiButton") then
        v63(v9, v61.Activated:Connect(v62))
    end
end

local function bind(v65) -- line 233 | captures: v4, v6, v8, EggTypeConfig, FuseMachineConfig, FuseMachineChances, FuseMachineFlow, FuseMachinePicker, v7, v9, refresh, send, onAdd, onSacrifice
    local function v66(...)
        return (tonumber(...))
    end

    local function v67(v68, ...)
        table.insert(v68, ...)
    end

    local function v69(v70, ...)
        table.insert(v70, ...)
    end

    local function v71(v72, ...)
        table.insert(v72, ...)
    end

    local function v73(v74, ...)
        table.insert(v74, ...)
    end

    if not (v65.Name == "SciFi UI" and v65:IsA("ScreenGui") and v65 ~= v6) then
        return
    end
    local v75 = v65:WaitForChild("SciFiTradeInMain", 10)
    if v75 then
        for v76, v77 in v9 do
            v77:Disconnect()
        end
        table.clear(v9)
        table.clear(v7)
        v6 = v65
        FuseMachineChances.Fill(v75)
        FuseMachineFlow.Bind(v75)
        local SciFiTradeInInventory = v65:FindFirstChild("SciFiTradeInInventory")
        if SciFiTradeInInventory then
            FuseMachinePicker.Bind(SciFiTradeInInventory)
        end
        local SacrificeInputs = v75:FindFirstChild("SacrificeInputs")
        if SacrificeInputs then
            for v78, v79 in SacrificeInputs:GetChildren() do
                local v80 = v66(string.match(v79.Name, "^Input(%d+)$"))
                if v80 and v79:IsA("GuiObject") then
                    local v81 = FuseMachineConfig.Requirements[v80]
                    v79.Visible = v81 ~= nil
                    if v81 then
                        v7[v80] = v79
                        local Empty = v79:FindFirstChild("Empty")
                        local Full = v79:FindFirstChild("Full")
                        local v82 = Empty and Empty:FindFirstChild("Add")

                        local function v83() -- line 271 | captures: v81, onAdd
                            onAdd(v81)
                        end

                        if v82 and v82:IsA("GuiButton") then
                            v67(v9, v82.Activated:Connect(v83))
                        end
                        local v84 = Full and Full:FindFirstChild("Return")

                        local function v85() -- line 274 | captures: v81, v4, send
                            if v4[v81] then
                                send("Return", v81)
                            end
                        end

                        if v84 and v84:IsA("GuiButton") then
                            v69(v9, v84.Activated:Connect(v85))
                        end
                    end
                end
            end
        end
        local Sacrifice = v75:FindFirstChild("Sacrifice")
        local v86 = Sacrifice and Sacrifice:FindFirstChild("Price")
        if not (v86 and v86:IsA("TextLabel")) then
            v86 = nil
        end
        v8 = v86
        if Sacrifice and Sacrifice:IsA("GuiButton") then
            v71(v9, Sacrifice.Activated:Connect(onSacrifice))
        end
        local v87 = EggTypeConfig.Get(FuseMachineConfig.EggType)
        local SacrificeOutput = v75:FindFirstChild("SacrificeOutput")
        local v88 = SacrificeOutput and SacrificeOutput:FindFirstChild("Output")
        local v89 = v88 and v88:FindFirstChild("OutputEgg")
        if v87 and v87.Icon and v89 and v89:IsA("ImageLabel") then
            FuseMachineFlow.SetEggImage(v87.Icon)
        end
        local Destroying = v65.Destroying
        v73(v9, Destroying:Connect(function() -- line 296 | captures: v65, v6, v8, v7
            if v6 ~= v65 then
                return
            end
            v6 = nil
            v8 = nil
            table.clear(v7)
        end))
        refresh()
    else
        warn("[FuseMachineController] SciFi UI.SciFiTradeInMain not found")
    end
end

local function onServerEvent(v90, v91, v92, v93) -- line 310 | captures: v4, v5, AnimalEggsConfig, AnimalRenders, EggTypeConfig, FuseMachineConfig, MergeRevealFX, MergeSfx, NewItemController, SciFiTradeInUIController, FuseMachinePicker, SFX, refresh
    if v90 == "State" then
        local v94 = v4
        v4 = {}
        if typeof(v91) == "table" then
            for v95, v96 in v91 do
                if typeof(v95) == "string" and typeof(v96) == "table" then
                    v4[v95] = v96
                end
            end
        end
        refresh(v5)
        if v5 then
            for v97 in v4 do
                if v94[v97] == nil then
                    SFX.play("deposit")
                    break
                end
            end
        end
        v5 = true
    elseif v90 == "Fused" then
        local v98 = EggTypeConfig.Get(FuseMachineConfig.EggType)
        MergeSfx.Play("Fuse")
        MergeSfx.Play("Merged")
        MergeSfx.Play("MergedPower")
        MergeRevealFX.PlayRarity(v98 and v98.Rarity or nil)
        FuseMachinePicker.Close()
        SciFiTradeInUIController.Close()
        local v99 = EggTypeConfig.Get(v93) or v98
        local v100
        if typeof(v93) == "string" then
            v100 = v99 and v99.Icon or nil
        elseif typeof(v92) == "string" then
            v100 = AnimalRenders.GetEggImage(v92)
            if v100 == "" then
                v100 = nil
            end
        end
        local v101
        if v100 then
        else
            local v102
            if typeof(v93) == "string" then
                v102 = EggTypeConfig.CloneModel(v93)
            elseif typeof(v92) == "string" then
                if AnimalEggsConfig.UsesPlaceholder(v92) then
                else
                    v102 = AnimalEggsConfig.CloneEgg(v92)
                end
            end
            if v102 then
                AnimalEggsConfig.PrepareForDisplay(v102)
            end
            v101 = v102
        end
        local Show = NewItemController.Show
        local v103 = {}
        local v104 = {}
        if not v100 then
            if v101 then
                v100 = nil
            else
                local Icon = if v98 then v98.Icon else nil
                if not v98 or not Icon then
                    v100 = nil
                else
                    v100 = Icon
                end
            end
        end
        v104.Image = v100
        v104.Model = v101
        if typeof(v91) == "string" then
            v104.Text = v91
        else
            v104.Text = nil
        end
        v103[1] = v104
        Show(v103)
    end
end

function v1.Start() -- line 378 | captures: v3, ReplicatedStorage, FuseMachineConfig, SciFiTradeInUIController, FuseMachinePicker, LocalPlayer, bind, onServerEvent
    task.spawn(function() -- line 379 | captures: v3, ReplicatedStorage, FuseMachineConfig, onServerEvent
        local v105 = ReplicatedStorage:WaitForChild(FuseMachineConfig.RemoteName, 30)
        if not (v105 and v105:IsA("RemoteEvent")) then
            warn((("[FuseMachineController] ReplicatedStorage.%* not found"):format(FuseMachineConfig.RemoteName)))
        else
            v3 = v105
            v105.OnClientEvent:Connect(onServerEvent)
            v105:FireServer("Sync")
        end
    end)
    SciFiTradeInUIController.Observe(function(v106) -- line 391 | captures: FuseMachinePicker
        if not v106 then
            FuseMachinePicker.Close()
        end
    end)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    PlayerGui.ChildAdded:Connect(function(v107) -- line 398 | captures: bind
        task.spawn(bind, v107)
    end)
    local v108 = PlayerGui:FindFirstChild("SciFi UI")
    if v108 then
        task.spawn(bind, v108)
    end
end

return v1
