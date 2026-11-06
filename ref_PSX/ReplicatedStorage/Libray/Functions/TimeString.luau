-- https://github.com/kalidrios

return function(p1, p2) -- Line: 16
	local math_round_ret = math.round(p1 / 60 / 60 / 24 - 0.5);
	local math_round_ret2 = math.round(p1 / 60 / 60 % 24 - 0.5);
	local math_round_ret3 = math.round(p1 / 60 % 60 - 0.5);
	local math_round_ret4 = math.round(p1 % 60);
	if p2 then
		if math_round_ret >= 1 then
			return math_round_ret .. "d";
		end
		if math_round_ret2 >= 1 then
			return math_round_ret2 .. "hr";
		end
		if math_round_ret3 >= 1 then
			return math_round_ret3 .. "m";
		end
		return math_round_ret4 .. "s";
	end
	if math_round_ret >= 1 then
		return math_round_ret .. (math_round_ret > 1 and " Days" or " Day");
	end
	if math_round_ret2 >= 1 then
		return math_round_ret2 .. (math_round_ret2 > 1 and " Hours" or " Hour");
	end
	if math_round_ret3 >= 1 then
		return math_round_ret3 .. (math_round_ret3 > 1 and " Minutes" or " Minute");
	end
	return math_round_ret4 .. (math_round_ret4 > 1 and " Seconds" or " Second");
end;
