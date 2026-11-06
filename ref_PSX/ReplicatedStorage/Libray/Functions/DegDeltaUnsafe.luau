-- https://github.com/kalidrios

return function(p1, p2) -- Line: 8
	local v1 = p2 - p1;
	if v1 > 180 then
		return v1 - 360;
	end
	if v1 < -180 then
		v1 = v1 + 360;
	end
	return v1;
end;
