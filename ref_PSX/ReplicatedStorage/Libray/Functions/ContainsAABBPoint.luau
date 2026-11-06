-- https://github.com/kalidrios

return function(p1, p2) -- Line: 3
	if p2.X < -p1.X or p2.X > p1.X then
		return false;
	end
	if p2.Y < -p1.Y or p2.Y > p1.Y then
		return false;
	end
	if p2.Z < -p1.Z or p2.Z > p1.Z then
		return false;
	end
	return true;
end;
