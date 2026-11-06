-- https://github.com/kalidrios

return function(p1) -- Line: 3
	return math.min(p1.X, (math.min(p1.Y, p1.Z)));
end;
