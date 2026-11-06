-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2 = { live = 0 }

v1.state = v2

local T, rng, OpeningBurst, v3, v4, v5
local v6 = -1
local v7 = -1
local v8 = 0
local v9 = false

function v1.play(v10) -- line 26 | captures: OpeningBurst, v3, v6, v7, v2
    if not (OpeningBurst and v3) then
        return
    end
    v6 = -v10
    v7 = -1
    v2.live = 1
end

function v1.step(v11) -- line 35 | captures: T, rng, OpeningBurst, v3, v4, v5, v6, v7, v8, v1
    v6 += v11
    if v6 < 0 then
        return
    end
    local v12 = v6 * v5
    local v13 = math.floor(v12) + 1
    if v4 < v13 then
        v1.hideAll()
    else
        if v7 == -1 then
            OpeningBurst.Rotation = v8 + rng:NextNumber(-T.BURST_ROT, T.BURST_ROT)
            OpeningBurst.ImageRectOffset = v3[1]
            OpeningBurst.Visible = true
        end
        if v13 ~= v7 then
            v7 = v13
            OpeningBurst.ImageRectOffset = v3[v13]
        end
    end
end

function v1.hideAll() -- line 56 | captures: OpeningBurst, v3, v6, v7, v8, v9, v2
    if v2.live == 0 then
        return
    end
    v2.live = 0
    v6 = -1
    if OpeningBurst and v7 ~= -1 then
        OpeningBurst.Visible = v9
        OpeningBurst.Rotation = v8
        OpeningBurst.ImageRectOffset = v3[1]
    end
    v7 = -1
end

function v1.init(v14) -- line 70 | captures: T, rng, OpeningBurst, v3, v4, v5, v6, v7, v8, v9, v2
    local T_2 = v14.T
    local rng_2 = v14.rng
    T = T_2
    rng = rng_2
    v2.live = 0
    v6 = -1
    v7 = -1
    v3 = nil
    OpeningBurst = v14.OpeningBurst
    if not OpeningBurst then
        return
    end
    v14.Actors.noFade[OpeningBurst] = true
    local Rotation = OpeningBurst.Rotation
    local Visible = OpeningBurst.Visible
    v8 = Rotation
    v9 = Visible
    local Cells = OpeningBurst:GetAttribute("Cells")
    v5 = OpeningBurst:GetAttribute("FPS")
    local ImageRectSize = OpeningBurst.ImageRectSize
    local v15, v16
    if typeof(Cells) == "Vector2" then
        local v17 = v5
        if type(v17) == "number" then
            if v5 <= 0 or ImageRectSize.X <= 0 then
                v16 = true
            else
                v3 = v14.Sprites.offsetsFor(Cells, ImageRectSize, false)
                local Frames = OpeningBurst:GetAttribute("Frames")
                if type(Frames) == "number" and Frames >= 1 then
                    local v18 = math.floor(Frames)
                    local v19 = #v3
                    v15 = math.min(v18, v19) or #v3
                else
                    v15 = #v3
                end
                v16 = false
            end
        else
            v16 = true
        end
    else
        v16 = true
    end
    if not v16 then
        v4 = v15
    else
        OpeningBurst = nil
    end
end

return v1
