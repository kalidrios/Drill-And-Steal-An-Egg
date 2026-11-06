-- https://github.com/kalidrios

return function(p1, p2) -- Line: 5
	local v1 = 0;
	local v2 = p2.X;
	local v3 = p2.Y;
	local v4 = p2.Z;
	local v5 = 0;
	if p2.X < -p1.X then
		local v6 = v2 + p1.X;
		v1 = v1 + v6 * v6;
		v2 = -p1.X;
	elseif p2.X > p1.X then
		local v9 = v2 - p1.X;
		v1 = v1 + v9 * v9;
		v2 = p1.X;
	else
		v5 = v5 + 1;
	end
	if p2.Y < -p1.Y then
		local v7 = v3 + p1.Y;
		v1 = v1 + v7 * v7;
		v3 = -p1.Y;
	elseif p2.Y > p1.Y then
		local v10 = v3 - p1.Y;
		v1 = v1 + v10 * v10;
		v3 = p1.Y;
	else
		v5 = v5 + 1;
	end
	if p2.Z < -p1.Z then
		local v8 = v4 + p1.Z;
		v1 = v1 + v8 * v8;
		v4 = -p1.Z;
	elseif p2.Z > p1.Z then
		local v11 = v4 - p1.Z;
		v1 = v1 + v11 * v11;
		v4 = p1.Z;
	else
		v5 = v5 + 1;
	end
	return math.sqrt(v1), Vector3.new(v2, v3, v4), v5 >= 3;
end;
