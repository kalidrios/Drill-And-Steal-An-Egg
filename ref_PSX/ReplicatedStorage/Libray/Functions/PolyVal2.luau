-- https://github.com/kalidrios

return function(p1, p2) -- Line: 3
	local v1 = Vector2.new();
	for index1 = 1, #p1 do
		v1 = v1 + p1[index1] * p2 ^ (index1 - 1);
	end
	return v1;
end;
