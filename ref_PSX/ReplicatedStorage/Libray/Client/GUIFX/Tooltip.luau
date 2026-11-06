-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TextService = game:GetService("TextService");
local RunService = game:GetService("RunService");
local m_Variables = require(ReplicatedStorage:WaitForChild("Library").Variables);
local t_PlayerGui = Players.LocalPlayer.PlayerGui;
return function(p1, p2) -- Line: 36
	--[[
		Upvalues:
			[1] = m_Variables
			[2] = t_PlayerGui
			[3] = TextService
			[4] = Players
			[5] = RunService
	--]]
	if m_Variables.Mobile then
		return function() -- Line: 39
		end;
	end
	local table1 = {};
	local TextLabel = nil;
	local bool1 = nil;
	local u1 = t_PlayerGui:FindFirstChild("TooltipsFolder");
	if u1 == nil then
		u1 = Instance.new("ScreenGui");
		u1.Name = "TooltipsFolder";
		u1.DisplayOrder = 999;
		u1.Parent = t_PlayerGui;
	end
	local function Remove() -- Line: 57
		--[[
			Upvalues:
				[1] = TextLabel
		--]]
		if TextLabel then
			TextLabel:Destroy();
		end
	end
	local function Create() -- Line: 64
		--[[
			Upvalues:
				[1] = u1
				[2] = TextLabel
				[3] = p2
				[4] = TextService
				[5] = bool1
				[6] = p1
				[7] = m_Variables
				[8] = Players
				[9] = RunService
		--]]
		u1:ClearAllChildren();
		TextLabel = Instance.new("TextLabel");
		TextLabel.BorderSizePixel = 0;
		TextLabel.BackgroundColor3 = Color3.new(0.35, 0.35, 0.35);
		TextLabel.TextColor3 = Color3.new(1, 1, 1);
		TextLabel.TextSize = 18;
		TextLabel.Font = Enum.Font.FredokaOne;
		TextLabel.Text = p2;
		local UICorner = Instance.new("UICorner");
		UICorner.CornerRadius = UDim.new(1, 0);
		UICorner.Parent = TextLabel;
		local TextSize = TextService:GetTextSize(TextLabel.Text, TextLabel.TextSize, TextLabel.Font, Vector2.new(1000, 1000));
		TextLabel.Size = UDim2.new(0, TextSize.X + 14, 0, TextSize.Y + 8);
		TextLabel.Parent = u1;
		while not bool1 and TextLabel and TextLabel.Parent and p1 and not m_Variables.Mobile do
			local Mouse = Players.LocalPlayer:GetMouse();
			local t_X = Mouse.X;
			local t_Y = Mouse.Y;
			local t_X2 = p1.AbsoluteSize.X;
			local t_Y2 = p1.AbsoluteSize.Y;
			local t_X3 = p1.AbsolutePosition.X;
			local t_Y3 = p1.AbsolutePosition.Y;
			if t_X3 - 10 < t_X and t_X < t_X3 + t_X2 + 10 and t_Y3 - 10 < t_Y and t_Y < t_Y3 + t_Y2 + 10 then
				TextLabel.Position = UDim2.new(0, Mouse.X + 17, 0, Mouse.Y);
			else
				bool1 = true;
			end
			RunService.RenderStepped:Wait();
		end
		if TextLabel then
			TextLabel:Destroy();
		end
	end
	table1[#table1 + 1] = p1.MouseEnter:Connect(function() -- Line: 118
		--[[
			Upvalues:
				[1] = TextLabel
				[2] = Create
		--]]
		if TextLabel then
			TextLabel:Destroy();
		end
		Create();
	end);
	table1[#table1 + 1] = p1.MouseLeave:Connect(function() -- Line: 124
		--[[
			Upvalues:
				[1] = TextLabel
		--]]
		if TextLabel then
			TextLabel:Destroy();
		end
	end);
	return function() -- Line: 130
		--[[
			Upvalues:
				[1] = table1
				[2] = bool1
		--]]
		for _, val1 in ipairs(table1) do
			val1:Disconnect();
		end
		table1 = {};
		bool1 = true;
	end;
end;
