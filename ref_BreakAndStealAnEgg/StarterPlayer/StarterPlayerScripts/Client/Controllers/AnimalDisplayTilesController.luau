-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalDisplayTilesConfig = require(ReplicatedStorage.Shared.AnimalDisplayTilesConfig)
local FloatingIconConfig = require(ReplicatedStorage.Shared.FloatingIconConfig)
local FloatingIconFX = require(script.Parent.Parent.Modules.FloatingIconFX)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}

local function resolve(v2, v3) -- line 28
    local v4 = v2
    for v5, v6 in v3 do
        v4 = v4 and v4:FindFirstChild(v6)
    end
    return v4
end

local function styleFor(v7) -- line 36 | captures: FloatingIconConfig
    local v8 = table.clone(FloatingIconConfig.Styles.AnimalTile)
    for v9, v10 in v7.StyleOverrides do
        v8[v9] = v10
    end
    return v8
end

local function bindTile(v11, v12, v13) -- line 44 | captures: FloatingIconFX
    v11:SetAttribute("HoverScale", 1)
    v11:SetAttribute("PressScale", 1)
    if v12.ClipTiles then
        v11.ClipsDescendants = true
    end
    local v14 = v11:FindFirstChild(v12.Display)
    if v14 and v14:IsA("GuiObject") then
        FloatingIconFX.Attach(v14, v13, v11)
    end
end

local function bind(v15) -- line 59 | captures: AnimalDisplayTilesConfig, FloatingIconConfig, bindTile
    for v16, v17 in AnimalDisplayTilesConfig.Targets do
        local v18 = v15
        for v19, v20 in v17.Path do
            v18 = v18 and v18:FindFirstChild(v20)
        end
        if v18 then
            local v21 = table.clone(FloatingIconConfig.Styles.AnimalTile)
            for v22, v23 in v17.StyleOverrides do
                v21[v22] = v23
            end
            for v24, v25 in v18:GetChildren() do
                if v25:IsA("GuiButton") and string.match(v25.Name, v17.Tile) then
                    bindTile(v25, v17, v21)
                end
            end
        else
            warn((("[AnimalDisplayTilesController] missing MainGUI.%*"):format((table.concat(v17.Path, ".")))))
        end
    end
end

function v1.Start() -- line 75 | captures: MainGui, bind
    MainGui.Observe(bind)
end

return v1
