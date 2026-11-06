-- https://github.com/kalidrios

return function(p1) -- Line: 13
	local v1 = 0;
	for index1 = 1, string.len(p1) do
		v1 = v1 + string.byte((string.sub(p1, index1, index1)));
	end
	return v1;
end;
