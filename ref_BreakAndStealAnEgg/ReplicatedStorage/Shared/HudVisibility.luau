-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}

v1.__index = v1

function v1.new() -- line 19 | captures: v1
    local v2 = {
        hidden = {}
    }
    return (setmetatable(v2, v1))
end

local function Hide(v3, v4) -- line 25
    if v4 and v3.hidden[v4] == nil then
        v3.hidden[v4] = v4.Visible
        v4.Visible = false
    end
end

v1.Hide = Hide

local function HideChildren(v5, v6, v7) -- line 35
    if v6 then
        for v8, v9 in v7 do
            local v10 = v6:FindFirstChild(v9)
            if v10 and v10:IsA("GuiObject") then
                v5:Hide(v10)
            end
        end
    end
end

v1.HideChildren = HideChildren

local function RestoreAll(v11) -- line 52
    for v12, v13 in v11.hidden do
        v12.Visible = v13
    end
    table.clear(v11.hidden)
end

v1.RestoreAll = RestoreAll
return v1
