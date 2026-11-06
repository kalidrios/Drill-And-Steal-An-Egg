-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local m_Functions = require(ReplicatedStorage:WaitForChild("Library").Functions);
local m_GetHolder = require(script.Parent.GetHolder);
return function(p1, p2, p3, p4) -- Line: 35
	--[[
		Upvalues:
			[1] = m_GetHolder
			[2] = m_Functions
	--]]
	local v1 = p3 or 1;
	local v2 = p2 or "";
	local v3 = p4 or 1;
	local v4 = m_GetHolder();
	local v5 = p1 + UDim2.new(0, 0, 0, -(game.Workspace.CurrentCamera.ViewportSize.Y / 5) * v3);
	local TextLabel = Instance.new("TextLabel");
	TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
	TextLabel.Position = p1;
	TextLabel.Size = UDim2.new(0, 250, 0, 250);
	TextLabel.BackgroundTransparency = 1;
	TextLabel.BorderSizePixel = 0;
	TextLabel.TextColor3 = Color3.new(1, 1, 1);
	TextLabel.TextStrokeTransparency = 0.5;
	TextLabel.Text = v2;
	TextLabel.Name = "Floating Text";
	TextLabel.Font = Enum.Font.GothamBold;
	TextLabel.TextSize = 20;
	TextLabel.Parent = v4;
	local v6 = m_Functions.Tween(TextLabel, {
		TextTransparency = 1,
		TextStrokeTransparency = 1,
		Position = v5
	}, {v1});
	m_Functions.AddDebris(TextLabel, 5);
	v6.Completed:Connect(function() -- Line: 66
		--[[
			Upvalues:
				[1] = TextLabel
		--]]
		TextLabel:Destroy();
	end);
	return TextLabel;
end;
