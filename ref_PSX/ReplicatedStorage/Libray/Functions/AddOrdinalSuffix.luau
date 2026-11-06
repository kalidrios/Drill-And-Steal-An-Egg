-- https://github.com/kalidrios

return function(p1) -- Line: 3
	local tostring_ret = tostring(p1);
	local sub_ret = tostring_ret:sub(-1);
	local sub_ret2 = tostring_ret:sub(-2, -2);
	if sub_ret == "1" and sub_ret2 ~= "1" then
		return tostring_ret .. "st";
	end
	if sub_ret == "2" and sub_ret2 ~= "1" then
		return tostring_ret .. "nd";
	end
	if sub_ret == "3" and sub_ret2 ~= "1" then
		return tostring_ret .. "rd";
	end
	return tostring_ret .. "th";
end;
