-- https://github.com/kalidrios

return function(p1) -- Line: 13
	if typeof(p1) == "table" then
		if #p1 > 0 then
			return true;
		end
		local pairs_ret1, pairs_ret2, pairs_ret3 = pairs(p1);
		local v1, _ = pairs_ret1(pairs_ret2, pairs_ret3);
		if --[[generic for]] v1 then
			return false;
		end
		return true;
	end
	return false;
end;
