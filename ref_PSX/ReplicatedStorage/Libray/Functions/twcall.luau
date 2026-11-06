-- https://github.com/kalidrios

return function(p1, p2, ...) -- Line: 3
	local tostring_ret = nil;
	local tostring_ret2 = nil;
	local table_pack_ret = nil;
	local function v1(...) -- Anonymous function at line 11
		--[[
			Upvalues:
				[1] = table_pack_ret
				[2] = p2
				[3] = tostring_ret
				[4] = tostring_ret2
		--]]
		table_pack_ret = table.pack(xpcall(p2, function(p3) -- Line: 12
			--[[
				Upvalues:
					[1] = tostring_ret
					[2] = tostring_ret2
			--]]
			tostring_ret = tostring(p3);
			tostring_ret2 = tostring(debug.traceback(nil, 3));
		end, ...));
	end
	local coroutine_create_ret = coroutine.create(v1);
	local os_clock_ret = os.clock();
	local table_pack_ret2 = table.pack(coroutine.resume(coroutine_create_ret, ...));
	if not table_pack_ret2[1] then
		error(table.unpack(table_pack_ret2, 2));
	end
	while true do
		local coroutine_status_ret = coroutine.status(coroutine_create_ret);
		if table_pack_ret then
			if coroutine_status_ret == "dead" then break end
			local table_pack_ret4 = table.pack(coroutine.resume(coroutine_create_ret));
			coroutine.close(coroutine_create_ret);
			if table_pack_ret4[1] == true then break end
			error(table.unpack(table_pack_ret4, 2));
			break;
		end
		if coroutine_status_ret == "dead" then
			local table_pack_ret3 = table.pack(coroutine.resume(coroutine_create_ret));
			coroutine.close(coroutine_create_ret);
			if table_pack_ret3[1] ~= true then
				error(table.unpack(table_pack_ret3, 2));
			end
			error("died");
		end
		if os.clock() - os_clock_ret >= p1 then
			coroutine.close(coroutine_create_ret);
			return false;
		end
		task.wait();
	end
	coroutine.close(coroutine_create_ret);
	if table_pack_ret[1] ~= true then
		warn((("%*\nStack Begin\n%*Stack End"):format(tostring(tostring_ret), (tostring(tostring_ret2)))));
		return false;
	end
	return table.unpack(table_pack_ret);
end;
