-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local create = require(script.Parent.Parent.Parent.roblox_packages.vide).create
return function() -- line 5 | captures: create
    local v1 = create("UIListLayout")({})
    local v2 = { v1 }
    local v3 = {}

    function v3.row(v4) -- line 10 | captures: v1
        v1.FillDirection = Enum.FillDirection.Vertical
        return v4
    end

    function v3.column(v5) -- line 15 | captures: v1
        v1.FillDirection = Enum.FillDirection.Horizontal
        return v5
    end

    function v3.layout(v6) -- line 20 | captures: v1
        v1.SortOrder = Enum.SortOrder.LayoutOrder
        return v6
    end

    function v3.name(v7) -- line 25 | captures: v1
        v1.SortOrder = Enum.SortOrder.Name
        return v7
    end

    function v3.none(v8, v9) -- line 30 | captures: v1
        if v9 ~= "vertical" then
            v1.HorizontalFlex = Enum.UIFlexAlignment.None
        end
        if v9 ~= "horizontal" then
            v1.VerticalFlex = Enum.UIFlexAlignment.None
        end
        return v8
    end

    function v3.even(v10, v11) -- line 40 | captures: v1
        if v11 ~= "vertical" then
            v1.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly
        end
        if v11 ~= "horizontal" then
            v1.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
        end
        return v10
    end

    function v3.around(v12, v13) -- line 50 | captures: v1
        if v13 ~= "vertical" then
            v1.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
        end
        if v13 ~= "horizontal" then
            v1.VerticalFlex = Enum.UIFlexAlignment.SpaceAround
        end
        return v12
    end

    function v3.between(v14, v15) -- line 60 | captures: v1
        if v15 ~= "vertical" then
            v1.HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
        end
        if v15 ~= "horizontal" then
            v1.VerticalFlex = Enum.UIFlexAlignment.SpaceBetween
        end
        return v14
    end

    function v3.fill(v16, v17) -- line 70 | captures: v1
        if v17 ~= "vertical" then
            v1.HorizontalFlex = Enum.UIFlexAlignment.Fill
        end
        if v17 ~= "horizontal" then
            v1.VerticalFlex = Enum.UIFlexAlignment.Fill
        end
        return v16
    end

    function v3.horizontal(v18, v19) -- line 80 | captures: v1
        local v20
        if v19 == "left" then
            v20 = Enum.HorizontalAlignment.Left
        elseif v19 == "right" then
            v20 = Enum.HorizontalAlignment.Right
        else
            v20 = Enum.HorizontalAlignment.Center
        end
        v1.HorizontalAlignment = v20
        return v18
    end

    function v3.vertical(v21, v22) -- line 88 | captures: v1
        local v23
        if v22 == "top" then
            v23 = Enum.VerticalAlignment.Top
        elseif v22 == "bottom" then
            v23 = Enum.VerticalAlignment.Bottom
        else
            v23 = Enum.VerticalAlignment.Center
        end
        v1.VerticalAlignment = v23
        return v21
    end

    function v3.gap(v24, v25) -- line 96 | captures: v1
        v1.Padding = UDim.new(0, v25)
        return v24
    end

    local v26 = { __index = v3 }
    return (setmetatable(v2, v26))
end
