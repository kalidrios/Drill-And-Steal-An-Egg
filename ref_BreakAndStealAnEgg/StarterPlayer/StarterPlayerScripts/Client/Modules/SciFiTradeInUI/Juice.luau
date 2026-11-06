-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local SFX = require(script.Parent.SFX)
local Shimmer = require(script.Parent.Shimmer)
local Glow = require(script.Parent.Glow)

v1.SFX = SFX
v1.Shimmer = Shimmer
v1.Glow = Glow

local v2, T
local step = Shimmer.step
local step_2 = Glow.step
local play = SFX.play
local v3 = table.create(6, false)
local v4 = table.create(6, (1/0))
local v5 = 0

function v1.cue(v6, v7) -- line 31 | captures: v5, v3, v4
    if v5 >= 6 then
        return
    end
    v5 += 1
    local v8 = v5
    local v9 = v5
    v3[v8] = v6
    v4[v9] = v7
end

local function clearCues() -- line 39 | captures: v5, v3, v4
    local v10 = v5
    for v11 = 1, v10 do
        v3[v11] = false
        v4[v11] = (1/0)
    end
    v5 = 0
end

function v1.init(v12) -- line 46 | captures: v2, T, SFX, Shimmer, Glow
    v2 = v12
    T = v2.T
    v2.SFX = SFX
    SFX.init(v2)
    Shimmer.init(v2)
    Glow.init(v2)
end

function v1.build() -- line 55 | captures: SFX
    SFX.build()
end

function v1.start() -- line 59 | captures: Shimmer, Glow
    Shimmer.start()
    Glow.start()
end

function v1.stop() -- line 64 | captures: v5, Shimmer, Glow, v3, v4
    Shimmer.stop()
    Glow.stop()
    local v13 = v5
    for v14 = 1, v13 do
        v3[v14] = false
        v4[v14] = (1/0)
    end
    v5 = 0
end

function v1.step(v15, v16) -- line 70 | captures: v5, step, step_2, play, v3, v4
    if v5 > 0 then
        local v17 = 1
        while true do
            if v17 <= v5 then
                if v4[v17] <= v16 then
                    play(v3[v17])
                    local v18 = v3[v5]
                    local v19 = v4[v5]
                    v3[v17] = v18
                    v4[v17] = v19
                    local v20 = v5
                    local v21 = v5
                    v3[v20] = false
                    v4[v21] = (1/0)
                    v5 -= 1
                else
                    v17 += 1
                end
            else
                break
            end
        end
    end
    step(v15, v16)
    step_2(v15, v16)
end

function v1.onOpen(v22) -- line 89 | captures: v2, T, v1, play
    play("whoosh", true)
    if not v22 then
        return
    end
    local clock = v2.clock
    v1.cue("glitchOpen", clock + T.GLITCH_OPEN_AT * T.TIME_SCALE)
    v1.cue("hum", clock + 0.02)
end

function v1.onClose() -- line 98 | captures: v5, play, v3, v4
    local v23 = v5
    for v24 = 1, v23 do
        v3[v24] = false
        v4[v24] = (1/0)
    end
    v5 = 0
    play("glitchClose", true)
end

function v1.onBeam() -- line 103 | captures: play
    play("beam")
end

function v1.destroy() -- line 107 | captures: v5, SFX, Shimmer, Glow, v3, v4
    local v25 = v5
    for v26 = 1, v25 do
        v3[v26] = false
        v4[v26] = (1/0)
    end
    v5 = 0
    Shimmer.stop()
    Glow.stop()
    SFX.destroy()
end

return v1
