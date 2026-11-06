-- https://github.com/kalidrios

return function(p1) -- Line: 20
	local v1 = os.date("!%X", p1);
	if p1 <= 3600 then
		v1 = v1:sub(4);
	end
	return v1;
end;
