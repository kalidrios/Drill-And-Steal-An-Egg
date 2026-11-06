-- https://github.com/kalidrios

return function() -- Line: 19
	local os_time_ret = os.time();
	local v1 = math.floor((os_time_ret - 1617235200) / 604800) * 604800 + 1617235200;
	if tonumber(os.date("%w", os_time_ret)) >= 3 then
		v1 = v1 + 604800;
	end
	return v1;
end;
