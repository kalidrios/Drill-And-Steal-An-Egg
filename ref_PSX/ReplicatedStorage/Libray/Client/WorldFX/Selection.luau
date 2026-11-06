-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local __DEBRIS = workspace:WaitForChild("__DEBRIS");
local _ = require(Library.Functions);
return function(p1, p2, p3) -- Line: 34
	--[[
		Upvalues:
			[1] = Assets
			[2] = __DEBRIS
			[3] = RunService
	--]]
	local u1 = p1:IsA("Model") and p1.PrimaryPart or p1;
	local u2 = p2:IsA("Model") and p2.PrimaryPart or p2;
	if not u1 or not u2 then
		return function() -- Line: 43
		end;
	end
	local v1 = p3 or Color3.new(1, 1, 1);
	local bool1 = false;
	local Clone_ret = Assets.Other.Selection:FindFirstChild("DottedLine"):Clone();
	local Clone_ret2 = Assets.Other.Selection:FindFirstChild("SelectionCircle"):Clone();
	local Clone_ret3 = Assets.Other.Selection:FindFirstChild("SelectionCircle"):Clone();
	local Attachment = Clone_ret2:FindFirstChild("Attachment");
	local Attachment2 = Clone_ret3:FindFirstChild("Attachment");
	Clone_ret.Attachment0 = Attachment;
	Clone_ret.Attachment1 = Attachment2;
	Clone_ret.Color = ColorSequence.new(v1);
	Clone_ret2.Decal.Color3 = v1;
	Clone_ret3.Decal.Color3 = v1;
	local math_max_ret = math.max(u1.Size.X, u1.Size.Z);
	local math_max_ret2 = math.max(u2.Size.X, u2.Size.Z);
	Clone_ret2.Size = Vector3.new(math_max_ret + 2, 0.05, math_max_ret + 2);
	Clone_ret3.Size = Vector3.new(math_max_ret2 + 2, 0.05, math_max_ret2 + 2);
	Attachment.Position = Vector3.new(0, 0, -Clone_ret2.Size.Z / 2);
	Attachment2.Position = Vector3.new(0, 0, -Clone_ret3.Size.Z / 2);
	Clone_ret.Parent = Clone_ret2;
	Clone_ret2.Parent = __DEBRIS;
	Clone_ret3.Parent = __DEBRIS;
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 77
		--[[
			Upvalues:
				[1] = bool1
				[2] = u1
				[3] = u2
				[4] = Clone_ret2
				[5] = Clone_ret3
				[6] = Clone_ret
				[7] = RunService
		--]]
		while not bool1 and u1.Parent and u2.Parent and Clone_ret2.Parent and Clone_ret3.Parent and Clone_ret.Parent do
			local __MAP = workspace:WaitForChild("__MAP");
			for index1 = 1, 2 do
				local v4 = index1 == 1 and u1 or u2;
				local v5 = index1 == 1 and Clone_ret2 or Clone_ret3;
				local Ray_new_ret = Ray.new(v4.CFrame.Position, Vector3.new(0, -1, 0).Unit * 300);
				local FindPartOnRayWithWhitelist_ret1, FindPartOnRayWithWhitelist_ret2, _ = workspace:FindPartOnRayWithWhitelist(Ray_new_ret, {__MAP});
				if FindPartOnRayWithWhitelist_ret1 and FindPartOnRayWithWhitelist_ret2 then
					v5.CFrame = CFrame.new(v4.Position.X, FindPartOnRayWithWhitelist_ret2.Y + 0, v4.Position.Z);
				end
			end
			local cf = CFrame.new(Clone_ret2.CFrame.Position, Clone_ret3.CFrame.Position);
			local cf2 = CFrame.new(Clone_ret3.CFrame.Position, Clone_ret2.CFrame.Position);
			local table1 = {cf:ToOrientation()};
			local table2 = {cf2:ToOrientation()};
			local v2 = CFrame.new(cf.Position) * CFrame.fromOrientation(0, table1[2], 0);
			local v3 = CFrame.new(cf2.Position) * CFrame.fromOrientation(0, table2[2], 0);
			Clone_ret2.CFrame = v2;
			Clone_ret3.CFrame = v3;
			RunService.RenderStepped:Wait();
		end
		Clone_ret2:Destroy();
		Clone_ret3:Destroy();
	end);
	coroutine_wrap_ret();
	return function() -- Line: 122
		--[[
			Upvalues:
				[1] = bool1
		--]]
		bool1 = true;
	end;
end;
