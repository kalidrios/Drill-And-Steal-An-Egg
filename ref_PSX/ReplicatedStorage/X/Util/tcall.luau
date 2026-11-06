-- https://github.com/kalidrios

local m_math_helper = require(script.Parent.math_helper);
return function(p1, p2, ...) -- Line: 5
	--[[
		Upvalues:
			[1] = m_math_helper
	--]]
	assert(typeof(p1) == "number", "timeout must be a number");
	assert(m_math_helper.isfinite(p1), "timeout must be finite");
	assert(p1 >= 0, "timeout must be positive");
	assert(typeof(p2) == "function", "f must be a function");
	local coroutine_create_ret = coroutine.create(p2);
	local os_clock_ret = os.clock();
	local table_pack_ret = table.pack(coroutine.resume(coroutine_create_ret, ...));
	if not table_pack_ret[1] then
		error(table_pack_ret[2]);
	end
	while true do
		local coroutine_status_ret = coroutine.status(coroutine_create_ret);
		if coroutine_status_ret == "dead" then break end
		if coroutine_status_ret ~= "suspended" then
			coroutine.close(coroutine_create_ret);
			error(string.format("Unexpected coroutine.status: '%s'", coroutine_status_ret));
		end
		if os.clock() - os_clock_ret >= p1 then
			coroutine.close(coroutine_create_ret);
			error("timeout");
		end
		local table_pack_ret2 = table.pack(coroutine.resume(coroutine_create_ret));
		if not table_pack_ret2[1] then
			error(table_pack_ret2[2]);
		end
	end
	return table.unpack(table_pack_ret, 2);
end;
