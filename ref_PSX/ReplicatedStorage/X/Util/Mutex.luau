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
function table1.async(p5, p6) -- Line: 55
	assert(not p5.destroyed);
	local tryLock_ret2 = p5:tryLock();
	if tryLock_ret2 then
		local success2, pcall_ret2_2 = pcall(function() -- Line: 59
			--[[
				Upvalues:
					[1] = p6
			--]]
			p6();
		end);
		p5:unlock(tryLock_ret2);
		if not success2 then
			error(pcall_ret2_2);
		end
	else
		local Connect_ret = nil;
		Connect_ret = p5.event.Event:Connect(function() -- Line: 68
			--[[
				Upvalues:
					[1] = p5
					[2] = Connect_ret
					[3] = p6
			--]]
			local tryLock_ret3 = p5:tryLock();
			if tryLock_ret3 then
				Connect_ret:Disconnect();
				local success, pcall_ret2 = pcall(function() -- Line: 72
					--[[
						Upvalues:
							[1] = p6
					--]]
					p6();
				end);
				p5:unlock(tryLock_ret3);
				if not success then
					error(pcall_ret2);
				end
			end
		end);
	end
end
function table1.unlock(p7, p8) -- Line: 84
	assert(typeof(p8) == "number");
	assert(p8 == p7.lockHolder);
	p7.lockHolder = nil;
	p7.event:Fire();
end
function table1.runLocked(p9, p10, ...) -- Line: 92
	local lock_ret = p9:lock();
	local table_pack_ret = table.pack(pcall(p10));
	p9:unlock(lock_ret);
	return table.unpack(table_pack_ret);
end
function table1.exec(p11, p12, ...) -- Line: 100
	local lock_ret2 = p11:lock();
	local tostring_ret = nil;
	local tostring_ret2 = nil;
	local tostring_ret3 = nil;
	local table_pack_ret2 = table.pack(xpcall(p12, function(p15) -- Line: 106
		--[[
			Upvalues:
				[1] = tostring_ret
				[2] = tostring_ret2
				[3] = tostring_ret3
		--]]
		tostring_ret = tostring(p15);
		tostring_ret2 = tostring(debug.traceback(nil, 3));
		tostring_ret3 = tostring(debug.info(3, "s"));
	end, p11, ...));
	local v1 = table_pack_ret2[1] == true;
	p11:unlock(lock_ret2);
	if not v1 then
		error(string.format("[Mutex] %s\nStack Begin\n%sStack End", tostring(tostring_ret), tostring(tostring_ret2)));
	end
	return select(2, table.unpack(table_pack_ret2));
end
function table1.isDestroyed(p13) -- Line: 122
	return p13.destroyed;
end
function table1.destroy(p14) -- Line: 126
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
