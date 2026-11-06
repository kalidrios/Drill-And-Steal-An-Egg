-- https://github.com/kalidrios

return function() -- Line: 18
	local ServerTimeNow = workspace:GetServerTimeNow();
	local ToUniversalTime_ret = DateTime.fromUnixTimestamp(ServerTimeNow + (14 - os.date("!*t").wday) % 7 * 86400):ToUniversalTime();
	local v1 = os.time({
		year = ToUniversalTime_ret.Year,
		month = ToUniversalTime_ret.Month,
		day = ToUniversalTime_ret.Day
	}) + 18000 + 1800;
	if v1 < ServerTimeNow then
		v1 = v1 + 604800;
	end
	return v1 - 3600;
end;
