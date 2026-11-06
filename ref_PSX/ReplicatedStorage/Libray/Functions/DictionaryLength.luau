-- https://github.com/kalidrios

return function(p1) -- Line: 3
	local v1 = 0;
	for _, _ in pairs(p1) do
		v1 = v1 + 1;
	end
	return v1;
end;
