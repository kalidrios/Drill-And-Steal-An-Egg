-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}

v1.__index = v1

local function graphemes(v2) -- line 48
    local v3 = {}
    for v4, v5 in utf8.graphemes(v2) do
        local v6 = string.sub(v2, v4, v5)
        table.insert(v3, v6)
    end
    return v3
end

function v1.new(v7) -- line 56 | captures: v1, graphemes
    local Text = v7.Text
    local v8, v9, v10, v11 = string.match(Text, "^(.-)<font color=\"#?(%x+)\">(.-)</font>(.*)$")
    if not v8 then
        v8 = string.match(Text, "^(.*:%s*)") or ""
        local v12 = #v8 + 1
        v9, v10, v11 = nil, string.sub(Text, v12), ""
    end
    v7.RichText = true
    local v13 = {
        Generation = 0,
        Label = v7,
        Prefix = v8,
        Suffix = v11,
        Shown = graphemes(v10),
        Target = v10
    }
    if not (v9 and #v9 == 6) then
        v13.Color = v7.TextColor3
    else
        v13.Color = Color3.fromHex(v9)
    end
    return (setmetatable(v13, v1))
end

local function Render(v14) -- line 81
    if v14.Label.Parent then
        v14.Label.Text = ("%*<font color=\"#%*\">%*</font>%*"):format(v14.Prefix, v14.Color:ToHex(), table.concat(v14.Shown), v14.Suffix)
    end
end

v1.Render = Render

function v1.Set(v15, v16, v17, v18) -- line 88 | captures: graphemes
    v15.Generation += 1
    local Generation = v15.Generation
    v15.Target = v16
    local v19 = table.concat(v15.Shown)
    if v18 or not v15.Label.Parent then
        v15.Shown = graphemes(v16)
        v15.Color = v17
        v15:Render()
    elseif v19 == v16 then
        v15.Color = v17
        v15:Render()
    else
        task.spawn(function() -- line 107 | captures: v15, v16, v17, Generation, graphemes
            local function alive() -- line 108 | captures: v15, Generation
                if v15.Generation == Generation then
                    return v15.Label.Parent ~= nil
                end
                return false
            end

            while true do
                local v20
                if #v15.Shown > 0 then
                    table.remove(v15.Shown)
                    v15:Render()
                    task.wait(0.035)
                    if v15.Generation == Generation then
                        v20 = v15.Label.Parent ~= nil
                    else
                        v20 = false
                    end
                else
                    break
                end
                if v20 then
                    continue
                end
                return
            end
            task.wait(0.08)
            if v15.Generation == Generation and v15.Label.Parent ~= nil then
                v15.Color = v17
                for v21, v22 in graphemes(v16) do
                    local Shown = v15.Shown
                    table.insert(Shown, v22)
                    v15:Render()
                    task.wait(0.055)
                    if not (v15.Generation == Generation and v15.Label.Parent ~= nil) then
                        return
                    end
                end
            end
        end)
    end
end

return v1
