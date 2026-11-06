-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ Line: 1 ]]
	local SelectionContainer = Instance.new("Frame")

	SelectionContainer.Name = "SelectionContainer"
	SelectionContainer.Visible = false

	local Selection = Instance.new("Frame")

	Selection.Name = "Selection"
	Selection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Selection.BackgroundTransparency = 1
	Selection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Selection.BorderSizePixel = 0
	Selection.Parent = SelectionContainer

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Name = "UIStroke"
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Thickness = 3
	UIStroke.Parent = Selection

	local SelectionGradient = Instance.new("UIGradient")

	SelectionGradient.Name = "SelectionGradient"
	SelectionGradient.Parent = UIStroke

	local UICorner = Instance.new("UICorner")

	UICorner:SetAttribute("Collective", "IconCorners")
	UICorner.Name = "UICorner"
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Selection

	local RunService = game:GetService("RunService")
	local GuiService = game:GetService("GuiService")
	local v1 = 1

	Selection:GetAttributeChangedSignal("RotationSpeed"):Connect(function() --[[ Line: 37 | Upvalues: v1 (ref), Selection (copy) ]]
		v1 = Selection:GetAttribute("RotationSpeed")
	end)
	RunService.Heartbeat:Connect(function() --[[ Line: 40 | Upvalues: GuiService (copy), SelectionGradient (copy), v1 (ref) ]]
		if GuiService.SelectedObject then
			SelectionGradient.Rotation = os.clock() * v1 * 100 % 360
		end
	end)

	return SelectionContainer
end