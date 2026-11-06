-- https://github.com/kalidrios

return function() -- Line: 3
	local ServerTimeNow = workspace:GetServerTimeNow();
	return DateTime.fromUnixTimestamp(ServerTimeNow):ToUniversalTime().Month;
end;
