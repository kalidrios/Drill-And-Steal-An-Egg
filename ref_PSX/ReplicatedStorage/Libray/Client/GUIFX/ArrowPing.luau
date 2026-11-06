-- Decompiled with Synapse X v3.0 | https://github.com/synllc

local RunService = game:GetService("RunService");
local table1 = {
	Frequency = 1,
	Amplitude = 6,
	Distance = 5
};
return function(p1, p2) -- Line: 17
	--[[
		Upvalues:
			[1] = table1
			[2] = RunService
	--]]
	if not p1:IsA("GuiButton") then return end
	p2 = p2 or "ABOVE";
	local vec2 = nil;
	local u1 = nil;
	local u2 = nil;
	local num1 = nil;
	if p2 == "ABOVE" then
		vec2 = Vector2.new(0.5, 1);
		num1 = 0;
		function u2() -- Anonymous function at line 29
			--[[
				Upvalues:
					[1] = table1
			--]]
			return Vector2.new(0, -table1.Distance + math.sin(tick() * 2 * math.pi * 1 / table1.Frequency) * table1.Amplitude);
		end
		function u1() -- Anonymous function at line 32
			--[[
				Upvalues:
					[1] = p1
			--]]
			return Vector2.new(p1.AbsolutePosition.X + p1.AbsoluteSize.X / 2, p1.AbsolutePosition.Y - 10);
		end
	elseif p2 == "BELOW" then
		vec2 = Vector2.new(0.5, 0);
		num1 = 180;
		function u2() -- Anonymous function at line 41
			--[[
				Upvalues:
					[1] = table1
			--]]
			return Vector2.new(0, table1.Distance + math.sin(tick() * 2 * math.pi * 1 / table1.Frequency) * table1.Amplitude);
		end
		function u1() -- Anonymous function at line 44
			--[[
				Upvalues:
					[1] = p1
			--]]
			return Vector2.new(p1.AbsolutePosition.X + p1.AbsoluteSize.X / 2, p1.AbsolutePosition.Y + p1.AbsoluteSize.Y + 10);
		end
	elseif p2 == "LEFT" then
		num1 = 270;
		vec2 = Vector2.new(1, 0.5);
		function u2() -- Anonymous function at line 53
			--[[
				Upvalues:
					[1] = table1
			--]]
			return Vector2.new(-table1.Distance + math.sin(tick() * 2 * math.pi * 1 / table1.Frequency) * table1.Amplitude, 0);
		end
		function u1() -- Anonymous function at line 56
			--[[
				Upvalues:
					[1] = p1
			--]]
			return Vector2.new(p1.AbsolutePosition.X - 10, p1.AbsolutePosition.Y + p1.AbsoluteSize.Y / 2);
		end
	elseif p2 == "RIGHT" then
		num1 = 90;
		vec2 = Vector2.new(0, 0.5);
		function u2() -- Anonymous function at line 65
			--[[
				Upvalues:
					[1] = table1
			--]]
			return Vector2.new(table1.Distance + math.sin(tick() * 2 * math.pi * 1 / table1.Frequency) * table1.Amplitude, 0);
		end
		function u1() -- Anonymous function at line 68
			--[[
				Upvalues:
					[1] = p1
			--]]
			return Vector2.new(p1.AbsolutePosition.X + p1.AbsoluteSize.X + 10, p1.AbsolutePosition.Y + p1.AbsoluteSize.Y / 2);
		end
	end
	local TutorialArrowUI = Instance.new("ScreenGui");
	TutorialArrowUI.Name = "TutorialArrowUI";
	TutorialArrowUI.ResetOnSpawn = false;
	TutorialArrowUI.ZIndexBehavior = Enum.ZIndexBehavior.Global;
	TutorialArrowUI.DisplayOrder = 10;
	TutorialArrowUI.Parent = game.Players.LocalPlayer.PlayerGui;
	
	-- Busca o asset TutorialArrow
	local arrowAsset = game.ReplicatedStorage.Assets.UI.TutorialArrow
	local Clone_ret = nil
	
	-- Se for uma Folder, busca o primeiro GuiObject dentro
	if arrowAsset:IsA("Folder") then
		for _, child in ipairs(arrowAsset:GetChildren()) do
			if child:IsA("GuiObject") then
				Clone_ret = child:Clone()
				break
			end
		end
		-- Se não encontrou, tenta criar um ImageLabel básico
		if not Clone_ret then
			Clone_ret = Instance.new("ImageLabel")
			Clone_ret.Size = UDim2.new(0, 50, 0, 50)
			Clone_ret.BackgroundTransparency = 1
			Clone_ret.Image = "rbxassetid://6034818375" -- Seta genérica
		end
	else
		-- Se já for um GuiObject, clona diretamente
		Clone_ret = arrowAsset:Clone()
	end
	
	Clone_ret.AnchorPoint = vec2;
	Clone_ret.Rotation = num1;
	Clone_ret.Parent = TutorialArrowUI;
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 88
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = u1
				[3] = u2
				[4] = RunService
		--]]
		while Clone_ret and Clone_ret.Parent do
			local v1 = u1();
			local v2 = u2();
			Clone_ret.Position = UDim2.new(0, v1.X + v2.X, 0, v1.Y + v2.Y);
			RunService.RenderStepped:Wait();
		end
	end);
	coroutine_wrap_ret();
	local Connect_ret = nil;
	Connect_ret = p1.MouseButton1Down:Connect(function() -- Line: 98
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = TutorialArrowUI
				[3] = Connect_ret
		--]]
		Clone_ret:Destroy();
		TutorialArrowUI:Destroy();
		Connect_ret:Disconnect();
	end);
	return TutorialArrowUI;
end;