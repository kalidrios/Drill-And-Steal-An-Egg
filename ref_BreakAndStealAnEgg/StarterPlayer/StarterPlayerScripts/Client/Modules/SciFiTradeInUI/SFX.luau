-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2, T, rng
local v3 = false
local Folder
local v4 = {}
local v5 = {}
local v6 = {}

v1.plays = 0
v1.byKey = {}

function v1.build() -- line 25 | captures: v2, T, v3, Folder, v4, v5, v6
    if v3 then
        return
    end
    v3 = true
    local Folder_2 = Instance.new("Folder")
    Folder_2.Name = "ScifiSFX"
    for v7, v8 in pairs(T.SFX) do
        local id = v8.id
        if type(id) == "string" and v8.id ~= "" then
            local v9 = v8.pool or 1
            local v10 = table.create(v9)
            for v11 = 1, v9 do
                local Sound = Instance.new("Sound")
                Sound.Name = v7 .. v11
                Sound.SoundId = v8.id
                Sound.Volume = v8.vol or 0.3
                if v8.region then
                    Sound.PlaybackRegionsEnabled = true
                    Sound.PlaybackRegion = NumberRange.new(0, v8.region)
                end
                Sound.Parent = Folder_2
                v10[v11] = Sound
            end
            v4[v7] = v10
            v5[v7] = 1
            v6[v7] = (-1/0)
        end
    end
    Folder_2.Parent = v2.gui
    Folder = Folder_2
end

function v1.play(v12, v13) -- line 57 | captures: v2, T, rng, v3, v1, v4, v5, v6
    if not (v2 and (v13 or v2.running)) then
        return
    end
    if not v3 then
        v1.build()
    end
    local v14 = v4[v12]
    if not v14 then
        return
    end
    local v15 = T.SFX[v12]
    local v16 = os.clock()
    if not (v16 - v6[v12] < (v15.gap or 0.03)) then
        v6[v12] = v16
        local v17 = v5[v12]
        v5[v12] = v17 % #v14 + 1
        local v18 = v14[v17]
        local v19 = v15.vary or 0.05
        v18.PlaybackSpeed = 1 + rng:NextNumber(-v19, v19)
        v18.TimePosition = 0
        v18:Play()
        v1.plays += 1
        v1.byKey[v12] = (v1.byKey[v12] or 0) + 1
    end
end

function v1.playing() -- line 89 | captures: v4
    local v20 = 0
    for v21, v22 in pairs(v4) do
        local v23 = v20
        for v24, v25 in ipairs(v22) do
            if v25.IsPlaying then
                v23 += 1
            end
            v20 = v23
        end
    end
    return v20
end

function v1.destroy() -- line 101 | captures: v3, Folder, v4, v5, v6
    if Folder then
        Folder:Destroy()
        Folder = nil
    end
    table.clear(v4)
    table.clear(v5)
    table.clear(v6)
    v3 = false
end

function v1.init(v26) -- line 112 | captures: v2, T, rng
    v2 = v26
    local T_2 = v2.T
    local rng_2 = v2.rng
    T = T_2
    rng = rng_2
end

return v1
