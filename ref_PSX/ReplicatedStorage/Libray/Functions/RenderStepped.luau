-- https://github.com/kalidrios

local RunService = game:GetService("RunService");
return function(p1, p2, p3, p4) -- Line: 5
	--[[
		Upvalues:
			[1] = RunService
	--]]
	assert(typeof(p1) == "function");
	if p2 ~= nil then
		assert(typeof(p2) == "number");
		assert(p2 > 0);
		assert(p2 == p2);
	end
	local table1 = {};
	local u1 = p2 or math.huge;
	local u2 = 0;
	local table2 = {};
	local Connect_ret = nil;
	function table1.Disconnect(_) -- Line: 31
		--[[
			Upvalues:
				[1] = Connect_ret
				[2] = table2
		--]]
		local v1 = Connect_ret;
		if v1 then
			Connect_ret = nil;
			v1:Disconnect();
		end
		local v2 = table2;
		if #v2 > 0 then
			table2 = {};
			for _, val1 in ipairs(v2) do
				val1();
			end
		end
	end
	function table1.IsConnected(_) -- Line: 49
		--[[
			Upvalues:
				[1] = Connect_ret
		--]]
		return Connect_ret ~= nil;
	end
	function table1.Then(p1, p5) -- Line: 53
		--[[
			Upvalues:
				[1] = Connect_ret
				[2] = table2
		--]]
		assert(typeof(p5) == "function");
		if Connect_ret then
			table.insert(table2, p5);
			return p1
		end
		return p5();
	end
	function table1.Wait(p6) -- Line: 65
		while p6:IsConnected() do
			task.wait();
		end
	end
	Connect_ret = RunService.RenderStepped:Connect(function(p7) -- Line: 72
		--[[
			Upvalues:
				[1] = p4
				[2] = u1
				[3] = u2
				[4] = p3
				[5] = p1
				[6] = table1
		--]]
		if not p4 then
			p7 = math.min(p7, u1 - u2);
		end
		u2 = u2 + p7;
		if not p4 then
			u2 = math.min(u2, u1);
		end
		local v3 = p7;
		local v4 = u2;
		if p3 and u1 ~= math.huge then
			v3 = v3 / u1;
			v4 = v4 / u1;
			if not p4 then
				v3 = math.min(v3, 1 - v4);
				v4 = math.min(v4, 1);
			end
		end
		local v5 = p1(v3, v4);
		if v5 or u1 <= u2 then
			table1:Disconnect();
		end
	end);
	return table1;
end;
