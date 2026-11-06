-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DemonEventUIConfig = require(ReplicatedStorage.Shared.DemonEventUIConfig)
local ShopAnimalInfo = require(script.Parent.Parent.ShopAnimalInfo)
local v1 = {}

local function renderButtonOf(v2) -- line 27 | captures: DemonEventUIConfig
    for v3, v4 in v2:GetDescendants() do
        if v4:IsA("GuiButton") and v4.Name == DemonEventUIConfig.LAYER_NAME then
            return v4
        end
    end
    return nil
end

function v1.bind(v5) -- line 37 | captures: DemonEventUIConfig, ShopAnimalInfo, renderButtonOf
    local function v6(v7, ...)
        table.insert(v7, ...)
    end

    local v8 = v5:WaitForChild("Main", 10)
    local v9 = v8 and v8:FindFirstChild("EggTab")
    local v10, v11
    if v9 then
        v10 = v9:FindFirstChild("ItemList")
        if v9:IsA("GuiObject") and v10 then
            local v12 = v9:FindFirstChild(DemonEventUIConfig.ANIMAL_INFO_NAME)
            if v12 and v12:IsA("GuiObject") then
                v12.Visible = false
            end
            v11 = false
        else
            v11 = true
        end
    else
        v10 = v9
        v11 = true
    end
    if not v11 then
        local v13 = {}
        for v14, v15 in v10:GetChildren() do
            if v15:IsA("GuiObject") then
                local v16 = v15:GetAttribute(DemonEventUIConfig.ANIMAL_ATTRIBUTE)
                if typeof(v16) == "string" then
                    local v17 = renderButtonOf(v15)
                    local v18 = v17 or v15
                    local v19 = if v17 then { v15 } else nil
                    v6(v13, ShopAnimalInfo.Bind(v18, v16, v9, v19))
                end
            end
        end
        local v20 = v5:GetAttributeChangedSignal("Open"):Connect(function() -- line 70 | captures: v5, ShopAnimalInfo
            if v5:GetAttribute("Open") ~= true then
                ShopAnimalInfo.Hide()
            end
        end)
        return function() -- line 76 | captures: v13, v20
            v20:Disconnect()
            for v21, v22 in v13 do
                v22()
            end
            table.clear(v13)
        end
    end
    warn("[AnimalInfo] missing Main.EggTab.ItemList")
    return function() -- line 43
    end
end

return v1
