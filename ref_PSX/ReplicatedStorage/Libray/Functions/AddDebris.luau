-- https://github.com/kalidrios

local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local X = ReplicatedStorage:WaitForChild("X");
local u1 = require(X:WaitForChild("Util").LeftistHeap).new(function(p4, p5) -- Line: 11
	return p4 - p5;
end);
local table1 = {};
local u2 = 0;
game:GetService("RunService").Stepped:Connect(function(_, p1) -- Line: 16
	--[[
		Upvalues:
			[1] = u2
			[2] = u1
			[3] = table1
			[4] = Debris
	--]]
	debug.profilebegin("AddDebris.Stepped");
	u2 = u2 + p1;
	while true do
		local v4, v5 = u1.tryMin();
		if not v4 or u2 < v5 then break end
		u1.popFast();
		local v6 = table1[v5];
		if v6 then
			for _, val1 in ipairs(v6) do
				if not val1 then continue end
				pcall(function() -- Line: 30
					--[[
						Upvalues:
							[1] = Debris
							[2] = val1
					--]]
					Debris:AddItem(val1, 0);
				end);
			end
		end
	end
	debug.profileend();
end);
return function(p2, p3) -- Line: 39
	--[[
		Upvalues:
			[1] = u2
			[2] = table1
			[3] = u1
	--]]
	assert(typeof(p2) == "Instance");
	local v1 = 0;
	if p3 ~= nil then
		assert(typeof(p3) == "number");
		assert(p3 == p3);
		v1 = math.max(0, p3);
		if v1 == math.huge then return end
	end
	local v2 = u2 + v1;
	local v3 = table1[v2];
	if v3 then
		table.insert(v3, p2);
		return;
	end
	local table2 = {p2};
	table1[v2] = table2;
	u1.insert(v2);
end;
