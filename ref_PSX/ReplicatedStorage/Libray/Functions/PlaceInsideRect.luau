-- https://github.com/kalidrios

return function(p1, p2) -- Line: 19
	local v1 = p2.Min.X + p2.Width / 2;
	local v2 = p2.Min.Y + p2.Height / 2;
	local v3 = v1;
	local v4 = v2;
	if v1 < p1.Min.X then
		v3 = p1.Min.X;
	elseif p1.Max.X < v1 then
		v3 = p1.Max.X;
	end
	if v2 < p1.Min.Y then
		v4 = p1.Min.Y;
	elseif p1.Max.Y < v2 then
		v4 = p1.Max.Y;
	end
	local v5 = v3 - v1;
	local v6 = v4 - v2;
	return Rect.new(p2.Min.X + v5, p2.Min.Y + v6, p2.Max.X + v5, p2.Max.Y + v6);
end;
