-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local m_Functions = require(Library.Functions);
local Random_new_ret = Random.new();
return function(p1, p2) -- Line: 27
	--[[
		Upvalues:
			[1] = Assets
			[2] = Random_new_ret
			[3] = m_Functions
	--]]
	local u1 = p2 or 1;
	local u2 = p1:FindFirstAncestorOfClass("ScreenGui") or p1:FindFirstAncestorOfClass("BillboardGui") or p1:FindFirstAncestorOfClass("SurfaceGui");
	if not u2 then
		warn("Must be parented first");
		return function() -- Line: 33
		end;
	end
	assert(u2);
	local function Sparkle() -- Line: 37
		--[[
			Upvalues:
				[1] = Assets
				[2] = Random_new_ret
				[3] = p1
				[4] = u1
				[5] = m_Functions
		--]]
		local Clone_ret = Assets.UI.FRAMEWORK.GUIFX.Sparkle:Clone();
		Clone_ret.Position = UDim2.new(Random_new_ret:NextNumber(), 0, Random_new_ret:NextNumber(), 0);
		Clone_ret.Size = UDim2.new(0, 0, 0, 0);
		Clone_ret.ZIndex = 99;
		Clone_ret.Parent = p1;
		local NextNumber_ret = Random_new_ret:NextNumber(u1 * 0.15, u1 * 0.2);
		m_Functions.Tween(Clone_ret, {Size = UDim2.new(NextNumber_ret, 0, NextNumber_ret, 0)}, {
			Random_new_ret:NextNumber(0.75, 1),
			"Quad",
			"Out"
		}).Completed:Connect(function() -- Line: 47
			--[[
				Upvalues:
					[1] = m_Functions
					[2] = Clone_ret
					[3] = Random_new_ret
			--]]
			m_Functions.Tween(Clone_ret, {Size = UDim2.new(0, 0, 0, 0)}, {
				Random_new_ret:NextNumber(1.75, 2.5),
				"Sine",
				"InOut"
			}).Completed:Wait();
			Clone_ret:Destroy();
		end);
	end
	local bool1 = false;
	task.spawn(function() -- Line: 56
		--[[
			Upvalues:
				[1] = bool1
				[2] = p1
				[3] = u2
				[4] = Sparkle
				[5] = Random_new_ret
		--]]
		while not bool1 and p1 and p1.Parent do
			if u2.Enabled then
				Sparkle();
			end
			wait(Random_new_ret:NextNumber(1, 2.5));
		end
	end);
	return function() -- Line: 65
		--[[
			Upvalues:
				[1] = bool1
		--]]
		bool1 = true;
	end;
end;
