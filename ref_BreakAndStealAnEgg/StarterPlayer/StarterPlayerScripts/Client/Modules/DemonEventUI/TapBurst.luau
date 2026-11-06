-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local UserInputService = game:GetService("UserInputService")
local v1 = {}

function v1.new() -- line 33 | captures: UserInputService
    local v2 = {}
    local v3, T, rng, gui, offsetsFor
    local cos = math.cos
    local sin = math.sin
    local rad = math.rad
    local v4 = {}
    local v5 = {}
    local v6 = 0
    local v7 = {}
    local v8 = {}
    local v9 = {}
    local v10 = {}
    local TapBurst
    local v11 = {
        size = 0,
        live = 0,
        cursor = 0,
        offsets = nil,
        count = 0,
        fps = 0,
        lastAt = (-1/0),
        conn = nil,
        pool = {},
        t = {},
        last = {}
    }
    v2.state = v11

    local function buildPool() -- line 60 | captures: v3, T, gui, offsetsFor, TapBurst, v7, v8, v9, v10, v11
        local Cells = TapBurst:GetAttribute("Cells")
        local FPS = TapBurst:GetAttribute("FPS")
        local ImageRectSize = TapBurst.ImageRectSize
        local v12, v13, v14
        if typeof(Cells) == "Vector2" and type(FPS) == "number" then
            if FPS <= 0 or ImageRectSize.X <= 0 then
                v14 = true
            else
                local v15 = offsetsFor(Cells, ImageRectSize, false)
                local Frames = TapBurst:GetAttribute("Frames")
                v11.offsets = v15
                v12 = v11
                if type(Frames) == "number" and Frames >= 1 then
                    local v16 = math.floor(Frames)
                    local v17 = #v15
                    v13 = math.min(v16, v17) or #v15
                else
                    v13 = #v15
                end
                v14 = false
            end
        else
            v14 = true
        end
        if v14 then
            return false
        end
        v12.count = v13
        v11.fps = FPS
        local v18, v19
        if v3.touchOnly or v3.lowEnd then
            local BURST_POOL_LOW = T.BURST_POOL_LOW
            if BURST_POOL_LOW then
                v18 = BURST_POOL_LOW
                v19 = true
            else
                v19 = false
            end
        else
            v19 = false
        end
        if not v19 then
            v18 = T.BURST_POOL
        end
        for v20 = 1, v18 do
            local v21 = TapBurst:Clone()
            v21.Name = "TapBurstFX"
            v21.AnchorPoint = Vector2.new(0.5, 0.5)
            v21.ZIndex = T.BURST_Z
            v21.Active = false
            v21.Visible = false
            v21.Parent = gui
            v11.pool[v20] = v21
            v11.t[v20] = -1
            v11.last[v20] = 0
            v7[v20] = 0
            v8[v20] = 0
            v9[v20] = 0
            v10[v20] = 0
        end
        v11.size = v18
        return true
    end

    function v2.build() -- line 90 | captures: TapBurst, v11, buildPool
        if v11.size == 0 and TapBurst then
            buildPool()
        end
    end

    local function place(v22, v23) -- line 97 | captures: v6, v4, v5, v7, v8, v9, v10, v11
        local v24, v25
        if v23 <= v6 then
            v24, v25 = v4[v23], v5[v23]
        else
            v24 = 0
            v25 = 0
        end
        local v26 = v9[v22]
        local v27 = v10[v22]
        v11.pool[v22].Position = UDim2.fromOffset(v7[v22] - (v24 * v26 - v25 * v27), v8[v22] - (v24 * v27 + v25 * v26))
    end

    local function spawn(v28, v29) -- line 106 | captures: v3, T, rng, gui, v6, TapBurst, cos, sin, rad, v4, v5, v7, v8, v9, v10, v11, buildPool
        local clock = v3.clock
        if not (clock - v11.lastAt < T.BURST_GAP) then
            v11.lastAt = clock
            if v11.size ~= 0 or buildPool() then
                local v30 = v11.cursor % v11.size + 1
                v11.cursor = v30
                local v31 = v11.pool[v30]
                local Size = TapBurst.Size
                local v32 = rng:NextNumber(T.BURST_SIZE_MIN, T.BURST_SIZE_MAX)
                v31.Size = UDim2.new(Size.X.Scale * v32, Size.X.Offset * v32, Size.Y.Scale * v32, Size.Y.Offset * v32)
                local v33 = rng:NextNumber(0, 360)
                v31.Rotation = v33
                local AbsoluteSize = gui.AbsoluteSize
                local v34 = (Size.X.Scale * AbsoluteSize.X + Size.X.Offset) * v32
                local v35 = (Size.Y.Scale * AbsoluteSize.Y + Size.Y.Offset) * v32
                if v34 < v35 and v34 then
                    v35 = v34
                end
                local v36 = rad(v33)
                v7[v30] = v28
                v8[v30] = v29
                local v37 = v35 * cos(v36)
                local v38 = v35 * sin(v36)
                v9[v30] = v37
                v10[v30] = v38
                local v39, v40
                if v6 >= 1 then
                    v39, v40 = v4[1], v5[1]
                else
                    v39 = 0
                    v40 = 0
                end
                local v41 = v9[v30]
                local v42 = v10[v30]
                v11.pool[v30].Position = UDim2.fromOffset(v7[v30] - (v39 * v41 - v40 * v42), v8[v30] - (v39 * v42 + v40 * v41))
                v31.ImageRectOffset = v11.offsets[1]
                v31.Visible = true
                if v11.t[v30] < 0 then
                    v11.live += 1
                end
                v11.t[v30] = 0
                v11.last[v30] = 1
            end
        end
    end

    function v2.step(v43) -- line 141 | captures: v6, v4, v5, v7, v8, v9, v10, v11
        local fps = v11.fps
        local count = v11.count
        local offsets = v11.offsets
        local size = v11.size
        for v44 = 1, size do
            local v45 = v11.t[v44]
            if v45 >= 0 then
                local v46 = v45 + v43
                local v47 = v46 * fps
                local v48 = math.floor(v47) + 1
                if count < v48 then
                    v11.t[v44] = -1
                    v11.live -= 1
                    v11.pool[v44].Visible = false
                else
                    v11.t[v44] = v46
                    if v48 ~= v11.last[v44] then
                        v11.last[v44] = v48
                        v11.pool[v44].ImageRectOffset = offsets[v48]
                        local v49, v50
                        if v48 <= v6 then
                            v49, v50 = v4[v48], v5[v48]
                        else
                            v49 = 0
                            v50 = 0
                        end
                        local v51 = v9[v44]
                        local v52 = v10[v44]
                        v11.pool[v44].Position = UDim2.fromOffset(v7[v44] - (v49 * v51 - v50 * v52), v8[v44] - (v49 * v52 + v50 * v51))
                    end
                end
            end
        end
    end

    local function hideAll() -- line 164 | captures: v11
        local size = v11.size
        for v53 = 1, size do
            if v11.t[v53] >= 0 then
                v11.t[v53] = -1
                v11.pool[v53].Visible = false
            end
        end
        v11.live = 0
    end

    local function onInput(v54) -- line 176 | captures: v3, gui, spawn
        local UserInputType = v54.UserInputType
        if not v3.isOpen or UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local Position = v54.Position
        local AbsolutePosition = gui.AbsolutePosition
        spawn(Position.X - AbsolutePosition.X, Position.Y - AbsolutePosition.Y)
    end

    function v2.start() -- line 189 | captures: TapBurst, v11, onInput, UserInputService
        if TapBurst then
            v11.conn = UserInputService.InputBegan:Connect(onInput)
        end
    end

    function v2.stop() -- line 195 | captures: v11, hideAll
        if v11.conn then
            v11.conn:Disconnect()
            v11.conn = nil
        end
        hideAll()
    end

    function v2.init(v55) -- line 203 | captures: v3, T, rng, gui, offsetsFor, v6, TapBurst, v4, v5
        v3 = v55
        local T_2 = v3.T
        local rng_2 = v3.rng
        local gui_2 = v3.gui
        T = T_2
        rng = rng_2
        gui = gui_2
        offsetsFor = v3.Sprites.offsetsFor
        local v56 = T.BURST_CENTRE_X or {}
        local v57 = T.BURST_CENTRE_Y or {}
        local v58 = #v56
        local v59 = #v57
        v6 = math.min(v58, v59)
        local v60 = v6
        for v61 = 1, v60 do
            local v62 = v56[v61]
            local v63 = v57[v61]
            v4[v61] = v62
            v5[v61] = v63
        end
        local TapBurst_2 = gui:FindFirstChild("TapBurst")
        if TapBurst_2 and TapBurst_2:IsA("ImageLabel") then
            TapBurst = TapBurst_2
            TapBurst_2.Visible = false
        end
    end

    return v2
end

return v1
