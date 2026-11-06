-- https://github.com/kalidrios

return function(p1) -- Line: 27
	assert(typeof(p1) == "number");
	local v1 = "";
	if p1 ~= p1 then
		return "NaN";
	end
	if p1 == math.huge then
		return "Infinity";
	end
	if p1 == -math.huge then
		return "-Infinity";
	end
	if p1 < 0 then
		v1 = v1 .. "-";
		p1 = -p1;
	end
	p1 = math.round(p1);
	local tostring_ret = tostring(p1);
	local v2 = 1;
	local v3 = #tostring_ret % 3;
	if v3 > 0 then
		v1 = v1 .. tostring_ret:sub(v2, v2 + v3 - 1);
		v2 = v2 + v3;
	end
	while v2 <= #tostring_ret do
		if v2 > 1 then
			v1 = v1 .. ",";
		end
		v1 = v1 .. tostring_ret:sub(v2, v2 + 2);
		v2 = v2 + 3;
	end
	return v1;
end;
