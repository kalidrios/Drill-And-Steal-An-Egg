-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ConfettiConfig = require(ReplicatedStorage.Shared.ConfettiConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = Random.new()
local v3
local v4 = {}
local v5 = {}
local v6

local function roll(v7) -- line 63 | captures: v2
    return v2:NextNumber(v7.Min, v7.Max)
end

local function getHolder() -- line 68 | captures: v3, ConfettiConfig, LocalPlayer
    if v3 and v3.Parent then
        return v3
    end
    local v8 = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(ConfettiConfig.GuiName)
    if v8 then
        local v9 = v8:FindFirstChild(ConfettiConfig.LayerName)
        if not (v9 and v9:IsA("Frame")) then
            local Frame = Instance.new("Frame")
            Frame.Name = ConfettiConfig.LayerName
            Frame.Size = UDim2.fromScale(1, 1)
            Frame.BackgroundTransparency = 1
            Frame.BorderSizePixel = 0
            Frame.Active = false
            Frame.ZIndex = ConfettiConfig.ZIndex
            Frame.Parent = v8
            v3 = Frame
            return Frame
        end
        v3 = v9
        return v9
    end
    return nil
end

local function spawnPiece(v10, v11) -- line 97 | captures: ConfettiConfig, v2, v4
    local v12 = #v4
    if ConfettiConfig.MaxPieces <= v12 then
        return
    end
    local X = v11.X
    local Y = v11.Y
    local PieceWidth = ConfettiConfig.PieceWidth
    local v13 = v2:NextNumber(PieceWidth.Min, PieceWidth.Max) * Y
    local PieceLength = ConfettiConfig.PieceLength
    local v14 = v2:NextNumber(PieceLength.Min, PieceLength.Max) * Y
    local v15 = math.max(v13, v14) * 0.5
    local v16 = Y + v14
    local PeakAboveTop = ConfettiConfig.PeakAboveTop
    local v17 = -v2:NextNumber(PeakAboveTop.Min, PeakAboveTop.Max) * Y - v14
    local v18 = 2 * (ConfettiConfig.Gravity * Y) * (v16 - v17)
    local v19 = math.sqrt(v18)
    local v20 = v2:NextNumber(0, 360)
    local Frame = Instance.new("Frame")
    Frame.Name = "Confetti"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BorderSizePixel = 0
    Frame.Active = false
    Frame.BackgroundColor3 = ConfettiConfig.Colors[v2:NextInteger(1, #ConfettiConfig.Colors)]
    Frame.Size = UDim2.fromOffset(v13, v14)
    Frame.Rotation = v20
    local v21 = { frame = Frame }
    local v22 = X - v15
    v21.x = v2:NextNumber(v15, (math.max(v22, v15)))
    v21.y = v16
    v21.vx = v2:NextNumber(-ConfettiConfig.SideSpeed, ConfettiConfig.SideSpeed) * Y
    v21.vy = -v19
    v21.halfWidth = v15
    v21.halfLength = v14 * 0.5
    local FallSpeed = ConfettiConfig.FallSpeed
    v21.fallSpeed = v2:NextNumber(FallSpeed.Min, FallSpeed.Max) * Y
    local SwayDistance = ConfettiConfig.SwayDistance
    v21.swayDistance = v2:NextNumber(SwayDistance.Min, SwayDistance.Max) * Y
    local SwaySpeed = ConfettiConfig.SwaySpeed
    v21.swaySpeed = v2:NextNumber(SwaySpeed.Min, SwaySpeed.Max)
    v21.swayPhase = v2:NextNumber(0, 6.283185307179586)
    v21.baseRotation = v20
    local WobbleDegrees = ConfettiConfig.WobbleDegrees
    v21.wobble = v2:NextNumber(WobbleDegrees.Min, WobbleDegrees.Max)
    local WobbleSpeed = ConfettiConfig.WobbleSpeed
    v21.wobbleSpeed = v2:NextNumber(WobbleSpeed.Min, WobbleSpeed.Max)
    v21.wobblePhase = v2:NextNumber(0, 6.283185307179586)
    Frame.Position = UDim2.fromOffset(v21.x, v21.y)
    Frame.Parent = v10
    table.insert(v4, v21)
end

local function step(v23) -- line 147 | captures: v3, v6, ConfettiConfig, v4, v5, spawnPiece
    local v24 = v3
    if not (v24 and v24.Parent) then
        for v25, v26 in v4 do
            v26.frame:Destroy()
        end
        table.clear(v4)
        table.clear(v5)
    else
        local AbsoluteSize = v24.AbsoluteSize
        local v27 = #v5
        for v28 = v27, 1, -1 do
            local v29 = v5[v28]
            v29.timer += v23
            while true do
                if v29.remaining > 0 then
                    local timer = v29.timer
                    if v29.interval <= timer then
                        v29.timer -= v29.interval
                        v29.remaining -= 1
                        spawnPiece(v24, AbsoluteSize)
                        continue
                    end
                end
                break
            end
            if v29.remaining <= 0 then
                table.remove(v5, v28)
            end
        end
        local v30 = ConfettiConfig.Gravity * AbsoluteSize.Y
        local v31 = -ConfettiConfig.SideDrag * v23
        local v32 = math.exp(v31)
        local v33 = #v4
        for v34 = v33, 1, -1 do
            local v35 = v4[v34]
            local frame = v35.frame
            local v36 = v35.vy + v30 * v23
            local fallSpeed = v35.fallSpeed
            v35.vy = math.min(v36, fallSpeed)
            v35.vx *= v32
            local v37 = v35.vy > 0
            local v38 = v35.x + v35.vx * v23
            if v37 then
                v35.swayPhase += v35.swaySpeed * v23
                local swayPhase = v35.swayPhase
                v38 += math.sin(swayPhase) * v35.swayDistance * v23
            end
            local halfWidth = v35.halfWidth
            local v39 = AbsoluteSize.X - v35.halfWidth
            local halfWidth_2 = v35.halfWidth
            local v40 = math.max(v39, halfWidth_2)
            v35.x = math.clamp(v38, halfWidth, v40)
            v35.y += v35.vy * v23
            local v41
            if v37 then
                local v42 = v35.y - v35.halfWidth
                if AbsoluteSize.Y < v42 then
                    v41 = false
                else
                    v41 = not not frame.Parent
                end
            else
                v41 = not not frame.Parent
            end
            if v41 then
                frame.Position = UDim2.fromOffset(v35.x, v35.y)
                if v37 then
                    v35.wobblePhase += v35.wobbleSpeed * v23
                    local baseRotation = v35.baseRotation
                    local wobblePhase = v35.wobblePhase
                    frame.Rotation = baseRotation + math.sin(wobblePhase) * v35.wobble
                end
            else
                frame:Destroy()
                v4[v34] = v4[#v4]
                v4[#v4] = nil
            end
        end
    end
    if #v4 == 0 and #v5 == 0 and v6 then
        v6:Disconnect()
        v6 = nil
    end
end

function v1.Burst() -- line 217 | captures: v6, RunService, ConfettiConfig, v5, getHolder, step
    if not getHolder() then
        return
    end
    local PieceCount = ConfettiConfig.PieceCount
    local v43 = math.max(PieceCount, 1)
    local v44 = ConfettiConfig.SpawnDuration / v43
    local v45 = {
        remaining = v43,
        interval = v44,
        timer = v44
    }
    table.insert(v5, v45)
    v6 = v6 or RunService.RenderStepped:Connect(step)
end

function v1.Start() -- line 235 | captures: ConfettiConfig, LocalPlayer, getHolder
    LocalPlayer:WaitForChild("PlayerGui"):WaitForChild(ConfettiConfig.GuiName, 30)
    getHolder()
end

return v1
