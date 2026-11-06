-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

return function(v1) -- line 1
    local Frame = Instance.new("Frame")
    Frame.Name = "SelectionContainer"
    Frame.Visible = false
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "Selection"
    Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame_2.BackgroundTransparency = 1
    Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BorderSizePixel = 0
    Frame_2.Parent = Frame
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "UIStroke"
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 3
    UIStroke.Parent = Frame_2
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Name = "SelectionGradient"
    UIGradient.Parent = UIStroke
    local UICorner = Instance.new("UICorner")
    UICorner:SetAttribute("Collective", "IconCorners")
    UICorner.Name = "UICorner"
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame_2
    local RunService = game:GetService("RunService")
    local GuiService = game:GetService("GuiService")
    local v2 = 1
    Frame_2:GetAttributeChangedSignal("RotationSpeed"):Connect(function() -- line 37 | captures: v2, Frame_2
        v2 = Frame_2:GetAttribute("RotationSpeed")
    end)
    RunService.Heartbeat:Connect(function() -- line 40 | captures: v2, UIGradient, GuiService
        if GuiService.SelectedObject then
            UIGradient.Rotation = os.clock() * v2 * 100 % 360
        end
    end)
    return Frame
end
