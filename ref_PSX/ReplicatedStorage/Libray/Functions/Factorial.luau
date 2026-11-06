-- https://github.com/kalidrios

return function(p1) -- Line: 4
	local v1 = 1;
	for index1 = 2, p1 do
		v1 = v1 * index1;
	end
	return v1;
end;
