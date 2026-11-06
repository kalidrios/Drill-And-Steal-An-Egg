-- https://github.com/kalidrios

local RunService = game:GetService("RunService");
local table1 = {new = function(p1, p2, p3, p4) -- new (Line: 15)
	--[[
		Upvalues:
			[1] = RunService
	--]]
	assert(typeof(p1) == "number");
	assert(typeof(p2) == "number");
	assert(typeof(p3) == "number");
	assert(typeof(p4) == "function");
	local table2 = {};
	local bool1 = false;
	local table3 = {};
	function table2.get(p5, p6, p7, ...) -- Anonymous function at line 32
		--[[
			Upvalues:
				[1] = bool1
				[2] = p1
				[3] = table3
				[4] = p4
		--]]
		assert(p5 ~= nil);
		if p6 ~= nil then
			assert(typeof(p6) == "number");
			assert(p6 == p6);
			assert(p6 >= 0);
		end
		assert(p7 == nil and true or typeof(p7) == "boolean");
		assert(not bool1);
		local v1 = p6 or p1;
		local u2 = table3[p5];
		if not u2 then
			local table4 = {usedTimestamp = os.clock()};
			u2 = table4;
			table3[p5] = table4;
		else
			u2.usedTimestamp = os.clock();
		end
		if not p7 and (not u2.executeTimestamp or os.clock() - u2.executeTimestamp >= v1) then
			if not u2.executing then
				u2.executing = true;
				local os_clock_ret = nil;
				local success, pcall_ret2 = pcall(function(...) -- Line: 71
					--[[
						Upvalues:
							[1] = p4
							[2] = p5
							[3] = os_clock_ret
							[4] = u2
					--]]
					local v3, v4 = p4(p5, ...);
					if v3 then
						os_clock_ret = os.clock();
						assert(os_clock_ret);
						u2.valueTimestamp = os_clock_ret;
						u2.value = v4;
					end
				end, ...);
				if not os_clock_ret then
					os_clock_ret = os.clock();
				end
				assert(os_clock_ret);
				u2.executeTimestamp = os_clock_ret;
				u2.usedTimestamp = os_clock_ret;
				u2.executing = false;
				if not success then
					warn((("[Bank] SmartCache.get(%*, %*, %*, ...) failed: %*"):format(p5, v1, p7, (tostring(pcall_ret2)))));
				end
			else
				repeat
					task.wait();
				until u2.executing;
				u2.usedTimestamp = os.clock();
			end
		end
		return u2.value;
	end
	function table2.clear(p8) -- Anonymous function at line 104
		--[[
			Upvalues:
				[1] = bool1
				[2] = table3
		--]]
		assert(p8 ~= nil);
		assert(not bool1);
		table3[p8] = nil;
	end
	function table2.set(p9, p10, p11) -- Anonymous function at line 115
		--[[
			Upvalues:
				[1] = bool1
				[2] = table3
		--]]
		assert(p9 ~= nil);
		assert(not bool1);
		local os_clock_ret2 = os.clock();
		local v2 = table3[p9];
		if not v2 then
			local table5 = {usedTimestamp = os_clock_ret2};
			v2 = table5;
			table3[p9] = table5;
		else
			v2.usedTimestamp = os_clock_ret2;
		end
		if not p11 then
			v2.executeTimestamp = os_clock_ret2;
			v2.valueTimestamp = os_clock_ret2;
		end
		v2.value = p10;
	end
	function table2.gc() -- Anonymous function at line 144
		--[[
			Upvalues:
				[1] = bool1
				[2] = table3
				[3] = p2
		--]]
		if bool1 then return end
		local os_clock_ret3 = os.clock();
		for key1, val1 in pairs(table3) do
			if val1.executing or p2 > os_clock_ret3 - val1.usedTimestamp then continue end
			table3[key1] = nil;
		end
	end
	local Connect_ret = nil;
	local u1 = math.random() * p3;
	Connect_ret = RunService.Heartbeat:Connect(function(p12) -- Line: 159
		--[[
			Upvalues:
				[1] = bool1
				[2] = Connect_ret
				[3] = u1
				[4] = p3
				[5] = table2
		--]]
		if bool1 then
			if Connect_ret then
				Connect_ret:Disconnect();
			end
			return;
		end
		u1 = u1 + p12;
		if p3 <= u1 then
			u1 = 0;
			table2.gc();
		end
	end);
	function table2.destroy() -- Anonymous function at line 173
		--[[
			Upvalues:
				[1] = bool1
				[2] = Connect_ret
		--]]
		if bool1 then return end
		bool1 = true;
		if Connect_ret then
			Connect_ret:Disconnect();
		end
	end
	return table2;
end};
return table1;
