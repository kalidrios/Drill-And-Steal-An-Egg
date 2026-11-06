-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local FormatNumber = require(ReplicatedStorage.Shared.FormatNumber)
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local BackpackUiConfig = require(ReplicatedStorage.Shared.BackpackUiConfig)
local ViewportLighting = require(ReplicatedStorage.Shared.ViewportLighting)
local ClaimFeedback = require(script.Parent.ClaimFeedback)
local NewItemTweens = require(script.Parent.Parent.Modules.NewItemTweens)
local StrokePulse = require(script.Parent.Parent.Modules.StrokePulse)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2 = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local v4 = 0

local function getNewItemFrame() -- line 98 | captures: LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v5 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v6 = v5 and v5:FindFirstChild("NewItem")
    if not (v6 and v6:IsA("Frame")) then
        return nil
    end
    return v6
end

local function runGlowPulses(v7, v8) -- line 117 | captures: Debris, TweenService, StrokePulse, v2, v3
    local Size = v8.Size
    local v9 = UDim2.new(Size.X.Scale * 1.08, Size.X.Offset * 1.08, Size.Y.Scale * 1.08, Size.Y.Offset * 1.08)
    local v10 = UDim2.new(Size.X.Scale * 1.5, Size.X.Offset * 1.5, Size.Y.Scale * 1.5, Size.Y.Offset * 1.5)
    local ItemDisplay = v7:FindFirstChild("ItemDisplay")
    local v11 = ItemDisplay and ItemDisplay:FindFirstChildOfClass("UICorner")
    local ItemDisplay_2 = ItemDisplay
    if ItemDisplay then
        ItemDisplay = ItemDisplay:FindFirstChild("Outer")
        ItemDisplay_2 = ItemDisplay
    end
    if not (ItemDisplay and ItemDisplay:IsA("UIStroke")) then
        ItemDisplay_2 = nil
    end
    task.spawn(function() -- line 137 | captures: ItemDisplay_2, v7, v8, v9, v10, v11, Debris, TweenService, StrokePulse, v2, v3
        local v12 = 0
        while true do
            local v13, v14, v15
            if v7.Parent then
                if v7:GetAttribute("Retiring") then
                    v15 = true
                else
                    v13 = v12 + 1
                    v14 = v8:Clone()
                    v14.Name = "GlowPulse"
                    v14.Visible = true
                    v14.Size = v9
                    if v11 then
                        v11:Clone().Parent = v14
                    end
                    v15 = false
                end
            else
                v15 = true
            end
            if v15 then
                break
            end
            v14.Parent = v7
            TweenService:Create(v14, v2, {
                ImageTransparency = 1,
                Size = v10
            }):Play()
            Debris:AddItem(v14, v2.Time + 0.1)
            if v13 % 5 == 1 then
                StrokePulse.Spawn(v7, {
                    Thickness = 2,
                    EndScale = 1.3,
                    Color = Color3.new(1, 1, 1),
                    Tween = v3,
                    Corner = v11,
                    BaseStroke = ItemDisplay_2
                })
            end
            task.wait(0.4)
            v12 = v13
        end
    end)
end

local function buildModelViewport(v16, v17, v18) -- line 178 | captures: BackpackUiConfig, ViewportLighting
    local ViewportFrame = Instance.new("ViewportFrame")
    ViewportFrame.Name = "ModelDisplay"
    ViewportFrame.BackgroundTransparency = 1
    if v17 then
        ViewportFrame.Size = v17.Size
        ViewportFrame.Position = v17.Position
        ViewportFrame.AnchorPoint = v17.AnchorPoint
        ViewportFrame.ZIndex = v17.ZIndex
    else
        ViewportFrame.Size = UDim2.fromScale(1, 1)
    end
    local v19 = v18:Clone()
    for v20, v21 in v19:GetDescendants() do
        if v21:IsA("LuaSourceContainer") or v21:IsA("ProximityPrompt") then
            v21:Destroy()
        end
    end
    v19.Parent = ViewportFrame
    local Camera = Instance.new("Camera")
    local v22, v23 = v19:GetBoundingBox()
    local ViewportFov = BackpackUiConfig.ViewportFov
    local v24 = v23.Magnitude / 2
    local v25 = ViewportFov / 2
    local v26 = math.rad(v25)
    local v27 = v24 / math.sin(v26)
    local v28 = v22:VectorToWorldSpace(BackpackUiConfig.ViewportDirection.Unit)
    Camera.FieldOfView = ViewportFov
    Camera.CFrame = CFrame.lookAt(v22.Position + v28 * v27, v22.Position)
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera
    ViewportLighting.Apply(ViewportFrame)
    ViewportFrame.Parent = v16
end

local function showCard(v29, v30, v31) -- line 217 | captures: v4, FormatNumber, AnimalRenders, NewItemTweens, buildModelViewport
    local Count = v31.Count
    local v32 = tonumber(Count) or 1
    local v33 = math.floor(v32)
    local v34 = math.max(v33, 1)
    local v35 = v30:Clone()
    v35.Name = v31.Name or "NewItem"
    local ItemDisplay = v35:FindFirstChild("ItemDisplay")
    local v36, v37, v38
    if ItemDisplay then
        v36 = ItemDisplay:FindFirstChild("ViewportFrame")
        v37 = ItemDisplay:FindFirstChild("Icon")
        v38 = ItemDisplay:FindFirstChild("Amount")
    else
        v36 = ItemDisplay
        v37 = ItemDisplay
        v38 = ItemDisplay
    end
    local Image = v31.Image
    local v39 = if typeof(Image) == "string" then v31.Image ~= "" else false
    local v40 = not v39
    if v40 then
        local Model = v31.Model
        v40 = typeof(Model) == "Instance"
    end
    local v41 = not v39 and not v40 and v31.Icon ~= nil
    if v36 and v36:IsA("ImageLabel") then
        v36.Visible = not v41 and not v40
        if v39 then
            v36.ScaleType = Enum.ScaleType.Fit
            v36.Image = v31.Image
        elseif not v41 and not v40 and v31.Name then
            AnimalRenders.Apply(v36, v31.Name, v31.Variant)
        end
    end
    if v37 and v37:IsA("ImageLabel") then
        v37.Visible = v41
        if v41 then
            v37.Image = v31.Icon
        end
    end
    if v40 and ItemDisplay then
        local v42 = if v36 and v36:IsA("ImageLabel") then v36 else nil
        buildModelViewport(ItemDisplay, v42, v31.Model)
    end
    if v38 and v38:IsA("TextLabel") then
        if v31.Text then
            v38.Text = v31.Text
        else
            local v43, v44
            if v41 then
                v44 = true
            elseif v31.Name then
                if v34 > 1 then
                    v43 = ("%* x%*"):format(v31.Name, (FormatNumber.Short(v34)))
                else
                    v43 = v31.Name
                end
                v44 = false
            else
                v44 = true
            end
            if v44 then
                v38.Text = ("%*x"):format((FormatNumber.Short(v34)))
            else
                v38.Text = v43
            end
        end
    end
    local Glow = v35:FindFirstChild("Glow")
    if Glow and Glow:IsA("ImageLabel") then
        Glow.Visible = false
    end
    local v45 = NewItemTweens.Prepare(v35)
    v4 += 1
    v35.LayoutOrder = v4
    v35.Visible = true
    v35.Parent = v29
    if not (Glow and Glow:IsA("ImageLabel")) then
        return v45, nil
    end
    return v45, Glow
end

local function runBatch(v46, v47) -- line 297 | captures: RunService, NewItemTweens, runGlowPulses
    RunService.Heartbeat:Wait()
    local v48 = {}
    local v49 = {}
    for v50, v51 in v47 do
        v48[v51.Handle.Card] = v51.Glow
        local Handle = v51.Handle
        table.insert(v49, Handle)
    end
    for v52, v53 in NewItemTweens.OrderLeftToRight(v49) do
        local Card = v53.Card
        local delay = task.delay
        local v54 = (v52 - 1) * 0.07
        local v55 = v53
        delay(v54, function() -- line 309 | captures: v46, v48, Card, v55, NewItemTweens, runGlowPulses
            if Card.Parent == v46 then
                NewItemTweens.PlayIntro(v55, function() -- line 313 | captures: v46, v48, Card, runGlowPulses
                    local v56 = v48[Card]
                    if v56 and Card.Parent == v46 and not Card:GetAttribute("Retiring") then
                        runGlowPulses(Card, v56)
                    end
                end)
            end
        end)
    end
    task.wait(3)
    local v57 = {}
    for v58, v59 in v49 do
        if v59.Card.Parent == v46 then
            table.insert(v57, v59)
        end
    end
    local v60 = NewItemTweens.OrderLeftToRight(v57)
    for v61, v62 in v60 do
        local delay = task.delay
        local v63 = (v61 - 1) * 0.06
        local v64 = v62
        delay(v63, function() -- line 335 | captures: v46, v64, NewItemTweens
            if v64.Card.Parent == v46 then
                v64.Card:SetAttribute("Retiring", true)
                NewItemTweens.PlayOutro(v64)
            end
        end)
    end
    local wait = task.wait
    local v65 = #v60 - 1
    wait(math.max(v65, 0) * 0.06 + NewItemTweens.OutroTime)
    for v66, v67 in v49 do
        if v67.Card.Parent then
            v67.Card:Destroy()
        end
    end
end

function v1.Show(v68) -- line 354 | captures: ClaimFeedback, LocalPlayer, showCard, runBatch
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local v69 = PlayerGui and PlayerGui:FindFirstChild("MainGUI")
    local v70 = v69 and v69:FindFirstChild("NewItem")
    if not (v70 and v70:IsA("Frame")) then
        v70 = nil
    end
    if v70 then
        local v71 = v70:FindFirstChild("Template")
        if v71 and v71:IsA("Frame") then
            ClaimFeedback.PlaySting()
            local v72 = {}
            for v73, v74 in v68 do
                if typeof(v74) == "table" then
                    local Image = v74.Image
                    local v75 = if typeof(Image) == "string" then v74.Image ~= "" else false
                    local Name = v74.Name
                    local v76 = typeof(Name) == "string"
                    local Icon = v74.Icon
                    local v77 = typeof(Icon) == "string"
                    local Model = v74.Model
                    local v78 = typeof(Model) == "Instance"
                    if v75 or v76 or v77 or v78 then
                        local v79, v80 = showCard(v70, v71, v74)
                        local v81 = {
                            Handle = v79,
                            Glow = v80
                        }
                        table.insert(v72, v81)
                    end
                end
            end
            if #v72 > 0 then
                task.spawn(runBatch, v70, v72)
            end
        end
    end
end

function v1.Start() -- line 387 | captures: ReplicatedStorage, v1
    local v82 = ReplicatedStorage:WaitForChild("AnimalBankedRemote", 30)
    if not v82 then
        warn("[NewItemController] AnimalBankedRemote slow to arrive \226\128\148 still waiting")
        v82 = ReplicatedStorage:WaitForChild("AnimalBankedRemote")
    end
    if v82:IsA("RemoteEvent") then
        v82.OnClientEvent:Connect(function(v83) -- line 403 | captures: v1
            if typeof(v83) == "table" and #v83 > 0 then
                v1.Show(v83)
            end
        end)
    else
        warn("[NewItemController] AnimalBankedRemote is not a RemoteEvent \226\128\148 new item popups disabled")
    end
end

return v1
