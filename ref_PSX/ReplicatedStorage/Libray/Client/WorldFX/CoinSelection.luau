-- Velvet Group's kalidrios @pggondim .gg/pggondim

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local __DEBRIS = workspace:WaitForChild("__DEBRIS");
return function(p1, p2, p3) -- Line: 31
	--[[
		Upvalues:
			[1] = Assets
			[2] = __DEBRIS
			[3] = RunService
	--]]
	local v1 = p3 or Color3.new(1, 1, 1);
	local bool1 = false;
	local Coin = p2:FindFirstChild("Coin");
	if not Coin or Coin:GetAttribute("DisableSelectionCircle") then
		return function() -- Line: 36
		end;
	end
	local bool2 = false;
	local Clone_ret = Assets.Other.Selection:FindFirstChild("DottedLine"):Clone();
	local Clone_ret2 = Assets.Other.Selection:FindFirstChild("SelectionCircle"):Clone();
	local Clone_ret3 = Assets.Other.Selection:FindFirstChild("SelectionCircle"):Clone();
	local Attachment = Clone_ret2:FindFirstChild("Attachment");
	local Attachment2 = Clone_ret3:FindFirstChild("Attachment");
	Clone_ret.Attachment0 = Attachment;
	Clone_ret.Attachment1 = Attachment2;
	Clone_ret.Color = ColorSequence.new(v1);
	Clone_ret2.SurfaceGui.Circle.ImageColor3 = v1;
	Clone_ret3.SurfaceGui.Circle.ImageColor3 = v1;
	local function UpdateCoin() -- Line: 53
		--[[
			Upvalues:
				[1] = p2
				[2] = Coin
				[3] = bool1
		--]]
		if p2 and p2.Parent then
			Coin = p2:FindFirstChild("Coin");
			if Coin then return end
		end
		bool1 = true;
	end
	while true do
		if p2 and p2.Parent then
			Coin = p2:FindFirstChild("Coin");
			if Coin then
				break;
			end
		end
		bool1 = true;
		break;
	end
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 67
		--[[
			Upvalues:
				[1] = bool1
				[2] = p1
				[3] = Coin
				[4] = Clone_ret2
				[5] = Clone_ret3
				[6] = Attachment
				[7] = Attachment2
				[8] = bool2
				[9] = Clone_ret
				[10] = __DEBRIS
				[11] = RunService
				[12] = p2
		--]]
		while not bool1 and p1.Parent do
			local __MAP = game.Workspace:WaitForChild("__MAP");
			for index1 = 1, 2 do
				local v6 = index1 == 1 and p1 or Coin;
				local v7 = index1 == 1 and Clone_ret2 or Clone_ret3;
				local Ray_new_ret = Ray.new(v6.CFrame.Position, Vector3.new(0, -1, 0).Unit * 300);
				local FindPartOnRayWithWhitelist_ret1, FindPartOnRayWithWhitelist_ret2, _ = game.Workspace:FindPartOnRayWithWhitelist(Ray_new_ret, {__MAP});
				if FindPartOnRayWithWhitelist_ret1 and FindPartOnRayWithWhitelist_ret2 then
					v7.CFrame = CFrame.new(v6.Position.X, FindPartOnRayWithWhitelist_ret2.Y + 0, v6.Position.Z);
				end
			end
			local math_max_ret = math.max(p1.Size.X, p1.Size.Z);
			local math_max_ret2 = math.max(Coin.Size.X, Coin.Size.Z);
			Clone_ret2.Size = Vector3.new(math_max_ret + 1.5, 0.05, math_max_ret + 1.5);
			Clone_ret3.Size = Vector3.new(math_max_ret2 + 1.5, 0.05, math_max_ret2 + 1.5);
			Attachment.Position = Vector3.new(0, 0, -Clone_ret2.Size.Z / 2);
			Attachment2.Position = Vector3.new(0, 0, -Clone_ret3.Size.Z / 2);
			local v2 = CFrame.new(Clone_ret2.CFrame.Position, Clone_ret3.CFrame.Position) + Vector3.new(0, 0.025, 0);
			local v3 = CFrame.new(Clone_ret3.CFrame.Position, Clone_ret2.CFrame.Position) + Vector3.new(0, 0.025, 0);
			local table1 = {v2:ToOrientation()};
			local table2 = {v3:ToOrientation()};
			local v4 = CFrame.new(v2.Position) * CFrame.fromOrientation(0, table1[2], 0);
			local v5 = CFrame.new(v3.Position) * CFrame.fromOrientation(0, table2[2], 0);
			Clone_ret2.CFrame = v4;
			Clone_ret3.CFrame = v5;
			if not bool2 then
				bool2 = true;
				Clone_ret.Parent = Clone_ret2;
				Clone_ret2.Parent = __DEBRIS;
				Clone_ret3.Parent = __DEBRIS;
			end
			RunService.RenderStepped:Wait();
			while true do
				if p2 and p2.Parent then
					Coin = p2:FindFirstChild("Coin");
					if Coin then
						break;
					end
				end
				bool1 = true;
				break;
			end
		end
		Clone_ret2:Destroy();
		Clone_ret3:Destroy();
	end);
	coroutine_wrap_ret();
	return function() -- Line: 129
		--[[
			Upvalues:
				[1] = bool1
		--]]
		bool1 = true;
	end;
end;
