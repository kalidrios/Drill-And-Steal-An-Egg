-- https://github.com/kalidrios

local table1 = {};
function table1.new(p1) -- Line: 12
	--[[
		Upvalues:
			[1] = table1
	--]]
	assert(p1 == nil and true or typeof(p1) == "boolean");
	local table2 = {
		destroyed = false,
		fired = p1 == true
	};
	local new_mt = setmetatable(table2, {__index = table1});
	return new_mt;
end
function table1.isFired(p2) -- Line: 22
	return p2.fired;
end
function table1.fire(p3) -- Line: 26
	assert(not p3.destroyed);
	if p3.fired then
		return false;
	end
	p3.fired = true;
	local t_event = p3.event;
	if t_event then
		p3.event = nil;
		t_event:Fire();
		t_event:Destroy();
	end
	return true;
end
function table1.await(p4) -- Line: 42
	assert(not p4.destroyed);
	if not p4.fired then
		local v1 = p4.event;
		if not v1 then
			local BindableEvent = Instance.new("BindableEvent");
			p4.event = BindableEvent;
			v1 = BindableEvent;
		end
		while true do
			assert(not p4.destroyed);
			if p4.fired then break end
			v1.Event:Wait();
		end
	end
end
function table1.isDestroyed(p5) -- Line: 62
	return p5.destroyed;
end
function table1.destroy(p6) -- Line: 66
	if p6.destroyed then
		return false;
	end
	p6.destroyed = true;
	local t_event2 = p6.event;
	if t_event2 then
		p6.event = nil;
		t_event2:Destroy();
	end
	return true;
end
return table1;
