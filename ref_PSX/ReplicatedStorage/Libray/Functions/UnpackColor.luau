-- https://github.com/kalidrios

return function(p1) -- Line: 3
	assert(#p1 == 3);
	return Color3.new(p1[1], p1[2], p1[3]);
end;
