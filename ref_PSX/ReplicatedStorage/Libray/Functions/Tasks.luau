-- https://github.com/kalidrios

return function() -- Line: 3
	local table1 = {};
	local table2 = {};
	function table1.track(p1) -- Anonymous function at line 8
		--[[
			Upvalues:
				[1] = table2
		--]]
		table2[p1] = true;
	end
	function table1.cleanup() -- Anonymous function at line 12
		--[[
			Upvalues:
				[1] = table2
		--]]
		for key1, _ in pairs(table2) do
			if coroutine.status(key1) ~= "dead" then continue end
			table2[key1] = nil;
		end
	end
	function table1.spawn(p2, ...) -- Anonymous function at line 20
		--[[
			Upvalues:
				[1] = table1
		--]]
		table1.track(task.spawn(p2, ...));
	end
	function table1.defer(p3, ...) -- Anonymous function at line 24
		--[[
			Upvalues:
				[1] = table1
		--]]
		table1.track(task.defer(p3, ...));
	end
	function table1.delay(p4, p5, ...) -- Anonymous function at line 28
		--[[
			Upvalues:
				[1] = table1
		--]]
		table1.track(task.delay(p4, p5, ...));
	end
	function table1.isDone() -- Anonymous function at line 32
		--[[
			Upvalues:
				[1] = table2
		--]]
		for key2, _ in pairs(table2) do
			if coroutine.status(key2) == "dead" then continue end
			return false;
		end
		return true;
	end
	function table1.wait() -- Anonymous function at line 41
		--[[
			Upvalues:
				[1] = table1
		--]]
		while not table1.isDone() do
			task.wait();
		end
	end
	function table1.waitFor(p6) -- Anonymous function at line 47
		--[[
			Upvalues:
				[1] = table1
		--]]
		local os_clock_ret = os.clock();
		while true do
			if not table1.isDone() then
				if os.clock() - os_clock_ret >= p6 then
					return false;
				end
				task.wait();
				continue;
			end
			return true;
		end
	end
	return table1;
end;
