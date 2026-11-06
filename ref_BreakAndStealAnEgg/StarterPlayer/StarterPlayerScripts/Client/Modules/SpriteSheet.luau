-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local v1 = {}

local function frameOffsets(v2, v3, v4) -- line 26
    local function v5(v6, ...)
        table.insert(v6, ...)
    end

    local v7 = {}
    local X = v2.X
    local v8 = math.floor(X)
    local v9 = math.max(v8, 1)
    local Y = v2.Y
    local v10 = math.floor(Y)
    local v11 = math.max(v10, 1) - 1
    for v12 = 0, v11 do
        local v13 = v9 - 1
        for v14 = 0, v13 do
            local v15 = if v4 then v9 - 1 - v14 else v14
            v5(v7, Vector2.new(v3.X * v15, v3.Y * v12))
        end
    end
    return v7
end

local function onScreen(v16) -- line 38
    local v17 = v16
    while v17 do
        if v17:IsA("GuiObject") then
            if v17.Visible then
                v17 = v17.Parent
                continue
            end
            return false
        end
        break
    end
    if v17 == nil then
        return false
    end
    return not v17:IsA("ScreenGui") or v17.Enabled
end

function v1.Play(v18) -- line 49 | captures: RunService, frameOffsets, onScreen
    local Cells = v18:GetAttribute("Cells")
    local FPS = v18:GetAttribute("FPS")
    local ImageRectSize = v18.ImageRectSize
    local frameOffsets_2, v19, v20
    if typeof(Cells) == "Vector2" and type(FPS) == "number" then
        if FPS <= 0 or ImageRectSize.X <= 0 or ImageRectSize.Y <= 0 then
            v20 = true
        else
            frameOffsets_2 = frameOffsets
            v19 = v18:GetAttribute("MirrorCells") == true
            v20 = false
        end
    else
        v20 = true
    end
    if v20 then
        return function() -- line 54
        end
    end
    local v21 = frameOffsets_2(Cells, ImageRectSize, v19)
    local v22 = #v21
    local v23 = v22 / FPS
    local v24 = 0
    local v25 = -1
    local v26 = RunService.RenderStepped:Connect(function(v27) -- line 61 | captures: v24, v25, v18, FPS, v21, v22, v23, onScreen
        if v18.Parent then
            v24 = (v24 + v27) % v23
            if onScreen(v18) then
                local v28 = v24 * FPS
                local v29 = math.floor(v28) + 1
                local v30 = math.min(v29, v22)
                if v30 ~= v25 then
                    v25 = v30
                    v18.ImageRectOffset = v21[v30]
                end
            end
        end
    end)
    local v31 = v18.Destroying:Once(function() -- line 76 | captures: v26
        v26:Disconnect()
    end)
    return function() -- line 79 | captures: v18, v21, v26, v31
        v26:Disconnect()
        v31:Disconnect()
        v18.ImageRectOffset = v21[1]
    end
end

return v1
