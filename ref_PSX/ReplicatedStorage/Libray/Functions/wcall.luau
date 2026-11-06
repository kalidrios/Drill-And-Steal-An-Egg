-- https://github.com/kalidrios

return function(p1, ...) -- Line: 3
	local tostring_ret = nil;
	local tostring_ret2 = nil;
	local table_pack_ret = table.pack(xpcall(p1, function(p2) -- Line: 9
		--[[
			Upvalues:
				[1] = tostring_ret
				[2] = tostring_ret2
		--]]
		tostring_ret = tostring(p2);
		tostring_ret2 = tostring(debug.traceback(nil, 3));
	end, ...));
	if table_pack_ret[1] ~= true then
		warn((("%*\nStack Begin\n%*Stack End"):format(tostring(tostring_ret), (tostring(tostring_ret2)))));
		return false;
	end
	return table.unpack(table_pack_ret);
end;
