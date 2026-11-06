-- https://github.com/kalidrios

local table1 = {};
function table1.new() -- Line: 13
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table2 = {
		destroyed = false,
		event = Instance.new("BindableEvent"),
		locked = false,
		counter = 0
	};
	local new_mt = setmetatable(table2, {__index = table1});
	return new_mt;
end
function table1.nextCounter(p1) -- Line: 24
	local t_counter = p1.counter;
	p1.counter = t_counter + 1;
	return t_counter;
end
function table1.getLock(p2) -- Line: 30
	return p2.lockHolder;
end
function table1.tryLock(p3) -- Line: 34
	assert(not p3.destroyed);
	if p3.lockHolder then
		return nil;
	end
	local nextCounter_ret = p3:nextCounter();
	p3.lockHolder = nextCounter_ret;
	return nextCounter_ret;
end
function table1.lock(p4) -- Line: 45
	local tryLock_ret;
	while true do
		tryLock_ret = p4:tryLock();
		if tryLock_ret then break end
		p4.event.Event:Wait();
	end
	return tryLock_ret;
end
function table1.unlock(p5, p6) -- Line: 55
	if p5.destroyed then return end
	assert(typeof(p6) == "number");
	assert(p6 == p5.lockHolder);
	p5.lockHolder = nil;
	p5.event:Fire();
end
function table1.wrun(p7, p8, ...) -- Line: 66
	local lock_ret = p7:lock();
	local tostring_ret = nil;
	local tostring_ret2 = nil;
	local table_pack_ret = table.pack(xpcall(p8, function(p15) -- Line: 75
		--[[
			Upvalues:
				[1] = tostring_ret
				[2] = tostring_ret2
		--]]
		tostring_ret = tostring(p15);
		tostring_ret2 = tostring(debug.traceback(nil, 3));
	end, ...));
	p7:unlock(lock_ret);
	if table_pack_ret[1] ~= true then
		warn((("[Mutex] %*\nStack Begin\n%*Stack End"):format(tostring(tostring_ret), (tostring(tostring_ret2)))));
	end
	return table.unpack(table_pack_ret);
end
function table1.run(p9, p10, ...) -- Line: 89
	local lock_ret2 = p9:lock();
	local tostring_ret3 = nil;
	local tostring_ret4 = nil;
	local table_pack_ret2 = table.pack(xpcall(p10, function(p16) -- Line: 98
		--[[
			Upvalues:
				[1] = tostring_ret3
				[2] = tostring_ret4
		--]]
		tostring_ret3 = tostring(p16);
		tostring_ret4 = tostring(debug.traceback(nil, 3));
	end, ...));
	p9:unlock(lock_ret2);
	if table_pack_ret2[1] ~= true then
		error((("[Mutex] %*\nStack Begin\n%*Stack End"):format(tostring(tostring_ret3), (tostring(tostring_ret4)))));
	end
	return table.unpack(table_pack_ret2, 2);
end
function table1.async(p11, p12, ...) -- Line: 112
	assert(not p11.destroyed);
	task.spawn(function(...) -- Line: 119
		--[[
			Upvalues:
				[1] = p11
				[2] = p12
		--]]
		local lock_ret3 = p11:lock();
		local tostring_ret5 = nil;
		local tostring_ret6 = nil;
		local success = xpcall(p12, function(p17) -- Line: 124
			--[[
				Upvalues:
					[1] = tostring_ret5
					[2] = tostring_ret6
			--]]
			tostring_ret5 = tostring(p17);
			tostring_ret6 = tostring(debug.traceback(nil, 3));
		end, ...);
		p11:unlock(lock_ret3);
		if success ~= true then
			error((("[Mutex] %*\nStack Begin\n%*Stack End"):format(tostring(tostring_ret5), (tostring(tostring_ret6)))));
		end
	end, ...);
end
function table1.isDestroyed(p13) -- Line: 137
	return p13.destroyed;
end
function table1.destroy(p14) -- Line: 141
	if p14.destroyed then
		return false;
	end
	p14.destroyed = true;
	local t_event = p14.event;
	p14.event = nil;
	if t_event then
		t_event:Destroy();
	end
	return true;
end
return table1;
